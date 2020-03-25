Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 638071923E6
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 10:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgCYJTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 05:19:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:31493 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgCYJTp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 05:19:45 -0400
IronPort-SDR: bDO90GJtSezuzoPa6BG2csYg3TH5qZFF8WtFP+Fvu24Y1nVriURY0b6cgh071JhzXt7JJ4OCZw
 vd15Dx7e4tqA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 02:19:45 -0700
IronPort-SDR: SVpkEtL6FQF9ihkm/7TmbdTES4u5cSE3X5XmrUP3NZxlVHQe7LhVjheklB4jM4H/VUHBQj4NvL
 XrlFsEUV38Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,303,1580803200"; 
   d="scan'208";a="393570476"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga004.jf.intel.com with ESMTP; 25 Mar 2020 02:19:44 -0700
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 02:19:44 -0700
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 25 Mar 2020 02:19:44 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.206]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.155]) with mapi id 14.03.0439.000;
 Wed, 25 Mar 2020 17:19:40 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: RE: [PATCH v1 21/22] intel_iommu: process PASID-based Device-TLB
 invalidation
Thread-Topic: [PATCH v1 21/22] intel_iommu: process PASID-based Device-TLB
 invalidation
Thread-Index: AQHWAEW3SLxZzekg2UiXjepI51bQEKhXj4aAgAF819A=
Date:   Wed, 25 Mar 2020 09:19:39 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A201D7B@SHSMSX104.ccr.corp.intel.com>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-22-git-send-email-yi.l.liu@intel.com>
 <20200324183611.GF127076@xz-x1>
In-Reply-To: <20200324183611.GF127076@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwg
TWFyY2ggMjUsIDIwMjAgMjozNiBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjEgMjEvMjJdIGludGVsX2lvbW11OiBwcm9jZXNz
IFBBU0lELWJhc2VkIERldmljZS1UTEINCj4gaW52YWxpZGF0aW9uDQo+IA0KPiBPbiBTdW4sIE1h
ciAyMiwgMjAyMCBhdCAwNTozNjoxOEFNIC0wNzAwLCBMaXUgWWkgTCB3cm90ZToNCj4gPiBUaGlz
IHBhdGNoIGFkZHMgYW4gZW1wdHkgaGFuZGxpbmcgZm9yIFBBU0lELWJhc2VkIERldmljZS1UTEIN
Cj4gPiBpbnZhbGlkYXRpb24uIEZvciBub3cgaXQgaXMgZW5vdWdoIGFzIGl0IGlzIG5vdCBuZWNl
c3NhcnkgdG8gcHJvcGFnYXRlDQo+ID4gaXQgdG8gaG9zdCBmb3IgcGFzc3RocnUgZGV2aWNlIGFu
ZCBhbHNvIHRoZXJlIGlzIG5vIGVtdWxhdGVkIGRldmljZQ0KPiA+IGhhcyBkZXZpY2UgdGxiLg0K
PiA+DQo+ID4gQ2M6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KPiA+IENjOiBK
YWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiA+IENjOiBQZXRlciBY
dSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+ID4gQ2M6IFlpIFN1biA8eWkueS5zdW5AbGludXguaW50
ZWwuY29tPg0KPiA+IENjOiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPg0KPiA+
IENjOiBSaWNoYXJkIEhlbmRlcnNvbiA8cnRoQHR3aWRkbGUubmV0Pg0KPiA+IENjOiBFZHVhcmRv
IEhhYmtvc3QgPGVoYWJrb3N0QHJlZGhhdC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlp
IEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gDQo+IE9LIHRoaXMgcGF0Y2ggc2VlbXMgdG8gYmUg
bW9zdGx5IG1lYW5pbmdsZXNzLi4uIGJ1dCBPSyBzaW5jZSB5b3UndmUgd3JvdGUgaXQuLi4gOikN
Cj4gDQo+IFJldmlld2VkLWJ5OiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQoNClRoYW5r
cywNCllpIExpdQ0K
