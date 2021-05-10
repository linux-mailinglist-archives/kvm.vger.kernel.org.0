Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AE3792F2
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhEJPp4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:45:56 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:54824 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbhEJPpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1620661488; x=1652197488;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=7uk2/+tULUo3LdntKsuwUNQhV9sMzVjZaJesCMqLVv8=;
  b=ORU++DZv1uzrouBXOToMb6xA2fFFq+NujiUwOuBVi4ahu5f3/VrM8Z2A
   E4gPlndWRzxWNJDT1C4hF537fti02XAiyU6DO9YaXWHnixQPP4eqcR76B
   29x70OLVPrnr/dq3yx4xzkILBZsfdjMt2TMQGdUYg7RK1U47gIK+JSIBI
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,287,1613433600"; 
   d="scan'208";a="111260441"
Subject: Re: [PATCH 3/8] KVM: X86: Pass an additional 'L1' argument to kvm_scale_tsc()
Thread-Topic: [PATCH 3/8] KVM: X86: Pass an additional 'L1' argument to kvm_scale_tsc()
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 10 May 2021 15:44:41 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 7EDD2A25D2;
        Mon, 10 May 2021 15:44:37 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 May 2021 15:44:33 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 10 May 2021 15:44:32 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.015;
 Mon, 10 May 2021 15:44:32 +0000
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
Thread-Index: AQHXQmOK1EXr+eKsSkOZOg555bWIgKrcwqWAgAAfUIA=
Date:   Mon, 10 May 2021 15:44:31 +0000
Message-ID: <041e087ab930f33cff5563204c79438368c9d694.camel@amazon.com>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-4-ilstam@mailbox.org>
         <b87ca34b3251f06c807e5d46bbf821756e57ff5b.camel@redhat.com>
