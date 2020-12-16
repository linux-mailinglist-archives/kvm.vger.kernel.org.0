Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4282DBC68
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 09:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgLPICW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 03:02:22 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2093 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgLPICW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 03:02:22 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4CwncL4gcpzVpnY;
        Wed, 16 Dec 2020 16:00:34 +0800 (CST)
Received: from dggemm751-chm.china.huawei.com (10.1.198.57) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 16 Dec 2020 16:01:37 +0800
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
 dggemm751-chm.china.huawei.com (10.1.198.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Wed, 16 Dec 2020 16:01:37 +0800
Received: from dggpemm000001.china.huawei.com ([7.185.36.245]) by
 dggpemm000001.china.huawei.com ([7.185.36.245]) with mapi id 15.01.1913.007;
 Wed, 16 Dec 2020 16:01:37 +0800
From:   Jiangyifei <jiangyifei@huawei.com>
To:     Anup Patel <anup@brainfault.org>
CC:     Anup Patel <anup.patel@wdc.com>, Atish Patra <atish.patra@wdc.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhanghailiang <zhang.zhanghailiang@huawei.com>,
        KVM General <kvm@vger.kernel.org>,
        yinyipeng <yinyipeng1@huawei.com>,
        "Zhangxiaofeng (F)" <victor.zhangxiaofeng@huawei.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "Wubin (H)" <wu.wubin@huawei.com>,
        "dengkai (A)" <dengkai1@huawei.com>
Subject: RE: [PATCH RFC 0/3] Implement guest time scaling in RISC-V KVM
Thread-Topic: [PATCH RFC 0/3] Implement guest time scaling in RISC-V KVM
Thread-Index: AQHWyW7J7KJ3/h39l0SdrqVdkwzNb6n403kAgACcZuA=
Date:   Wed, 16 Dec 2020 08:01:37 +0000
Message-ID: <70bdbe9c25214e9483950a0a0efb4305@huawei.com>
References: <20201203121839.308-1-jiangyifei@huawei.com>
 <CAAhSdy2zdwfOGFUtakhbeDUJBapz6fWPnQptT7nCdyFMSoLyGg@mail.gmail.com>
In-Reply-To: <CAAhSdy2zdwfOGFUtakhbeDUJBapz6fWPnQptT7nCdyFMSoLyGg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.186.236]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFudXAgUGF0ZWwgW21haWx0
bzphbnVwQGJyYWluZmF1bHQub3JnXQ0KPiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDE2LCAy
MDIwIDI6NDAgUE0NCj4gVG86IEppYW5neWlmZWkgPGppYW5neWlmZWlAaHVhd2VpLmNvbT4NCj4g
Q2M6IEFudXAgUGF0ZWwgPGFudXAucGF0ZWxAd2RjLmNvbT47IEF0aXNoIFBhdHJhIDxhdGlzaC5w
YXRyYUB3ZGMuY29tPjsNCj4gUGF1bCBXYWxtc2xleSA8cGF1bC53YWxtc2xleUBzaWZpdmUuY29t
PjsgUGFsbWVyIERhYmJlbHQNCj4gPHBhbG1lckBkYWJiZWx0LmNvbT47IEFsYmVydCBPdSA8YW91
QGVlY3MuYmVya2VsZXkuZWR1PjsgUGFvbG8gQm9uemluaQ0KPiA8cGJvbnppbmlAcmVkaGF0LmNv
bT47IFpoYW5naGFpbGlhbmcgPHpoYW5nLnpoYW5naGFpbGlhbmdAaHVhd2VpLmNvbT47DQo+IEtW
TSBHZW5lcmFsIDxrdm1Admdlci5rZXJuZWwub3JnPjsgeWlueWlwZW5nIDx5aW55aXBlbmcxQGh1
YXdlaS5jb20+Ow0KPiBaaGFuZ3hpYW9mZW5nIChGKSA8dmljdG9yLnpoYW5neGlhb2ZlbmdAaHVh
d2VpLmNvbT47DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcgTGlzdCA8bGludXgta2Vy
bmVsQHZnZXIua2VybmVsLm9yZz47DQo+IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRlYWQub3JnOyBs
aW51eC1yaXNjdiA8bGludXgtcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9yZz47DQo+IFd1YmluIChI
KSA8d3Uud3ViaW5AaHVhd2VpLmNvbT47IGRlbmdrYWkgKEEpIDxkZW5na2FpMUBodWF3ZWkuY29t
Pg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJGQyAwLzNdIEltcGxlbWVudCBndWVzdCB0aW1lIHNj
YWxpbmcgaW4gUklTQy1WIEtWTQ0KPiANCj4gT24gVGh1LCBEZWMgMywgMjAyMCBhdCA1OjUxIFBN
IFlpZmVpIEppYW5nIDxqaWFuZ3lpZmVpQGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+DQo+ID4gVGhp
cyBzZXJpZXMgaW1wbGVtZW50cyBndWVzdCB0aW1lIHNjYWxpbmcgYmFzZWQgb24gUkRUSU1FIGlu
c3RydWN0aW9uDQo+ID4gZW11bGF0aW9uIHNvIHRoYXQgd2UgY2FuIGFsbG93IG1pZ3JhdGluZyBH
dWVzdC9WTSBhY3Jvc3MgSG9zdHMgd2l0aA0KPiA+IGRpZmZlcmVudCB0aW1lIGZyZXF1ZW5jeS4N
Cj4gPg0KPiA+IFdoeSBub3QgdGhyb3VnaCBwYXJhLXZpcnQuIEZyb20gYXJtJ3MgZXhwZXJpZW5j
ZVsxXSwgcGFyYS12aXJ0DQo+ID4gaW1wbGVtZW50YXRpb24gZG9lc24ndCByZWFsbHkgc29sdmUg
dGhlIHByb2JsZW0gZm9yIHRoZSBmb2xsb3dpbmcgdHdvIG1haW4NCj4gcmVhc29uczoNCj4gPiAt
IFJEVElNRSBub3Qgb25seSBiZSB1c2VkIGluIGxpbnV4LCBidXQgYWxzbyBpbiBmaXJtd2FyZSBh
bmQgdXNlcnNwYWNlLg0KPiA+IC0gSXQgaXMgZGlmZmljdWx0IHRvIGJlIGNvbXBhdGlibGUgd2l0
aCBuZXN0ZWQgdmlydHVhbGl6YXRpb24uDQo+IA0KPiBJIHRoaW5rIHRoaXMgYXBwcm9hY2ggaXMg
cmF0aGVyIGluY29tcGxldGUuIEFsc28sIEkgZG9uJ3Qgc2VlIGhvdyBwYXJhLXZpcnQgdGltZQ0K
PiBzY2FsaW5nIHdpbGwgYmUgZGlmZmljdWx0IGZvciBuZXN0ZWQgdmlydHVhbGl6YXRpb24uDQo+
IA0KPiBJZiB0cmFwLW4tZW11bGF0ZSBUSU1FIENTUiBmb3IgR3Vlc3QgTGludXggdGhlbiBpdCB3
aWxsIGhhdmUgc2lnbmlmaWNhbnQNCj4gcGVyZm9ybWFuY2UgaW1wYWN0IG9mIHN5c3RlbXMgd2hl
cmUgVElNRSBDU1IgaXMgaW1wbGVtZW50ZWQgaW4gSFcuDQo+IA0KPiBCZXN0IGFwcHJvYWNoIHdp
bGwgYmUgdG8gaGF2ZSBWRFNPLXN0eWxlIHBhcmEtdmlydCB0aW1lLXNjYWxlIFNCSSBjYWxscyAo
c2ltaWxhcg0KPiB0byB3aGF0IEtWTSB4ODYgZG9lcykuIElmIHRoZSBHdWVzdCBzb2Z0d2FyZSAo
TGludXgvQm9vdGxvYWRlcikgZG9lcyBub3QNCj4gZW5hYmxlIHBhcmEtdmlydCB0aW1lLXNjYWxp
bmcgdGhlbiB3ZSB0cmFwLW4tZW11bGF0ZSBUSU1FIENTUiAodGhpcyBzZXJpZXMpLg0KPiANCj4g
UGxlYXNlIHByb3Bvc2UgVkRTTy1zdHlsZSBwYXJhLXZpcnQgdGltZS1zY2FsZSBTQkkgY2FsbCBh
bmQgZXhwYW5kIHRoaXMgdGhpcw0KPiBzZXJpZXMgdG8gcHJvdmlkZSBib3RoOg0KPiAxLiBWRFNP
LXN0eWxlIHBhcmEtdmlydCB0aW1lLXNjYWxpbmcNCj4gMi4gVHJhcC1uLWVtdWxhdGlvbiBvZiBU
SU1FIENTUiB3aGVuICMxIGlzIGRpc2FibGVkDQo+IA0KPiBSZWdhcmRzLA0KPiBBbnVwDQo+IA0K
DQpPSywgaXQgc291bmRzIGdvb2QuIFdlIHdpbGwgbG9vayBpbnRvIHRoZSBwYXJhLXZpcnQgdGlt
ZS1zY2FsaW5nIGZvciBtb3JlIGRldGFpbHMuDQoNCllpZmVpDQoNCj4gPg0KPiA+IFsxXSBodHRw
czovL2xvcmUua2VybmVsLm9yZy9wYXRjaHdvcmsvY292ZXIvMTI4ODE1My8NCj4gPg0KPiA+IFlp
ZmVpIEppYW5nICgzKToNCj4gPiAgIFJJU0MtVjogS1ZNOiBDaGFuZ2UgdGhlIG1ldGhvZCBvZiBj
YWxjdWxhdGluZyBjeWNsZXMgdG8gbmFub3NlY29uZHMNCj4gPiAgIFJJU0MtVjogS1ZNOiBTdXBw
b3J0IGR5bmFtaWMgdGltZSBmcmVxdWVuY3kgZnJvbSB1c2Vyc3BhY2UNCj4gPiAgIFJJU0MtVjog
S1ZNOiBJbXBsZW1lbnQgZ3Vlc3QgdGltZSBzY2FsaW5nDQo+ID4NCj4gPiAgYXJjaC9yaXNjdi9p
bmNsdWRlL2FzbS9jc3IuaCAgICAgICAgICAgIHwgIDMgKysNCj4gPiAgYXJjaC9yaXNjdi9pbmNs
dWRlL2FzbS9rdm1fdmNwdV90aW1lci5oIHwgMTMgKysrKystLQ0KPiA+ICBhcmNoL3Jpc2N2L2t2
bS92Y3B1X2V4aXQuYyAgICAgICAgICAgICAgfCAzNSArKysrKysrKysrKysrKysrKw0KPiA+ICBh
cmNoL3Jpc2N2L2t2bS92Y3B1X3RpbWVyLmMgICAgICAgICAgICAgfCA1MQ0KPiArKysrKysrKysr
KysrKysrKysrKysrLS0tDQo+ID4gIDQgZmlsZXMgY2hhbmdlZCwgOTMgaW5zZXJ0aW9ucygrKSwg
OSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IC0tDQo+ID4gMi4xOS4xDQo+ID4NCj4gPg0KPiA+IC0t
DQo+ID4ga3ZtLXJpc2N2IG1haWxpbmcgbGlzdA0KPiA+IGt2bS1yaXNjdkBsaXN0cy5pbmZyYWRl
YWQub3JnDQo+ID4gaHR0cDovL2xpc3RzLmluZnJhZGVhZC5vcmcvbWFpbG1hbi9saXN0aW5mby9r
dm0tcmlzY3YNCg==
