Return-Path: <kvm+bounces-7274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD91D83EC53
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 10:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EAF4B216B9
	for <lists+kvm@lfdr.de>; Sat, 27 Jan 2024 09:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5833C1EB34;
	Sat, 27 Jan 2024 09:34:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9871EB21;
	Sat, 27 Jan 2024 09:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706348063; cv=none; b=eHP7MTW/Ge2AAukZnSOOuM5BgQ4mWnY4SDMqyDCntzMMlbbMjUItGV5zkXl2s1te4EoomMah4/kWjfrFLiJTW1GVvHQoBzXLRTYBDoB6ZWtGW4DVMpqos3ybe4IOA7RyPrNDbkshl2nZJvnzukNzY/kJD+63pquggLv15KYleJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706348063; c=relaxed/simple;
	bh=jWWHAvPyYDmqWSnWLY25KtBJxBARbNBlduXIIg7JPi4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eyiOs8KiP29kFiIRBGWsDITVFR+AvKyAISGISYAEtmkoL9s68tMoguz4xZ+Lrw8LOFuomAV+srZVc3LBGdenmTq2Y1rweGdXnwJMaISlb7lBiyVUuV0+lJXWkDlGpKb61ojDocKC8Gf+CD/Vf1/ZfyJ9MovyesdeVODVj2hkb3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4TMTqt3f6XzvVKf;
	Sat, 27 Jan 2024 17:32:42 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (unknown [7.185.36.136])
	by mail.maildlp.com (Postfix) with ESMTPS id E0421180079;
	Sat, 27 Jan 2024 17:34:17 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggpemm500008.china.huawei.com (7.185.36.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Jan 2024 17:34:17 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Sat, 27 Jan 2024 17:34:17 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: wangyunjian <wangyunjian@huawei.com>, Jason Wang <jasowang@redhat.com>
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
Thread-Index: AQHaTqkDLHSSzcU2CESolpkubpTJa7DpcBcAgAD60ACAAvY/kA==
Date: Sat, 27 Jan 2024 09:34:17 +0000
Message-ID: <156030296fea4f7abef6ab7155ba2e32@huawei.com>
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
 <ad74a361d5084c62a89f7aa276273649@huawei.com>
In-Reply-To: <ad74a361d5084c62a89f7aa276273649@huawei.com>
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

PiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogSmFzb24gV2FuZyBbbWFp
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+ID4gU2VudDogVGh1cnNkYXksIEphbnVhcnkgMjUs
IDIwMjQgMTI6NDkgUE0NCj4gPiBUbzogd2FuZ3l1bmppYW4gPHdhbmd5dW5qaWFuQGh1YXdlaS5j
b20+DQo+ID4gQ2M6IG1zdEByZWRoYXQuY29tOyB3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwu
Y29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+ID4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbWFnbnVzLmth
cmxzc29uQGludGVsLmNvbTsNCj4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnOw0KPiA+IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHZpcnR1YWxpemF0
aW9uQGxpc3RzLmxpbnV4LmRldjsgeHVkaW5na2UNCj4gPiA8eHVkaW5na2VAaHVhd2VpLmNvbT4N
Cj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IDIvMl0gdHVuOiBBRl9YRFAgUnggemVy
by1jb3B5IHN1cHBvcnQNCj4gPg0KPiA+IE9uIFdlZCwgSmFuIDI0LCAyMDI0IGF0IDU6MzjigK9Q
TSBZdW5qaWFuIFdhbmcNCj4gPHdhbmd5dW5qaWFuQGh1YXdlaS5jb20+DQo+ID4gd3JvdGU6DQo+
ID4gPg0KPiA+ID4gTm93IHRoZSB6ZXJvLWNvcHkgZmVhdHVyZSBvZiBBRl9YRFAgc29ja2V0IGlz
IHN1cHBvcnRlZCBieSBzb21lDQo+ID4gPiBkcml2ZXJzLCB3aGljaCBjYW4gcmVkdWNlIENQVSB1
dGlsaXphdGlvbiBvbiB0aGUgeGRwIHByb2dyYW0uDQo+ID4gPiBUaGlzIHBhdGNoIHNldCBhbGxv
d3MgdHVuIHRvIHN1cHBvcnQgQUZfWERQIFJ4IHplcm8tY29weSBmZWF0dXJlLg0KPiA+ID4NCj4g
PiA+IFRoaXMgcGF0Y2ggdHJpZXMgdG8gYWRkcmVzcyB0aGlzIGJ5Og0KPiA+ID4gLSBVc2UgcGVl
a19sZW4gdG8gY29uc3VtZSBhIHhzay0+ZGVzYyBhbmQgZ2V0IHhzay0+ZGVzYyBsZW5ndGguDQo+
ID4gPiAtIFdoZW4gdGhlIHR1biBzdXBwb3J0IEFGX1hEUCBSeCB6ZXJvLWNvcHksIHRoZSB2cSdz
IGFycmF5IG1heWJlIGVtcHR5Lg0KPiA+ID4gU28gYWRkIGEgY2hlY2sgZm9yIGVtcHR5IHZxJ3Mg
YXJyYXkgaW4gdmhvc3RfbmV0X2J1Zl9wcm9kdWNlKCkuDQo+ID4gPiAtIGFkZCBYRFBfU0VUVVBf
WFNLX1BPT0wgYW5kIG5kb194c2tfd2FrZXVwIGNhbGxiYWNrIHN1cHBvcnQNCj4gPiA+IC0gYWRk
IHR1bl9wdXRfdXNlcl9kZXNjIGZ1bmN0aW9uIHRvIGNvcHkgdGhlIFJ4IGRhdGEgdG8gVk0NCj4g
Pg0KPiA+IENvZGUgZXhwbGFpbnMgdGhlbXNlbHZlcywgbGV0J3MgZXhwbGFpbiB3aHkgeW91IG5l
ZWQgdG8gZG8gdGhpcy4NCj4gPg0KPiA+IDEpIHdoeSB5b3Ugd2FudCB0byB1c2UgcGVla19sZW4N
Cj4gPiAyKSBmb3IgInZxJ3MgYXJyYXkiLCB3aGF0IGRvZXMgaXQgbWVhbj8NCj4gPiAzKSBmcm9t
IHRoZSB2aWV3IG9mIFRVTi9UQVAgdHVuX3B1dF91c2VyX2Rlc2MoKSBpcyB0aGUgVFggcGF0aCwg
c28gSQ0KPiA+IGd1ZXNzIHlvdSBtZWFudCBUWCB6ZXJvY29weSBpbnN0ZWFkIG9mIFJYIChhcyBJ
IGRvbid0IHNlZSBjb2RlcyBmb3INCj4gPiBSWD8pDQo+IA0KPiBPSywgSSBhZ3JlZSBhbmQgdXNl
IFRYIHplcm9jb3B5IGluc3RlYWQgb2YgUlggemVyb2NvcHkuIEkgbWVhbnQgUlggemVyb2NvcHkN
Cj4gZnJvbSB0aGUgdmlldyBvZiB2aG9zdC1uZXQuDQo+IA0KPiA+DQo+ID4gQSBiaWcgcXVlc3Rp
b24gaXMgaG93IGNvdWxkIHlvdSBoYW5kbGUgR1NPIHBhY2tldHMgZnJvbSB1c2Vyc3BhY2UvZ3Vl
c3RzPw0KPiANCj4gTm93IGJ5IGRpc2FibGluZyBWTSdzIFRTTyBhbmQgY3N1bSBmZWF0dXJlLiBY
RFAgZG9lcyBub3Qgc3VwcG9ydCBHU08NCj4gcGFja2V0cy4NCj4gSG93ZXZlciwgdGhpcyBmZWF0
dXJlIGNhbiBiZSBhZGRlZCBvbmNlIFhEUCBzdXBwb3J0cyBpdCBpbiB0aGUgZnV0dXJlLg0KPiAN
Cj4gPg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFl1bmppYW4gV2FuZyA8d2FuZ3l1bmpp
YW5AaHVhd2VpLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L3R1bi5jICAgfCAx
NjUNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+
ID4gIGRyaXZlcnMvdmhvc3QvbmV0LmMgfCAgMTggKysrLS0NCj4gPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDE3NiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KDQpbLi4uXQ0KDQo+ID4gPg0K
PiA+ID4gIHN0YXRpYyBpbnQgcGVla19oZWFkX2xlbihzdHJ1Y3Qgdmhvc3RfbmV0X3ZpcnRxdWV1
ZSAqcnZxLCBzdHJ1Y3QNCj4gPiA+IHNvY2sNCj4gPiA+ICpzaykgIHsNCj4gPiA+ICsgICAgICAg
c3RydWN0IHNvY2tldCAqc29jayA9IHNrLT5za19zb2NrZXQ7DQo+ID4gPiAgICAgICAgIHN0cnVj
dCBza19idWZmICpoZWFkOw0KPiA+ID4gICAgICAgICBpbnQgbGVuID0gMDsNCj4gPiA+ICAgICAg
ICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiA+DQo+ID4gPiAtICAgICAgIGlmIChydnEtPnJ4
X3JpbmcpDQo+ID4gPiAtICAgICAgICAgICAgICAgcmV0dXJuIHZob3N0X25ldF9idWZfcGVlayhy
dnEpOw0KPiA+ID4gKyAgICAgICBpZiAocnZxLT5yeF9yaW5nKSB7DQo+ID4gPiArICAgICAgICAg
ICAgICAgbGVuID0gdmhvc3RfbmV0X2J1Zl9wZWVrKHJ2cSk7DQo+ID4gPiArICAgICAgICAgICAg
ICAgaWYgKGxpa2VseShsZW4pKQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJu
IGxlbjsNCj4gPiA+ICsgICAgICAgfQ0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICBpZiAoc29jay0+
b3BzLT5wZWVrX2xlbikNCj4gPiA+ICsgICAgICAgICAgICAgICByZXR1cm4gc29jay0+b3BzLT5w
ZWVrX2xlbihzb2NrKTsNCj4gPg0KPiA+IFdoYXQgcHJldmVudHMgeW91IGZyb20gcmV1c2luZyB0
aGUgcHRyX3JpbmcgaGVyZT8gVGhlbiB5b3UgZG9uJ3QgbmVlZA0KPiA+IHRoZSBhYm92ZSB0cmlj
a3MuDQo+IA0KPiBUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2VzdGlvbi4gSSB3aWxsIGNvbnNpZGVy
IGhvdyB0byByZXVzZSB0aGUgcHRyX3JpbmcuDQoNCklmIHB0cl9yaW5nIGlzIHVzZWQgdG8gdHJh
bnNmZXIgeGRwX2Rlc2NzLCB0aGVyZSBpcyBhIHByb2JsZW06IEFmdGVyIHNvbWUNCnhkcF9kZXNj
cyBhcmUgb2J0YWluZWQgdGhyb3VnaCB4c2tfdHhfcGVla19kZXNjKCksIHRoZSBkZXNjcyBtYXkg
ZmFpbA0KdG8gYmUgYWRkZWQgdG8gcHRyX3JpbmcuIEhvd2V2ZXIsIG5vIEFQSSBpcyBhdmFpbGFi
bGUgdG8gaW1wbGVtZW50IHRoZQ0Kcm9sbGJhY2sgZnVuY3Rpb24uDQoNClRoYW5rcw0KDQo+IA0K
PiA+DQo+ID4gVGhhbmtzDQo+ID4NCj4gPg0KPiA+ID4NCj4gPiA+ICAgICAgICAgc3Bpbl9sb2Nr
X2lycXNhdmUoJnNrLT5za19yZWNlaXZlX3F1ZXVlLmxvY2ssIGZsYWdzKTsNCj4gPiA+ICAgICAg
ICAgaGVhZCA9IHNrYl9wZWVrKCZzay0+c2tfcmVjZWl2ZV9xdWV1ZSk7DQo+ID4gPiAtLQ0KPiA+
ID4gMi4zMy4wDQo+ID4gPg0KDQo=

