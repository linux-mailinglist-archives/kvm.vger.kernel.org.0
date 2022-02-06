Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C883A4AAF86
	for <lists+kvm@lfdr.de>; Sun,  6 Feb 2022 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbiBFNma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Feb 2022 08:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239964AbiBFNm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Feb 2022 08:42:29 -0500
X-Greylist: delayed 8177 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 05:42:27 PST
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60C23C043183
        for <kvm@vger.kernel.org>; Sun,  6 Feb 2022 05:42:27 -0800 (PST)
Received: from BC-Mail-Ex16.internal.baidu.com (unknown [172.31.51.56])
        by Forcepoint Email with ESMTPS id 1D8B49227D940A4670D2;
        Sun,  6 Feb 2022 21:42:15 +0800 (CST)
Received: from BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38) by
 BC-Mail-Ex16.internal.baidu.com (172.31.51.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Sun, 6 Feb 2022 21:42:14 +0800
Received: from BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) by
 BJHW-Mail-Ex15.internal.baidu.com ([100.100.100.38]) with mapi id
 15.01.2308.020; Sun, 6 Feb 2022 21:42:14 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBLVk06IFg4Njogc2V0IHZjcHUgcHJlZW1wdGVkIG9u?=
 =?gb2312?Q?ly_if_it_is_preempted?=
