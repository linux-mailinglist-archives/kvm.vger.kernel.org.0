Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF80163BF4
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 05:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgBSEL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 23:11:57 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3017 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726467AbgBSEL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 23:11:57 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id C5A712D56B7C0556EDEF;
        Wed, 19 Feb 2020 12:11:54 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.16]) by
 DGGEMM404-HUB.china.huawei.com ([10.3.20.212]) with mapi id 14.03.0439.000;
 Wed, 19 Feb 2020 12:11:48 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Xu <peterx@redhat.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV5kqezhdNltl9dkyyI6w50CaTlKggTY0AgACgi6D//8BQgIABOXyg
Date:   Wed, 19 Feb 2020 04:11:48 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BAFEBB5@DGGEMM528-MBX.china.huawei.com>
References: <20200218110013.15640-1-jianjay.zhou@huawei.com>
 <24b21aee-e038-bc55-a85e-0f64912e7b89@redhat.com>
 <B2D15215269B544CADD246097EACE7474BAF9BDD@DGGEMM528-MBX.china.huawei.com>
 <20200218172627.GD1408806@xz-x1>
In-Reply-To: <20200218172627.GD1408806@xz-x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGV0ZXIsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIg
WHUgW21haWx0bzpwZXRlcnhAcmVkaGF0LmNvbV0NCj4gU2VudDogV2VkbmVzZGF5LCBGZWJydWFy
eSAxOSwgMjAyMCAxOjI2IEFNDQo+IFRvOiBaaG91amlhbiAoamF5KSA8amlhbmpheS56aG91QGh1
YXdlaS5jb20+DQo+IENjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPjsga3Zt
QHZnZXIua2VybmVsLm9yZzsgd2FuZ3hpbiAoVSkNCj4gPHdhbmd4aW54aW4ud2FuZ0BodWF3ZWku
Y29tPjsgbGluZmVuZyAoTSkgPGxpbmZlbmcyM0BodWF3ZWkuY29tPjsNCj4gSHVhbmd3ZWlkb25n
IChDKSA8d2VpZG9uZy5odWFuZ0BodWF3ZWkuY29tPjsgTGl1amluc29uZyAoUGF1bCkNCj4gPGxp
dS5qaW5zb25nQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIEtWTTogeDg2OiBl
bmFibGUgZGlydHkgbG9nIGdyYWR1YWxseSBpbiBzbWFsbCBjaHVua3MNCj4gDQo+IE9uIFR1ZSwg
RmViIDE4LCAyMDIwIGF0IDAxOjM5OjM2UE0gKzAwMDAsIFpob3VqaWFuIChqYXkpIHdyb3RlOg0K
PiA+IEhpIFBhb2xvLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+
ID4gRnJvbTogUGFvbG8gQm9uemluaSBbbWFpbHRvOnBib256aW5pQHJlZGhhdC5jb21dDQo+ID4g
PiBTZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxOCwgMjAyMCA3OjQwIFBNDQo+ID4gPiBUbzogWmhv
dWppYW4gKGpheSkgPGppYW5qYXkuemhvdUBodWF3ZWkuY29tPjsga3ZtQHZnZXIua2VybmVsLm9y
Zw0KPiA+ID4gQ2M6IHBldGVyeEByZWRoYXQuY29tOyB3YW5neGluIChVKSA8d2FuZ3hpbnhpbi53
YW5nQGh1YXdlaS5jb20+Ow0KPiA+ID4gbGluZmVuZyAoTSkgPGxpbmZlbmcyM0BodWF3ZWkuY29t
PjsgSHVhbmd3ZWlkb25nIChDKQ0KPiA+ID4gPHdlaWRvbmcuaHVhbmdAaHVhd2VpLmNvbT4NCj4g
PiA+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIEtWTTogeDg2OiBlbmFibGUgZGlydHkgbG9nIGdyYWR1
YWxseSBpbiBzbWFsbA0KPiA+ID4gY2h1bmtzDQo+ID4gPg0KPiA+ID4gT24gMTgvMDIvMjAgMTI6
MDAsIEpheSBaaG91IHdyb3RlOg0KPiA+ID4gPiBJdCBjb3VsZCB0YWtlIGt2bS0+bW11X2xvY2sg
Zm9yIGFuIGV4dGVuZGVkIHBlcmlvZCBvZiB0aW1lIHdoZW4NCj4gPiA+ID4gZW5hYmxpbmcgZGly
dHkgbG9nIGZvciB0aGUgZmlyc3QgdGltZS4gVGhlIG1haW4gY29zdCBpcyB0byBjbGVhcg0KPiA+
ID4gPiBhbGwgdGhlIEQtYml0cyBvZiBsYXN0IGxldmVsIFNQVEVzLiBUaGlzIHNpdHVhdGlvbiBj
YW4gYmVuZWZpdA0KPiA+ID4gPiBmcm9tIG1hbnVhbCBkaXJ0eSBsb2cgcHJvdGVjdCBhcyB3ZWxs
LCB3aGljaCBjYW4gcmVkdWNlIHRoZSBtbXVfbG9jaw0KPiB0aW1lIHRha2VuLg0KPiA+ID4gPiBU
aGUgc2VxdWVuY2UgaXMgbGlrZSB0aGlzOg0KPiA+ID4gPg0KPiA+ID4gPiAxLiBTZXQgYWxsIHRo
ZSBiaXRzIG9mIHRoZSBmaXJzdCBkaXJ0eSBiaXRtYXAgdG8gMSB3aGVuIGVuYWJsaW5nDQo+ID4g
PiA+ICAgIGRpcnR5IGxvZyBmb3IgdGhlIGZpcnN0IHRpbWUNCj4gPiA+ID4gMi4gT25seSB3cml0
ZSBwcm90ZWN0IHRoZSBodWdlIHBhZ2VzIDMuIEtWTV9HRVRfRElSVFlfTE9HIHJldHVybnMNCj4g
PiA+ID4gdGhlIGRpcnR5IGJpdG1hcCBpbmZvIDQuDQo+ID4gPiA+IEtWTV9DTEVBUl9ESVJUWV9M
T0cgd2lsbCBjbGVhciBELWJpdCBmb3IgZWFjaCBvZiB0aGUgbGVhZiBsZXZlbA0KPiA+ID4gPiAg
ICBTUFRFcyBncmFkdWFsbHkgaW4gc21hbGwgY2h1bmtzDQo+ID4gPiA+DQo+ID4gPiA+IFVuZGVy
IHRoZSBJbnRlbChSKSBYZW9uKFIpIEdvbGQgNjE1MiBDUFUgQCAyLjEwR0h6IGVudmlyb25tZW50
LCBJDQo+ID4gPiA+IGRpZCBzb21lIHRlc3RzIHdpdGggYSAxMjhHIHdpbmRvd3MgVk0gYW5kIGNv
dW50ZWQgdGhlIHRpbWUgdGFrZW4NCj4gPiA+ID4gb2YgbWVtb3J5X2dsb2JhbF9kaXJ0eV9sb2df
c3RhcnQsIGhlcmUgaXMgdGhlIG51bWJlcnM6DQo+ID4gPiA+DQo+ID4gPiA+IFZNIFNpemUgICAg
ICAgIEJlZm9yZSAgICBBZnRlciBvcHRpbWl6YXRpb24NCj4gPiA+ID4gMTI4RyAgICAgICAgICAg
NDYwbXMgICAgIDEwbXMNCj4gPiA+DQo+ID4gPiBUaGlzIGlzIGEgZ29vZCBpZGVhLCBidXQgY291
bGQgdXNlcnNwYWNlIGV4cGVjdCB0aGUgYml0bWFwIHRvIGJlIDANCj4gPiA+IGZvciBwYWdlcyB0
aGF0IGhhdmVuJ3QgYmVlbiB0b3VjaGVkPw0KPiA+DQo+ID4gVGhlIHVzZXJzcGFjZSBnZXRzIHRo
ZSBiaXRtYXAgaW5mb3JtYXRpb24gb25seSBmcm9tIHRoZSBrZXJuZWwgc2lkZS4NCj4gPiBJdCBk
ZXBlbmRzIG9uIHRoZSBrZXJuZWwgc2lkZSB0byBkaXN0aW5ndWlzaCB3aGV0aGVyIHRoZSBwYWdl
cyBoYXZlDQo+ID4gYmVlbiB0b3VjaGVkIEkgdGhpbmssIHdoaWNoIHVzaW5nIHRoZSBybWFwIHRv
IHRyYXZlcnNlIGZvciBub3cuIEkNCj4gPiBoYXZlbid0IHRoZSBvdGhlciBpZGVhcyB5ZXQsIDot
KA0KPiA+DQo+ID4gQnV0IGV2ZW4gdGhvdWdoIHRoZSB1c2Vyc3BhY2UgZ2V0cyAxIGZvciBwYWdl
cyB0aGF0IGhhdmVuJ3QgYmVlbg0KPiA+IHRvdWNoZWQsIHRoZXNlIHBhZ2VzIHdpbGwgYmUgZmls
dGVyZWQgb3V0IHRvbyBpbiB0aGUga2VybmVsIHNwYWNlDQo+ID4gS1ZNX0NMRUFSX0RJUlRZX0xP
RyBpb2N0bCBwYXRoLCBzaW5jZSB0aGUgcm1hcCBkb2VzIG5vdCBleGlzdCBJIHRoaW5rLg0KPiA+
DQo+ID4gPiBJIHRoaW5rIHRoaXMgc2hvdWxkIGJlIGFkZGVkIGFzIGEgbmV3IGJpdCB0byB0aGUg
S1ZNX0VOQUJMRV9DQVAgZm9yDQo+ID4gPiBLVk1fQ0FQX01BTlVBTF9ESVJUWV9MT0dfUFJPVEVD
VDIuICBUaGF0IGlzOg0KPiA+ID4NCj4gPiA+IC0gaW4ga3ZtX3ZtX2lvY3RsX2NoZWNrX2V4dGVu
c2lvbl9nZW5lcmljLCByZXR1cm4gMyBmb3INCj4gPiA+IEtWTV9DQVBfTUFOVUFMX0RJUlRZX0xP
R19QUk9URUNUMiAoYmV0dGVyOiBkZWZpbmUgdHdvIGNvbnN0YW50cw0KPiA+ID4gS1ZNX0RJUlRZ
X0xPR19NQU5VQUxfUFJPVEVDVCBhcyAxIGFuZA0KPiBLVk1fRElSVFlfTE9HX0lOSVRJQUxMWV9T
RVQgYXMNCj4gPiA+IDIpLg0KPiA+ID4NCj4gPiA+IC0gaW4ga3ZtX3ZtX2lvY3RsX2VuYWJsZV9j
YXBfZ2VuZXJpYywgYWxsb3cgYml0IDAgYW5kIGJpdCAxIGZvcg0KPiA+ID4gY2FwLT5hcmdzWzBd
DQo+ID4gPg0KPiA+ID4gLSBpbiBrdm1fdm1faW9jdGxfZW5hYmxlX2NhcF9nZW5lcmljLCBjaGVj
ayAiaWYNCj4gPiA+ICghKGt2bS0+bWFudWFsX2RpcnR5X2xvZ19wcm90ZWN0ICYgS1ZNX0RJUlRZ
X0xPR19JTklUSUFMTFlfU0VUKSkiLg0KPiA+DQo+ID4gVGhhbmtzIGZvciB0aGUgZGV0YWlscyEg
SSdsbCBhZGQgdGhlbSBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KPiANCj4gSSBhZ3JlZSB3aXRoIFBh
b2xvIHRoYXQgd2UnZCBiZXR0ZXIgaW50cm9kdWNlIGEgbmV3IGJpdCBmb3IgdGhlIGNoYW5nZSwg
YmVjYXVzZQ0KPiB3ZSBkb24ndCBrbm93IHdoZXRoZXIgdXNlcnNwYWNlIGhhcyB0aGUgYXNzdW1w
dGlvbiB3aXRoIGEgemVyb2VkIGRpcnR5DQo+IGJpdG1hcCBhcyBpbml0aWFsIHN0YXRlICh3aGlj
aCBpcyBzdGlsbCBwYXJ0IG9mIHRoZSBrZXJuZWwgQUJJIElJVUMsIGFjdHVhbGx5IHRoYXQNCj4g
Y291bGQgYmUgYSBnb29kIHRoaW5nIGZvciBzb21lIHVzZXJzcGFjZSkuDQo+IA0KPiBBbm90aGVy
IHF1ZXN0aW9uIGlzIHRoYXQgSSBzZWUgeW91IG9ubHkgbW9kaWZpZWQgdGhlIFBNTCBwYXRoLiAg
Q291bGQgdGhpcyBhbHNvDQo+IGJlbmVmaXQgdGhlIHJlc3QgKHNheSwgU1BURSB3cml0ZSBwcm90
ZWN0cyk/DQoNCk9oIEkgbWlzc2VkIHRoZSBvdGhlciBwYXRoLCB0aGFua3MgZm9yIHJlbWluZGlu
ZywgSSdsbCBhZGQgaXQgaW4gVjIuDQoNClJlZ2FyZHMsDQpKYXkgWmhvdQ0KDQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiAtLQ0KPiBQZXRlciBYdQ0KDQo=
