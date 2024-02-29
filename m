Return-Path: <kvm+bounces-10491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC5A86CA09
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:18:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CC87B24BDD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BF37E585;
	Thu, 29 Feb 2024 13:17:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369137D419;
	Thu, 29 Feb 2024 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709212664; cv=none; b=qJG+M6rgyz2JAzObx3j54pznAZ0nwE2yMkeWFrdCP7JldwPJcSmuHr5WWcaaoGXYdboA/z4n1IxZRkUXi14eaXZUKt1OP62vx/EeoXlhCsIyXvVwaNPIR8+vwSAbhF2qYje7jaALeoKV1sGHASYdwNlK/aAPkSAoSPjXEzpRijY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709212664; c=relaxed/simple;
	bh=ffaOsioAuW/jkHp3zdbo8WE/lDghqJi6iwSVpu984bw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HGlSmsyHLreiuC/aUNRC828B8eQAPNClzkSGTXTuR3Gwt590R8EAss39YtqpTw5WsO8++PAuNsklX+daB/+OzcR2pYZP7ndLVNecu1FduyTIsMn2KoZa/FYr7iE7if0MJzoqfFGxSqoreXUYcFH5f0jD5rEWmxOO+TYsGr8Im74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TlsFL2KnqzNndD;
	Thu, 29 Feb 2024 21:16:54 +0800 (CST)
