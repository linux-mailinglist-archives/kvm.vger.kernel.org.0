Return-Path: <kvm+bounces-23850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 736CD94EE9A
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6F061C218BE
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0988717D895;
	Mon, 12 Aug 2024 13:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PT5SdbcZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6197217D355
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470316; cv=none; b=fEn7beKqTorG5YPth3Ns9fZDYRXTOqnZfqraRjixUOX0TXWNMUXwNqQdLWyFPN+M1HmYPJXhe71X6m5veCBsYmOjNDDAx6Tpm5wpRpGbZM3degUr8V2LyD3HBRVZM2CVk+2ORCkysmjCVel13bmLP4WLpfaijtaLYOlm/meCfWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470316; c=relaxed/simple;
	bh=pBf+LtRf5wx9RL5a9rheXT1nVhOXFCo71yKipNKfjAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHslAPnCmh7snYCZ3QkH9Tc7Hm/pTNQXxR84kATb2B4TGhommlpQLC3bnKXZma56+lPyEFqya2XYtDImOsCqLbN4QHTvKfedE6Y5EGtt/cnQTLga20hd4hivRsUkKayHrN0HKtbR+E0ifkJLZOnU+3RgQQPZbBiRVgPRLACGjZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PT5SdbcZ; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IQpSYlAP04me5Adzln3w4xVrKO6RUKkPSs6y6rO/R0g=;
	b=PT5SdbcZMCSsmOx5Rl1wh9Qgo4dvADGGtwSNXlH9FTHRn1M29FOMcjfizJ8HAa+6q39Agc
	c/CBEvOfqPvXdmwPZxpmd94EncjrlEycxv/8P/4ZeHILvuyU3OEMCTUnUyFUUe1oc47Iri
	LEBjKKrW9K9TEt44zsUE4YxMVuhemj4=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 5/7] riscv: mmu: Sanity check input physical addresses
Date: Mon, 12 Aug 2024 15:44:57 +0200
Message-ID: <20240812134451.112498-14-andrew.jones@linux.dev>
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

Ensure physical addresses aren't using bits they shouldn't be.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/asm/mmu.h | 2 ++
 lib/riscv/mmu.c     | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/lib/riscv/asm/mmu.h b/lib/riscv/asm/mmu.h
index bb60f0895e2b..9cd760093666 100644
--- a/lib/riscv/asm/mmu.h
+++ b/lib/riscv/asm/mmu.h
@@ -6,6 +6,8 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
+#define PHYS_MASK	((phys_addr_t)SATP_PPN << PAGE_SHIFT | (PAGE_SIZE - 1))
+
 static inline pgd_t *current_pgtable(void)
 {
 	return (pgd_t *)((csr_read(CSR_SATP) & SATP_PPN) << PAGE_SHIFT);
diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index 6ab1f15a99ae..24f9f90e51c3 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -77,6 +77,8 @@ pteval_t *install_page(pgd_t *pgtable, phys_addr_t phys, void *virt)
 	phys_addr_t paddr = phys & PAGE_MASK;
 	uintptr_t vaddr = (uintptr_t)virt & PAGE_MASK;
 
+	assert(phys == (phys & PHYS_MASK));
+
 	return __install_page(pgtable, paddr, vaddr,
 			      __pgprot(_PAGE_READ | _PAGE_WRITE), true);
 }
@@ -89,6 +91,8 @@ void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
 	uintptr_t vaddr = virt_offset & PAGE_MASK;
 	uintptr_t virt_end = phys_end - paddr + vaddr;
 
+	assert(phys_start == (phys_start & PHYS_MASK));
+	assert(phys_end == (phys_end & PHYS_MASK));
 	assert(phys_start < phys_end);
 
 	for (; vaddr < virt_end; vaddr += PAGE_SIZE, paddr += PAGE_SIZE)
-- 
2.45.2


