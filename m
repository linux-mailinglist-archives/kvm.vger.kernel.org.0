Return-Path: <kvm+bounces-30420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 341859B9EDD
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 11:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A85251F2160B
	for <lists+kvm@lfdr.de>; Sat,  2 Nov 2024 10:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67188170A01;
	Sat,  2 Nov 2024 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Ch5AjQx1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00714EB50;
	Sat,  2 Nov 2024 10:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730542983; cv=none; b=KhplhWhbaiieDf1nMM3tzCHKo1sJ00YSCD6uvgYf8mKboowD6h9xvkdMOYNcwIZs45Dy075IN6sHqKE+ahsIbFWjMwDu1BWAV9j0eXsf3FRJTonrzCCxz92hvo39lhRt/rkKFb4kICI9HIVz9qeUhO/NKvlglLDvKS5UfQVnI3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730542983; c=relaxed/simple;
	bh=Hui5t1gehMTdty4pXjzuyHcceV0JNyhjLbGDeQM1nTY=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ztd9Dcr7ARgDW7GQqHaiDvUFfsSWGY1S2YKo3lVYCJrNCp9ql/++cbjtgiiDAEm5K93mG5nuxlc7ie4bbNdAVcrOw8QBGECqPsawOAbgkhKl9pBB8bwUciCS021t4wdjpIBmn7AFJOPyzCJGAnTVDkjq75hgDOYvciz3Sbn5p7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=Ch5AjQx1; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1730542982; x=1762078982;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=Hui5t1gehMTdty4pXjzuyHcceV0JNyhjLbGDeQM1nTY=;
  b=Ch5AjQx1NURMQgHf6CK38UOrDZmXG7m8Sz4qmQ/ozza42GJlfTw0Ccy9
   byWl6rKUOQRUUx4j5T5Pqp1cQV9aTIh/QttvfhOwjkJUWaoCzGn5GvRFO
   GNy37mQf1erIEIrxAuTCWGDaBOKpihCrKcwdMaplNcexTcs9kaCd9fD9t
   Y=;
X-IronPort-AV: E=Sophos;i="6.11,252,1725321600"; 
   d="scan'208";a="445826218"
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Thread-Topic: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2024 10:22:58 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:23491]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.52:2525] with esmtp (Farcaster)
 id e7310b3f-1e45-4905-85dc-9b1ecd70ac2a; Sat, 2 Nov 2024 10:22:56 +0000 (UTC)
X-Farcaster-Flow-ID: e7310b3f-1e45-4905-85dc-9b1ecd70ac2a
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 2 Nov 2024 10:22:55 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Sat, 2 Nov 2024 10:22:54 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.034; Sat, 2 Nov 2024 10:22:54 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "jacob.pan@linux.microsoft.com" <jacob.pan@linux.microsoft.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>, "jinankjain@linux.microsoft.com"
	<jinankjain@linux.microsoft.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "kw@linux.com" <kw@linux.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "madvenka@linux.microsoft.com"
	<madvenka@linux.microsoft.com>, "anthony.yznaga@oracle.com"
	<anthony.yznaga@oracle.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Saenz Julienne, Nicolas"
	<nsaenz@amazon.es>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"will@kernel.org" <will@kernel.org>, "Graf (AWS), Alexander"
	<graf@amazon.de>, "steven.sistare@oracle.com" <steven.sistare@oracle.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>
Thread-Index: AQHbCCwuWjwUDEQNSEmjPqzUeT3bK7KKIvOAgBJyeoCAB3yRAA==
Date: Sat, 2 Nov 2024 10:22:54 +0000
Message-ID: <1f50020d9bd74ab8315cec473d3e6285d0fc8259.camel@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
	 <20240916113102.710522-6-jgowans@amazon.com>
	 <20241016152047.2a604f08@DESKTOP-0403QTC.>
	 <20241028090311.54bc537f@DESKTOP-0403QTC.>
