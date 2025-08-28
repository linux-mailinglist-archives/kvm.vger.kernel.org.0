Return-Path: <kvm+bounces-56059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 64714B3987F
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1955E3B4BA6
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 048E32F1FC2;
	Thu, 28 Aug 2025 09:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="eqmsxTJK"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9D72ECE8D;
	Thu, 28 Aug 2025 09:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.28.197.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756373974; cv=none; b=TiZf5QVs8sZLZ6WxxHndDFnsZQ7vz+R1nRFHXWH0tix+UWE9THdfY8NvBym+6S36HBF9sJvYEJIPHHxqq1EbFYih47RewD3M6jA5IFJlaEjynqnNik7UJFK96j+5cAKTswH4aemG8UQGbey3pLgfAR9IgvGK1gIJGTScMqszqyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756373974; c=relaxed/simple;
	bh=ABN4SGVApKBOKlDxz2m3QqAZNJ5LHx/3vj8LdcvrxbE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FqO8OGmWvfjNCto+Y5U5OeC+Ktj1hnpCK8f4Qq5zXPLCw0FtMgl648EZrPkmq6yScKBHyGV4l3D7sBLwfTOcNQ09fuWQ4mSOdle0cLJ4hhM3NeF78D7KXV38XRau7bi6kjRuEQnMV1E8c77upD5UUMxw8SVBgj7gAGuHdMMBmMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=eqmsxTJK; arc=none smtp.client-ip=52.28.197.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373971; x=1787909971;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QxcRm5lfAR27jNQOt1Cv3ZD27Tadoj4JCPsxnEzoRq0=;
  b=eqmsxTJKZv6MpFCsVVCtBxtAtR3lEQQyZPC6AdzUAB1eB/JBa1LrFDZL
   /rvGwDEP97cOzUyhub306h81mqxJ9aP7VLe6TSJMaTGawLojgjkhxHXyL
   wadrqO8qkpH/5I3zX34tZh6sKflbdX31O6qATFUw2CqDpYu6k2+S/KMvo
   I8DNJxFuekzkXzpg02VZkLBgr1m+kMSdSgNejve3AGYl7a/I2UA7ENY16
   S75KU/T+ylGlUgxm0cAliACb6k5xhXlWXHPHANTRyOTgYsE6SG7syyzJY
   0F/o7RIDnglutCghf/MDOjU1npDUTZC5nrHi12Cd1ARNauShT71VCKC5B
   Q==;
X-CSE-ConnectionGUID: 7aAfSXOpQhSh0GmR202udQ==
X-CSE-MsgGUID: 784e2/YRTTud5uoKzM+cEg==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1198436"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:18 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:9852]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.197:2525] with esmtp (Farcaster)
 id f40bcc95-ba71-4bbc-8aef-317484c6e4a7; Thu, 28 Aug 2025 09:39:18 +0000 (UTC)
X-Farcaster-Flow-ID: f40bcc95-ba71-4bbc-8aef-317484c6e4a7
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:17 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:17 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:17 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to KVM
 module
Thread-Topic: [PATCH v5 02/12] arch: export set_direct_map_valid_noflush to
 KVM module
Thread-Index: AQHcF/+fQN7WhMNbEkOkKSoqsUoNyw==
Date: Thu, 28 Aug 2025 09:39:17 +0000
Message-ID: <20250828093902.2719-3-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Use the new per-module export functionality to allow KVM (and only KVM)=0A=
access to set_direct_map_valid_noflush(). This allows guest_memfd to=0A=
remove its memory from the direct map, even if KVM is built as a module.=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret enjoys, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 arch/arm64/mm/pageattr.c     | 1 +=0A=
 arch/loongarch/mm/pageattr.c | 1 +=0A=
 arch/riscv/mm/pageattr.c     | 1 +=0A=
 arch/s390/mm/pageattr.c      | 1 +=0A=
 arch/x86/mm/pat/set_memory.c | 1 +=0A=
 5 files changed, 5 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c=0A=
index 04d4a8f676db..4f3cddfab9b0 100644=0A=
--- a/arch/arm64/mm/pageattr.c=0A=
+++ b/arch/arm64/mm/pageattr.c=0A=
@@ -291,6 +291,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return set_memory_valid(addr, nr, valid);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 /*=0A=
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=0A=
index f5e910b68229..d076bfd3fcbf 100644=0A=
--- a/arch/loongarch/mm/pageattr.c=0A=
+++ b/arch/loongarch/mm/pageattr.c=0A=
@@ -217,6 +217,7 @@ int set_direct_map_invalid_noflush(struct page *page)=
=0A=
 =0A=
 	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_=
VALID));=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
 {=0A=
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c=0A=
index 3f76db3d2769..6db31040cd66 100644=0A=
--- a/arch/riscv/mm/pageattr.c=0A=
+++ b/arch/riscv/mm/pageattr.c=0A=
@@ -400,6 +400,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory((unsigned long)page_address(page), nr, set, clear);=
=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *=
data)=0A=
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c=0A=
index 348e759840e7..8ffd9ef09bc6 100644=0A=
--- a/arch/s390/mm/pageattr.c=0A=
+++ b/arch/s390/mm/pageattr.c=0A=
@@ -413,6 +413,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory((unsigned long)page_to_virt(page), nr, flags);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 bool kernel_page_present(struct page *page)=0A=
 {=0A=
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c=0A=
index 8834c76f91c9..87e9c7d2dcdc 100644=0A=
--- a/arch/x86/mm/pat/set_memory.c=0A=
+++ b/arch/x86/mm/pat/set_memory.c=0A=
@@ -2661,6 +2661,7 @@ int set_direct_map_valid_noflush(struct page *page, u=
nsigned nr, bool valid)=0A=
 =0A=
 	return __set_pages_np(page, nr);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 void __kernel_map_pages(struct page *page, int numpages, int enable)=0A=
-- =0A=
2.50.1=0A=
=0A=

