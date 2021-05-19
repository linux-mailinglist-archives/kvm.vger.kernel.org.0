Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F12388D4F
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 13:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352791AbhESL5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 07:57:11 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:26305 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240448AbhESL5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 07:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621425352; x=1652961352;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=7wOlZ2gzX8M1e1TcLJxy2vcRUtwsLg/oGU7mZHfCpco=;
  b=Di3O54SCXdQjZMrt64GcdQdEJsE1PXSS5uKcJqED560Xv71QLnCrP2Wu
   6/W0ohPnAxKlwMJFTueAhsj/qGAvEuNAFU7K9FW7rMnR/gkqwUChJK8T/
   SH091VKJKVIgFaFbWTn/i3jRbxP6cDbIsL9jH7bZojXSG57GERevd/r8B
   A=;
X-IronPort-AV: E=Sophos;i="5.82,312,1613433600"; 
   d="scan'208";a="108697019"
Subject: Re: [PATCH v2 08/10] KVM: VMX: Set the TSC offset and multiplier on nested
 entry and exit
Thread-Topic: [PATCH v2 08/10] KVM: VMX: Set the TSC offset and multiplier on nested entry
 and exit
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 19 May 2021 11:55:51 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 96BC8A1F72;
        Wed, 19 May 2021 11:55:47 +0000 (UTC)
Received: from EX13D08UEB001.ant.amazon.com (10.43.60.245) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 19 May 2021 11:55:44 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB001.ant.amazon.com (10.43.60.245) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 19 May 2021 11:55:43 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Wed, 19 May 2021 11:55:43 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXR0FPCDaBzFcBrUGdKtsaYHCYIarp94cAgADEW4A=
Date:   Wed, 19 May 2021 11:55:43 +0000
Message-ID: <a506d7cf3cde8c2b258fb6d31088030e2ce171ab.camel@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
         <20210512150945.4591-9-ilstam@amazon.com> <YKRW3EF5NHBlJEOn@google.com>
