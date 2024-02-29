Return-Path: <kvm+bounces-10488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BFC86C983
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:52:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 567571F238AA
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 12:52:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC117E0FE;
	Thu, 29 Feb 2024 12:52:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83A07D3EB;
	Thu, 29 Feb 2024 12:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709211135; cv=none; b=ERBmj5iDJjF8BiE/XPB70+g8kBVHHFbSXgbV6iu8xgpdn3BcahnFFQ2h7tx43RrxP2S+6umPgc5uj8NKfEc21jvFoLQootToM7KtTXlfXQ2ZCIzmGrk1GGHI6HTfWXMbbcCndi4kq05sv0kaGOy9ID7/BNj4EdWydhRuAUZQ3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709211135; c=relaxed/simple;
	bh=kb07Bofn5YvOT4z4iZNaMpVFkUQyAqY/FdzZob/hJ6s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JFXUsgwPDP+bo0E205GBmp4OlSPCAmhpVjQ4R4uWekSLba4JMt/qieVArjbJfu9bSBjX15Vun1GAprFOKF++/Dw6Wp4YJzVacTyW3oiEeDPZIIJvqR4zHdy+ry//pPYZ4nqL2y7iFAlLDQEnBRTiYqRHrm9Ua0iwtG7RfvIgle8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Tlrff5y2FzpVXm;
	Thu, 29 Feb 2024 20:50:18 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (unknown [7.193.23.202])
	by mail.maildlp.com (Postfix) with ESMTPS id EEBBB1404DB;
	Thu, 29 Feb 2024 20:52:08 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 20:52:08 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Thu, 29 Feb 2024 20:52:08 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: Paolo Abeni <pabeni@redhat.com>, "mst@redhat.com" <mst@redhat.com>,
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "bjorn@kernel.org" <bjorn@kernel.org>,
	"magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
	"maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "davem@davemloft.net"
	<davem@davemloft.net>
CC: "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke
	<xudingke@huawei.com>, "liwei (DT)" <liwei395@huawei.com>
Subject: RE: [PATCH net-next v2 1/3] xsk: Remove non-zero 'dma_page' check in
 xp_assign_dev
Thread-Topic: [PATCH net-next v2 1/3] xsk: Remove non-zero 'dma_page' check in
 xp_assign_dev
Thread-Index: AQHaajYJnbtzT7JgCU+QOT7x4zY88rEgnaQAgACpFNA=
Date: Thu, 29 Feb 2024 12:52:08 +0000
Message-ID: <55ef319de7084614b1883018f69de1eb@huawei.com>
References: <1709118325-120336-1-git-send-email-wangyunjian@huawei.com>
 <75b6f7686c03519a1aaeb461618070747890143b.camel@redhat.com>
