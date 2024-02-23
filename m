Return-Path: <kvm+bounces-9542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CDC86165F
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:53:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24C771C23E23
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 15:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8657D8565A;
	Fri, 23 Feb 2024 15:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KZVDuybP"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0475E84FC6
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 15:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703551; cv=none; b=mdukbZkZlB9u0zxe0Fuc3bI/4HQUaTjc0t0hS6zgOPRnrONVXlOQldrGQ+ZqfgxG3V6ywiin7HPFvG+8xAtY9z11oMumJr5B+RuHzHw0PQe65wGcRyr4ctzkrwQoDfAJGqstXUXKyXs21ZVqRidclugQzpVDuqw1QsAmH4KSFb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703551; c=relaxed/simple;
	bh=wpDhFfTN6nJKNBehoP3s6/g3ERYTTnU4O47Znkkop/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=JCQLVWHZrHbpnaw8tDbjtpjYjfJ1FecrDWldqICNYTQKgn4T7EZXmuDFgALx3WgI/SShfIqvyllBRwewtkH442RvK8bWjg74GlZi+8OEJaGPnLbiHJ7fw9tITXPTqy8V9yNZZu+ZoyiLb4zyBtDkJMo9FpgNRUiS9eXtwWiz1Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KZVDuybP; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYIHvI1GLAd4wT4WngttIKyGQENqRKMJxOIUlux1SQg=;
	b=KZVDuybPaLYI8cqhd1QFh+LAxp88DjjBEKA8QYeXq85QsU4l1WJ7U8UpcBaaN+23ZKgeGE
	1K6vDCRpBs6DI0nli9AzZorQltIi1GdCa9hqzDEUIcLdAyTDDWoef88fitZGIOPj4Ol128
	VhjCu3Z4IPMXqGWRXTqG+Xv99fRiKv8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 12/14] arm/arm64: Factor out allocator init from mem_init
Date: Fri, 23 Feb 2024 16:51:38 +0100
Message-ID: <20240223155125.368512-28-andrew.jones@linux.dev>
In-Reply-To: <20240223155125.368512-16-andrew.jones@linux.dev>
References: <20240223155125.368512-16-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The allocator init is identical for mem_init() and efi_mem_init().
Share it.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/arm/setup.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index f96ee04ddd68..d0be4c437708 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -136,9 +136,28 @@ static void arm_memregions_add_assumed(void)
 #endif
 }
 
-static void mem_init(phys_addr_t freemem_start)
+static void mem_allocator_init(phys_addr_t freemem_start, phys_addr_t freemem_end)
 {
 	phys_addr_t base, top;
+
+	freemem_start = PAGE_ALIGN(freemem_start);
+	freemem_end &= PAGE_MASK;
+
+	phys_alloc_init(freemem_start, freemem_end - freemem_start);
+	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
+
+	phys_alloc_get_unused(&base, &top);
+	base = PAGE_ALIGN(base);
+	top &= PAGE_MASK;
+	assert(sizeof(long) == 8 || !(base >> 32));
+	if (sizeof(long) != 8 && (top >> 32) != 0)
+		top = ((uint64_t)1 << 32);
+	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
+	page_alloc_ops_enable();
+}
+
+static void mem_init(phys_addr_t freemem_start)
+{
 	struct mem_region *freemem, *r, mem = {
 		.start = (phys_addr_t)-1,
 	};
@@ -169,17 +188,7 @@ static void mem_init(phys_addr_t freemem_start)
 	__phys_offset = mem.start;	/* PHYS_OFFSET */
 	__phys_end = mem.end;		/* PHYS_END */
 
-	phys_alloc_init(freemem_start, freemem->end - freemem_start);
-	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
-
-	phys_alloc_get_unused(&base, &top);
-	base = PAGE_ALIGN(base);
-	top = top & PAGE_MASK;
-	assert(sizeof(long) == 8 || !(base >> 32));
-	if (sizeof(long) != 8 && (top >> 32) != 0)
-		top = ((uint64_t)1 << 32);
-	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
-	page_alloc_ops_enable();
+	mem_allocator_init(freemem_start, freemem->end);
 }
 
 static void freemem_push_fdt(void **freemem, const void *fdt)
@@ -292,7 +301,6 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 	struct efi_boot_memmap *map = &(efi_bootinfo->mem_map);
 	efi_memory_desc_t *buffer = *map->map;
 	efi_memory_desc_t *d = NULL;
-	phys_addr_t base, top;
 	struct mem_region r;
 	uintptr_t text = (uintptr_t)&_text, etext = ALIGN((uintptr_t)&_etext, 4096);
 	uintptr_t data = (uintptr_t)&_data, edata = ALIGN((uintptr_t)&_edata, 4096);
@@ -380,17 +388,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 
 	assert(sizeof(long) == 8 || free_mem_start < (3ul << 30));
 
-	phys_alloc_init(free_mem_start, free_mem_pages << EFI_PAGE_SHIFT);
-	phys_alloc_set_minimum_alignment(SMP_CACHE_BYTES);
-
-	phys_alloc_get_unused(&base, &top);
-	base = PAGE_ALIGN(base);
-	top = top & PAGE_MASK;
-	assert(sizeof(long) == 8 || !(base >> 32));
-	if (sizeof(long) != 8 && (top >> 32) != 0)
-		top = ((uint64_t)1 << 32);
-	page_alloc_init_area(0, base >> PAGE_SHIFT, top >> PAGE_SHIFT);
-	page_alloc_ops_enable();
+	mem_allocator_init(free_mem_start, free_mem_start + (free_mem_pages << EFI_PAGE_SHIFT));
 
 	return EFI_SUCCESS;
 }
-- 
2.43.0


