Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB77122204
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLQCdf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:33:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:8431 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfLQCde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:33:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 18:33:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="209535052"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga008.jf.intel.com with ESMTP; 16 Dec 2019 18:33:33 -0800
Received: from fmsmsx162.amr.corp.intel.com (10.18.125.71) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:33:33 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx162.amr.corp.intel.com (10.18.125.71) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:33:32 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.46]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 10:33:31 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over
 first level
Thread-Topic: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over
 first level
Thread-Index: AQHVr8iyIh/47oarrk2lLODWaUc1kqe3zByggACkbgCAAoJegIACI9KAgACM1XA=
Date:   Tue, 17 Dec 2019 02:33:30 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A135CE8@SHSMSX104.ccr.corp.intel.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-5-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A1309A9@SHSMSX104.ccr.corp.intel.com>
 <acb93807-7a78-b81a-3b27-fde9ee4d7edb@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C9A@SHSMSX104.ccr.corp.intel.com>
 <b883602c-ecdf-11ea-c26c-4b221bf7634d@linux.intel.com>
In-Reply-To: <b883602c-ecdf-11ea-c26c-4b221bf7634d@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjZmNDgwMGEtNDE2Ni00NzhmLWI5MDktMTJkZWM0ZmY2MDYzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN1dCbjRyNlNUSkdEeVVrSWd3ZlRETXRsdlFhVkkra2ZBaTZiUzJYOTlNZGFqS0lydE9XTlFjV2xReUFoeFlCOCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSA8IGJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbSA+DQo+IFNlbnQ6IFR1
ZXNkYXksIERlY2VtYmVyIDE3LCAyMDE5IDEwOjA0IEFNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwu
bGl1QGludGVsLmNvbT47IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPjsgRGF2aWQNCj4g
V29vZGhvdXNlIDxkd213MkBpbmZyYWRlYWQub3JnPjsgQWxleCBXaWxsaWFtc29uDQo+IDxhbGV4
LndpbGxpYW1zb25AcmVkaGF0LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyA0LzZdIGlv
bW11L3Z0LWQ6IFNldHVwIHBhc2lkIGVudHJpZXMgZm9yIGlvdmEgb3ZlciBmaXJzdCBsZXZlbA0K
PiANCj4gSGkgWWksDQo+IA0KPiBPbiAxMi8xNS8xOSA1OjM3IFBNLCBMaXUsIFlpIEwgd3JvdGU6
DQo+ID4+IFhEIChiaXQgNjMpIGlzIG9ubHkgZm9yIHRoZSBmaXJzdCBsZXZlbCwgYW5kIFNOUCAo
Yml0IDExKSBpcyBvbmx5IGZvcg0KPiA+PiBzZWNvbmQgbGV2ZWwsIHJpZ2h0PyBJIHRoaW5rIHdl
IG5lZWQgdG8gYWx3YXlzIHNldCBYRCBiaXQgZm9yIElPVkEgb3ZlciBGTCBjYXNlLg0KPiB0aG91
Z2h0cz8NCj4gPiBPb3BzLCBJIG1hZGUgYSBtaXN0YWtlIGhlcmUuIFBsZWFzZSBmb3JnZXQgU05Q
IGJpdCwgdGhlcmUgaXMgbm8gd2F5IHRvDQo+ID4gY29udHJvbCBTTlAgd2l0aCBmaXJzdCBsZXZl
bCBwYWdlIHRhYmxlLjotKQ0KPiA+DQo+ID4gQWN0dWFsbHksIGl0IGlzIGV4ZWN1dGUgKGJpdCAx
KSBvZiBzZWNvbmQgbGV2ZWwgcGFnZSB0YWJsZSB3aGljaCBJIHdhbnRlZCB0byBzYXkuDQo+ID4g
SWYgc29mdHdhcmUgc2V0cyBSL1cvWCBwZXJtaXNzaW9uIHRvIGFuIElPVkEsIHdpdGggSU9WQSBv
dmVyIHNlY29uZA0KPiA+IGxldmVsIHBhZ2UgdGFibGUsIGl0IHdpbGwgc2V0IGJpdCAxLiBIb3dl
dmVyLCBpZiBJT1ZBIGlzIG92ZXIgZmlyc3QNCj4gPiBsZXZlbCBwYWdlIHRhYmxlLCBpdCBtYXkg
bmVlZCB0byBjbGVhciBYRCBiaXQuIFRoaXMgaXMgd2hhdCBJIHdhbnQgdG8NCj4gPiBzYXkgaGVy
ZS4gSWYgSU9WQSBkb2VzbuKAmXQgYWxsb3cgZXhlY3V0ZSBwZXJtaXNzaW9uLCBpdCdzIG9rIHRv
IGFsd2F5cw0KPiA+IHNldCBYRCBiaXQgZm9yIElPVkEgb3ZlciBGTCBjYXNlLiBCdXQgSSB3b3Vs
ZCBsaWtlIHRvIGRvIGl0IGp1c3QgYXMNCj4gPiB3aGF0IHdlIGRpZCBmb3IgUi9XIHBlcm1pc3Np
b24uIFIvVyBwZXJtaXNzaW9uIHJlbGllcyBvbiB0aGUgcGVybWlzc2lvbg0KPiBjb25maWd1cmVk
IGJ5IHRoZSBwYWdlIG1hcCBjYWxsZXIuIHJpZ2h0Pw0KPiANCj4gR290IHlvdXIgcG9pbnQuDQo+
IA0KPiBDdXJyZW50IGRyaXZlciBhbHdheXMgY2xlYXJkIFggKGJpdCAyKSBpbiB0aGUgc2Vjb25k
IGxldmVsIHBhZ2UgdGFibGUuDQo+IFNvIHdlIHdpbGwgYWx3YXlzIHNldCBYRCBiaXQgKGJpdCA2
MykgaW4gdGhlIGZpcnN0IGxldmVsIHBhZ2UgdGFibGUuDQoNCnllcywgSSBhbHNvIG5vdGljZWQg
WCAoYml0IDIpIGlzIG5vdCB1c2VkIGluIGludGVsLWlvbW11IGRyaXZlci4gU28gSQ0Ka25vdyB3
aHkgeW91IHNldCBYRCBmb3IgSU9WQSBvdmVyIEZMIGNhc2UuIEJ1dCBpdCdzIGEgbGl0dGxlIGJp
dCB3ZWlyZA0KdG8gaGFyZCBjb2RlIGl0LiBUaGF0J3Mgd2h5IEkgc3VnZ2VzdGVkIHRvIHJlbGF5
IHBhZ2UgbWFwIGNhbGxlcidzDQpwZXJtaXNzaW9uIGlucHV0Lg0KDQo+IElmIHdlIGRlY2lkZSB0
byB1c2UgdGhlIFggcGVybWlzc2lvbiwgd2UgbmVlZCBhIHNlcGFyYXRlZCBwYXRjaCwgcmlnaHQ/
DQoNCnN1cmUsIGl0IHdvdWxkIGJlIGEgc2VwYXJhdGUgcGF0Y2ggc2luY2UgY3VycmVudCBjb2Rl
IGRvZXNu4oCZdCBhcHBseQ0KWCBwZXJtaXNzaW9uLg0KDQpSZWdhcmRzLA0KWWkgTGl1DQo=
