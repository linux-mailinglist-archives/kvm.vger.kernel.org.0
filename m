Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1841BD798
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgD2IuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 04:50:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:46349 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726345AbgD2IuZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 04:50:25 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-250-ruH5aaJPOy-ZH7BMxoXelQ-1; Wed, 29 Apr 2020 09:50:21 +0100
X-MC-Unique: ruH5aaJPOy-ZH7BMxoXelQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Wed, 29 Apr 2020 09:50:21 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Wed, 29 Apr 2020 09:50:21 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jim Mattson' <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "everdox@gmail.com" <everdox@gmail.com>
Subject: RE: [PATCH] KVM: x86: handle wrap around 32-bit address space
Thread-Topic: [PATCH] KVM: x86: handle wrap around 32-bit address space
Thread-Index: AQHWHPQJ/975q5rp/UiOQx/+1A4bJqiPy+vw
Date:   Wed, 29 Apr 2020 08:50:21 +0000
Message-ID: <c3ac5f4c9e3a412cb57ea02df19dd2d2@AcuMS.aculab.com>
References: <20200427165917.31799-1-pbonzini@redhat.com>
 <CALMp9eTBs=deSYu1=CMLwZcO8HTpGM2JsgDxvFR1Y220tdUQ3w@mail.gmail.com>
In-Reply-To: <CALMp9eTBs=deSYu1=CMLwZcO8HTpGM2JsgDxvFR1Y220tdUQ3w@mail.gmail.com>
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

RnJvbTogSmltIE1hdHRzb24NCj4gU2VudDogMjggQXByaWwgMjAyMCAwMToyOQ0KPiBPbiBNb24s
IEFwciAyNywgMjAyMCBhdCA5OjU5IEFNIFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5j
b20+IHdyb3RlOg0KPiA+DQo+ID4gS1ZNIGlzIG5vdCBoYW5kbGluZyB0aGUgY2FzZSB3aGVyZSBF
SVAgd3JhcHMgYXJvdW5kIHRoZSAzMi1iaXQgYWRkcmVzcw0KPiA+IHNwYWNlICh0aGF0IGlzLCBv
dXRzaWRlIGxvbmcgbW9kZSkuICBUaGlzIGlzIG5lZWRlZCBib3RoIGluIHZteC5jDQo+ID4gYW5k
IGluIGVtdWxhdGUuYy4gIFNWTSB3aXRoIE5SSVBTIGlzIG9rYXksIGJ1dCBpdCBjYW4gc3RpbGwg
cHJpbnQNCj4gPiBhbiBlcnJvciB0byBkbWVzZyBkdWUgdG8gaW50ZWdlciBvdmVyZmxvdy4NCi4u
Lg0KPiA+ICsgICAgICAgICAgICAgICBpZiAodW5saWtlbHkoKChyaXAgXiBvcmlnX3JpcCkgPj4g
MzEpID09IDMpICYmICFpc182NF9iaXRfbW9kZSh2Y3B1KSkNCg0KSXNuJ3QgdGhlIG1vcmUgb2J2
aW91czoNCglpZiAoKChyaXAgXiBvcmlnX3JpcCkgJiAxdWxsIDw8IDMyKSAuLi4NCmVxdWl2YWxl
bnQ/DQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkg
Um9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlv
biBObzogMTM5NzM4NiAoV2FsZXMpDQo=