In-Reply-To: <b87ca34b3251f06c807e5d46bbf821756e57ff5b.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.104]
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F01C480F69B494481C981360DC2AE9A@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIxLTA1LTEwIGF0IDE2OjUyICswMzAwLCBNYXhpbSBMZXZpdHNreSB3cm90ZToN
Cj4gT24gVGh1LCAyMDIxLTA1LTA2IGF0IDEwOjMyICswMDAwLCBpbHN0YW1AbWFpbGJveC5vcmcg
d3JvdGU6DQo+ID4gRnJvbTogSWxpYXMgU3RhbWF0aXMgPGlsc3RhbUBhbWF6b24uY29tPg0KPiA+
IA0KPiA+IFNvbWV0aW1lcyBrdm1fc2NhbGVfdHNjKCkgbmVlZHMgdG8gdXNlIHRoZSBjdXJyZW50
IHNjYWxpbmcgcmF0aW8gYW5kDQo+ID4gb3RoZXIgdGltZXMgKGxpa2Ugd2hlbiByZWFkaW5nIHRo
ZSBUU0MgZnJvbSB1c2VyIHNwYWNlKSBpdCBuZWVkcyB0byB1c2UNCj4gPiBMMSdzIHNjYWxpbmcg
cmF0aW8uIEhhdmUgdGhlIGNhbGxlciBzcGVjaWZ5IHRoaXMgYnkgcGFzc2luZyBhbg0KPiA+IGFk
ZGl0aW9uYWwgYm9vbGVhbiBhcmd1bWVudC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBJbGlh
cyBTdGFtYXRpcyA8aWxzdGFtQGFtYXpvbi5jb20+DQo+ID4gLS0tDQo+ID4gIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAgMiArLQ0KPiA+ICBhcmNoL3g4Ni9rdm0veDg2LmMgICAg
ICAgICAgICAgIHwgMjEgKysrKysrKysrKysrKy0tLS0tLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdl
ZCwgMTQgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L2t2bV9ob3N0LmgNCj4gPiBpbmRleCAxMzJlODIwNTI1ZmIuLmNkZGRiZjBiMTE3NyAxMDA2NDQN
Cj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+ID4gKysrIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiA+IEBAIC0xNzc5LDcgKzE3NzksNyBAQCBp
bnQga3ZtX3B2X3NlbmRfaXBpKHN0cnVjdCBrdm0gKmt2bSwgdW5zaWduZWQgbG9uZyBpcGlfYml0
bWFwX2xvdywNCj4gPiAgdm9pZCBrdm1fZGVmaW5lX3VzZXJfcmV0dXJuX21zcih1bnNpZ25lZCBp
bmRleCwgdTMyIG1zcik7DQo+ID4gIGludCBrdm1fc2V0X3VzZXJfcmV0dXJuX21zcih1bnNpZ25l
ZCBpbmRleCwgdTY0IHZhbCwgdTY0IG1hc2spOw0KPiA+IA0KPiA+IC11NjQga3ZtX3NjYWxlX3Rz
YyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB0c2MpOw0KPiA+ICt1NjQga3ZtX3NjYWxlX3Rz
YyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB0c2MsIGJvb2wgbDEpOw0KPiA+ICB1NjQga3Zt
X3JlYWRfbDFfdHNjKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGhvc3RfdHNjKTsNCj4gPiAN
Cj4gPiAgdW5zaWduZWQgbG9uZyBrdm1fZ2V0X2xpbmVhcl9yaXAoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KTsNCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3Zt
L3g4Ni5jDQo+ID4gaW5kZXggN2JjNTE1NWFjNmZkLi4yNmE0YzBmNDZmMTUgMTAwNjQ0DQo+ID4g
LS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+
ID4gQEAgLTIyNDEsMTAgKzIyNDEsMTQgQEAgc3RhdGljIGlubGluZSB1NjQgX19zY2FsZV90c2Mo
dTY0IHJhdGlvLCB1NjQgdHNjKQ0KPiA+ICAgICAgIHJldHVybiBtdWxfdTY0X3U2NF9zaHIodHNj
LCByYXRpbywga3ZtX3RzY19zY2FsaW5nX3JhdGlvX2ZyYWNfYml0cyk7DQo+ID4gIH0NCj4gPiAN
Cj4gPiAtdTY0IGt2bV9zY2FsZV90c2Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgdHNjKQ0K
PiA+ICsvKg0KPiA+ICsgKiBJZiBsMSBpcyB0cnVlIHRoZSBUU0MgaXMgc2NhbGVkIHVzaW5nIEwx
J3Mgc2NhbGluZyByYXRpbywgb3RoZXJ3aXNlDQo+ID4gKyAqIHRoZSBjdXJyZW50IHNjYWxpbmcg
cmF0aW8gaXMgdXNlZC4NCj4gPiArICovDQo+ID4gK3U2NCBrdm1fc2NhbGVfdHNjKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwgdTY0IHRzYywgYm9vbCBsMSkNCj4gPiAgew0KPiA+ICAgICAgIHU2NCBf
dHNjID0gdHNjOw0KPiA+IC0gICAgIHU2NCByYXRpbyA9IHZjcHUtPmFyY2gudHNjX3NjYWxpbmdf
cmF0aW87DQo+ID4gKyAgICAgdTY0IHJhdGlvID0gbDEgPyB2Y3B1LT5hcmNoLmwxX3RzY19zY2Fs
aW5nX3JhdGlvIDogdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19yYXRpbzsNCj4gPiANCj4gPiAgICAg
ICBpZiAocmF0aW8gIT0ga3ZtX2RlZmF1bHRfdHNjX3NjYWxpbmdfcmF0aW8pDQo+ID4gICAgICAg
ICAgICAgICBfdHNjID0gX19zY2FsZV90c2MocmF0aW8sIHRzYyk7DQo+IA0KPiBJIGRvIHdvbmRl
ciBpZiBpdCBpcyBiZXR0ZXIgdG8gaGF2ZSBrdm1fc2NhbGVfdHNjX2wxIGFuZCBrdm1fc2NhbGVf
dHNjIGluc3RlYWQgZm9yIGJldHRlcg0KPiByZWFkYWJsaWxpdHk/DQo+IA0KDQpUaGF0IG1ha2Vz
IHNlbnNlLiBXaWxsIGRvLg0KDQo+IA0KPiA+IEBAIC0yMjU3LDE0ICsyMjYxLDE0IEBAIHN0YXRp
YyB1NjQga3ZtX2NvbXB1dGVfdHNjX29mZnNldChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCB0
YXJnZXRfdHNjKQ0KPiA+ICB7DQo+ID4gICAgICAgdTY0IHRzYzsNCj4gPiANCj4gPiAtICAgICB0
c2MgPSBrdm1fc2NhbGVfdHNjKHZjcHUsIHJkdHNjKCkpOw0KPiA+ICsgICAgIHRzYyA9IGt2bV9z
Y2FsZV90c2ModmNwdSwgcmR0c2MoKSwgdHJ1ZSk7DQo+IA0KPiBIZXJlIHdlIGhhdmUgYSBzb21l
d2hhdCBkYW5nZXJvdXMgYXNzdW1wdGlvbiB0aGF0IHRoaXMgZnVuY3Rpb24NCj4gd2lsbCBhbHdh
eXMgYmUgdXNlZCB3aXRoIEwxIHRzYyB2YWx1ZXMuDQo+IA0KPiBUaGUga3ZtX2NvbXB1dGVfdHNj
X29mZnNldCBzaG91bGQgYXQgbGVhc3QgYmUgcmVuYW1lZCB0bw0KPiBrdm1fY29tcHV0ZV90c2Nf
b2Zmc2V0X2wxIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuDQo+IA0KPiBDdXJyZW50bHkgdGhlIGFz
c3VtcHRpb24gaG9sZHMgdGhvdWdoOg0KPiANCj4gV2UgY2FsbCB0aGUga3ZtX2NvbXB1dGVfdHNj
X29mZnNldCBpbjoNCj4gDQo+IC0+IGt2bV9zeW5jaHJvbml6ZV90c2Mgd2hpY2ggaXMgbm93YWRh
eXMgdGhhbmtmdWxseSBvbmx5IGNhbGxlZA0KPiBvbiBUU0Mgd3JpdGVzIGZyb20gcWVtdSwgd2hp
Y2ggYXJlIGFzc3VtZWQgdG8gYmUgTDEgdmFsdWVzLg0KPiANCj4gKHRoaXMgaXMgcGVuZGluZyBh
IHJld29yayBvZiB0aGUgd2hvbGUgdGhpbmcgd2hpY2ggSSBzdGFydGVkDQo+IHNvbWUgdGltZSBh
Z28gYnV0IGhhdmVuJ3QgaGFkIGEgY2hhbmNlIHRvIGZpbmlzaCBpdCB5ZXQpDQo+IA0KPiAtPiBH
dWVzdCB3cml0ZSBvZiBNU1JfSUEzMl9UU0MuIFRoZSB2YWx1ZSB3cml0dGVuIGlzIGluIEwxIHVu
aXRzLA0KPiBzaW5jZSBUU0Mgb2Zmc2V0L3NjYWxpbmcgb25seSBjb3ZlcnMgUkRUU0MgYW5kIFJE
TVNSIG9mIHRoZSBJQTMyX1RTQywNCj4gd2hpbGUgV1JNU1Igc2hvdWxkIGJlIGludGVyY2VwdGVk
IGJ5IEwxIGFuZCBlbXVsYXRlZC4NCj4gSWYgaXQgaXMgbm90IGVtdWxhdGVkLCB0aGVuIEwyIHdv
dWxkIGp1c3Qgd3JpdGUgTDEgdmFsdWUuDQo+IA0KPiAtPiBpbiBrdm1fYXJjaF92Y3B1X2xvYWQs
IHdoZW4gVFNDIGlzIHVuc3RhYmxlLCB3ZSBhbHdheXMgdHJ5IHRvIHJlc3VtZQ0KPiB0aGUgZ3Vl
c3QgZnJvbSB0aGUgc2FtZSBUU0MgdmFsdWUgYXMgaXQgaGFkIHNlZW4gbGFzdCB0aW1lLA0KPiBh
bmQgdGhlbiBjYXRjaHVwLg0KDQpZZXMuIEkgd2Fzbid0IHN1cmUgYWJvdXQga3ZtX2NvbXB1dGVf
dHNjX29mZnNldCBidXQgbXkgdW5kZXJzdGFuZGluZyB3YXMNCnRoYXQgYWxsIG9mIGl0cyBjYWxs
ZXJzIHdhbnRlZCB0aGUgTDEgdmFsdWUgc2NhbGVkLg0KDQpSZW5hbWluZyBpdCB0byBrdm1fc2Nh
bGVfdHNjX2wxIHNvdW5kcyBsaWtlIGEgZ3JlYXQgaWRlYS4NCg0KPiBBbHNvIGhvc3QgVFNDIHZh
bHVlcyBhcmUgdXNlZCwgYW5kIGFmdGVyIHJlYWRpbmcgdGhpcyBmdW5jdGlvbiwNCj4gSSByZWNv
bW1lbmQgdG8gcmVuYW1lIHRoZSB2Y3B1LT5hcmNoLmxhc3RfZ3Vlc3RfdHNjDQo+IHRvIHZjcHUt
PmFyY2gubGFzdF9ndWVzdF90c2NfbDEgdG8gZG9jdW1lbnQgdGhpcy4NCg0KT0sNCg0KPiA+IA0K
PiA+ICAgICAgIHJldHVybiB0YXJnZXRfdHNjIC0gdHNjOw0KPiA+ICB9DQo+ID4gDQo+ID4gIHU2
NCBrdm1fcmVhZF9sMV90c2Moc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQgaG9zdF90c2MpDQo+
ID4gIHsNCj4gPiAtICAgICByZXR1cm4gdmNwdS0+YXJjaC5sMV90c2Nfb2Zmc2V0ICsga3ZtX3Nj
YWxlX3RzYyh2Y3B1LCBob3N0X3RzYyk7DQo+ID4gKyAgICAgcmV0dXJuIHZjcHUtPmFyY2gubDFf
dHNjX29mZnNldCArIGt2bV9zY2FsZV90c2ModmNwdSwgaG9zdF90c2MsIHRydWUpOw0KPiANCj4g
T0sNCj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChrdm1fcmVhZF9sMV90c2MpOw0KPiA+
IA0KPiA+IEBAIC0yMzk1LDkgKzIzOTksOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYWRqdXN0X3Rz
Y19vZmZzZXRfZ3Vlc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiA+IA0KPiA+ICBzdGF0aWMg
aW5saW5lIHZvaWQgYWRqdXN0X3RzY19vZmZzZXRfaG9zdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
IHM2NCBhZGp1c3RtZW50KQ0KPiA+ICB7DQo+ID4gLSAgICAgaWYgKHZjcHUtPmFyY2gudHNjX3Nj
YWxpbmdfcmF0aW8gIT0ga3ZtX2RlZmF1bHRfdHNjX3NjYWxpbmdfcmF0aW8pDQo+ID4gKyAgICAg
aWYgKHZjcHUtPmFyY2gubDFfdHNjX3NjYWxpbmdfcmF0aW8gIT0ga3ZtX2RlZmF1bHRfdHNjX3Nj
YWxpbmdfcmF0aW8pDQo+ID4gICAgICAgICAgICAgICBXQVJOX09OKGFkanVzdG1lbnQgPCAwKTsN
Cj4gDQo+IFRoaXMgc2hvdWxkIGJlbG9uZyB0byBwYXRjaCAyIElNSE8uDQo+IA0KDQpSaWdodCwg
SSB3aWxsIG1vdmUgaXQuDQoNCj4gPiAtICAgICBhZGp1c3RtZW50ID0ga3ZtX3NjYWxlX3RzYyh2
Y3B1LCAodTY0KSBhZGp1c3RtZW50KTsNCj4gPiArICAgICBhZGp1c3RtZW50ID0ga3ZtX3NjYWxl
X3RzYyh2Y3B1LCAodTY0KSBhZGp1c3RtZW50LCB0cnVlKTsNCj4gDQo+IE9LDQo+ID4gICAgICAg
YWRqdXN0X3RzY19vZmZzZXRfZ3Vlc3QodmNwdSwgYWRqdXN0bWVudCk7DQo+ID4gIH0NCj4gPiAN
Cj4gPiBAQCAtMjc4MCw3ICsyNzg0LDcgQEAgc3RhdGljIGludCBrdm1fZ3Vlc3RfdGltZV91cGRh
dGUoc3RydWN0IGt2bV92Y3B1ICp2KQ0KPiA+ICAgICAgIC8qIFdpdGggYWxsIHRoZSBpbmZvIHdl
IGdvdCwgZmlsbCBpbiB0aGUgdmFsdWVzICovDQo+ID4gDQo+ID4gICAgICAgaWYgKGt2bV9oYXNf
dHNjX2NvbnRyb2wpDQo+ID4gLSAgICAgICAgICAgICB0Z3RfdHNjX2toeiA9IGt2bV9zY2FsZV90
c2ModiwgdGd0X3RzY19raHopOw0KPiA+ICsgICAgICAgICAgICAgdGd0X3RzY19raHogPSBrdm1f
c2NhbGVfdHNjKHYsIHRndF90c2Nfa2h6LCB0cnVlKTsNCj4gDQo+IE9LIChrdm1jbG9jayBpcyBm
b3IgTDEgb25seSwgTDEgaHlwZXJ2aXNvciBpcyBmcmVlIHRvIGV4cG9zZSBpdHMgb3duIGt2bWNs
b2NrIHRvIEwyKQ0KPiA+IA0KPiA+ICAgICAgIGlmICh1bmxpa2VseSh2Y3B1LT5od190c2Nfa2h6
ICE9IHRndF90c2Nfa2h6KSkgew0KPiA+ICAgICAgICAgICAgICAga3ZtX2dldF90aW1lX3NjYWxl
KE5TRUNfUEVSX1NFQywgdGd0X3RzY19raHogKiAxMDAwTEwsDQo+ID4gQEAgLTM0NzQsNyArMzQ3
OCw4IEBAIGludCBrdm1fZ2V0X21zcl9jb21tb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1
Y3QgbXNyX2RhdGEgKm1zcl9pbmZvKQ0KPiA+ICAgICAgICAgICAgICAgdTY0IHRzY19vZmZzZXQg
PSBtc3JfaW5mby0+aG9zdF9pbml0aWF0ZWQgPyB2Y3B1LT5hcmNoLmwxX3RzY19vZmZzZXQgOg0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB2Y3B1LT5hcmNoLnRzY19vZmZzZXQ7DQo+ID4gDQo+ID4gLSAgICAgICAgICAgICBtc3Jf
aW5mby0+ZGF0YSA9IGt2bV9zY2FsZV90c2ModmNwdSwgcmR0c2MoKSkgKyB0c2Nfb2Zmc2V0Ow0K
PiA+ICsgICAgICAgICAgICAgbXNyX2luZm8tPmRhdGEgPSBrdm1fc2NhbGVfdHNjKHZjcHUsIHJk
dHNjKCksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
bXNyX2luZm8tPmhvc3RfaW5pdGlhdGVkKSArIHRzY19vZmZzZXQ7DQo+IA0KPiBTaW5jZSB3ZSBu
b3cgZG8gdHdvIHRoaW5ncyB0aGF0IGRlcGVuZCBvbiBtc3JfaW5mby0+aG9zdF9pbml0aWF0ZWQs
IEkNCj4gdGhpbmsgSSB3b3VsZCBwcmVmZXIgdG8gY29udmVydCB0aGlzIGJhY2sgdG8gcmVndWxh
ciAnaWYnLg0KPiBJIGRvbid0IGhhdmUgYSBzdHJvbmcgb3BpbmlvbiBvbiB0aGlzIHRob3VnaC4N
Cj4gDQoNCkFncmVlZC4NCg0KVGhhbmtzIQ0KDQpJbGlhcw0KDQo+IA0KPiA+ICAgICAgICAgICAg
ICAgYnJlYWs7DQo+ID4gICAgICAgfQ0KPiA+ICAgICAgIGNhc2UgTVNSX01UUlJjYXA6DQo+IA0K
PiANCj4gQmVzdCByZWdhcmRzLA0KPiAgICAgICAgIE1heGltIExldml0c2t5DQo+IA0KPiANCg==
