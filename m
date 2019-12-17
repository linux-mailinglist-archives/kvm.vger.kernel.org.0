Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD1C1122385
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 06:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfLQFRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 00:17:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:44870 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfLQFRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 00:17:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 21:17:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,324,1571727600"; 
   d="scan'208";a="266469839"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Dec 2019 21:17:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 21:17:32 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 21:17:31 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 21:17:31 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.195]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 13:17:30 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     'Paolo Bonzini' <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: RE: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory
 tracking
Thread-Topic: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory
 tracking
Thread-Index: AQHVpv0PhLjsXcMNH0yRgZXkCE4uD6emxQcAgAASdgCAAAmKgIABC3sAgABTNwCAAQD8gIAIoYgAgADM8YCAAGCGgIAAFT8AgAffHQCAARlPgIABgxAQgABDsWA=
Date:   Tue, 17 Dec 2019 05:17:29 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D646148@SHSMSX104.ccr.corp.intel.com>
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
 <AADFC41AFE54684AB9EE6CBC0274A5D19D645E5F@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D645E5F@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjQ4ZWYwMjEtYTg2OS00MDllLTllZGMtZjdjZDkyMTJmMWVmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibWtHNnhSNlpVN1FnTjNtUzF5WG1lbVI4VWlyMVNpanJacmZpWDY3akhmdGR6eXhvd2JIdTJvUnJBZVZcL3VTR1QifQ==
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

