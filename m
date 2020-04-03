Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A489A19D9FB
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 17:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgDCPWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 11:22:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:48351 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403991AbgDCPWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 11:22:02 -0400
IronPort-SDR: AkR+1BJjd+FfvGTvEUfS4vMCfM/pdJz81WOAnh/fH8p03M1/ezc4DTMe+vSlobIRushWZvkkcU
 kg4PxXWNtk1A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2020 08:22:01 -0700
IronPort-SDR: f18KJOPBARxqq+jwBPeF22qGTZqDi8tT7KRl4cyGw3aUNSWwhi8RIFvPhj7N/hlRGChUQsiQtX
 /woycPv2B0yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,340,1580803200"; 
   d="scan'208";a="241145420"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga007.fm.intel.com with ESMTP; 03 Apr 2020 08:22:01 -0700
Received: from FMSMSX109.amr.corp.intel.com (10.18.116.9) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 08:22:01 -0700
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx109.amr.corp.intel.com (10.18.116.9) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 3 Apr 2020 08:22:00 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.138]) with mapi id 14.03.0439.000;
 Fri, 3 Apr 2020 23:21:57 +0800
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
Subject: RE: [PATCH v2 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Thread-Topic: [PATCH v2 19/22] intel_iommu: process PASID-based iotlb
 invalidation
Thread-Index: AQHWBkplO1jjT6AjC0K+wjIyCHcvO6hm+tuAgACPoRA=
Date:   Fri, 3 Apr 2020 15:21:56 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A220E5F@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-20-git-send-email-yi.l.liu@intel.com>
 <20200403144719.GL103677@xz-x1>
In-Reply-To: <20200403144719.GL103677@xz-x1>
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

PiBGcm9tOiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXBy
aWwgMywgMjAyMCAxMDo0NyBQTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+
DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMTkvMjJdIGludGVsX2lvbW11OiBwcm9jZXNzIFBB
U0lELWJhc2VkIGlvdGxiIGludmFsaWRhdGlvbg0KPiANCj4gT24gU3VuLCBNYXIgMjksIDIwMjAg
YXQgMDk6MjQ6NThQTSAtMDcwMCwgTGl1IFlpIEwgd3JvdGU6DQo+ID4gVGhpcyBwYXRjaCBhZGRz
IHRoZSBiYXNpYyBQQVNJRC1iYXNlZCBpb3RsYiAocGlvdGxiKSBpbnZhbGlkYXRpb24NCj4gPiBz
dXBwb3J0LiBwaW90bGIgaXMgdXNlZCBkdXJpbmcgd2Fsa2luZyBJbnRlbCBWVC1kIDFzdCBsZXZl
bCBwYWdlDQo+ID4gdGFibGUuIFRoaXMgcGF0Y2ggb25seSBhZGRzIHRoZSBiYXNpYyBwcm9jZXNz
aW5nLiBEZXRhaWxlZCBoYW5kbGluZw0KPiA+IHdpbGwgYmUgYWRkZWQgaW4gbmV4dCBwYXRjaC4N
Cj4gPg0KPiA+IENjOiBLZXZpbiBUaWFuIDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gPiBDYzog
SmFjb2IgUGFuIDxqYWNvYi5qdW4ucGFuQGxpbnV4LmludGVsLmNvbT4NCj4gPiBDYzogUGV0ZXIg
WHUgPHBldGVyeEByZWRoYXQuY29tPg0KPiA+IENjOiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPiBDYzogUGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4NCj4g
PiBDYzogUmljaGFyZCBIZW5kZXJzb24gPHJ0aEB0d2lkZGxlLm5ldD4NCj4gPiBDYzogRWR1YXJk
byBIYWJrb3N0IDxlaGFia29zdEByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExpdSBZ
aSBMIDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogUGV0ZXIgWHUgPHBl
dGVyeEByZWRoYXQuY29tPg0KPiANCnRoYW5rcyBmb3IgeW91ciBoZWxwLiA6LSkNCg0KUmVnYXJk
cywNCllpIExpdQ0K
