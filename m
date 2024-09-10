Return-Path: <kvm+bounces-26206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E76E0972A60
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 09:17:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 975701F258BD
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 07:17:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC3A17C222;
	Tue, 10 Sep 2024 07:17:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1DCBA45
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 07:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725952623; cv=none; b=PI7hgQV0ukZe11em8xGnUBGeS230rpdnlJJ5JtNZbIjRIdm/cXv5pDx71w1GbjLu8uIT+vD6KwWn4vtcaMQsEZpAjintAd4+ndQ8FDEWRnsRYi+39JZxoUy1I6viD7A78VpuZsVdjtn4PDdpbRZyOTwdnFfe8+wO2YtfIR4ANOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725952623; c=relaxed/simple;
	bh=2Cw9mNBhZURvNnlO42Hu3NILmNZJ3TmRQ7D/nqNfoWQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eZ9IvN0ZV5nKaNLAvSeuE9TTnZtF/UNloFk8jZPdVYNVKtq60sH1cqj2p6G+tHvQclBKhRz2h0ehmpMkIdvr6aJ4IACF4eoCD7ZF/Z+4kD+JFJaCkLYeoRLThqpmR/0hv6kPjPPzmQwqjav4+r+8en04VlpU07xnslejVcd1wls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4X2w3W4bxgzyR17;
	Tue, 10 Sep 2024 15:16:07 +0800 (CST)
