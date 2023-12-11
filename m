Return-Path: <kvm+bounces-4024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C5B80C26B
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 08:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02E1EB208FB
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 07:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76EE20B0A;
	Mon, 11 Dec 2023 07:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="LVpNoLrV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A001CD;
	Sun, 10 Dec 2023 23:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1702281296; x=1733817296;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=r73lI5nXluUvYNLiP+U10mmGdgAqNSuQ7rSnDd3RcJk=;
  b=LVpNoLrVG+1GqbNFrh483O9bMSJInVxUEym7p7vFjr87wUfCZzRL4fUR
   RI+sfU7s8vC56Ddr0THo7AXp24HxpbVH7rFU1CBQNNfjy3byOwOvT6V/V
   emAJTuN4Id622TkFtFjZmfqIG/UrsSjOZRjuVy06nZ6eC0a4tS4YvIELK
   A=;
X-IronPort-AV: E=Sophos;i="6.04,267,1695686400"; 
   d="scan'208";a="624436526"
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook
 restart/shutdown
Thread-Topic: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook
 restart/shutdown
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 07:54:54 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 10901AAAFC;
	Mon, 11 Dec 2023 07:54:49 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:25155]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.40.11:2525] with esmtp (Farcaster)
 id 93b94b21-a815-4010-9fac-0e3e3813c799; Mon, 11 Dec 2023 07:54:47 +0000 (UTC)
