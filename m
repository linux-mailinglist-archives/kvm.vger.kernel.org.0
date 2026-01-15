Return-Path: <kvm+bounces-68205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4ABD27277
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2703A30CE2C2
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAB13A1E86;
	Thu, 15 Jan 2026 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PQovNdwv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15DE2D9494
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497721; cv=none; b=V1MMMhaVgoJsSP0U2rqOxEGXkMlD1eODGoVdPeDRS9tRf7hVci+mNZNyFKzZcfeAcgo9pJd47lxt12VCVhPrNSotps3NhE0u5HiXPCPnU26GBbyPZqs99vDX2aVrJFwVRHUrBo0DhirRHGOcpZuip4g1159nn0DBJFzu8X8jWf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497721; c=relaxed/simple;
	bh=TNIz5IARBDbTWNboxMQA4GejKtpr9IQdS6SRlsz1/04=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pWAWJJe+VVwIB0LB5zaMC30TYbUDJRFFkUjshXKvAb5Z7d8qvEJ8u/+2mPTNt1qyVs9c3y+/E9CCC4LWp37mL51wfCtgKDsYytjmD/25Y4s3KCBUzZpZV8CGyMGcb9AFEOkAM+Dh4SpBezRXVQcenrd/Nrp8jAPzUS1e4eEaYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PQovNdwv; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a31087af17so12625415ad.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768497719; x=1769102519; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gKOSVpFyQ9XN1hofqpQ+NZX4AdN5kyrx+sAWKyXNk5w=;
        b=PQovNdwvA5AAkkgFc2I49aR1Ua1N26iBvYhF9Y49/knN8tJWxbEuGTYoIdnbuL1suw
         v56euRUH66RXtEtRVGcOlWsRQbzaQSI+wxVw4SjAw6m28SWh581lv8pOmETOps9azk6U
         nurpjZsicplhufcHFflal6uYYlnSwV7LfKws2UhSw5CCmEruFUX3AXTXFUe45lU5AVWC
         4fXZdPgbczL8svj2ZBEmRtP5+so+zp9ySOvGI3K1WbEvHzy5y/I5DJAQs5y9T6Hnz16G
         JB5ac3y66UxghFFzoU8ZzQY2nAzrYJawtYIQ1bJHfajBQXKp869on0Pq416Cv6gtVA7I
         P01A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768497719; x=1769102519;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gKOSVpFyQ9XN1hofqpQ+NZX4AdN5kyrx+sAWKyXNk5w=;
        b=IoZgRV8eI+bO6G4USig9VbfyAx/6k+xC7h6drQ8hm4AdvHLOiwmjooWc99/cLp+gcG
         D5ikGdEvhMrDhUnw6tC9xD6AuOQg1DGaq2rqHNDoqByyQg8C/NEU/LIVdXtA1rHFdu7Q
         QZ3oOZjFijNcf3CTLO+NMJCdEyOwt1wzHWG7dLRejTti7RTcJE/415SK0twn7ehCYMiC
         KOzQpduURMlTkcTOMme4h3ElmpeJK3sd/yxNRtt++JqWxms8iSaJXOMoFxDtX2ToO9f4
         k6zdxV7o3ZJiIqeVO3cx59G25PKNU/BZ+Iu2P14Da8DxPop2K/wN6YUlQaz38FLOCiIX
         4rhg==
X-Gm-Message-State: AOJu0Ywf7Y9uQ0Hddb6LQ+EQ2ZLg8V9qmhN5qR6rGLvE3qlQ4/M9EK5g
	19NDUbhhxTOM9UPu2mi9aBZKWvv3oux3dUFSZVpdWsmUBOxyO/YvfH8NFvpKzBFxjG5eNpFgMnJ
	bNajIKQ==
