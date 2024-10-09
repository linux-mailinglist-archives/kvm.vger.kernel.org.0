Return-Path: <kvm+bounces-28233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EF48996921
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 13:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC332286068
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CFC719258B;
	Wed,  9 Oct 2024 11:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="kLDZdA9s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A0E191F66;
	Wed,  9 Oct 2024 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474288; cv=none; b=YcSYehrakFQGxyjZH/wyBbf1kpgR/e7eZgO1C51Tk9X2kv6hZoODWpW1s3oHlpYmuqy7Oukxb/wDZlednYPTT9ZrMHS0JMsmDzd3QVL/BqXa3AS+d2ffYxUH87jUsH+JYEN6+jTknEQNymBCaFQSwDz7z2eQYbbG91Sb1LLd1sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474288; c=relaxed/simple;
	bh=UcKvFO+TsNSbZ5qXvdfNQzdJpe62EFjWfL/jyLbZmqI=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DgQN4AIiF8gjx0MXpgwMrn9NDUL3M32hkkWx0fS1toEOaLlO9YT8jpW9Kko6XV44LJ8+kkyDL6HItuvcoEWa090SvsY/mHL3QTT0/OEFbk6iMPfQj4fexB6QMSxjtv5IFHGUsgFpbc1hGyM7KC8vK+evok+otZzlI1zZg4/nkJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=kLDZdA9s; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1728474288; x=1760010288;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=UcKvFO+TsNSbZ5qXvdfNQzdJpe62EFjWfL/jyLbZmqI=;
  b=kLDZdA9swz8sK8wQ6UxkVDqfAdPUvVJZvxACAJFtALgj337u7kLw8+fZ
   oB0PZtt4HGKMHbH9XmRzNH6qhTWWxzSBpyKyjgAjWg/K41kdEcwlUPdSl
   iZ8Int0um/IoalVEU4xPwMJfKyJXmQX5hu10mnNGx5vnZ5kUpHHxw61R/
   4=;
X-IronPort-AV: E=Sophos;i="6.11,189,1725321600"; 
   d="scan'208";a="765049900"
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Thread-Topic: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 11:44:34 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:55271]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.3.68:2525] with esmtp (Farcaster)
 id 6223964c-61b1-498f-a40a-44a95eba2766; Wed, 9 Oct 2024 11:44:32 +0000 (UTC)
X-Farcaster-Flow-ID: 6223964c-61b1-498f-a40a-44a95eba2766
Received: from EX19D004EUC003.ant.amazon.com (10.252.51.249) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 9 Oct 2024 11:44:31 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D004EUC003.ant.amazon.com (10.252.51.249) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 9 Oct 2024 11:44:31 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.034; Wed, 9 Oct 2024 11:44:31 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "kw@linux.com" <kw@linux.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "madvenka@linux.microsoft.com"
	<madvenka@linux.microsoft.com>, "anthony.yznaga@oracle.com"
	<anthony.yznaga@oracle.com>, "robin.murphy@arm.com" <robin.murphy@arm.com>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"nh-open-source@amazon.com" <nh-open-source@amazon.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Saenz Julienne, Nicolas"
	<nsaenz@amazon.es>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>, "steven.sistare@oracle.com"
	<steven.sistare@oracle.com>, "Graf (AWS), Alexander" <graf@amazon.de>,
	"will@kernel.org" <will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>,
	"maz@kernel.org" <maz@kernel.org>
Thread-Index: AQHbCCwuWjwUDEQNSEmjPqzUeT3bK7Jz6OkAgAcvr4CAAAJBgIAAAo+AgABl3QCAAu2RAA==
Date: Wed, 9 Oct 2024 11:44:30 +0000
Message-ID: <b76aa005c0fb75199cbb1fa0790858b9c808c90a.camel@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
	 <20240916113102.710522-6-jgowans@amazon.com>
	 <20241002185520.GL1369530@ziepe.ca>
	 <d6328467adc9b7512f6dd88a6f8f843b8efdc154.camel@amazon.com>
	 <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>
	 <1d331c55a299d414e49ba5eb6f46dccb525bf788.camel@amazon.com>
	 <20241007150138.GM2456194@ziepe.ca>
