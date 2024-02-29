Return-Path: <kvm+bounces-10490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1ED86C9FB
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:15:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101541C20EA2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331197E576;
	Thu, 29 Feb 2024 13:15:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFB27E0FE;
	Thu, 29 Feb 2024 13:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709212512; cv=none; b=lfBafBMNJ7mAdgTz4FA1ZCacIb1akZ62pxoiCwwf3S1I3gexsSASK+sGrwcdF7DB1YmgGEtRktIQN2rL4rvgurm5Pf9XgFey4wRrNEQQd9IJjYHqDp6czwkP27k31G0MWSKjvwoxG1j9TLaDggkojFzQ0cE2cD4Zi0FEuDf3pBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709212512; c=relaxed/simple;
	bh=0zxbrL9dDiIjEZVQE6pZj017WOvJu+qyy6LsJ9ewYrM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qtkqbUrDbZn7pSI2z4YMSpdLkF2SATzcFrA1/OGI5aCeYB30BaMPW7DTePG5RBMAEICNaMf/pY5uWZn7Q201MvqAll4IS30GpB5+XksK8ZZmVNu5LPpSDlY30I0BkMvdqZ54vw4JOATInobgK/ocJICy4fRcjeCE5CPt9YF8MaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Tls9W4RCjz1xpn4;
	Thu, 29 Feb 2024 21:13:35 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (unknown [7.193.23.3])
	by mail.maildlp.com (Postfix) with ESMTPS id EA4BF140390;
	Thu, 29 Feb 2024 21:15:06 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 21:15:06 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Thu, 29 Feb 2024 21:15:06 +0800
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
Subject: RE: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Thread-Topic: [PATCH net-next v2 3/3] tun: AF_XDP Tx zero-copy support
Thread-Index: AQHaajYcNkJKJoTBfEqyMPzDlwSi+bEgpeYAgACiGXA=
Date: Thu, 29 Feb 2024 13:15:06 +0000
Message-ID: <abef895c10c74099857e2f52e8b62552@huawei.com>
References: <1709118356-133960-1-git-send-email-wangyunjian@huawei.com>
 <7d478cb842e28094f4d6102e593e3de25ab27dfe.camel@redhat.com>
