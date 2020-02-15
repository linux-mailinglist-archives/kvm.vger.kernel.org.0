Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED7015FDB3
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 09:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgBOItH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 03:49:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:36131 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgBOItH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 03:49:07 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 00:49:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,443,1574150400"; 
   d="scan'208";a="252892382"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga002.jf.intel.com with ESMTP; 15 Feb 2020 00:49:05 -0800
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 15 Feb 2020 00:49:05 -0800
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 15 Feb 2020 00:49:05 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.97]) with mapi id 14.03.0439.000;
 Sat, 15 Feb 2020 16:49:02 +0800
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
Subject: RE: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Thread-Topic: [RFC v3 14/25] intel_iommu: add virtual command capability
 support
Thread-Index: AQHV1p1OZ3QtxF5MCUauWTZBa4G1JagWGOQAgAJEBHCAAGQ5AIAACoqAgAM/R9A=
Date:   Sat, 15 Feb 2020 08:49:02 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BE85D@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-15-git-send-email-yi.l.liu@intel.com>
 <20200211215630.GN984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BBBF4@SHSMSX104.ccr.corp.intel.com>
 <20200213143110.GA1103216@xz-x1> <20200213150853.GB1103216@xz-x1>
In-Reply-To: <20200213150853.GB1103216@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzI0MzBiY2EtMGZhOC00OWZmLTg2MTYtZGE2YTgzMmNlZGM4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSHZhcmVDZXJ5QWJhcFMzazNIR1cwem9nTmw3MWM2QkNub25CTWphYUFYUVpuWE5BdW9hMmVOSFRsSkp1cWZZZSJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8IHBldGVyeEByZWRoYXQuY29tID4NCj4gU2VudDogVGh1cnNkYXks
IEZlYnJ1YXJ5IDEzLCAyMDIwIDExOjA5IFBNDQo+IFRvOiBMaXUsIFlpIEwgPHlpLmwubGl1QGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgdjMgMTQvMjVdIGludGVsX2lvbW11OiBhZGQg
dmlydHVhbCBjb21tYW5kIGNhcGFiaWxpdHkgc3VwcG9ydA0KPiANCj4gT24gVGh1LCBGZWIgMTMs
IDIwMjAgYXQgMDk6MzE6MTBBTSAtMDUwMCwgUGV0ZXIgWHUgd3JvdGU6DQo+IA0KPiBbLi4uXQ0K
PiANCj4gPiA+ID4gQXBhcnQgb2YgdGhpczogYWxzbyBJIGp1c3Qgbm90aWNlZCAod2hlbiByZWFk
aW5nIHRoZSBsYXR0ZXIgcGFydCBvZg0KPiA+ID4gPiB0aGUgc2VyaWVzKSB0aGF0IHRoZSB0aW1l
IHRoYXQgYSBwYXNpZCB0YWJsZSB3YWxrIGNhbiBjb25zdW1lIHdpbGwNCj4gPiA+ID4gZGVwZW5k
IG9uIHRoaXMgdmFsdWUgdG9vLiAgSSdkIHN1Z2dlc3QgdG8gbWFrZSB0aGlzIGFzIHNtYWxsIGFz
IHdlDQo+ID4gPiA+IGNhbiwgYXMgbG9uZyBhcyBpdCBzYXRpc2ZpZXMgdGhlIHVzYWdlLiAgV2Ug
Y2FuIGV2ZW4gYnVtcCBpdCBpbiB0aGUNCj4gPiA+ID4gZnV0dXJlLg0KPiA+ID4NCj4gPiA+IEkg
c2VlLiBUaGlzIGxvb2tzIHRvIGJlIGFuIG9wdGltaXphdGlvbi4gcmlnaHQ/IEluc3RlYWQgb2Yg
bW9kaWZ5IHRoZQ0KPiA+ID4gdmFsdWUgb2YgdGhpcyBtYWNybywgIEkgdGhpbmsgd2UgY2FuIGRv
IHRoaXMgb3B0aW1pemF0aW9uIGJ5IHRyYWNraW5nDQo+ID4gPiB0aGUgYWxsb2NhdGVkIFBBU0lE
cyBpbiBRRU1VLiBUaHVzLCB0aGUgcGFzaWQgdGFibGUgd2FsayAgd291bGQgYmUgbW9yZQ0KPiA+
ID4gZWZmaWNpZW50IGFuZCBhbHNvIG5vIGRlcGVuZGVuY3kgb24gdGhlIFZURF9NQVhfSFBBU0lE
LiBEb2VzIGl0IG1ha2UNCj4gPiA+IHNlbnNlIHRvIHlvdT8gOi0pDQo+ID4NCj4gPiBZZWFoIHNv
dW5kcyBnb29kLiA6KQ0KPiANCj4gSnVzdCB0byBtYWtlIHN1cmUgaXQncyBzYWZlIGV2ZW4gZm9y
IHdoZW4gdGhlIGdsb2JhbCBhbGxvY2F0aW9uIGlzIG5vdA0KPiBoYXBwZW5pbmcgKGZ1bGwgZW11
bGF0aW9uIGRldmljZXM/ICBEbyB0aGV5IG5lZWQgdGhlIFBBU0lEIHRhYmxlIHdhbGsNCj4gdG9v
PykuIA0KDQpJJ2Qgc2F5IG5vLiBGb3IgZnVsbCBlbXVsYXRpb24gZGV2aWNlcywganVzdCBuZWVk
cyB0byBlbnN1cmUgdGhlIHBhc2lkIGNhY2hlDQppcyBsYXRlc3QgKGRvIHdoYXQgZ3Vlc3QgdG9s
ZCkuIEV2ZW4gdGhlIGludmFsaWRhdGlvbiBmbHVzaGVzIHRvbyBtdWNoIGNhY2hlLA0KaXQganVz
dCBhZmZlY3RzIHRoZSBwZXJmb3JtYW5jZSBidXQgbm8gY29ycmVjdG5lc3MgaXNzdWUuICBUaGlz
IGlzIGRpZmZlcmVudA0Kd2l0aCBwYXNzdGhydSBkZXZpY2VzLCBpZiB1bmJpbmQgdG9vIG11Y2gs
IGl0IG1lYW5zIHNvbWUgcGFzc3RocnUgZGV2aWNlcw0KbWF5IGVuY291bnRlciBETUEgIGZhdWx0
IGxhdGVyLg0KDQo+IEFueXdheSwgYmUgY2FyZWZ1bCB0byBub3QgbWlzcyBzb21lIHZhbGlkIFBB
U0lEIGVudHJpZXMsIG9yIHdlDQo+IGNhbiBzdGlsbCB1c2UgdGhlIE1JTihQQVNJRF9NQVgsIENP
TlRFWFRfRU5UUllfU0laRSkgdG8gYmUgc2FmZSBhcyBhDQo+IGZpcnN0IHZlcnNpb24uICBUaGFu
a3MsDQoNCkFncmVlZC4gRmlyc3QgdmVyc2lvbiB0byBlbnN1cmUgMTAwJSBzYWZlLg0KDQpSZWdh
cmRzLA0KWWkgTGl1DQo=
