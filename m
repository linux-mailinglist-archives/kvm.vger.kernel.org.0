Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F017A88C
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 16:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgCEPKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 10:10:12 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:37175 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbgCEPKL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 10:10:11 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-19-dq2hfeTOM-OFX6XMs-OnUQ-1; Thu, 05 Mar 2020 15:10:07 +0000
X-MC-Unique: dq2hfeTOM-OFX6XMs-OnUQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Thu, 5 Mar 2020 15:10:06 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Thu, 5 Mar 2020 15:10:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Paolo Bonzini' <pbonzini@redhat.com>,
        linmiaohe <linmiaohe@huawei.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
Thread-Topic: [PATCH] KVM: x86: small optimization for is_mtrr_mask
 calculation
Thread-Index: AQHV8vtgGziz2VnmdUK2S7OlSyi4eKg6GbLw
Date:   Thu, 5 Mar 2020 15:10:06 +0000
Message-ID: <dc1870b0ea164015b1c1b6bc4d3248fe@AcuMS.aculab.com>
References: <1583376535-27255-1-git-send-email-linmiaohe@huawei.com>
 <2b678644-fcc0-e853-a53c-2651c1f6a327@redhat.com>
In-Reply-To: <2b678644-fcc0-e853-a53c-2651c1f6a327@redhat.com>
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

RnJvbTogUGFvbG8gQm9uemluaQ0KPiBTZW50OiAwNSBNYXJjaCAyMDIwIDE0OjM2DQo+IA0KPiBP
biAwNS8wMy8yMCAwMzo0OCwgbGlubWlhb2hlIHdyb3RlOg0KPiA+IEZyb206IE1pYW9oZSBMaW4g
PGxpbm1pYW9oZUBodWF3ZWkuY29tPg0KPiA+DQo+ID4gV2UgY2FuIGdldCBpc19tdHJyX21hc2sg
YnkgY2FsY3VsYXRpbmcgKG1zciAtIDB4MjAwKSAlIDIgZGlyZWN0bHkuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBNaWFvaGUgTGluIDxsaW5taWFvaGVAaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4g
PiAgYXJjaC94ODYva3ZtL210cnIuYyB8IDQgKystLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2t2bS9tdHJyLmMgYi9hcmNoL3g4Ni9rdm0vbXRyci5jDQo+ID4gaW5kZXggN2YwMDU5YWEz
MGUxLi5hOTg3MDFkOWYyYmYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL210cnIuYw0K
PiA+ICsrKyBiL2FyY2gveDg2L2t2bS9tdHJyLmMNCj4gPiBAQCAtMzQ4LDcgKzM0OCw3IEBAIHN0
YXRpYyB2b2lkIHNldF92YXJfbXRycl9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgbXNy
LCB1NjQgZGF0YSkNCj4gPiAgCWludCBpbmRleCwgaXNfbXRycl9tYXNrOw0KPiA+DQo+ID4gIAlp
bmRleCA9IChtc3IgLSAweDIwMCkgLyAyOw0KPiA+IC0JaXNfbXRycl9tYXNrID0gbXNyIC0gMHgy
MDAgLSAyICogaW5kZXg7DQo+ID4gKwlpc19tdHJyX21hc2sgPSAobXNyIC0gMHgyMDApICUgMjsN
Cj4gPiAgCWN1ciA9ICZtdHJyX3N0YXRlLT52YXJfcmFuZ2VzW2luZGV4XTsNCj4gPg0KPiA+ICAJ
LyogcmVtb3ZlIHRoZSBlbnRyeSBpZiBpdCdzIGluIHRoZSBsaXN0LiAqLw0KPiA+IEBAIC00MjQs
NyArNDI0LDcgQEAgaW50IGt2bV9tdHJyX2dldF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1
MzIgbXNyLCB1NjQgKnBkYXRhKQ0KPiA+ICAJCWludCBpc19tdHJyX21hc2s7DQo+ID4NCj4gPiAg
CQlpbmRleCA9IChtc3IgLSAweDIwMCkgLyAyOw0KPiA+IC0JCWlzX210cnJfbWFzayA9IG1zciAt
IDB4MjAwIC0gMiAqIGluZGV4Ow0KPiA+ICsJCWlzX210cnJfbWFzayA9IChtc3IgLSAweDIwMCkg
JSAyOw0KPiA+ICAJCWlmICghaXNfbXRycl9tYXNrKQ0KPiA+ICAJCQkqcGRhdGEgPSB2Y3B1LT5h
cmNoLm10cnJfc3RhdGUudmFyX3Jhbmdlc1tpbmRleF0uYmFzZTsNCj4gPiAgCQllbHNlDQo+ID4N
Cj4gDQo+IElmIHlvdSdyZSBnb2luZyB0byBkbyB0aGF0LCBtaWdodCBhcyB3ZWxsIHVzZSAiPj4g
MSIgZm9yIGluZGV4IGluc3RlYWQNCj4gb2YgIi8gMiIsIGFuZCAibXNyICYgMSIgZm9yIGlzX210
cnJfbWFzay4NCg0KUHJvdmlkZWQgdGhlIHZhcmlhYmxlcyBhcmUgdW5zaWduZWQgaXQgbWFrZXMg
bGl0dGxlIGRpZmZlcmVuY2UNCndoZXRoZXIgeW91IHVzZSAvICUgb3IgPj4gJi4NCkF0IGxlYXN0
IHdpdGggLyAlIHRoZSB0d28gdmFsdWVzIGFyZSB0aGUgc2FtZS4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

