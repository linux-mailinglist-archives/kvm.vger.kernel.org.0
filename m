Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6E122215
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 03:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLQCos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 21:44:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:28074 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbfLQCos (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 21:44:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 18:44:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="221643930"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga001.fm.intel.com with ESMTP; 16 Dec 2019 18:44:47 -0800
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:44:47 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 16 Dec 2019 18:44:47 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.71]) with mapi id 14.03.0439.000;
 Tue, 17 Dec 2019 10:44:45 +0800
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
Subject: RE: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova
 over first level
Thread-Topic: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova
 over first level
Thread-Index: AQHVr8iiJX/bvAPmK0eIArQDcTD6yKe33K3QgACZjICAAndaMIACHLkAgAAFFACAAACDAIAAl1Vg
Date:   Tue, 17 Dec 2019 02:44:44 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A135D50@SHSMSX104.ccr.corp.intel.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-6-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
 <f1e5cfea-8b11-6d72-8e57-65daea51c050@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A132C50@SHSMSX104.ccr.corp.intel.com>
 <6a5f6695-d1fd-e7d1-3ea3-f222a1ef0e54@linux.intel.com>
 <b4a879b2-a5c7-b0bf-8cd4-7397aeebc381@linux.intel.com>
 <2b024c1e-79bd-6827-47e6-ae9457054c79@linux.intel.com>
In-Reply-To: <2b024c1e-79bd-6827-47e6-ae9457054c79@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2JiZjNhYjctY2IyNi00NjcxLTkxYjEtZTQ0ZWY2ZWQ0MjQzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoic3k5R2ljVUpuY3REWVlQOHl0b01hQnZkSnhUbWtPUXcreEY4c3hMQlJKMDdaMHU3M2UzdHZ0UWpPTkRPT2QyVSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMdSBCYW9sdSBbbWFpbHRvOmJhb2x1Lmx1QGxpbnV4LmludGVsLmNvbV0NCj4gU2Vu
dDogVHVlc2RheSwgRGVjZW1iZXIgMTcsIDIwMTkgOTozOSBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5
aS5sLmxpdUBpbnRlbC5jb20+OyBKb2VyZyBSb2VkZWwgPGpvcm9AOGJ5dGVzLm9yZz47IERhdmlk
DQo+IFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz47IEFsZXggV2lsbGlhbXNvbg0KPiA8
YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjMgNS82
XSBpb21tdS92dC1kOiBGbHVzaCBQQVNJRC1iYXNlZCBpb3RsYiBmb3IgaW92YSBvdmVyIGZpcnN0
DQo+IGxldmVsDQo+IA0KPiBIaSwNCj4gDQo+IE9uIDEyLzE3LzE5IDk6MzcgQU0sIEx1IEJhb2x1
IHdyb3RlOg0KPiA+IFlvdSBhcmUgcmlnaHQuIEkgd2lsbCBjaGFuZ2UgaXQgYWNjb3JkaW5nbHku
IFRoZSBsb2dpYyBzaG91bGQgbG9vaw0KPiA+IGxpa2U6DQo+ID4NCj4gPiBpZiAoZG9tYWluIGF0
dGFjaGVkIHRvIHBoeXNpY2FsIGRldmljZSkNCj4gPiAgwqDCoMKgwqBmbHVzaF9waW90bGJfd2l0
aF9SSUQyUEFTSUQoKQ0KPiA+IGVsc2UgaWYgKGRvbWFpbl9hdHRhY2hlZF90b19tZGV2X2Rldmlj
ZSkNCj4gPiAgwqDCoMKgwqBmbHVzaF9waW90bGJfd2l0aF9kZWZhdWx0X3Bhc2lkKCkNCj4gPg0K
PiANCj4gQm90aCEgc28gbm8gImVsc2UiIGhlcmUuDQoNCmFoYSwgaWYgd2Ugd2FudCB0byBmbHVz
aCBtb3JlIHByZWNpc2VseSwgd2UgbWF5IGNoZWNrIHdoZXRoZXINCmRvbWFpbi0+ZGVmYXVsdF9w
YXNpZCBpcyBhbGxvY2F0ZWQuIElmIG5vdCwgaXQgbWVhbnMgbm8gbWRldiBpcw0KaW52b2x2ZWQs
IHRoZW4gd2UgbWF5IHNhdmUgYSBwX2lvdGxiX2ludl9kc2Mgc3VibWlzc2lvbiBhbmQgYWxzbw0K
c2F2ZSBWVC1kIGhhcmR3YXJlIGNpcmNsZXMgZnJvbSBkb2luZyB1c2VsZXNzIGZsdXNoLiBUaGlz
IGlzIGp1c3QNCm9wdGltaXphdGlvbiwgaXQncyB1cCB0byB5b3UgdG8gcGljayBpdCBvciBub3Qg
aW4gdGhpcyBwYXRjaHNldC4gSSdtDQpmaW5lIHdpdGggZmx1c2ggImJvdGgiIHNpbmNlIGl0IGd1
YXJhbnRlZXMgY29ycmVjdG5lc3MuDQoNClJlZ2FyZHMsDQpZaSBMaXUNCg==
