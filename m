Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96E638B5F5
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 20:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbhETS2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 14:28:46 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:17951 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhETS2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 14:28:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621535245; x=1653071245;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=s8cmiaERlKUz3hIIWr0df5gbBWVmLCfxFe0w+iSnRl0=;
  b=e+iYgtAU1vuD16gVST83hsIVL0aplgjT+UBVzuATrs2AXgav7EyEwYBe
   cfOBlkH5QK2gJpzN5vsg2xL5YBKnLsD06S675dqSmvGlZEsZ4gguMCF6x
   WPWlCC8CtFIPGQnHZV3JJD1jRUsRt6Z27kiOeXmnFgPxa9xx/8s1badIg
   k=;
X-IronPort-AV: E=Sophos;i="5.82,313,1613433600"; 
   d="scan'208";a="109050490"
Subject: Re: [PATCH v2 03/10] KVM: X86: Add kvm_scale_tsc_l1() and
 kvm_compute_tsc_offset_l1()
Thread-Topic: [PATCH v2 03/10] KVM: X86: Add kvm_scale_tsc_l1() and
 kvm_compute_tsc_offset_l1()
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-4101.iad4.amazon.com with ESMTP; 20 May 2021 18:27:17 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 168A8A1DEC;
        Thu, 20 May 2021 18:27:15 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 18:27:13 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 20 May 2021 18:27:13 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Thu, 20 May 2021 18:27:12 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "seanjc@google.com" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXR0Eu985oRo9Cq0eeOk7jLKEluarp5bsAgACnOACAAG8LAIABv5mA
Date:   Thu, 20 May 2021 18:27:12 +0000
Message-ID: <980ceab359264525a6e8ae8403ff3a42a465b4ef.camel@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
         <20210512150945.4591-4-ilstam@amazon.com> <YKRH7qVHpow6kwi5@google.com>
         <772e232c27d180f876a5b49d7f188c0c3acd7560.camel@amazon.com>
         <YKUxWh1Blu7rLZR9@google.com>
