Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB12D98E1
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 14:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439670AbgLNNdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 08:33:37 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:63345 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407994AbgLNNd2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 08:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1607952806; x=1639488806;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=OJReaFBOm57ptAWHbfUPKcij7HfouCnChGEUVkVoJ1s=;
  b=tezrtVqNvKOdwGkdk7Ts5iQ+3WawoMq15Awm6YvY94y7cASwAp3u9EgG
   8vLH6vtrRizVij6YGSkGjXDnTJ4GI092tcCXKrFKLwZn6jGcqqt7YrRNm
   YKv4jtLs61bTdyj/cmhDDk2CShCIyKY7oXR+UiCVZYqZnMJpLfiXiGUi1
   c=;
X-IronPort-AV: E=Sophos;i="5.78,418,1599523200"; 
   d="scan'208";a="69224097"
Subject: RE: [PATCH v3 17/17] KVM: x86/xen: Add event channel interrupt vector upcall
Thread-Topic: [PATCH v3 17/17] KVM: x86/xen: Add event channel interrupt vector upcall
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 14 Dec 2020 13:32:38 +0000
Received: from EX13D02EUC004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id C2925A21FD;
        Mon, 14 Dec 2020 13:32:36 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D02EUC004.ant.amazon.com (10.43.164.117) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 13:32:35 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.006;
 Mon, 14 Dec 2020 13:32:35 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Aslanidis (AWS), Ioannis" <iaslan@amazon.de>,
        "Agache, Alexandru" <aagch@amazon.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Thread-Index: AQHW0fXAY3qctFUabkWCPdAN/HSThqn2k5sAgAADGFA=
Date:   Mon, 14 Dec 2020 13:32:35 +0000
Message-ID: <f6d3b496773f4c85a4ffd595aeb593ae@EX13D32EUC003.ant.amazon.com>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-18-dwmw2@infradead.org>
 <3917aa37-ed00-9350-1ba5-c3390be6b500@oracle.com>
