Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1C3889ED
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhESI4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:56:20 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:39191 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhESI4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 04:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1621414501; x=1652950501;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Io1xrxf97DwHIsMb4dT2TrJXA7kKP3n6iNjtOzGzI80=;
  b=LEatEKZ2eBeJp30wS2IDq8/UNUcP1+n2KYeEZFJaWx14+mC4poRTI5p4
   wepjm3Bk5JjQaJpVoOAx3W1GDzMerVKTOb3gpTuH/6mkqLwq/xvspVOmi
   VQKhaOBKwDwqFoyto0vRbGljpxQrQw+LvoanzOy5vOrpYq03axID6+4rV
   c=;
X-IronPort-AV: E=Sophos;i="5.82,312,1613433600"; 
   d="scan'208";a="110205524"
Subject: Re: [PATCH v2 02/10] KVM: X86: Store L1's TSC scaling ratio in 'struct
 kvm_vcpu_arch'
Thread-Topic: [PATCH v2 02/10] KVM: X86: Store L1's TSC scaling ratio in 'struct
 kvm_vcpu_arch'
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 19 May 2021 08:54:52 +0000
Received: from EX13MTAUEE001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 909F8A1822;
        Wed, 19 May 2021 08:54:51 +0000 (UTC)
Received: from EX13D08UEE004.ant.amazon.com (10.43.62.182) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.200) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 19 May 2021 08:54:50 +0000
Received: from EX13D18EUA001.ant.amazon.com (10.43.165.58) by
 EX13D08UEE004.ant.amazon.com (10.43.62.182) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Wed, 19 May 2021 08:54:50 +0000
Received: from EX13D18EUA001.ant.amazon.com ([10.43.165.58]) by
 EX13D18EUA001.ant.amazon.com ([10.43.165.58]) with mapi id 15.00.1497.018;
 Wed, 19 May 2021 08:54:49 +0000
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
Thread-Index: AQHXR0EodBzfPWtL4kyOSaA1r4vfJKrp4pSAgACoKYA=
Date:   Wed, 19 May 2021 08:54:49 +0000
Message-ID: <b3f785d4dccf7f8235103f85d814be34c51987e6.camel@amazon.com>
References: <20210512150945.4591-1-ilstam@amazon.com>
         <20210512150945.4591-3-ilstam@amazon.com> <YKRFSaktB4+tgFUH@google.com>