Received: from kwepemm000004.china.huawei.com (unknown [7.193.23.18])
	by mail.maildlp.com (Postfix) with ESMTPS id 1140B14037F;
	Thu, 29 Feb 2024 21:17:34 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemm000004.china.huawei.com (7.193.23.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 21:17:33 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Thu, 29 Feb 2024 21:17:33 +0800
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
Subject: RE: [PATCH net-next v2 2/3] vhost_net: Call peek_len when using xdp
Thread-Topic: [PATCH net-next v2 2/3] vhost_net: Call peek_len when using xdp
Thread-Index: AQHaajYUllx6TBWEQkypM6YmziwRB7EgnzGAgACvRnA=
Date: Thu, 29 Feb 2024 13:17:33 +0000
Message-ID: <3841008ad79642d694779aaeac87516e@huawei.com>
References: <1709118344-127812-1-git-send-email-wangyunjian@huawei.com>
 <94bd28f625f7ca066e8f2b2686c2493cfab386bd.camel@redhat.com>
In-Reply-To: <94bd28f625f7ca066e8f2b2686c2493cfab386bd.camel@redhat.com>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgW21h
aWx0bzpwYWJlbmlAcmVkaGF0LmNvbV0NCj4gU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDI5LCAy
MDI0IDY6NDkgUE0NCj4gVG86IHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPjsg
bXN0QHJlZGhhdC5jb207DQo+IHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb207IGphc293
YW5nQHJlZGhhdC5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gYmpvcm5Aa2VybmVsLm9yZzsgbWFn
bnVzLmthcmxzc29uQGludGVsLmNvbTsgbWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbTsNCj4g
am9uYXRoYW4ubGVtb25AZ21haWwuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0DQo+IENjOiBicGZA
dmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiB2aXJ0dWFsaXphdGlvbkBs
aXN0cy5saW51eC5kZXY7IHh1ZGluZ2tlIDx4dWRpbmdrZUBodWF3ZWkuY29tPjsgbGl3ZWkgKERU
KQ0KPiA8bGl3ZWkzOTVAaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4
dCB2MiAyLzNdIHZob3N0X25ldDogQ2FsbCBwZWVrX2xlbiB3aGVuIHVzaW5nIHhkcA0KPiANCj4g
T24gV2VkLCAyMDI0LTAyLTI4IGF0IDE5OjA1ICswODAwLCBZdW5qaWFuIFdhbmcgd3JvdGU6DQo+
ID4gSWYgVFVOIHN1cHBvcnRzIEFGX1hEUCBUWCB6ZXJvLWNvcHksIHRoZSBYRFAgcHJvZ3JhbSB3
aWxsIGVucXVldWUNCj4gPiBwYWNrZXRzIHRvIHRoZSBYRFAgcmluZyBhbmQgd2FrZSB1cCB0aGUg
dmhvc3Qgd29ya2VyLiBUaGlzIHJlcXVpcmVzDQo+ID4gdGhlIHZob3N0IHdvcmtlciB0byBjYWxs
IHBlZWtfbGVuKCksIHdoaWNoIGNhbiBiZSB1c2VkIHRvIGNvbnN1bWUgWERQDQo+ID4gZGVzY3Jp
cHRvcnMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZdW5qaWFuIFdhbmcgPHdhbmd5dW5qaWFu
QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmhvc3QvbmV0LmMgfCAxNyArKysr
KysrKysrKystLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNSBk
ZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Zob3N0L25ldC5jIGIv
ZHJpdmVycy92aG9zdC9uZXQuYyBpbmRleA0KPiA+IGYyZWQ3MTY3Yzg0OC4uMDc3ZTc0NDIxNTU4
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4gPiArKysgYi9kcml2ZXJz
L3Zob3N0L25ldC5jDQo+ID4gQEAgLTIwNyw2ICsyMDcsMTEgQEAgc3RhdGljIGludCB2aG9zdF9u
ZXRfYnVmX3BlZWtfbGVuKHZvaWQgKnB0cikNCj4gPiAgCXJldHVybiBfX3NrYl9hcnJheV9sZW5f
d2l0aF90YWcocHRyKTsgIH0NCj4gPg0KPiA+ICtzdGF0aWMgYm9vbCB2aG9zdF9zb2NrX3hkcChz
dHJ1Y3Qgc29ja2V0ICpzb2NrKSB7DQo+ID4gKwlyZXR1cm4gc29ja19mbGFnKHNvY2stPnNrLCBT
T0NLX1hEUCk7IH0NCj4gPiArDQo+ID4gIHN0YXRpYyBpbnQgdmhvc3RfbmV0X2J1Zl9wZWVrKHN0
cnVjdCB2aG9zdF9uZXRfdmlydHF1ZXVlICpudnEpICB7DQo+ID4gIAlzdHJ1Y3Qgdmhvc3RfbmV0
X2J1ZiAqcnhxID0gJm52cS0+cnhxOyBAQCAtMjE0LDYgKzIxOSwxMyBAQCBzdGF0aWMNCj4gPiBp
bnQgdmhvc3RfbmV0X2J1Zl9wZWVrKHN0cnVjdCB2aG9zdF9uZXRfdmlydHF1ZXVlICpudnEpDQo+
ID4gIAlpZiAoIXZob3N0X25ldF9idWZfaXNfZW1wdHkocnhxKSkNCj4gPiAgCQlnb3RvIG91dDsN
Cj4gPg0KPiA+ICsJaWYgKHB0cl9yaW5nX2VtcHR5KG52cS0+cnhfcmluZykpIHsNCj4gPiArCQlz
dHJ1Y3Qgc29ja2V0ICpzb2NrID0gdmhvc3RfdnFfZ2V0X2JhY2tlbmQoJm52cS0+dnEpOw0KPiA+
ICsJCS8qIENhbGwgcGVla19sZW4gdG8gY29uc3VtZSBYU0sgZGVzY3JpcHRvcnMsIHdoZW4gdXNp
bmcgeGRwICovDQo+ID4gKwkJaWYgKHZob3N0X3NvY2tfeGRwKHNvY2spICYmIHNvY2stPm9wcy0+
cGVla19sZW4pDQo+ID4gKwkJCXNvY2stPm9wcy0+cGVla19sZW4oc29jayk7DQo+IA0KPiBUaGlz
IHJlYWxseSBsb29rcyBsaWtlIGEgc29ja2V0IEFQSSBtaXN1c2UuIFdoeSBjYW4ndCB5b3UgdXNl
IHB0ci1yaW5nIHByaW1pdGl2ZXMNCj4gdG8gY29uc3VtZSBYU0sgZGVzY3JpcHRvcnM/IHBlZWtf
bGVuIGNvdWxkIGJlIGNvbnN0aWZpZWQgc29tZSBkYXksIHRoaXMgY29kZQ0KPiB3aWxsIHByZXZl
bnQgc3VjaCAoZ29vZCkgdGhpbmcuDQoNClRoYW5rIHlvdSBmb3IgeW91ciBzdWdnZXN0aW9uLiBJ
IHdpbGwgY29uc2lkZXIgdGhhdCB3aXRoIFBhdGNoIDMvMy4NCg0KPiANCj4gQ2hlZXJzLA0KPiAN
Cj4gUGFvbG8NCg0K

