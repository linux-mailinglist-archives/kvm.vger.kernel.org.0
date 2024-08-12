Return-Path: <kvm+bounces-23852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1C794EE9C
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 15:46:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 581A01F22816
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 13:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93D117E47A;
	Mon, 12 Aug 2024 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Te8KoT86"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422E817E44A
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 13:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723470325; cv=none; b=BLoI+7u2fSTLCD6Q44/cF568XDGsyLFQ8OrpsOOyHJv+LgWQb7RKAYNdZSyT5vo001zIwLZx0rvLgFL1Sd65znH9ZEGlk2OqFubIse7p0NfWVburT3gNvXd8f/9Wr8+pvXffjzPKV0B5NzmyZN8MkLCUyIiiAGOoD518CuSqlyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723470325; c=relaxed/simple;
	bh=lhF3pTH4I8xK/IBvlxVSscLk3/iBHjh5SV8iq7IJ+oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mybejx36RTAeUNuF61cLQKMz5aPr56ESIaAO7vBqHX7D3A68+KKXhXMJSd8koUml3qYqF8bSF90dhqJJnRGSLJdXX2yQWBMdT6ehKC9IbLYhhVAY+12K/vcK3FkJ8xF7jyoXuTDUXQA/EnmpvjZwFCXGPNOrT/A4ri1KRwhje4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Te8KoT86; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723470321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7vPIBP2a9yupeSh/dTtIjIhVHAEaR6O7IF7oJLTZlss=;
	b=Te8KoT86Agc628rl3kVeA7m0vcuzoOnAkLe+eT0X9RfwGXM+2ahGGIRm5G5DrGs1L6RxhQ
	CREKtkAZUXw7/fVeT1PWOx+P6UqTdVzFDwQEgfWry4DntLi52iecwvTQCp8tJZhKI0Fvqa
	z0YeeqzKC3OCmcBqsCiMzO0fzFXml1I=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH v2 7/7] riscv: mmu: Ensure order of PTE update and sfence
Date: Mon, 12 Aug 2024 15:44:59 +0200
Message-ID: <20240812134451.112498-16-andrew.jones@linux.dev>
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

Use WRITE_ONCE to ensure the compiler won't order the page table
write after the TLB flush.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 lib/riscv/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/riscv/mmu.c b/lib/riscv/mmu.c
index ce49e67be84b..577c66aa77ba 100644
--- a/lib/riscv/mmu.c
+++ b/lib/riscv/mmu.c
@@ -64,7 +64,8 @@ static pteval_t *__install_page(pgd_t *pgtable, phys_addr_t paddr,
 	assert(!(ppn & ~PTE_PPN));
 
 	ptep = get_pte(pgtable, vaddr);
-	*ptep = __pte(pte | pgprot_val(prot) | _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_DIRTY);
+	pte |= pgprot_val(prot) | _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_DIRTY;
+	WRITE_ONCE(*ptep, __pte(pte));
 
 	if (flush)
 		local_flush_tlb_page(vaddr);
-- 
2.45.2