Received: from kwepemd200010.china.huawei.com (unknown [7.221.188.124])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F3F51400D1;
	Tue, 10 Sep 2024 15:16:52 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 kwepemd200010.china.huawei.com (7.221.188.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 10 Sep 2024 15:16:51 +0800
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.039;
 Tue, 10 Sep 2024 08:16:49 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
CC: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Sebastian Ott
	<sebott@redhat.com>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, yuzenghui <yuzenghui@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shaoqin Huang
	<shahuang@redhat.com>, Eric Auger <eric.auger@redhat.com>, "Wangzhou (B)"
	<wangzhou1@hisilicon.com>
Subject: RE: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Thread-Topic: [PATCH v5 07/10] KVM: arm64: Treat CTR_EL0 as a VM feature ID
 register
Thread-Index: AQHawm/0TP9B4WSU3kSdeZvzR1wQjLJQDNGggAAIPQCAAAfwgIAAEmkA///8m4CAAOuFwA==
Date: Tue, 10 Sep 2024 07:16:49 +0000
Message-ID: <6abe14d969da42638d648db205d39fe7@huawei.com>
References: <20240619174036.483943-1-oliver.upton@linux.dev>
 <20240619174036.483943-8-oliver.upton@linux.dev>
 <0db19a081d9e41f08b0043baeef16f16@huawei.com> <864j6o94fz.wl-maz@kernel.org>
 <Zt8o6fStuQXANSrX@linux.dev> <8e361ab82d6c4adcb15890cd3cab48ee@huawei.com>
 <Zt81ga44ztdX_KET@linux.dev>
In-Reply-To: <Zt81ga44ztdX_KET@linux.dev>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogT2xpdmVyIFVwdG9uIDxv
bGl2ZXIudXB0b25AbGludXguZGV2Pg0KPiBTZW50OiBNb25kYXksIFNlcHRlbWJlciA5LCAyMDI0
IDY6NTEgUE0NCj4gVG86IFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkgPHNoYW1lZXJhbGkua29s
b3RodW0udGhvZGlAaHVhd2VpLmNvbT4NCj4gQ2M6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+OyBrdm1hcm1AbGlzdHMubGludXguZGV2OyBTZWJhc3RpYW4gT3R0DQo+IDxzZWJvdHRAcmVk
aGF0LmNvbT47IEphbWVzIE1vcnNlIDxqYW1lcy5tb3JzZUBhcm0uY29tPjsgU3V6dWtpIEsNCj4g
UG91bG9zZSA8c3V6dWtpLnBvdWxvc2VAYXJtLmNvbT47IHl1emVuZ2h1aSA8eXV6ZW5naHVpQGh1
YXdlaS5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBTaGFvcWluIEh1YW5nIDxzaGFodWFu
Z0ByZWRoYXQuY29tPjsgRXJpYyBBdWdlcg0KPiA8ZXJpYy5hdWdlckByZWRoYXQuY29tPjsgV2Fu
Z3pob3UgKEIpIDx3YW5nemhvdTFAaGlzaWxpY29uLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SCB2NSAwNy8xMF0gS1ZNOiBhcm02NDogVHJlYXQgQ1RSX0VMMCBhcyBhIFZNIGZlYXR1cmUgSUQN
Cj4gcmVnaXN0ZXINCj4gDQo+IE9uIE1vbiwgU2VwIDA5LCAyMDI0IGF0IDA1OjE2OjU1UE0gKzAw
MDAsIFNoYW1lZXJhbGkgS29sb3RodW0gVGhvZGkNCj4gd3JvdGU6DQo+ID4gPiA+IEl0IHNob3Vs
ZCBiZSBzYWZlLCBhcyBhIFBJUFQgQ01PIGFsd2F5cyBkb2VzIGF0IGxlYXN0IHRoZSBzYW1lIGFz
DQo+ID4gPiA+IFZJUFQsIGFuZCBwb3RlbnRpYWxseSBtb3JlIGlmIHRoZXJlIGlzIGFsaWFzaW5n
Lg0KPiA+ID4NCj4gPiA+ICsxLCB0aGVyZSB3YXMgbm8gcGFydGljdWxhciByZWFzb24gd2h5IHRo
aXMgd2Fzbid0IGhhbmRsZWQgYmVmb3JlLg0KPiA+ID4NCj4gPiA+IFdlIHNob3VsZCBiZSBjYXJl
ZnVsIHRvIG9ubHkgYWxsb3cgdXNlcnNwYWNlIHRvIHNlbGVjdCBWSVBUIG9yIFBJUFQNCj4gKHdo
ZXJlDQo+ID4gPiBwZXJtaXNzaWJsZSksIGFuZCBub3QgbmVjZXNzYXJpbHkgYW55IHZhbHVlIGxv
d2VyIHRoYW4gd2hhdCdzIHJlcG9ydGVkIGJ5DQo+ID4gPiBoYXJkd2FyZS4NCj4gPg0KPiA+IFZJ
UFQgMGIxMA0KPiA+IFBJUFQgMGIxMQ0KPiA+DQo+ID4gT2suIEp1c3QgdG8gY2xhcmlmeSB0aGF0
ICIgbm90IG5lY2Vzc2FyaWx5IGFueSB2YWx1ZSBsb3dlciB0aGFuIHdoYXQncw0KPiByZXBvcnRl
ZCBieQ0KPiA+IGhhcmR3YXJlIiBtZWFucyB1c2Vyc3BhY2UgY2FuIHNldCBQSVBUIGlmIGhhcmR3
YXJlIHN1cHBvcnRzIFZJUFQ/DQo+IA0KPiBCeSB0aGF0IEkgbWVhbnQgd2UgZGlzYWxsb3cgdXNl
cnNwYWNlIGZyb20gc2VsZWN0aW5nIEFJVklWVCAoMGIwMSkgYW5kDQo+IFZQSVBUICgwYjAwKS4g
VGhlIGZvcm1lciBpcyByZXNlcnZlZCBpbiBBUk12OCwgYW5kIEkgZG9uJ3QgdGhpbmsgYW55b25l
DQo+IGhhcyBldmVyIGJ1aWx0IHRoZSBsYXR0ZXIuDQo+IA0KPiA+IEJhc2VkIG9uIHRoaXMsDQo+
ID4gIiBJZiB3ZSBoYXZlIGRpZmZlcmluZyBJLWNhY2hlIHBvbGljaWVzLCByZXBvcnQgaXQgYXMg
dGhlIHdlYWtlc3QgLSBWSVBULiIgLCBJDQo+IHdhcyB0aGlua2luZw0KPiA+IHRoZSBvdGhlciB3
YXkgYXJvdW5kKHNlZSAic2FmZSB0byBkb3duZ3JhZGUgUElQVCB0byBWSVBUIikuIEJ1dCBNYXJj
IGFsc28NCj4gPiBzZWVtcyB0byBzdWdnZXN0IFBJUFQgQ01PIGVuZHMgdXAgZG9pbmcgYXRsZWFz
dCBzYW1lIGFzIFZJUFQgYW5kIG1vcmUsDQo+IHNvIGl0IGxvb2tzIGxpa2UNCj4gPiB0aGUgb3Ro
ZXIgd2F5LiBJZiB0aGF0J3MgdGhlIGNhc2UsIHdoYXQgZG9lcyB0aGF0ICJyZXBvcnQgaXQgYXMg
dGhlIHdlYWtlc3QiDQo+IG1lYW5zIGZvciBob3N0Pw0KPiANCj4gUElQVCBpcyB0aGUgbm9uLWFs
aWFzaW5nIGZsYXZvciBvZiBJJC4gVXNpbmcgYSBWSVBUIHNvZnR3YXJlIG1vZGVsIG9uDQo+IFBJ
UFQgd2lsbCBsZWFkIHRvIG92ZXJpbnZhbGlkYXRpbmcsIGJ1dCBzdGlsbCBjb3JyZWN0LiBDYW5u
b3QgZG8gaXQgdGhlDQo+IG90aGVyIHdheSBhcm91bmQuDQoNCk9rLiBUaGFua3MgYm90aC4gSSB3
aWxsIHNlbmQgb3V0IGEgcGF0Y2ggc29vbi4NCg0KQW5kIG5vdyB0byB0aGUgZWxlcGhhbnQgaW4g
dGhlIHJvb20sIGhhbmRsaW5nIE1JRFIgZGlmZmVyZW5jZXMgYW5kIGFzc29jaWF0ZWQgZXJyYXRh
DQptYW5hZ2VtZW50IPCfmIoNCg0KTWFyYywgeW91IG1lbnRpb25lZCBhYm91dCBhICBwcm90b3R5
cGUgc29sdXRpb24geW91IGhhdmUgYSB3aGlsZSBiYWNrWzBdLA0KaGFzIHRoYXQgYmVlbiBzaGFy
ZWQgcHVibGljPw0KDQpBbHNvIG5vdCBzdXJlIEFSTSBoYXMgYW55IHBsYW5zIHRvIG1ha2UgdGhp
cyBhIHNwZWNpZmljYXRpb24gc29vbi4NCg0KSSB3YXMgdGhpbmtpbmcgb2YgaGFuZGxpbmcgdGhp
cyBpbiB1c2Vyc3BhY2UgZm9yIG5vdyBieSBpZ25vcmluZyB0aGUgTUlEUiB3cml0ZQ0KZXJyb3Ig
b24gTWlncmF0aW9uIGFuZCBrZWVwaW5nIHRoZSBob3N0IE1JRFIgdmFsdWUgZm9yIGRlc3RpbmF0
aW9uIFZNLiBUaGlzIGlzDQpmb3IgdXNlIGNhc2VzIHdoZXJlIHdlIGtub3cgdGhhdCB0aGUgaG9z
dHMgZG9lc24ndCBoYXZlIGFueSBNSURSIGJhc2VkIGVycmF0YSBvcg0KZXJyYXRhIGRpZmZlcmVu
Y2UgZG9lc24ndCBtYXR0ZXIgYW5kIGFzc3VtaW5nIHRoZSB1c2VyIGtub3dzIHdoYXQgdGhleSBh
cmUgZG9pbmcuDQoNClBsZWFzZSBsZXQgbWUga25vdywgaWYgdGhlcmUgYXJlIGFueSBvdGhlciBz
dWdnZXN0aW9ucyBvciB3b3JrIGluIHByb2dyZXNzIG9uIHRoaXMgb25lLg0KDQpUaGFua3MsDQpT
aGFtZWVyDQpbMF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtYXJtLWtlcm5lbC84Njdj
dDhtbmVsLndsLW1hekBrZXJuZWwub3JnLw0KDQo=

