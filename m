Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 645DF123B91
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 01:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfLRA3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 19:29:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:54081 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfLRA3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 19:29:22 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 16:29:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="209898680"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga008.jf.intel.com with ESMTP; 17 Dec 2019 16:29:21 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 17 Dec 2019 16:29:17 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 17 Dec 2019 16:29:17 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 17 Dec 2019 16:29:17 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.222]) with mapi id 14.03.0439.000;
 Wed, 18 Dec 2019 08:29:15 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Peter Xu <peterx@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory
 tracking
Thread-Topic: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory
 tracking
Thread-Index: AQHVpv0PhLjsXcMNH0yRgZXkCE4uD6emxQcAgAASdgCAAAmKgIABC3sAgABTNwCAAQD8gIAIoYgAgADM8YCAAGCGgIAAFT8AgAffHQCAARlPgIABgxAQgAB2wICAAANjAIABCzww
Date:   Wed, 18 Dec 2019 00:29:15 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D6487AB@SHSMSX104.ccr.corp.intel.com>
References: <20191202201036.GJ4063@linux.intel.com>
 <20191202211640.GF31681@xz-x1> <20191202215049.GB8120@linux.intel.com>
 <fd882b9f-e510-ff0d-db43-eced75427fc6@redhat.com>
 <20191203184600.GB19877@linux.intel.com>
 <374f18f1-0592-9b70-adbb-0a72cc77d426@redhat.com>
 <20191209215400.GA3352@xz-x1>
 <affd9d84-1b84-0c25-c431-a075c58c33dc@redhat.com>
 <20191210155259.GD3352@xz-x1>
 <3e6cb5ec-66c0-00ab-b75e-ad2beb1d216d@redhat.com>
 <20191215172124.GA83861@xz-x1>
 <f117d46a-7528-ce32-8e46-4f3f35937079@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D645E55@SHSMSX104.ccr.corp.intel.com>
 <20191217091837.744982d3@x1.home>
 <10cc6fc6-c837-1a1a-a344-df97793b5ff5@redhat.com>
In-Reply-To: <10cc6fc6-c837-1a1a-a344-df97793b5ff5@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWMzNjNiM2QtNjVjOS00NmRhLWE3NDItODkwNTg4NmYxNzBmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidEYzeGxQM1NXNUdReXlOV3JUUGw3T1U2aUYwanczVDlsXC9uellvMXo1bWUxampzNnM5UWhZTTRYWHFzWU9wdEcifQ==
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIERlY2VtYmVyIDE4LCAyMDE5IDEyOjMxIEFNDQo+IA0KPiBPbiAxNy8xMi8xOSAxNzox
OCwgQWxleCBXaWxsaWFtc29uIHdyb3RlOg0KPiA+Pg0KPiA+PiBBbGV4LCBpZiB5b3UgYXJlIE9L
IHdlJ2xsIHdvcmsgb24gc3VjaCBpbnRlcmZhY2UgYW5kIG1vdmUga3ZtZ3QgdG8gdXNlIGl0Lg0K
PiA+PiBBZnRlciBpdCdzIGFjY2VwdGVkLCB3ZSBjYW4gYWxzbyBtYXJrIHBhZ2VzIGRpcnR5IHRo
cm91Z2ggdGhpcyBuZXcNCj4gaW50ZXJmYWNlDQo+ID4+IGluIEtpcnRpJ3MgZGlydHkgcGFnZSB0
cmFja2luZyBzZXJpZXMuDQo+ID4gSSdtIG5vdCBzdXJlIHdoYXQgeW91J3JlIGFza2luZyBmb3Is
IGlzIGl0IGFuIGludGVyZmFjZSBmb3IgdGhlIGhvc3QNCj4gPiBDUFUgdG8gcmVhZC93cml0ZSB0
aGUgbWVtb3J5IGJhY2tpbmcgb2YgYSBtYXBwZWQgSU9WQSByYW5nZSB3aXRob3V0DQo+ID4gcGlu
bmluZyBwYWdlcz8gIFRoYXQgc2VlbXMgbGlrZSBzb21ldGhpbmcgbGlrZSB0aGF0IHdvdWxkIG1h
a2Ugc2Vuc2UgZm9yDQo+ID4gYW4gZW11bGF0aW9uIG1vZGVsIHdoZXJlIGEgcGFnZSBkb2VzIG5v
dCBuZWVkIHRvIGJlIHBpbm5lZCBmb3IgcGh5c2ljYWwNCj4gPiBETUEuICBJZiB5b3UncmUgYXNr
aW5nIG1vcmUgZm9yIGFuIGludGVyZmFjZSB0aGF0IHVuZGVyc3RhbmRzIHRoZQ0KPiA+IHVzZXJz
cGFjZSBkcml2ZXIgaXMgYSBWTSAoaWUuIGltcGxpZWQgdXNpbmcgYSBfZ3Vlc3QgcG9zdGZpeCBv
biB0aGUNCj4gPiBmdW5jdGlvbiBuYW1lKSBhbmQga25vd3MgYWJvdXQgR1BBIG1hcHBpbmdzIGJl
eW9uZCB0aGUgd2luZG93cw0KPiBkaXJlY3RseQ0KPiA+IG1hcHBlZCBmb3IgZGV2aWNlIGFjY2Vz
cywgSSdkIG5vdCBsb29rIGZvbmRseSBvbiBzdWNoIGEgcmVxdWVzdC4NCj4gDQo+IE5vLCBpdCB3
b3VsZCBkZWZpbml0ZWx5IGJlIHRoZSBmb3JtZXIsIHVzaW5nIElPVkFzIHRvIGFjY2VzcyBndWVz
dA0KPiBtZW1vcnktLS1rdm1ndCBpcyBjdXJyZW50bHkgZG9pbmcgdGhlIGxhdHRlciBieSBjYWxs
aW5nIGludG8gS1ZNLCBhbmQNCj4gSSdtIG5vdCByZWFsbHkgZm9uZCBvZiB0aGF0IGVpdGhlci4N
Cj4gDQoNCkV4YWN0bHkuIGxldCdzIHdvcmsgb24gdGhlIGZpeC4NCg0KVGhhbmtzDQpLZXZpbg0K
