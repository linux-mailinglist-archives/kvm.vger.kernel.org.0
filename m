Return-Path: <kvm+bounces-4157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 917E680E6A6
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 09:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 077C1B21087
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 08:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3659F39AD5;
	Tue, 12 Dec 2023 08:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ITCrqBsJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAB1AC;
	Tue, 12 Dec 2023 00:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1702371056; x=1733907056;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=kbYhK6bcNLvWaLADIREECSkT5n5R6xh4aWNtaq66HUw=;
  b=ITCrqBsJOIWxjJNAtFPASVzbKKGtGSU2r5O63HPJBsOcQq5Wov+VUdUi
   kPzWkci2+HeV2lFojjMCq527I6ul226G4Upmx0OMBpt3ADt9Prj6MmC72
   8sTbCPTXLN2rxaWvjzSbDWgyCAIHWur7n8larmFb4wxvorpTpmQHlzYMj
   0=;
X-IronPort-AV: E=Sophos;i="6.04,269,1695686400"; 
   d="scan'208";a="258431658"
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook
 restart/shutdown
Thread-Topic: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to hook
 restart/shutdown
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 08:50:52 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1a-m6i4x-96feee09.us-east-1.amazon.com (Postfix) with ESMTPS id 3BEDC497EE;
	Tue, 12 Dec 2023 08:50:47 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:27324]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.100:2525] with esmtp (Farcaster)
 id fe0bb469-decf-4e0f-878d-e52a4e884b55; Tue, 12 Dec 2023 08:50:46 +0000 (UTC)
