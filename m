Return-Path: <kvm+bounces-25834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0964F96B272
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 09:11:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F396B25C57
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 07:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6137214658D;
	Wed,  4 Sep 2024 07:11:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E91413B295;
	Wed,  4 Sep 2024 07:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725433887; cv=none; b=EQKwgrSY3IzI2owztw/Jec02rOWIfOQ7bDSl//ulXQsF83j+GBrYS2LoawbPWW+926xkgAB9qYPyK8D5MRj2IK9ke9m0EoAHpJgvXqa0j0Ie0moxkBIu+cdrFe5tNklm4/nQcoG5I8mCOeaAYz9uTQ+heT0Z4+0iC64VhA+XgKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725433887; c=relaxed/simple;
	bh=XUia+7rc1rUXT14/Otf2vEXD49C/QKG8Z2n50lG3/SI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kRXp3+Ms7w+ge6M0aLWOmUXhsD3fmkNo6gUVBsvMO0/IDSK+pJ2rneeTC7EDal+O6t6pCHP5423B87EmTq20vBaJAkQ3XAiz9MYzVOdgjltLhH8w73Vf5zYkutELBW/AfqIiJxOnKUnEBVj0pXv/l3p/MEJke2ZbHmzjTFVUgA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WzD8q1Tdvz1HJ84;
	Wed,  4 Sep 2024 15:07:55 +0800 (CST)
