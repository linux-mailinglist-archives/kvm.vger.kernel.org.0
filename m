Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433D1BD930
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405936AbfIYHf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:35:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:53122 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390567AbfIYHf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:35:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 00:35:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="188706169"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 25 Sep 2019 00:35:26 -0700
Received: from fmsmsx125.amr.corp.intel.com (10.18.125.40) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 00:35:25 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX125.amr.corp.intel.com (10.18.125.40) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Sep 2019 00:35:25 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.132]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 15:35:23 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Peter Xu <peterx@redhat.com>, Lu Baolu <baolu.lu@linux.intel.com>
CC:     Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sun, Yi Y" <yi.y.sun@intel.com>
Subject: RE: [RFC PATCH 4/4] iommu/vt-d: Identify domains using first level
 page table
Thread-Topic: [RFC PATCH 4/4] iommu/vt-d: Identify domains using first level
 page table
Thread-Index: AQHVcgpG/pXRrE8O1EK3Luw5SA+K6qc7cLwAgACSPnA=
Date:   Wed, 25 Sep 2019 07:35:23 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F50F@SHSMSX104.ccr.corp.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-5-baolu.lu@linux.intel.com>
 <20190925065006.GN28074@xz-x1>
In-Reply-To: <20190925065006.GN28074@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWNjOWZjYmUtYzc2MS00MjE2LWJkYmYtYzU2YTdhNGI0OWMyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSnozQ1pmXC9STHptMktYYkRDZzRUWjJ6MUk0bzJ2NWgzcXIxXC9pK05WeW1VRkg5K2FVUWJyVG9jcUQyenU4cmdWIn0=
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

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnBldGVyeEByZWRoYXQuY29tXQ0KPiBTZW50OiBXZWRu
ZXNkYXksIFNlcHRlbWJlciAyNSwgMjAxOSAyOjUwIFBNDQo+IA0KPiBPbiBNb24sIFNlcCAyMywg
MjAxOSBhdCAwODoyNDo1NFBNICswODAwLCBMdSBCYW9sdSB3cm90ZToNCj4gPiArLyoNCj4gPiAr
ICogQ2hlY2sgYW5kIHJldHVybiB3aGV0aGVyIGZpcnN0IGxldmVsIGlzIHVzZWQgYnkgZGVmYXVs
dCBmb3INCj4gPiArICogRE1BIHRyYW5zbGF0aW9uLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGJv
b2wgZmlyc3RfbGV2ZWxfYnlfZGVmYXVsdCh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgZG1h
cl9kcmhkX3VuaXQgKmRyaGQ7DQo+ID4gKwlzdHJ1Y3QgaW50ZWxfaW9tbXUgKmlvbW11Ow0KPiA+
ICsNCj4gPiArCXJjdV9yZWFkX2xvY2soKTsNCj4gPiArCWZvcl9lYWNoX2FjdGl2ZV9pb21tdShp
b21tdSwgZHJoZCkNCj4gPiArCQlpZiAoIXNtX3N1cHBvcnRlZChpb21tdSkgfHwNCj4gPiArCQkg
ICAgIWVjYXBfZmx0cyhpb21tdS0+ZWNhcCkgfHwNCj4gPiArCQkgICAgIWNhcF9jYWNoaW5nX21v
ZGUoaW9tbXUtPmNhcCkpDQo+ID4gKwkJCXJldHVybiBmYWxzZTsNCj4gPiArCXJjdV9yZWFkX3Vu
bG9jaygpOw0KPiA+ICsNCj4gPiArCXJldHVybiB0cnVlOw0KPiA+ICt9DQo+IA0KPiAiSWYgbm8g
Y2FjaGluZyBtb2RlLCB0aGVuIHdlIHdpbGwgbm90IHVzZSAxc3QgbGV2ZWwuIg0KPiANCj4gSG1t
LCBkb2VzIHRoZSB2SU9NTVUgbmVlZHMgdG8gc3VwcG9ydCBjYWNoaW5nLW1vZGUgaWYgd2l0aCB0
aGUNCj4gc29sdXRpb24geW91IHByb3Bvc2VkIGhlcmU/ICBDYWNoaW5nIG1vZGUgaXMgb25seSBu
ZWNlc3NhcnkgZm9yDQo+IHNoYWRvd2luZyBBRkFJQ1QsIGFuZCBhZnRlciBhbGwgeW91J3JlIGdv
aW5nIHRvIHVzZSBmdWxsLW5lc3RlZCwNCj4gdGhlbi4uLiB0aGVuIEkgd291bGQgdGhpbmsgaXQn
cyBub3QgbmVlZGVkLiAgQW5kIGlmIHNvLCB3aXRoIHRoaXMNCj4gcGF0Y2ggMXN0IGxldmVsIHdp
bGwgYmUgZGlzYWJsZWQuIFNvdW5kcyBsaWtlIGEgcGFyYWRveC4uLg0KPiANCj4gSSdtIHRoaW5r
aW5nIHdoYXQgd291bGQgYmUgdGhlIGJpZyBwaWN0dXJlIGZvciB0aGlzIHRvIHdvcmsgbm93OiBG
b3INCj4gdGhlIHZJT01NVSwgaW5zdGVhZCBvZiBleHBvc2luZyB0aGUgY2FjaGluZy1tb2RlLCBJ
J20gdGhpbmtpbmcgbWF5YmUNCj4gd2Ugc2hvdWxkIGV4cG9zZSBpdCB3aXRoIGVjYXAuRkxUUz0x
IHdoaWxlIHdlIGNhbiBrZWVwIGVjYXAuU0xUUz0wDQo+IHRoZW4gaXQncyBuYXR1cmFsIHRoYXQg
d2UgY2FuIG9ubHkgdXNlIDFzdCBsZXZlbCB0cmFuc2xhdGlvbiBpbiB0aGUNCj4gZ3Vlc3QgZm9y
IGFsbCB0aGUgZG9tYWlucyAoYW5kIEkgYXNzdW1lIHN1Y2ggYW4gZWNhcCB2YWx1ZSBzaG91bGQN
Cj4gbmV2ZXIgaGFwcGVuIG9uIHJlYWwgaGFyZHdhcmUsIGFtIEkgcmlnaHQ/KS4NCj4gDQoNCnll
cywgdGhhdCdzIGFsc28gdGhlIHBpY3R1cmUgaW4gbXkgbWluZC4gOi0pDQoNClRoYW5rcw0KS2V2
aW4NCg==
