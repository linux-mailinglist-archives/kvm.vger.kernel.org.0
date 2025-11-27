Return-Path: <kvm+bounces-64808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CF6E7C8C91E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 479FD3483EF
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7146A26E719;
	Thu, 27 Nov 2025 01:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MkZMqqUA"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72000258EC1
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207316; cv=none; b=BRq/P/m6Jk+vgS9YVtdCruOoBgudU3EP5FzXanUc8LxUCGutNXi4bIGFR8HXczlCj2HuZ15240RceQx5346KM5faRsRPtWMmnrNsboG/rFC8b6l9Cxtku9IC///48lAASLQXi8m1GqDhyUkrSzf6/bc3ZBFWcBmrDgCkK6eja2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207316; c=relaxed/simple;
	bh=9fqIvL+ZjBcPwbLZpcVLWbQ/sL6oJKZiqT1+y68f5ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeeTrrtP34IpqkZzoZ/TGZ3+ji/6d+ZImzuvAApv/9Ixo0+sCZ+dOf73RW11vXmcYhZPk4VdebJRgLDNUrYsecA9J5RRA+oK/LIMTWTgqjDpiF8EtvTxkrTJocqLcR5EqOyyoLSqGhdnW8mNJoeock766uTwSf0oho5hhcijYgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MkZMqqUA; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h8lR1pc6Hr1WzKrsuMNFl8jlT04mlphFfDkA3PXHYU0=;
	b=MkZMqqUAOp6RagIs31KJrEKAPT2WLWIa4I69EM0Jtaf0srm917wWgCrNle0tmhNw77xLKL
	ezkSiHAv5B1IgsoRqh2/kwPuZDG6rDb93s+4FjPo49lue4hnAD1xlo8yOXHPOfQT5Vf2AY
	GJ9J+k8ga37sUa+E68bph/WRHXJHIxo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 09/16] KVM: selftests: Stop passing VMX metadata to TDP mapping functions
Date: Thu, 27 Nov 2025 01:34:33 +0000
Message-ID: <20251127013440.3324671-10-yosry.ahmed@linux.dev>
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

The root GPA can now be retrieved from the nested MMU, stop passing VMX
metadata. This is in preparation for making these functions work for
NPTs as well.

Opportunistically drop tdp_pg_map() since it's unused.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/vmx.h | 11 ++-----
 .../testing/selftests/kvm/lib/x86/memstress.c | 11 +++----
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 33 +++++++------------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  9 +++--
 4 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 1fd83c23529a..4dd4c2094ee6 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -557,14 +557,9 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
-		uint64_t paddr);
-void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm, uint64_t nested_paddr,
-	     uint64_t paddr, uint64_t size);
-void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
-				       struct kvm_vm *vm);
-void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			 uint64_t addr, uint64_t size);
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
+void tdp_identity_map_default_memslots(struct kvm_vm *vm);
+void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void vm_enable_ept(struct kvm_vm *vm);
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 00f7f11e5f0e..3319cb57a78d 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -59,7 +59,7 @@ uint64_t memstress_nested_pages(int nr_vcpus)
 	return 513 + 10 * nr_vcpus;
 }
 
-static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *vm)
+static void memstress_setup_ept_mappings(struct kvm_vm *vm)
 {
 	uint64_t start, end;
 
@@ -68,16 +68,15 @@ static void memstress_setup_ept_mappings(struct vmx_pages *vmx, struct kvm_vm *v
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
 	 * by the backing source.
 	 */
-	tdp_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+	tdp_identity_map_1g(vm, 0, 0x100000000ULL);
 
 	start = align_down(memstress_args.gpa, PG_SIZE_1G);
 	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
-	tdp_identity_map_1g(vmx, vm, start, end - start);
+	tdp_identity_map_1g(vm, start, end - start);
 }
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
 {
-	struct vmx_pages *vmx;
 	struct kvm_regs regs;
 	vm_vaddr_t vmx_gva;
 	int vcpu_id;
@@ -87,11 +86,11 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 
 	vm_enable_ept(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-		vmx = vcpu_alloc_vmx(vm, &vmx_gva);
+		vcpu_alloc_vmx(vm, &vmx_gva);
 
 		/* The EPTs are shared across vCPUs, setup the mappings once */
 		if (vcpu_id == 0)
-			memstress_setup_ept_mappings(vmx, vm);
+			memstress_setup_ept_mappings(vm);
 
 		/*
 		 * Override the vCPU to run memstress_l1_guest_code() which will
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 5d799ec5f7c6..a909fad57fd5 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -404,8 +404,8 @@ static void tdp_create_pte(struct kvm_vm *vm,
 }
 
 
-void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		  uint64_t nested_paddr, uint64_t paddr, int target_level)
+void __tdp_pg_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+		  int target_level)
 {
 	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
 	void *eptp_hva = addr_gpa2hva(vm, vm->arch.nested.mmu->root_gpa);
@@ -448,12 +448,6 @@ void __tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	}
 }
 
-void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		uint64_t nested_paddr, uint64_t paddr)
-{
-	__tdp_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
-}
-
 /*
  * Map a range of EPT guest physical addresses to the VM's physical address
  *
@@ -471,9 +465,8 @@ void tdp_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-	       uint64_t nested_paddr, uint64_t paddr, uint64_t size,
-		  int level)
+void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	       uint64_t size, int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
@@ -482,23 +475,22 @@ void __tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__tdp_pg_map(vmx, vm, nested_paddr, paddr, level);
+		__tdp_pg_map(vm, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
-void tdp_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-	     uint64_t nested_paddr, uint64_t paddr, uint64_t size)
+void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
+	     uint64_t size)
 {
-	__tdp_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__tdp_map(vm, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
-				       struct kvm_vm *vm)
+void tdp_identity_map_default_memslots(struct kvm_vm *vm)
 {
 	uint32_t s, memslot = 0;
 	sparsebit_idx_t i, last;
@@ -515,16 +507,15 @@ void tdp_identity_map_default_memslots(struct vmx_pages *vmx,
 		if (i > last)
 			break;
 
-		tdp_map(vmx, vm, (uint64_t)i << vm->page_shift,
+		tdp_map(vm, (uint64_t)i << vm->page_shift,
 			(uint64_t)i << vm->page_shift, 1 << vm->page_shift);
 	}
 }
 
 /* Identity map a region with 1GiB Pages. */
-void tdp_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
-			    uint64_t addr, uint64_t size)
+void tdp_identity_map_1g(struct kvm_vm *vm, uint64_t addr, uint64_t size)
 {
-	__tdp_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+	__tdp_map(vm, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 5c8cf8ac42a2..370f8d3117c2 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -80,7 +80,6 @@ void l1_guest_code(struct vmx_pages *vmx)
 static void test_vmx_dirty_log(bool enable_ept)
 {
 	vm_vaddr_t vmx_pages_gva = 0;
-	struct vmx_pages *vmx;
 	unsigned long *bmap;
 	uint64_t *host_test_mem;
 
@@ -96,7 +95,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	if (enable_ept)
 		vm_enable_ept(vm);
 
-	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
 
 	/* Add an extra memory slot for testing dirty logging */
@@ -120,9 +119,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 * GPAs as the EPT enabled case.
 	 */
 	if (enable_ept) {
-		tdp_identity_map_default_memslots(vmx, vm);
-		tdp_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		tdp_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_identity_map_default_memslots(vm);
+		tdp_map(vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		tdp_map(vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-- 
2.52.0.158.g65b55ccf14-goog


