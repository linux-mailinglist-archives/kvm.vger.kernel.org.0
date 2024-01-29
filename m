Return-Path: <kvm+bounces-7323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E77F8403F4
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:41:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F8F2B21F08
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE2295D73B;
	Mon, 29 Jan 2024 11:40:45 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2265BAD2;
	Mon, 29 Jan 2024 11:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706528445; cv=none; b=rY2r+6/9GMq/wKq0alMw1Hm66UEddBufqMv+sk4XTeKECQNNg7eqs93odFZadhU11GXX3nJ1XehDXVxsWOgjVxOIZrP8UzyUXkxVffu0jbtH2TgbM+6uPDZrWCGrcVAab8ArtGWNhdyEBsJCMhNGAs4OH/5NVdZsoPY9JcXiraE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706528445; c=relaxed/simple;
	bh=sftGxx9AngSKs+fFAwBqBkU4IwozNf5mZoEO742mLns=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nOf51mK8ZiwoNjduu/8+BZxgFcG41RpOOSi35uuYskvU0QzuTdVYCkRqTZdTLG16iShDhalnz3kx9c9VBFhldWbyACeZHoPu9ZkgNaAkSJjK4G2Tmbu3tak5kZpDl46UWQ/Eq0Q1aS/5yiqUnib59nN53szVFZJMLj0zwA5mkII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TNmYG2Z7sz1Q8Zk;
	Mon, 29 Jan 2024 19:39:30 +0800 (CST)
