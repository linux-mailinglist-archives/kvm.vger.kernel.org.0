Return-Path: <kvm+bounces-7322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE894840387
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 12:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6EFD81F22911
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 11:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38C95BAC9;
	Mon, 29 Jan 2024 11:10:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCE95A7B3;
	Mon, 29 Jan 2024 11:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706526640; cv=none; b=RDNYK9moT5evFA2VvhUDYxkAgYjB9ukGSzkejGJ+atjxg3qbe4K3q81/J4z0ZFA/Xjz5ejJTZnkmn+6+EmMvqOFOZADdbLDFwdyLpBAwhnnTLBi0yosQ19vfpNS9G6vrqOqqHvA5cDHCaMsFU/qeg/BTHu6YYoLqJXKHgTRBKFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706526640; c=relaxed/simple;
	bh=XF0gGsYO9iDx7O+R5WdF16srQI/v5qvD1W7fKbgxUks=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wd1EIBJgHC1kNbABzbC1ia0ELa/iBp4J383BiyCjWGbOBLnVOEdJAbYEKNgMHsBH9Y8Tjg+zcA/lIE3F/RqNJDyAvjZDDxpGMJn0p0Zw770Jm5+wBkRZRu7J1MC7+IB5bjGC9pVh/K2HGLT1ibmhlRuimFSYnpMwNXzYaCzZZ7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4TNltX1D17z1Q8bW;
	Mon, 29 Jan 2024 19:09:24 +0800 (CST)
Received: from kwepemd200002.china.huawei.com (unknown [7.221.188.186])
	by mail.maildlp.com (Postfix) with ESMTPS id 67BE018001D;
	Mon, 29 Jan 2024 19:10:33 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemd200002.china.huawei.com (7.221.188.186) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Mon, 29 Jan 2024 19:10:32 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Mon, 29 Jan 2024 19:10:32 +0800
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
Thread-Index: AQHaTqkDLHSSzcU2CESolpkubpTJa7DpcBcAgAD60ACAAvY/kIACO22AgAEHRbA=
Date: Mon, 29 Jan 2024 11:10:32 +0000
Message-ID: <506f483f07eb41d0bbea58333ae0c933@huawei.com>
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com>
 <CACGkMEu5PaBgh37X4KysoF9YB8qy6jM5W4G6sm+8fjrnK36KXA@mail.gmail.com>
 <ad74a361d5084c62a89f7aa276273649@huawei.com>
 <156030296fea4f7abef6ab7155ba2e32@huawei.com>
 <CACGkMEuMTdr3NS=XdkN+XDRqiXouL2tWcXEk6-qTvOsm0JCc9Q@mail.gmail.com>