In-Reply-To: <20241028090311.54bc537f@DESKTOP-0403QTC.>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <E287AEB17CC88C4A8C68D6AC15942C94@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGkgSmFjb2IsIGFwb2xvZ2llcyBmb3IgdGhlIGxhdGUgcmVwbHkuDQoNCk9uIE1vbiwgMjAyNC0x
MC0yOCBhdCAwOTowMyAtMDcwMCwgSmFjb2IgUGFuIHdyb3RlOg0KPiBIaSBKYW1lcywNCj4gDQo+
IEp1c3QgYSBnZW50bGUgcmVtaW5kZXIuIExldCBtZSBhbHNvIGV4cGxhaW4gdGhlIHByb2JsZW0g
d2UgYXJlIHRyeWluZw0KPiB0byBzb2x2ZSBmb3IgdGhlIGxpdmUgdXBkYXRlIG9mIE9wZW5IQ0wg
cGFyYXZpc29yWzFdLiBPcGVuSENMIGhhcyB1c2VyDQo+IHNwYWNlIGRyaXZlcnMgYmFzZWQgb24g
VkZJTyBub2lvbW11IG1vZGUsIHdlIGFyZSBpbiB0aGUgcHJvY2VzcyBvZg0KPiBjb252ZXJ0aW5n
IHRvIGlvbW11ZmQgY2Rldi4NCj4gDQo+IFNpbWlsYXJseSwgcnVubmluZyBETUEgY29udGludW91
c2x5IGFjcm9zcyB1cGRhdGVzIGlzIHJlcXVpcmVkLCBidXQNCj4gdW5saWtlIHlvdXIgY2FzZSwg
T3BlbkhDTCB1cGRhdGVzIGRvIG5vdCBpbnZvbHZlIHByZXNlcnZpbmcgdGhlIElPIHBhZ2UNCj4g
dGFibGVzIGluIHRoYXQgaXQgaXMgbWFuYWdlZCBieSB0aGUgaHlwZXJ2aXNvciB3aGljaCBpcyBu
b3QgcGFydCBvZiB0aGUNCj4gdXBkYXRlLg0KPiANCj4gSXQgc2VlbXMgcmVhc29uYWJsZSB0byBz
aGFyZSB0aGUgZGV2aWNlIHBlcnNpc3RlbmNlIGNvZGUgcGF0aA0KPiB3aXRoIHRoZSBwbGFuIGxh
aWQgb3V0IGluIHlvdXIgY292ZXIgbGV0dGVyLiBJT0FTIGNvZGUgcGF0aCB3aWxsIGJlDQo+IGRp
ZmZlcmVudCBzaW5jZSBub2lvbW11IG9wdGlvbiBkb2VzIG5vdCBoYXZlIElPQVMuDQo+IA0KPiBJ
ZiB3ZSB3ZXJlIHRvIHJldml2ZSBub2lvbW11IHN1cHBvcnQgZm9yIGlvbW11ZmQgY2RldlsyXSwg
Y2FuIHdlIHVzZQ0KPiB0aGUgcGVyc2lzdGVudCBpb21tdWZkIGNvbnRleHQgdG8gYWxsb3cgZGV2
aWNlIHBlcnNpc3RlbmNlPyBQZXJoYXBzDQo+IHRocm91Z2ggSU9NTVVGRF9PQkpfREVWSUNFIGFu
ZCBJT01NVUZEX09CSl9BQ0NFU1ModXNlZCBpbiBbMl0pPw0KPiANCj4gQERhdmlkLCBASmFzb24s
IEBBbGV4LCBAWWksIGFueSBjb21tZW50cyBvciBzdWdnZXN0aW9ucz8NCg0KSUlSQyB3ZSBkaWQg
ZGlzY3VzcyB0aGlzIGRldmljZSBwZXJzaXN0ZW5jZSB1c2UgY2FzZSB3aXRoIHNvbWUgb2YgeW91
cg0KY29sbGVhZ3VlcyBhdCBMaW51eCBQbHVtYmVycy4gQWRkaW5nIEppbmFuayB0byB0aGlzIHRo
cmVhZCBhcyBoZSB3YXMNCnBhcnQgb2YgdGhlIGNvbnZlcnNhdGlvbiB0b28uDQoNClllcywgSSB0
aGluayB0aGUgZ3VpZGFuY2Ugd2FzIHRvIGJpbmQgYSBkZXZpY2UgdG8gaW9tbXVmZCBpbiBub2lv
bW11DQptb2RlLiBJdCBkb2VzIHNlZW0gYSBiaXQgd2VpcmQgdG8gdXNlIGlvbW11ZmQgd2l0aCBu
b2lvbW11LCBidXQgd2UNCmFncmVlZCBpdCdzIHRoZSBiZXN0L3NpbXBsZXN0IHdheSB0byBnZXQg
dGhlIGZ1bmN0aW9uYWxpdHkuIFRoZW4gYXMgeW91DQpzdWdnZXN0IGJlbG93IHRoZSBJT01NVUZE
X09CSl9ERVZJQ0Ugd291bGQgYmUgc2VyaWFsaXNlZCB0b28gaW4gc29tZQ0Kd2F5LCBwcm9iYWJs
eSBieSBpb21tdWZkIHRlbGxpbmcgdGhlIFBDSSBsYXllciB0aGF0IHRoaXMgZGV2aWNlIG11c3Qg
YmUNCnBlcnNpc3RlbnQgYW5kIGhlbmNlIG5vdCB0byByZS1wcm9iZSBpdCBvbiBrZXhlYy4gSSB0
aGluayB0aGlzIHdvdWxkIGdldA0KeW91IHdoYXQgeW91IHdhbnQ/IFNwZWNpZmljYWxseSB5b3Ug
d2FudCB0byBtYWtlIHN1cmUgdGhhdCB0aGUgZGV2aWNlIGlzDQpub3QgcmVzZXQgZHVyaW5nIGtl
eGVjIHNvIGl0IGNhbiBrZWVwIHJ1bm5pbmc/IEFuZCBzb21lIGhhbmRsZSBmb3INCnVzZXJzcGFj
ZSB0byBwaWNrIGl0IHVwIGFnYWluIGFuZCBjb250aW51ZSBpbnRlcmFjdGluZyB3aXRoIGl0IGFm
dGVyDQprZXhlYy4NCg0KSXQncyBhbGwgYSBiaXQgaGFuZCB3YXZ5IGF0IHRoZSBtb21lbnQsIGJ1
dCBzb21ldGhpbmcgYWxvbmcgdGhvc2UgbGluZXMNCnByb2JhYmx5IG1ha2VzIHNlbnNlLiBJIG5l
ZWQgdG8gd29yayBvbiByZXYyIG9mIHRoaXMgUkZDIGFzIHBlciBKYXNvbidzDQpmZWVkYmFjayBp
biB0aGUgb3RoZXIgdGhyZWFkLiBSZXYyIHdpbGwgbWFrZSB0aGUgcmVzdG9yZSBwYXRoIG1vcmUN
CnVzZXJzcGFjZSBkcml2ZW4sIHdpdGggZnJlc2ggaW9tbXVmZCBhbmQgcGd0YWJsZXMgb2JqZWN0
cyBiZWluZyBjcmVhdGVkDQphbmQgdGhlbiBhdG9taWNhbGx5IHN3YXBwZWQgb3ZlciB0b28uIEkn
bGwgYWxzbyBnZXQgdGhlIFBDSSBsYXllcg0KaW52b2x2ZWQgd2l0aCByZXYyLiBPbmNlIHRoYXQn
cyBvdXQgKGl0J2xsIGJlIGEgZmV3IHdlZWtzIGFzIEknbSBvbg0KbGVhdmUpIHRoZW4gbGV0J3Mg
dGFrZSBhIGxvb2sgYXQgaG93IHRoZSBub2lvbW11IGRldmljZSBwZXJzaXN0ZW5jZSBjYXNlDQp3
b3VsZCBmaXQgaW4uDQoNCkpHDQoNCj4gDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBKYWNvYg0KPiAN
Cj4gMS4gKG9wZW52bW0vR3VpZGUvc3JjL3JlZmVyZW5jZS9hcmNoaXRlY3R1cmUvb3BlbmhjbC5t
ZCBhdCBtYWluIMK3DQo+IG1pY3Jvc29mdC9vcGVudm1tLg0KPiAyLiBbUEFUQ0ggdjExIDAwLzIz
XSBBZGQgdmZpb19kZXZpY2UgY2RldiBmb3INCj4gaW9tbXVmZCBzdXBwb3J0IC0gWWkgTGl1DQo+
IA0KPiBPbiBXZWQsIDE2IE9jdCAyMDI0IDE1OjIwOjQ3IC0wNzAwIEphY29iIFBhbg0KPiA8amFj
b2IucGFuQGxpbnV4Lm1pY3Jvc29mdC5jb20+IHdyb3RlOg0KPiANCj4gPiBIaSBKYW1lcywNCj4g
PiANCj4gPiBPbiBNb24sIDE2IFNlcCAyMDI0IDEzOjMwOjU0ICswMjAwDQo+ID4gSmFtZXMgR293
YW5zIDxqZ293YW5zQGFtYXpvbi5jb20+IHdyb3RlOg0KPiA+IA0KPiA+ID4gK3N0YXRpYyBpbnQg
c2VyaWFsaXNlX2lvbW11ZmQodm9pZCAqZmR0LCBzdHJ1Y3QgaW9tbXVmZF9jdHggKmljdHgpDQo+
ID4gPiArew0KPiA+ID4gKyAgIGludCBlcnIgPSAwOw0KPiA+ID4gKyAgIGNoYXIgbmFtZVsyNF07
DQo+ID4gPiArICAgc3RydWN0IGlvbW11ZmRfb2JqZWN0ICpvYmo7DQo+ID4gPiArICAgdW5zaWdu
ZWQgbG9uZyBvYmpfaWR4Ow0KPiA+ID4gKw0KPiA+ID4gKyAgIHNucHJpbnRmKG5hbWUsIHNpemVv
ZihuYW1lKSwgIiVsdSIsIGljdHgtPnBlcnNpc3RlbnRfaWQpOw0KPiA+ID4gKyAgIGVyciB8PSBm
ZHRfYmVnaW5fbm9kZShmZHQsIG5hbWUpOw0KPiA+ID4gKyAgIGVyciB8PSBmZHRfYmVnaW5fbm9k
ZShmZHQsICJpb2FzZXMiKTsNCj4gPiA+ICsgICB4YV9mb3JfZWFjaCgmaWN0eC0+b2JqZWN0cywg
b2JqX2lkeCwgb2JqKSB7DQo+ID4gPiArICAgICAgICAgICBzdHJ1Y3QgaW9tbXVmZF9pb2FzICpp
b2FzOw0KPiA+ID4gKyAgICAgICAgICAgc3RydWN0IGlvcHRfYXJlYSAqYXJlYTsNCj4gPiA+ICsg
ICAgICAgICAgIGludCBhcmVhX2lkeCA9IDA7DQo+ID4gPiArDQo+ID4gPiArICAgICAgICAgICBp
ZiAob2JqLT50eXBlICE9IElPTU1VRkRfT0JKX0lPQVMpDQo+ID4gPiArICAgICAgICAgICAgICAg
ICAgIGNvbnRpbnVlOw0KPiA+IEkgd2FzIHdvbmRlcmluZyBob3cgZGV2aWNlIHN0YXRlIHBlcnNp
c3RlbmN5IGlzIG1hbmFnZWQgaGVyZS4gSXMgaXQNCj4gPiBjb3JyZWN0IHRvIGFzc3VtZSB0aGF0
IGFsbCBkZXZpY2VzIGJvdW5kIHRvIGFuIGlvbW11ZmQgY29udGV4dCBzaG91bGQNCj4gPiBiZSBw
ZXJzaXN0ZW50PyBJZiBzbywgc2hvdWxkIHdlIGJlIHNlcmlhbGl6aW5nIElPTU1VRkRfT0JKX0RF
VklDRSBhcw0KPiA+IHdlbGw/DQo+ID4gDQo+ID4gSSdtIGNvbnNpZGVyaW5nIHRoaXMgZnJvbSB0
aGUgcGVyc3BlY3RpdmUgb2YgdXNlciBtb2RlIGRyaXZlcnMsDQo+ID4gaW5jbHVkaW5nIHRob3Nl
IHRoYXQgdXNlIG5vaW9tbXUgbW9kZSAobmVlZCB0byBiZSBhZGRlZCB0byBpb21tdWZkDQo+ID4g
Y2RldikuIEluIHRoaXMgc2NlbmFyaW8sIHdlIG9ubHkgbmVlZCB0byBtYWludGFpbiB0aGUgZGV2
aWNlIHN0YXRlcw0KPiA+IHBlcnNpc3RlbnRseSB3aXRob3V0IElPQVMuDQo+IA0KDQo=

