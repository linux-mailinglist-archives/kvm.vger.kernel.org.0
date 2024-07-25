Return-Path: <kvm+bounces-22251-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDDAC93C5CC
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07C691C21E3F
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696FC19D074;
	Thu, 25 Jul 2024 14:56:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA81A1DFF7
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 14:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919388; cv=none; b=h3h3EJN3Oipe/sZ/GgYDfFXLoUW0JG0XjtGBfZSSYFlBXnenkx1aS9CuhdxQvERKC4jMgtgA+7ZKWmSYEmQFxjcZ+OnL8wKsNJMciEyleg24/FIbAvwhbc/mSNG9/mfoCrZXHDTEJWVztcrJo80kvHiXTnfXhkdTdsHpC6dlQak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919388; c=relaxed/simple;
	bh=WwJ/DTZFfUdMK+9S2+SvdFlTQXytqdU5xia6AwlukG0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZTtuTIb+l9NarrKIqVVlhASUxRf4u5jxi1jejnydztj72bVNeUPEGEuGCqxjG5X3Y1XLnHoEtYc7b/J771LmJMt8Xp5EKEqpZtjGyeIHZEoRuvaD4uWJ1pfRqVQhPQ2XTSalvL2HHSQ7NQXANHvrmZG3YzHGXMFvWAVchMi9PbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WVDSL3fZRz6HJTn;
	Thu, 25 Jul 2024 22:54:42 +0800 (CST)
