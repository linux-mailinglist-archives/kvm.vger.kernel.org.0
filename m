Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881A064616
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 14:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfGJMQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 08:16:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:60415 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfGJMQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 08:16:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 05:16:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,474,1557212400"; 
   d="scan'208";a="364914178"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jul 2019 05:16:16 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:16:16 -0700
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 10 Jul 2019 05:16:16 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.110]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.109]) with mapi id 14.03.0439.000;
 Wed, 10 Jul 2019 20:16:14 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Peter Xu <zhexu@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Thread-Topic: [RFC v1 05/18] vfio/pci: add pasid alloc/free implementation
Thread-Index: AQHVM+ylZdJ7a+KBXU2HFFh5qj+Ya6bBDKUAgAK9roA=
Date:   Wed, 10 Jul 2019 12:16:14 +0000
Message-ID: <A2975661238FB949B60364EF0F2C257439F2A6F5@SHSMSX104.ccr.corp.intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
 <1562324511-2910-6-git-send-email-yi.l.liu@intel.com>
 <20190709022332.GC5178@xz-x1>
In-Reply-To: <20190709022332.GC5178@xz-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODdjNDNhMGMtYjA0OS00ZjM0LThiMjgtMDliZDRmZTViYTEwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaFlWXC9RODl2OWpIMWZHZlwvSEhMeGR0bUhGK09TbTNLVWUxSUsxUkZVT0ZjVk9mXC96MzZSbFZKXC9IbEV1MWRjRE4ifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBQZXRlciBYdSBbbWFpbHRvOnpoZXh1QHJlZGhhdC5jb21dDQo+IFNlbnQ6IFR1ZXNk
YXksIEp1bHkgOSwgMjAxOSAxMDoyNCBBTQ0KPiBUbzogTGl1LCBZaSBMIDx5aS5sLmxpdUBpbnRl
bC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDIHYxIDA1LzE4XSB2ZmlvL3BjaTogYWRkIHBhc2lk
IGFsbG9jL2ZyZWUgaW1wbGVtZW50YXRpb24NCj4gDQo+IE9uIEZyaSwgSnVsIDA1LCAyMDE5IGF0
IDA3OjAxOjM4UE0gKzA4MDAsIExpdSBZaSBMIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggYWRkcyB2
ZmlvIGltcGxlbWVudGF0aW9uIFBDSVBBU0lET3BzLmFsbG9jX3Bhc2lkL2ZyZWVfcGFzaWQoKS4N
Cj4gPiBUaGVzZSB0d28gZnVuY3Rpb25zIGFyZSB1c2VkIHRvIHByb3BhZ2F0ZSBndWVzdCBwYXNp
ZCBhbGxvY2F0aW9uIGFuZA0KPiA+IGZyZWUgcmVxdWVzdHMgdG8gaG9zdCB2aWEgdmZpbyBjb250
YWluZXIgaW9jdGwuDQo+ID4NCj4gPiBDYzogS2V2aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5j
b20+DQo+ID4gQ2M6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRlbC5jb20+DQo+
ID4gQ2M6IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT4NCj4gPiBDYzogRXJpYyBBdWdlciA8
ZXJpYy5hdWdlckByZWRoYXQuY29tPg0KPiA+IENjOiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4Lmlu
dGVsLmNvbT4NCj4gPiBDYzogRGF2aWQgR2lic29uIDxkYXZpZEBnaWJzb24uZHJvcGJlYXIuaWQu
YXU+DQo+ID4gU2lnbmVkLW9mZi1ieTogTGl1IFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBZaSBTdW4gPHlpLnkuc3VuQGxpbnV4LmludGVsLmNvbT4NCj4gPiAt
LS0NCj4gPiAgaHcvdmZpby9wY2kuYyB8IDYxDQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCA2
MSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvaHcvdmZpby9wY2kuYyBiL2h3
L3ZmaW8vcGNpLmMNCj4gPiBpbmRleCBjZTNmZTk2Li5hYjE4NGFkIDEwMDY0NA0KPiA+IC0tLSBh
L2h3L3ZmaW8vcGNpLmMNCj4gPiArKysgYi9ody92ZmlvL3BjaS5jDQo+ID4gQEAgLTI2OTAsNiAr
MjY5MCw2NSBAQCBzdGF0aWMgdm9pZCB2ZmlvX3VucmVnaXN0ZXJfcmVxX25vdGlmaWVyKFZGSU9Q
Q0lEZXZpY2UNCj4gKnZkZXYpDQo+ID4gICAgICB2ZGV2LT5yZXFfZW5hYmxlZCA9IGZhbHNlOw0K
PiA+ICB9DQo+ID4NCj4gPiArc3RhdGljIGludCB2ZmlvX3BjaV9kZXZpY2VfcmVxdWVzdF9wYXNp
ZF9hbGxvYyhQQ0lCdXMgKmJ1cywNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBpbnQzMl90IGRldmZuLA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVpbnQzMl90IG1pbl9wYXNpZCwNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1aW50MzJfdCBtYXhf
cGFzaWQpDQo+ID4gK3sNCj4gPiArICAgIFBDSURldmljZSAqcGRldiA9IGJ1cy0+ZGV2aWNlc1tk
ZXZmbl07DQo+ID4gKyAgICBWRklPUENJRGV2aWNlICp2ZGV2ID0gRE9fVVBDQVNUKFZGSU9QQ0lE
ZXZpY2UsIHBkZXYsIHBkZXYpOw0KPiA+ICsgICAgVkZJT0NvbnRhaW5lciAqY29udGFpbmVyID0g
dmRldi0+dmJhc2VkZXYuZ3JvdXAtPmNvbnRhaW5lcjsNCj4gPiArICAgIHN0cnVjdCB2ZmlvX2lv
bW11X3R5cGUxX3Bhc2lkX3JlcXVlc3QgcmVxOw0KPiA+ICsgICAgdW5zaWduZWQgbG9uZyBhcmdz
ejsNCj4gPiArICAgIGludCBwYXNpZDsNCj4gPiArDQo+ID4gKyAgICBhcmdzeiA9IHNpemVvZihy
ZXEpOw0KPiA+ICsgICAgcmVxLmFyZ3N6ID0gYXJnc3o7DQo+ID4gKyAgICByZXEuZmxhZyA9IFZG
SU9fSU9NTVVfUEFTSURfQUxMT0M7DQo+ID4gKyAgICByZXEubWluX3Bhc2lkID0gbWluX3Bhc2lk
Ow0KPiA+ICsgICAgcmVxLm1heF9wYXNpZCA9IG1heF9wYXNpZDsNCj4gPiArDQo+ID4gKyAgICBy
Y3VfcmVhZF9sb2NrKCk7DQo+IA0KPiBDb3VsZCBJIGFzayB3aGF0J3MgdGhpcyBSQ1UgbG9jayBw
cm90ZWN0aW5nPw0KDQpnb29kIGNhdGNoLCBsZXQgbWUgcmVtb3ZlIGl0Lg0KDQo+IA0KPiA+ICsg
ICAgcGFzaWQgPSBpb2N0bChjb250YWluZXItPmZkLCBWRklPX0lPTU1VX1BBU0lEX1JFUVVFU1Qs
ICZyZXEpOw0KPiA+ICsgICAgaWYgKHBhc2lkIDwgMCkgew0KPiA+ICsgICAgICAgIGVycm9yX3Jl
cG9ydCgidmZpb19wY2lfZGV2aWNlX3JlcXVlc3RfcGFzaWRfYWxsb2M6Ig0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAiIHJlcXVlc3QgZmFpbGVkLCBjb250YW5pZXI6ICVwIiwgY29udGFpbmVy
KTsNCj4gDQo+IENhbiB1c2UgX19mdW5jX18sIGFsc28gc2luY2Ugd2UncmUgZ29pbmcgdG8gZHVt
cCB0aGUgZXJyb3IgYWZ0ZXIgYWxsLA0KPiB3ZSBjYW4gYWxzbyBpbmNsdWRlIHRoZSBlcnJubyAo
cGFzaWQpIGhlcmUgd2hpY2ggc2VlbXMgdG8gYmUgbW9yZQ0KPiBoZWxwZnVsIHRoYW4gdGhlIGNv
bnRhaW5lciBwb2ludGVyIGF0IGxlYXN0IHRvIG1lLiA6KQ0KDQphY2NlcHRlZCwgdGhhbmtzLg0K
DQo+ID4gKyAgICB9DQo+ID4gKyAgICByY3VfcmVhZF91bmxvY2soKTsNCj4gPiArICAgIHJldHVy
biBwYXNpZDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCB2ZmlvX3BjaV9kZXZpY2Vf
cmVxdWVzdF9wYXNpZF9mcmVlKFBDSUJ1cyAqYnVzLA0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50MzJfdCBkZXZmbiwNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHVpbnQzMl90IHBhc2lkKQ0KPiA+
ICt7DQo+ID4gKyAgICBQQ0lEZXZpY2UgKnBkZXYgPSBidXMtPmRldmljZXNbZGV2Zm5dOw0KPiA+
ICsgICAgVkZJT1BDSURldmljZSAqdmRldiA9IERPX1VQQ0FTVChWRklPUENJRGV2aWNlLCBwZGV2
LCBwZGV2KTsNCj4gPiArICAgIFZGSU9Db250YWluZXIgKmNvbnRhaW5lciA9IHZkZXYtPnZiYXNl
ZGV2Lmdyb3VwLT5jb250YWluZXI7DQo+ID4gKyAgICBzdHJ1Y3QgdmZpb19pb21tdV90eXBlMV9w
YXNpZF9yZXF1ZXN0IHJlcTsNCj4gPiArICAgIHVuc2lnbmVkIGxvbmcgYXJnc3o7DQo+ID4gKyAg
ICBpbnQgcmV0ID0gMDsNCj4gPiArDQo+ID4gKyAgICBhcmdzeiA9IHNpemVvZihyZXEpOw0KPiA+
ICsgICAgcmVxLmFyZ3N6ID0gYXJnc3o7DQo+ID4gKyAgICByZXEuZmxhZyA9IFZGSU9fSU9NTVVf
UEFTSURfRlJFRTsNCj4gPiArICAgIHJlcS5wYXNpZCA9IHBhc2lkOw0KPiA+ICsNCj4gPiArICAg
IHJjdV9yZWFkX2xvY2soKTsNCj4gPiArICAgIHJldCA9IGlvY3RsKGNvbnRhaW5lci0+ZmQsIFZG
SU9fSU9NTVVfUEFTSURfUkVRVUVTVCwgJnJlcSk7DQo+ID4gKyAgICBpZiAocmV0ICE9IDApIHsN
Cj4gPiArICAgICAgICBlcnJvcl9yZXBvcnQoInZmaW9fcGNpX2RldmljZV9yZXF1ZXN0X3Bhc2lk
X2ZyZWU6Ig0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAiIHJlcXVlc3QgZmFpbGVkLCBjb250
YW5pZXI6ICVwIiwgY29udGFpbmVyKTsNCj4gPiArICAgIH0NCj4gPiArICAgIHJjdV9yZWFkX3Vu
bG9jaygpOw0KPiA+ICsgICAgcmV0dXJuIHJldDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGlj
IFBDSVBBU0lET3BzIHZmaW9fcGNpX3Bhc2lkX29wcyA9IHsNCj4gPiArICAgIC5hbGxvY19wYXNp
ZCA9IHZmaW9fcGNpX2RldmljZV9yZXF1ZXN0X3Bhc2lkX2FsbG9jLA0KPiA+ICsgICAgLmZyZWVf
cGFzaWQgPSB2ZmlvX3BjaV9kZXZpY2VfcmVxdWVzdF9wYXNpZF9mcmVlLA0KPiA+ICt9Ow0KPiA+
ICsNCj4gPiAgc3RhdGljIHZvaWQgdmZpb19yZWFsaXplKFBDSURldmljZSAqcGRldiwgRXJyb3Ig
KiplcnJwKQ0KPiA+ICB7DQo+ID4gICAgICBWRklPUENJRGV2aWNlICp2ZGV2ID0gUENJX1ZGSU8o
cGRldik7DQo+ID4gQEAgLTI5OTEsNiArMzA1MCw4IEBAIHN0YXRpYyB2b2lkIHZmaW9fcmVhbGl6
ZShQQ0lEZXZpY2UgKnBkZXYsIEVycm9yICoqZXJycCkNCj4gPiAgICAgIHZmaW9fcmVnaXN0ZXJf
cmVxX25vdGlmaWVyKHZkZXYpOw0KPiA+ICAgICAgdmZpb19zZXR1cF9yZXNldGZuX3F1aXJrKHZk
ZXYpOw0KPiA+DQo+ID4gKyAgICBwY2lfc2V0dXBfcGFzaWRfb3BzKHBkZXYsICZ2ZmlvX3BjaV9w
YXNpZF9vcHMpOw0KPiA+ICsNCj4gPiAgICAgIHJldHVybjsNCj4gPg0KPiA+ICBvdXRfdGVhcmRv
d246DQo+ID4gLS0NCj4gPiAyLjcuNA0KPiA+DQo+IA0KPiBSZWdhcmRzLA0KPiANCj4gLS0NCj4g
UGV0ZXIgWHUNCg0KVGhhbmtzLA0KWWkgTGl1DQo=
