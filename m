Return-Path: <kvm+bounces-64811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 247A6C8C924
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA4133A80FC
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A4D27F18B;
	Thu, 27 Nov 2025 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ci8yM1TH"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DB1264F81
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207318; cv=none; b=SQAqLeYlnrw7jthIvaFaV4qConlJRhZhC4xtEbeLW1eSNZGlOAEg1fBJJau4vzcmMhCM0YbpkKqOBZpDpuqhbWFSxDH4OI9sHKbPU+jY0hhWJiuD6nRAKjV7a7GmKgZZPrVpGrPWkHiEGp46fB3+a0XkkomZw3GSjkse36+TLR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207318; c=relaxed/simple;
	bh=7jysPTyIv1P0d4kKSGjyAUuqEIOTtAMqKPjVlRhWESc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5BWgDDwCcBL71Do6HnyayDqMf/mOfI0khGXAvWE6WE2Y9xrKlNR0RNUBajlQ3oKljroV6H6uLec+tiCO/JAeHBwuNiPv9FDjJ0OpcKt5aNWYPg2O4jGJX41oD4LSW0GzhhZ/Zu9LahD6neNioJf+uwGkHqTBOGaKeUb9BoHVvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ci8yM1TH; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3foPKGFPq15EJ4a7jcZKNWZVI98HAc3xZlYw2h3wQY=;
	b=ci8yM1THYDgsePbAu2q9myzREAkoDertf2Y3fIZJpaSok/sUbgwiExJadhtU16O5B9liF2
	o44oUJ5S5d5qJbzNoJ5bDOErXqyb/18LVPLWbbqA83MtMEYF8ZQKhrSgrcYgpNG5w0jDeo
	BxzdaMsYzoMxS8p2piFc4vIrY4PTHSI=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 11/16] KVM: selftests: Move TDP mapping functions outside of vmx.c
Date: Thu, 27 Nov 2025 01:34:35 +0000
Message-ID: <20251127013440.3324671-12-yosry.ahmed@linux.dev>
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

Now that the functions are no longer VMX-specific, move them to
processor.c. Do a minor comment tweak replacing 'EPT' with 'TDP'.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/processor.h     |  4 ++
 tools/testing/selftests/kvm/include/x86/vmx.h |  3 -
 .../testing/selftests/kvm/lib/x86/processor.c | 71 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 71 -------------------
 4 files changed, 75 insertions(+), 74 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 62e10b296719..95216b513379 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1487,6 +1487,10 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void tdp_identity_map_default_memslots(struct kvm_vm *vm);
+void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 4dd4c2094ee6..92b918700d24 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -557,9 +557,6 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void tdp_identity_map_default_memslots(struct kvm_vm *vm);
-void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void vm_enable_ept(struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 8b0e17f8ca37..517a8185eade 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -467,6 +467,77 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
+/*
+ * Map a range of TDP guest physical addresses to the VM's physical address
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
+void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	       uint64_t size, int level)
+{
+	struct kvm_mmu *mmu = vm->arch.nested.mmu;
+	size_t page_size = PG_LEVEL_SIZE(level);
+	size_t npages = size / page_size;
+
+	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
+	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
+
+	while (npages--) {
+		__virt_pg_map(vm, mmu, nested_paddr, paddr, level);
+		nested_paddr += page_size;
+		paddr += page_size;
+	}
+}
+
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	     uint64_t size)
+{
+	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+}
+
+/* Prepare an identity extended page table that maps all the
+ * physical pages in VM.
+ */
+void tdp_identity_map_default_memslots(struct kvm_vm *vm)
+{
+	uint32_t s, memslot = 0;
+	sparsebit_idx_t i, last;
+	struct userspace_mem_region *region = memslot2region(vm, memslot);
+
+	/* Only memslot 0 is mapped here, ensure it's the only one being used */
+	for (s = 0; s < NR_MEM_REGIONS; s++)
+		TEST_ASSERT_EQ(vm->memslots[s], 0);
+
+	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
+	last = i + (region->region.memory_size >> vm->page_shift);
+	for (;;) {
+		i = sparsebit_next_clear(region->unused_phy_pages, i);
+		if (i > last)
+			break;
+
+		tdp_map(vm, (uint64_t)i << vm->page_shift,
+			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
+	}
+}
+
+/* Identity map a region with 1GiB Pages. */
+void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
+{
+	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
+}
+
 /*
  * Set Unusable Segment
  *
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 0cba31cae896..4289c9eb61ff 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -376,77 +376,6 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
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
-void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
-	       uint64_t size, int level)
-{
-	struct kvm_mmu *mmu = vm->arch.nested.mmu;
-	size_t page_size = PG_LEVEL_SIZE(level);
-	size_t npages = size / page_size;
-
-	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
-	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
-
-	while (npages--) {
-		__virt_pg_map(vm, mmu, nested_paddr, paddr, level);
-		nested_paddr += page_size;
-		paddr += page_size;
-	}
-}
-
-void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
-	     uint64_t size)
-{
-	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
-}
-
-/* Prepare an identity extended page table that maps all the
- * physical pages in VM.
- */
-void tdp_identity_map_default_memslots(struct kvm_vm *vm)
-{
-	uint32_t s, memslot = 0;
-	sparsebit_idx_t i, last;
-	struct userspace_mem_region *region = memslot2region(vm, memslot);
-
-	/* Only memslot 0 is mapped here, ensure it's the only one being used */
-	for (s = 0; s < NR_MEM_REGIONS; s++)
-		TEST_ASSERT_EQ(vm->memslots[s], 0);
-
-	i = (region->region.guest_phys_addr >> vm->page_shift) - 1;
-	last = i + (region->region.memory_size >> vm->page_shift);
-	for (;;) {
-		i = sparsebit_next_clear(region->unused_phy_pages, i);
-		if (i > last)
-			break;
-
-		tdp_map(vm, (uint64_t)i << vm->page_shift,
-			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
-	}
-}
-
-/* Identity map a region with 1GiB Pages. */
-void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
-{
-	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
-}
-
 bool kvm_cpu_has_ept(void)
 {
 	uint64_t ctrl;
-- 
2.52.0.158.g65b55ccf14-goog