X-Received: from plrt17.prod.google.com ([2002:a17:902:b211:b0:2a0:86eb:ac5f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f645:b0:2a0:daa7:8a3d
 with SMTP id d9443c01a7336-2a717548d83mr2239485ad.23.1768497719230; Thu, 15
 Jan 2026 09:21:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 15 Jan 2026 09:21:54 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115172154.709024-1-seanjc@google.com>
Subject: [PATCH v5] KVM: selftests: Test READ=>WRITE dirty logging behavior
 for shadow MMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Update the nested dirty log test to validate KVM's handling of READ faults
when dirty logging is enabled.  Specifically, set the Dirty bit in the
guest PTEs used to map L2 GPAs, so that KVM will create writable SPTEs
when handling L2 read faults.  When handling read faults in the shadow MMU,
KVM opportunistically creates a writable SPTE if the mapping can be
writable *and* the gPTE is dirty (or doesn't support the Dirty bit), i.e.
if KVM doesn't need to intercept writes in order to emulate Dirty-bit
updates.

To actually test the L2 READ=>WRITE sequence, e.g. without masking a false
pass by other test activity, route the READ=>WRITE and WRITE=>WRITE
sequences to separate L1 pages, and differentiate between "marked dirty
due to a WRITE access/fault" and "marked dirty due to creating a writable
SPTE for a READ access/fault".  The updated sequence exposes the bug fixed
by KVM commit 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration
with PML") when the guest performs a READ=>WRITE sequence with dirty guest
PTEs.

Opportunistically tweak and rename the address macros, and add comments,
to make it more obvious what the test is doing.  E.g. NESTED_TEST_MEM1
vs. GUEST_TEST_MEM doesn't make it all that obvious that the test is
creating aliases in both the L2 GPA and GVA address spaces, but only when
L1 is using TDP to run L2.

Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

v5:
 - Drop all other patches (already applied).
 - Eliminate hardcoding of page indices. [Yosry]
 - Add macros to handle getting various addresses. [Yosry]
 - Add comments to explain what the test is doing.
 - Keep the non-aliased pages contiguous so that the aliases can be
   computed and reverse engineered with a simple offset.
 - Clean up the for-loop checking of the results. [Yosry]

v4 (de facto v1 for this patch):
 - https://lore.kernel.org/all/20251230230150.4150236-1-seanjc@google.com
 - Make it clear PTE accessors are predicates.
 - Add a patch to extend the nested_dirty_log_test to verify that KVM creates
   writable SPTEs when the gPTEs are writable and dirty.

 .../selftests/kvm/include/x86/processor.h     |   1 +
 .../testing/selftests/kvm/lib/x86/processor.c |   7 +
 .../selftests/kvm/x86/nested_dirty_log_test.c | 186 +++++++++++++-----
 3 files changed, 143 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 6bfffc3b0a33..4ebae4269e68 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1486,6 +1486,7 @@ bool kvm_cpu_has_tdp(void);
 void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
+uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index ab869a98bbdc..fab18e9be66c 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -390,6 +390,13 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
 	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 }
 
+uint64_t *tdp_get_pte(struct kvm_vm *vm, uint64_t l2_gpa)
+{
+	int level = PG_LEVEL_4K;
+
+	return __vm_get_page_table_entry(vm, &vm->stage2_mmu, l2_gpa, &level);
+}
+
 uint64_t *vm_get_pte(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
diff --git a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
index 89d2e86a0db9..9a3b9556ef02 100644
--- a/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_dirty_log_test.c
@@ -17,29 +17,55 @@
 
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
-#define TEST_MEM_PAGES			3
 
-/* L1 guest test virtual memory offset */
-#define GUEST_TEST_MEM			0xc0000000
+/*
+ * Allocate four pages total.  Two pages are used to verify that the KVM marks
+ * the accessed page/GFN as marked dirty, but not the "other" page.  Times two
+ * so that each "normal" page can be accessed from L2 via an aliased L2 GVA+GPA
+ * (when TDP is enabled), to verify KVM marks _L1's_ page/GFN as dirty (to
+ * detect failures, L2 => L1 GPAs can't be identity mapped in the TDP page
+ * tables, as marking L2's GPA dirty would get a false pass if L1 == L2).
+ */
+#define TEST_MEM_PAGES			4
 
-/* L2 guest test virtual memory offset */
-#define NESTED_TEST_MEM1		0xc0001000
-#define NESTED_TEST_MEM2		0xc0002000
+#define TEST_MEM_BASE			0xc0000000
+#define TEST_MEM_ALIAS_BASE		0xc0002000
+
+#define TEST_GUEST_ADDR(base, idx)	((base) + (idx) * PAGE_SIZE)
+
+#define TEST_GVA(idx)			TEST_GUEST_ADDR(TEST_MEM_BASE, idx)
+#define TEST_GPA(idx)			TEST_GUEST_ADDR(TEST_MEM_BASE, idx)
+
+#define TEST_ALIAS_GPA(idx)		TEST_GUEST_ADDR(TEST_MEM_ALIAS_BASE, idx)
+
+#define TEST_HVA(vm, idx)		addr_gpa2hva(vm, TEST_GPA(idx))
 
 #define L2_GUEST_STACK_SIZE 64
 
-static void l2_guest_code(u64 *a, u64 *b)
+/* Use the page offset bits to communicate the access+fault type. */
+#define TEST_SYNC_READ_FAULT		BIT(0)
+#define TEST_SYNC_WRITE_FAULT		BIT(1)
+#define TEST_SYNC_NO_FAULT		BIT(2)
+
+static void l2_guest_code(vm_vaddr_t base)
 {
-	READ_ONCE(*a);
-	WRITE_ONCE(*a, 1);
-	GUEST_SYNC(true);
-	GUEST_SYNC(false);
+	vm_vaddr_t page0 = TEST_GUEST_ADDR(base, 0);
+	vm_vaddr_t page1 = TEST_GUEST_ADDR(base, 1);
 
-	WRITE_ONCE(*b, 1);
-	GUEST_SYNC(true);
-	WRITE_ONCE(*b, 1);
-	GUEST_SYNC(true);
-	GUEST_SYNC(false);
+	READ_ONCE(*(u64 *)page0);
+	GUEST_SYNC(page0 | TEST_SYNC_READ_FAULT);
+	WRITE_ONCE(*(u64 *)page0, 1);
+	GUEST_SYNC(page0 | TEST_SYNC_WRITE_FAULT);
+	READ_ONCE(*(u64 *)page0);
+	GUEST_SYNC(page0 | TEST_SYNC_NO_FAULT);
+
+	WRITE_ONCE(*(u64 *)page1, 1);
+	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
+	WRITE_ONCE(*(u64 *)page1, 1);
+	GUEST_SYNC(page1 | TEST_SYNC_WRITE_FAULT);
+	READ_ONCE(*(u64 *)page1);
+	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
+	GUEST_SYNC(page1 | TEST_SYNC_NO_FAULT);
 
 	/* Exit to L1 and never come back.  */
 	vmcall();
@@ -47,13 +73,22 @@ static void l2_guest_code(u64 *a, u64 *b)
 
 static void l2_guest_code_tdp_enabled(void)
 {
-	l2_guest_code((u64 *)NESTED_TEST_MEM1, (u64 *)NESTED_TEST_MEM2);
+	/*
+	 * Use the aliased virtual addresses when running with TDP to verify
+	 * that KVM correctly handles the case where a page is dirtied via a
+	 * different GPA than would be used by L1.
+	 */
+	l2_guest_code(TEST_MEM_ALIAS_BASE);
 }
 
 static void l2_guest_code_tdp_disabled(void)
 {
-	/* Access the same L1 GPAs as l2_guest_code_tdp_enabled() */
-	l2_guest_code((u64 *)GUEST_TEST_MEM, (u64 *)GUEST_TEST_MEM);
+	/*
+	 * Use the "normal" virtual addresses when running without TDP enabled,
+	 * in which case L2 will use the same page tables as L1, and thus needs
+	 * to use the same virtual addresses that are mapped into L1.
+	 */
+	l2_guest_code(TEST_MEM_BASE);
 }
 
 void l1_vmx_code(struct vmx_pages *vmx)
@@ -72,9 +107,9 @@ void l1_vmx_code(struct vmx_pages *vmx)
 
 	prepare_vmcs(vmx, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT(!vmlaunch());
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
 	GUEST_DONE();
 }
@@ -91,9 +126,9 @@ static void l1_svm_code(struct svm_test_data *svm)
 
 	generic_svm_setup(svm, l2_rip, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
 
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	run_guest(svm->vmcb, svm->vmcb_gpa);
-	GUEST_SYNC(false);
+	GUEST_SYNC(TEST_SYNC_NO_FAULT);
 	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
 	GUEST_DONE();
 }
@@ -106,12 +141,66 @@ static void l1_guest_code(void *data)
 		l1_svm_code(data);
 }
 
+static void test_handle_ucall_sync(struct kvm_vm *vm, u64 arg,
+				   unsigned long *bmap)
+{
+	vm_vaddr_t gva = arg & ~(PAGE_SIZE - 1);
+	int page_nr, i;
+
+	/*
+	 * Extract the page number of underlying physical page, which is also
+	 * the _L1_ page number.  The dirty bitmap _must_ be updated based on
+	 * the L1 GPA, not L2 GPA, i.e. whether or not L2 used an aliased GPA
+	 * (i.e. if TDP enabled for L2) is irrelevant with respect to the dirty
+	 * bitmap and which underlying physical page is accessed.
+	 *
+	 * Note, gva will be '0' if there was no access, i.e. if the purpose of
+	 * the sync is to verify all pages are clean.
+	 */
+	if (!gva)
+		page_nr = 0;
+	else if (gva >= TEST_MEM_ALIAS_BASE)
+		page_nr = (gva - TEST_MEM_ALIAS_BASE) >> PAGE_SHIFT;
+	else
+		page_nr = (gva - TEST_MEM_BASE) >> PAGE_SHIFT;
+	TEST_ASSERT(page_nr == 0 || page_nr == 1,
+		    "Test bug, unexpected frame number '%u' for arg = %lx", page_nr, arg);
+	TEST_ASSERT(gva || (arg & TEST_SYNC_NO_FAULT),
+		    "Test bug, gva must be valid if a fault is expected");
+
+	kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
+
+	/*
+	 * Check all pages to verify the correct physical page was modified (or
+	 * not), and that all pages are clean/dirty as expected.
+	 *
+	 * If a fault of any kind is expected, the target page should be dirty
+	 * as the Dirty bit is set in the gPTE.  KVM should create a writable
+	 * SPTE even on a read fault, *and* KVM must mark the GFN as dirty
+	 * when doing so.
+	 */
+	for (i = 0; i < TEST_MEM_PAGES; i++) {
+		if (i == page_nr && (arg & TEST_SYNC_WRITE_FAULT))
+			TEST_ASSERT(*(u64 *)TEST_HVA(vm, i) == 1,
+				    "Page %u incorrectly not written by guest", i);
+		else
+			TEST_ASSERT(*(u64 *)TEST_HVA(vm, i) == 0xaaaaaaaaaaaaaaaaULL,
+				    "Page %u incorrectly written by guest", i);
+
+		if (i == page_nr && !(arg & TEST_SYNC_NO_FAULT))
+			TEST_ASSERT(test_bit(i, bmap),
+				    "Page %u incorrectly reported clean on %s fault",
+				    i, arg & TEST_SYNC_READ_FAULT ? "read" : "write");
+		else
+			TEST_ASSERT(!test_bit(i, bmap),
+				    "Page %u incorrectly reported dirty", i);
+	}
+}
+
 static void test_dirty_log(bool nested_tdp)
 {
 	vm_vaddr_t nested_gva = 0;
 	unsigned long *bmap;
-	uint64_t *host_test_mem;
-
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	struct ucall uc;
@@ -133,35 +222,46 @@ static void test_dirty_log(bool nested_tdp)
 
 	/* Add an extra memory slot for testing dirty logging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
-				    GUEST_TEST_MEM,
+				    TEST_MEM_BASE,
 				    TEST_MEM_SLOT_INDEX,
 				    TEST_MEM_PAGES,
 				    KVM_MEM_LOG_DIRTY_PAGES);
 
 	/*
-	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
+	 * Add an identity map for GVA range [0xc0000000, 0xc0004000).  This
 	 * affects both L1 and L2.  However...
 	 */
-	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES);
+	virt_map(vm, TEST_MEM_BASE, TEST_MEM_BASE, TEST_MEM_PAGES);
 
 	/*
-	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
-	 * 0xc0000000.
+	 * ... pages in the L2 GPA address range [0xc0002000, 0xc0004000) will
+	 * map to [0xc0000000, 0xc0002000) when TDP is enabled (for L2).
 	 *
 	 * When TDP is disabled, the L2 guest code will still access the same L1
 	 * GPAs as the TDP enabled case.
+	 *
+	 * Set the Dirty bit in the PTEs used by L2 so that KVM will create
+	 * writable SPTEs when handling read faults (if the Dirty bit isn't
+	 * set, KVM must intercept the next write to emulate the Dirty bit
+	 * update).
 	 */
 	if (nested_tdp) {
 		tdp_identity_map_default_memslots(vm);
-		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vm, TEST_ALIAS_GPA(0), TEST_GPA(0), PAGE_SIZE);
+		tdp_map(vm, TEST_ALIAS_GPA(1), TEST_GPA(1), PAGE_SIZE);
+
+		*tdp_get_pte(vm, TEST_ALIAS_GPA(0)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
+		*tdp_get_pte(vm, TEST_ALIAS_GPA(1)) |= PTE_DIRTY_MASK(&vm->stage2_mmu);
+	} else {
+		*vm_get_pte(vm, TEST_GVA(0)) |= PTE_DIRTY_MASK(&vm->mmu);
+		*vm_get_pte(vm, TEST_GVA(1)) |= PTE_DIRTY_MASK(&vm->mmu);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-	host_test_mem = addr_gpa2hva(vm, GUEST_TEST_MEM);
 
 	while (!done) {
-		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
+		memset(TEST_HVA(vm, 0), 0xaa, TEST_MEM_PAGES * PAGE_SIZE);
+
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
@@ -170,23 +270,7 @@ static void test_dirty_log(bool nested_tdp)
 			REPORT_GUEST_ASSERT(uc);
 			/* NOT REACHED */
 		case UCALL_SYNC:
-			/*
-			 * The nested guest wrote at offset 0x1000 in the memslot, but the
-			 * dirty bitmap must be filled in according to L1 GPA, not L2.
-			 */
-			kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-			if (uc.args[1]) {
-				TEST_ASSERT(test_bit(0, bmap), "Page 0 incorrectly reported clean");
-				TEST_ASSERT(host_test_mem[0] == 1, "Page 0 not written by guest");
-			} else {
-				TEST_ASSERT(!test_bit(0, bmap), "Page 0 incorrectly reported dirty");
-				TEST_ASSERT(host_test_mem[0] == 0xaaaaaaaaaaaaaaaaULL, "Page 0 written by guest");
-			}
-
-			TEST_ASSERT(!test_bit(1, bmap), "Page 1 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[PAGE_SIZE / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 1 written by guest");
-			TEST_ASSERT(!test_bit(2, bmap), "Page 2 incorrectly reported dirty");
-			TEST_ASSERT(host_test_mem[PAGE_SIZE*2 / 8] == 0xaaaaaaaaaaaaaaaaULL, "Page 2 written by guest");
+			test_handle_ucall_sync(vm, uc.args[1], bmap);
 			break;
 		case UCALL_DONE:
 			done = true;

base-commit: acdc5446135932ca974b82d9d9a17762c7a82493
-- 
2.52.0.457.g6b5491de43-goog


