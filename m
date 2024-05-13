Return-Path: <kvm+bounces-17329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E4228C44BA
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 18:01:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD079287BC8
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 16:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E499615532C;
	Mon, 13 May 2024 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="My//k5o7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E7E155320
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 16:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715616089; cv=none; b=cjhwaPtFmyxr7tOprOzy/i923V9xDlHiygD/OEWNWf453yosc6s9YXKysr1Y2omyLd8gN0yRAHgtKuKvE3YuIKnT6S0XcnujSzNKUXLB8uXPVTES+C7C8Y6aDYg5Ohn8JJPbTaOtN5ujzA5GppQGjPUY7X4CBdxDBG8JjsKzdOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715616089; c=relaxed/simple;
	bh=/ZQi9dOaRQSJ70JtHs5ktPMljCtexhvs6nJFR6ZIOr8=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aTPEps5G3GI4ap+5ZZmZut3q5TJmhROMeDEQtzjWQEzXcxqbMP/6NLdWgKTnHvv3MA4ugwvXemaPfMqF2/gu//KJynChJVZF0U9XJ4fJapIBETCWsloZtlJRYHWb/CdZgWnYBWLBH2Zexd90CQGe9g3Lw9d5YAPD23D/fU74egA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=My//k5o7; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1715616088; x=1747152088;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=/ZQi9dOaRQSJ70JtHs5ktPMljCtexhvs6nJFR6ZIOr8=;
  b=My//k5o7FrtSmXKBp9YSy3gbtRniIXQpFrlGAeJ/xgNuok2IqFzuxHF3
   8GK67+X+hsqqLliRNo6Jl+T3bpiiFeZ2BI/U5WTqvif6L4p/B5/8ngleG
   /iGQJS5xjL+LT4RNUnjDwHJ06DAjcxV7x0BSvxsZYZiIyWBS21EJHMhZ5
   A=;
X-IronPort-AV: E=Sophos;i="6.08,158,1712620800"; 
   d="scan'208";a="658341340"
Subject: Re: Unmapping KVM Guest Memory from Host Kernel
Thread-Topic: Unmapping KVM Guest Memory from Host Kernel
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 16:01:25 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:5865]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.14.167:2525] with esmtp (Farcaster)
 id 1115728c-e447-424e-be56-7a79af17b930; Mon, 13 May 2024 16:01:23 +0000 (UTC)