In-Reply-To: <YKUxWh1Blu7rLZR9@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.198]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1840E9ADAB2B4E4DB079DC7BE116AE73@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIxLTA1LTE5IGF0IDE1OjQwICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAxOSwgMjAyMSwgU3RhbWF0aXMsIElsaWFzIHdyb3RlOg0KPiA+
IE9uIFR1ZSwgMjAyMS0wNS0xOCBhdCAyMzowNCArMDAwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3
cm90ZToNCj4gPiA+IE9uIFdlZCwgTWF5IDEyLCAyMDIxLCBJbGlhcyBTdGFtYXRpcyB3cm90ZToN
Cj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94
ODYuYw0KPiA+ID4gPiBpbmRleCAwN2NmNWQ3ZWNlMzguLjg0YWYxYWY3YTJjYyAxMDA2NDQNCj4g
PiA+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2t2
bS94ODYuYw0KPiA+ID4gPiBAQCAtMjMxOSwxOCArMjMxOSwzMCBAQCB1NjQga3ZtX3NjYWxlX3Rz
YyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB0c2MpDQo+ID4gPiA+ICB9DQo+ID4gPiA+ICBF
WFBPUlRfU1lNQk9MX0dQTChrdm1fc2NhbGVfdHNjKTsNCj4gPiA+ID4gDQo+ID4gPiA+IC1zdGF0
aWMgdTY0IGt2bV9jb21wdXRlX3RzY19vZmZzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
dGFyZ2V0X3RzYykNCj4gPiA+ID4gK3U2NCBrdm1fc2NhbGVfdHNjX2wxKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwgdTY0IHRzYykNCj4gPiA+ID4gK3sNCj4gPiA+ID4gKyAgICAgdTY0IF90c2MgPSB0
c2M7DQo+ID4gPiA+ICsgICAgIHU2NCByYXRpbyA9IHZjcHUtPmFyY2gubDFfdHNjX3NjYWxpbmdf
cmF0aW87DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgaWYgKHJhdGlvICE9IGt2bV9kZWZhdWx0
X3RzY19zY2FsaW5nX3JhdGlvKQ0KPiA+ID4gPiArICAgICAgICAgICAgIF90c2MgPSBfX3NjYWxl
X3RzYyhyYXRpbywgdHNjKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArICAgICByZXR1cm4gX3RzYzsN
Cj4gPiA+ID4gK30NCj4gPiA+IA0KPiA+ID4gSnVzdCBtYWtlIHRoZSByYXRpbyBhIHBhcmFtLiAg
VGhpcyBpcyBjb21wbGV0ZSBjb3B5K3Bhc3RlIG9mIGt2bV9zY2FsZV90c2MoKSwNCj4gPiA+IHdp
dGggMyBjaGFyYWN0ZXJzIGFkZGVkLiAgQW5kIGFsbCBvZiB0aGUgY2FsbGVycyBhcmUgYWxyZWFk
eSBpbiBhbiBMMS1zcGVjaWZpYw0KPiA+ID4gZnVuY3Rpb24gb3IgaGF2ZSBMMSB2cy4gTDIgYXdh
cmVuZXNzLiAgSU1PLCB0aGF0IG1ha2VzIHRoZSBjb2RlIGxlc3MgbWFnaWNhbCwgdG9vLA0KPiA+
ID4gYXMgSSBkb24ndCBoYXZlIHRvIGRpdmUgaW50byBhIGhlbHBlciB0byBzZWUgdGhhdCBpdCBy
ZWFkcyBsMV90c2Nfc2NhbGluZ19yYXRpbw0KPiA+ID4gdmVyc3VzIHRzY19zY2FsaW5nX3JhdGlv
Lg0KPiA+ID4gDQo+ID4gDQo+ID4gVGhhdCdzIGhvdyBJIGRpZCBpdCBpbml0aWFsbHkgYnV0IGNo
YW5nZWQgaXQgaW50byBhIHNlcGFyYXRlIGZ1bmN0aW9uIGFmdGVyDQo+ID4gcmVjZWl2aW5nIGZl
ZWRiYWNrIG9uIHYxLiBJJ20gbmV1dHJhbCwgSSBkb24ndCBtaW5kIGNoYW5naW5nIGl0IGJhY2su
DQo+IA0KPiBBaCwgSSBzZWUgdGhlIGNvbnVuZHJ1bS4gIFRoZSB2ZW5kb3IgY29kZSBpc24ndCBz
dHJhaWdodGZvcndhcmQgYmVjYXVzZSBvZiBhbGwNCj4gdGhlIGVuYWJsaW5nIGNoZWNrcyBhZ2Fp
bnN0IHZtY3MxMiBjb250cm9scy4NCj4gDQo+IEdpdmVuIHRoYXQsIEkgZG9uJ3QgdGVycmlibHkg
bWluZCB0aGUgY2FsbGJhY2tzLCBidXQgSSBkbyB0aGluayB0aGUgY29ubmVjdGlvbg0KPiBiZXR3
ZWVuIHRoZSBjb21wdXRhdGlvbiBhbmQgdGhlIFZNV1JJVEUgbmVlZHMgdG8gYmUgbW9yZSBleHBs
aWNpdC4NCj4gDQo+IFBva2luZyBhcm91bmQgdGhlIGNvZGUsIHRoZSBvdGhlciB0aGluZyB0aGF0
IHdvdWxkIGhlbHAgd291bGQgYmUgdG8gZ2V0IHJpZCBvZg0KPiB0aGUgYXdmdWwgZGVjYWNoZV90
c2NfbXVsdGlwbGllcigpLiAgVGhhdCBoZWxwZXIgd2FzIGFkZGVkIHRvIHBhcGVyIG92ZXIgdGhl
DQo+IGNvbXBsZXRlbHkgYnJva2VuIGxvZ2ljIG9mIGNvbW1pdCBmZjJjM2ExODAzNzcgKCJLVk06
IFZNWDogU2V0dXAgVFNDIHNjYWxpbmcNCj4gcmF0aW8gd2hlbiBhIHZjcHUgaXMgbG9hZGVkIiku
ICBJdHMgdXNlIGluIHZteF92Y3B1X2xvYWRfdm1jcygpIGlzIGJhc2ljYWxseQ0KPiAid3JpdGUg
dGhlIFZNQ1MgaWYgd2UgZm9yZ290IHRvIGVhcmxpZXIiLCB3aGljaCBpcyBhbGwga2luZHMgb2Yg
d3JvbmcuDQo+IA0KDQpJIGFtIGdvaW5nIHRvIGFkZCBhIHBhdGNoIHRoYXQgcmVtb3ZlcyBkZWNh
Y2hlX3RzY19tdWx0aXBsaWVyKCkgYW5kIA0Kdm14LT5jdXJyZW50X3RzY19yYXRpbyBhcyB0aGUg
bGF0dGVyIGlzIHVzZWxlc3Mgc2luY2UgdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19yYXRpbyANCmlz
IGFscmVhZHkgdGhlIGN1cnJlbnQgcmF0aW8uIEFuZCB3aXRob3V0IGl0IGRlY2FjaGVfdHNjX211
bHRpcGxpZXIoKSBiZWNvbWVzDQphbiBvbmUtbGluZXIgdGhhdCBpcyBwb2ludGxlc3MgdG8gaGF2
ZTsgd2UgY2FuIGRvIHZtY3Nfd3JpdGU2NCgpIGRpcmVjdGx5Lg0KDQpOZXZlcnRoZWxlc3MsIEkg
YW0gbm90IGdvaW5nIHRvIG1vdmUgdGhlIGNvZGUgb3V0c2lkZSBvZiB2bXhfdmNwdV9sb2FkX3Zt
Y3MoKS4NCkdyYW50ZWQsIGEgYmV0dGVyIHBsYWNlIGZvciBzZXR0aW5nIHRoZSBtdWx0aXBsaWVy
IGluIGhhcmR3YXJlIHdvdWxkIGJlDQpzZXRfdHNjX2toeigpLiBCdXQgdGhpcyBmdW5jdGlvbiBp
cyBpbnNpZGUgeDg2LmMgc28gaXQgd291bGQgcmVxdWlyZSB5ZXQNCmFub3RoZXIgdmVuZG9yIGNh
bGxiYWNrIHRvIGJlIGFkZGVkLCBtb3ZlIHRoZSBzdm0gY29kZSB0b28sIGV0YywgZXRjLg0KDQpN
dWNoIG1vcmUgcmVmYWN0b3JpbmcgY2FuIGJlIGRvbmUgaW4gS1ZNIGNvZGUgaW4gZ2VuZXJhbCBi
dXQgSSBkb24ndCB0aGluayBpdA0KaGFzIHRvIGJlIHBhcnQgb2YgdGhpcyBzZXJpZXMuIEkgYW0g
Z29pbmcgdG8gc2VuZCB0aGUgdjMgcGF0Y2hlcyB0b21vcnJvdy4gDQoNCklsaWFzDQoNCg==