In-Reply-To: <20241007150138.GM2456194@ziepe.ca>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <33562CF835D94F48866753933764304C@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTEwLTA3IGF0IDEyOjAxIC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIE1vbiwgT2N0IDA3LCAyMDI0IGF0IDA4OjU3OjA3QU0gKzAwMDAsIEdvd2FucywgSmFt
ZXMgd3JvdGU6DQo+ID4gV2l0aCB0aGUgQVJNIFNNTVV2MyBmb3IgZXhhbXBsZSBJIHRoaW5rIHRo
ZXJlIGFyZSBicmVhay1iZWZvcmUtbWFrZQ0KPiA+IHJlcXVpcmVtZW50LCBzbyBpcyBpdCBwb3Nz
aWJsZSB0byBkbyBhbiBhdG9taWMgc3dpdGNoIG9mIHRoZSBTTU1VdjMgcGFnZQ0KPiA+IHRhYmxl
IFBHRCBpbiBhIGhpdGxlc3Mgd2F5Pw0KPiANCj4gVGhlIEJCTSBydWxlcyBhcmUgb25seSBhYm91
dCBjYWNoZWQgdHJhbnNsYXRpb25zLiBJZiBhbGwgeW91ciBJT1BURXMNCj4gcmVzdWx0IGluIHRo
ZSBzYW1lIHRyYW5zbGF0aW9uICpzaXplKiB0aGVuIHlvdSBhcmUgc2FmZS4gWW91IGNhbg0KPiBj
aGFuZ2UgdGhlIHJhZGl4IG1lbW9yeSBzdG9yaW5nIHRoZSBJT1BURXMgZnJlZWx5LCBBRkFJSy4N
Cg0KT2theSwgYnV0IGluIGdlbmVyYWwgdGhpcyBzdGlsbCBtZWFucyB0aGF0IHRoZSBwYWdlIHRh
YmxlcyBtdXN0IGhhdmUNCmV4YWN0bHkgdGhlIHNhbWUgdHJhbnNsYXRpb25zIGlmIHdlIHRyeSB0
byBzd2l0Y2ggZnJvbSBvbmUgc2V0IHRvDQphbm90aGVyLiBJZiBpdCBpcyBwb3NzaWJsZSB0byBj
aGFuZ2UgdHJhbnNsYXRpb25zIHRoZW4gdHJhbnNsYXRpb24gdGFibGUNCmVudHJpZXMgY291bGQg
YmUgY3JlYXRlZCBhdCBkaWZmZXJlbnQgZ3JhbnVsYXJpdHkgKFBURSwgUE1ELCBQVUQpIGxldmVs
DQp3aGljaCB3b3VsZCB2aW9sYXRlIHRoaXMgcmVxdWlyZW1lbnQuIA0KDQpJdCdzIGFsc28gcG9z
c2libGUgZm9yIGRpZmZlcmVudCBJT01NVSBkcml2ZXIgdmVyc2lvbnMgdG8gc2V0IHVwIHRoZSB0
aGUNCnNhbWUgdHJhbnNsYXRpb25zLCBidXQgYXQgZGlmZmVyZW50IHBhZ2UgdGFibGUgbGV2ZWxz
LiBQZXJoYXBzIGFuIG9sZGVyDQp2ZXJzaW9uIGRpZCBub3QgY29hbGVzY2UgY29tZSBQVEVzLCBi
dXQgYSBuZXdlciB2ZXJzaW9uIGRvZXMgY29hbGVzY2UuDQpXb3VsZCB0aGUgc2FtZSB0cmFuc2xh
dGlvbnMgYnV0IGF0IGEgZGlmZmVyZW50IHNpemUgdmlvbGF0ZSBCQk0/DQoNCklmIHdlIHNheSB0
aGF0IHRvIGJlIHNhZmUvY29ycmVjdCBpbiB0aGUgZ2VuZXJhbCBjYXNlIHRoZW4gaXQgaXMNCm5l
Y2Vzc2FyeSBmb3IgdGhlIHRyYW5zbGF0aW9ucyB0byBiZSAqZXhhY3RseSogdGhlIHNhbWUgYmVm
b3JlIGFuZCBhZnRlcg0Ka2V4ZWMsIGlzIHRoZXJlIGFueSBiZW5lZml0IHRvIGJ1aWxkaW5nIG5l
dyB0cmFuc2xhdGlvbiB0YWJsZXMgYW5kDQpzd2l0Y2hpbmcgdG8gdGhlbT8gV2UgbWF5IGFzIHdl
bGwgY29udGludWUgdG8gdXNlIHRoZSBleGFjdCBzYW1lIHBhZ2UNCnRhYmxlcyBhbmQgY29uc3Ry
dWN0IGlvbW11ZmQgb2JqZWN0cyAoSU9BUywgZXRjKSB0byBtYXRjaC4NCg0KVGhlcmUgaXMgYWxz
byBhIHBlcmZvcm1hbmNlIGNvbnNpZGVyYXRpb24gaGVyZTogd2hlbiBkb2luZyBsaXZlIHVwZGF0
ZQ0KZXZlcnkgbWlsbGlzZWNvbmQgb2YgZG93biB0aW1lIG1hdHRlcnMuIEknbSBub3Qgc3VyZSBp
ZiB0aGlzIGlvbW11ZmQgcmUtDQppbml0aWFsaXNhdGlvbiB3aWxsIGVuZCB1cCBiZWluZyBpbiB0
aGUgaG90IHBhdGggb2YgdGhpbmdzIHRoYXQgbmVlZCB0bw0KYmUgZG9uZSBiZWZvcmUgdGhlIFZN
IGNhbiBzdGFydCBydW5uaW5nIGFnYWluLiBJZiBpdCBpbiB0aGUgaG90IHBhdGgNCnRoZW4gaXQg
d291bGQgYmUgdXNlZnVsIHRvIGF2b2lkIHJlYnVpbGRpbmcgaWRlbnRpY2FsIHRhYmxlcy4gTWF5
YmUgaXQNCmVuZHMgdXAgYmVpbmcgaW4gdGhlICJ3YXJtIiBwYXRoIC0gdGhlIFZNIGNhbiBzdGFy
dCBydW5uaW5nIGJ1dCB3aWxsDQpzbGVlcCBpZiB0YWtpbmcgYSBwYWdlIGZhdWx0IGJlZm9yZSBJ
T01NVUZEIGlzIHJlLWluaXRhbGlzZWQuLi4NCg0KU28gb3ZlcmFsbCBteSBwb2ludCBpcyB0aGF0
IEkgdGhpbmsgd2UgZW5kIHVwIHdpdGggYSByZXF1aXJlbWVudCB0aGF0DQp0aGUgcGd0YWJsZXMg
YXJlIGlkZW50aWNhbCBiZWZvcmUgYW5kIGFmdGVyIGtleGVjIHNvIHRoZXJlIGlzIGFueQ0KYmVu
ZWZpdCBpbiByZWJ1aWxkaW5nIHRoZW0/DQoNCkpHDQo=

