Return-Path: <kvm+bounces-23851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1608494EE9B
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB18B283048
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1A917D378;
	Mon, 12 Aug 2024 13:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kLHovIh3"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1717B43F
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470321; cv=none; b=ejAz99+oI8PK+6wyJsTBba9swZyIM5cqoJ/vr7ywd9Edu1ol7/AZenf+aRS32qW6vKSwUr34AkcR/nvJVBvXdmO0wZ6ZjKSqget0+zhz5roHacFobGyzDhRYUgktSc31+Uj07SjPcGDcCt/7OelvGWjhcRd+QeFH//JsOn+Y95E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470321; c=relaxed/simple;
	bh=BLyvcz54yqw1cwd0lSpRMPr+MNn/ltNU4PwII5Im8vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6tFIrG9AFJoew6xMgRjVfuIi+RS2F/naBURUVwEst4pOSMUCihnjmYszHWJq2gxDyLiIQL62IERAThbvy350M4nffUv7digpwZRPfSM6LK0EBP41N733kK5+0nb/dfdRmKncuPcg1wQPs3org3PY2TuU5XdVrmEwlICNDmIHZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kLHovIh3; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XcHI0hzaFA/CxI3F7rOVjwGJI3765tE7OQbDjHZ6mtQ=;
	b=kLHovIh38AsJCYGIl4qz6BtAL5jJ5n7588bvYPDS9G+o5tc2FG6/tEepI1cvVPABPFqbJW
	/JHrkAqSqeNalKVX+EiBsKLt5VkZHIEHkb2nNX1De97gGLpPKUBtOPJiS4fAYYksU/ua3H
	uC9HibmcrqmQOKwDAFc8M7FodO3nTxA=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 6/7] riscv: Define and use PHYS_PAGE_MASK
Date: Mon, 12 Aug 2024 15:44:58 +0200
Message-ID: <20240812134451.112498-15-andrew.jones@linux.dev>
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

C doesn't extend the sign bit for unsigned types since there isn't a
sign bit to extend. This means a promotion of a u32 to a u64 results
in the upper 32 bits of the u64 being zero. When the u64 is then used
as a mask on another u64 the upper 32 bits get cleared, and that's
definitely not the intention of 'phys_addr & PAGE_MASK', which should
only clear the lower bits for page alignment. Create PHYS_PAGE_MASK
to do the right thing.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/mmu.h | 1 +
 lib/riscv/mmu.c     | 6 +++---
 lib/riscv/setup.c   | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/riscv/asm/mmu.h b/lib/riscv/asm/mmu.h
index 9cd760093666..28c332f11496 100644
--- a/lib/riscv/asm/mmu.h
+++ b/lib/riscv/asm/mmu.h
@@ -7,6 +7,7 @@
 #include <asm/pgtable.h>
 
 #define PHYS_MASK	((phys_addr_t)SATP_PPN << PAGE_SHIFT | (PAGE_SIZE - 1))
+#define PHYS_PAGE_MASK	(~((phys_addr_t)PAGE_SIZE - 1))
 
 static inline pgd_t *current_pgtable(void)
 {
diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index 24f9f90e51c3..ce49e67be84b 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -74,7 +74,7 @@ static pteval_t *__install_page(pgd_t *pgtable, phys_addr_t paddr,
 
 pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
 {
-	phys_addr_t paddr = phys & PAGE_MASK;
+	phys_addr_t paddr = phys & PHYS_PAGE_MASK;
 	uintptr_t vaddr = (uintptr_t)virt & PAGE_MASK;
 
 	assert(phys == (phys & PHYS_MASK));
@@ -87,7 +87,7 @@ void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 			phys_addr_t phys_start, phys_addr_t phys_end,
 			pgprot_t prot, bool flush)
 {
-	phys_addr_t paddr = phys_start & PAGE_MASK;
+	phys_addr_t paddr = phys_start & PHYS_PAGE_MASK;
 	uintptr_t vaddr = virt_offset & PAGE_MASK;
 	uintptr_t virt_end = phys_end - paddr + vaddr;
 
@@ -155,7 +155,7 @@ void *setup_mmu(phys_addr_t top, void *opaque)
 
 void __iomem *ioremap(phys_addr_t phys_addr, size_t size)
 {
-	phys_addr_t start = phys_addr & PAGE_MASK;
+	phys_addr_t start = phys_addr & PHYS_PAGE_MASK;
 	phys_addr_t end = PAGE_ALIGN(phys_addr + size);
 	pgd_t *pgtable = current_pgtable();
 	bool flush = true;
diff --git a/lib/riscv/setup.c b/lib/riscv/setup.c
index 35829309c13d..9a16f00093d7 100644
--- a/lib/riscv/setup.c
+++ b/lib/riscv/setup.c
@@ -91,7 +91,7 @@ static void mem_allocator_init(struct mem_region *freemem, phys_addr_t freemem_s
 	phys_addr_t base, top;
 
 	freemem_start = PAGE_ALIGN(freemem_start);
-	freemem_end &= PAGE_MASK;
+	freemem_end &= PHYS_PAGE_MASK;
 
 	/*
 	 * The assert below is mostly checking that the free memory doesn't
-- 
2.45.2