In-Reply-To: <YKRW3EF5NHBlJEOn@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.148]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D0B452918BD2D468236E29CE8B50089@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTA1LTE5IGF0IDAwOjA3ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAxMiwgMjAyMSwgSWxpYXMgU3RhbWF0aXMgd3JvdGU6DQo+ID4g
Tm93IHRoYXQgbmVzdGVkIFRTQyBzY2FsaW5nIGlzIHN1cHBvcnRlZCB3ZSBuZWVkIHRvIGNhbGN1
bGF0ZSB0aGUNCj4gPiBjb3JyZWN0IDAyIHZhbHVlcyBmb3IgYm90aCB0aGUgb2Zmc2V0IGFuZCB0
aGUgbXVsdGlwbGllciB1c2luZyB0aGUNCj4gPiBjb3JyZXNwb25kaW5nIGZ1bmN0aW9ucy4gT24g
TDIncyBleGl0IHRoZSBMMSB2YWx1ZXMgYXJlIHJlc3RvcmVkLg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IElsaWFzIFN0YW1hdGlzIDxpbHN0YW1AYW1hem9uLmNvbT4NCj4gPiAtLS0NCj4gPiAg
YXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYyB8IDEzICsrKysrKysrKy0tLS0NCj4gPiAgMSBmaWxl
IGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC9uZXN0ZWQuYyBiL2FyY2gveDg2L2t2bS92bXgvbmVz
dGVkLmMNCj4gPiBpbmRleCA2MDU4YTY1YTZlZGUuLmYxZGZmMWViYWNjYiAxMDA2NDQNCj4gPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3Zt
eC9uZXN0ZWQuYw0KPiA+IEBAIC0zMzU0LDggKzMzNTQsOSBAQCBlbnVtIG52bXhfdm1lbnRyeV9z
dGF0dXMgbmVzdGVkX3ZteF9lbnRlcl9ub25fcm9vdF9tb2RlKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwNCj4gPiAgICAgICB9DQo+ID4gDQo+ID4gICAgICAgZW50ZXJfZ3Vlc3RfbW9kZSh2Y3B1KTsN
Cj4gPiAtICAgICBpZiAodm1jczEyLT5jcHVfYmFzZWRfdm1fZXhlY19jb250cm9sICYgQ1BVX0JB
U0VEX1VTRV9UU0NfT0ZGU0VUVElORykNCj4gPiAtICAgICAgICAgICAgIHZjcHUtPmFyY2gudHNj
X29mZnNldCArPSB2bWNzMTItPnRzY19vZmZzZXQ7DQo+ID4gKw0KPiA+ICsgICAgIGt2bV9zZXRf
MDJfdHNjX29mZnNldCh2Y3B1KTsNCj4gPiArICAgICBrdm1fc2V0XzAyX3RzY19tdWx0aXBsaWVy
KHZjcHUpOw0KPiANCj4gUGxlYXNlIG1vdmUgdGhpcyBjb2RlIGludG8gcHJlcGFyZV92bWNzMDIo
KSB0byBjby1sb2NhdGUgaXQgd2l0aCB0aGUgcmVsZXZhbnQNCj4gdm1jczAyIGxvZ2ljLiAgSWYg
dGhlcmUncyBzb21ldGhpbmcgaW4gcHJlcGFyZV92bWNzMDIoKSB0aGF0IGNvbnN1bWVzDQo+IHZj
cHUtPmFyY2gudHNjX29mZnNldCgpIG90aGVyIHRoYW4gdGhlIG9idmlvdXMgVk1XUklURSwgSSB2
b3RlIHRvIG1vdmUgdGhpbmdzDQo+IGFyb3VuZCB0byBmaXggdGhhdCByYXRoZXIgdGhhbiBjcmVh
dGUgdGhpcyB3ZWlyZCBzcGxpdC4NCj4gDQoNCkFncmVlZC4gSXQgbWFrZXMgbW9yZSBzZW5zZS4N
Cg0KPiA+ICAgICAgIGlmIChwcmVwYXJlX3ZtY3MwMih2Y3B1LCB2bWNzMTIsICZlbnRyeV9mYWls
dXJlX2NvZGUpKSB7DQo+ID4gICAgICAgICAgICAgICBleGl0X3JlYXNvbi5iYXNpYyA9IEVYSVRf
UkVBU09OX0lOVkFMSURfU1RBVEU7DQo+ID4gQEAgLTQ0NjMsOCArNDQ2NCwxMiBAQCB2b2lkIG5l
c3RlZF92bXhfdm1leGl0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIHZtX2V4aXRfcmVhc29u
LA0KPiA+ICAgICAgIGlmIChuZXN0ZWRfY3B1X2hhc19wcmVlbXB0aW9uX3RpbWVyKHZtY3MxMikp
DQo+ID4gICAgICAgICAgICAgICBocnRpbWVyX2NhbmNlbCgmdG9fdm14KHZjcHUpLT5uZXN0ZWQu
cHJlZW1wdGlvbl90aW1lcik7DQo+ID4gDQo+ID4gLSAgICAgaWYgKHZtY3MxMi0+Y3B1X2Jhc2Vk
X3ZtX2V4ZWNfY29udHJvbCAmIENQVV9CQVNFRF9VU0VfVFNDX09GRlNFVFRJTkcpDQo+ID4gLSAg
ICAgICAgICAgICB2Y3B1LT5hcmNoLnRzY19vZmZzZXQgLT0gdm1jczEyLT50c2Nfb2Zmc2V0Ow0K
PiA+ICsgICAgIGlmICh2bWNzMTItPmNwdV9iYXNlZF92bV9leGVjX2NvbnRyb2wgJiBDUFVfQkFT
RURfVVNFX1RTQ19PRkZTRVRUSU5HKSB7DQo+ID4gKyAgICAgICAgICAgICB2Y3B1LT5hcmNoLnRz
Y19vZmZzZXQgPSB2Y3B1LT5hcmNoLmwxX3RzY19vZmZzZXQ7DQo+ID4gKw0KPiA+ICsgICAgICAg
ICAgICAgaWYgKHZtY3MxMi0+c2Vjb25kYXJ5X3ZtX2V4ZWNfY29udHJvbCAmIFNFQ09OREFSWV9F
WEVDX1RTQ19TQ0FMSU5HKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICB2Y3B1LT5hcmNoLnRz
Y19zY2FsaW5nX3JhdGlvID0gdmNwdS0+YXJjaC5sMV90c2Nfc2NhbGluZ19yYXRpbzsNCj4gPiAr
ICAgICB9DQoNCkkgZ3Vlc3MgdGhlc2UgbmVlZCB0byBzdGF5IHdoZXJlIHRoZXkgYXJlIHRob3Vn
aC4NCg0KQW5kIHRoaW5raW5nIGFib3V0IGl0IHRoZSB0d28gaWYgY29uZGl0aW9ucyBhcmUgdW5u
ZWNlc3NhcnkgcmVhbGx5Lg0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXdzIQ0KDQpJbGlhcw0KDQo+
ID4gDQo+ID4gICAgICAgaWYgKGxpa2VseSghdm14LT5mYWlsKSkgew0KPiA+ICAgICAgICAgICAg
ICAgc3luY192bWNzMDJfdG9fdm1jczEyKHZjcHUsIHZtY3MxMik7DQo+ID4gLS0NCj4gPiAyLjE3
LjENCj4gPiANCg0KDQoNCg==