In-Reply-To: <75b6f7686c03519a1aaeb461618070747890143b.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYW9sbyBBYmVuaSBbbWFpbHRv
OnBhYmVuaUByZWRoYXQuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMjksIDIwMjQg
Njo0MyBQTQ0KPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+OyBtc3RA
cmVkaGF0LmNvbTsNCj4gd2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbTsgamFzb3dhbmdA
cmVkaGF0LmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBiam9ybkBrZXJuZWwub3JnOyBtYWdudXMu
a2FybHNzb25AaW50ZWwuY29tOyBtYWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tOw0KPiBqb25h
dGhhbi5sZW1vbkBnbWFpbC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gQ2M6IGJwZkB2Z2Vy
Lmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpcnR1YWxpemF0aW9uQGxpc3Rz
LmxpbnV4LmRldjsgeHVkaW5na2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+OyBsaXdlaSAoRFQpDQo+
IDxsaXdlaTM5NUBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYy
IDEvM10geHNrOiBSZW1vdmUgbm9uLXplcm8gJ2RtYV9wYWdlJyBjaGVjayBpbg0KPiB4cF9hc3Np
Z25fZGV2DQo+IA0KPiBPbiBXZWQsIDIwMjQtMDItMjggYXQgMTk6MDUgKzA4MDAsIFl1bmppYW4g
V2FuZyB3cm90ZToNCj4gPiBOb3cgZG1hIG1hcHBpbmdzIGFyZSB1c2VkIGJ5IHRoZSBwaHlzaWNh
bCBOSUNzLiBIb3dldmVyIHRoZSB2TklDIG1heWJlDQo+ID4gZG8gbm90IG5lZWQgdGhlbS4gU28g
cmVtb3ZlIG5vbi16ZXJvICdkbWFfcGFnZScgY2hlY2sgaW4NCj4gPiB4cF9hc3NpZ25fZGV2Lg0K
PiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWXVuamlhbiBXYW5nIDx3YW5neXVuamlhbkBodWF3ZWku
Y29tPg0KPiA+IC0tLQ0KPiA+ICBuZXQveGRwL3hza19idWZmX3Bvb2wuYyB8IDcgLS0tLS0tLQ0K
PiA+ICAxIGZpbGUgY2hhbmdlZCwgNyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9uZXQveGRwL3hza19idWZmX3Bvb2wuYyBiL25ldC94ZHAveHNrX2J1ZmZfcG9vbC5jIGluZGV4
DQo+ID4gY2U2MGVjZDQ4YTRkLi5hNWFmNzViMWY0M2MgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L3hk
cC94c2tfYnVmZl9wb29sLmMNCj4gPiArKysgYi9uZXQveGRwL3hza19idWZmX3Bvb2wuYw0KPiA+
IEBAIC0yMTksMTYgKzIxOSw5IEBAIGludCB4cF9hc3NpZ25fZGV2KHN0cnVjdCB4c2tfYnVmZl9w
b29sICpwb29sLA0KPiA+ICAJaWYgKGVycikNCj4gPiAgCQlnb3RvIGVycl91bnJlZ19wb29sOw0K
PiA+DQo+ID4gLQlpZiAoIXBvb2wtPmRtYV9wYWdlcykgew0KPiA+IC0JCVdBUk4oMSwgIkRyaXZl
ciBkaWQgbm90IERNQSBtYXAgemVyby1jb3B5IGJ1ZmZlcnMiKTsNCj4gPiAtCQllcnIgPSAtRUlO
VkFMOw0KPiA+IC0JCWdvdG8gZXJyX3VucmVnX3hzazsNCj4gPiAtCX0NCj4gDQo+IFRoaXMgd291
bGQgdW5jb25kaXRpb25hbGx5IHJlbW92ZSBhbiBvdGhlcndpc2UgdmFsaWQgY2hlY2sgZm9yIG1v
c3QgTklDLiBXaGF0DQo+IGFib3V0IGxldCB0aGUgZHJpdmVyIGRlY2xhcmUgaXQgd29udCBuZWVk
IERNQSBtYXAgd2l0aCBhDQo+IChwb29sPykgZmxhZy4NCg0KVGhpcyBjaGVjayBpcyByZWR1bmRh
bnQuIFRoZSBOSUMncyBkcml2ZXIgZGV0ZXJtaW5lcyB3aGV0aGVyIGEgRE1BIG1hcCBpcyByZXF1
aXJlZC4NCklmIHRoZSBOSUMnZHJpdmVyIHJlcXVpcmVzIHRoZSBETUEgbWFwLCBpdCB1c2VzIHRo
ZSB4c2tfcG9vbF9kbWFfbWFwIGZ1bmN0aW9uLCB3aGljaA0KaW5pdGlhbGl6ZXMgdGhlIERNQSBt
YXAgYW5kIHBlcmZvcm1zIGEgY2hlY2suDQoNClRoYW5rcw0KDQo+IA0KPiBDaGVlcnMsDQo+IA0K
PiBQYW9sbw0KDQo=

