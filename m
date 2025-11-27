Return-Path: <kvm+bounces-64814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C9DC8C942
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:38:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 25B8D350047
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2CF2BF3F4;
	Thu, 27 Nov 2025 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iWAfUKbo"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B3129BD87
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207324; cv=none; b=ookeC85VxjkRunF3NjiSkjtv3bNU50f9j9HyViDAmQvMqc94Ry0tRtV14TMqC+RQ5va87LMiM2/nuEdVQenlWi+uVk56BCRRNan9PMNZp7MkpZAFQkjquu1Dd8Kc9xNEcLioz9UAKBOt6Zs5QjdfOKTCNL3hUtTucme4JDI7kik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207324; c=relaxed/simple;
	bh=1DWJ0vq5Vnbhy9GpTMm1kM3h66r8u2AM0I+qwZIpt1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ6pfPJXzcjFl9wbmXWGt9yz4/1VSp0QQqiG0dMtpwR9Y/AMP1qrJB/FMIqH1e1D2XUPYwp/fgwyqCqwK7g+iraFx4H3cvPf97H6XSZUoc+AkZDN2SiiO703cyUTE89lEq81bgpueCC37EZ3QpGp9jbRKSDd3fZYH8RpDbP3qKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iWAfUKbo; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fRvdalb8Nz4KrVxtn9MByTFzTbfGayUg/tC+6ctnf4M=;
	b=iWAfUKboKdh5xonWPG0KNDL7cViftZuXMR4LaXsDEtJQJ4eYdlJOsEGrkFSGDYZTcSDN8O
	pM43h/xFg9CbM2sa9WL6JS1lrm2WRexO6KcmqJDNOfkWwanNru9kLWPbqUUk/z4GCgFKnG
	gubWwpk7wKovSFLQ6hparqCslg1UB1Q=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 14/16] KVM: selftests: Set the user bit on nested NPT PTEs
Date: Thu, 27 Nov 2025 01:34:38 +0000
Message-ID: <20251127013440.3324671-15-yosry.ahmed@linux.dev>
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

According to the APM, NPT walks are treated as user accesses. In
preparation for supporting NPT mappings, set the 'user' bit on NPTs by
adding a mask of bits to always be set on PTEs in kvm_mmu.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/processor.h | 4 ++++
 tools/testing/selftests/kvm/lib/x86/processor.c     | 6 ++++--
 tools/testing/selftests/kvm/lib/x86/svm.c           | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 920abd14f3a6..d41245e2521b 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1450,6 +1450,8 @@ struct pte_masks {
 	uint64_t x;
 	uint64_t c;
 	uint64_t s;
+
+	uint64_t always_set;
 };
 
 struct kvm_mmu {
@@ -1469,6 +1471,8 @@ struct kvm_mmu {
 #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
 #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
 
+#define PTE_ALWAYS_SET_MASK(mmu) ((mmu)->pte_masks.always_set)
+
 #define pte_present(mmu, pte) (!!(*(pte) & PTE_PRESENT_MASK(mmu)))
 #define pte_writable(mmu, pte) (!!(*(pte) & PTE_WRITABLE_MASK(mmu)))
 #define pte_user(mmu, pte) (!!(*(pte) & PTE_USER_MASK(mmu)))
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index b22c8c1bfdc3..749ae7522473 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -227,7 +227,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	paddr = vm_untag_gpa(vm, paddr);
 
 	if (!pte_present(mmu, pte)) {
-		*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | PTE_X_MASK(mmu);
+		*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu)
+			| PTE_X_MASK(mmu) | PTE_ALWAYS_SET_MASK(mmu);
 		if (current_level == target_level)
 			*pte |= PTE_HUGE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 		else
@@ -293,7 +294,8 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!pte_present(mmu, pte),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | PTE_X_MASK(mmu)
+	*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu)
+		| PTE_X_MASK(mmu) | PTE_ALWAYS_SET_MASK(mmu)
 		| (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index cf3b98802164..838f218545af 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -73,6 +73,9 @@ void vm_enable_npt(struct kvm_vm *vm)
 	pte_masks.c = 0;
 	pte_masks.s = 0;
 
+	/* NPT walks are treated as user accesses, so set the 'user' bit */
+	pte_masks.always_set = pte_masks.user;
+
 	vm->arch.nested.mmu = mmu_create(vm, vm->pgtable_levels, &pte_masks);
 }
 
-- 
2.52.0.158.g65b55ccf14-goog