In-Reply-To: <CACGkMEuMTdr3NS=XdkN+XDRqiXouL2tWcXEk6-qTvOsm0JCc9Q@mail.gmail.com>
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
OjA1IEFNDQo+IFRvOiB3YW5neXVuamlhbiA8d2FuZ3l1bmppYW5AaHVhd2VpLmNvbT4NCj4gQ2M6
IG1zdEByZWRoYXQuY29tOyB3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tOyBrdWJhQGtl
cm5lbC5vcmc7DQo+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG1hZ251cy5rYXJsc3NvbkBpbnRlbC5j
b207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IGt2bUB2Z2VyLmtlcm5lbC5vcmc7DQo+IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LmRl
djsgeHVkaW5na2UgPHh1ZGluZ2tlQGh1YXdlaS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
bmV0LW5leHQgMi8yXSB0dW46IEFGX1hEUCBSeCB6ZXJvLWNvcHkgc3VwcG9ydA0KPiANCj4gT24g
U2F0LCBKYW4gMjcsIDIwMjQgYXQgNTozNOKAr1BNIHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBo
dWF3ZWkuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gPiBGcm9tOiBKYXNvbiBXYW5nIFttYWlsdG86amFzb3dhbmdAcmVkaGF0LmNv
bV0NCj4gPiA+ID4gU2VudDogVGh1cnNkYXksIEphbnVhcnkgMjUsIDIwMjQgMTI6NDkgUE0NCj4g
PiA+ID4gVG86IHdhbmd5dW5qaWFuIDx3YW5neXVuamlhbkBodWF3ZWkuY29tPg0KPiA+ID4gPiBD
YzogbXN0QHJlZGhhdC5jb207IHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb207DQo+ID4g
PiA+IGt1YmFAa2VybmVsLm9yZzsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbWFnbnVzLmthcmxzc29u
QGludGVsLmNvbTsNCj4gPiA+ID4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsNCj4gPiA+ID4ga3ZtQHZnZXIua2VybmVsLm9yZzsgdmlydHVhbGl6
YXRpb25AbGlzdHMubGludXguZGV2OyB4dWRpbmdrZQ0KPiA+ID4gPiA8eHVkaW5na2VAaHVhd2Vp
LmNvbT4NCj4gPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAyLzJdIHR1bjogQUZf
WERQIFJ4IHplcm8tY29weSBzdXBwb3J0DQo+ID4gPiA+DQo+ID4gPiA+IE9uIFdlZCwgSmFuIDI0
LCAyMDI0IGF0IDU6MzjigK9QTSBZdW5qaWFuIFdhbmcNCj4gPiA+IDx3YW5neXVuamlhbkBodWF3
ZWkuY29tPg0KPiA+ID4gPiB3cm90ZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IE5vdyB0aGUgemVy
by1jb3B5IGZlYXR1cmUgb2YgQUZfWERQIHNvY2tldCBpcyBzdXBwb3J0ZWQgYnkgc29tZQ0KPiA+
ID4gPiA+IGRyaXZlcnMsIHdoaWNoIGNhbiByZWR1Y2UgQ1BVIHV0aWxpemF0aW9uIG9uIHRoZSB4
ZHAgcHJvZ3JhbS4NCj4gPiA+ID4gPiBUaGlzIHBhdGNoIHNldCBhbGxvd3MgdHVuIHRvIHN1cHBv
cnQgQUZfWERQIFJ4IHplcm8tY29weSBmZWF0dXJlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gVGhp
cyBwYXRjaCB0cmllcyB0byBhZGRyZXNzIHRoaXMgYnk6DQo+ID4gPiA+ID4gLSBVc2UgcGVla19s
ZW4gdG8gY29uc3VtZSBhIHhzay0+ZGVzYyBhbmQgZ2V0IHhzay0+ZGVzYyBsZW5ndGguDQo+ID4g
PiA+ID4gLSBXaGVuIHRoZSB0dW4gc3VwcG9ydCBBRl9YRFAgUnggemVyby1jb3B5LCB0aGUgdnEn
cyBhcnJheSBtYXliZQ0KPiBlbXB0eS4NCj4gPiA+ID4gPiBTbyBhZGQgYSBjaGVjayBmb3IgZW1w
dHkgdnEncyBhcnJheSBpbiB2aG9zdF9uZXRfYnVmX3Byb2R1Y2UoKS4NCj4gPiA+ID4gPiAtIGFk
ZCBYRFBfU0VUVVBfWFNLX1BPT0wgYW5kIG5kb194c2tfd2FrZXVwIGNhbGxiYWNrIHN1cHBvcnQN
Cj4gPiA+ID4gPiAtIGFkZCB0dW5fcHV0X3VzZXJfZGVzYyBmdW5jdGlvbiB0byBjb3B5IHRoZSBS
eCBkYXRhIHRvIFZNDQo+ID4gPiA+DQo+ID4gPiA+IENvZGUgZXhwbGFpbnMgdGhlbXNlbHZlcywg
bGV0J3MgZXhwbGFpbiB3aHkgeW91IG5lZWQgdG8gZG8gdGhpcy4NCj4gPiA+ID4NCj4gPiA+ID4g
MSkgd2h5IHlvdSB3YW50IHRvIHVzZSBwZWVrX2xlbg0KPiA+ID4gPiAyKSBmb3IgInZxJ3MgYXJy
YXkiLCB3aGF0IGRvZXMgaXQgbWVhbj8NCj4gPiA+ID4gMykgZnJvbSB0aGUgdmlldyBvZiBUVU4v
VEFQIHR1bl9wdXRfdXNlcl9kZXNjKCkgaXMgdGhlIFRYIHBhdGgsIHNvDQo+ID4gPiA+IEkgZ3Vl
c3MgeW91IG1lYW50IFRYIHplcm9jb3B5IGluc3RlYWQgb2YgUlggKGFzIEkgZG9uJ3Qgc2VlIGNv
ZGVzDQo+ID4gPiA+IGZvcg0KPiA+ID4gPiBSWD8pDQo+ID4gPg0KPiA+ID4gT0ssIEkgYWdyZWUg
YW5kIHVzZSBUWCB6ZXJvY29weSBpbnN0ZWFkIG9mIFJYIHplcm9jb3B5LiBJIG1lYW50IFJYDQo+
ID4gPiB6ZXJvY29weSBmcm9tIHRoZSB2aWV3IG9mIHZob3N0LW5ldC4NCj4gPiA+DQo+ID4gPiA+
DQo+ID4gPiA+IEEgYmlnIHF1ZXN0aW9uIGlzIGhvdyBjb3VsZCB5b3UgaGFuZGxlIEdTTyBwYWNr
ZXRzIGZyb20NCj4gdXNlcnNwYWNlL2d1ZXN0cz8NCj4gPiA+DQo+ID4gPiBOb3cgYnkgZGlzYWJs
aW5nIFZNJ3MgVFNPIGFuZCBjc3VtIGZlYXR1cmUuIFhEUCBkb2VzIG5vdCBzdXBwb3J0IEdTTw0K
PiA+ID4gcGFja2V0cy4NCj4gPiA+IEhvd2V2ZXIsIHRoaXMgZmVhdHVyZSBjYW4gYmUgYWRkZWQg
b25jZSBYRFAgc3VwcG9ydHMgaXQgaW4gdGhlIGZ1dHVyZS4NCj4gPiA+DQo+ID4gPiA+DQo+ID4g
PiA+ID4NCj4gPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBZdW5qaWFuIFdhbmcgPHdhbmd5dW5qaWFu
QGh1YXdlaS5jb20+DQo+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gIGRyaXZlcnMvbmV0L3R1bi5j
ICAgfCAxNjUNCj4gPiA+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0NCj4gPiA+ID4gPiAgZHJpdmVycy92aG9zdC9uZXQuYyB8ICAxOCArKystLQ0KPiA+ID4g
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDE3NiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gWy4uLl0NCj4gPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gIHN0YXRpYyBpbnQgcGVl
a19oZWFkX2xlbihzdHJ1Y3Qgdmhvc3RfbmV0X3ZpcnRxdWV1ZSAqcnZxLA0KPiA+ID4gPiA+IHN0
cnVjdCBzb2NrDQo+ID4gPiA+ID4gKnNrKSAgew0KPiA+ID4gPiA+ICsgICAgICAgc3RydWN0IHNv
Y2tldCAqc29jayA9IHNrLT5za19zb2NrZXQ7DQo+ID4gPiA+ID4gICAgICAgICBzdHJ1Y3Qgc2tf
YnVmZiAqaGVhZDsNCj4gPiA+ID4gPiAgICAgICAgIGludCBsZW4gPSAwOw0KPiA+ID4gPiA+ICAg
ICAgICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+IC0gICAgICAg
aWYgKHJ2cS0+cnhfcmluZykNCj4gPiA+ID4gPiAtICAgICAgICAgICAgICAgcmV0dXJuIHZob3N0
X25ldF9idWZfcGVlayhydnEpOw0KPiA+ID4gPiA+ICsgICAgICAgaWYgKHJ2cS0+cnhfcmluZykg
ew0KPiA+ID4gPiA+ICsgICAgICAgICAgICAgICBsZW4gPSB2aG9zdF9uZXRfYnVmX3BlZWsocnZx
KTsNCj4gPiA+ID4gPiArICAgICAgICAgICAgICAgaWYgKGxpa2VseShsZW4pKQ0KPiA+ID4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBsZW47DQo+ID4gPiA+ID4gKyAgICAgICB9
DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICsgICAgICAgaWYgKHNvY2stPm9wcy0+cGVla19sZW4p
DQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVybiBzb2NrLT5vcHMtPnBlZWtfbGVuKHNv
Y2spOw0KPiA+ID4gPg0KPiA+ID4gPiBXaGF0IHByZXZlbnRzIHlvdSBmcm9tIHJldXNpbmcgdGhl
IHB0cl9yaW5nIGhlcmU/IFRoZW4geW91IGRvbid0DQo+ID4gPiA+IG5lZWQgdGhlIGFib3ZlIHRy
aWNrcy4NCj4gPiA+DQo+ID4gPiBUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2VzdGlvbi4gSSB3aWxs
IGNvbnNpZGVyIGhvdyB0byByZXVzZSB0aGUgcHRyX3JpbmcuDQo+ID4NCj4gPiBJZiBwdHJfcmlu
ZyBpcyB1c2VkIHRvIHRyYW5zZmVyIHhkcF9kZXNjcywgdGhlcmUgaXMgYSBwcm9ibGVtOiBBZnRl
cg0KPiA+IHNvbWUgeGRwX2Rlc2NzIGFyZSBvYnRhaW5lZCB0aHJvdWdoIHhza190eF9wZWVrX2Rl
c2MoKSwgdGhlIGRlc2NzIG1heQ0KPiA+IGZhaWwgdG8gYmUgYWRkZWQgdG8gcHRyX3JpbmcuIEhv
d2V2ZXIsIG5vIEFQSSBpcyBhdmFpbGFibGUgdG8NCj4gPiBpbXBsZW1lbnQgdGhlIHJvbGxiYWNr
IGZ1bmN0aW9uLg0KPiANCj4gSSBkb24ndCB1bmRlcnN0YW5kLCB0aGlzIGlzc3VlIHNlZW1zIHRv
IGV4aXN0IGluIHRoZSBwaHlzaWNhbCBOSUMgYXMgd2VsbD8NCj4gDQo+IFdlIGdldCBtb3JlIGRl
c2NyaXB0b3JzIHRoYW4gdGhlIGZyZWUgc2xvdHMgaW4gdGhlIE5JQyByaW5nLg0KPiANCj4gSG93
IGRpZCBvdGhlciBOSUMgc29sdmUgdGhpcyBpc3N1ZT8NCg0KQ3VycmVudGx5LCBwaHlzaWNhbCBO
SUNzIHN1Y2ggYXMgaTQwZSwgaWNlLCBpeGdiZSwgaWdjLCBhbmQgbWx4NSBvYnRhaW5zDQphdmFp
bGFibGUgTklDIGRlc2NyaXB0b3JzIGFuZCB0aGVuIHJldHJpZXZlIHRoZSBzYW1lIG51bWJlciBv
ZiB4c2sNCmRlc2NyaXB0b3JzIGZvciBwcm9jZXNzaW5nLg0KDQpUaGFua3MNCg0KPiANCj4gVGhh
bmtzDQo+IA0KPiA+DQo+ID4gVGhhbmtzDQo+ID4NCj4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+IFRo
YW5rcw0KPiA+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gICAgICAgICBzcGlu
X2xvY2tfaXJxc2F2ZSgmc2stPnNrX3JlY2VpdmVfcXVldWUubG9jaywgZmxhZ3MpOw0KPiA+ID4g
PiA+ICAgICAgICAgaGVhZCA9IHNrYl9wZWVrKCZzay0+c2tfcmVjZWl2ZV9xdWV1ZSk7DQo+ID4g
PiA+ID4gLS0NCj4gPiA+ID4gPiAyLjMzLjANCj4gPiA+ID4gPg0KPiA+DQoNCg==

