Return-Path: <kvm+bounces-4093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B727080D8B2
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 19:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E6881F21B5B
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCAD51C3D;
	Mon, 11 Dec 2023 18:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Qj6AHJni"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64ECD6;
	Mon, 11 Dec 2023 10:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1702320478; x=1733856478;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=BBxHyiZZ7qd6t/Hnqi40UYRvuKrVu6V0t98axO4RwLo=;
  b=Qj6AHJniTYeDWDCoAIV/ZuXXwAIfeFQbUqfciMTqiytO3/8jXD0qoakK
   Ai2NNXYhqUf9wmXCpW7pKi/dNJPw/pfnE26XjxWlVVM92UvHQCpJg6IyD
   R2TQYrSg48drXel8wE7BLcd2WHndnH27nM5wADo6jmUhOlVIfcXKiXQMu
   M=;
X-IronPort-AV: E=Sophos;i="6.04,268,1695686400"; 
   d="scan'208";a="599945077"
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook
 restart/shutdown
Thread-Topic: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook
 restart/shutdown
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 18:47:54 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id EBACF40D7D;
	Mon, 11 Dec 2023 18:47:52 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:54605]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.36.52:2525] with esmtp (Farcaster)
 id 8884d293-f880-40f3-a23f-45b255ccad1a; Mon, 11 Dec 2023 18:47:52 +0000 (UTC)