In-Reply-To: <YKRFSaktB4+tgFUH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.129]
Content-Type: text/plain; charset="utf-8"
Content-ID: <B247DC1AF064FE438F89234BA47D339A@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTA1LTE4IGF0IDIyOjUyICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAxMiwgMjAyMSwgSWxpYXMgU3RhbWF0aXMgd3JvdGU6DQo+ID4g
U3RvcmUgTDEncyBzY2FsaW5nIHJhdGlvIGluIHRoYXQgc3RydWN0IGxpa2Ugd2UgYWxyZWFkeSBk
byBmb3IgTDEncyBUU0MNCj4gDQo+IHMvdGhhdCBzdHJ1Y3Qva3ZtX3ZjcHVfYXJjaC4gIEZvcmNp
bmcgdGhlIHJlYWRlciB0byBsb29rIGF0IHRoZSBzdWJqZWN0IHRvDQo+IHVuZGVyc3RhbmQgdGhl
IGNoYW5nZWxvZyBpcyBhbm5veWluZywgZXNwZWNpYWxseSB3aGVuIGl0IHNhdmVzIGFsbCBvZiBh
IGhhbmRmdWwNCj4gb2YgY2hhcmFjdGVycy4gIEUuZy4gSSBvZnRlbiByZWFkIHBhdGNoZXMgd2l0
aG91dCB0aGUgc3ViamVjdCBpbiBzY29wZS4NCj4gDQo+ID4gb2Zmc2V0LiBUaGlzIGFsbG93cyBm
b3IgZWFzeSBzYXZlL3Jlc3RvcmUgd2hlbiB3ZSBlbnRlciBhbmQgdGhlbiBleGl0DQo+ID4gdGhl
IG5lc3RlZCBndWVzdC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBJbGlhcyBTdGFtYXRpcyA8
aWxzdGFtQGFtYXpvbi5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IE1heGltIExldml0c2t5IDxtbGV2
aXRza0ByZWRoYXQuY29tPg0KPiA+IC0tLQ0KPiANCj4gLi4uDQo+IA0KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBpbmRleCA5YjZi
Y2E2MTY5MjkuLjA3Y2Y1ZDdlY2UzOCAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2
LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiBAQCAtMjE4NSw2ICsyMTg1LDcg
QEAgc3RhdGljIGludCBzZXRfdHNjX2toeihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiB1c2Vy
X3RzY19raHosIGJvb2wgc2NhbGUpDQo+ID4gDQo+ID4gICAgICAgLyogR3Vlc3QgVFNDIHNhbWUg
ZnJlcXVlbmN5IGFzIGhvc3QgVFNDPyAqLw0KPiA+ICAgICAgIGlmICghc2NhbGUpIHsNCj4gPiAr
ICAgICAgICAgICAgIHZjcHUtPmFyY2gubDFfdHNjX3NjYWxpbmdfcmF0aW8gPSBrdm1fZGVmYXVs
dF90c2Nfc2NhbGluZ19yYXRpbzsNCj4gPiAgICAgICAgICAgICAgIHZjcHUtPmFyY2gudHNjX3Nj
YWxpbmdfcmF0aW8gPSBrdm1fZGVmYXVsdF90c2Nfc2NhbGluZ19yYXRpbzsNCj4gDQo+IExvb2tz
IGxpa2UgdGhlc2UgYXJlIGFsd2F5cyBzZXQgYXMgYSBwYWlyLCBtYXliZSBhZGQgYSBoZWxwZXIs
IGUuZy4NCj4gDQo+IHN0YXRpYyB2b2lkIGt2bV9zZXRfbDFfdHNjX3NjYWxpbmdfcmF0aW8odTY0
IHJhdGlvKQ0KPiB7DQo+ICAgICAgICAgdmNwdS0+YXJjaC5sMV90c2Nfc2NhbGluZ19yYXRpbyA9
IHJhdGlvOw0KPiAgICAgICAgIHZjcHUtPmFyY2gudHNjX3NjYWxpbmdfcmF0aW8gPSByYXRpbzsN
Cj4gfQ0KPiANCg0KSG1tLCB0aGV5IGFyZSBub3QgKmFsd2F5cyogc2V0IGFzIGEgcGFpci4gUGx1
cyB3b3VsZG4ndCB0aGlzIG5hbWUgYmUgYSBiaXQNCm1pc2xlYWRpbmcgc3VnZ2VzdGluZyB0aGF0
IEwxJ3Mgc2NhbGluZyByYXRpbyBpcyB1cGRhdGVkIGJ1dCBpbXBsaWNpdGx5DQpjaGFuZ2luZyB0
aGUgY3VycmVudCByYXRpbyB0b28/IA0KDQpJJ20gbm90IHN1cmUgYSBoZWxwZXIgZnVuY3Rpb24g
d291bGQgYWRkIG11Y2gNCnZhbHVlIGhlcmUuDQoNCj4gPiAgICAgICAgICAgICAgIHJldHVybiAw
Ow0KPiA+ICAgICAgIH0NCj4gPiBAQCAtMjIxMSw3ICsyMjEyLDcgQEAgc3RhdGljIGludCBzZXRf
dHNjX2toeihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHUzMiB1c2VyX3RzY19raHosIGJvb2wgc2Nh
bGUpDQo+ID4gICAgICAgICAgICAgICByZXR1cm4gLTE7DQo+ID4gICAgICAgfQ0KPiA+IA0KPiA+
IC0gICAgIHZjcHUtPmFyY2gudHNjX3NjYWxpbmdfcmF0aW8gPSByYXRpbzsNCj4gPiArICAgICB2
Y3B1LT5hcmNoLmwxX3RzY19zY2FsaW5nX3JhdGlvID0gdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19y
YXRpbyA9IHJhdGlvOw0KPiA+ICAgICAgIHJldHVybiAwOw0KPiA+ICB9DQo+ID4gDQo+ID4gQEAg
LTIyMjMsNiArMjIyNCw3IEBAIHN0YXRpYyBpbnQga3ZtX3NldF90c2Nfa2h6KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgdTMyIHVzZXJfdHNjX2toeikNCj4gPiAgICAgICAvKiB0c2Nfa2h6IGNhbiBi
ZSB6ZXJvIGlmIFRTQyBjYWxpYnJhdGlvbiBmYWlscyAqLw0KPiA+ICAgICAgIGlmICh1c2VyX3Rz
Y19raHogPT0gMCkgew0KPiA+ICAgICAgICAgICAgICAgLyogc2V0IHRzY19zY2FsaW5nX3JhdGlv
IHRvIGEgc2FmZSB2YWx1ZSAqLw0KPiA+ICsgICAgICAgICAgICAgdmNwdS0+YXJjaC5sMV90c2Nf
c2NhbGluZ19yYXRpbyA9IGt2bV9kZWZhdWx0X3RzY19zY2FsaW5nX3JhdGlvOw0KPiA+ICAgICAg
ICAgICAgICAgdmNwdS0+YXJjaC50c2Nfc2NhbGluZ19yYXRpbyA9IGt2bV9kZWZhdWx0X3RzY19z
Y2FsaW5nX3JhdGlvOw0KPiA+ICAgICAgICAgICAgICAgcmV0dXJuIC0xOw0KPiA+ICAgICAgIH0N
Cj4gPiBAQCAtMjQ1OSw3ICsyNDYxLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIGFkanVzdF90c2Nf
b2Zmc2V0X2d1ZXN0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiANCj4gPiAgc3RhdGljIGlu
bGluZSB2b2lkIGFkanVzdF90c2Nfb2Zmc2V0X2hvc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBz
NjQgYWRqdXN0bWVudCkNCj4gPiAgew0KPiA+IC0gICAgIGlmICh2Y3B1LT5hcmNoLnRzY19zY2Fs
aW5nX3JhdGlvICE9IGt2bV9kZWZhdWx0X3RzY19zY2FsaW5nX3JhdGlvKQ0KPiA+ICsgICAgIGlm
ICh2Y3B1LT5hcmNoLmwxX3RzY19zY2FsaW5nX3JhdGlvICE9IGt2bV9kZWZhdWx0X3RzY19zY2Fs
aW5nX3JhdGlvKQ0KPiA+ICAgICAgICAgICAgICAgV0FSTl9PTihhZGp1c3RtZW50IDwgMCk7DQo+
ID4gICAgICAgYWRqdXN0bWVudCA9IGt2bV9zY2FsZV90c2ModmNwdSwgKHU2NCkgYWRqdXN0bWVu
dCk7DQo+ID4gICAgICAgYWRqdXN0X3RzY19vZmZzZXRfZ3Vlc3QodmNwdSwgYWRqdXN0bWVudCk7
DQo+ID4gLS0NCj4gPiAyLjE3LjENCj4gPiANCg0K
