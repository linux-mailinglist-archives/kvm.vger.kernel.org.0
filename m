Return-Path: <kvm+bounces-60624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC94BBF515B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74059188453F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BA92ECD31;
	Tue, 21 Oct 2025 07:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RKXTwJX0"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37D42D0283
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032933; cv=none; b=clv34X7F8nvOZ3uk7/aPMGIBCFjsmy0OQ6+wFDDMV5bh6OUhtb1bgpwA+eoKXyOaqgpNIawbFEEl8xfYFf75XbgJll4P8C5OTMlEsWXGAQog9OJk9v578uKJB2axR+waeStDJAKWkzdfsd6mN0tz2q4ByRGHOuWGr0gDBiR4kxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032933; c=relaxed/simple;
	bh=nwpKTYunhpR2I0MoWw1vUHuiJF4funA/hkV+m9fRtrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRVwQPmeBFONmRMMiv/zPLUcuFwF4HTs03UYudkOe4Wvj4p3zd3gXU3m4+M6ka7l2lzH9EC5tubUENMFMkugkPk3pNQOgZbhR/uiTRZ5YKTUnzGYIbrWJ+bpKCZTtudZRN+0WIctyL+nc0j0hymo+WLtz6Oh7Q3013Z9ljm7NFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RKXTwJX0; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gu9aKJgaFjqAioSjcKo6ytfp2sq+GCP1NpEqf7iOGR4=;
	b=RKXTwJX0QR7FdDc+zDFHY9HJGGzCceCN+8dnlp1HwdXNLJyoKJ3SlwGwOqeYikKRUIcjHM
	qGGilgGfioQeKVKGp1QslmYAn+QH9OhQqu+Uab3sAskkvLIijPcSECUvplxRHhGAiTe5Zk
	pyChKLPvKgpx4Bk0EAQzLNhfdiJ3fwU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 14/23] KVM: selftests: Pass the root GPA into __virt_pg_map()
Date: Tue, 21 Oct 2025 07:47:27 +0000
Message-ID: <20251021074736.1324328-15-yosry.ahmed@linux.dev>
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

Pass the root_gpa into __virt_pg_map() instead of assuming vm->pgd in
preparation for using it with other MMUs.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../testing/selftests/kvm/include/x86/processor.h  |  4 ++--
 tools/testing/selftests/kvm/lib/x86/processor.c    | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 8debe0df3ffca..2f0d83b6e5952 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1451,8 +1451,8 @@ struct pte_masks {
 
 extern const struct pte_masks x86_pte_masks;
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   int level, const struct pte_masks *masks);
+void __virt_pg_map(struct kvm_vm *vm, vm_paddr_t root_gpa, uint64_t vaddr,
+		   uint64_t paddr, int level, const struct pte_masks *masks);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 92a2b5aefd880..13e9376d5f545 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -230,11 +230,11 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		   int level, const struct pte_masks *masks)
+void __virt_pg_map(struct kvm_vm *vm, vm_paddr_t root_gpa, uint64_t vaddr,
+		   uint64_t paddr, int level, const struct pte_masks *masks)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pte = &vm->pgd;
+	uint64_t *pte = &root_gpa;
 	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K ||
@@ -261,14 +261,14 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	 * early if a hugepage was created.
 	 */
 	for (current_level = vm->pgtable_levels; current_level > PG_LEVEL_4K; current_level--) {
-		pte = virt_create_upper_pte(vm, vm->pgd, pte, vaddr, paddr,
+		pte = virt_create_upper_pte(vm, root_gpa, pte, vaddr, paddr,
 					    current_level, level, masks);
 		if (*pte & masks->large)
 			return;
 	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, vm->pgd, pte, vaddr, PG_LEVEL_4K, masks);
+	pte = virt_get_pte(vm, root_gpa, pte, vaddr, PG_LEVEL_4K, masks);
 	TEST_ASSERT(!(*pte & masks->present),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = masks->present | masks->writeable | (paddr & PHYSICAL_PAGE_MASK);
@@ -285,7 +285,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K, &x86_pte_masks);
+	__virt_pg_map(vm, vm->pgd, vaddr, paddr, PG_LEVEL_4K, &x86_pte_masks);
 }
 
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -300,7 +300,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, vaddr, paddr, level, &x86_pte_masks);
+		__virt_pg_map(vm, vm->pgd, vaddr, paddr, level, &x86_pte_masks);
 		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
-- 
2.51.0.869.ge66316f041-goog


