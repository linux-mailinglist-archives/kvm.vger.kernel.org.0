Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEEE379361
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhEJQKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:10:23 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:26703 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhEJQKL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 12:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620662947; x=1652198947;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=krevKjhDWRPmtYm5SQ2LctOgE9jRRClKMqOAsxF5gJc=;
  b=WLOevkRj7/8s84J9mOY+N78Jt/E/b87Za1bsHD7ig1m0LwRfA/+Fn/C8
   Nqe+qQonqttbS9X7Z4B4dZRoz9TYP2ZjV+4TCU1cw/DWawhMNHGaoZUiM
   txuH71u+3Q3ui4BH7Nq+jbCAC0j2ZLbAW61hdcM5j8Yjb37/5z8BXxgNj
   0=;
X-IronPort-AV: E=Sophos;i="5.82,287,1613433600"; 
   d="scan'208";a="112701303"
Subject: Re: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with nested
 TSC scaling
Thread-Topic: [PATCH 6/8] KVM: VMX: Make vmx_write_l1_tsc_offset() work with nested TSC
 scaling
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 10 May 2021 16:08:58 +0000
Received: from EX13MTAUEB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id 95B5D2226F4;
        Mon, 10 May 2021 16:08:57 +0000 (UTC)
Received: from EX13D08UEB002.ant.amazon.com (10.43.60.107) by
 EX13MTAUEB002.ant.amazon.com (10.43.60.12) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 May 2021 16:08:56 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB002.ant.amazon.com (10.43.60.107) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 May 2021 16:08:56 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.015;
 Mon, 10 May 2021 16:08:55 +0000
From:   "Stamatis, Ilias" <ilstam@amazon.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "ilstam@mailbox.org" <ilstam@mailbox.org>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Thread-Index: AQHXQmO8SiBk4OMk60G+2dhJ+Mah0qrcw0EAgAAlhIA=
Date:   Mon, 10 May 2021 16:08:55 +0000
Message-ID: <9e0973a1adef19158e0c09a642b8c733556e272c.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-7-ilstam@mailbox.org>
         <a83fa70e3111f9c9bcbc5204569d084229815b9a.camel@redhat.com>