X-Farcaster-Flow-ID: 8884d293-f880-40f3-a23f-45b255ccad1a
Received: from EX19D012EUC004.ant.amazon.com (10.252.51.220) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 11 Dec 2023 18:47:51 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D012EUC004.ant.amazon.com (10.252.51.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 11 Dec 2023 18:47:51 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1118.040; Mon, 11 Dec 2023 18:47:50 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Graf (AWS), Alexander"
	<graf@amazon.de>, "seanjc@google.com" <seanjc@google.com>,
	=?utf-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>,
	"ebiederm@xmission.com" <ebiederm@xmission.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>,
	"james.morse@arm.com" <james.morse@arm.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "atishp@atishpatra.org"
	<atishp@atishpatra.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "maz@kernel.org" <maz@kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "aleksandar.qemu.devel@gmail.com"
	<aleksandar.qemu.devel@gmail.com>, "anup@brainfault.org"
	<anup@brainfault.org>
Thread-Index: AQHaKm9F6TfLvhzSVEeLxKjiUjwNTrCgjTCAgAPOgQCAABR9AA==
Date: Mon, 11 Dec 2023 18:47:50 +0000
Message-ID: <55ef5cbf44bb73030d6387aa181393b8cb044f77.camel@amazon.com>
References: <20230512233127.804012-1-seanjc@google.com>
	 <20230512233127.804012-2-seanjc@google.com>
	 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
	 <ZXdIIBUXcCIK28ys@google.com>
In-Reply-To: <ZXdIIBUXcCIK28ys@google.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <44768D8B1F7ED64C87222E7575E03BDD@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDIzLTEyLTExIGF0IDA5OjM0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBTYXQsIERlYyAwOSwgMjAyMywgSmFtZXMgR293YW5zIHdyb3RlOg0KPiA+IFRo
b3VnaHRzIG9uIHBvc3NpYmxlIHdheXMgdG8gZml4IHRoaXM6DQo+ID4gYSkgZ28gYmFjayB0byBy
ZWJvb3Qgbm90aWZpZXJzDQo+ID4gYikgZ2V0IGtleGVjIHRvIGNhbGwgc3lzY29yZV9zaHV0ZG93
bigpIHRvIGludm9rZSBhbGwgb2YgdGhlc2UgY2FsbGJhY2tzDQo+ID4gYykgQWRkIGEgS1ZNLXNw
ZWNpZmljIGNhbGxiYWNrIHRvIG5hdGl2ZV9tYWNoaW5lX3NodXRkb3duKCk7IHdlIG9ubHkNCj4g
PiBuZWVkIHRoaXMgZm9yIEludGVsIHg4NiwgcmlnaHQ/DQo+IA0KPiBJIGRvbid0IGxpa2UgKGMp
LiAgVk1YIGlzIHRoZSBtb3N0IHNlbnNpdGl2ZS9wcm9ibGVtYXRpYywgZS5nLiB0aGUgd2hvbGUg
YmxvY2tpbmcNCj4gb2YgSU5JVCB0aGluZywgYnV0IFNWTSBjYW4gYWxzbyBydW4gYWZvdWwgb2Yg
RUZFUi5TVk1FIGJlaW5nIGNsZWFyZWQsIGFuZCBLVk0gcmVhbGx5DQo+IHNob3VsZCBsZWF2ZSB2
aXJ0dWFsaXphdGlvbiBlbmFibGVkIGFjcm9zcyBrZXhlYygpLCBldmVuIGlmIGxlYXZpbmcgdmly
dHVhbGl6YXRpb24NCj4gZW5hYmxlZCBpcyByZWxhdGl2ZWx5IGJlbmlnbiBvbiBvdGhlciBhcmNo
aXRlY3R1cmVzLg0KDQpHb29kIHRvIGtub3cuIEFncmVlZCB0aGF0IGNsZWFuIHNodXRkb3duIGlu
IGFsbCBjYXNlcyBpcyBiZXN0IGFuZCB3ZQ0KZGlzY2FyZCAoYykuDQo+IA0KPiBPbmUgbW9yZSBv
cHRpb24gd291bGQgYmU6DQo+IA0KPiAgZCkgQWRkIGFub3RoZXIgc3ljb3JlIGhvb2ssIGUuZy4g
c3lzY29yZV9rZXhlYygpIHNwZWNpZmljYWxseSBmb3IgdGhpcyBwYXRoLg0KPiANCj4gPiBNeSBz
bGlnaHQgcHJlZmVyZW5jZSBpcyB0b3dhcmRzIGFkZGluZyBzeXNjb3JlX3NodXRkb3duKCkgdG8g
a2V4ZWMsIGJ1dA0KPiA+IEknbSBub3Qgc3VyZSB0aGF0J3MgZmVhc2libGUuIEFkZGluZyBrZXhl
YyBtYWludGFpbmVycyBmb3IgaW5wdXQuDQo+IA0KPiBJbiBhIHZhY3V1bSwgdGhhdCdkIGJlIG15
IHByZWZlcmVuY2UgdG9vLiAgSXQncyB0aGUgb2J2aW91cyBjaG9pY2UgSU1PLCBlLmcuIHRoZQ0K
PiBrZXhlY19pbWFnZS0+cHJlc2VydmVfY29udGV4dCBwYXRoIGRvZXMgc3lzY29yZV9zdXNwZW5k
KCkgKGFuZCB0aGVuIHJlc3VtZSgpLCBzbw0KPiBpdCdzIG5vdCBjb21wbGV0ZWx5IHVuY2hhcnRl
ZCB0ZXJyaXRvcnkuDQo+IA0KPiBIb3dldmVyLCB0aGVyZSdzIGEgcmF0aGVyIGJpZyB3cmlua2xl
IGluIHRoYXQgbm90IGFsbCBvZiB0aGUgZXhpc3RpbmcgLnNodXRkb3duKCkNCj4gaW1wbGVtZW50
YXRpb25zIGFyZSBvYnZpb3VzbHkgb2sgdG8gY2FsbCBkdXJpbmcga2V4ZWMuICBMdWNraWx5LCBB
RkFJQ1QgdGhlcmUgYXJlDQo+IHZlcnkgZmV3IHVzZXJzIG9mIHRoZSBzeXNjb3JlIC5zaHV0ZG93
biBob29rLCBzbyBpdCdzIGF0IGxlYXN0IGZlYXNpYmxlIHRvIGdvIHRoYXQNCj4gcm91dGUuDQo+
IA0KPiB4ODYncyBtY2Vfc3lzY29yZV9zaHV0ZG93bigpIHNob3VsZCBiZSBvaywgYW5kIGFyZ3Vh
Ymx5IGlzIGNvcnJlY3QsIGUuZy4gSSBkb24ndA0KPiBzZWUgaG93IGxlYXZpbmcgI01DIHJlcG9y
dGluZyBlbmFibGVkIGFjcm9zcyBrZXhlYyBjYW4gd29yay4NCj4gDQo+IGxlZHRyaWdfY3B1X3N5
c2NvcmVfc2h1dGRvd24oKSBpcyBhbHNvIGxpa2VseSBvayBhbmQgYXJndWFibHkgY29ycmVjdC4N
Cg0KSSBsaWtlIHlvdXIgb2JzZXJ2YXRpb24gaGVyZSB0aGF0IHdlIHByb2JhYmx5IGhhdmUgb3Ro
ZXIgbWlzc2VzIGxpa2UgTUNFDQp3aGljaCBzaG91bGQgYmUgc2h1dCBkb3duIHRvbyAtIHRoYXQn
cyBhIGhpbnQgdGhhdCBhZGRpbmcNCnN5c2NvcmVfc2h1dGRvd24oKSB0byBrZXhlYyBpcyB0aGUg
d2F5IHRvIGdvLg0KDQo+IA0KPiBUaGUgaW50ZXJydXB0IGNvbnRyb2xsZXJzIHRob3VnaD8gIHg4
NiBkaXNhYmxlcyBJUlFzIGF0IHRoZSB2ZXJ5IGJlZ2lubmluZyBvZg0KPiBtYWNoaW5lX2tleGVj
KCksIHNvIGl0J3MgbGlrZWx5IGZpbmUuICBCdXQgZXZlcnkgb3RoZXIgYXJjaGl0ZWN0dXJlPyAg
Tm8gY2x1ZS4NCj4gRS5nLiBQUEMncyBkZWZhdWx0X21hY2hpbmVfa2V4ZWMoKSBzZW5kcyBJUElz
IHRvIHNodXRkb3duIG90aGVyIENQVXMsIHRob3VnaCBJDQo+IGhhdmUgbm8gaWRlYSBpZiB0aGF0
IGNhbiBydW4gYWZvdWwgb2YgYW55IG9mIHRoZSBwYXRocyBiZWxvdy4NCj4gDQo+ICAgICAgICAg
YXJjaC9wb3dlcnBjL3BsYXRmb3Jtcy9jZWxsL3NwdV9iYXNlLmMgIC5zaHV0ZG93biA9IHNwdV9z
aHV0ZG93biwNCj4gICAgICAgICBhcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9jb3JlLmMgICAgICAg
ICAgLnNodXRkb3duID0gbWNlX3N5c2NvcmVfc2h1dGRvd24sDQo+ICAgICAgICAgYXJjaC94ODYv
a2VybmVsL2k4MjU5LmMgICAgICAgICAgICAgICAgIC5zaHV0ZG93biA9IGk4MjU5QV9zaHV0ZG93
biwNCj4gICAgICAgICBkcml2ZXJzL2lycWNoaXAvaXJxLWk4MjU5LmMgICAgICAgICAgICAgLnNo
dXRkb3duID0gaTgyNTlBX3NodXRkb3duLA0KPiAgICAgICAgIGRyaXZlcnMvaXJxY2hpcC9pcnEt
c3VuNmktci5jICAgICAgICAgICAuc2h1dGRvd24gPSBzdW42aV9yX2ludGNfc2h1dGRvd24sDQo+
ICAgICAgICAgZHJpdmVycy9sZWRzL3RyaWdnZXIvbGVkdHJpZy1jcHUuYyAgICAgIC5zaHV0ZG93
biA9IGxlZHRyaWdfY3B1X3N5c2NvcmVfc2h1dGRvd24sDQo+ICAgICAgICAgZHJpdmVycy9wb3dl
ci9yZXNldC9zYzI3eHgtcG93ZXJvZmYuYyAgIC5zaHV0ZG93biA9IHNjMjd4eF9wb3dlcm9mZl9z
aHV0ZG93biwNCj4gICAgICAgICBrZXJuZWwvaXJxL2dlbmVyaWMtY2hpcC5jICAgICAgICAgICAg
ICAgLnNodXRkb3duID0gaXJxX2djX3NodXRkb3duLA0KPiAgICAgICAgIHZpcnQva3ZtL2t2bV9t
YWluLmMgICAgICAgICAgICAgICAgICAgICAuc2h1dGRvd24gPSBrdm1fc2h1dGRvd24sDQo+IA0K
PiBUaGUgd2hvbGUgdGhpbmcgaXMgYSBiaXQgb2YgYSBtZXNzLiAgRS5nLiB4ODYgdHJlYXRzIG1h
Y2hpbmVfc2h1dGRvd24oKSBmcm9tDQo+IGtleGVjIHByZXR0eSBtdWNoIHRoZSBzYW1lIGFzIHNo
dXRkb3duIGZvciByZWJvb3QsIGJ1dCBvdGhlciBhcmNoaXRlY3R1cmVzIGhhdmUNCj4gd2hhdCBh
cHBlYXIgdG8gYmUgdW5pcXVlIHBhdGhzIGZvciBoYW5kbGluZyBrZXhlYy4NCj4gDQo+IEZXSVcs
IGlmIHdlIHdhbnQgdG8gZ28gd2l0aCBvcHRpb24gKGIpLCBzeXNjb3JlX3NodXRkb3duKCkgaG9v
a3MgY291bGQgdXNlDQo+IGtleGVjX2luX3Byb2dyZXNzIHRvIGRpZmZlcmVudGlhdGUgYmV0d2Vl
biAicmVndWxhciIgc2h1dGRvd24vcmVib290IGFuZCBrZXhlYy4NCg0KWWVhaCwgcGVyaGFwcyB0
aGF0J3MgdGhlIGJlc3Q6IGFkZCBzeXNjb3JlX3NodXRkb3duIHRvIGtleGVjIGFuZCBnZXQgdGhl
DQpjYWxsZXJzIHRvIGhhbmRsZSBib3RoIGNhc2VzIGlmIG5lY2Vzc2FyeS4gV2UgY291bGQgZ2V0
IG1haW50YWluZXJzIGZvcg0KYWxsIG9mIHRoZXNlIGRyaXZlcnMgdG8gc2lnbiBvZmYgb24gdGhl
IGNoYW5nZSBhbmQgc2F5IHdoZXRoZXIgdGhleSBuZWVkDQp0byBkaWZmZXJlbnRpYXRlIGJldHdl
ZW4ga2V4ZWMgYW5kIHJlYm9vdC4NCg0KRXJpYywgd2hhdCBhcmUgeW91ciB0aG91Z2h0cyBvbiB0
aGlzIGFwcHJvYWNoPyBJIGNhbiB0cnkgdG8gd2hpcCB1cCBhDQpwYXRjaCBmb3IgdGhpcyBhbmQg
YWRkIHRoZSBtYWludGFpbmVycyBmb3IgYWxsIG9mIHRoZSBkcml2ZXJzLg0KDQpKRw0KDQo=

