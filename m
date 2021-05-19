Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077E3388B7B
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347581AbhESKRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:17:09 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:17386 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345568AbhESKRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 06:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621419349; x=1652955349;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Q0kvc8mitvUtI7rRXq2upWsaHx2vb41rgIJw04C/oKw=;
  b=NtLXaqlsf0qnr+K6JXBcLdK4gqCz3jdSUbYO9xpSZXpAkPD7HCaiy1Uh
   l8gEpHHMrmsW1APOpOUd9XuQJfw2J5dX+dh3+PMEJzkRpd8FXdiLUly6r
   gbYtxsp9O4o5qsTZWcumkF++GQ5xBuWlkmzd6Y/HlG79s4uFQ96G66QCw
   U=;
X-IronPort-AV: E=Sophos;i="5.82,312,1613433600"; 
   d="scan'208";a="110222835"
Subject: Re: [PATCH v2 06/10] KVM: X86: Add functions that calculate the 02 TSC
 offset and multiplier
Thread-Topic: [PATCH v2 06/10] KVM: X86: Add functions that calculate the 02 TSC offset
 and multiplier
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-859fe132.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 19 May 2021 10:15:41 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-859fe132.us-west-2.amazon.com (Postfix) with ESMTPS id AE26E220DAD;
        Wed, 19 May 2021 10:15:39 +0000 (UTC)
Received: from EX13D08UEB004.ant.amazon.com (10.43.60.142) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 19 May 2021 10:15:36 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEB004.ant.amazon.com (10.43.60.142) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 19 May 2021 10:15:36 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Wed, 19 May 2021 10:15:35 +0000
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
Thread-Index: AQHXR0FBNd13NwbgBECkahn2O8tvMKrp6ocAgAC1YYA=
Date:   Wed, 19 May 2021 10:15:35 +0000
Message-ID: <1d66b5b9b3dadd968383faf318a168533869f126.camel@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
         <20210512150945.4591-7-ilstam@amazon.com> <YKRL9PPklYCFy43n@google.com>
