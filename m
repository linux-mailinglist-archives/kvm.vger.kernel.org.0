Return-Path: <kvm+bounces-22228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FA0E93C16D
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:06:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0B861C217E3
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 12:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B67199246;
	Thu, 25 Jul 2024 12:05:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C70522089
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 12:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721909158; cv=none; b=kkqAyINtP+p8rqt3dD2onHhIDUu1pCClPGFdKdymQeowEgv0Ag3QHiNpUGj6G13CUZMSl4lbObzdU6lltc0UROk0vpnQjQ2beac1r5FQlilmYbTEzWE0FpThsHob2qFkW7TYP2hqBiFMoWhGvYx22+kR24ru6txjicIRTGyEdwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721909158; c=relaxed/simple;
	bh=fOdKQ9fVU8gKG8SF3F1vS3oQT2gIophfp1LdCx3e3fE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hw5mk0Cpl7viB33ih2dtgUoSiLHH+IZ4l7xVCYQXE+1zZQLFAgIC1NI2zMh84WIS/ODBX1wprTV0QnSPRI2Y7Gzu9foAtqp/QALUjRygOg4cwgn0RonImb0sHIQVkCyO7M3M8r7T+JIwVUghnhhFXmXI/jYDfwgVt+El78+gRAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4WV8gb1yYMz6K5nt;
	Thu, 25 Jul 2024 20:04:11 +0800 (CST)
Received: from lhrpeml100003.china.huawei.com (unknown [7.191.160.210])
	by mail.maildlp.com (Postfix) with ESMTPS id 546D9140B2F;
	Thu, 25 Jul 2024 20:05:52 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml100003.china.huawei.com (7.191.160.210) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 25 Jul 2024 13:05:52 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.039;
 Thu, 25 Jul 2024 13:05:52 +0100
From: Salil Mehta <salil.mehta@huawei.com>
To: Peter Maydell <peter.maydell@linaro.org>, "Michael S. Tsirkin"
	<mst@redhat.com>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Gavin Shan
	<gshan@redhat.com>, Vishnu Pajjuri <vishnu@os.amperecomputing.com>, "Jonathan
 Cameron" <jonathan.cameron@huawei.com>, Xianglai Li <lixianglai@loongson.cn>,
	Miguel Luis <miguel.luis@oracle.com>, Shaoqin Huang <shahuang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>, Zhao Liu <zhao1.liu@intel.com>, "Harsh
 Prateek Bora" <harshpb@linux.ibm.com>, Igor Mammedov <imammedo@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: RE: [PULL v2 37/61] accel/kvm: Extract common KVM vCPU
 {creation,parking} code
Thread-Topic: [PULL v2 37/61] accel/kvm: Extract common KVM vCPU
 {creation,parking} code
Thread-Index: AQHa3O9RebBRo1C7H0iEcr177twQ1LIHMiGAgAApesA=
Date: Thu, 25 Jul 2024 12:05:51 +0000
Message-ID: <8f5fcf0c1deb4f199d86441f79298629@huawei.com>
References: <cover.1721731723.git.mst@redhat.com>
 <08c328682231b64878fc052a11091bea39577a6f.1721731723.git.mst@redhat.com>
 <CAFEAcA-3_d1c7XSXWkFubD-LsW5c5i95e6xxV09r2C9yGtzcdA@mail.gmail.com>
In-Reply-To: <CAFEAcA-3_d1c7XSXWkFubD-LsW5c5i95e6xxV09r2C9yGtzcdA@mail.gmail.com>
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

