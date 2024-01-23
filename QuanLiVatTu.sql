drop database if exists mini_test_3;
create database if not exists mini_test_3;

use mini_test_3;

create table material (
material_id int primary key,
material_code varchar(50),
material_name varchar(50),
material_unit varchar(50),
material_price float
);

create table inventory (
inventory_id int primary key,
material_id int,
inventory_number_origin float,
inventory_number_total_imported float,
inventory_number_total_exported float,
foreign key (material_id) references material(material_id)
);

create table supplier (
supplier_id int primary key,
supplier_code varchar(50),
supplier_name varchar(50),
supplier_address varchar(50),
supplier_phone varchar(10)
);

create table `order` (
order_id int primary key ,
order_code varchar(50),
order_date date,
supplier_id int,
foreign key (supplier_id) references supplier(supplier_id)
);

create table order_import (
import_id int primary key,
import_code varchar(50),
import_date date,
order_id int,
foreign key (order_id) references `order`(order_id)
);

create table order_export (
export_id int primary key,
export_code varchar(50),
export_date date,
export_name_customer varchar(50)
);

create table order_detail (
order_detail_id int primary key,
order_id int,
material_id int,
order_number float,
foreign key (order_id) references `order`(order_id),
foreign key (material_id) references material(material_id)
);

create table import_detail (
import_detail_id int primary key,
import_id int,
material_id int,
import_number float,
import_price float,
import_detail_note varchar(50),
foreign key (import_id) references order_import(import_id),
foreign key (material_id) references material(material_id)
);

create table export_detail (
export_detail_id int primary key,
export_id int,
material_id int,
export_number float,
export_price float,
export_detail_note varchar(50),
foreign key (export_id) references order_export(export_id),
foreign key (material_id) references material(material_id)
);

insert into material values
(1,"M1","sắt","kg",100000),
(2,"M2","thép","kg",200000),
(3,"M3","xi măng","tấn",1000000),
(4,"M4","cát","tấn",3300000),
(5,"M5","đồng","kg",100000);

insert into inventory values
(1,1,111.2,23,45),
(2,2,333.2,231,115),
(3,3,444,213,245),
(4,4,333,213,345),
(5,5,114,123,145);

insert into supplier values
(1,"N","Hải Nhật","Quảng Trị",'0111111111'),
(2,"D","Thanh Dụng","Quảng Nam",'0222222222'),
(3,"P","Đăng Pháp","Đà Nẵng",'0333333333');

insert into `order` values
(1,"O1",'2022-11-11',1),
(2,"O2",'2022-10-11',2),
(3,"O3",'2022-11-22',1);

insert into order_import values
(1,"I1",'2022-09-11',1),
(2,"I2",'2022-08-11',3),
(3,"I3",'2022-10-11',2);

insert into order_export values
(1,"E1",'2022-11-22',"dat1"),
(2,"E2",'2022-11-11',"dat2"),
(3,"E3",'2022-12-11',"dat3");

insert into order_detail values
(1,1,1,22),
(2,2,2,21),
(3,3,3,22),
(4,3,5,23),
(5,2,2,24),
(6,3,4,25);

insert into import_detail values
(1,1,1,61.2,90000,"no"),
(2,2,1,4,95000,"no"),
(3,1,2,222,111000,"no"),
(4,3,5,111,115000,"no"),
(5,3,3,112,111000,"no"),
(6,1,2,50,111111,"no");

insert into export_detail values
(1,1,1,44,1100000,"no"),
(2,2,1,42,1200000,"no"),
(3,3,2,34,300000,"no"),
(4,1,3,42,3300000,"no"),
(5,2,2,40,220000,"no"),
(6,3,1,41,2110000,"no");

-- Câu 1. Tạo view có tên vw_CTPNHAP bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP as
select id.import_detail_id, oi.import_code, m.material_code, id.import_number,id.import_price, (id.import_number * id.import_price ) as "money"
from import_detail id
join order_import oi on oi.import_id = id.import_id
join material m on m.material_id = id.material_id;
select * from vw_CTPNHAP;

-- Câu 2. Tạo view có tên vw_CTPNHAP_VT bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT as
select id.import_detail_id, oi.import_code, m.material_code,m.material_name ,id.import_number,id.import_price, (id.import_number * id.import_price ) as "money"
from import_detail id
join order_import oi on oi.import_id = id.import_id
join material m on m.material_id = id.material_id;
select * from vw_CTPNHAP_VT;