Received: from dggpemf200002.china.huawei.com (unknown [7.185.36.244])
	by mail.maildlp.com (Postfix) with ESMTPS id 8227714011D;
	Wed,  4 Sep 2024 15:11:22 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 dggpemf200002.china.huawei.com (7.185.36.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 4 Sep 2024 15:11:21 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Wed, 4 Sep 2024 08:11:19 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Mostafa Saleh <smostafa@google.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, "Guohanjun
 (Hanjun Guo)" <guohanjun@huawei.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Len
 Brown" <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Robert
 Moore" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, "Sudeep
 Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Thread-Topic: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Thread-Index: AQHa+JkM44hgQT3eCE+0H/cNBDIGbrI/3zqAgAAfZACABEBRAIAA7EQAgACK+ICAAP0kgIAAil8A
Date: Wed, 4 Sep 2024 07:11:19 +0000
Message-ID: <9e8153c95b664726bd7fcb6d0605610a@huawei.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com> <20240830171602.GX3773488@nvidia.com>
 <ZtWPRDsQ-VV-6juL@google.com> <20240903001654.GE3773488@nvidia.com>
 <ZtbKCb9FTt5gjERf@google.com> <20240903234019.GI3773488@nvidia.com>
In-Reply-To: <20240903234019.GI3773488@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgNCwgMjAyNCAx
Mjo0MCBBTQ0KPiBUbzogTW9zdGFmYSBTYWxlaCA8c21vc3RhZmFAZ29vZ2xlLmNvbT4NCj4gQ2M6
IGFjcGljYS1kZXZlbEBsaXN0cy5saW51eC5kZXY7IEd1b2hhbmp1biAoSGFuanVuIEd1bykNCj4g
PGd1b2hhbmp1bkBodWF3ZWkuY29tPjsgaW9tbXVAbGlzdHMubGludXguZGV2OyBKb2VyZyBSb2Vk
ZWwNCj4gPGpvcm9AOGJ5dGVzLm9yZz47IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29t
PjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgTGVuIEJyb3duIDxsZW5iQGtlcm5lbC5vcmc+OyBs
aW51eC0NCj4gYWNwaUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5m
cmFkZWFkLm9yZzsgTG9yZW56byBQaWVyYWxpc2kNCj4gPGxwaWVyYWxpc2lAa2VybmVsLm9yZz47
IFJhZmFlbCBKLiBXeXNvY2tpIDxyYWZhZWxAa2VybmVsLm9yZz47IFJvYmVydA0KPiBNb29yZSA8
cm9iZXJ0Lm1vb3JlQGludGVsLmNvbT47IFJvYmluIE11cnBoeQ0KPiA8cm9iaW4ubXVycGh5QGFy
bS5jb20+OyBTdWRlZXAgSG9sbGEgPHN1ZGVlcC5ob2xsYUBhcm0uY29tPjsgV2lsbA0KPiBEZWFj
b24gPHdpbGxAa2VybmVsLm9yZz47IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJl
ZGhhdC5jb20+Ow0KPiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+OyBKZWFuLVBo
aWxpcHBlIEJydWNrZXIgPGplYW4tDQo+IHBoaWxpcHBlQGxpbmFyby5vcmc+OyBNb3JpdHogRmlz
Y2hlciA8bWRmQGtlcm5lbC5vcmc+OyBNaWNoYWVsIFNoYXZpdA0KPiA8bXNoYXZpdEBnb29nbGUu
Y29tPjsgTmljb2xpbiBDaGVuIDxuaWNvbGluY0BudmlkaWEuY29tPjsNCj4gcGF0Y2hlc0BsaXN0
cy5saW51eC5kZXY7IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gPHNoYW1lZXJhbGkua29s
b3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiA2LzhdIGlv
bW11L2FybS1zbW11LXYzOiBTdXBwb3J0DQo+IElPTU1VX0dFVF9IV19JTkZPIHZpYSBzdHJ1Y3Qg
YXJtX3NtbXVfaHdfaW5mbw0KPiANCj4gT24gVHVlLCBTZXAgMDMsIDIwMjQgYXQgMDg6MzQ6MTdB
TSArMDAwMCwgTW9zdGFmYSBTYWxlaCB3cm90ZToNCj4gDQo+ID4gPiA+IEZvciBleGFtcGxlLCBL
Vk0gZG9lc27igJl0IGFsbG93IHJlYWRpbmcgcmVhZGluZyB0aGUgQ1BVIHN5c3RlbQ0KPiA+ID4g
PiByZWdpc3RlcnMgdG8ga25vdyBpZiBTVkUob3Igb3RoZXIgZmVhdHVyZXMpIGlzIHN1cHBvcnRl
ZCBidXQgaGlkZXMNCj4gPiA+ID4gdGhhdCBieSBhIENBUCBpbiBLVk1fQ0hFQ0tfRVhURU5TSU9O
DQo+ID4gPg0KPiA+ID4gRG8geW91IGtub3cgd2h5Pw0KPiA+DQo+ID4gSSBhbSBub3QgcmVhbGx5
IHN1cmUsIGJ1dCBJIGJlbGlldmUgaXTigJlzIGEgdXNlZnVsIGFic3RyYWN0aW9uDQo+IA0KPiBJ
dCBzZWVtcyBvZGQgdG8gbWUsIHVucHJpdiB1c2Vyc3BhY2UgY2FuIGxvb2sgaW4gL3Byb2MvY3B1
aW5mbyBhbmQgc2VlDQo+IFNFViwgd2h5IHdvdWxkIGt2bSBoaWRlIHRoZSBzYW1lIGluZm9ybWF0
aW9uIGJlaGluZCBhDQo+IENBUF9TWVNfQURNSU4vd2hhdGV2ZXIgY2hlY2s/DQoNCkkgZG9u4oCZ
dCB0aGluayBLVk0gaGlkZXMgU1ZFIGFsd2F5cy4gSXQgYWxzbyBkZXBlbmRzIG9uIHdoZXRoZXIg
dGhlIFZNTSBoYXMNCnJlcXVlc3RlZCBzdmUgZm9yIGEgc3BlY2lmaWMgR3Vlc3Qgb3Igbm90KFFl
bXUgaGFzIG9wdGlvbiB0byB0dXJuIHN2ZSBvbi9vZmYsIHNpbWlsYXJseSBwbXUNCmFzIHdlbGwp
LiAgQmFzZWQgb24gdGhhdCBLVk0gcG9wdWxhdGVzIHRoZSBHdWVzdCBzcGVjaWZpYyBJRCByZWdp
c3RlcnMuICBBbmQgR3Vlc3QNCi9wcm9jL2NwdWluZm8gcmVmbGVjdHMgdGhhdC4NCg0KQW5kIGZv
ciBzb21lIGZlYXR1cmVzIGlmIEtWTSBpcyBub3QgaGFuZGxpbmcgdGhlIGZlYXR1cmUgcHJvcGVy
bHkgb3Igbm90IG1ha2luZyBhbnkgc2Vuc2UNCnRvIGJlIGV4cG9zZWQgdG8gR3Vlc3QsIHRob3Nl
IGZlYXR1cmVzIGFyZSBtYXNrZWQgaW4gSUQgcmVnaXN0ZXJzLg0KDQpSZWNlbnRseSBBUk02NCBJ
RCByZWdpc3RlcnMgaGFzIGJlZW4gbWFkZSB3cml0YWJsZSBmcm9tIHVzZXJzcGFjZSB0byBhbGxv
dyBWTU0gdG8gdHVybg0Kb24vb2ZmIGZlYXR1cmVzLCBzbyB0aGF0IFZNcyBjYW4gYmUgbWlncmF0
ZWQgYmV0d2VlbiBob3N0cyB0aGF0IGRpZmZlciBpbiBmZWF0dXJlIHN1cHBvcnQuDQoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC9aUjJZZkFpeFpnYkNGbmI4QGxpbnV4LmRldi9ULyNtN2My
NDkzZmQyZDQzYzEzYTMzMzZkMTlmMmRjMDZhODk4MDNjNmZkYg0KDQpUaGFua3MsDQpTaGFtZWVy
DQo=

