Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2D1BF913
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgD3NSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:18:15 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:48596 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbgD3NSO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 09:18:14 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id uk-mta-8-eqYfVa2uOue2i3Uoab9kpQ-1;
 Thu, 30 Apr 2020 14:18:10 +0100
X-MC-Unique: eqYfVa2uOue2i3Uoab9kpQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 30 Apr 2020 14:18:10 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 30 Apr 2020 14:18:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Bonzini' <pbonzini@redhat.com>,
        'Jim Mattson' <jmattson@google.com>
CC:     'LKML' <linux-kernel@vger.kernel.org>,
        'kvm list' <kvm@vger.kernel.org>,
        'Sean Christopherson' <sean.j.christopherson@intel.com>,
        'Joerg Roedel' <joro@8bytes.org>,
        "'everdox@gmail.com'" <everdox@gmail.com>
Subject: RE: [PATCH] KVM: x86: handle wrap around 32-bit address space
Thread-Topic: [PATCH] KVM: x86: handle wrap around 32-bit address space
Thread-Index: AQHWHPQJ/975q5rp/UiOQx/+1A4bJqiPy+vwgAABnFCAAcI2gIAAFr9g
Date:   Thu, 30 Apr 2020 13:18:10 +0000
Message-ID: <47a766451de248718d2a9bec47dda86e@AcuMS.aculab.com>
References: <20200427165917.31799-1-pbonzini@redhat.com>
 <CALMp9eTBs=deSYu1=CMLwZcO8HTpGM2JsgDxvFR1Y220tdUQ3w@mail.gmail.com>
 <c3ac5f4c9e3a412cb57ea02df19dd2d2@AcuMS.aculab.com>
 <91c76eb0edcd4f1a9d5bc541d35f8ade@AcuMS.aculab.com>
 <2f471fbc-99fb-1a85-8f9f-c276c897f518@redhat.com>
In-Reply-To: <2f471fbc-99fb-1a85-8f9f-c276c897f518@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4gU2VudDogMzAgQXBy
aWwgMjAyMCAxMzo0NQ0KPiBPbiAyOS8wNC8yMCAxMDo1NiwgRGF2aWQgTGFpZ2h0IHdyb3RlOg0K
PiA+Pj4+ICsgICAgICAgICAgICAgICBpZiAodW5saWtlbHkoKChyaXAgXiBvcmlnX3JpcCkgPj4g
MzEpID09IDMpICYmICFpc182NF9iaXRfbW9kZSh2Y3B1KSkNCj4gPj4gSXNuJ3QgdGhlIG1vcmUg
b2J2aW91czoNCj4gPj4gCWlmICgoKHJpcCBeIG9yaWdfcmlwKSAmIDF1bGwgPDwgMzIpIC4uLg0K
PiA+PiBlcXVpdmFsZW50Pw0KPiANCj4gVGhpcyBvbmUgd291bGQgbm90IChpdCB3b3VsZCBhbHNv
IGRldGVjdCBjYXJyeSBvbiBoaWdoIG1lbW9yeSBhZGRyZXNzZXMsDQo+IG5vdCBqdXN0IDB4N2Zm
ZmZmZmYgdG8gMHg4MDAwMDAwMCkuLi4NCg0KU28gd2lsbCB0aGUgcHJvcG9zZWQgb25lIGhhbGYg
dGhlIHRpbWUuDQpJZiAob3JpZ19yaXAgJiAxIDw8IDMyKSBpcyB6ZXJvIHRoZSBoaWdoIGJpdHMg
YXJlIGFsbCB1bmNoYW5nZWQNCmFuZCBjYW5jZWwgb3V0Lg0KDQo+ID4gQWN0dWFsbHkgbm90IGV2
ZW4gYmVpbmcgY2xldmVyLCBob3cgYWJvdXQ6DQo+ID4gCWlmIChvcmlnX3JpcCA8ICgxdWxsIDw8
IDMyKSAmJiB1bmxpa2VseShyaXAgPj0gKDF1bGwgPDwgMzIpKSAmJiAuLi4NCj4gDQo+IC4uLiBi
dXQgeWVzIHRoaXMgb25lIHdvdWxkIGJlIGVxdWl2YWxlbnQuDQoNCklmIHN1YiA0RyBhZGRyZXNz
ZXMgYXJlIGxpa2VseSBvbiA2NGJpdCB5b3UgbWF5IHdhbnQgdG8gZG86DQoJaWYgKHVubGlrZWx5
KChyaXAgXiBvcmlnX3JpcCkgJiAoMXVsbCA8PCAzMikpICYmIG9yaWdfcmlwIDwgKDF1bGwgPDwg
MzIpKSAmJiAuLi4NCm9yIHVubGlrZWx5KChyaXAgXiBvcmlnX3JpcCkgPj4gMzIpDQoNCkkgdGhp
bmsgeW91IGFsd2F5cyB3YW50IHVubGlrZWx5KGEpICYmIGIgcmF0aGVyIHRoYW4gdW5saWtlbHko
YSAmJiBiKS4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJh
bWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0
cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

