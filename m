Return-Path: <kvm+bounces-11371-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A55598767AF
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 278071F22BD6
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 15:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857291EF1E;
	Fri,  8 Mar 2024 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="sUjZFJrL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C42C6A8
	for <kvm@vger.kernel.org>; Fri,  8 Mar 2024 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709913011; cv=none; b=b5YNmnBZSbcUyxJ9SkgjlewR8Pas7IuHqxCBYRyKTPLJj27dR52sUylCUkrXeJDjG5yKptJJGXgV3iLDj6DXovRcBUidzrrLpgfXGFvJnZR1VCXyRyq3AG2/7lQYUENW6j6PqPM9VjrhBgM1aSL068c4nUvRmNF6L2WE9WhG4to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709913011; c=relaxed/simple;
	bh=QA4lHtqKxSjsxT9qHmwJmhLD+pT1DQH3Vc8P8ZDukqU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ko/zG3xqMS68mVc62Mxa7IQsDTbXZJHNDybhz/CONLYXhW4cc71k0Uv2Q43bXWdQJRwHIN5zf7/kiOVkJcb/QvQHOcL7d91L22jUBLGVUBpBtdtx/PCgetma3X0PLiAGJL3g/oQVmiCn2qoCaHlF59hUH73zMfF0IuQTSsssmvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=sUjZFJrL; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1709913010; x=1741449010;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=QA4lHtqKxSjsxT9qHmwJmhLD+pT1DQH3Vc8P8ZDukqU=;
  b=sUjZFJrL5e9ej2vlGK81PUPVGEjo8JPcnpal+i1XE/wPgVSbegsHQoSG
   XnsrPebkemdsI/zhNeKG3CBrskGBI1R5D+OeXYniXsrSf3oo7+693xRvF
   PgrGrakbw+ns8YAOJPoF+ytiSa5avj1AQ4y4R/TLkreHyAs/rzb7Ml0Md
   0=;
X-IronPort-AV: E=Sophos;i="6.07,110,1708387200"; 
   d="scan'208";a="391958052"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 15:50:07 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:1988]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.25.203:2525] with esmtp (Farcaster)
 id 8c23d56c-2946-4ad1-a458-e638ebc96e22; Fri, 8 Mar 2024 15:50:05 +0000 (UTC)
X-Farcaster-Flow-ID: 8c23d56c-2946-4ad1-a458-e638ebc96e22
Received: from EX19D022EUC004.ant.amazon.com (10.252.51.159) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 8 Mar 2024 15:50:05 +0000
Received: from EX19D014EUC004.ant.amazon.com (10.252.51.182) by
 EX19D022EUC004.ant.amazon.com (10.252.51.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Fri, 8 Mar 2024 15:50:05 +0000
Received: from EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41]) by
 EX19D014EUC004.ant.amazon.com ([fe80::76dd:4020:4ff2:1e41%3]) with mapi id
 15.02.1258.028; Fri, 8 Mar 2024 15:50:05 +0000
From: "Gowans, James" <jgowans@amazon.com>
To: "seanjc@google.com" <seanjc@google.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "Roy, Patrick" <roypat@amazon.co.uk>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>, "Manwaring,
 Derek" <derekmn@amazon.com>, "rppt@kernel.org" <rppt@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Woodhouse, David"
	<dwmw@amazon.co.uk>
CC: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "lstoakes@gmail.com"
	<lstoakes@gmail.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"mst@redhat.com" <mst@redhat.com>, "somlo@cmu.edu" <somlo@cmu.edu>, "Graf
 (AWS), Alexander" <graf@amazon.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Unmapping KVM Guest Memory from Host Kernel
