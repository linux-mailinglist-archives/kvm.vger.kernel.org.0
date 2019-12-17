Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E42122207
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfLQCga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:36:30 -0500
Received: from mga18.intel.com ([134.134.136.126]:8536 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbfLQCg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:36:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 18:36:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217628428"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2019 18:36:27 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:36:27 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.71]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 10:36:25 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
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
Thread-Index: AQHVr8iiJX/bvAPmK0eIArQDcTD6yKe33K3QgACZjICAAndaMIACHLkAgAAFFACAAJLKQIAAA2Ag
Date:   Tue, 17 Dec 2019 02:36:25 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A135D05@SHSMSX104.ccr.corp.intel.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-6-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
 <f1e5cfea-8b11-6d72-8e57-65daea51c050@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C50@SHSMSX104.ccr.corp.intel.com>
 <6a5f6695-d1fd-e7d1-3ea3-f222a1ef0e54@linux.intel.com>
 <b4a879b2-a5c7-b0bf-8cd4-7397aeebc381@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A135CAB@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A135CAB@SHSMSX104.ccr.corp.intel.com>
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

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
RGVjZW1iZXIgMTcsIDIwMTkgMTA6MjYgQU0NCj4gVG86IEx1IEJhb2x1IDxiYW9sdS5sdUBsaW51
eC5pbnRlbC5jb20+OyBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz47IERhdmlkDQo+IFdv
b2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz47IEFsZXggV2lsbGlhbXNvbg0KPiA8YWxleC53
aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggdjMgNS82XSBpb21t
dS92dC1kOiBGbHVzaCBQQVNJRC1iYXNlZCBpb3RsYiBmb3IgaW92YSBvdmVyIGZpcnN0DQo+IGxl
dmVsDQo+IA0KPiA+IEZyb206IEx1IEJhb2x1IFttYWlsdG86YmFvbHUubHVAbGludXguaW50ZWwu
Y29tXQ0KPiA+IFNlbnQ6IFR1ZXNkYXksIERlY2VtYmVyIDE3LCAyMDE5IDk6MzcgQU0NCj4gPiBU
bzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+OyBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5
dGVzLm9yZz47IERhdmlkDQo+ID4gV29vZGhvdXNlIDxkd213MkBpbmZyYWRlYWQub3JnPjsgQWxl
eCBXaWxsaWFtc29uDQo+ID4gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjMgNS82XSBpb21tdS92dC1kOiBGbHVzaCBQQVNJRC1iYXNlZCBpb3Rs
YiBmb3IgaW92YSBvdmVyIGZpcnN0DQo+ID4gbGV2ZWwNCj4gPg0KPiA+IEhpIGFnYWluLA0KPiA+
DQo+ID4gT24gMTIvMTcvMTkgOToxOSBBTSwgTHUgQmFvbHUgd3JvdGU6DQo+ID4gPiBIaSBZaSwN
Cj4gPiA+DQo+ID4gPiBPbiAxMi8xNS8xOSA1OjIyIFBNLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4g
Pj4gT2ssIGxldCBtZSBleHBsYWluIG1vcmUuLi4gZGVmYXVsdCBwYXNpZCBpcyBtZWFuaW5nZnVs
IG9ubHkgd2hlbg0KPiA+ID4+IHRoZSBkb21haW4gaGFzIGJlZW4gYXR0YWNoZWQgdG8gYSBkZXZp
Y2UgYXMgYW4gYXV4LWRvbWFpbi4gcmlnaHQ/DQo+ID4gPg0KPiA+ID4gTm8gZXhhY3RseS4gRWFj
aCBkb21haW4gaGFzIGEgc3BlY2lmaWMgZGVmYXVsdCBwYXNpZCwgbm8gbWF0dGVyIG5vcm1hbA0K
PiA+ID4gZG9tYWluIChSSUQgYmFzZWQpIG9yIGF1eC1kb21haW4gKFBBU0lEIGJhc2VkKS4gVGhl
IGRpZmZlcmVuY2UgaXMgZm9yIGENCj4gPiA+IG5vcm1hbCBkb21haW4gUklEMlBBU0lEIHZhbHVl
IGlzIHVzZWQsIGZvciBhbiBhdXgtZG9tYWluIHRoZSBwYXNpZCBpcw0KPiA+ID4gYWxsb2NhdGVk
IGZyb20gYSBnbG9iYWwgcG9vbC4NCj4gPiA+DQo+ID4gPiBUaGUgc2FtZSBjb25jZXB0IHVzZWQg
aW4gVlQtZCAzLnggc2NhbGFibGUgbW9kZS4gRm9yIFJJRCBiYXNlZCBETUENCj4gPiA+IHRyYW5z
bGF0aW9uIFJJRDJQQVNJRCB2YWx1ZSBpcyB1c2VkIHdoZW4gd2Fsa2luZyB0aGUgdGFibGVzOyBG
b3IgUEFTSUQNCj4gPiA+IGJhc2VkIERNQSB0cmFuc2xhdGlvbiBhIHJlYWwgcGFzaWQgaW4gdGhl
IHRyYW5zYWN0aW9uIGlzIHVzZWQuDQo+ID4gPg0KPiA+ID4+IElmIGEgZG9tYWluIG9ubHkgaGFz
IG9uZSBkZXZpY2UsIGFuZCBpdCBpcyBhdHRhY2hlZCB0byB0aGlzIGRldmljZSBhcw0KPiA+ID4+
IG5vcm1hbCBkb21haW4gKG5vcm1hbCBkb21haW4gbWVhbnMgbm9uIGF1eC1kb21haW4gaGVyZSku
IFRoZW4NCj4gPiA+PiB5b3Ugc2hvdWxkIGZsdXNoIGNhY2hlIHdpdGggZG9tYWluLWlkIGFuZCBS
SUQyUEFTSUQgdmFsdWUuDQo+ID4gPj4gSWYgYSBkb21haW4gaGFzIG9uZSBkZXZpY2UsIGFuZCBp
dCBpcyBhdHRhY2hlZCB0byB0aGlzIGRldmljZSBhcw0KPiA+ID4+IGF1eC1kb21haW4uIFRoZW4g
eW91IG1heSB3YW50IHRvIGZsdXNoIGNhY2hlIHdpdGggZG9tYWluLWlkDQo+ID4gPj4gYW5kIGRl
ZmF1bHQgcGFzaWQuIHJpZ2h0Pw0KPiA+ID4NCj4gPiA+IEEgZG9tYWluJ3MgY291bnRlcnBhcnQg
aXMgSU9NTVUgZ3JvdXAuIFNvIHdlIHNheSBhdHRhY2gvZGV0YWNoIGRvbWFpbg0KPiA+ID4gdG8v
ZnJvbSBkZXZpY2VzIGluIGEgZ3JvdXAuIFdlIGRvbid0IGFsbG93IGRldmljZXMgd2l0aCBkaWZm
ZXJlbnQNCj4gPiA+IGRlZmF1bHQgcGFzaWQgc2l0dGluZyBpbiBhIHNhbWUgZ3JvdXAsIHJpZ2h0
Pw0KPiA+ID4NCj4gPiA+PiBUaGVuIGxldCdzIGNvbWUgdG8gdGhlIGNhc2UgSSBtZW50aW9uZWQg
aW4gcHJldmlvdXMgZW1haWwuIGEgbWRldg0KPiA+ID4+IGFuZCBhbm90aGVyIGRldmljZSBhc3Np
Z25lZCB0byBhIHNpbmdsZSBWTS4gSW4gaG9zdCwgeW91IHdpbGwgaGF2ZQ0KPiA+ID4+IGEgZG9t
YWluIHdoaWNoIGhhcyB0d28gZGV2aWNlcywgb25lIGRldmljZShkZXZhKSBpcyBhdHRhY2hlZCBh
cw0KPiA+ID4NCj4gPiA+IE5vLiBXZSB3aWxsIGhhdmUgdHdvIElPTU1VIGdyb3VwcyBhbmQgdHdv
IGRvbWFpbnMuIENvcnJlY3QgbWUgaWYgbXkNCj4gPiA+IHVuZGVyc3RhbmRpbmcgaXMgbm90IHJp
Z2h0Lg0KPiA+DQo+ID4gUmVjb25zaWRlcmVkIHRoaXMuIFVuZm9ydHVuYXRlbHksIG15IHVuZGVy
c3RhbmRpbmcgaXMgbm90IHJpZ2h0LiA6LSgNCj4gPg0KPiA+IEEgc2luZ2xlIGRvbWFpbiBjb3Vs
ZCBiZSBhdHRhY2hlZCB0byBtdWx0aXBsZSBJT01NVSBncm91cHMuIFNvIGl0DQo+ID4gY29tZXMg
dG8gdGhlIGlzc3VlIHlvdSBjb25jZXJuZWQuIERvIEkgdW5kZXJzdGFuZCBpdCByaWdodD8NCj4g
DQo+IHllcy4gRGV2aWNlIHdpdGhpbiB0aGUgc2FtZSBncm91cCBoYXMgbm8gc3VjaCBpc3N1ZSBz
aW5jZSBzdWNoDQo+IGRldmljZXMgYXJlIG5vdCBhYmxlIHRvIGVuYWJsZWQgYXV4LWRvbWFpbi4g
Tm93IG91ciB1bmRlcnN0YW5kaW5nDQo+IGFyZSBhbGlnbmVkLiA6LSkNCj4gDQo+ID4gPg0KPiA+
ID4+IG5vcm1hbCBkb21haW4sIGFub3RoZXIgb25lIChkZXZCKSBpcyBhdHRhY2hlZCBhcyBhdXgt
ZG9tYWluLiBUaGVuDQo+ID4gPj4gd2hpY2ggcGFzaWQgc2hvdWxkIGJlIHVzZWQgd2hlbiB0aGUg
bWFwcGluZyBpbiBJT1ZBIHBhZ2UgdGFibGUgaXMNCj4gPiA+PiBtb2RpZmllZD8gUklEMlBBU0lE
IG9yIGRlZmF1bHQgcGFzaWQ/IEkgdGhpbmsgYm90aCBzaG91bGQgYmUgdXNlZA0KPiA+ID4+IHNp
bmNlIHRoZSBkb21haW4gbWVhbnMgZGlmZmVyZW50bHkgdG8gdGhlIHR3byBkZXZpY2VzLiBJZiB5
b3UganVzdA0KPiA+ID4+IHVzZSBkZWZhdWx0IHBhc2lkLCB0aGVuIGRldmEgbWF5IHN0aWxsIGJl
IGFibGUgdG8gdXNlIHN0YWxlIGNhY2hlcy4NCj4gPg0KPiA+IFlvdSBhcmUgcmlnaHQuIEkgd2ls
bCBjaGFuZ2UgaXQgYWNjb3JkaW5nbHkuIFRoZSBsb2dpYyBzaG91bGQgbG9vaw0KPiA+IGxpa2U6
DQo+ID4NCj4gPiBpZiAoZG9tYWluIGF0dGFjaGVkIHRvIHBoeXNpY2FsIGRldmljZSkNCj4gPiAJ
Zmx1c2hfcGlvdGxiX3dpdGhfUklEMlBBU0lEKCkNCj4gPiBlbHNlIGlmIChkb21haW5fYXR0YWNo
ZWRfdG9fbWRldl9kZXZpY2UpDQo+ID4gCWZsdXNoX3Bpb3RsYl93aXRoX2RlZmF1bHRfcGFzaWQo
KQ0KPiA+DQo+ID4gRG9lcyB0aGlzIHdvcmsgZm9yIHlvdT8gVGhhbmtzIGZvciBjYXRjaGluZyB0
aGlzIQ0KPiANCj4gSWYgbm8gZWxzZSwgaXQgd291bGQgd29yayBmb3Igc2NhbGFibGUgbW9kZS4g
Xl9eIEkgbm90aWNlZCB5b3UndmUNCj4gYWxyZWFkeSBjb3JyZWN0ZWQgYnkgeW91cnNlbGYgaW4g
YW5vdGhlciByZXBseS4gOi0pIExvb2sgZm9yd2FyZCB0bw0KPiB5b3VyIG5leHQgdmVyc2lvbi4N
Cg0KQlRXLiBUaGUgZGlzY3Vzc2lvbiBpbiB0aGlzIHRocmVhZCBtYXkgYXBwbHkgdG8gb3RoZXIg
Y2FjaGUgZmx1c2gNCmluIHlvdXIgc2VyaWVzLiBQbGVhc2UgaGF2ZSBhIGNoZWNrLiBBdCBsZWFz
dCwgdGhlcmUgYXJlIHR3byBwbGFjZXMgd2hpY2gNCm5lZWQgdG8gYmUgdXBkYXRlZCBpbiB0aGlz
IHNpbmdsZSBwYXRjaC4NCiANClJlZ2FyZHMsDQpZaSBMaXUNCg==