X-Farcaster-Flow-ID: 93b94b21-a815-4010-9fac-0e3e3813c799
Received: from EX19D012EUC004.ant.amazon.com (10.252.51.220) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 11 Dec 2023 07:54:43 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D012EUC004.ant.amazon.com (10.252.51.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 11 Dec 2023 07:54:42 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1118.040; Mon, 11 Dec 2023 07:54:42 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "Graf (AWS), Alexander" <graf@amazon.de>, "seanjc@google.com"
	<seanjc@google.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
	=?utf-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "atishp@atishpatra.org"
	<atishp@atishpatra.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"anup@brainfault.org" <anup@brainfault.org>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>
Thread-Index: AQHaKm9F6TfLvhzSVEeLxKjiUjwNTrCgjTCAgAFn6T+AAcSbgA==
Date: Mon, 11 Dec 2023 07:54:42 +0000
Message-ID: <a02b40d3d9ae5b3037b9a9d5921cfb0144ab5610.camel@amazon.com>
References: <20230512233127.804012-1-seanjc@google.com>
	 <20230512233127.804012-2-seanjc@google.com>
	 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
	 <871qbud5f9.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <871qbud5f9.fsf@email.froward.int.ebiederm.org>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <F320358D0A3B8147A9D633C6C3B3AEF4@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gU2F0LCAyMDIzLTEyLTA5IGF0IDIyOjUzIC0wNjAwLCBFcmljIFcuIEJpZWRlcm1hbiB3cm90
ZToNCj4gPiBPbiBGcmksIDIwMjMtMDUtMTIgYXQgMTY6MzEgLTA3MDAsIFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gd3JvdGU6DQo+ID4gPiBVc2Ugc3lzY29yZV9vcHMuc2h1dGRvd24gdG8gZGlzYWJsZSBo
YXJkd2FyZSB2aXJ0dWFsaXphdGlvbiBkdXJpbmcgYQ0KPiA+ID4gcmVib290IGluc3RlYWQgb2Yg
dXNpbmcgdGhlIGRlZGljYXRlZCByZWJvb3Rfbm90aWZpZXIgc28gdGhhdCBLVk0gZGlzYWJsZXMN
Cj4gPiA+IHZpcnR1YWxpemF0aW9uIF9hZnRlcl8gc3lzdGVtX3N0YXRlIGhhcyBiZWVuIHVwZGF0
ZWQuwqAgVGhpcyB3aWxsIGFsbG93DQo+ID4gPiBmaXhpbmcgYSByYWNlIGluIEtWTSdzIGhhbmRs
aW5nIG9mIGEgZm9yY2VkIHJlYm9vdCB3aGVyZSBLVk0gY2FuIGVuZCB1cA0KPiA+ID4gZW5hYmxp
bmcgaGFyZHdhcmUgdmlydHVhbGl6YXRpb24gYmV0d2VlbiBrZXJuZWxfcmVzdGFydF9wcmVwYXJl
KCkgYW5kDQo+ID4gPiBtYWNoaW5lX3Jlc3RhcnQoKS4NCj4gPiANCj4gPiBUaGUgaXNzdWUgaXMg
dGhhdCwgQUZBSUNULCB0aGUgc3lzY29yZV9vcHMuc2h1dGRvd24gYXJlIG5vdCBjYWxsZWQgd2hl
bg0KPiA+IGRvaW5nIGEga2V4ZWMuIFJlYm9vdCBub3RpZmllcnMgYXJlIGNhbGxlZCBhY3Jvc3Mg
a2V4ZWMgdmlhOg0KPiA+IA0KPiA+IGtlcm5lbF9rZXhlYw0KPiA+IMKgwqAga2VybmVsX3Jlc3Rh
cnRfcHJlcGFyZQ0KPiA+IMKgwqDCoMKgIGJsb2NraW5nX25vdGlmaWVyX2NhbGxfY2hhaW4NCj4g
PiDCoMKgwqDCoMKgwqAga3ZtX3JlYm9vdA0KPiA+IA0KPiA+IFNvIGFmdGVyIHRoaXMgcGF0Y2gs
IEtWTSBpcyBub3Qgc2h1dGRvd24gZHVyaW5nIGtleGVjOyBpZiBoYXJkd2FyZSB2aXJ0DQo+ID4g
bW9kZSBpcyBlbmFibGVkIHRoZW4gdGhlIGtleGVjIGhhbmdzIGluIGV4YWN0bHkgdGhlIHNhbWUg
bWFubmVyIGFzIHlvdQ0KPiA+IGRlc2NyaWJlIHdpdGggdGhlIHJlYm9vdC4NCj4gDQo+IGtlcm5l
bF9yZXN0YXJ0X3ByZXBhcmUgY2FsbHMgZGV2aWNlX3NodXRkb3duLsKgIFdoaWNoIHNob3VsZCBj
YWxsIGFsbA0KPiBvZiB0aGUgc2h1dGRvd24gb3BlcmF0aW9ucy7CoCBUaGlzIGhhcyBiZWVuIHRo
ZSB3YXkgdGhlIGNvZGUgaGFzIGJlZW4NCj4gc3RydWN0dXJlZCBzaW5jZSBEZWNlbWJlciAyMDA1
Lg0KDQpZZXMsIGtlcm5lbF9yZXNldF9wcmVwYXJlIGNhbGxzIGRldmljZV9zaHV0ZG93biB3aGlj
aCBjYWxscw0KZGV2LT5kcml2ZXItPnNodXRkb3duIGZvciBlYWNoIGRldiB3aGljaCBoYXMgYSBk
cml2ZXIuIEtWTSwgaG93ZXZlciwgaXMNCm5vdCBhIGRldiB3aXRoIGEgZHJpdmVyLCBoZW5jZSBk
b2Vzbid0IGhhdmUgYSBkZXYtPmRyaXZlci0+c2h1dGRvd24NCmNhbGxiYWNrLiBTbyBLVk0gaXMg
bm8tb3AnZWQgaW4gZGV2aWNlX3NodXRkb3duLg0KDQpLVk0gYWRkcyBpdHMgc2h1dGRvd24gY2Fs
bGJhY2sgdG8gc3lzY29yZV9vcHMgYW5kIGV4cGVjdHMgdG8gYmUgc2h1dA0KZG93biB0aGF0IHdh
eS4NCg0KPiANCj4gPiBTb21lIHNwZWNpZmljIHNodXRkb3duIGNhbGxiYWNrcywgZm9yIGV4YW1w
bGUgSU9NTVUsIEhQRVQsIElSUSwgZXRjIGFyZQ0KPiA+IGNhbGxlZCBpbiBuYXRpdmVfbWFjaGlu
ZV9zaHV0ZG93biwgYnV0IEtWTSBpcyBub3Qgb25lIG9mIHRoZXNlLg0KPiA+IA0KPiA+IFRob3Vn
aHRzIG9uIHBvc3NpYmxlIHdheXMgdG8gZml4IHRoaXM6DQo+ID4gYSkgZ28gYmFjayB0byByZWJv
b3Qgbm90aWZpZXJzDQo+ID4gYikgZ2V0IGtleGVjIHRvIGNhbGwgc3lzY29yZV9zaHV0ZG93bigp
IHRvIGludm9rZSBhbGwgb2YgdGhlc2UgY2FsbGJhY2tzDQo+ID4gYykgQWRkIGEgS1ZNLXNwZWNp
ZmljIGNhbGxiYWNrIHRvIG5hdGl2ZV9tYWNoaW5lX3NodXRkb3duKCk7IHdlIG9ubHkNCj4gPiBu
ZWVkIHRoaXMgZm9yIEludGVsIHg4NiwgcmlnaHQ/DQo+ID4gDQo+ID4gTXkgc2xpZ2h0IHByZWZl
cmVuY2UgaXMgdG93YXJkcyBhZGRpbmcgc3lzY29yZV9zaHV0ZG93bigpIHRvIGtleGVjLCBidXQN
Cj4gPiBJJ20gbm90IHN1cmUgdGhhdCdzIGZlYXNpYmxlLiBBZGRpbmcga2V4ZWMgbWFpbnRhaW5l
cnMgZm9yIGlucHV0Lg0KPiANCj4gV2h5IGlzbid0IGRldmljZV9zdXRoZG93biBjYWxsaW5nIHN5
c2NvcmVfc2h1dGRvd24/DQoNCkknbSBub3Qgc3VyZSAtIHRoYXQgd291bGQgaW5kZWVkIGJlIG9u
ZSB3YXkgdG8gZml4OyBhZGRpbmcgYSBjYWxsIHRvDQpzeXNjb3JlX3NodXRkb3duKCkgaW5zaWRl
IGRldmljZV9zaHV0ZG93bi4gV2UgbWF5IG5lZWQgdG8gY2xlYW4gdXAgb3RoZXINCmNhbGxlcnMg
dG8gbm90IGRvIHRoZWlyIG93biBzeXNjb3JlX3NodXRkb3duIGFuZCByYXRoZXIgZGVwZW5kIG9u
DQpkZXZpY2Vfc2h1dGRvd24gdG8gZG8gaXQgYWxsLg0KDQpXb3VsZCB5b3Ugc3VwcG9ydCBhZGRp
bmcgc3lzY29yZV9zaHV0ZG93bigpIHRvIGRldmljZV9zaHV0ZG93bigpPw0KDQo+IA0KPiBXaGF0
IHByb2JsZW0gYXJlIHlvdSBydW5uaW5nIGludG8gd2l0aCB5b3VyIHJlYmFzZSB0aGF0IHdvcmtl
ZCB3aXRoDQo+IHJlYm9vdCBub3RpZmllcnMgdGhhdCBpcyBub3Qgd29ya2luZyB3aXRoIHN5c2Nv
cmVfc2h1dGRvd24/DQoNClByaW9yIHRvIHRoaXMgY29tbWl0IFsxXSB3aGljaCBjaGFuZ2VkIEtW
TSBmcm9tIHJlYm9vdCBub3RpZmllcnMgdG8NCnN5c2NvcmVfb3BzLCBLVk0ncyByZWJvb3Qgbm90
aWZpZXIgc2h1dGRvd24gY2FsbGJhY2sgd2FzIGludm9rZWQgb24NCmtleGVjIHZpYSBrZXJuZWxf
cmVzdGFydF9wcmVwYXJlLg0KDQpBZnRlciB0aGlzIGNvbW1pdCwgS1ZNIGlzIG5vdCBiZWluZyBz
aHV0IGRvd24gYmVjYXVzZSBjdXJyZW50bHkgdGhlDQprZXhlYyBmbG93IGRvZXMgbm90IGNhbGwg
c3lzY29yZV9zaHV0ZG93bi4NCg0KSkcNCg0KDQpbMV0gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZh
bGRzL2xpbnV4L2NvbW1pdC82NzM1MTUwYjY5OTcNCg==

