Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66045439798
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhJYNc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 09:32:58 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:40701 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhJYNc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 09:32:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1635168635; x=1666704635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:mime-version:
   content-transfer-encoding;
  bh=gNBIVVVpY3C3K53efuFP2H+Pv9kFnthtmpKuHaHmIA4=;
  b=Hn8GJflCg/Gn/UjzBvUEeYU4ywDe2abfOSTqp5JjBpAEMyy3cEo+gcwL
   ywFkf/z5TcQVameFgqKf4+K7C3MwkTAoTsqwtbINQfn8i/K+lc92BhyOZ
   xw1BE7ngpwdUmZt3HDDHwhxPcftkvHdSD1ZPAB4vzWRdI8s+OxPmO9oIX
   M=;
X-IronPort-AV: E=Sophos;i="5.87,180,1631577600"; 
   d="scan'208";a="151717139"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 25 Oct 2021 13:30:26 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-b09ea7fa.us-west-2.amazon.com (Postfix) with ESMTPS id 99B564268E;
        Mon, 25 Oct 2021 13:30:25 +0000 (UTC)
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Mon, 25 Oct 2021 13:30:24 +0000
Received: from EX13D08UEE001.ant.amazon.com (10.43.62.126) by
 EX13D08UEE001.ant.amazon.com (10.43.62.126) with Microsoft SMTP Server (TLS)
 id 15.0.1497.24; Mon, 25 Oct 2021 13:30:24 +0000
Received: from EX13D08UEE001.ant.amazon.com ([10.43.62.126]) by
 EX13D08UEE001.ant.amazon.com ([10.43.62.126]) with mapi id 15.00.1497.024;
 Mon, 25 Oct 2021 13:30:24 +0000
From:   "Woodhouse, David" <dwmw@amazon.co.uk>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jmattson@google.com" <jmattson@google.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>
Subject: Re: [PATCH] KVM: x86/xen: Fix runstate updates to be atomic when
 preempting vCPU
Thread-Topic: [PATCH] KVM: x86/xen: Fix runstate updates to be atomic when
 preempting vCPU
Thread-Index: AQHXyaR37IdP8RXfykGCc2u+63CPQg==
Date:   Mon, 25 Oct 2021 13:30:24 +0000
Message-ID: <5869684ac49c205ae3b744bb1fece20409d3f175.camel@amazon.co.uk>
References: <3d2a13164cbc61142b16edba85960db9a381bebe.camel@amazon.co.uk>
         <e5db0fcc-f4a0-b12a-d75e-5f9c4f746126@redhat.com>
In-Reply-To: <e5db0fcc-f4a0-b12a-d75e-5f9c4f746126@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.62.122]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B8893A816C260448E8CF73F1889AE21@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gTW9uLCAyMDIxLTEwLTI1IGF0IDEzOjQzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyMy8xMC8yMSAyMTo0NywgV29vZGhvdXNlLCBEYXZpZCB3cm90ZToNCj4gPiAgIAlCVUlM
RF9CVUdfT04oc2l6ZW9mKCgoc3RydWN0IHZjcHVfcnVuc3RhdGVfaW5mbyAqKTApLT5zdGF0ZSkg
IT0NCj4gPiAgIAkJICAgICBzaXplb2YodngtPmN1cnJlbnRfcnVuc3RhdGUpKTsNCj4gPiAgIAlC
VUlMRF9CVUdfT04oc2l6ZW9mKCgoc3RydWN0IGNvbXBhdF92Y3B1X3J1bnN0YXRlX2luZm8gKikw
KS0+c3RhdGUpICE9DQo+ID4gICAJCSAgICAgc2l6ZW9mKHZ4LT5jdXJyZW50X3J1bnN0YXRlKSk7
DQo+IA0KPiBXZSBjYW4gYWxzbyB1c2Ugc2l6ZW9mX2ZpZWxkIGhlcmUsIHdoaWxlIHlvdSdyZSBh
dCBpdCAoc2VwYXJhdGUgcGF0Y2gsIA0KPiB0aG91Z2gpLg0KDQpBY2suIEknbSBhYm91dCB0byB3
b3JrIG9uIGV2ZW50IGNoYW5uZWwgZGVsaXZlcnkgZnJvbSB3aXRoaW4gdGhlDQprZXJuZWwsIHNv
IEknbGwgZG8gc28gYXMgcGFydCBvZiB0aGF0IHNlcmllcy4NCg0KVGhhbmtzLg0KCgoKQW1hem9u
IERldmVsb3BtZW50IENlbnRyZSAoTG9uZG9uKSBMdGQuIFJlZ2lzdGVyZWQgaW4gRW5nbGFuZCBh
bmQgV2FsZXMgd2l0aCByZWdpc3RyYXRpb24gbnVtYmVyIDA0NTQzMjMyIHdpdGggaXRzIHJlZ2lz
dGVyZWQgb2ZmaWNlIGF0IDEgUHJpbmNpcGFsIFBsYWNlLCBXb3JzaGlwIFN0cmVldCwgTG9uZG9u
IEVDMkEgMkZBLCBVbml0ZWQgS2luZ2RvbS4KCgo=