In-Reply-To: <a83fa70e3111f9c9bcbc5204569d084229815b9a.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.198]
Content-Type: text/plain; charset="utf-8"
Content-ID: <434A13D666B5104DB4E8A5BA2661EC8E@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIxLTA1LTEwIGF0IDE2OjU0ICswMzAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToN
Cj4gT24gVGh1LCAyMDIxLTA1LTA2IGF0IDEwOjMyICswMDAwLCBpbHN0YW1AbWFpbGJveC5vcmcg
d3JvdGU6DQo+ID4gRnJvbTogSWxpYXMgU3RhbWF0aXMgPGlsc3RhbUBhbWF6b24uY29tPg0KPiA+
IA0KPiA+IENhbGN1bGF0aW5nIHRoZSBjdXJyZW50IFRTQyBvZmZzZXQgaXMgZG9uZSBkaWZmZXJl
bnRseSB3aGVuIG5lc3RlZCBUU0MNCj4gPiBzY2FsaW5nIGlzIHVzZWQuDQo+ID4gDQo+ID4gU2ln
bmVkLW9mZi1ieTogSWxpYXMgU3RhbWF0aXMgPGlsc3RhbUBhbWF6b24uY29tPg0KPiA+IC0tLQ0K
PiA+ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jIHwgMjYgKysrKysrKysrKysrKysrKysrKystLS0t
LS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0p
DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4
Ni9rdm0vdm14L3ZteC5jDQo+ID4gaW5kZXggNDkyNDE0MjNiODU0Li5kZjdkYzBlNGM5MDMgMTAw
NjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ICsrKyBiL2FyY2gveDg2
L2t2bS92bXgvdm14LmMNCj4gPiBAQCAtMTc5NywxMCArMTc5NywxNiBAQCBzdGF0aWMgdm9pZCBz
ZXR1cF9tc3JzKHN0cnVjdCB2Y3B1X3ZteCAqdm14KQ0KPiA+ICAgICAgICAgICAgICAgdm14X3Vw
ZGF0ZV9tc3JfYml0bWFwKCZ2bXgtPnZjcHUpOw0KPiA+ICB9DQo+ID4gDQo+ID4gLXN0YXRpYyB1
NjQgdm14X3dyaXRlX2wxX3RzY19vZmZzZXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgb2Zm
c2V0KQ0KPiA+ICsvKg0KPiA+ICsgKiBUaGlzIGZ1bmN0aW9uIHJlY2VpdmVzIHRoZSByZXF1ZXN0
ZWQgb2Zmc2V0IGZvciBMMSBhcyBhbiBhcmd1bWVudCBidXQgaXQNCj4gPiArICogYWN0dWFsbHkg
d3JpdGVzIHRoZSAiY3VycmVudCIgdHNjIG9mZnNldCB0byB0aGUgVk1DUyBhbmQgcmV0dXJucyBp
dC4gVGhlDQo+ID4gKyAqIGN1cnJlbnQgb2Zmc2V0IG1pZ2h0IGJlIGRpZmZlcmVudCBpbiBjYXNl
IGFuIEwyIGd1ZXN0IGlzIGN1cnJlbnRseSBydW5uaW5nDQo+ID4gKyAqIGFuZCBpdHMgVk1DUzAy
IGlzIGxvYWRlZC4NCj4gPiArICovDQo+IA0KPiAoTm90IHJlbGF0ZWQgdG8gdGhpcyBwYXRjaCkg
SXQgbWlnaHQgYmUgYSBnb29kIGlkZWEgdG8gcmVuYW1lIHRoaXMgY2FsbGJhY2sNCj4gaW5zdGVh
ZCBvZiB0aGlzIGNvbW1lbnQsIGJ1dCBJIGFtIG5vdCBzdXJlIGFib3V0IGl0Lg0KPiANCg0KWWVz
ISBJIHdhcyBwbGFubmluZyB0byBkbyB0aGlzIG9uIHYyIGFueXdheSBhcyB0aGUgbmFtZSBvZiB0
aGF0IGZ1bmN0aW9uDQppcyBjb21wbGV0ZWx5IG1pc2xlYWRpbmcvd3JvbmcgSU1ITy4NCg0KSSB0
aGluayB0aGF0IGV2ZW4gdGhlIGNvbW1lbnQgaW5zaWRlIGl0IHRoYXQgZXhwbGFpbnMgdGhhdCB3
aGVuIEwxDQpkb2Vzbid0IHRyYXAgV1JNU1IgdGhlbiBMMiBUU0Mgd3JpdGVzIG92ZXJ3cml0ZSBM
MSdzIFRTQyBpcyBtaXNwbGFjZWQuDQpJdCBzaG91bGQgZ28gb25lIG9yIG1vcmUgbGV2ZWxzIGFi
b3ZlIEkgYmVsaWV2ZS4NCg0KVGhpcyBmdW5jdGlvbiBzaW1wbHkNCnVwZGF0ZXMgdGhlIFRTQyBv
ZmZzZXQgaW4gdGhlIGN1cnJlbnQgVk1DUyBkZXBlbmRpbmcgb24gd2hldGhlciBMMSBvciBMMg0K
aXMgZXhlY3V0aW5nLiANCg0KPiANCj4gPiArc3RhdGljIHU2NCB2bXhfd3JpdGVfbDFfdHNjX29m
ZnNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBsMV9vZmZzZXQpDQo+ID4gIHsNCj4gPiAg
ICAgICBzdHJ1Y3Qgdm1jczEyICp2bWNzMTIgPSBnZXRfdm1jczEyKHZjcHUpOw0KPiA+IC0gICAg
IHU2NCBnX3RzY19vZmZzZXQgPSAwOw0KPiA+ICsgICAgIHU2NCBjdXJfb2Zmc2V0ID0gbDFfb2Zm
c2V0Ow0KPiA+IA0KPiA+ICAgICAgIC8qDQo+ID4gICAgICAgICogV2UncmUgaGVyZSBpZiBMMSBj
aG9zZSBub3QgdG8gdHJhcCBXUk1TUiB0byBUU0MuIEFjY29yZGluZw0KPiA+IEBAIC0xODA5LDEx
ICsxODE1LDE5IEBAIHN0YXRpYyB1NjQgdm14X3dyaXRlX2wxX3RzY19vZmZzZXQoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCB1NjQgb2Zmc2V0KQ0KPiA+ICAgICAgICAqIHRvIHRoZSBuZXdseSBzZXQg
VFNDIHRvIGdldCBMMidzIFRTQy4NCj4gPiAgICAgICAgKi8NCj4gPiAgICAgICBpZiAoaXNfZ3Vl
c3RfbW9kZSh2Y3B1KSAmJg0KPiA+IC0gICAgICAgICAodm1jczEyLT5jcHVfYmFzZWRfdm1fZXhl
Y19jb250cm9sICYgQ1BVX0JBU0VEX1VTRV9UU0NfT0ZGU0VUVElORykpDQo+ID4gLSAgICAgICAg
ICAgICBnX3RzY19vZmZzZXQgPSB2bWNzMTItPnRzY19vZmZzZXQ7DQo+ID4gKyAgICAgICAgICh2
bWNzMTItPmNwdV9iYXNlZF92bV9leGVjX2NvbnRyb2wgJiBDUFVfQkFTRURfVVNFX1RTQ19PRkZT
RVRUSU5HKSkgew0KPiA+ICsgICAgICAgICAgICAgaWYgKHZtY3MxMi0+c2Vjb25kYXJ5X3ZtX2V4
ZWNfY29udHJvbCAmIFNFQ09OREFSWV9FWEVDX1RTQ19TQ0FMSU5HKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgIGN1cl9vZmZzZXQgPSBrdm1fY29tcHV0ZV8wMl90c2Nfb2Zmc2V0KA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbDFfb2Zmc2V0LA0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm1jczEyLT50c2NfbXVsdGlwbGll
ciwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZtY3MxMi0+dHNj
X29mZnNldCk7DQo+ID4gKyAgICAgICAgICAgICB9IGVsc2Ugew0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBjdXJfb2Zmc2V0ID0gbDFfb2Zmc2V0ICsgdm1jczEyLT50c2Nfb2Zmc2V0Ow0KPiA+
ICsgICAgICAgICAgICAgfQ0KPiA+ICsgICAgIH0NCj4gPiANCj4gPiAtICAgICB2bWNzX3dyaXRl
NjQoVFNDX09GRlNFVCwgb2Zmc2V0ICsgZ190c2Nfb2Zmc2V0KTsNCj4gPiAtICAgICByZXR1cm4g
b2Zmc2V0ICsgZ190c2Nfb2Zmc2V0Ow0KPiA+ICsgICAgIHZtY3Nfd3JpdGU2NChUU0NfT0ZGU0VU
LCBjdXJfb2Zmc2V0KTsNCj4gPiArICAgICByZXR1cm4gY3VyX29mZnNldDsNCj4gPiAgfQ0KPiA+
IA0KPiA+ICAvKg0KPiANCj4gVGhpcyBjb2RlIHdvdWxkIGJlIGlkZWFsIHRvIG1vdmUgdG8gY29t
bW9uIGNvZGUgYXMgU1ZNIHdpbGwgZG8gYmFzaWNhbGx5DQo+IHRoZSBzYW1lIHRoaW5nLg0KPiBE
b2Vzbid0IGhhdmUgdG8gYmUgZG9uZSBub3cgdGhvdWdoLg0KPiANCg0KSG1tLCBob3cgY2FuIHdl
IGRvIHRoZSBmZWF0dXJlIGF2YWlsYWJpbGl0eSBjaGVja2luZyBpbiBjb21tb24gY29kZT8NCg0K
PiANCj4gQmVzdCByZWdhcmRzLA0KPiAgICAgICAgIE1heGltIExldml0c2t5DQo+IA0K