In-Reply-To: <3917aa37-ed00-9350-1ba5-c3390be6b500@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.145]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FvIE1hcnRpbnMgPGpvYW8u
bS5tYXJ0aW5zQG9yYWNsZS5jb20+DQo+IFNlbnQ6IDE0IERlY2VtYmVyIDIwMjAgMTM6MjANCj4g
VG86IERhdmlkIFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz4NCj4gQ2M6IFBhb2xvIEJv
bnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+OyBBbmt1ciBBcm9yYSA8YW5rdXIuYS5hcm9yYUBv
cmFjbGUuY29tPjsgQm9yaXMgT3N0cm92c2t5DQo+IDxib3Jpcy5vc3Ryb3Zza3lAb3JhY2xlLmNv
bT47IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPjsgR3JhZiAoQVdTKSwg
QWxleGFuZGVyDQo+IDxncmFmQGFtYXpvbi5kZT47IEFzbGFuaWRpcyAoQVdTKSwgSW9hbm5pcyA8
aWFzbGFuQGFtYXpvbi5kZT47IER1cnJhbnQsIFBhdWwgPHBkdXJyYW50QGFtYXpvbi5jby51az47
DQo+IEFnYWNoZSwgQWxleGFuZHJ1IDxhYWdjaEBhbWF6b24uY29tPjsgRmxvcmVzY3UsIEFuZHJl
ZWEgPGZhbmRyZWVAYW1hem9uLmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UkU6IFtFWFRFUk5BTF0gW1BBVENIIHYzIDE3LzE3XSBLVk06IHg4Ni94ZW46IEFkZCBldmVudCBj
aGFubmVsIGludGVycnVwdCB2ZWN0b3IgdXBjYWxsDQo+IA0KPiBDQVVUSU9OOiBUaGlzIGVtYWls
IG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGlj
ayBsaW5rcyBvciBvcGVuDQo+IGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhl
IHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IA0KPiBPbiAx
Mi8xNC8yMCA4OjM5IEFNLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6DQo+ID4gZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+IGluZGV4IGRmNDRk
OWU1MGFkYy4uZTYyNzEzOWNmOGNkIDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS94ODYu
Yw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPiA+IEBAIC04ODk2LDcgKzg4OTYsOCBA
QCBzdGF0aWMgaW50IHZjcHVfZW50ZXJfZ3Vlc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiA+
ICAgICAgICAgICAgICAgICAgICAgICBrdm1feDg2X29wcy5tc3JfZmlsdGVyX2NoYW5nZWQodmNw
dSk7DQo+ID4gICAgICAgfQ0KPiA+DQo+ID4gLSAgICAgaWYgKGt2bV9jaGVja19yZXF1ZXN0KEtW
TV9SRVFfRVZFTlQsIHZjcHUpIHx8IHJlcV9pbnRfd2luKSB7DQo+ID4gKyAgICAgaWYgKGt2bV9j
aGVja19yZXF1ZXN0KEtWTV9SRVFfRVZFTlQsIHZjcHUpIHx8IHJlcV9pbnRfd2luIHx8DQo+ID4g
KyAgICAgICAgIGt2bV94ZW5faGFzX2ludGVycnVwdCh2Y3B1KSkgew0KPiA+ICAgICAgICAgICAg
ICAgKyt2Y3B1LT5zdGF0LnJlcV9ldmVudDsNCj4gPiAgICAgICAgICAgICAgIGt2bV9hcGljX2Fj
Y2VwdF9ldmVudHModmNwdSk7DQo+ID4gICAgICAgICAgICAgICBpZiAodmNwdS0+YXJjaC5tcF9z
dGF0ZSA9PSBLVk1fTVBfU1RBVEVfSU5JVF9SRUNFSVZFRCkgew0KPiA+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0veGVuLmMgYi9hcmNoL3g4Ni9rdm0veGVuLmMNCj4gPiBpbmRleCAxN2NiYjQ0
NjJiN2UuLjRiYzlkYTlmY2ZiOCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0veGVuLmMN
Cj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veGVuLmMNCj4gPiBAQCAtMTc2LDYgKzE3Niw0NSBAQCB2
b2lkIGt2bV94ZW5fc2V0dXBfcnVuc3RhdGVfcGFnZShzdHJ1Y3Qga3ZtX3ZjcHUgKnYpDQo+ID4g
ICAgICAga3ZtX3hlbl91cGRhdGVfcnVuc3RhdGUodiwgUlVOU1RBVEVfcnVubmluZywgc3RlYWxf
dGltZSk7DQo+ID4gIH0NCj4gPg0KPiA+ICtpbnQga3ZtX3hlbl9oYXNfaW50ZXJydXB0KHN0cnVj
dCBrdm1fdmNwdSAqdikNCj4gPiArew0KPiA+ICsgICAgIHU4IHJjID0gMDsNCj4gPiArDQo+ID4g
KyAgICAgLyoNCj4gPiArICAgICAgKiBJZiB0aGUgZ2xvYmFsIHVwY2FsbCB2ZWN0b3IgKEhWTUlS
UV9jYWxsYmFja192ZWN0b3IpIGlzIHNldCBhbmQNCj4gPiArICAgICAgKiB0aGUgdkNQVSdzIGV2
dGNobl91cGNhbGxfcGVuZGluZyBmbGFnIGlzIHNldCwgdGhlIElSUSBpcyBwZW5kaW5nLg0KPiA+
ICsgICAgICAqLw0KPiA+ICsgICAgIGlmICh2LT5hcmNoLnhlbi52Y3B1X2luZm9fc2V0ICYmIHYt
Pmt2bS0+YXJjaC54ZW4udXBjYWxsX3ZlY3Rvcikgew0KPiA+ICsgICAgICAgICAgICAgc3RydWN0
IGdmbl90b19odmFfY2FjaGUgKmdoYyA9ICZ2LT5hcmNoLnhlbi52Y3B1X2luZm9fY2FjaGU7DQo+
ID4gKyAgICAgICAgICAgICBzdHJ1Y3Qga3ZtX21lbXNsb3RzICpzbG90cyA9IGt2bV9tZW1zbG90
cyh2LT5rdm0pOw0KPiA+ICsgICAgICAgICAgICAgdW5zaWduZWQgaW50IG9mZnNldCA9IG9mZnNl
dG9mKHN0cnVjdCB2Y3B1X2luZm8sIGV2dGNobl91cGNhbGxfcGVuZGluZyk7DQo+ID4gKw0KPiAN
Cj4gVG8gaGF2ZSBsZXNzIG5lc3RpbmcsIHdvdWxkbid0IGl0IGJlIGJldHRlciB0byBpbnZlcnQg
dGhlIGxvZ2ljPw0KPiANCj4gc2F5Og0KPiANCj4gICAgICAgICB1OCByYyA9IDA7DQo+ICAgICAg
ICAgc3RydWN0IGdmbl90b19odmFfY2FjaGUgKmdoYw0KPiAgICAgICAgIHN0cnVjdCBrdm1fbWVt
c2xvdHMgKnNsb3RzOw0KPiAgICAgICAgIHVuc2lnbmVkIGludCBvZmZzZXQ7DQo+IA0KPiANCj4g
ICAgICAgICBpZiAoIXYtPmFyY2gueGVuLnZjcHVfaW5mb19zZXQgfHwgIXYtPmt2bS0+YXJjaC54
ZW4udXBjYWxsX3ZlY3RvcikNCj4gICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiANCj4gICAg
ICAgICBCVUlMRF9CVUdfT04oLi4uKQ0KPiANCj4gICAgICAgICBnaGMgPSAmdi0+YXJjaC54ZW4u
dmNwdV9pbmZvX2NhY2hlOw0KPiAgICAgICAgIHNsb3RzID0ga3ZtX21lbXNsb3RzKHYtPmt2bSk7
DQo+ICAgICAgICAgb2Zmc2V0ID0gb2Zmc2V0b2Yoc3RydWN0IHZjcHVfaW5mbywgZXZ0Y2huX3Vw
Y2FsbF9wZW5kaW5nKTsNCj4gDQo+IEJ1dCBJIHRoaW5rIHRoZXJlJ3MgYSBmbGF3IGhlcmUuIFRo
YXQgaXMgaGFuZGxpbmcgdGhlIGNhc2Ugd2hlcmUgeW91IGRvbid0IGhhdmUgYQ0KPiB2Y3B1X2lu
Zm8gcmVnaXN0ZXJlZCwgYW5kIG9ubHkgc2hhcmVkIGluZm8uIFRoZSB2Y3B1X2luZm8gaXMgdGhl
biBwbGFjZWQgZWxzZXdoZXJlLCBpLmUuDQo+IGFub3RoZXIgb2Zmc2V0IG91dCBvZiBzaGFyZWRf
aW5mbyAtLSB3aGljaCBpcyAqSSB0aGluayogdGhlIGNhc2UgZm9yIFBWSFZNIFdpbmRvd3MgZ3Vl
c3RzLg0KDQpPbmx5IGJlZW4gdHJ1ZSBmb3IgV2luZG93cyBmb3IgYWJvdXQgYSB3ZWVrIDstKQ0K
DQogIFBhdWwNCg0KPiANCj4gUGVyaGFwcyBpbnRyb2R1Y2luZyBhIGhlbHBlciB3aGljaCBhZGRz
IHhlbl92Y3B1X2luZm8oKSBhbmQgcmV0dXJucyB5b3UgdGhlIGh2YSAocGlja2luZw0KPiB0aGUg
cmlnaHQgY2FjaGUpIHNpbWlsYXIgdG8gdGhlIFJGQyBwYXRjaC4gQWxiZWl0IHRoYXQgd2FzIHdp
dGggcGFnZSBwaW5uaW5nLCBidXQNCj4gYm9ycm93aW5nIGFuIG9sZGVyIHZlcnNpb24gSSBoYWQg
d2l0aCBodmFfdG9fZ2ZuX2NhY2hlIGluY2FudGF0aW9uIHdvdWxkIHByb2JhYmx5IGxvb2sgbGlr
ZToNCj4gDQo+IA0KPiAgICAgICAgIGlmICh2LT5hcmNoLnhlbi52Y3B1X2luZm9fc2V0KSB7DQo+
ICAgICAgICAgICAgICAgICBnaGMgPSAmdi0+YXJjaC54ZW4udmNwdV9pbmZvX2NhY2hlOw0KPiAg
ICAgICAgIH0gZWxzZSB7DQo+ICAgICAgICAgICAgICAgICBnaGMgPSAmdi0+YXJjaC54ZW4udmNw
dV9pbmZvX2NhY2hlOw0KPiAgICAgICAgICAgICAgICAgb2Zmc2V0ICs9IG9mZnNldG9mKHN0cnVj
dCBzaGFyZWRfaW5mbywgdmNwdV9pbmZvKTsNCj4gICAgICAgICAgICAgICAgIG9mZnNldCArPSAo
diAtIGt2bV9nZXRfdmNwdV9ieV9pZCgwKSkgKiBzaXplb2Yoc3RydWN0IHZjcHVfaW5mbyk7DQo+
ICAgICAgICAgfQ0KPiANCj4gICAgICAgICBpZiAobGlrZWx5KHNsb3RzLT5nZW5lcmF0aW9uID09
IGdoYy0+Z2VuZXJhdGlvbiAmJg0KPiAgICAgICAgICAgICAgICAgICAgIWt2bV9pc19lcnJvcl9o
dmEoZ2hjLT5odmEpICYmIGdoYy0+bWVtc2xvdCkpIHsNCj4gICAgICAgICAgICAgICAgIC8qIEZh
c3QgcGF0aCAqLw0KPiAgICAgICAgICAgICAgICAgX19nZXRfdXNlcihyYywgKHU4IF9fdXNlciAq
KWdoYy0+aHZhICsgb2Zmc2V0KTsNCj4gICAgICAgICB9IGVsc2Ugew0KPiAgICAgICAgICAgICAg
ICAgLyogU2xvdyBwYXRoICovDQo+ICAgICAgICAgICAgICAgICBrdm1fcmVhZF9ndWVzdF9vZmZz
ZXRfY2FjaGVkKHYtPmt2bSwgZ2hjLCAmcmMsIG9mZnNldCwNCj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc2l6ZW9mKHJjKSk7DQo+ICAgICAgICAgfQ0KPiAN
Cj4gID8NCj4gDQo+ICAgICAgICAgSm9hbw0K