-- Câu 3. Tạo view có tên vw_CTPNHAP_VT_PN bao gồm các thông tin sau: số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT_PN as
select id.import_detail_id,oi.import_date, oi.import_code,od.order_number ,m.material_code,m.material_name ,id.import_number,id.import_price, (id.import_number * id.import_price ) as "money"
from import_detail id
join order_import oi on oi.import_id = id.import_id
join material m on m.material_id = id.material_id
join order_detail od on od.material_id = m.material_id;
select * from vw_CTPNHAP_VT_PN;

-- Câu 4. Tạo view có tên vw_CTPNHAP_VT_PN_DH bao gồm các thông tin sau: số phiếu nhập hàng, ngày nhập hàng, số đơn đặt hàng, mã nhà cung cấp, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập.
create view vw_CTPNHAP_VT_PN_DH as
select id.import_detail_id,oi.import_date, oi.import_code,od.order_number, s.supplier_code ,m.material_code,m.material_name ,id.import_number,id.import_price, (id.import_number * id.import_price ) as "money"
from import_detail id
join order_import oi on oi.import_id = id.import_id
join material m on m.material_id = id.material_id
join order_detail od on od.material_id = m.material_id
join `order` o on o.order_id = od.order_id
join supplier s on s.supplier_id = o.supplier_id;
select * from vw_CTPNHAP_VT_PN_DH;

-- Câu 5. Tạo view có tên vw_CTPNHAP_loc  bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập có số lượng nhập > 5.
create view vw_CTPNHAP_loc as
select id.import_detail_id, oi.import_code, m.material_code, id.import_number,id.import_price, (id.import_number * id.import_price ) as "money"
from import_detail id
join order_import oi on oi.import_id = id.import_id
join material m on m.material_id = id.material_id
where id.import_number > 5;
select * from vw_CTPNHAP_loc;

-- Câu 6. Tạo view có tên vw_CTPNHAP_VT_loc bao gồm các thông tin sau: số phiếu nhập hàng, mã vật tư, tên vật tư, số lượng nhập, đơn giá nhập, thành tiền nhập. Và chỉ liệt kê các chi tiết nhập vật tư có đơn vị tính là kg.
create view vw_CTPNHAP_VT_loc as
select id.import_detail_id, oi.import_code, m.material_code,m.material_name ,m.material_unit,id.import_number,id.import_price, (id.import_number * id.import_price ) as "money"
from import_detail id
join order_import oi on oi.import_id = id.import_id
join material m on m.material_id = id.material_id
where m.material_unit like "kg";
select * from vw_CTPNHAP_VT_loc;

-- Câu 7. Tạo view có tên vw_CTPXUAT bao gồm các thông tin sau: số phiếu xuất hàng, mã vật tư, số lượng xuất, đơn giá xuất, thành tiền xuất.
create view vw_CTPXUAT as
select ed.export_detail_id, oe.export_code, m.material_code, ed.export_number,ed.export_price, (ed.export_number * ed.export_price ) as "money"
from export_detail ed
left join order_export oe on oe.export_id = ed.export_id
left join material m on m.material_id = ed.material_id;
select * from vw_CTPXUAT;

-- Câu 8. Tạo view có tên vw_CTPXUAT_VT bao gồm các thông tin sau: số phiếu xuất hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.
create view vw_CTPXUAT_VT as
select ed.export_detail_id, oe.export_code, m.material_code,m.material_name ,ed.export_number,ed.export_price
from export_detail ed
left join order_export oe on oe.export_id = ed.export_id
left join material m on m.material_id = ed.material_id;
select * from vw_CTPXUAT_VT;

-- Câu 9. Tạo view có tên vw_CTPXUAT_VT_PX bao gồm các thông tin sau: số phiếu xuất hàng, tên khách hàng, mã vật tư, tên vật tư, số lượng xuất, đơn giá xuất.
create view vw_CTPXUAT_VT_PX as
select ed.export_detail_id, oe.export_code,oe.export_name_customer, m.material_code,m.material_name ,ed.export_number,ed.export_price
from export_detail ed
left join order_export oe on oe.export_id = ed.export_id
left join material m on m.material_id = ed.material_id;
select * from vw_CTPXUAT_VT_PX;


-- II, Tạo các stored procedure