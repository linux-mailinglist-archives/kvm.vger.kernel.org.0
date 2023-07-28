Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1706D766565
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 09:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbjG1HcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 03:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjG1HcE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 03:32:04 -0400
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B4D2733
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 00:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1690529523; x=1722065523;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=8ejy6P2bBd0LhwiqvIcJEfKf41A6QsV8xDWjh4JMxWw=;
  b=bdWZh2pZvc/t99tUZ1vmnDhDTL2FETW0ACiRIvhcmymm+s7j53LVu1pP
   qxuNZng3Nk6OciGOoIHe0UnxTJ4kiDXDcbayjMmJIYMlHzIMB438Wzg9R
   JPF0egrMNChSpPkZ4rbmpbrIBzbvR9PNmArPE/YUAY3HsbotU9mb2AtbL
   k=;
X-IronPort-AV: E=Sophos;i="6.01,236,1684800000"; 
   d="scan'208";a="19134859"
Subject: RE: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Thread-Topic: [PATCH v3] KVM: x86/xen: Implement hvm_op/HVMOP_flush_tlbs hypercall
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2023 07:32:01 +0000
Received: from EX19D020EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id 85D9F8046C;
        Fri, 28 Jul 2023 07:31:58 +0000 (UTC)
Received: from EX19D043EUB002.ant.amazon.com (10.252.61.125) by
 EX19D020EUA003.ant.amazon.com (10.252.50.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 07:31:58 +0000
Received: from EX19D043EUB001.ant.amazon.com (10.252.61.24) by
 EX19D043EUB002.ant.amazon.com (10.252.61.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 07:31:57 +0000
Received: from EX19D043EUB001.ant.amazon.com ([fe80::e881:f31d:88bf:58d8]) by
 EX19D043EUB001.ant.amazon.com ([fe80::e881:f31d:88bf:58d8%4]) with mapi id
 15.02.1118.030; Fri, 28 Jul 2023 07:31:57 +0000
From:   "Kaya, Metin" <metikaya@amazon.co.uk>
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "paul@xen.org" <paul@xen.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>
Thread-Index: AQHZv/zTJE/XNJFp4kq8iGiflPNh7K/NhPIAgAFDMOA=
Date:   Fri, 28 Jul 2023 07:31:57 +0000
Message-ID: <617829a3b166423486bcb69884cc8894@amazon.co.uk>
References: <138f584bd86fe68aa05f20db3de80bae61880e11.camel@infradead.org>
         <20230418101306.98263-1-metikaya@amazon.co.uk>
         <ZHEXX/OG6suNGWPN@google.com>
         <9a58e731421edad45dff31e681b83f90c5e9775e.camel@infradead.org>
         <ZMF8/SUw5ebkDhde@google.com>
 <bbe3f0721e9f2965858b407afe638000f6b0d021.camel@infradead.org>
In-Reply-To: <bbe3f0721e9f2965858b407afe638000f6b0d021.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.51.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCBKdWwgMjcsIDIwMjMgYXQgMTowNCBQTSwgRGF2aWQgV29vZGhvdXNlIHdyb3RlOg0K
PiBPbiBXZWQsIDIwMjMtMDctMjYgYXQgMTM6MDcgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gT24gVHVlLCBKdWwgMjUsIDIwMjMsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToN
Cj4gPiA+IE9uIEZyaSwgMjAyMy0wNS0yNiBhdCAxMzozMiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhl
cnNvbiB3cm90ZToNCj4gPiA+ID4gICA6IEFoYSEgIEFuZCBRRU1VIGFwcGVhcnMgdG8gaGF2ZSBY
ZW4gZW11bGF0aW9uIHN1cHBvcnQuICBUaGF0IG1lYW5zIEtWTS1Vbml0LVRlc3RzDQo+ID4gPiA+
ICAgOiBpcyBhbiBvcHRpb24uICBTcGVjaWZpY2FsbHksIGV4dGVuZCB0aGUgImFjY2VzcyIgdGVz
dCB0byB1c2UgdGhpcyBoeXBlcmNhbGwgaW5zdGVhZA0KPiA+ID4gPiAgIDogb2YgSU5WTFBHLiAg
VGhhdCdsbCB2ZXJpZnkgdGhhdCB0aGUgZmx1c2ggaXMgYWN0dWFsbHkgYmVpbmcgcGVyZm9ybWVk
IGFzIGV4cHRlY2VkLg0KPiA+ID4NCj4gPiA+IFRoYXQgd29ya3MuIE1ldGluIGhhcyBhIGJldHRl
ciB2ZXJzaW9uIHRoYXQgYWN0dWFsbHkgc2V0cyB1cCB0aGUNCj4gPiA+IGh5cGVyY2FsbCBwYWdl
IHByb3Blcmx5IGFuZCB1c2VzIGl0LCBidXQgdGhhdCBvbmUgYmFpbHMgb3V0IHdoZW4gWGVuDQo+
ID4gPiBzdXBwb3J0IGlzbid0IHByZXNlbnQsIGFuZCBkb2Vzbid0IHNob3cgdGhlIGZhaWx1cmUg
bW9kZSBxdWl0ZSBzbw0KPiA+ID4gY2xlYXJseS4gVGhpcyBpcyB0aGUgc2ltcGxlIHZlcnNpb246
DQo+ID4NCj4gPiBJSVVDLCB5J2FsbCBoYXZlIGFscmVhZHkgd3JpdHRlbiBib3RoIHRlc3RzLCBz
byB3aHkgbm90IHBvc3QgYm90aD8gIEkgY2VydGFpbmx5DQo+ID4gd29uJ3Qgb2JqZWN0IHRvIG1v
cmUgdGVzdHMgaWYgdGhleSBwcm92aWRlIGRpZmZlcmVudCBjb3ZlcmFnZS4NCj4NCj4gWWVhaCwg
aXQganVzdCBuZWVkZWQgY2xlYW5pbmcgdXAuDQo+DQo+IFRoaXMgaXMgd2hhdCB3ZSBoYXZlOyBN
ZXRpbiB3aWxsIHN1Ym1pdCBpdCBmb3IgcmVhbCBhZnRlciBhIGxpdHRsZSBtb3JlDQo+IHBvbGlz
aGluZy4gSXQgbW9kaWZpZXMgdGhlIGV4aXN0aW5nIGFjY2VzcyB0ZXN0IHNvIHRoYXQgKmlmKiBp
dCdzIHJ1bg0KPiBpbiBhIFhlbiBlbnZpcm9ubWVudCwgYW5kICppZiogdGhlIEhWTU9QX2ZsdXNo
X3RsYnMgY2FsbCByZXR1cm5zDQo+IHN1Y2Nlc3MgaW5zdGVhZCBvZiAtRU5PU1lTLCBpdCdsbCB1
c2UgdGhhdCBpbnN0ZWFkIG9mIGludmxwZy4NCg0KUGF0Y2ggaXMgcG9zdGVkIHRvIGt2bS11bml0
LXRlc3RzOiBodHRwczovL21hcmMuaW5mby8/bD1rdm0mbT0xNjkwNTI4NjcwMjQxOTEmdz0yDQoN
Cj4gSW4gaXRzZWxmLCB0aGF0IGRvZXNuJ3QgZ2l2ZSB1cyBhbiBhdXRvbWF0aWMgcmVncmVzc2lv
biB0ZXN0cywgYmVjYXVzZQ0KPiB5b3Ugc3RpbGwgbmVlZCB0byBydW4gaXQgbWFudWFsbHkg4oCU
IGFzIGJlZm9yZSwNCj4gIHFlbXUtc3lzdGVtLXg4Nl82NCAtZGV2aWNlIGlzYS1kZWJ1Zy1leGl0
LGlvYmFzZT0weGY0LGlvc2l6ZT0weDQgLXZuYyBub25lIC1zZXJpYWwgc3RkaW8gLWRldmljZSBw
Y2ktdGVzdGRldiAtLWFjY2VsIGt2bSx4ZW4tdmVyc2lvbj0weDQwMDBhLGtlcm5lbC1pcnFjaGlw
PXNwbGl0ICAta2VybmVsIH4vYWNjZXNzX3Rlc3QuZmxhdA0KPg0KPiBJZiB3ZSByZWFsbHkgd2Fu
dCB0bywgd2UgY2FuIGxvb2sgYXQgbWFraW5nIGl0IHJ1biB0aGF0IHdheSB3aGVuIHFlbXUNCj4g
YW5kIHRoZSBob3N0IGtlcm5lbCBzdXBwb3J0IFhlbiBndWVzdHMuLi4/DQoNCg==
