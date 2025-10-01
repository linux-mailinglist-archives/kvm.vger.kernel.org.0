Return-Path: <kvm+bounces-59309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84DB3BB0EC5
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39AAF19C1977
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:03:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE3530C36E;
	Wed,  1 Oct 2025 14:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bYrSxoPg"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F6B30AD14
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330735; cv=none; b=QA+BupZW4rsWf2+aT24WD7SB1ZmV4tN+pDEVsdvdisyqXe3t3Tt69BAya3F7Y6gkFohBRnvPsKdYUEVCu26Z+TiI5PgcmGdD7O3VtGr2xUqJnsgMQ0TKnByspiNVbfkWeAnVRLwTAXJOjYxjC5pxiYOy6R4J0Q/y1gcU2PrJIb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330735; c=relaxed/simple;
	bh=PoyR2ZY6GSsug/ZnMOiuT6hdgnY+8NNEflpyqeTNBAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFjDS/v8shoPT0k7SrY4/VeM6VYYTGuuJtzuvSiKJaoGFbAhd2Cc4q4jYh9M9Qt3C8l3QDSdQYN/ZLLQreYOwxCoWFNJ7elz9fppmIMuwS/XZxAns4L6uNc+XCtLLDthnUZVtnhrlbs44ENI3WIgcrGXrYVpv0agYQNLp9QqqLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bYrSxoPg; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pkZED150T2wLLTSKFE9dwj5Dxedh3WTVdUnAFT4nOkU=;
	b=bYrSxoPgzfbwEagdRuvobCtdcC1XKJsrbpkiwvuC6PxPWwggFlsPPv5OAja42NxFQ84F/H
	6VZ29bjw4WErwfVA4+3GqVTF4mMNyRTGKx6KA65rVRMJvF27BiUHI/QZDy3M7dM8ByvMna
	jongPK6gHcXP9c1f2+bLsOCOdnXuJ9Y=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 07/12] KVM: selftests: Pass the root HVA directly to nested mapping functions
Date: Wed,  1 Oct 2025 14:58:11 +0000
Message-ID: <20251001145816.1414855-8-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

The nested mapping functions used to create EPT mappings currently
accept a struct vmx_pages argument, only to get the EPT root from it
later. In preparation for generalizing these functions to work for NPTs,
pass the EPT root HVA directly instead.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/vmx.h |  8 +++----
 .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 24 +++++++++----------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  6 ++---
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index edb3c391b9824..06ae68cf9635c 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -559,13 +559,13 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_pg_map(void *root_hva, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr);
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map(void *root_hva, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map_memslot(void *root_hva, struct kvm_vm *vm,
 			uint32_t memslot);
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_identity_map_1g(void *root_hva, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 7f5d62a65c68a..7981e295cac70 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -70,11 +70,11 @@ void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
 	 * by the backing source.
 	 */
-	nested_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+	nested_identity_map_1g(vmx->eptp_hva, vm, 0, 0x100000000ULL);
 
 	start = align_down(memstress_args.gpa, PG_SIZE_1G);
 	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
-	nested_identity_map_1g(vmx, vm, start, end - start);
+	nested_identity_map_1g(vmx->eptp_hva, vm, start, end - start);
 }
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index d4d1208dd0238..04c4b97bcd1e7 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -394,11 +394,11 @@ static void nested_create_pte(struct kvm_vm *vm,
 }
 
 
-void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void __nested_pg_map(void *root_hva, struct kvm_vm *vm,
 		     uint64_t nested_paddr, uint64_t paddr, int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
+	struct eptPageTableEntry *pt = root_hva, *pte;
 	uint16_t index;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
@@ -445,10 +445,10 @@ void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 
 }
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_pg_map(void *root_hva, struct kvm_vm *vm,
 		   uint64_t nested_paddr, uint64_t paddr)
 {
-	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
+	__nested_pg_map(root_hva, vm, nested_paddr, paddr, PG_LEVEL_4K);
 }
 
 /*
@@ -468,7 +468,7 @@ void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void __nested_map(void *root_hva, struct kvm_vm *vm,
 		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
 		  int level)
 {
@@ -479,22 +479,22 @@ void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__nested_pg_map(vmx, vm, nested_paddr, paddr, level);
+		__nested_pg_map(root_hva, vm, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map(void *root_hva, struct kvm_vm *vm,
 		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
 {
-	__nested_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__nested_map(root_hva, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map_memslot(void *root_hva, struct kvm_vm *vm,
 			uint32_t memslot)
 {
 	sparsebit_idx_t i, last;
@@ -508,7 +508,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 		if (i > last)
 			break;
 
-		nested_map(vmx, vm,
+		nested_map(root_hva, vm,
 			   (uint64_t)i << vm->page_shift,
 			   (uint64_t)i << vm->page_shift,
 			   1 << vm->page_shift);
@@ -516,10 +516,10 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 }
 
 /* Identity map a region with 1GiB Pages. */
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_identity_map_1g(void *root_hva, struct kvm_vm *vm,
 			    uint64_t addr, uint64_t size)
 {
-	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+	__nested_map(root_hva, vm, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index fa512d033205f..21a57805e9780 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,9 +121,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm, 0);
-		nested_map_memslot(vmx, vm, 0);
-		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
-		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
+		nested_map_memslot(vmx->eptp_hva, vm, 0);
+		nested_map(vmx->eptp_hva, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096);
+		nested_map(vmx->eptp_hva, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-- 
2.51.0.618.g983fd99d29-goog


