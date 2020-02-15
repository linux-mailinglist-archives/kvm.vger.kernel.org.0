Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FFF15FDB5
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 09:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgBOIuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Feb 2020 03:50:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:39852 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgBOIuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Feb 2020 03:50:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Feb 2020 00:50:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,443,1574150400"; 
   d="scan'208";a="433280509"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 15 Feb 2020 00:50:23 -0800
Received: from fmsmsx152.amr.corp.intel.com (10.18.125.5) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 15 Feb 2020 00:50:23 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX152.amr.corp.intel.com (10.18.125.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 15 Feb 2020 00:50:22 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.201]) with mapi id 14.03.0439.000;
 Sat, 15 Feb 2020 16:50:20 +0800
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
Subject: RE: [RFC v3 16/25] intel_iommu: add PASID cache management
 infrastructure
Thread-Topic: [RFC v3 16/25] intel_iommu: add PASID cache management
 infrastructure
Thread-Index: AQHV1p1QpD/IVrZuSU6bcoY7cN43AagWNKIAgAEU7GD///SzgIABQpxQgABMTYCAAz89AA==
Date:   Sat, 15 Feb 2020 08:50:20 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1BE87E@SHSMSX104.ccr.corp.intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-17-git-send-email-yi.l.liu@intel.com>
 <20200211233548.GO984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA669@SHSMSX104.ccr.corp.intel.com>
 <20200212152629.GA1083891@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BBCA9@SHSMSX104.ccr.corp.intel.com>
 <20200213151415.GC1103216@xz-x1>
In-Reply-To: <20200213151415.GC1103216@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjJmNDcwZmUtMWVkMS00OGMzLTk1YTQtMDllOTgzOTNlYzQ4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoid3VKVE5cL0ltdHdpOW8wZEp2MUFRSUJpWDFzc0dtYWZKXC94YUIyTVBPOGx2bm8xanluUHRkVExJTkxlVEUyeUJnIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgWHUgPHBldGVy
eEByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMTMsIDIwMjAgMTE6MTQg
UE0NCj4gVG86IExpdSwgWWkgTCA8eWkubC5saXVAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1JGQyB2MyAxNi8yNV0gaW50ZWxfaW9tbXU6IGFkZCBQQVNJRCBjYWNoZSBtYW5hZ2VtZW50DQo+
IGluZnJhc3RydWN0dXJlDQo+IA0KPiBPbiBUaHUsIEZlYiAxMywgMjAyMCBhdCAwMjo1OTozN0FN
ICswMDAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gPiAtIFJlbW92ZSB0aGUgdnRkX3Bhc2lkX2Fz
IGNoZWNrIHJpZ2h0IGJlbG93IGJlY2F1c2UgaXQncyBub3QgbmVlZGVkLg0KPiA+ID4NCj4gPiA+
ID4NCj4gPiA+ID4NCj4gPiA+ID4gPiA+ICsgICAgICAgIGlmICh2dGRfcGFzaWRfYXMgJiYNCj4g
PiA+ICAgICAgICAgICAgICAgICAgICBeXl5eXl5eXl5eXl4NCj4gPg0KPiA+IHllcywgaXQgaXMu
IEluIGN1cnJlbnQgc2VyaWVzIHZ0ZF9hZGRfZmluZF9wYXNpZF9hcygpIGRvZXNu4oCZdCBjaGVj
ayB0aGUNCj4gPiByZXN1bHQgb2YgdnRkX3Bhc2lkX2FzIG1lbSBhbGxvY2F0aW9uLCBzbyBubyBu
ZWVkIHRvIGNoZWNrIHZ0ZF9wYXNpZF9hcw0KPiA+IGhlcmUgZWl0aGVyLiBIb3dldmVyLCBpdCBt
aWdodCBiZSBiZXR0ZXIgdG8gY2hlY2sgdGhlIGFsbG9jYXRpb24gcmVzdWx0DQo+ID4gb3IgaXQg
d2lsbCByZXN1bHQgaW4gaXNzdWUgaWYgYWxsb2NhdGlvbiBmYWlsZWQuIFdoYXQncyB5b3VyIHBy
ZWZlcmVuY2UNCj4gPiBoZXJlPw0KPiANCj4gVGhhdCBzaG91bGQgbm90IGJlIG5lZWRlZCwgYmVj
YXVzZSBJSVJDIGdfbWFsbG9jMCgpIHdpbGwgZGlyZWN0bHkNCj4gY29yZWR1bXAgaWYgYWxsb2Nh
dGlvbiBmYWlscy4gIEV2ZW4gaWYgbm90LCBpdCdsbCBjb3JlZHVtcCBpbg0KPiB2dGRfYWRkX2Zp
bmRfcGFzaWRfYXMoKSBzb29uIHdoZW4gYWNjZXNzaW5nIHRoZSBOVUxMIHBvaW50ZXIuDQoNCkNv
b2wsIHRoYW5rcyBmb3IgdGhpcyBtZXNzYWdlLiBUaGVuIEknbGwgZm9sbG93IHlvdXIgc3VnZ2Vz
dGlvbiAgdG8gIHJlbW92ZQ0KdGhlIHZ0ZF9wYXNpZF9hcyBjaGVjay4NCg0KUmVnYXJkcywNCllp
IExpdQ0K
