Return-Path: <kvm+bounces-28051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2189927AA
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 10:57:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 02E26B22DF7
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 08:57:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D2818C32F;
	Mon,  7 Oct 2024 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="ZwgNzrpL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8081D18BBA6;
	Mon,  7 Oct 2024 08:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728291433; cv=none; b=OaYv/XASopequnulk/YceNAox3oydVmObvFfJBWeTzE4eJ+mrt3AwRp2HGLzvWnUREZ/eRySDBJyuEsrvd/21jmMgEJvqQw6nBXuacdauuWjr7rWj662HKuuxWC6LSv/LPsRQ1EsREANiU3DmLyEqduM5ZjusucwOZYktHqqFoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728291433; c=relaxed/simple;
	bh=DJbexe+ttiZ5x77hbQXF2Mka5pGwQQWWP1++J/3f+8k=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BqX2lNkn9/E1C+9MY+L0coSw7rBPIARMEbJXl2b4pb7oFwycmjdEuKbw64CFy5HTTx+Bs1UQ5eR1CDxhuy7g2YHgoNtki8NXvqnd/RjlHDdWLwmiNcm16JWpidkeMOit9Bt/OUQuUaR4cxXIwdV0yJuBXIOSGPUENteuewTQWA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=ZwgNzrpL; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1728291432; x=1759827432;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=DJbexe+ttiZ5x77hbQXF2Mka5pGwQQWWP1++J/3f+8k=;
  b=ZwgNzrpLXRiyg109oaJJYV1CvV0pOyFusMm1fIuxVQ7Yx80nhMAsCrXP
   OlT3FLutfvFg4tGFbF2JvOWC4txZ1wNc/WQtS0pD7yfLDeLZBSglxjhr8
   fmwqxjdWpI+xDEi+86cZmGrvuvHfgmAMDqbhE2+WuDwUqH6bkbEr9PWlg
   A=;
X-IronPort-AV: E=Sophos;i="6.11,184,1725321600"; 
   d="scan'208";a="135547122"
Subject: Re: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Thread-Topic: [RFC PATCH 05/13] iommufd: Serialise persisted iommufds and ioas
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 08:57:09 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:56144]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.46.202:2525] with esmtp (Farcaster)
 id a248f77f-5ebc-4dfe-9e52-0d5791a16722; Mon, 7 Oct 2024 08:57:08 +0000 (UTC)
X-Farcaster-Flow-ID: a248f77f-5ebc-4dfe-9e52-0d5791a16722
Received: from EX19D004EUC003.ant.amazon.com (10.252.51.249) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 7 Oct 2024 08:57:08 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D004EUC003.ant.amazon.com (10.252.51.249) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Mon, 7 Oct 2024 08:57:08 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.034; Mon, 7 Oct 2024 08:57:07 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "jgg@ziepe.ca" <jgg@ziepe.ca>, "dwmw2@infradead.org" <dwmw2@infradead.org>
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
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "maz@kernel.org"
	<maz@kernel.org>, "steven.sistare@oracle.com" <steven.sistare@oracle.com>,
	"Graf (AWS), Alexander" <graf@amazon.de>, "will@kernel.org"
	<will@kernel.org>, "joro@8bytes.org" <joro@8bytes.org>
Thread-Index: AQHbCCwuWjwUDEQNSEmjPqzUeT3bK7Jz6OkAgAcvr4CAAAJBgIAAAo+A
Date: Mon, 7 Oct 2024 08:57:07 +0000
Message-ID: <1d331c55a299d414e49ba5eb6f46dccb525bf788.camel@amazon.com>
References: <20240916113102.710522-1-jgowans@amazon.com>
	 <20240916113102.710522-6-jgowans@amazon.com>
	 <20241002185520.GL1369530@ziepe.ca>
	 <d6328467adc9b7512f6dd88a6f8f843b8efdc154.camel@amazon.com>
	 <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>