Received: from kwepemd500002.china.huawei.com (unknown [7.221.188.104])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E6B414011F;
	Mon, 29 Jan 2024 19:40:39 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemd500002.china.huawei.com (7.221.188.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Mon, 29 Jan 2024 19:40:39 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Mon, 29 Jan 2024 19:40:38 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: Jason Wang <jasowang@redhat.com>
CC: "mst@redhat.com" <mst@redhat.com>, "willemdebruijn.kernel@gmail.com"
	<willemdebruijn.kernel@gmail.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "magnus.karlsson@intel.com"
	<magnus.karlsson@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, xudingke
	<xudingke@huawei.com>
Subject: RE: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
Thread-Topic: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
Thread-Index: AQHaTqkDLHSSzcU2CESolpkubpTJa7DpcBcAgAD60ACABTEcAIABDkhg
Date: Mon, 29 Jan 2024 11:40:38 +0000
Message-ID: <0141ea1c5b834503837df5db6aa5c92a@huawei.com>
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
 <ad74a361d5084c62a89f7aa276273649@huawei.com>
 <CACGkMEvvdfBhNXPSxEgpPGAaTrNZr83nyw35bvuZoHLf+k85Yg@mail.gmail.com>
In-Reply-To: <CACGkMEvvdfBhNXPSxEgpPGAaTrNZr83nyw35bvuZoHLf+k85Yg@mail.gmail.com>
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

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86
amFzb3dhbmdAcmVkaGF0LmNvbV0NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDI5LCAyMDI0IDEx
OjAzIEFNDQo+IFRvOiB3YW5neXVuamlhbiA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gQ2M6
IG1zdEByZWRoYXQuY29tOyB3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tOyBrdWJhQGtl
cm5lbC5vcmc7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG1hZ251cy5rYXJsc3NvbkBpbnRlbC5j
b207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LmRl
djsgeHVkaW5na2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
bmV0LW5leHQgMi8yXSB0dW46IEFGX1hEUCBSeCB6ZXJvLWNvcHkgc3VwcG9ydA0KPiANCj4gT24g
VGh1LCBKYW4gMjUsIDIwMjQgYXQgODo1NOKAr1BNIHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBo
dWF3ZWkuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFzb3dhbmdAcmVk
aGF0LmNvbV0NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDI1LCAyMDI0IDEyOjQ5IFBN
DQo+ID4gPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+DQo+ID4gPiBD
YzogbXN0QHJlZGhhdC5jb207IHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb207DQo+ID4g
PiBrdWJhQGtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG1hZ251cy5rYXJsc3NvbkBp
bnRlbC5jb207DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOw0KPiA+ID4ga3ZtQHZnZXIua2VybmVsLm9yZzsgdmlydHVhbGl6YXRpb25A
bGlzdHMubGludXguZGV2OyB4dWRpbmdrZQ0KPiA+ID4gPHh1ZGluZ2tlQGh1YXdlaS5jb20+DQo+
ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDIvMl0gdHVuOiBBRl9YRFAgUnggemVy
by1jb3B5IHN1cHBvcnQNCj4gPiA+DQo+ID4gPiBPbiBXZWQsIEphbiAyNCwgMjAyNCBhdCA1OjM4
4oCvUE0gWXVuamlhbiBXYW5nDQo+ID4gPiA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gPiA+
IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBOb3cgdGhlIHplcm8tY29weSBmZWF0dXJlIG9mIEFG
X1hEUCBzb2NrZXQgaXMgc3VwcG9ydGVkIGJ5IHNvbWUNCj4gPiA+ID4gZHJpdmVycywgd2hpY2gg
Y2FuIHJlZHVjZSBDUFUgdXRpbGl6YXRpb24gb24gdGhlIHhkcCBwcm9ncmFtLg0KPiA+ID4gPiBU
aGlzIHBhdGNoIHNldCBhbGxvd3MgdHVuIHRvIHN1cHBvcnQgQUZfWERQIFJ4IHplcm8tY29weSBm
ZWF0dXJlLg0KPiA+ID4gPg0KPiA+ID4gPiBUaGlzIHBhdGNoIHRyaWVzIHRvIGFkZHJlc3MgdGhp
cyBieToNCj4gPiA+ID4gLSBVc2UgcGVla19sZW4gdG8gY29uc3VtZSBhIHhzay0+ZGVzYyBhbmQg
Z2V0IHhzay0+ZGVzYyBsZW5ndGguDQo+ID4gPiA+IC0gV2hlbiB0aGUgdHVuIHN1cHBvcnQgQUZf
WERQIFJ4IHplcm8tY29weSwgdGhlIHZxJ3MgYXJyYXkgbWF5YmUgZW1wdHkuDQo+ID4gPiA+IFNv
IGFkZCBhIGNoZWNrIGZvciBlbXB0eSB2cSdzIGFycmF5IGluIHZob3N0X25ldF9idWZfcHJvZHVj
ZSgpLg0KPiA+ID4gPiAtIGFkZCBYRFBfU0VUVVBfWFNLX1BPT0wgYW5kIG5kb194c2tfd2FrZXVw
IGNhbGxiYWNrIHN1cHBvcnQNCj4gPiA+ID4gLSBhZGQgdHVuX3B1dF91c2VyX2Rlc2MgZnVuY3Rp
b24gdG8gY29weSB0aGUgUnggZGF0YSB0byBWTQ0KPiA+ID4NCj4gPiA+IENvZGUgZXhwbGFpbnMg
dGhlbXNlbHZlcywgbGV0J3MgZXhwbGFpbiB3aHkgeW91IG5lZWQgdG8gZG8gdGhpcy4NCj4gPiA+
DQo+ID4gPiAxKSB3aHkgeW91IHdhbnQgdG8gdXNlIHBlZWtfbGVuDQo+ID4gPiAyKSBmb3IgInZx
J3MgYXJyYXkiLCB3aGF0IGRvZXMgaXQgbWVhbj8NCj4gPiA+IDMpIGZyb20gdGhlIHZpZXcgb2Yg
VFVOL1RBUCB0dW5fcHV0X3VzZXJfZGVzYygpIGlzIHRoZSBUWCBwYXRoLCBzbyBJDQo+ID4gPiBn
dWVzcyB5b3UgbWVhbnQgVFggemVyb2NvcHkgaW5zdGVhZCBvZiBSWCAoYXMgSSBkb24ndCBzZWUg
Y29kZXMgZm9yDQo+ID4gPiBSWD8pDQo+ID4NCj4gPiBPSywgSSBhZ3JlZSBhbmQgdXNlIFRYIHpl
cm9jb3B5IGluc3RlYWQgb2YgUlggemVyb2NvcHkuIEkgbWVhbnQgUlgNCj4gPiB6ZXJvY29weSBm
cm9tIHRoZSB2aWV3IG9mIHZob3N0LW5ldC4NCj4gDQo+IE9rLg0KPiANCj4gPg0KPiA+ID4NCj4g
PiA+IEEgYmlnIHF1ZXN0aW9uIGlzIGhvdyBjb3VsZCB5b3UgaGFuZGxlIEdTTyBwYWNrZXRzIGZy
b20NCj4gdXNlcnNwYWNlL2d1ZXN0cz8NCj4gPg0KPiA+IE5vdyBieSBkaXNhYmxpbmcgVk0ncyBU
U08gYW5kIGNzdW0gZmVhdHVyZS4NCj4gDQo+IEJ0dywgaG93IGNvdWxkIHlvdSBkbyB0aGF0Pw0K
DQpCeSBzZXQgbmV0d29yayBiYWNrZW5kLXNwZWNpZmljIG9wdGlvbnM6DQo8ZHJpdmVyIG5hbWU9
J3Zob3N0Jz4NCgk8aG9zdCBjc3VtPSdvZmYnIGdzbz0nb2ZmJyB0c280PSdvZmYnIHRzbzY9J29m
ZicgZWNuPSdvZmYnIHVmbz0nb2ZmJyBtcmdfcnhidWY9J29mZicvPg0KICAgIDxndWVzdCBjc3Vt
PSdvZmYnIHRzbzQ9J29mZicgdHNvNj0nb2ZmJyBlY249J29mZicgdWZvPSdvZmYnLz4NCjwvZHJp
dmVyPg0KDQpUaGFua3MNCg0KPiANCj4gVGhhbmtzDQo+IA0KDQo=

