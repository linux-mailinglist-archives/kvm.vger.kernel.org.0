Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 076391221F1
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfLQC0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:26:22 -0500
Received: from mga03.intel.com ([134.134.136.65]:15828 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbfLQC0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:26:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 18:26:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217366633"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2019 18:26:20 -0800
Received: from fmsmsx119.amr.corp.intel.com (10.18.124.207) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:26:20 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX119.amr.corp.intel.com (10.18.124.207) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:26:19 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.71]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 10:26:18 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova
 over first level
Thread-Topic: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova
 over first level
Thread-Index: AQHVr8iiJX/bvAPmK0eIArQDcTD6yKe33K3QgACZjICAAndaMIACHLkAgAAFFACAAJLKQA==
Date:   Tue, 17 Dec 2019 02:26:17 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A135CAB@SHSMSX104.ccr.corp.intel.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-6-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
 <f1e5cfea-8b11-6d72-8e57-65daea51c050@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C50@SHSMSX104.ccr.corp.intel.com>
 <6a5f6695-d1fd-e7d1-3ea3-f222a1ef0e54@linux.intel.com>
 <b4a879b2-a5c7-b0bf-8cd4-7397aeebc381@linux.intel.com>
In-Reply-To: <b4a879b2-a5c7-b0bf-8cd4-7397aeebc381@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDIxNWMyOWQtMmViMi00MDliLWIwODAtMmYyNDAzZTY1ZTFkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiakNFTFFiaFZhTnNLWFNSNjY3a2FkVmpmWDBqd3JxZlQ3Q3RXektlWjYxdTdobDFzaGJSMjRWbGZtQlFROGtkTiJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSBbbWFpbHRvOmJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbV0NCj4gU2Vu
dDogVHVlc2RheSwgRGVjZW1iZXIgMTcsIDIwMTkgOTozNyBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5
aS5sLmxpdUBpbnRlbC5jb20+OyBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz47IERhdmlk
DQo+IFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz47IEFsZXggV2lsbGlhbXNvbg0KPiA8
YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgNS82
XSBpb21tdS92dC1kOiBGbHVzaCBQQVNJRC1iYXNlZCBpb3RsYiBmb3IgaW92YSBvdmVyIGZpcnN0
DQo+IGxldmVsDQo+IA0KPiBIaSBhZ2FpbiwNCj4gDQo+IE9uIDEyLzE3LzE5IDk6MTkgQU0sIEx1
IEJhb2x1IHdyb3RlOg0KPiA+IEhpIFlpLA0KPiA+DQo+ID4gT24gMTIvMTUvMTkgNToyMiBQTSwg
TGl1LCBZaSBMIHdyb3RlOg0KPiA+PiBPaywgbGV0IG1lIGV4cGxhaW4gbW9yZS4uLiBkZWZhdWx0
IHBhc2lkIGlzIG1lYW5pbmdmdWwgb25seSB3aGVuDQo+ID4+IHRoZSBkb21haW4gaGFzIGJlZW4g
YXR0YWNoZWQgdG8gYSBkZXZpY2UgYXMgYW4gYXV4LWRvbWFpbi4gcmlnaHQ/DQo+ID4NCj4gPiBO
byBleGFjdGx5LiBFYWNoIGRvbWFpbiBoYXMgYSBzcGVjaWZpYyBkZWZhdWx0IHBhc2lkLCBubyBt
YXR0ZXIgbm9ybWFsDQo+ID4gZG9tYWluIChSSUQgYmFzZWQpIG9yIGF1eC1kb21haW4gKFBBU0lE
IGJhc2VkKS4gVGhlIGRpZmZlcmVuY2UgaXMgZm9yIGENCj4gPiBub3JtYWwgZG9tYWluIFJJRDJQ
QVNJRCB2YWx1ZSBpcyB1c2VkLCBmb3IgYW4gYXV4LWRvbWFpbiB0aGUgcGFzaWQgaXMNCj4gPiBh
bGxvY2F0ZWQgZnJvbSBhIGdsb2JhbCBwb29sLg0KPiA+DQo+ID4gVGhlIHNhbWUgY29uY2VwdCB1
c2VkIGluIFZULWQgMy54IHNjYWxhYmxlIG1vZGUuIEZvciBSSUQgYmFzZWQgRE1BDQo+ID4gdHJh
bnNsYXRpb24gUklEMlBBU0lEIHZhbHVlIGlzIHVzZWQgd2hlbiB3YWxraW5nIHRoZSB0YWJsZXM7
IEZvciBQQVNJRA0KPiA+IGJhc2VkIERNQSB0cmFuc2xhdGlvbiBhIHJlYWwgcGFzaWQgaW4gdGhl
IHRyYW5zYWN0aW9uIGlzIHVzZWQuDQo+ID4NCj4gPj4gSWYgYSBkb21haW4gb25seSBoYXMgb25l
IGRldmljZSwgYW5kIGl0IGlzIGF0dGFjaGVkIHRvIHRoaXMgZGV2aWNlIGFzDQo+ID4+IG5vcm1h
bCBkb21haW4gKG5vcm1hbCBkb21haW4gbWVhbnMgbm9uIGF1eC1kb21haW4gaGVyZSkuIFRoZW4N
Cj4gPj4geW91IHNob3VsZCBmbHVzaCBjYWNoZSB3aXRoIGRvbWFpbi1pZCBhbmQgUklEMlBBU0lE
IHZhbHVlLg0KPiA+PiBJZiBhIGRvbWFpbiBoYXMgb25lIGRldmljZSwgYW5kIGl0IGlzIGF0dGFj
aGVkIHRvIHRoaXMgZGV2aWNlIGFzDQo+ID4+IGF1eC1kb21haW4uIFRoZW4geW91IG1heSB3YW50
IHRvIGZsdXNoIGNhY2hlIHdpdGggZG9tYWluLWlkDQo+ID4+IGFuZCBkZWZhdWx0IHBhc2lkLiBy
aWdodD8NCj4gPg0KPiA+IEEgZG9tYWluJ3MgY291bnRlcnBhcnQgaXMgSU9NTVUgZ3JvdXAuIFNv
IHdlIHNheSBhdHRhY2gvZGV0YWNoIGRvbWFpbg0KPiA+IHRvL2Zyb20gZGV2aWNlcyBpbiBhIGdy
b3VwLiBXZSBkb24ndCBhbGxvdyBkZXZpY2VzIHdpdGggZGlmZmVyZW50DQo+ID4gZGVmYXVsdCBw
YXNpZCBzaXR0aW5nIGluIGEgc2FtZSBncm91cCwgcmlnaHQ/DQo+ID4NCj4gPj4gVGhlbiBsZXQn
cyBjb21lIHRvIHRoZSBjYXNlIEkgbWVudGlvbmVkIGluIHByZXZpb3VzIGVtYWlsLiBhIG1kZXYN
Cj4gPj4gYW5kIGFub3RoZXIgZGV2aWNlIGFzc2lnbmVkIHRvIGEgc2luZ2xlIFZNLiBJbiBob3N0
LCB5b3Ugd2lsbCBoYXZlDQo+ID4+IGEgZG9tYWluIHdoaWNoIGhhcyB0d28gZGV2aWNlcywgb25l
IGRldmljZShkZXZhKSBpcyBhdHRhY2hlZCBhcw0KPiA+DQo+ID4gTm8uIFdlIHdpbGwgaGF2ZSB0
d28gSU9NTVUgZ3JvdXBzIGFuZCB0d28gZG9tYWlucy4gQ29ycmVjdCBtZSBpZiBteQ0KPiA+IHVu
ZGVyc3RhbmRpbmcgaXMgbm90IHJpZ2h0Lg0KPiANCj4gUmVjb25zaWRlcmVkIHRoaXMuIFVuZm9y
dHVuYXRlbHksIG15IHVuZGVyc3RhbmRpbmcgaXMgbm90IHJpZ2h0LiA6LSgNCj4gDQo+IEEgc2lu
Z2xlIGRvbWFpbiBjb3VsZCBiZSBhdHRhY2hlZCB0byBtdWx0aXBsZSBJT01NVSBncm91cHMuIFNv
IGl0DQo+IGNvbWVzIHRvIHRoZSBpc3N1ZSB5b3UgY29uY2VybmVkLiBEbyBJIHVuZGVyc3RhbmQg
aXQgcmlnaHQ/DQoNCnllcy4gRGV2aWNlIHdpdGhpbiB0aGUgc2FtZSBncm91cCBoYXMgbm8gc3Vj
aCBpc3N1ZSBzaW5jZSBzdWNoDQpkZXZpY2VzIGFyZSBub3QgYWJsZSB0byBlbmFibGVkIGF1eC1k
b21haW4uIE5vdyBvdXIgdW5kZXJzdGFuZGluZw0KYXJlIGFsaWduZWQuIDotKQ0KDQo+ID4NCj4g
Pj4gbm9ybWFsIGRvbWFpbiwgYW5vdGhlciBvbmUgKGRldkIpIGlzIGF0dGFjaGVkIGFzIGF1eC1k
b21haW4uIFRoZW4NCj4gPj4gd2hpY2ggcGFzaWQgc2hvdWxkIGJlIHVzZWQgd2hlbiB0aGUgbWFw
cGluZyBpbiBJT1ZBIHBhZ2UgdGFibGUgaXMNCj4gPj4gbW9kaWZpZWQ/IFJJRDJQQVNJRCBvciBk
ZWZhdWx0IHBhc2lkPyBJIHRoaW5rIGJvdGggc2hvdWxkIGJlIHVzZWQNCj4gPj4gc2luY2UgdGhl
IGRvbWFpbiBtZWFucyBkaWZmZXJlbnRseSB0byB0aGUgdHdvIGRldmljZXMuIElmIHlvdSBqdXN0
DQo+ID4+IHVzZSBkZWZhdWx0IHBhc2lkLCB0aGVuIGRldmEgbWF5IHN0aWxsIGJlIGFibGUgdG8g
dXNlIHN0YWxlIGNhY2hlcy4NCj4gDQo+IFlvdSBhcmUgcmlnaHQuIEkgd2lsbCBjaGFuZ2UgaXQg
YWNjb3JkaW5nbHkuIFRoZSBsb2dpYyBzaG91bGQgbG9vaw0KPiBsaWtlOg0KPiANCj4gaWYgKGRv
bWFpbiBhdHRhY2hlZCB0byBwaHlzaWNhbCBkZXZpY2UpDQo+IAlmbHVzaF9waW90bGJfd2l0aF9S
SUQyUEFTSUQoKQ0KPiBlbHNlIGlmIChkb21haW5fYXR0YWNoZWRfdG9fbWRldl9kZXZpY2UpDQo+
IAlmbHVzaF9waW90bGJfd2l0aF9kZWZhdWx0X3Bhc2lkKCkNCj4gDQo+IERvZXMgdGhpcyB3b3Jr
IGZvciB5b3U/IFRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcyENCg0KSWYgbm8gZWxzZSwgaXQgd291
bGQgd29yayBmb3Igc2NhbGFibGUgbW9kZS4gXl9eIEkgbm90aWNlZCB5b3UndmUNCmFscmVhZHkg
Y29ycmVjdGVkIGJ5IHlvdXJzZWxmIGluIGFub3RoZXIgcmVwbHkuIDotKSBMb29rIGZvcndhcmQg
dG8NCnlvdXIgbmV4dCB2ZXJzaW9uLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