In-Reply-To: <e458d48a797043b7efc853fc65b9c4d043b12ed4.camel@infradead.org>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <A16D75C62307944AA0B838AFB87120FC@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTEwLTA3IGF0IDA5OjQ3ICswMTAwLCBEYXZpZCBXb29kaG91c2Ugd3JvdGU6
DQo+IE9uIE1vbiwgMjAyNC0xMC0wNyBhdCAwODozOSArMDAwMCwgR293YW5zLCBKYW1lcyB3cm90
ZToNCj4gPiANCj4gPiBJIHRoaW5rIHdlIGhhdmUgdHdvIG90aGVyIHBvc3NpYmxlIGFwcHJvYWNo
ZXMgaGVyZToNCj4gPiANCj4gPiAxLiBXaGF0IHRoaXMgUkZDIGlzIHNrZXRjaGluZyBvdXQsIHNl
cmlhbGlzaW5nIGZpZWxkcyBmcm9tIHRoZSBzdHJ1Y3RzDQo+ID4gYW5kIHNldHRpbmcgdGhvc2Ug
ZmllbGRzIGFnYWluIG9uIGRlc2VyaWFsaXNlLiBBcyB5b3UgcG9pbnQgb3V0IHRoaXMNCj4gPiB3
aWxsIGJlIGNvbXBsaWNhdGVkLg0KPiA+IA0KPiA+IDIuIEdldCB1c2Vyc3BhY2UgdG8gZG8gdGhl
IHdvcms6IHVzZXJzcGFjZSBuZWVkcyB0byByZS1kbyB0aGUgaW9jdGxzDQo+ID4gYWZ0ZXIga2V4
ZWMgdG8gcmVjb25zdHJ1Y3QgdGhlIG9iamVjdHMuIE15IG1haW4gaXNzdWUgd2l0aCB0aGlzIGFw
cHJvYWNoDQo+ID4gaXMgdGhhdCB0aGUga2VybmVsIG5lZWRzIHRvIGRvIHNvbWUgc29ydCBvZiB0
cnVzdCBidXQgdmVyaWZ5IGFwcHJvYWNoIHRvDQo+ID4gZW5zdXJlIHRoYXQgdXNlcnNwYWNlIGNv
bnN0cnVjdHMgZXZlcnl0aGluZyB0aGUgc2FtZSB3YXkgYWZ0ZXIga2V4ZWMgYXMNCj4gPiBpdCB3
YXMgYmVmb3JlIGtleGVjLiBXZSBkb24ndCB3YW50IHRvIGVuZCB1cCBpbiBhIHN0YXRlIHdoZXJl
IHRoZQ0KPiA+IGlvbW11ZmQgb2JqZWN0cyBkb24ndCBtYXRjaCB0aGUgcGVyc2lzdGVkIHBhZ2Ug
dGFibGVzLg0KPiANCj4gVG8gd2hhdCBleHRlbnQgZG9lcyB0aGUga2VybmVsIHJlYWxseSBuZWVk
IHRvIHRydXN0IG9yIHZlcmlmeT8gQXQgTFBDDQo+IHdlIHNlZW1lZCB0byBzcGVhayBvZiBhIG1v
ZGVsIHdoZXJlIHVzZXJzcGFjZSBidWlsZHMgYSAibmV3IiBhZGRyZXNzDQo+IHNwYWNlIGZvciBl
YWNoIGRldmljZSBhbmQgdGhlbiBhdG9taWNhbGx5IHN3aXRjaGVzIHRvIHRoZSBuZXcgcGFnZQ0K
PiB0YWJsZXMgaW5zdGVhZCBvZiB0aGUgb3JpZ2luYWwgb25lcyBpbmhlcml0ZWQgZnJvbSB0aGUg
cHJldmlvdXMga2VybmVsLg0KPiANCj4gVGhhdCBkb2VzIGludm9sdmUgaGF2aW5nIHNwYWNlIGZv
ciBhbm90aGVyIHNldCBvZiBwYWdlIHRhYmxlcywgb2YNCj4gY291cnNlLCBidXQgdGhhdCdzIG5v
dCBpbXBvc3NpYmxlLg0KDQpUaGUgaWRlYSBvZiBjb25zdHJ1Y3RpbmcgZnJlc2ggcGFnZSB0YWJs
ZXMgYW5kIHRoZW4gc3dhcHBpbmcgb3ZlciB0bw0KdGhhdCBpcyBpbmRlZWQgYXBwZWFsaW5nLCBi
dXQgSSBkb24ndCBrbm93IGlmIHRoYXQncyBhbHdheXMgcG9zc2libGUuDQpXaXRoIHRoZSBBUk0g
U01NVXYzIGZvciBleGFtcGxlIEkgdGhpbmsgdGhlcmUgYXJlIGJyZWFrLWJlZm9yZS1tYWtlDQpy
ZXF1aXJlbWVudCwgc28gaXMgaXQgcG9zc2libGUgdG8gZG8gYW4gYXRvbWljIHN3aXRjaCBvZiB0
aGUgU01NVXYzIHBhZ2UNCnRhYmxlIFBHRCBpbiBhIGhpdGxlc3Mgd2F5PyBFdmVyeXRoaW5nIGhl
cmUgbXVzdCBiZSBoaXRsZXNzIC0gc2VyaWFsaXNlDQphbmQgZGVzZXJpYWxpc2UgbXVzdCBub3Qg
Y2F1c2UgYW55IERNQSBmYXVsdHMuDQoNCklmIGl0J3Mgbm90IHBvc3NpYmxlIHRvIGRvIGEgaGl0
bGVzcyBhdG9taWMgc3dpdGNoIChJIGFtIHVuc3VyZSBhYm91dA0KdGhpcywgbmVlZCB0byBSVEZN
KSB0aGVuIHdlJ3JlIGNvbXBlbGxlZCB0byByZS11c2UgdGhlIGV4aXN0aW5nIHBhZ2UNCnRhYmxl
cyBhbmQgaWYgdGhhdCdzIHRoZSBjYXNlIEkgdGhpbmsgdGhlIGtlcm5lbCBNVVNUIGVuc3VyZSB0
aGF0IHRoZQ0KaW9tbXVmZCBJT0FTIG9iamVjdCBleGFjdGx5IG1hdGNoIHRoZSBvbmVzIGJlZm9y
ZSBrZXhlYy4gSSBjYW4gaW1hZ2luZQ0KYWxsIHNvcnRzIG9mIG1lc3MgaWYgdGhvc2UgZ28gb3V0
IG9mIHN5bmMhIA0KDQo=