SEkgUGV0ZXIsDQoNCj4gIEZyb206IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJv
Lm9yZz4NCj4gIFNlbnQ6IFRodXJzZGF5LCBKdWx5IDI1LCAyMDI0IDExOjM2IEFNDQo+ICBUbzog
TWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4NCj4gIA0KPiAgT24gVHVlLCAyMyBK
dWwgMjAyNCBhdCAxMTo1OCwgTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4gd3Jv
dGU6DQo+ICA+DQo+ICA+IEZyb206IFNhbGlsIE1laHRhIDxzYWxpbC5tZWh0YUBodWF3ZWkuY29t
Pg0KPiAgPg0KPiAgPiBLVk0gdkNQVSBjcmVhdGlvbiBpcyBkb25lIG9uY2UgZHVyaW5nIHRoZSB2
Q1BVIHJlYWxpemF0aW9uIHdoZW4gUWVtdQ0KPiAgPiB2Q1BVIHRocmVhZCBpcyBzcGF3bmVkLiBU
aGlzIGlzIGNvbW1vbiB0byBhbGwgdGhlIGFyY2hpdGVjdHVyZXMgYXMgb2Ygbm93Lg0KPiAgPg0K
PiAgPiBIb3QtdW5wbHVnIG9mIHZDUFUgcmVzdWx0cyBpbiBkZXN0cnVjdGlvbiBvZiB0aGUgdkNQ
VSBvYmplY3QgaW4gUU9NDQo+ICA+IGJ1dCB0aGUgY29ycmVzcG9uZGluZyBLVk0gdkNQVSBvYmpl
Y3QgaW4gdGhlIEhvc3QgS1ZNIGlzIG5vdCBkZXN0cm95ZWQNCj4gID4gYXMgS1ZNIGRvZXNuJ3Qg
c3VwcG9ydCB2Q1BVIHJlbW92YWwuIFRoZXJlZm9yZSwgaXRzIHJlcHJlc2VudGF0aXZlIEtWTQ0K
PiAgPiB2Q1BVIG9iamVjdC9jb250ZXh0IGluIFFlbXUgaXMgcGFya2VkLg0KPiAgPg0KPiAgPiBS
ZWZhY3RvciBhcmNoaXRlY3R1cmUgY29tbW9uIGxvZ2ljIHNvIHRoYXQgc29tZSBBUElzIGNvdWxk
IGJlIHJldXNlZA0KPiAgPiBieSB2Q1BVIEhvdHBsdWcgY29kZSBvZiBzb21lIGFyY2hpdGVjdHVy
ZXMgbGlrZXMgQVJNLCBMb29uZ3NvbiBldGMuDQo+ICA+IFVwZGF0ZSBuZXcvb2xkIEFQSXMgd2l0
aCB0cmFjZSBldmVudHMuIE5ldyBBUElzDQo+ICA+IHFlbXVfe2NyZWF0ZSxwYXJrLHVucGFya31f
dmNwdSgpIGNhbiBiZSBleHRlcm5hbGx5IGNhbGxlZC4gTm8gZnVuY3Rpb25hbA0KPiAgY2hhbmdl
IGlzIGludGVuZGVkIGhlcmUuDQo+ICANCj4gIEhpOyBDb3Zlcml0eSBwb2ludHMgb3V0IGFuIGlz
c3VlIHdpdGggdGhpcyBjb2RlIChDSUQgMTU1ODU1Mik6DQo+ICANCj4gID4gK2ludCBrdm1fdW5w
YXJrX3ZjcHUoS1ZNU3RhdGUgKnMsIHVuc2lnbmVkIGxvbmcgdmNwdV9pZCkgew0KPiAgPiArICAg
IHN0cnVjdCBLVk1QYXJrZWRWY3B1ICpjcHU7DQo+ICA+ICsgICAgaW50IGt2bV9mZCA9IC1FTk9F
TlQ7DQo+ICA+ICsNCj4gID4gKyAgICBRTElTVF9GT1JFQUNIKGNwdSwgJnMtPmt2bV9wYXJrZWRf
dmNwdXMsIG5vZGUpIHsNCj4gID4gKyAgICAgICAgaWYgKGNwdS0+dmNwdV9pZCA9PSB2Y3B1X2lk
KSB7DQo+ICA+ICsgICAgICAgICAgICBRTElTVF9SRU1PVkUoY3B1LCBub2RlKTsNCj4gID4gKyAg
ICAgICAgICAgIGt2bV9mZCA9IGNwdS0+a3ZtX2ZkOw0KPiAgPiArICAgICAgICAgICAgZ19mcmVl
KGNwdSk7DQo+ICA+ICsgICAgICAgIH0NCj4gID4gKyAgICB9DQo+ICANCj4gIElmIHlvdSBhcmUg
Z29pbmcgdG8gcmVtb3ZlIGFuIGVudHJ5IGZyb20gYSBsaXN0IGFzIHlvdSBpdGVyYXRlIG92ZXIg
aXQsIHlvdQ0KPiAgY2FuJ3QgdXNlIFFMSVNUX0ZPUkVBQ0goKSwgYmVjYXVzZSBRTElTVF9GT1JF
QUNIIHdpbGwgbG9vayBhdCB0aGUgbmV4dA0KPiAgcG9pbnRlciBvZiB0aGUgaXRlcmF0aW9uIHZh
cmlhYmxlIGF0IHRoZSBlbmQgb2YgdGhlIGxvb3Agd2hlbiBpdCB3YW50cyB0bw0KPiAgYWR2YW5j
ZSB0byB0aGUgbmV4dCBub2RlLiBJbiB0aGlzIGNhc2Ugd2UndmUgYWxyZWFkeSBmcmVlZCAnY3B1
Jywgc28gaXQgd291bGQNCj4gIGJlIHJlYWRpbmcgZnJlZWQgbWVtb3J5Lg0KPiAgDQo+ICBTaG91
bGQgd2UgYnJlYWsgb3V0IG9mIHRoZSBsb29wIHdoZW4gd2UgZmluZCB0aGUgZW50cnk/DQoNCg0K
VGhhbmtzIGZvciBpZGVudGlmeWluZyB0aGlzLiBZZXMsIGEgIGJyZWFrIGlzIG1pc3NpbmcuIFNo
b3VsZCBJIHNlbmQgYSBmaXggZm9yIHRoaXMNCm5vdyBvciB5b3UgY2FuIGluY29ycG9yYXRlIGl0
Pw0KDQoNCkJlc3QgcmVnYXJkcw0KU2FsaWwNCg0KDQo+ICANCj4gIElmIHdlIGRvIG5lZWQgdG8g
Y29udGludWUgaXRlcmF0aW9uIGFmdGVyIHJlbW92aW5nIHRoZSBsaXN0IG5vZGUsIHlvdSBuZWVk
DQo+ICB0byB1c2UgUUxJU1RfRk9SRUFDSF9TQUZFKCkgdG8gZG8gdGhlIGxpc3QgaXRlcmF0aW9u
Lg0KPiAgDQo+ICA+IC1zdGF0aWMgaW50IGt2bV9nZXRfdmNwdShLVk1TdGF0ZSAqcywgdW5zaWdu
ZWQgbG9uZyB2Y3B1X2lkKSAtew0KPiAgPiAtICAgIHN0cnVjdCBLVk1QYXJrZWRWY3B1ICpjcHU7
DQo+ICA+IC0NCj4gID4gLSAgICBRTElTVF9GT1JFQUNIKGNwdSwgJnMtPmt2bV9wYXJrZWRfdmNw
dXMsIG5vZGUpIHsNCj4gID4gLSAgICAgICAgaWYgKGNwdS0+dmNwdV9pZCA9PSB2Y3B1X2lkKSB7
DQo+ICA+IC0gICAgICAgICAgICBpbnQga3ZtX2ZkOw0KPiAgPiAtDQo+ICA+IC0gICAgICAgICAg
ICBRTElTVF9SRU1PVkUoY3B1LCBub2RlKTsNCj4gID4gLSAgICAgICAgICAgIGt2bV9mZCA9IGNw
dS0+a3ZtX2ZkOw0KPiAgPiAtICAgICAgICAgICAgZ19mcmVlKGNwdSk7DQo+ICA+IC0gICAgICAg
ICAgICByZXR1cm4ga3ZtX2ZkOw0KPiAgDQo+ICBJbiB0aGlzIG9sZCBwaWVjZSBvZiBjb2RlIHdl
IHdlcmUgT0sgdXNpbmcgUUxJU1RfRk9SRUFDSCBiZWNhdXNlIHdlDQo+ICByZXR1cm5lZCBpbW1l
ZGlhdGVseSB3ZSB0b29rIHRoZSBub2RlIG9mZiB0aGUgbGlzdCBhbmQgZGlkbid0IGNvbnRpbnVl
IHRoZQ0KPiAgaXRlcmF0aW9uLg0KDQpBZ3JlZWQuDQoNCj4gIA0KPiAgPiAtICAgICAgICB9DQo+
ICA+IC0gICAgfQ0KPiAgPiAtDQo+ICA+IC0gICAgcmV0dXJuIGt2bV92bV9pb2N0bChzLCBLVk1f
Q1JFQVRFX1ZDUFUsICh2b2lkICopdmNwdV9pZCk7DQo+ICA+IC19DQo+ICANCj4gIHRoYW5rcw0K
PiAgLS0gUE1NDQo=