PiBGcm9tOiBUaWFuLCBLZXZpbg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxNywgMjAxOSAx
MDoyOSBBTQ0KPiANCj4gPiBGcm9tOiBQYW9sbyBCb256aW5pDQo+ID4gU2VudDogTW9uZGF5LCBE
ZWNlbWJlciAxNiwgMjAxOSA2OjA4IFBNDQo+ID4NCj4gPiBbQWxleCBhbmQgS2V2aW46IHRoZXJl
IGFyZSBkb3VidHMgYmVsb3cgcmVnYXJkaW5nIGRpcnR5IHBhZ2UgdHJhY2tpbmcNCj4gPiBmcm9t
IFZGSU8gYW5kIG1kZXYgZGV2aWNlcywgd2hpY2ggcGVyaGFwcyB5b3UgY2FuIGhlbHAgd2l0aF0N
Cj4gPg0KPiA+IE9uIDE1LzEyLzE5IDE4OjIxLCBQZXRlciBYdSB3cm90ZToNCj4gPiA+ICAgICAg
ICAgICAgICAgICBpbml0X3Jtb2RlX3Rzcw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICB2bXhf
c2V0X3Rzc19hZGRyDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICBrdm1fdm1faW9jdGxf
c2V0X3Rzc19hZGRyIFsqXQ0KPiA+ID4gICAgICAgICAgICAgICAgIGluaXRfcm1vZGVfaWRlbnRp
dHlfbWFwDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgIHZteF9jcmVhdGVfdmNwdSBbKl0NCj4g
Pg0KPiA+IFRoZXNlIGRvbid0IG1hdHRlciBiZWNhdXNlIHRoZWlyIGNvbnRlbnQgaXMgbm90IHZp
c2libGUgdG8gdXNlcnNwYWNlDQo+ID4gKHRoZSBiYWNraW5nIHN0b3JhZ2UgaXMgbW1hcC1lZCBi
eSBfX3g4Nl9zZXRfbWVtb3J5X3JlZ2lvbikuICBJbiBmYWN0LCBkDQo+ID4NCj4gPiA+ICAgICAg
ICAgICAgICAgICB2bXhfd3JpdGVfcG1sX2J1ZmZlcg0KPiA+ID4gICAgICAgICAgICAgICAgICAg
ICBrdm1fYXJjaF93cml0ZV9sb2dfZGlydHkgWyZdDQo+ID4gPiAgICAgICAgICAgICAgICAga3Zt
X3dyaXRlX2d1ZXN0DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgIGt2bV9odl9zZXR1cF90c2Nf
cGFnZQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAga3ZtX2d1ZXN0X3RpbWVfdXBkYXRl
IFsmXQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICBuZXN0ZWRfZmx1c2hfY2FjaGVkX3NoYWRv
d192bWNzMTIgWyZdDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgIGt2bV93cml0ZV93YWxsX2Ns
b2NrIFsmXQ0KPiA+ID4gICAgICAgICAgICAgICAgICAgICBrdm1fcHZfY2xvY2tfcGFpcmluZyBb
Jl0NCj4gPiA+ICAgICAgICAgICAgICAgICAgICAga3ZtZ3RfcndfZ3BhIFs/XQ0KPiA+DQo+ID4g
VGhpcyB0aGVuIGV4cGFuZHMgKHBhcnRpYWxseSkgdG8NCj4gPg0KPiA+IGludGVsX2d2dF9oeXBl
cnZpc29yX3dyaXRlX2dwYQ0KPiA+ICAgICBlbXVsYXRlX2NzYl91cGRhdGUNCj4gPiAgICAgICAg
IGVtdWxhdGVfZXhlY2xpc3RfY3R4X3NjaGVkdWxlX291dA0KPiA+ICAgICAgICAgICAgIGNvbXBs
ZXRlX2V4ZWNsaXN0X3dvcmtsb2FkDQo+ID4gICAgICAgICAgICAgICAgIGNvbXBsZXRlX2N1cnJl
bnRfd29ya2xvYWQNCj4gPiAgICAgICAgICAgICAgICAgICAgICB3b3JrbG9hZF90aHJlYWQNCj4g
PiAgICAgICAgIGVtdWxhdGVfZXhlY2xpc3RfY3R4X3NjaGVkdWxlX2luDQo+ID4gICAgICAgICAg
ICAgcHJlcGFyZV9leGVjbGlzdF93b3JrbG9hZA0KPiA+ICAgICAgICAgICAgICAgICBwcmVwYXJl
X3dvcmtsb2FkDQo+ID4gICAgICAgICAgICAgICAgICAgICBkaXNwYXRjaF93b3JrbG9hZA0KPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgIHdvcmtsb2FkX3RocmVhZA0KPiA+DQo+ID4gU28gS1ZN
R1QgaXMgYWx3YXlzIHdyaXRpbmcgdG8gR1BBcyBpbnN0ZWFkIG9mIElPVkFzIGFuZCBiYXNpY2Fs
bHkNCj4gPiBieXBhc3NpbmcgYSBndWVzdCBJT01NVS4gIFNvIGhlcmUgaXQgd291bGQgYmUgYmV0
dGVyIGlmIGt2bWd0IHdhcw0KPiA+IGNoYW5nZWQgbm90IHVzZSBrdm1fd3JpdGVfZ3Vlc3QgKGFs
c28gYmVjYXVzZSBJJ2QgcHJvYmFibHkgaGF2ZSBuYWNrZWQNCj4gPiB0aGF0IGlmIEkgaGFkIGtu
b3duIDopKS4NCj4gDQo+IEkgYWdyZWUuDQo+IA0KPiA+DQo+ID4gQXMgZmFyIGFzIEkga25vdywg
dGhlcmUgaXMgc29tZSB3b3JrIG9uIGxpdmUgbWlncmF0aW9uIHdpdGggYm90aCBWRklPDQo+ID4g
YW5kIG1kZXYsIGFuZCB0aGF0IHByb2JhYmx5IGluY2x1ZGVzIHNvbWUgZGlydHkgcGFnZSB0cmFj
a2luZyBBUEkuDQo+ID4ga3ZtZ3QgY291bGQgc3dpdGNoIHRvIHRoYXQgQVBJLCBvciB0aGVyZSBj
b3VsZCBiZSBWRklPIEFQSXMgc2ltaWxhciB0bw0KPiA+IGt2bV93cml0ZV9ndWVzdCBidXQgdGFr
aW5nIElPVkFzIGluc3RlYWQgb2YgR1BBcy4gIEFkdmFudGFnZTogdGhpcyB3b3VsZA0KPiA+IGZp
eCB0aGUgR1BBL0lPVkEgY29uZnVzaW9uLiAgRGlzYWR2YW50YWdlOiB1c2Vyc3BhY2Ugd291bGQg
bG9zZSB0aGUNCj4gPiB0cmFja2luZyBvZiB3cml0ZXMgZnJvbSBtZGV2IGRldmljZXMuICBLZXZp
biwgYXJlIHRoZXNlIHdyaXRlcyB1c2VkIGluDQo+ID4gYW55IHdheT8gIERvIHRoZSBjYWxscyB0
byBpbnRlbF9ndnRfaHlwZXJ2aXNvcl93cml0ZV9ncGEgY292ZXJzIGFsbA0KPiA+IHdyaXRlcyBm
cm9tIGt2bWd0IHZHUFVzLCBvciBjYW4gdGhlIGhhcmR3YXJlIHdyaXRlIHRvIG1lbW9yeSBhcyB3
ZWxsDQo+ID4gKHdoaWNoIHdvdWxkIGJlIG15IGd1ZXNzIGlmIEkgZGlkbid0IGtub3cgYW55dGhp
bmcgYWJvdXQga3ZtZ3QsIHdoaWNoIEkNCj4gPiBwcmV0dHkgbXVjaCBkb24ndCk/DQo+IA0KPiBp
bnRlbF9ndnRfaHlwZXJ2aXNvcl93cml0ZV9ncGEgY292ZXJzIGFsbCB3cml0ZXMgZHVlIHRvIHNv
ZnR3YXJlIG1lZGlhdGlvbi4NCj4gDQo+IGZvciBoYXJkd2FyZSB1cGRhdGVzLCBpdCBuZWVkcyBi
ZSBtYXBwZWQgaW4gSU9NTVUgdGhyb3VnaA0KPiB2ZmlvX3Bpbl9wYWdlcw0KPiBiZWZvcmUgYW55
IERNQSBoYXBwZW5zLiBUaGUgb25nb2luZyBkaXJ0eSB0cmFja2luZyBlZmZvcnQgaW4gVkZJTyB3
aWxsIHRha2UNCj4gZXZlcnkgcGlubmVkIHBhZ2UgdGhyb3VnaCB0aGF0IEFQSSBhcyBkaXJ0aWVk
Lg0KPiANCj4gSG93ZXZlciwgY3VycmVudGx5IFZGSU8gZG9lc24ndCBpbXBsZW1lbnQgYW55IHZm
aW9fcmVhZC93cml0ZV9ndWVzdA0KPiBpbnRlcmZhY2UgeWV0LiBhbmQgaXQgZG9lc24ndCBtYWtl
IHNlbnNlIHRvIHVzZSB2ZmlvX3Bpbl9wYWdlcyBmb3Igc29mdHdhcmUNCj4gZGlydGllZCBwYWdl
cywgYXMgcGluIGlzIHVubmVjZXNzYXJ5IGFuZCBoZWF2eSBpbnZvbHZpbmcgaW9tbXUgaW52YWxp
ZGF0aW9uLg0KDQpPbmUgY29ycmVjdGlvbi4gdmZpb19waW5fcGFnZXMgZG9lc24ndCBpbnZvbHZl
IGlvbW11IGludmFsaWRhdGlvbi4gSSBzaG91bGQNCmp1c3QgbWVhbiB0aGF0IHBpbm5pbmcgdGhl
IHBhZ2UgaXMgbm90IG5lY2Vzc2FyeS4gV2UganVzdCBuZWVkIGEga3ZtLWxpa2UNCmludGVyZmFj
ZSBiYXNlZCBvbiBodmEgdG8gYWNjZXNzLg0KDQo+IA0KPiBBbGV4LCBpZiB5b3UgYXJlIE9LIHdl
J2xsIHdvcmsgb24gc3VjaCBpbnRlcmZhY2UgYW5kIG1vdmUga3ZtZ3QgdG8gdXNlIGl0Lg0KPiBB
ZnRlciBpdCdzIGFjY2VwdGVkLCB3ZSBjYW4gYWxzbyBtYXJrIHBhZ2VzIGRpcnR5IHRocm91Z2gg
dGhpcyBuZXcgaW50ZXJmYWNlDQo+IGluIEtpcnRpJ3MgZGlydHkgcGFnZSB0cmFja2luZyBzZXJp
ZXMuDQo+IA0K
