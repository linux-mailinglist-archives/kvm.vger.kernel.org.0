Return-Path: <kvm+bounces-59313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6D0BB0F01
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7860C165AE5
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41A8A30E82B;
	Wed,  1 Oct 2025 14:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="M74zuC+x"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6E30DD01
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330743; cv=none; b=UOn9rvbDGTi3LX+OG8Vg/sFB0bLO1uULxzh2Y9qunHthQEVz6aJLNTypAcmr2XgKIHzSyolU37f2oSTbrUhRmJG9ps5cHUgtnhVnnqo+UZMi209KxA68EQ4z1hYWQkifMiVbN1+Zr6S5V0Dwa8WtR+VxUTPgRzjHcPup1gGPPwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330743; c=relaxed/simple;
	bh=cTQXGUYVVEI0C0zMAxK/fgTuCww5s7JNxb7uIbmmSuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1p5ieyXwD5cadb3DDgnM3WREeqmOCgsiyKvOh7bggPNWyVGJ+fjRix5Z0OTRxIy8x1LtGXpAFfn5rZV04kuinLSGG57r8tCsOGuk8+g31hXhDE2K+d2jcAhjHtZCrbE1ZLjeo9Y6mNSUzW66Ep1A1w27I9GcdmlFnp1FaRw4YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=M74zuC+x; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ibrGkq3SxosgUA5keIrPxQk0XJRBo1woRRNtpr/YYnE=;
	b=M74zuC+x1/Ccv0M9v1P9jcUvWiAbo/kSQvydEatpnYA3fUEHx7/LLd+oKL4dklO1ZflvJf
	zJDN2283ArjLom2L5qbKpgMKbGqcSvkOAVjvlxNIyPH+f/35F1iYo+1GLqUnvjmvdE3P5x
	XePzus2KAkxth1TP84N7MygvPFhUwcg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 11/12] KVM: selftests: Refactor generic nested mapping outside VMX code
Date: Wed,  1 Oct 2025 14:58:15 +0000
Message-ID: <20251001145816.1414855-12-yosry.ahmed@linux.dev>
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

Now that the nested mapping functions in vmx.c are all generic except
for nested_ept_create_pte(), move them all out into a new nested_map.c
lib file and expose nested_ept_create_pte() in vmx.h. This allows
reusing the code for NPT in following changes.

While we're at it, merge nested_pg_map() and __nested_pg_map(), as the
former is unused, and make sure all functions not exposed in the header
are static.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/nested_map.h    |  20 +++
 tools/testing/selftests/kvm/include/x86/vmx.h |  13 +-
 .../testing/selftests/kvm/lib/x86/memstress.c |   1 +
 .../selftests/kvm/lib/x86/nested_map.c        | 150 +++++++++++++++++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 155 +-----------------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |   1 +
 7 files changed, 183 insertions(+), 158 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86/nested_map.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86/nested_map.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 9b3c99acd51a3..9547d7263e236 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -23,6 +23,7 @@ LIBKVM_x86 += lib/x86/apic.c
 LIBKVM_x86 += lib/x86/handlers.S
 LIBKVM_x86 += lib/x86/hyperv.c
 LIBKVM_x86 += lib/x86/memstress.c
+LIBKVM_x86 += lib/x86/nested_map.c
 LIBKVM_x86 += lib/x86/pmu.c
 LIBKVM_x86 += lib/x86/processor.c
 LIBKVM_x86 += lib/x86/sev.c
