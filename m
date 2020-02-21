Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D73A16799F
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 10:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBUJoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 04:44:07 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:54540 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbgBUJoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 04:44:07 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 9BE3C980763F9391DD23;
        Fri, 21 Feb 2020 17:44:01 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.16]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0439.000;
 Fri, 21 Feb 2020 17:43:53 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV56Y5Alj8LhDzKkeojlXWbxjKp6gj70QAgAAB4gCAAAU2gIABbgYA
Date:   Fri, 21 Feb 2020 09:43:52 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB0653E@DGGEMM528-MBX.china.huawei.com>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220191706.GF2905@xz-x1> <20200220192350.GG3972@linux.intel.com>
 <20200220194229.GB15253@xz-x1>
In-Reply-To: <20200220194229.GB15253@xz-x1>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgWHUgW21haWx0
bzpwZXRlcnhAcmVkaGF0LmNvbV0NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyMSwgMjAyMCAz
OjQyIEFNDQo+IFRvOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0b3BoZXJzb25A
aW50ZWwuY29tPg0KPiBDYzogWmhvdWppYW4gKGpheSkgPGppYW5qYXkuemhvdUBodWF3ZWkuY29t
Pjsga3ZtQHZnZXIua2VybmVsLm9yZzsNCj4gcGJvbnppbmlAcmVkaGF0LmNvbTsgd2FuZ3hpbiAo
VSkgPHdhbmd4aW54aW4ud2FuZ0BodWF3ZWkuY29tPjsNCj4gSHVhbmd3ZWlkb25nIChDKSA8d2Vp
ZG9uZy5odWFuZ0BodWF3ZWkuY29tPjsgTGl1amluc29uZyAoUGF1bCkNCj4gPGxpdS5qaW5zb25n
QGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjJdIEtWTTogeDg2OiBlbmFibGUg
ZGlydHkgbG9nIGdyYWR1YWxseSBpbiBzbWFsbCBjaHVua3MNCj4gDQo+IE9uIFRodSwgRmViIDIw
LCAyMDIwIGF0IDExOjIzOjUwQU0gLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+
ID4gT24gVGh1LCBGZWIgMjAsIDIwMjAgYXQgMDI6MTc6MDZQTSAtMDUwMCwgUGV0ZXIgWHUgd3Jv
dGU6DQo+ID4gPiBPbiBUaHUsIEZlYiAyMCwgMjAyMCBhdCAxMjoyODoyOFBNICswODAwLCBKYXkg
WmhvdSB3cm90ZToNCj4gPiA+ID4gQEAgLTMzNDgsNyArMzM1MiwxNCBAQCBzdGF0aWMgaW50DQo+
IGt2bV92bV9pb2N0bF9lbmFibGVfY2FwX2dlbmVyaWMoc3RydWN0IGt2bSAqa3ZtLA0KPiA+ID4g
PiAgCXN3aXRjaCAoY2FwLT5jYXApIHsNCj4gPiA+ID4gICNpZmRlZiBDT05GSUdfS1ZNX0dFTkVS
SUNfRElSVFlMT0dfUkVBRF9QUk9URUNUDQo+ID4gPiA+ICAJY2FzZSBLVk1fQ0FQX01BTlVBTF9E
SVJUWV9MT0dfUFJPVEVDVDI6DQo+ID4gPiA+IC0JCWlmIChjYXAtPmZsYWdzIHx8IChjYXAtPmFy
Z3NbMF0gJiB+MSkpDQo+ID4gPiA+ICsJCWlmIChjYXAtPmZsYWdzIHx8DQo+ID4gPiA+ICsJCSAg
ICAoY2FwLT5hcmdzWzBdICYgfktWTV9ESVJUWV9MT0dfTUFOVUFMX0NBUFMpIHx8DQo+ID4gPiA+
ICsJCSAgICAvKiBUaGUgY2FwYWJpbGl0eSBvZiBLVk1fRElSVFlfTE9HX0lOSVRJQUxMWV9TRVQN
Cj4gZGVwZW5kcw0KPiA+ID4gPiArCQkgICAgICogb24gS1ZNX0RJUlRZX0xPR19NQU5VQUxfUFJP
VEVDVCwgaXQgc2hvdWxkIG5vdA0KPiBiZQ0KPiA+ID4gPiArCQkgICAgICogc2V0IGluZGl2aWR1
YWxseQ0KPiA+ID4gPiArCQkgICAgICovDQo+ID4gPiA+ICsJCSAgICAoKGNhcC0+YXJnc1swXSAm
IEtWTV9ESVJUWV9MT0dfTUFOVUFMX0NBUFMpID09DQo+ID4gPiA+ICsJCQlLVk1fRElSVFlfTE9H
X0lOSVRJQUxMWV9TRVQpKQ0KPiA+ID4NCj4gPiA+IEhvdyBhYm91dCBzb21ldGhpbmcgZWFzaWVy
IHRvIHJlYWQ/IDopDQo+ID4gPg0KPiA+ID4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2bV9tYWlu
LmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jIGluZGV4DQo+ID4gPiA3MGYwM2NlMGU1YzEuLjlkZmJh
YjJhOTkyOSAxMDA2NDQNCj4gPiA+IC0tLSBhL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gPiA+ICsr
KyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gPiA+IEBAIC0zMzQ4LDcgKzMzNDgsMTAgQEAgc3Rh
dGljIGludA0KPiBrdm1fdm1faW9jdGxfZW5hYmxlX2NhcF9nZW5lcmljKHN0cnVjdCBrdm0gKmt2
bSwNCj4gPiA+ICAgICAgICAgc3dpdGNoIChjYXAtPmNhcCkgew0KPiA+ID4gICNpZmRlZiBDT05G
SUdfS1ZNX0dFTkVSSUNfRElSVFlMT0dfUkVBRF9QUk9URUNUDQo+ID4gPiAgICAgICAgIGNhc2Ug
S1ZNX0NBUF9NQU5VQUxfRElSVFlfTE9HX1BST1RFQ1QyOg0KPiA+ID4gLSAgICAgICAgICAgICAg
IGlmIChjYXAtPmZsYWdzIHx8IChjYXAtPmFyZ3NbMF0gJiB+MSkpDQo+ID4gPiArICAgICAgICAg
ICAgICAgaWYgKGNhcC0+ZmxhZ3MgfHwgKGNhcC0+YXJnc1swXSAmIH4zKSkNCj4gPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ID4gKyAgICAgICAgICAgICAg
IC8qIEFsbG93IDAwLCAwMSwgYW5kIDExLiAqLw0KPiA+ID4gKyAgICAgICAgICAgICAgIGlmIChj
YXAtPmFyZ3NbMF0gPT0gS1ZNX0RJUlRZX0xPR19JTklUSUFMTFlfU0VUKQ0KPiA+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+ID4NCj4gPiBPb2YsICJlYXNpZXIi
IGlzIHN1YmplY3RpdmUgOi0pICBIb3cgYWJvdXQgdGhpcz8NCj4gPg0KPiA+IAljYXNlIEtWTV9D
QVBfTUFOVUFMX0RJUlRZX0xPR19QUk9URUNUMjogew0KPiA+IAkJdTY0IGFsbG93ZWRfb3B0aW9u
cyA9IEtWTV9ESVJUWV9MT0dfTUFOVUFMX1BST1RFQ1Q7DQo+ID4NCj4gPiAJCWlmIChjYXAtPmFy
Z3NbMF0gJiBLVk1fRElSVFlfTE9HX01BTlVBTF9QUk9URUNUKQ0KPiA+IAkJCWFsbG93ZWRfb3B0
aW9ucyA9IEtWTV9ESVJUWV9MT0dfSU5JVElBTExZX1NFVDsNCg0KSSBiZWxpZXZlIHlvdSBtZWFu
DQoNCgkJaWYgKGNhcC0+YXJnc1swXSAmIEtWTV9ESVJUWV9MT0dfTUFOVUFMX1BST1RFQ1QpDQoJ
CQlhbGxvd2VkX29wdGlvbnMgfD0gS1ZNX0RJUlRZX0xPR19JTklUSUFMTFlfU0VUOw0KDQo/DQoN
Cj4gPg0KPiA+IAkJaWYgKGNhcC0+ZmxhZ3MgfHwgKGNhcC0+YXJnc1swXSAmIH5hbGxvd2VkX29w
dGlvbnMpKQ0KPiA+IAkJCXJldHVybiAtRUlOVkFMOw0KPiA+IAkJa3ZtLT5tYW51YWxfZGlydHlf
bG9nX3Byb3RlY3QgPSBjYXAtPmFyZ3NbMF07DQo+ID4gCQlyZXR1cm4gMDsNCj4gPiAJfQ0KPiAN
Cj4gRmluZSBieSBtZSEgKEJ1dCBJIHdvbid0IHRlbGwgSSBzdGlsbCBwcmVmZXIgbWluZSA7KQ0K
DQo6LSkNCg0KDQpSZWdhcmRzLA0KSmF5IFpob3UNCg0KPiANCj4gLS0NCj4gUGV0ZXIgWHUNCg0K