In-Reply-To: <7d478cb842e28094f4d6102e593e3de25ab27dfe.camel@redhat.com>
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
NzoxMyBQTQ0KPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+OyBtc3RA
cmVkaGF0LmNvbTsNCj4gd2lsbGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbTsgamFzb3dhbmdA
cmVkaGF0LmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBiam9ybkBrZXJuZWwub3JnOyBtYWdudXMu
a2FybHNzb25AaW50ZWwuY29tOyBtYWNpZWouZmlqYWxrb3dza2lAaW50ZWwuY29tOw0KPiBqb25h
dGhhbi5sZW1vbkBnbWFpbC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQNCj4gQ2M6IGJwZkB2Z2Vy
Lmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpcnR1YWxpemF0aW9uQGxpc3Rz
LmxpbnV4LmRldjsgeHVkaW5na2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+OyBsaXdlaSAoRFQpDQo+
IDxsaXdlaTM5NUBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYy
IDMvM10gdHVuOiBBRl9YRFAgVHggemVyby1jb3B5IHN1cHBvcnQNCj4gDQo+IE9uIFdlZCwgMjAy
NC0wMi0yOCBhdCAxOTowNSArMDgwMCwgWXVuamlhbiBXYW5nIHdyb3RlOg0KPiA+IEBAIC0yNjYx
LDYgKzI3NzYsNTQgQEAgc3RhdGljIGludCB0dW5fcHRyX3BlZWtfbGVuKHZvaWQgKnB0cikNCj4g
PiAgCX0NCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyB2b2lkIHR1bl9wZWVrX3hzayhzdHJ1Y3Qg
dHVuX2ZpbGUgKnRmaWxlKSB7DQo+ID4gKwlzdHJ1Y3QgeHNrX2J1ZmZfcG9vbCAqcG9vbDsNCj4g
PiArCXUzMiBpLCBiYXRjaCwgYnVkZ2V0Ow0KPiA+ICsJdm9pZCAqZnJhbWU7DQo+ID4gKw0KPiA+
ICsJaWYgKCFwdHJfcmluZ19lbXB0eSgmdGZpbGUtPnR4X3JpbmcpKQ0KPiA+ICsJCXJldHVybjsN
Cj4gPiArDQo+ID4gKwlzcGluX2xvY2soJnRmaWxlLT5wb29sX2xvY2spOw0KPiA+ICsJcG9vbCA9
IHRmaWxlLT54c2tfcG9vbDsNCj4gPiArCWlmICghcG9vbCkgew0KPiA+ICsJCXNwaW5fdW5sb2Nr
KCZ0ZmlsZS0+cG9vbF9sb2NrKTsNCj4gPiArCQlyZXR1cm47DQo+ID4gKwl9DQo+ID4gKw0KPiA+
ICsJaWYgKHRmaWxlLT5uYl9kZXNjcykgew0KPiA+ICsJCXhza190eF9jb21wbGV0ZWQocG9vbCwg
dGZpbGUtPm5iX2Rlc2NzKTsNCj4gPiArCQlpZiAoeHNrX3VzZXNfbmVlZF93YWtldXAocG9vbCkp
DQo+ID4gKwkJCXhza19zZXRfdHhfbmVlZF93YWtldXAocG9vbCk7DQo+ID4gKwl9DQo+ID4gKw0K
PiA+ICsJc3Bpbl9sb2NrKCZ0ZmlsZS0+dHhfcmluZy5wcm9kdWNlcl9sb2NrKTsNCj4gPiArCWJ1
ZGdldCA9IG1pbl90KHUzMiwgdGZpbGUtPnR4X3Jpbmcuc2l6ZSwgVFVOX1hEUF9CQVRDSCk7DQo+
ID4gKw0KPiA+ICsJYmF0Y2ggPSB4c2tfdHhfcGVla19yZWxlYXNlX2Rlc2NfYmF0Y2gocG9vbCwg
YnVkZ2V0KTsNCj4gPiArCWlmICghYmF0Y2gpIHsNCj4gDQo+IFRoaXMgYnJhbmNoIGxvb2tzIGxp
a2UgYW4gdW5uZWVkZWQgIm9wdGltaXphdGlvbiIuIFRoZSBnZW5lcmljIGxvb3AgYmVsb3cNCj4g
c2hvdWxkIGhhdmUgdGhlIHNhbWUgZWZmZWN0IHdpdGggbm8gbWVhc3VyYWJsZSBwZXJmIGRlbHRh
IC0gYW5kIHNtYWxsZXIgY29kZS4NCj4gSnVzdCByZW1vdmUgdGhpcy4NCg0KT0ssIEkgd2lsbCB1
cGRhdGUgaXQsIHRoYW5rcy4NCg0KPiANCj4gPiArCQl0ZmlsZS0+bmJfZGVzY3MgPSAwOw0KPiA+
ICsJCXNwaW5fdW5sb2NrKCZ0ZmlsZS0+dHhfcmluZy5wcm9kdWNlcl9sb2NrKTsNCj4gPiArCQlz
cGluX3VubG9jaygmdGZpbGUtPnBvb2xfbG9jayk7DQo+ID4gKwkJcmV0dXJuOw0KPiA+ICsJfQ0K
PiA+ICsNCj4gPiArCXRmaWxlLT5uYl9kZXNjcyA9IGJhdGNoOw0KPiA+ICsJZm9yIChpID0gMDsg
aSA8IGJhdGNoOyBpKyspIHsNCj4gPiArCQkvKiBFbmNvZGUgdGhlIFhEUCBERVNDIGZsYWcgaW50
byBsb3dlc3QgYml0IGZvciBjb25zdW1lciB0byBkaWZmZXINCj4gPiArCQkgKiBYRFAgZGVzYyBm
cm9tIFhEUCBidWZmZXIgYW5kIHNrX2J1ZmYuDQo+ID4gKwkJICovDQo+ID4gKwkJZnJhbWUgPSB0
dW5feGRwX2Rlc2NfdG9fcHRyKCZwb29sLT50eF9kZXNjc1tpXSk7DQo+ID4gKwkJLyogVGhlIGJ1
ZGdldCBtdXN0IGJlIGxlc3MgdGhhbiBvciBlcXVhbCB0byB0eF9yaW5nLnNpemUsDQo+ID4gKwkJ
ICogc28gZW5xdWV1aW5nIHdpbGwgbm90IGZhaWwuDQo+ID4gKwkJICovDQo+ID4gKwkJX19wdHJf
cmluZ19wcm9kdWNlKCZ0ZmlsZS0+dHhfcmluZywgZnJhbWUpOw0KPiA+ICsJfQ0KPiA+ICsJc3Bp
bl91bmxvY2soJnRmaWxlLT50eF9yaW5nLnByb2R1Y2VyX2xvY2spOw0KPiA+ICsJc3Bpbl91bmxv
Y2soJnRmaWxlLT5wb29sX2xvY2spOw0KPiANCj4gTW9yZSByZWxhdGVkIHRvIHRoZSBnZW5lcmFs
IGRlc2lnbjogaXQgbG9va3Mgd3JvbmcuIFdoYXQgaWYNCj4gZ2V0X3J4X2J1ZnMoKSB3aWxsIGZh
aWwgKEVOT0JVRikgYWZ0ZXIgc3VjY2Vzc2Z1bCBwZWVraW5nPyBXaXRoIG5vIG1vcmUNCj4gaW5j
b21pbmcgcGFja2V0cywgbGF0ZXIgcGVlayB3aWxsIHJldHVybiAwIGFuZCBpdCBsb29rcyBsaWtl
IHRoYXQgdGhlDQo+IGhhbGYtcHJvY2Vzc2VkIHBhY2tldHMgd2lsbCBzdGF5IGluIHRoZSByaW5n
IGZvcmV2ZXI/Pz8NCg0KVGhlIHZob3N0X25ldF9yeF9wZWVrX2hlYWRfbGVuIGZ1bmN0aW9uIG9i
dGFpbnMgdGhlIHBhY2tldCBsZW5ndGgNCmJ1dCBkb2VzIG5vdCBjb25zdW1lIGl0LiBUaGUgcGFj
a2V0IGlzIHN0aWxsIGluIHRoZSByaW5nLiBUaGUgbGF0ZXIgcGVlaw0Kd2lsbCByZXVzZSBpdC4N
Cg0KPiANCj4gSSB0aGluayB0aGUgJ3JpbmcgcHJvZHVjZScgcGFydCBzaG91bGQgYmUgbW92ZWQg
aW50byB0dW5fZG9fcmVhZCgpLg0KDQpUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2VzdGlvbi4gSSB3
aWxsIGNvbnNpZGVyIHRoYXQuDQoNCj4gDQo+IENoZWVycywNCj4gDQo+IFBhb2xvDQoNCg==