diff --git a/tools/testing/selftests/kvm/include/x86/nested_map.h b/tools/testing/selftests/kvm/include/x86/nested_map.h
new file mode 100644
index 0000000000000..362162dd6db43
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86/nested_map.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/nested_map.h
+ *
+ * Copyright (C) 2025, Google LLC.
+ */
+
+#ifndef SELFTEST_KVM_NESTED_MAP_H
+#define SELFTEST_KVM_NESTED_MAP_H
+
+#include "kvm_util.h"
+
+void nested_map(void *root_hva, struct kvm_vm *vm,
+		uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void nested_map_memslot(void *root_hva, struct kvm_vm *vm,
+			uint32_t memslot);
+void nested_identity_map_1g(void *root_hva, struct kvm_vm *vm,
+			    uint64_t addr, uint64_t size);
+
+#endif /* SELFTEST_KVM_NESTED_MAP_H */
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 06ae68cf9635c..49d763144dbfe 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -559,14 +559,11 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void nested_pg_map(void *root_hva, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr);
-void nested_map(void *root_hva, struct kvm_vm *vm,
-		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(void *root_hva, struct kvm_vm *vm,
-			uint32_t memslot);
-void nested_identity_map_1g(void *root_hva, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size);
+bool nested_ept_create_pte(struct kvm_vm *vm,
+			   uint64_t *pte,
+			   uint64_t paddr,
+			   uint64_t *address,
+			   bool *leaf);
 bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 7981e295cac70..d3e2fbd550acd 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -12,6 +12,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "memstress.h"
+#include "nested_map.h"
 #include "processor.h"
 #include "vmx.h"
 
diff --git a/tools/testing/selftests/kvm/lib/x86/nested_map.c b/tools/testing/selftests/kvm/lib/x86/nested_map.c
new file mode 100644
index 0000000000000..454ab3e2f5b7e
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86/nested_map.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * tools/testing/selftests/kvm/lib/x86_64/nested_map.c
+ *
+ * Copyright (C) 2025, Google LLC.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "nested_map.h"
+#include "vmx.h"
+
+static uint64_t nested_create_pte(struct kvm_vm *vm,
+				  uint64_t *pte,
+				  uint64_t nested_paddr,
+				  uint64_t paddr,
+				  int level,
+				  bool want_leaf)
+{
+	bool leaf = want_leaf;
+	uint64_t address;
+
+	if (!nested_ept_create_pte(vm, pte, paddr, &address, &leaf)) {
+		TEST_ASSERT(!want_leaf,
+			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
+			    level, nested_paddr);
+		TEST_ASSERT(!leaf,
+			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
+			    level, nested_paddr);
+	}
+	return address;
+}
+
+static void nested_pg_map(void *root_hva, struct kvm_vm *vm, uint64_t
+			  nested_paddr, uint64_t paddr, int target_level)
+{
+	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
+	uint64_t *pt = root_hva, *pte;
+	uint16_t index, address;
+	bool leaf;
+
+	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
+		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
+
+	TEST_ASSERT((nested_paddr >> 48) == 0,
+		    "Nested physical address 0x%lx requires 5-level paging",
+		    nested_paddr);
+	TEST_ASSERT((nested_paddr % page_size) == 0,
+		    "Nested physical address not on page boundary,\n"
+		    "  nested_paddr: 0x%lx page_size: 0x%lx",
+		    nested_paddr, page_size);
+	TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
+		    "Physical address beyond beyond maximum supported,\n"
+		    "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT((paddr % page_size) == 0,
+		    "Physical address not on page boundary,\n"
+		    "  paddr: 0x%lx page_size: 0x%lx",
+		    paddr, page_size);
+	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
+		    "Physical address beyond beyond maximum supported,\n"
+		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
+		    paddr, vm->max_gfn, vm->page_size);
+
+	for (int level = PG_LEVEL_512G; level >= PG_LEVEL_4K; level--) {
+		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
+		pte = &pt[index];
+		leaf = (level == target_level);
+
+		address = nested_create_pte(vm, pte, nested_paddr, paddr, level, leaf);
+
+		if (leaf)
+			break;
+
+		pt = addr_gpa2hva(vm, address * vm->page_size);
+	}
+
+}
+
+/*
+ * Map a range of EPT guest physical addresses to the VM's physical address
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   nested_paddr - Nested guest physical address to map
+ *   paddr - VM Physical Address
+ *   size - The size of the range to map
+ *   level - The level at which to map the range
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within the VM given by vm, creates a nested guest translation for the
+ * page range starting at nested_paddr to the page range starting at paddr.
+ */
+static void __nested_map(void *root_hva, struct kvm_vm *vm, uint64_t
+			 nested_paddr, uint64_t paddr, uint64_t size, int level)
+{
+	size_t page_size = PG_LEVEL_SIZE(level);
+	size_t npages = size / page_size;
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	while (npages--) {
+		nested_pg_map(root_hva, vm, nested_paddr, paddr, level);
+		nested_paddr += page_size;
+		paddr += page_size;
+	}
+}
+
+void nested_map(void *root_hva, struct kvm_vm *vm,
+		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+{
+	__nested_map(root_hva, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+}
+
+/*
+ * Prepare an identity nested page table that maps all the
+ * physical pages in VM.
+ */
+void nested_map_memslot(void *root_hva, struct kvm_vm *vm,
+			uint32_t memslot)
+{
+	sparsebit_idx_t i, last;
+	struct userspace_mem_region *region =
+		memslot2region(vm, memslot);
+
+	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
+	last = i + (region->region.memory_size >> vm->page_shift);
+	for (;;) {
+		i = sparsebit_next_clear(region->unused_phy_pages, i);
+		if (i > last)
+			break;
+
+		nested_map(root_hva, vm,
+			   (uint64_t)i << vm->page_shift,
+			   (uint64_t)i << vm->page_shift,
+			   1 << vm->page_shift);
+	}
+}
+
+/* Identity map a region with 1GiB Pages. */
+void nested_identity_map_1g(void *root_hva, struct kvm_vm *vm,
+			    uint64_t addr, uint64_t size)
+{
+	__nested_map(root_hva, vm, addr, addr, size, PG_LEVEL_1G);
+}
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index eeacf42bf30b1..24345213fcd04 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -365,11 +365,11 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-static bool nested_ept_create_pte(struct kvm_vm *vm,
-				  uint64_t *pte,
-				  uint64_t paddr,
-				  uint64_t *address,
-				  bool *leaf)
+bool nested_ept_create_pte(struct kvm_vm *vm,
+			   uint64_t *pte,
+			   uint64_t paddr,
+			   uint64_t *address,
+			   bool *leaf)
 {
 	struct eptPageTableEntry *epte = (struct eptPageTableEntry *)pte;
 
@@ -401,151 +401,6 @@ static bool nested_ept_create_pte(struct kvm_vm *vm,
 	return true;
 }
 
-static uint64_t nested_create_pte(struct kvm_vm *vm,
-				  uint64_t *pte,
-				  uint64_t nested_paddr,
-				  uint64_t paddr,
-				  int level,
-				  bool want_leaf)
-{
-	bool leaf = want_leaf;
-	uint64_t address;
-
-	if (!nested_ept_create_pte(vm, pte, paddr, &address, &leaf)) {
-		TEST_ASSERT(!want_leaf,
-			    "Cannot create leaf entry at level: %u, nested_paddr: 0x%lx",
-			    level, nested_paddr);
-		TEST_ASSERT(!leaf,
-			    "Leaf entry already exists at level: %u, nested_paddr: 0x%lx",
-			    level, nested_paddr);
-	}
-	return address;
-}
-
-
-void __nested_pg_map(void *root_hva, struct kvm_vm *vm,
-		     uint64_t nested_paddr, uint64_t paddr, int target_level)
-{
-	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	uint64_t *pt = root_hva, *pte;
-	uint16_t index, address;
-	bool leaf;
-
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
-		    "unknown or unsupported guest mode, mode: 0x%x", vm->mode);
-
-	TEST_ASSERT((nested_paddr >> 48) == 0,
-		    "Nested physical address 0x%lx requires 5-level paging",
-		    nested_paddr);
-	TEST_ASSERT((nested_paddr % page_size) == 0,
-		    "Nested physical address not on page boundary,\n"
-		    "  nested_paddr: 0x%lx page_size: 0x%lx",
-		    nested_paddr, page_size);
-	TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
-		    "Physical address beyond beyond maximum supported,\n"
-		    "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		    paddr, vm->max_gfn, vm->page_size);
-	TEST_ASSERT((paddr % page_size) == 0,
-		    "Physical address not on page boundary,\n"
-		    "  paddr: 0x%lx page_size: 0x%lx",
-		    paddr, page_size);
-	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
-		    "Physical address beyond beyond maximum supported,\n"
-		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		    paddr, vm->max_gfn, vm->page_size);
-
-	for (int level = PG_LEVEL_512G; level >= PG_LEVEL_4K; level--) {
-		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
-		pte = &pt[index];
-		leaf = (level == target_level);
-
-		address = nested_create_pte(vm, pte, nested_paddr, paddr, level, leaf);
-
-		if (leaf)
-			break;
-
-		pt = addr_gpa2hva(vm, address * vm->page_size);
-	}
-
-}
-
-void nested_pg_map(void *root_hva, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
-{
-	__nested_pg_map(root_hva, vm, nested_paddr, paddr, PG_LEVEL_4K);
-}
-
-/*
- * Map a range of EPT guest physical addresses to the VM's physical address
- *
- * Input Args:
- *   vm - Virtual Machine
- *   nested_paddr - Nested guest physical address to map
- *   paddr - VM Physical Address
- *   size - The size of the range to map
- *   level - The level at which to map the range
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within the VM given by vm, creates a nested guest translation for the
- * page range starting at nested_paddr to the page range starting at paddr.
- */
-void __nested_map(void *root_hva, struct kvm_vm *vm,
-		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
-		  int level)
-{
-	size_t page_size = PG_LEVEL_SIZE(level);
-	size_t npages = size / page_size;
-
-	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
-	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
-
-	while (npages--) {
-		__nested_pg_map(root_hva, vm, nested_paddr, paddr, level);
-		nested_paddr += page_size;
-		paddr += page_size;
-	}
-}
-
-void nested_map(void *root_hva, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
-{
-	__nested_map(root_hva, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
-}
-
-/* Prepare an identity extended page table that maps all the
- * physical pages in VM.
- */
-void nested_map_memslot(void *root_hva, struct kvm_vm *vm,
-			uint32_t memslot)
-{
-	sparsebit_idx_t i, last;
-	struct userspace_mem_region *region =
-		memslot2region(vm, memslot);
-
-	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
-	last = i + (region->region.memory_size >> vm->page_shift);
-	for (;;) {
-		i = sparsebit_next_clear(region->unused_phy_pages, i);
-		if (i > last)
-			break;
-
-		nested_map(root_hva, vm,
-			   (uint64_t)i << vm->page_shift,
-			   (uint64_t)i << vm->page_shift,
-			   1 << vm->page_shift);
-	}
-}
-
-/* Identity map a region with 1GiB Pages. */
-void nested_identity_map_1g(void *root_hva, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size)
-{
-	__nested_map(root_hva, vm, addr, addr, size, PG_LEVEL_1G);
-}
-
 bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 21a57805e9780..db88a1e5e9d0c 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -11,6 +11,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "nested_map.h"
 #include "processor.h"
 #include "vmx.h"
 
-- 
2.51.0.618.g983fd99d29-goog


