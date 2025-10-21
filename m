Return-Path: <kvm+bounces-60623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA91EBF5155
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:51:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B5AC1882E36
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5FBF2ECD19;
	Tue, 21 Oct 2025 07:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JpzaxnZJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A22A27781D
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032933; cv=none; b=m9xye2DOG1RYbX7eKSs2PL1oE2Nr9Ggrkp77wfOA+w48b/tNVtNX0GJpxts0OpRBtvWQzbFkLp6DwoIotjFt537EwjAZIqVZwf6LQDiafSY1OwzPcUjYwLxiOhhVD2Zx0+34pTecetpEH4HOd5IZfhedCc8WmwijvZlIlANXuwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032933; c=relaxed/simple;
	bh=QMV5SQvBkBbcpMvCiQUR2nhYeO0rDEmSV4BK+AA4VK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVMdCrWlzpUeIKiBzpo/ZgR5KOLRNJORV9Yd8TJJPooqpufUuPhu7iSJFGhIBKkVSW/H3SQ7u2X9IU1cSpiPNfjlpfloB7eEMgrp96MAUtHawyMnRbQ2Ra2fWegivHYQCCB8v3dnVQrXI5631hJaokCPihjPAkTqQUYnF6lIT7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JpzaxnZJ; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kaqUgIzfA70/v+FwtaquFzSjQwTE2DOer6LTTMiWZzs=;
	b=JpzaxnZJ9BJ3bFSwGAbUdpfWFjL9R0aReRMUTrAFGrrnXtYivXWQPT3IjKggcvjnlZpEQk
	wpjiY1Xf+UGvFqSlvJFunXVs6xxwMlWwZXDFvbTKNKWx8EXAwhP/8casjW+pRqt8Gdk4yz
	xZrJslOOAAAxLgSdINMKMRQEmvoiCbg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 13/23] KVM: selftests: Pass the root GPA into virt_get_pte()
Date: Tue, 21 Oct 2025 07:47:26 +0000
Message-ID: <20251021074736.1324328-14-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Instead of hardcoding the root check against vm->pgd, pass the root_gpa
into virt_get_pte(). There's a subtle change here, instead of checking
that the parent pointer has the address of vm->pgd, check if the value
pointed at by the parent pointer is the root_gpa. No change in behavior
expected, but this will be required for following changes that
generalize __virt_pg_map() to other MMUs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/lib/x86/processor.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 8a838f208abe4..92a2b5aefd880 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -179,15 +179,15 @@ const struct pte_masks x86_pte_masks = {
 	.nx		=	BIT_ULL(63),
 };
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-			  uint64_t vaddr, int level,
+static void *virt_get_pte(struct kvm_vm *vm, vm_paddr_t root_gpa,
+			  uint64_t *parent_pte, uint64_t vaddr, int level,
 			  const struct pte_masks *masks)
 {
 	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte & masks->present) || parent_pte == &vm->pgd,
+	TEST_ASSERT((*parent_pte == root_gpa) || (*parent_pte & masks->present),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -195,6 +195,7 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
 }
 
 static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
+				       vm_paddr_t root_gpa,
 				       uint64_t *parent_pte,
 				       uint64_t vaddr,
 				       uint64_t paddr,
@@ -202,7 +203,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 				       int target_level,
 				       const struct pte_masks *masks)
 {
-	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level, masks);
+	uint64_t *pte = virt_get_pte(vm, root_gpa, parent_pte,
+				     vaddr, current_level, masks);
 
 	paddr = vm_untag_gpa(vm, paddr);
 
@@ -259,13 +261,14 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	 * early if a hugepage was created.
 	 */
 	for (current_level = vm->pgtable_levels; current_level > PG_LEVEL_4K; current_level--) {
-		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level, masks);
+		pte = virt_create_upper_pte(vm, vm->pgd, pte, vaddr, paddr,
+					    current_level, level, masks);
 		if (*pte & masks->large)
 			return;
 	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K, masks);
+	pte = virt_get_pte(vm, vm->pgd, pte, vaddr, PG_LEVEL_4K, masks);
 	TEST_ASSERT(!(*pte & masks->present),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = masks->present | masks->writeable | (paddr & PHYSICAL_PAGE_MASK);
@@ -348,7 +351,7 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
 		"Canonical check failed.  The virtual address is invalid.");
 
 	for (current_level = vm->pgtable_levels; current_level >= PG_LEVEL_4K; current_level--) {
-		pte = virt_get_pte(vm, pte, vaddr, current_level, masks);
+		pte = virt_get_pte(vm, vm->pgd, pte, vaddr, current_level, masks);
 		if (vm_is_target_pte(pte, level, current_level, masks))
 			return pte;
 	}
-- 
2.51.0.869.ge66316f041-goog