X-Farcaster-Flow-ID: 1115728c-e447-424e-be56-7a79af17b930
Received: from EX19D022EUC004.ant.amazon.com (10.252.51.159) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 13 May 2024 16:01:23 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D022EUC004.ant.amazon.com (10.252.51.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 13 May 2024 16:01:23 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.028; Mon, 13 May 2024 16:01:23 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "seanjc@google.com" <seanjc@google.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "somlo@cmu.edu" <somlo@cmu.edu>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Graf (AWS), Alexander" <graf@amazon.de>, "Manwaring,
 Derek" <derekmn@amazon.com>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "lstoakes@gmail.com" <lstoakes@gmail.com>,
	"mst@redhat.com" <mst@redhat.com>
Thread-Index: AQHapSDFL4wJB6zUokKkOmjg3vQ4V7GVTVUAgAAFhYA=
Date: Mon, 13 May 2024 16:01:22 +0000
Message-ID: <aaf684b5eb3a3fe9cfbb6205c16f0973c6f8bb07.camel@amazon.com>
References: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
	 <ZeudRmZz7M6fWPVM@google.com> <ZexEkGkNe_7UY7w6@kernel.org>
	 <58f39f23-0314-4e34-a8c7-30c3a1ae4777@amazon.co.uk>
	 <ZkI0SCMARCB9bAfc@google.com>
In-Reply-To: <ZkI0SCMARCB9bAfc@google.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <12947CE165AA3241A48C00EB1398EF6F@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

T24gTW9uLCAyMDI0LTA1LTEzIGF0IDA4OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFNlYW4sIHlvdSBtZW50aW9uZWQgdGhhdCB5b3UgZW52aXNpb24gZ3Vlc3RfbWVt
ZmQgYWxzbyBzdXBwb3J0aW5nIG5vbi1Db0NvIFZNcy4NCj4gPiBEbyB5b3UgaGF2ZSBzb21lIHRo
b3VnaHRzIGFib3V0IGhvdyB0byBtYWtlIHRoZSBhYm92ZSBjYXNlcyB3b3JrIGluIHRoZQ0KPiA+
IGd1ZXN0X21lbWZkIGNvbnRleHQ/DQo+IA0KPiBZZXMuwqAgVGhlIGhhbmQtd2F2eSBwbGFuIGlz
IHRvIGFsbG93IHNlbGVjdGl2ZWx5IG1tYXAoKWluZyBndWVzdF9tZW1mZCgpLsKgIFRoZXJlDQo+
IGlzIGEgbG9uZyB0aHJlYWRbKl0gZGlzY3Vzc2luZyBob3cgZXhhY3RseSB3ZSB3YW50IHRvIGRv
IHRoYXQuwqAgVGhlIFRMO0RSIGlzIHRoYXQNCj4gdGhlIGJhc2ljIGZ1bmN0aW9uYWxpdHkgaXMg
YWxzbyBzdHJhaWdodGZvcndhcmQ7IHRoZSBidWxrIG9mIHRoZSBkaXNjdXNzaW9uIGlzDQo+IGFy
b3VuZCBndXAoKSwgcmVjbGFpbSwgcGFnZSBtaWdyYXRpb24sIGV0Yy4NCg0KSSBzdGlsbCBuZWVk
IHRvIHJlYWQgdGhpcyBsb25nIHRocmVhZCwgYnV0IGp1c3QgYSB0aG91Z2h0IG9uIHRoZSB3b3Jk
DQoicmVzdHJpY3RlZCIgaGVyZTogZm9yIE1NSU8gdGhlIGluc3RydWN0aW9uIGNhbiBiZSBhbnl3
aGVyZSBhbmQNCnNpbWlsYXJseSB0aGUgbG9hZC9zdG9yZSBNTUlPIGRhdGEgY2FuIGJlIGFueXdo
ZXJlLiBEb2VzIHRoaXMgbWVhbiB0aGF0DQpmb3IgcnVubmluZyB1bm1vZGlmaWVkIG5vbi1Db0Nv
IFZNcyB3aXRoIGd1ZXN0X21lbWZkIGJhY2tlbmQgdGhhdCB3ZSdsbA0KYWx3YXlzIG5lZWQgdG8g
aGF2ZSB0aGUgd2hvbGUgb2YgZ3Vlc3QgbWVtb3J5IG1tYXBwZWQ/DQoNCkkgZ3Vlc3MgdGhlIGlk
ZWEgaXMgdGhhdCB0aGlzIHVzZSBjYXNlIHdpbGwgc3RpbGwgYmUgc3ViamVjdCB0byB0aGUNCm5v
cm1hbCByZXN0cmljdGlvbiBydWxlcywgYnV0IGZvciBhIG5vbi1Db0NvIG5vbi1wS1ZNIFZNIHRo
ZXJlIHdpbGwgYmUgDQpubyByZXN0cmljdGlvbiBpbiBwcmFjdGljZSwgYW5kIHVzZXJzcGFjZSB3
aWxsIG5lZWQgdG8gbW1hcCBldmVyeXRoaW5nDQphbHdheXM/DQoNCkl0IHJlYWxseSBzZWVtcyB5
dWNreSB0byBuZWVkIHRvIGhhdmUgYWxsIG9mIGd1ZXN0IFJBTSBtbWFwcGVkIGFsbCB0aGUNCnRp
bWUganVzdCBmb3IgTU1JTyB0byB3b3JrLi4uIEJ1dCBJIHN1cHBvc2UgdGhlcmUgaXMgbm8gd2F5
IGFyb3VuZCB0aGF0DQpmb3IgSW50ZWwgeDg2Lg0KDQpKRw0KDQo+IA0KPiBbKl0gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsL1pkZm9SM25DRVAzSFR0bTFAY2FzcGVyLmluZnJhZGVhZC5vcmcN
Cg0K