Received: from lhrpeml100005.china.huawei.com (unknown [7.191.160.25])
	by mail.maildlp.com (Postfix) with ESMTPS id DFEC9140519;
	Thu, 25 Jul 2024 22:56:23 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml100005.china.huawei.com (7.191.160.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 15:56:14 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.039;
 Thu, 25 Jul 2024 15:56:14 +0100
From: Salil Mehta <salil.mehta@huawei.com>
To: Peter Maydell <peter.maydell@linaro.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>, Gavin Shan <gshan@redhat.com>, Vishnu Pajjuri
	<vishnu@os.amperecomputing.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>, Xianglai Li <lixianglai@loongson.cn>, "Miguel
 Luis" <miguel.luis@oracle.com>, Shaoqin Huang <shahuang@redhat.com>,
	"Nicholas Piggin" <npiggin@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, "Harsh
 Prateek Bora" <harshpb@linux.ibm.com>, Igor Mammedov <imammedo@redhat.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: RE: [PULL v2 37/61] accel/kvm: Extract common KVM vCPU
 {creation,parking} code
Thread-Topic: [PULL v2 37/61] accel/kvm: Extract common KVM vCPU
 {creation,parking} code
Thread-Index: AQHa3O9RebBRo1C7H0iEcr177twQ1LIHMiGAgAApesD///W5gIAAOgIw
Date: Thu, 25 Jul 2024 14:56:14 +0000
Message-ID: <20ade2533af544ca96862154a0be1a56@huawei.com>
References: <cover.1721731723.git.mst@redhat.com>
 <08c328682231b64878fc052a11091bea39577a6f.1721731723.git.mst@redhat.com>
 <CAFEAcA-3_d1c7XSXWkFubD-LsW5c5i95e6xxV09r2C9yGtzcdA@mail.gmail.com>
 <8f5fcf0c1deb4f199d86441f79298629@huawei.com>
 <CAFEAcA9-gVBLAH9PaFrPmBLD5tHXMZ+-2m+pRvtjodOBaBa0GQ@mail.gmail.com>
In-Reply-To: <CAFEAcA9-gVBLAH9PaFrPmBLD5tHXMZ+-2m+pRvtjodOBaBa0GQ@mail.gmail.com>
Accept-Language: en-US
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

SGkgUGV0ZXIsDQoNCj4gIEZyb206IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJv
Lm9yZz4NCj4gIFNlbnQ6IFRodXJzZGF5LCBKdWx5IDI1LCAyMDI0IDE6MjcgUE0NCj4gIFRvOiBT
YWxpbCBNZWh0YSA8c2FsaWwubWVodGFAaHVhd2VpLmNvbT4NCj4gIA0KPiAgT24gVGh1LCAyNSBK
dWwgMjAyNCBhdCAxMzowNSwgU2FsaWwgTWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+IHdy
b3RlOg0KPiAgPg0KPiAgPiBISSBQZXRlciwNCj4gID4NCj4gID4gPiAgRnJvbTogUGV0ZXIgTWF5
ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3JnPg0KPiAgPiA+ICBTZW50OiBUaHVyc2RheSwg
SnVseSAyNSwgMjAyNCAxMTozNiBBTQ0KPiAgPiA+ICBUbzogTWljaGFlbCBTLiBUc2lya2luIDxt
c3RAcmVkaGF0LmNvbT4NCj4gID4gPg0KPiAgPiA+ICBPbiBUdWUsIDIzIEp1bCAyMDI0IGF0IDEx
OjU4LCBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29tPiB3cm90ZToNCj4gID4gPiAg
Pg0KPiAgPiA+ICA+IEZyb206IFNhbGlsIE1laHRhIDxzYWxpbC5tZWh0YUBodWF3ZWkuY29tPiAg
PiAgPiBLVk0gdkNQVQ0KPiAgPiA+IGNyZWF0aW9uIGlzIGRvbmUgb25jZSBkdXJpbmcgdGhlIHZD
UFUgcmVhbGl6YXRpb24gd2hlbiBRZW11ICA+IHZDUFUNCj4gID4gPiB0aHJlYWQgaXMgc3Bhd25l
ZC4gVGhpcyBpcyBjb21tb24gdG8gYWxsIHRoZSBhcmNoaXRlY3R1cmVzIGFzIG9mIG5vdy4NCj4g
ID4gPiAgPg0KPiAgPiA+ICA+IEhvdC11bnBsdWcgb2YgdkNQVSByZXN1bHRzIGluIGRlc3RydWN0
aW9uIG9mIHRoZSB2Q1BVIG9iamVjdCBpbg0KPiAgPiA+IFFPTSAgPiBidXQgdGhlIGNvcnJlc3Bv
bmRpbmcgS1ZNIHZDUFUgb2JqZWN0IGluIHRoZSBIb3N0IEtWTSBpcyBub3QNCj4gID4gPiBkZXN0
cm95ZWQgID4gYXMgS1ZNIGRvZXNuJ3Qgc3VwcG9ydCB2Q1BVIHJlbW92YWwuIFRoZXJlZm9yZSwg
aXRzDQo+ICA+ID4gcmVwcmVzZW50YXRpdmUgS1ZNICA+IHZDUFUgb2JqZWN0L2NvbnRleHQgaW4g
UWVtdSBpcyBwYXJrZWQuDQo+ICA+ID4gID4NCj4gID4gPiAgPiBSZWZhY3RvciBhcmNoaXRlY3R1
cmUgY29tbW9uIGxvZ2ljIHNvIHRoYXQgc29tZSBBUElzIGNvdWxkIGJlDQo+ICA+ID4gcmV1c2Vk
ICA+IGJ5IHZDUFUgSG90cGx1ZyBjb2RlIG9mIHNvbWUgYXJjaGl0ZWN0dXJlcyBsaWtlcyBBUk0s
DQo+ICBMb29uZ3NvbiBldGMuDQo+ICA+ID4gID4gVXBkYXRlIG5ldy9vbGQgQVBJcyB3aXRoIHRy
YWNlIGV2ZW50cy4gTmV3IEFQSXMgID4NCj4gID4gPiBxZW11X3tjcmVhdGUscGFyayx1bnBhcmt9
X3ZjcHUoKSBjYW4gYmUgZXh0ZXJuYWxseSBjYWxsZWQuIE5vDQo+ICA+ID4gZnVuY3Rpb25hbCAg
Y2hhbmdlIGlzIGludGVuZGVkIGhlcmUuDQo+ICA+ID4NCj4gID4gPiAgSGk7IENvdmVyaXR5IHBv
aW50cyBvdXQgYW4gaXNzdWUgd2l0aCB0aGlzIGNvZGUgKENJRCAxNTU4NTUyKToNCj4gID4gPg0K
PiAgPiA+ICA+ICtpbnQga3ZtX3VucGFya192Y3B1KEtWTVN0YXRlICpzLCB1bnNpZ25lZCBsb25n
IHZjcHVfaWQpIHsNCj4gID4gPiAgPiArICAgIHN0cnVjdCBLVk1QYXJrZWRWY3B1ICpjcHU7DQo+
ICA+ID4gID4gKyAgICBpbnQga3ZtX2ZkID0gLUVOT0VOVDsNCj4gID4gPiAgPiArDQo+ICA+ID4g
ID4gKyAgICBRTElTVF9GT1JFQUNIKGNwdSwgJnMtPmt2bV9wYXJrZWRfdmNwdXMsIG5vZGUpIHsN
Cj4gID4gPiAgPiArICAgICAgICBpZiAoY3B1LT52Y3B1X2lkID09IHZjcHVfaWQpIHsNCj4gID4g
PiAgPiArICAgICAgICAgICAgUUxJU1RfUkVNT1ZFKGNwdSwgbm9kZSk7DQo+ICA+ID4gID4gKyAg
ICAgICAgICAgIGt2bV9mZCA9IGNwdS0+a3ZtX2ZkOw0KPiAgPiA+ICA+ICsgICAgICAgICAgICBn
X2ZyZWUoY3B1KTsNCj4gID4gPiAgPiArICAgICAgICB9DQo+ICA+ID4gID4gKyAgICB9DQo+ICA+
ID4NCj4gID4gPiAgSWYgeW91IGFyZSBnb2luZyB0byByZW1vdmUgYW4gZW50cnkgZnJvbSBhIGxp
c3QgYXMgeW91IGl0ZXJhdGUgb3Zlcg0KPiAgPiA+IGl0LCB5b3UgIGNhbid0IHVzZSBRTElTVF9G
T1JFQUNIKCksIGJlY2F1c2UgUUxJU1RfRk9SRUFDSCB3aWxsIGxvb2sNCj4gID4gPiBhdCB0aGUg
bmV4dCAgcG9pbnRlciBvZiB0aGUgaXRlcmF0aW9uIHZhcmlhYmxlIGF0IHRoZSBlbmQgb2YgdGhl
DQo+ICA+ID4gbG9vcCB3aGVuIGl0IHdhbnRzIHRvICBhZHZhbmNlIHRvIHRoZSBuZXh0IG5vZGUu
IEluIHRoaXMgY2FzZSB3ZSd2ZQ0KPiAgPiA+IGFscmVhZHkgZnJlZWQgJ2NwdScsIHNvIGl0IHdv
dWxkICBiZSByZWFkaW5nIGZyZWVkIG1lbW9yeS4NCj4gID4gPg0KPiAgPiA+ICBTaG91bGQgd2Ug
YnJlYWsgb3V0IG9mIHRoZSBsb29wIHdoZW4gd2UgZmluZCB0aGUgZW50cnk/DQo+ICA+DQo+ICA+
DQo+ICA+IFRoYW5rcyBmb3IgaWRlbnRpZnlpbmcgdGhpcy4gWWVzLCBhICBicmVhayBpcyBtaXNz
aW5nLiBTaG91bGQgSSBzZW5kIGENCj4gID4gZml4IGZvciB0aGlzIG5vdyBvciB5b3UgY2FuIGlu
Y29ycG9yYXRlIGl0Pw0KPiAgDQo+ICBUaGUgY29kZSBpcyBhbHJlYWR5IGluIHVwc3RyZWFtIGdp
dCwgc28gcGxlYXNlIHNlbmQgYSBwYXRjaCB0byBmaXggdGhlIGJ1Zy4NCg0KDQpTdXJlLCBkb25l
LiBQbGVhc2UgaGF2ZSBhIGxvb2ssDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3FlbXUtZGV2
ZWwvMjAyNDA3MjUxNDUxMzIuOTkzNTUtMS1zYWxpbC5tZWh0YUBodWF3ZWkuY29tLw0KDQoNCkJl
c3QgcmVnYXJkcw0KU2FsaWwuDQoNCj4gIA0KPiAgdGhhbmtzDQo+ICAtLSBQTU0NCg==