In-Reply-To: <YKRL9PPklYCFy43n@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.148]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C180F609E39DFB4F8A5D4F325F29294D@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTA1LTE4IGF0IDIzOjIxICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gT24gV2VkLCBNYXkgMTIsIDIwMjEsIElsaWFzIFN0YW1hdGlzIHdyb3RlOg0K
PiA+IFdoZW4gTDIgaXMgZW50ZXJlZCB3ZSBuZWVkIHRvICJtZXJnZSIgdGhlIFRTQyBtdWx0aXBs
aWVyIGFuZCBUU0Mgb2Zmc2V0DQo+ID4gdmFsdWVzIG9mIDAxIGFuZCAxMiB0b2dldGhlci4NCj4g
PiANCj4gPiBUaGUgbWVyZ2luZyBpcyBkb25lIHVzaW5nIHRoZSBmb2xsb3dpbmcgZXF1YXRpb25z
Og0KPiA+ICAgb2Zmc2V0XzAyID0gKChvZmZzZXRfMDEgKiBtdWx0XzEyKSA+PiBzaGlmdF9iaXRz
KSArIG9mZnNldF8xMg0KPiA+ICAgbXVsdF8wMiA9IChtdWx0XzAxICogbXVsdF8xMikgPj4gc2hp
ZnRfYml0cw0KPiA+IA0KPiA+IFdoZXJlIHNoaWZ0X2JpdHMgaXMga3ZtX3RzY19zY2FsaW5nX3Jh
dGlvX2ZyYWNfYml0cy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBJbGlhcyBTdGFtYXRpcyA8
aWxzdGFtQGFtYXpvbi5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmggfCAgMiArKw0KPiA+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAgICAgICAgICAgIHwg
MjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAz
MSBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUv
YXNtL2t2bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gaW5k
ZXggNGM0YTNmZWZmZjU3Li41N2EyNWQ4ZThiMGYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYv
aW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgNCj4gPiBAQCAtMTc5Myw2ICsxNzkzLDggQEAgc3RhdGljIGlubGluZSBib29sIGt2
bV9pc19zdXBwb3J0ZWRfdXNlcl9yZXR1cm5fbXNyKHUzMiBtc3IpDQo+ID4gIHU2NCBrdm1fc2Nh
bGVfdHNjKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IHRzYyk7DQo+ID4gIHU2NCBrdm1fc2Nh
bGVfdHNjX2wxKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IHRzYyk7DQo+ID4gIHU2NCBrdm1f
cmVhZF9sMV90c2Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgaG9zdF90c2MpOw0KPiA+ICt2
b2lkIGt2bV9zZXRfMDJfdHNjX29mZnNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+ICt2
b2lkIGt2bV9zZXRfMDJfdHNjX211bHRpcGxpZXIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4g
PiANCj4gPiAgdW5zaWduZWQgbG9uZyBrdm1fZ2V0X2xpbmVhcl9yaXAoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KTsNCj4gPiAgYm9vbCBrdm1faXNfbGluZWFyX3JpcChzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHVuc2lnbmVkIGxvbmcgbGluZWFyX3JpcCk7DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+IGluZGV4IDg0YWYxYWY3YTJjYy4u
MWRiNmNmYzIwNzlmIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+ICsr
KyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+IEBAIC0yMzQ2LDYgKzIzNDYsMzUgQEAgdTY0IGt2
bV9yZWFkX2wxX3RzYyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBob3N0X3RzYykNCj4gPiAg
fQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChrdm1fcmVhZF9sMV90c2MpOw0KPiA+IA0KPiA+ICt2
b2lkIGt2bV9zZXRfMDJfdHNjX29mZnNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IA0KPiBJ
IGRpc2xpa2UgbGlrZSB0aGUgIjAyIiBub21lbmNsYXR1cmUuICAiMDIiIGlzIHVzZWQgc3BlY2lm
aWNhbGx5IHRvIHJlZmVyIHRvDQo+IHZtY3MwMiBhbmQgdm1jYjAyLCB3aGVyZWFzIHRoZXNlIGhl
bHBlcnMgdG91Y2ggS1ZNJ3Mgc29mdHdhcmUgbW9kZWwsIG5vdCB0aGUgQ1BVDQo+IHN0cnVjdC4g
IENhbid0IHRoaXMgc2ltcGx5IGJlICJsMiI/DQo+IA0KPiA+ICt7DQo+ID4gKyAgICAgdTY0IGwy
X29mZnNldCA9IHN0YXRpY19jYWxsKGt2bV94ODZfZ2V0X2wyX3RzY19vZmZzZXQpKHZjcHUpOw0K
PiA+ICsgICAgIHU2NCBsMl9tdWx0aXBsaWVyID0gc3RhdGljX2NhbGwoa3ZtX3g4Nl9nZXRfbDJf
dHNjX211bHRpcGxpZXIpKHZjcHUpOw0KPiA+ICsNCj4gPiArICAgICBpZiAobDJfbXVsdGlwbGll
ciAhPSBrdm1fZGVmYXVsdF90c2Nfc2NhbGluZ19yYXRpbykgew0KPiA+ICsgICAgICAgICAgICAg
dmNwdS0+YXJjaC50c2Nfb2Zmc2V0ID0gbXVsX3M2NF91NjRfc2hyKA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIChzNjQpIHZjcHUtPmFyY2gubDFfdHNjX29mZnNldCwNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsMl9tdWx0aXBsaWVyLA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGt2bV90c2Nfc2NhbGluZ19yYXRpb19mcmFjX2JpdHMpOw0K
PiA+ICsgICAgIH0NCj4gPiArDQo+ID4gKyAgICAgdmNwdS0+YXJjaC50c2Nfb2Zmc2V0ICs9IGwy
X29mZnNldDsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChrdm1fc2V0XzAyX3RzY19v
ZmZzZXQpOw0KPiA+ICsNCj4gPiArdm9pZCBrdm1fc2V0XzAyX3RzY19tdWx0aXBsaWVyKHN0cnVj
dCBrdm1fdmNwdSAqdmNwdSkNCj4gDQo+IEkgbm9ybWFsbHkgbGlrZSBzcGxpdHRpbmcgcGF0Y2hl
cyBncmF0dWl0b3VzbHksIGJ1dCBpbiB0aGlzIGNhc2UgSSB0aGluayBpdCB3b3VsZA0KPiBiZSBi
ZXR0ZXIgdG8gY29tYmluZSB0aGlzIHdpdGggdGhlIFZNWCB1c2FnZSBpbiBwYXRjaCAwOC4gIEl0
J3MgaW1wb3NzaWJsZSB0bw0KPiBwcm9wZXJseSByZXZpZXcgdGhpcyBwYXRjaCB3aXRob3V0IGxv
b2tpbmcgYXQgaXRzIGNhbGxlcnMuDQo+IA0KPiA+ICt7DQo+ID4gKyAgICAgdTY0IGwyX211bHRp
cGxpZXIgPSBzdGF0aWNfY2FsbChrdm1feDg2X2dldF9sMl90c2NfbXVsdGlwbGllcikodmNwdSk7
DQo+IA0KPiBDYXNlIGluIHBvaW50LCBjYWxsaW5nIGJhY2sgaW50byB2ZW5kb3IgY29kZSB0byBn
ZXQgdGhlIEwyIG11bHRpcGxpZXIgaXMgc2lsbHksDQo+IGp1c3QgaGF2ZSB0aGUgY2FsbGVyIHBy
b3ZpZGUgaXQgZXhwbGljaXRseS4NCj4gDQo+ID4gKyAgICAgaWYgKGwyX211bHRpcGxpZXIgIT0g
a3ZtX2RlZmF1bHRfdHNjX3NjYWxpbmdfcmF0aW8pIHsNCj4gDQo+IFdoeSBkb2VzIHRoaXMgY2hl
Y2sgYWdhaW5zdCB0aGUgZGVmYXVsdCByYXRpbyBpbnN0ZWFkIG9mIEwxJ3MgcmF0aW8/ICBJZiBM
MSBpcw0KPiBydW5uaW5nIGEgbm9uLWRlZmF1bHQgcmF0aW8sIGJ1dCBMMiBpcyBydW5uaW5nIGEg
ZGVmYXVsdCByYXRpbywgd29uJ3QgdGhpcyByZXN1bHQNCj4gaW4gS1ZNIGxlYXZpbmcgdmNwdS0+
YXJjaC50c2Nfc2NhbGluZ19yYXRpbyBhdCBMMSdzIHJhdGlvPyAgT3IgaXMgdGhlcmUgc2NhbGlu
Zw0KPiByYXRpbyBtYWdpYyBJIGRvbid0IHVuZGVyc3RhbmQgKHdoaWNoIGlzIGxpa2VseS4uLik/
ICBJZiB0aGVyZSdzIG1hZ2ljLCBjYW4geW91DQo+IGFkZCBhIGNvbW1lbnQ/DQo+IA0KDQpUaGlu
ayBvZiB0aGUgImRlZmF1bHQgcmF0aW8iIGFzIGEgcmF0aW8gb2YgMSwgaWUgTDIgaXMgbm90IHNj
YWxlZCAoZnJvbSBMMSdzDQpwZXJzcGVjdGl2ZSkuIFNvIHllcywgYXMgeW91IHNheSBpZiBMMSBp
cyBydW5uaW5nIGF0IGEgbm9uLWRlZmF1bHQgcmF0aW8sIGJ1dA0KTDIgaXMgcnVubmluZyBhdCBk
ZWZhdWx0IHJhdGlvIChub3Qgc2NhbGVkKSwgdGhpcyByZXN1bHRzIGluIEtWTSBsZWF2aW5nIA0K
YXJjaC50c2Nfc2NhbGluZ19yYXRpbyBhdCBMMSdzIHJhdGlvIChhcyBpdCBzaG91bGQpLiANCg0K
SSBhbSBub3Qgc3VyZSBhIGNvbW1lbnQgaXMgbmVlZGVkIGhlcmUuIA0KDQpIYXZpbmcgc2FpZCB0
aGF0LCB0aGVvcmV0aWNhbGx5IHdlIGNvdWxkIG9taXQgdGhpcyBjaGVjayBjb21wbGV0ZWx5IGFu
ZCBzdGlsbA0KZ2V0IHRoZSBjb3JyZWN0IHJlc3VsdC4gQnV0IGluIHJlYWxpdHkgYmVjYXVzZSBv
ZiB0aGUgY29tcHV0ZXIgbWF0aCBpbnZvbHZlZA0KdGhlcmUgd2lsbCBiZSBhIHNtYWxsIHByZWNp
c2lvbiBlcnJvciBhbmQgdGhlIHRzY19zY2FsaW5nX3JhdGlvIHJhdGlvIHdvbid0DQplbmQgdXAg
YmVpbmcgZXhhY3RseSB0aGUgc2FtZSBhcyB0aGUgbDFfdHNjX3NjYWxpbmdfcmF0aW8uIA0KDQpJ
IHdpbGwgaW1wbGVtZW50IHRoZSByZXN0IG9mIHlvdXIgZmVlZGJhY2ssIHRoYW5rcy4NCg0KPiAN
Cj4gU2FtZSBmZWVkYmFjayBmb3IgdGhlIGNoZWNrIGluIHRoZSBvZmZzZXQgdmVyc2lvbi4NCj4g
DQo+ID4gKyAgICAgICAgICAgICB2Y3B1LT5hcmNoLnRzY19zY2FsaW5nX3JhdGlvID0gbXVsX3U2
NF91NjRfc2hyKA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHZjcHUtPmFyY2gu
bDFfdHNjX3NjYWxpbmdfcmF0aW8sDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
bDJfbXVsdGlwbGllciwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICBrdm1fdHNj
X3NjYWxpbmdfcmF0aW9fZnJhY19iaXRzKTsNCj4gPiArICAgICB9DQo+ID4gK30NCj4gPiArRVhQ
T1JUX1NZTUJPTF9HUEwoa3ZtX3NldF8wMl90c2NfbXVsdGlwbGllcik7DQo+ID4gKw0KPiA+ICBz
dGF0aWMgdm9pZCBrdm1fdmNwdV93cml0ZV90c2Nfb2Zmc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgdTY0IG9mZnNldCkNCj4gPiAgew0KPiA+ICAgICAgIHZjcHUtPmFyY2gubDFfdHNjX29mZnNl
dCA9IG9mZnNldDsNCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+IA0KDQoNCg0KDQoNCg==
