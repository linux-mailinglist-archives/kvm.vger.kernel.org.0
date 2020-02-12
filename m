Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80F815A214
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 08:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgBLHdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 02:33:23 -0500
Received: from mga17.intel.com ([192.55.52.151]:20462 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgBLHdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 02:33:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 23:33:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="432224082"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga005.fm.intel.com with ESMTP; 11 Feb 2020 23:33:22 -0800
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:33:22 -0800
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 11 Feb 2020 23:33:22 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.225]) with mapi id 14.03.0439.000;
 Wed, 12 Feb 2020 15:33:20 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        "Eduardo Habkost" <ehabkost@redhat.com>
Subject: RE: [RFC v3 15/25] intel_iommu: process pasid cache invalidation
Thread-Topic: [RFC v3 15/25] intel_iommu: process pasid cache invalidation
Thread-Index: AQHV1p1PAzphlBRtJ0alU6uXzLVYlKgV/TkAgAFCrnA=
Date:   Wed, 12 Feb 2020 07:33:20 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BA59E@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-16-git-send-email-yi.l.liu@intel.com>
 <20200211201728.GM984290@xz-x1>
In-Reply-To: <20200211201728.GM984290@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWUxZjBiMzAtODQyNi00NGM3LWI1Y2YtNTQ5ZDdhNmUxM2ZmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNlRsWGt4SzYxZDYxaTM1UEFkRVNnQ2d5RXFlR21aMGRJcUYzZGMzZFlGS25WNFFrczRDUEV3QkJqbGhpY0ltayJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
RmVicnVhcnkgMTIsIDIwMjAgNDoxNyBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYzIDE1LzI1XSBpbnRlbF9pb21tdTogcHJvY2Vz
cyBwYXNpZCBjYWNoZSBpbnZhbGlkYXRpb24NCj4gDQo+IE9uIFdlZCwgSmFuIDI5LCAyMDIwIGF0
IDA0OjE2OjQ2QU0gLTA4MDAsIExpdSwgWWkgTCB3cm90ZToNCj4gPiBGcm9tOiBMaXUgWWkgTCA8
eWkubC5saXVAaW50ZWwuY29tPg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhZGRzIFBBU0lEIGNhY2hl
IGludmFsaWRhdGlvbiBoYW5kbGluZy4gV2hlbiBndWVzdCBlbmFibGVkDQo+ID4gUEFTSUQgdXNh
Z2VzIChlLmcuIFNWQSksIGd1ZXN0IHNvZnR3YXJlIHNob3VsZCBpc3N1ZSBhIHByb3BlciBQQVNJ
RA0KPiA+IGNhY2hlIGludmFsaWRhdGlvbiB3aGVuIGNhY2hpbmctbW9kZSBpcyBleHBvc2VkLiBU
aGlzIHBhdGNoIG9ubHkgYWRkcw0KPiA+IHRoZSBkcmFmdCBoYW5kbGluZyBvZiBwYXNpZCBjYWNo
ZSBpbnZhbGlkYXRpb24uIERldGFpbGVkIGhhbmRsaW5nIHdpbGwNCj4gPiBiZSBhZGRlZCBpbiBz
dWJzZXF1ZW50IHBhdGNoZXMuDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBp
bnRlbC5jb20+DQo+ID4gQ2M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5j
b20+DQo+ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiBDYzogWWkgU3Vu
IDx5aS55LnN1bkBsaW51eC5pbnRlbC5jb20+DQo+ID4gQ2M6IFBhb2xvIEJvbnppbmkgPHBib256
aW5pQHJlZGhhdC5jb20+DQo+ID4gQ2M6IFJpY2hhcmQgSGVuZGVyc29uIDxydGhAdHdpZGRsZS5u
ZXQ+DQo+ID4gQ2M6IEVkdWFyZG8gSGFia29zdCA8ZWhhYmtvc3RAcmVkaGF0LmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBMaXUgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiANCj4gUmV2aWV3
ZWQtYnk6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCg0KVGhhbmtz8J+Yig0KDQpSZWdh
cmRzLA0KWWkgTGl1DQo=