Thread-Topic: Unmapping KVM Guest Memory from Host Kernel
Thread-Index: AQHacXBJeX10YUH0O0SiQBg1zQLaEw==
Date: Fri, 8 Mar 2024 15:50:05 +0000
Message-ID: <cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D0CAAE8EB336B4C9323DDC23B24F0C0@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SGVsbG8gS1ZNLCBNTSBhbmQgbWVtZmRfc2VjcmV0IGZvbGtzLA0KDQpDdXJyZW50bHkgd2hlbiB1
c2luZyBhbm9ueW1vdXMgbWVtb3J5IGZvciBLVk0gZ3Vlc3QgUkFNLCB0aGUgbWVtb3J5IGFsbA0K
cmVtYWlucyBtYXBwZWQgaW50byB0aGUga2VybmVsIGRpcmVjdCBtYXAuIFdlIGFyZSBsb29raW5n
IGF0IG9wdGlvbnMgdG8NCmdldCBLVk0gZ3Vlc3QgbWVtb3J5IG91dCBvZiB0aGUga2VybmVs4oCZ
cyBkaXJlY3QgbWFwIGFzIGEgcHJpbmNpcGxlZA0KYXBwcm9hY2ggdG8gbWl0aWdhdGluZyBzcGVj
dWxhdGl2ZSBleGVjdXRpb24gaXNzdWVzIGluIHRoZSBob3N0IGtlcm5lbC4NCk91ciBnb2FsIGlz
IHRvIG1vcmUgY29tcGxldGVseSBhZGRyZXNzIHRoZSBjbGFzcyBvZiBpc3N1ZXMgd2hvc2UgbGVh
aw0Kb3JpZ2luIGlzIGNhdGVnb3JpemVkIGFzICJNYXBwZWQgbWVtb3J5IiBbMV0uDQoNCldlIGN1
cnJlbnRseSBoYXZlIGRvd25zdHJlYW0tb25seSBzb2x1dGlvbnMgdG8gdGhpcywgYnV0IHdlIHdh
bnQgdG8gbW92ZQ0KdG8gcHVyZWx5IHVwc3RyZWFtIGNvZGUuDQoNClNvIGZhciB3ZSBoYXZlIGJl
ZW4gbG9va2luZyBhdCB1c2luZyBtZW1mZF9zZWNyZXQsIHdoaWNoIHNlZW1zIHRvIGJlDQpkZXNp
Z25lZCBleGFjdGx5IGZvciB1c2VjYXNlcyB3aGVyZSBpdCBpcyB1bmRlc2lyYWJsZSB0byBoYXZl
IHNvbWUNCm1lbW9yeSByYW5nZSBhY2Nlc3NpYmxlIHRocm91Z2ggdGhlIGtlcm5lbOKAmXMgZGly
ZWN0IG1hcC4NCg0KSG93ZXZlciwgbWVtZmRfc2VjcmV0IGRvZXNu4oCZdCB3b3JrIG91dCB0aGUg
Ym94IGZvciBLVk0gZ3Vlc3QgbWVtb3J5OyB0aGUNCm1haW4gcmVhc29uIHNlZW1zIHRvIGJlIHRo
YXQgdGhlIEdVUCBwYXRoIGlzIGludGVudGlvbmFsbHkgZGlzYWJsZWQgZm9yDQptZW1mZF9zZWNy
ZXQsIHNvIGlmIHdlIHVzZSBhIG1lbWZkX3NlY3JldCBiYWNrZWQgVk1BIGZvciBhIG1lbXNsb3Qg
dGhlbg0KS1ZNIGlzIG5vdCBhYmxlIHRvIGZhdWx0IHRoZSBtZW1vcnkgaW4uIElmIGl04oCZcyBi
ZWVuIHByZS1mYXVsdGVkIGluIGJ5DQp1c2Vyc3BhY2UgdGhlbiBpdCBzZWVtcyB0byB3b3JrLg0K
DQpUaGVyZSBhcmUgYSBmZXcgb3RoZXIgaXNzdWVzIGFyb3VuZCB3aGVuIEtWTSBhY2Nlc3NlcyB0
aGUgZ3Vlc3QgbWVtb3J5Lg0KRm9yIGV4YW1wbGUgdGhlIEtWTSBQViBjbG9jayBjb2RlIGdvZXMg
ZGlyZWN0bHkgdG8gdGhlIFBGTiB2aWEgdGhlDQpwZm5jYWNoZSwgYW5kIHRoYXQgYWxzbyBicmVh
a3MgaWYgdGhlIFBGTiBpcyBub3QgaW4gdGhlIGRpcmVjdCBtYXAsIHNvDQp3ZeKAmWQgbmVlZCB0
byBjaGFuZ2UgdGhhdCBzb3J0IG9mIHRoaW5nLCBwZXJoYXBzIGdvaW5nIHZpYSB1c2Vyc3BhY2UN
CmFkZHJlc3Nlcy4NCg0KSWYgd2UgcmVtb3ZlIHRoZSBtZW1mZF9zZWNyZXQgY2hlY2sgZnJvbSB0
aGUgR1VQIHBhdGgsIGFuZCBkaXNhYmxlIEtWTeKAmXMNCnB2Y2xvY2sgZnJvbSB1c2Vyc3BhY2Ug
dmlhIEtWTV9DUFVJRF9GRUFUVVJFUywgd2UgYXJlIGFibGUgdG8gYm9vdCBhDQpzaW1wbGUgTGlu
dXggaW5pdHJkIHVzaW5nIGEgRmlyZWNyYWNrZXIgVk1NIG1vZGlmaWVkIHRvIHVzZQ0KbWVtZmRf
c2VjcmV0Lg0KDQpXZSBhcmUgYWxzbyBhd2FyZSBvZiBvbmdvaW5nIHdvcmsgb24gZ3Vlc3RfbWVt
ZmQuIFRoZSBjdXJyZW50DQppbXBsZW1lbnRhdGlvbiB1bm1hcHMgZ3Vlc3QgbWVtb3J5IGZyb20g
Vk1NIGFkZHJlc3Mgc3BhY2UsIGJ1dCBsZWF2ZXMgaXQNCmluIHRoZSBrZXJuZWzigJlzIGRpcmVj
dCBtYXAuIFdl4oCZcmUgbm90IGxvb2tpbmcgYXQgdW5tYXBwaW5nIGZyb20gVk1NDQp1c2Vyc3Bh
Y2UgeWV0OyB3ZSBzdGlsbCBuZWVkIGd1ZXN0IFJBTSB0aGVyZSBmb3IgUFYgZHJpdmVycyBsaWtl
IHZpcnRpbw0KdG8gY29udGludWUgdG8gd29yay4gU28gS1ZN4oCZcyBnbWVtIGRvZXNu4oCZdCBz
ZWVtIGxpa2UgdGhlIHJpZ2h0IHNvbHV0aW9uPw0KDQpXaXRoIHRoaXMgaW4gbWluZCwgd2hhdOKA
mXMgdGhlIGJlc3Qgd2F5IHRvIHNvbHZlIGdldHRpbmcgZ3Vlc3QgUkFNIG91dCBvZg0KdGhlIGRp
cmVjdCBtYXA/IElzIG1lbWZkX3NlY3JldCBpbnRlZ3JhdGlvbiB3aXRoIEtWTSB0aGUgd2F5IHRv
IGdvLCBvcg0Kc2hvdWxkIHdlIGJ1aWxkIGEgc29sdXRpb24gb24gdG9wIG9mIGd1ZXN0X21lbWZk
LCBmb3IgZXhhbXBsZSB2aWEgc29tZQ0KZmxhZyB0aGF0IGNhdXNlcyBpdCB0byBsZWF2ZSBtZW1v
cnkgaW4gdGhlIGhvc3QgdXNlcnNwYWNl4oCZcyBwYWdlIHRhYmxlcywNCmJ1dCByZW1vdmVzIGl0
IGZyb20gdGhlIGRpcmVjdCBtYXA/IA0KDQpXZSBhcmUga2VlbiB0byBoZWxwIGNvbnRyaWJ1dGUg
dG8gZ2V0dGluZyB0aGlzIHdvcmtpbmcsIHdl4oCZcmUganVzdA0KbG9va2luZyBmb3IgZ3VpZGFu
Y2UgZnJvbSBtYWludGFpbmVycyBvbiB3aGF0IHRoZSBjb3JyZWN0IHdheSB0byBzb2x2ZQ0KdGhp
cyBpcy4NCg0KQ2hlZXJzLA0KSmFtZXMgKyBjb2xsZWFndWVzIERlcmVrIGFuZCBQYXRyaWNrDQoN
Cg==

