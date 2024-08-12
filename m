Return-Path: <kvm+bounces-23849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41DAA94EE99
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0005A282A5D
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 859AE17CA03;
	Mon, 12 Aug 2024 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T6uuc6YT"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4BB0183CCD
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470310; cv=none; b=KeJjgynwfquJx+WCvoyS0JzUXd0kfLORIkOaBc6JCrcMxZLa8dPYIETJfoCG0kIcaUGJYdORQ620C00V7gkFW0SM30qzHxM8t5LAX3CRrLp5EbBD7Mo4EbfKZsnqczt3v7Ku0JRdvU9zYBm0qHtw4vW7mq0Ad0TXtbxHDZasFXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470310; c=relaxed/simple;
	bh=wUUrzDclgObepKvY1X8OMBl+3sMIkOuMBjGGtUd1uFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXGXZduejjuXNolZeTm/nigrbiK6T3d4W7/rAsawSVJifq390Rvj4J9F2opwZJjLcxvIMNuzL0Peod563KQbdzdVWvd19Up5G2ivztITTrLLkTscUqSYkDmFTTAQ+hlFqJxmCv+kLCa0X2IsWNljPyPxKICIEqIaio5APvQW9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T6uuc6YT; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a5FUvyxgqIHirRDjYb8iKhaLQoEREVMWBDImlBAY+uo=;
	b=T6uuc6YTjf5TpMnzIkOOlhC6iaTCi99ascOo96eZbBxkcU950NvcWFHAbLlWeUqs2Q22ck
	PIXjYmCzZOcq5YOt6YLgQv1GpV9TBn/gZNSZsPGGovFDnPjsU98PryCh+oTldMUmQlAFA0
	xTlSrvja6AjvcD639fpyxByoopoFDVk=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 4/7] riscv: Track memory above 3G
Date: Mon, 12 Aug 2024 15:44:56 +0200
Message-ID: <20240812134451.112498-13-andrew.jones@linux.dev>
In-Reply-To: <20240812134451.112498-9-andrew.jones@linux.dev>
References: <20240812134451.112498-9-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We chop the main memory region (which gets identity mapped) off at
the 3G boundary because the virtual memory allocator claims the 3G-4G
address range. Unit tests may want to be able to access the higher
memory, though, so keep track of it by putting it in its own memory
region. Since the test framework isn't using that memory region, flag
it as unused so unit tests will be confident that they can use the
memory for whatever they like.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/memregions.h  |  1 +
 lib/riscv/setup.c | 15 +++++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/lib/memregions.h b/lib/memregions.h
index 1600530ad7bf..04027f61b84c 100644
--- a/lib/memregions.h
+++ b/lib/memregions.h
@@ -10,6 +10,7 @@
 #define MR_F_CODE			BIT(1)
 #define MR_F_RESERVED			BIT(2)
 #define MR_F_PERSISTENT			BIT(3)
+#define MR_F_UNUSED			BIT(4)
 #define MR_F_UNKNOWN			BIT(31)
 
 struct mem_region {
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 2c7792a5b0bd..35829309c13d 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -85,8 +85,9 @@ static void cpu_init(void)
 	cpu0_calls_idle = true;
 }
 
-static void mem_allocator_init(phys_addr_t freemem_start, phys_addr_t freemem_end)
+static void mem_allocator_init(struct mem_region *freemem, phys_addr_t freemem_start)
 {
+	phys_addr_t freemem_end = freemem->end;
 	phys_addr_t base, top;
 
 	freemem_start = PAGE_ALIGN(freemem_start);
@@ -100,8 +101,14 @@ static void mem_allocator_init(phys_addr_t freemem_start, phys_addr_t freemem_en
 	 *
 	 * TODO: Allow the VA range to shrink and move.
 	 */
-	if (freemem_end > VA_BASE)
+	if (freemem_end > VA_BASE) {
+		struct mem_region *curr, *rest;
 		freemem_end = VA_BASE;
+		memregions_split(VA_BASE, &curr, &rest);
+		assert(curr == freemem);
+		if (rest)
+			rest->flags = MR_F_UNUSED;
+	}
 	assert(freemem_end - freemem_start >= SZ_1M * 16);
 
 	init_alloc_vpage(__va(VA_TOP));
@@ -135,7 +142,7 @@ static void mem_init(phys_addr_t freemem_start)
 	freemem = memregions_find(freemem_start);
 	assert(freemem && !(freemem->flags & (MR_F_IO | MR_F_CODE)));
 
-	mem_allocator_init(freemem_start, freemem->end);
+	mem_allocator_init(freemem, freemem_start);
 }
 
 static void freemem_push_fdt(void **freemem, const void *fdt)
@@ -248,7 +255,7 @@ static efi_status_t efi_mem_init(efi_bootinfo_t *efi_bootinfo)
 		freemem_push_fdt(&freemem, efi_bootinfo->fdt);
 
 	mmu_disable();
-	mem_allocator_init((unsigned long)freemem, freemem_mr->end);
+	mem_allocator_init(freemem_mr, (unsigned long)freemem);
 
 	return EFI_SUCCESS;
 }
-- 
2.45.2