Thread-Topic: [PATCH] KVM: X86: set vcpu preempted only if it is preempted
Thread-Index: AQHYB7WMg7j2vnvXFkKy6dq5PabOWqxfHr2AgABDQICAJyN4QIAAKHmw
Date:   Sun, 6 Feb 2022 13:42:14 +0000
Message-ID: <39f8f0f26c5b453ba61e8c8256955eae@baidu.com>
References: <1641988921-3507-1-git-send-email-lirongqing@baidu.com>
 <Yd7S5rEYZg8v93NX@hirez.programming.kicks-ass.net>
 <Yd8QR2KHDfsekvNg@google.com>
 <20220112213129.GO16608@worktop.programming.kicks-ass.net> 
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.117.122]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiA+IE9uIFdlZCwgSmFuIDEyLCAyMDIyIGF0IDA1OjMwOjQ3UE0gKzAwMDAsIFNlYW4gQ2hyaXN0
b3BoZXJzb24gd3JvdGU6DQo+ID4gPiBPbiBXZWQsIEphbiAxMiwgMjAyMiwgUGV0ZXIgWmlqbHN0
cmEgd3JvdGU6DQo+ID4gPiA+IE9uIFdlZCwgSmFuIDEyLCAyMDIyIGF0IDA4OjAyOjAxUE0gKzA4
MDAsIExpIFJvbmdRaW5nIHdyb3RlOg0KPiA+ID4gPiA+IHZjcHUgY2FuIHNjaGVkdWxlIG91dCB3
aGVuIHJ1biBoYWx0IGluc3RydWN0aW9uLCBhbmQgc2V0IGl0c2VsZg0KPiA+ID4gPiA+IHRvIElO
VEVSUlVQVElCTEUgYW5kIHN3aXRjaCB0byBpZGxlIHRocmVhZCwgdmNwdSBzaG91bGQgbm90IGJl
DQo+ID4gPiA+ID4gc2V0IHByZWVtcHRlZCBmb3IgdGhpcyBjb25kaXRpb24NCj4gPiA+ID4NCj4g
PiA+ID4gVWhobW0sIHdoeSBub3Q/IFdobyBzYXlzIHRoZSB2Y3B1IHdpbGwgcnVuIHRoZSBtb21l
bnQgaXQgYmVjb21lcw0KPiA+ID4gPiBydW5uYWJsZSBhZ2Fpbj8gQW5vdGhlciB0YXNrIGNvdWxk
IGJlIHdva2VuIHVwIG1lYW53aGlsZSBvY2N1cHlpbmcNCj4gPiA+ID4gdGhlIHJlYWwgY3B1Lg0K
PiA+ID4NCj4gPiA+IEhybSwgYnV0IHdoZW4gZW11bGF0aW5nIEhMVCwgZS5nLiBmb3IgYW4gaWRs
aW5nIHZDUFUsIEtWTSB3aWxsDQo+ID4gPiB2b2x1bnRhcmlseSBzY2hlZHVsZSBvdXQgdGhlIHZD
UFUgYW5kIG1hcmsgaXQgYXMgcHJlZW1wdGVkIGZyb20gdGhlDQo+ID4gPiBndWVzdCdzIHBlcnNw
ZWN0aXZlLiAgVGhlIHZhc3QgbWFqb3JpdHksIHByb2JhYmx5IGFsbCwgdXNhZ2Ugb2YNCj4gPiA+
IHN0ZWFsX3RpbWUucHJlZW1wdGVkIGV4cGVjdHMgaXQgdG8gdHJ1bHkgbWVhbiAicHJlZW1wdGVk
IiBhcyBvcHBvc2VkDQo+ID4gPiB0bw0KPiA+ICJub3QgcnVubmluZyIuDQo+ID4NCj4gPiBObywg
dGhlIG9yaWdpbmFsIHVzZS1jYXNlIHdhcyBsb2NraW5nIGFuZCB0aGF0IHJlYWxseSBjYXJlcyBh
Ym91dCBydW5uaW5nLg0KPiA+DQo+ID4gSWYgdGhlIHZDUFUgaXNuJ3QgcnVubmluZywgd2UgbXVz
dCBub3QgYnVzeS13YWl0IGZvciBpdCBldGMuLg0KPiA+DQo+ID4gU2ltaWxhciB0byB0aGUgc2No
ZWR1bGVyIHVzZSBvZiBpdCwgaWYgdGhlIHZDUFUgaXNuJ3QgcnVubmluZywgd2UNCj4gPiBzaG91
bGQgbm90IGNvbnNpZGVyIGl0IHNvLiBHZXR0aW5nIHRoZSB2Q1BVIHRhc2sgc2NoZWR1bGVkIGJh
Y2sgb24gdGhlIENQVSBjYW4NCj4gdGFrZSBhICdsb25nJw0KPiA+IHRpbWUuDQo+ID4NCj4gPiBJ
ZiB5b3UgaGF2ZSBwaW5uZWQgdkNQVSB0aHJlYWRzIGFuZCBubyBvdmVyY29tbWl0LCB3ZSBoYXZl
IG90aGVyIGtub2JzDQo+ID4gdG8gaW5kaWNhdGUgdGhpcyBJIHRpaG5rLg0KPiANCj4gDQo+IElm
IHZjcHUgaXMgaWRsZSwgYW5kIGJlIG1hcmtlZCBhcyBwcmVlbXB0ZWQsIGlzIGl0IHJpZ2h0IGlu
DQo+IGt2bV9zbXBfc2VuZF9jYWxsX2Z1bmNfaXBpPw0KPiANCj4gc3RhdGljIHZvaWQga3ZtX3Nt
cF9zZW5kX2NhbGxfZnVuY19pcGkoY29uc3Qgc3RydWN0IGNwdW1hc2sgKm1hc2spIHsNCj4gICAg
IGludCBjcHU7DQo+IA0KPiAgICAgbmF0aXZlX3NlbmRfY2FsbF9mdW5jX2lwaShtYXNrKTsNCj4g
DQo+ICAgICAvKiBNYWtlIHN1cmUgb3RoZXIgdkNQVXMgZ2V0IGEgY2hhbmNlIHRvIHJ1biBpZiB0
aGV5IG5lZWQgdG8uICovDQo+ICAgICBmb3JfZWFjaF9jcHUoY3B1LCBtYXNrKSB7DQo+ICAgICAg
ICAgaWYgKHZjcHVfaXNfcHJlZW1wdGVkKGNwdSkpIHsNCj4gICAgICAgICAgICAga3ZtX2h5cGVy
Y2FsbDEoS1ZNX0hDX1NDSEVEX1lJRUxELA0KPiBwZXJfY3B1KHg4Nl9jcHVfdG9fYXBpY2lkLCBj
cHUpKTsNCj4gICAgICAgICAgICAgYnJlYWs7DQo+ICAgICAgICAgfQ0KPiAgICAgfQ0KPiB9DQo+
IA0KDQpDaGVjayBpZiB2Y3B1IGlzIGlkbGUgYmVmb3JlIGNoZWNrIHZjcHUgaXMgcHJlZW1wdGVk
Pw0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva2VybmVsL2t2bS5jIGIvYXJjaC94ODYva2VybmVs
L2t2bS5jDQppbmRleCBmZTBhZWFkLi5jMWViZDY5IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva2Vy
bmVsL2t2bS5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwva3ZtLmMNCkBAIC02MTksNyArNjE5LDcg
QEAgc3RhdGljIHZvaWQga3ZtX3NtcF9zZW5kX2NhbGxfZnVuY19pcGkoY29uc3Qgc3RydWN0IGNw
dW1hc2sgKm1hc2spDQoNCiAgICAgICAgLyogTWFrZSBzdXJlIG90aGVyIHZDUFVzIGdldCBhIGNo
YW5jZSB0byBydW4gaWYgdGhleSBuZWVkIHRvLiAqLw0KICAgICAgICBmb3JfZWFjaF9jcHUoY3B1
LCBtYXNrKSB7DQotICAgICAgICAgICAgICAgaWYgKHZjcHVfaXNfcHJlZW1wdGVkKGNwdSkpIHsN
CisgICAgICAgICAgICAgICBpZiAoIWlkbGVfY3B1KGNwdSkgJiYgdmNwdV9pc19wcmVlbXB0ZWQo
Y3B1KSkgew0KICAgICAgICAgICAgICAgICAgICAgICAga3ZtX2h5cGVyY2FsbDEoS1ZNX0hDX1ND
SEVEX1lJRUxELCBwZXJfY3B1KHg4Nl9jcHVfdG9fYXBpY2lkLCBjcHUpKTsNCiAgICAgICAgICAg
ICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgIH0NCg0KDQpTaW1pbGFyIGluIGt2
bV9mbHVzaF90bGJfbXVsdGkoKSA/DQoNCi1MaQ0K
