Return-Path: <kvm+bounces-3983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1863780B2BF
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 08:27:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83CBFB20C96
	for <lists+kvm@lfdr.de>; Sat,  9 Dec 2023 07:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067C02107;
	Sat,  9 Dec 2023 07:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="PIQSUBrt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1528D5B;
	Fri,  8 Dec 2023 23:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1702106811; x=1733642811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4okwfpjiOL9ZonK2dWGC50lt5XsgIOEt8Jz9Lhvjzo4=;
  b=PIQSUBrti7XNdxosdmG+XzBhb0pfM+sUYWjKMzM5Ly2fg1oN3WgMtKYS
   ykv+mcF3w3FD4LSA2mRkAwKA7bzyX/9YX6aPjLlYXJC/v9QsUFOxB8zIy
   bA+Ul9y2JzV0nA+6cH2DrSzLH0sOAWdBHg4CTdr6X3W/zqHgncdwMI2MI
   I=;
X-IronPort-AV: E=Sophos;i="6.04,262,1695686400"; 
   d="scan'208";a="258537457"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2023 07:26:47 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id C784184A4F;
	Sat,  9 Dec 2023 07:26:41 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.17.79:62225]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.20.114:2525] with esmtp (Farcaster)
 id 6f872b6f-41b3-41a6-ab54-db2adfc2df23; Sat, 9 Dec 2023 07:26:40 +0000 (UTC)
X-Farcaster-Flow-ID: 6f872b6f-41b3-41a6-ab54-db2adfc2df23
Received: from EX19D012EUC004.ant.amazon.com (10.252.51.220) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sat, 9 Dec 2023 07:26:37 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D012EUC004.ant.amazon.com (10.252.51.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sat, 9 Dec 2023 07:26:37 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1118.040; Sat, 9 Dec 2023 07:26:37 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Graf (AWS), Alexander"
	<graf@amazon.de>, "seanjc@google.com" <seanjc@google.com>,
	=?utf-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>,
	"ebiederm@xmission.com" <ebiederm@xmission.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "atishp@atishpatra.org"
	<atishp@atishpatra.org>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "james.morse@arm.com" <james.morse@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, "maz@kernel.org"
	<maz@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
	"anup@brainfault.org" <anup@brainfault.org>, "kexec@lists.infradead.org"
	<kexec@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier to
 hook restart/shutdown
Thread-Topic: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier
 to hook restart/shutdown
Thread-Index: AQHaKm9F6TfLvhzSVEeLxKjiUjwNTrCgjTCA
Date: Sat, 9 Dec 2023 07:26:36 +0000
Message-ID: <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
References: <20230512233127.804012-1-seanjc@google.com>
	 <20230512233127.804012-2-seanjc@google.com>
In-Reply-To: <20230512233127.804012-2-seanjc@google.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <A719B06918EA30498C61BE1015DC918C@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGkgU2VhbiwNCg0KQmxhc3QgZnJvbSB0aGUgcGFzdCBidXQgSSd2ZSBqdXN0IGJlZW4gYml0dGVu
IGJ5IHRoaXMgcGF0Y2ggd2hlbg0KcmViYXNpbmcgYWNyb3NzIHY2LjQuDQoNCk9uIEZyaSwgMjAy
My0wNS0xMiBhdCAxNjozMSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gVXNl
IHN5c2NvcmVfb3BzLnNodXRkb3duIHRvIGRpc2FibGUgaGFyZHdhcmUgdmlydHVhbGl6YXRpb24g
ZHVyaW5nIGENCj4gcmVib290IGluc3RlYWQgb2YgdXNpbmcgdGhlIGRlZGljYXRlZCByZWJvb3Rf
bm90aWZpZXIgc28gdGhhdCBLVk0gZGlzYWJsZXMNCj4gdmlydHVhbGl6YXRpb24gX2FmdGVyXyBz
eXN0ZW1fc3RhdGUgaGFzIGJlZW4gdXBkYXRlZC7CoCBUaGlzIHdpbGwgYWxsb3cNCj4gZml4aW5n
IGEgcmFjZSBpbiBLVk0ncyBoYW5kbGluZyBvZiBhIGZvcmNlZCByZWJvb3Qgd2hlcmUgS1ZNIGNh
biBlbmQgdXANCj4gZW5hYmxpbmcgaGFyZHdhcmUgdmlydHVhbGl6YXRpb24gYmV0d2VlbiBrZXJu
ZWxfcmVzdGFydF9wcmVwYXJlKCkgYW5kDQo+IG1hY2hpbmVfcmVzdGFydCgpLg0KDQpUaGUgaXNz
dWUgaXMgdGhhdCwgQUZBSUNULCB0aGUgc3lzY29yZV9vcHMuc2h1dGRvd24gYXJlIG5vdCBjYWxs
ZWQgd2hlbg0KZG9pbmcgYSBrZXhlYy4gUmVib290IG5vdGlmaWVycyBhcmUgY2FsbGVkIGFjcm9z
cyBrZXhlYyB2aWE6DQoNCmtlcm5lbF9rZXhlYw0KICBrZXJuZWxfcmVzdGFydF9wcmVwYXJlDQog
ICAgYmxvY2tpbmdfbm90aWZpZXJfY2FsbF9jaGFpbg0KICAgICAga3ZtX3JlYm9vdA0KDQpTbyBh
ZnRlciB0aGlzIHBhdGNoLCBLVk0gaXMgbm90IHNodXRkb3duIGR1cmluZyBrZXhlYzsgaWYgaGFy
ZHdhcmUgdmlydA0KbW9kZSBpcyBlbmFibGVkIHRoZW4gdGhlIGtleGVjIGhhbmdzIGluIGV4YWN0
bHkgdGhlIHNhbWUgbWFubmVyIGFzIHlvdQ0KZGVzY3JpYmUgd2l0aCB0aGUgcmVib290Lg0KDQpT
b21lIHNwZWNpZmljIHNodXRkb3duIGNhbGxiYWNrcywgZm9yIGV4YW1wbGUgSU9NTVUsIEhQRVQs
IElSUSwgZXRjIGFyZQ0KY2FsbGVkIGluIG5hdGl2ZV9tYWNoaW5lX3NodXRkb3duLCBidXQgS1ZN
IGlzIG5vdCBvbmUgb2YgdGhlc2UuDQoNClRob3VnaHRzIG9uIHBvc3NpYmxlIHdheXMgdG8gZml4
IHRoaXM6DQphKSBnbyBiYWNrIHRvIHJlYm9vdCBub3RpZmllcnMNCmIpIGdldCBrZXhlYyB0byBj
YWxsIHN5c2NvcmVfc2h1dGRvd24oKSB0byBpbnZva2UgYWxsIG9mIHRoZXNlIGNhbGxiYWNrcw0K
YykgQWRkIGEgS1ZNLXNwZWNpZmljIGNhbGxiYWNrIHRvIG5hdGl2ZV9tYWNoaW5lX3NodXRkb3du
KCk7IHdlIG9ubHkNCm5lZWQgdGhpcyBmb3IgSW50ZWwgeDg2LCByaWdodD8NCg0KTXkgc2xpZ2h0
IHByZWZlcmVuY2UgaXMgdG93YXJkcyBhZGRpbmcgc3lzY29yZV9zaHV0ZG93bigpIHRvIGtleGVj
LCBidXQNCkknbSBub3Qgc3VyZSB0aGF0J3MgZmVhc2libGUuIEFkZGluZyBrZXhlYyBtYWludGFp
bmVycyBmb3IgaW5wdXQuDQoNCkpHDQo=