X-Farcaster-Flow-ID: fe0bb469-decf-4e0f-878d-e52a4e884b55
Received: from EX19D012EUC003.ant.amazon.com (10.252.51.208) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 12 Dec 2023 08:50:40 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D012EUC003.ant.amazon.com (10.252.51.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Tue, 12 Dec 2023 08:50:40 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1118.040; Tue, 12 Dec 2023 08:50:40 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "Graf (AWS), Alexander" <graf@amazon.de>, "seanjc@google.com"
	<seanjc@google.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>,
	=?utf-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "james.morse@arm.com" <james.morse@arm.com>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"atishp@atishpatra.org" <atishp@atishpatra.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
	"anup@brainfault.org" <anup@brainfault.org>
Thread-Index: AQHaKm9F6TfLvhzSVEeLxKjiUjwNTrCgjTCAgAFn6T+AAcSbgIAAKp8AgADgykyAAJaPgA==
Date: Tue, 12 Dec 2023 08:50:40 +0000
Message-ID: <cf9e15bf3da411ada1c5b2bbdbfdea836029a5e1.camel@amazon.com>
References: <20230512233127.804012-1-seanjc@google.com>
	 <20230512233127.804012-2-seanjc@google.com>
	 <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
	 <871qbud5f9.fsf@email.froward.int.ebiederm.org>
	 <a02b40d3d9ae5b3037b9a9d5921cfb0144ab5610.camel@amazon.com>
	 <7e30cfc2359dfef39d038e3734f7e5e3d9e82d68.camel@amazon.com>
	 <87wmtk9u46.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <87wmtk9u46.fsf@email.froward.int.ebiederm.org>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <76D26AF16DA5D4499D562F4A2CD6FDBF@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDIzLTEyLTExIGF0IDE3OjUwIC0wNjAwLCBFcmljIFcuIEJpZWRlcm1hbiB3cm90
ZToNCj4gIkdvd2FucywgSmFtZXMiIDxqZ293YW5zQGFtYXpvbi5jb20+IHdyaXRlczoNCj4gDQo+
ID4gT24gTW9uLCAyMDIzLTEyLTExIGF0IDA5OjU0ICswMjAwLCBKYW1lcyBHb3dhbnMgd3JvdGU6
DQo+ID4gPiA+IA0KPiA+ID4gPiBXaGF0IHByb2JsZW0gYXJlIHlvdSBydW5uaW5nIGludG8gd2l0
aCB5b3VyIHJlYmFzZSB0aGF0IHdvcmtlZCB3aXRoDQo+ID4gPiA+IHJlYm9vdCBub3RpZmllcnMg
dGhhdCBpcyBub3Qgd29ya2luZyB3aXRoIHN5c2NvcmVfc2h1dGRvd24/DQo+ID4gPiANCj4gPiA+
IFByaW9yIHRvIHRoaXMgY29tbWl0IFsxXSB3aGljaCBjaGFuZ2VkIEtWTSBmcm9tIHJlYm9vdCBu
b3RpZmllcnMgdG8NCj4gPiA+IHN5c2NvcmVfb3BzLCBLVk0ncyByZWJvb3Qgbm90aWZpZXIgc2h1
dGRvd24gY2FsbGJhY2sgd2FzIGludm9rZWQgb24NCj4gPiA+IGtleGVjIHZpYSBrZXJuZWxfcmVz
dGFydF9wcmVwYXJlLg0KPiA+ID4gDQo+ID4gPiBBZnRlciB0aGlzIGNvbW1pdCwgS1ZNIGlzIG5v
dCBiZWluZyBzaHV0IGRvd24gYmVjYXVzZSBjdXJyZW50bHkgdGhlDQo+ID4gPiBrZXhlYyBmbG93
IGRvZXMgbm90IGNhbGwgc3lzY29yZV9zaHV0ZG93bi4NCj4gPiANCj4gPiBJIHRoaW5rIEkgbWlz
c2VkIHdoYXQgeW91J3JlIGFza2luZyBoZXJlOyB5b3UncmUgYXNraW5nIGZvciBhIHJlcHJvZHVj
ZXINCj4gPiBmb3IgdGhlIHNwZWNpZmljIGZhaWx1cmU/DQo+ID4gDQo+ID4gMS4gTGF1bmNoIGEg
UUVNVSBWTSB3aXRoIC1lbmFibGUta3ZtIGZsYWcNCj4gPiANCj4gPiAyLiBEbyBhbiBpbW1lZGlh
dGUgKC1mIGZsYWcpIGtleGVjOg0KPiA+IGtleGVjIC1mIC0tcmV1c2UtY21kbGluZSAuL2J6SW1h
Z2UNCj4gPiANCj4gPiBTb21ld2hlcmUgYWZ0ZXIgZG9pbmcgdGhlIFJFVCB0byBuZXcga2VybmVs
IGluIHRoZSByZWxvY2F0ZV9rZXJuZWwgYXNtDQo+ID4gZnVuY3Rpb24gdGhlIG5ldyBrZXJuZWwg
c3RhcnRzIHRyaXBsZSBmYXVsdGluZzsgSSBjYW4ndCBleGFjdGx5IGZpZ3VyZQ0KPiA+IG91dCB3
aGVyZSBidXQgSSB0aGluayBpdCBoYXMgdG8gZG8gd2l0aCB0aGUgbmV3IGtlcm5lbCB0cnlpbmcg
dG8gbW9kaWZ5DQo+ID4gQ1IzIHdoaWxlIHRoZSBWTVhFIGJpdCBpcyBzdGlsbCBzZXQgaW4gQ1I0
IGNhdXNpbmcgdGhlIHRyaXBsZSBmYXVsdC4NCj4gPiANCj4gPiBJZiBLVk0gaGFzIGJlZW4gc2h1
dCBkb3duIHZpYSB0aGUgc2h1dGRvd24gY2FsbGJhY2ssIG9yIGFsdGVybmF0aXZlbHkgaWYNCj4g
PiB0aGUgUUVNVSBwcm9jZXNzIGhhcyBhY3R1YWxseSBiZWVuIGtpbGxlZCBmaXJzdCAoYnkgbm90
IGRvaW5nIGEgLWYgZXhlYykNCj4gPiB0aGVuIHRoZSBWTVhFIGJpdCBpcyBjbGVhciBhbmQgdGhl
IGtleGVjIGdvZXMgc21vb3RobHkuDQo+ID4gDQo+ID4gU28sIFRMO0RSOiBrZXhlYyAtZiB1c2Ug
dG8gd29yayB3aXRoIGEgS1ZNIFZNIGFjdGl2ZSwgbm93IGl0IGdvZXMgaW50byBhDQo+ID4gdHJp
cGxlIGZhdWx0IGNyYXNoLg0KPiANCj4gWW91IG1lbnRpb25lZCBJIHJlYmFzZSBzbyBJIHRob3Vn
aHQgeW91ciB3ZXJlIGJhY2twb3J0aW5nIGtlcm5lbCBwYXRjaGVzLg0KPiBCeSByZWJhc2UgZG8g
eW91IG1lYW4geW91IHBvcnRpbmcgeW91ciB1c2Vyc3BhY2UgdG8gYSBuZXdlciBrZXJuZWw/DQoN
CkkndmUgYmVlbiB3b3JraW5nIG9uIHNvbWUgcGF0Y2hlcyBhbmQgd2hlbiBJIHJlYmFzZWQgbXkg
d29yay1pbi1wcm9ncmVzcw0KcGF0Y2hlcyB0byBsYXRlc3QgbWFzdGVyIHRoZW4ga2V4ZWMgc3Rv
cHBlZCB3b3JraW5nIHdoZW4gS1ZNIFZNcyBleGlzdC4NCk9yaWdpbmFsbHkgdGhlIFdJUCBwYXRj
aGVzIHdlcmUgYmFzZWQgb24gYW4gb2xkZXIgc3RhYmxlIHZlcnNpb24uDQoNCj4gDQo+IEluIGFu
eSBldmVudCBJIGJlbGlldmUgdGhlIGJ1ZyB3aXRoIHJlc3BlY3QgdG8ga2V4ZWMgd2FzIGludHJv
ZHVjZWQgaW4NCj4gY29tbWl0IDZmMzg5YThmMWRkMiAoIlBNIC8gcmVib290OiBjYWxsIHN5c2Nv
cmVfc2h1dGRvd24oKSBhZnRlcg0KPiBkaXNhYmxlX25vbmJvb3RfY3B1cygpIikuICBUaGF0IGlz
IHdoZXJlIHN5c2NvcmVfc2h1dGRvd24gd2FzIHJlbW92ZWQNCj4gZnJvbSBrZXJuZWxfcmVzdGFy
dF9wcmVwYXJlKCkuDQo+IA0KPiBBdCB0aGlzIHBvaW50IGl0IGxvb2tzIGxpa2Ugc29tZW9uZSBq
dXN0IG5lZWRzIHRvIGFkZCB0aGUgbWlzc2luZw0KPiBzeXNjb3JlX3NodXRkb3duIGNhbGwgaW50
byBrZXJuZWxfa2V4ZWMoKSByaWdodCBhZnRlcg0KPiBtaWdyYXRlX3RvX3JlYm9vdF9jcHUoKSBp
cyBjYWxsZWQuDQoNClNlZW1zIGdvb2QgYW5kIEknbSBoYXBweSB0byBkbyB0aGF0OyBvbmUgdGhp
bmcgd2UgbmVlZCB0byBjaGVjayBmaXJzdDoNCmFyZSBhbGwgQ1BVcyBvbmxpbmUgYXQgdGhhdCBw
b2ludD8gVGhlIGNvbW1pdCBtZXNzYWdlIGZvcg0KNmYzODlhOGYxZGQyICgiUE0gLyByZWJvb3Q6
IGNhbGwgc3lzY29yZV9zaHV0ZG93bigpIGFmdGVyIGRpc2FibGVfbm9uYm9vdF9jcHVzKCkiKQ0K
c3BlYWtzIGFib3V0OiAib25lIENQVSBvbi1saW5lIGFuZCBpbnRlcnJ1cHRzIGRpc2FibGVkIiB3
aGVuDQpzeXNjb3JlX3NodXRkb3duIGlzIGNhbGxlZC4gS1ZNJ3Mgc3lzY29yZSBzaHV0ZG93biBo
b29rIGRvZXM6DQoNCm9uX2VhY2hfY3B1KGhhcmR3YXJlX2Rpc2FibGVfbm9sb2NrLCBOVUxMLCAx
KTsNCg0KLi4uIHNvIHRoYXQgc21lbGxzIHRvIG1lIGxpa2UgaXQgd2FudHMgYWxsIHRoZSBDUFVz
IHRvIGJlIG9ubGluZSBhdA0Ka3ZtX3NodXRkb3duIHBvaW50Lg0KDQpJdCdzIG5vdCBjbGVhciB0
byBtZToNCg0KMS4gRG9lcyBoYXJkd2FyZV9kaXNhYmxlX25vbG9jayBhY3R1YWxseSBuZWVkIHRv
IGJlIGRvbmUgb24gKmV2ZXJ5KiBDUFUNCm9yIHdvdWxkIHRoZSBvZmZsaW5lZCBvbmVzIGJlIGZp
bmUgdG8gaWdub3JlIGJlY2F1c2UgdGhleSB3aWxsIGJlIHJlc2V0DQphbmQgdGhlIFZNWEUgYml0
IHdpbGwgYmUgY2xlYXJlZCB0aGF0IHdheT8gV2l0aCBjb29wZXJhdGl2ZSBDUFUgaGFuZG92ZXIN
CndlIHByb2JhYmx5IGRvIGluZGVlZCB3YW50IHRvIGRvIHRoaXMgb24gZXZlcnkgQ1BVIGFuZCBu
b3QgZGVwZW5kIG9uDQpyZXNldHRpbmcuDQoNCjIuIEFyZSBDUFVzIGFjdHVhbGx5IG9mZmxpbmUg
YXQgdGhpcyBwb2ludD8gV2hlbiB0aGF0IGNvbW1pdCB3YXMNCmF1dGhvcmVkIHRoZXJlIHVzZWQg
dG8gYmUgYSBjYWxsIHRvIGhhcmR3YXJlX2Rpc2FibGVfbm9sb2NrKCkgYnV0IHRoYXQncw0Kbm90
IHRoZXJlIGFueW1vcmUuDQoNCj4gDQo+IFRoYXQgc2FpZCBJIGFtIG5vdCBzZWVpbmcgdGhlIHJl
Ym9vdCBub3RpZmllcnMgYmVpbmcgY2FsbGVkIG9uIHRoZSBrZXhlYw0KPiBwYXRoIGVpdGhlciBz
byB5b3VyIGlzc3VlIHdpdGgga3ZtIG1pZ2h0IGJlIGRlZXBlci4NCg0KUHJldmlvdXNseSBpdCB3
YXMgY2FsbGVkIHZpYToNCg0Ka2VybmVsX2tleGVjDQogIGtlcm5lbF9yZXN0YXJ0X3ByZXBhcmUN
CiAgICBibG9ja2luZ19ub3RpZmllcl9jYWxsX2NoYWluKCZyZWJvb3Rfbm90aWZpZXJfbGlzdCwg
U1lTX1JFU1RBUlQsIGNtZCk7DQogICAgICBrdm1fc2h1dGRvd24NCg0KSkcNCg==

