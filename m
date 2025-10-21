Return-Path: <kvm+bounces-60628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE686BF5185
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC9E481D76
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E712F90C4;
	Tue, 21 Oct 2025 07:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q7otXJ5E"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11062EE5FC
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032939; cv=none; b=L8yLTGMr/GLq7gpxoYnyq/3Je9WjCzV95/vjpMusacDlUeFcs0rTLtZ4hGf360NElX414MA/Xxsat3XRdYyZWCYsBHHW4GA14Bv0jn3zJck9aBmA9/f2AArCfReyAEDKywIqXEAhAOygNVD05GBg+C4gzCHtZOIUoioF5tXSnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032939; c=relaxed/simple;
	bh=19aCZcu0vL3OtVccqeE7RWDOIWmFbC1XpRSSnDXy6MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBTuRNbllKTXDLYV4q6uhEJ0FICmOYj9Pu6+YnuR9OqXUTMQSk0IwpG4TPeWQaKPHNITlE1wGMSyKDqdb9JeXtyxOeSWP9aKF3pO2heCZj2+fFLkMzQyx5sLwrxZqtFVdR4AmScwvtlVLf2lJ8eLCbP2OtVYF4HoN5P+UJ1JN2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q7otXJ5E; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrdQMUeB9V5fIrbohohZAu0JiP8CYsDeVqzmHC77NBI=;
	b=Q7otXJ5ELC03U1EapQ91WURdS4AmI5zJsRE6py+P/we7kq2rr0IFFzZgYGEwnd+Xbjb+0h
	zG2cw4hThas2+yX20tGe+4+EAWehLSh/yHyL472zooWA6xL+NCY2Po5ti5EymvRv1a84FE
	BBZwSMPOHHPkElN0LX7FApm6N2AZVuE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 18/23] KVM: selftests: Generalize nested mapping functions
Date: Tue, 21 Oct 2025 07:47:31 +0000
Message-ID: <20251021074736.1324328-19-yosry.ahmed@linux.dev>
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

Instead of passing in a pointer to struct vmx_pages, pass in the GPA of
the root of the EPTs, as that's the only member being used. Furthermore,
only use ept_pte_masks for VMX, and use x86_pte_masks otherwise (which
is what NPT uses).

This is in preparation of supporting NPTs as well.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/include/x86/vmx.h |  6 +++---
 .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 20 ++++++++++---------
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  6 +++---
 4 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 5aa14ceed050a..4429e83e1f52c 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -561,11 +561,11 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t root_gpa,
 			uint32_t memslot);
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_identity_map_1g(struct kvm_vm *vm, vm_paddr_t root_gpa,
 			    uint64_t addr, uint64_t size);
 bool kvm_cpu_has_ept(void);
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 0b1f288ad5564..5ca970a8a5c14 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -70,11 +70,11 @@ void memstress_setup_ept(struct vmx_pages *vmx, struct kvm_vm *vm)
 	 * KVM can shadow the EPT12 with the maximum huge page size supported
 	 * by the backing source.
 	 */
-	nested_identity_map_1g(vmx, vm, 0, 0x100000000ULL);
+	nested_identity_map_1g(vm, vmx->eptp_gpa, 0, 0x100000000ULL);
 
 	start = align_down(memstress_args.gpa, PG_SIZE_1G);
 	end = align_up(memstress_args.gpa + memstress_args.size, PG_SIZE_1G);
-	nested_identity_map_1g(vmx, vm, start, end - start);
+	nested_identity_map_1g(vm, vmx->eptp_gpa, start, end - start);
 }
 
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 75996fc00501e..0573b3ea717cb 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -378,34 +378,36 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
  * Within the VM given by vm, creates a nested guest translation for the
  * page range starting at nested_paddr to the page range starting at paddr.
  */
-void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void __nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
 		  uint64_t nested_paddr, uint64_t paddr, uint64_t size,
 		  int level)
 {
 	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
+	const struct pte_masks *masks;
+
+	masks = kvm_cpu_has(X86_FEATURE_VMX) ? &ept_pte_masks : &x86_pte_masks;
 
 	TEST_ASSERT(nested_paddr + size > nested_paddr, "Vaddr overflow");
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__virt_pg_map(vm, vmx->eptp_gpa, nested_paddr, paddr,
-			      level, &ept_pte_masks);
+		__virt_pg_map(vm, root_gpa, nested_paddr, paddr, level, masks);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
 }
 
-void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map(struct kvm_vm *vm, vm_paddr_t root_gpa,
 		uint64_t nested_paddr, uint64_t paddr, uint64_t size)
 {
-	__nested_map(vmx, vm, nested_paddr, paddr, size, PG_LEVEL_4K);
+	__nested_map(vm, root_gpa, nested_paddr, paddr, size, PG_LEVEL_4K);
 }
 
 /* Prepare an identity extended page table that maps all the
  * physical pages in VM.
  */
-void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_map_memslot(struct kvm_vm *vm, vm_paddr_t root_gpa,
 			uint32_t memslot)
 {
 	sparsebit_idx_t i, last;
@@ -419,7 +421,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 		if (i > last)
 			break;
 
-		nested_map(vmx, vm,
+		nested_map(vm, root_gpa,
 			   (uint64_t)i << vm->page_shift,
 			   (uint64_t)i << vm->page_shift,
 			   1 << vm->page_shift);
@@ -427,10 +429,10 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 }
 
 /* Identity map a region with 1GiB Pages. */
-void nested_identity_map_1g(struct vmx_pages *vmx, struct kvm_vm *vm,
+void nested_identity_map_1g(struct kvm_vm *vm, vm_paddr_t root_gpa,
 			    uint64_t addr, uint64_t size)
 {
-	__nested_map(vmx, vm, addr, addr, size, PG_LEVEL_1G);
+	__nested_map(vm, root_gpa, addr, addr, size, PG_LEVEL_1G);
 }
 
 bool kvm_cpu_has_ept(void)
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 98cb6bdab3e6d..e54e6111164e7 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -121,9 +121,9 @@ static void test_vmx_dirty_log(bool enable_ept)
 	 */
 	if (enable_ept) {
 		prepare_eptp(vmx, vm);
-		nested_map_memslot(vmx, vm, 0);
-		nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
-		nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
+		nested_map_memslot(vm, vmx->eptp_gpa, 0);
+		nested_map(vm, vmx->eptp_gpa, NESTED_TEST_MEM1, GUEST_TEST_MEM, PAGE_SIZE);
+		nested_map(vm, vmx->eptp_gpa, NESTED_TEST_MEM2, GUEST_TEST_MEM, PAGE_SIZE);
 	}
 
 	bmap = bitmap_zalloc(TEST_MEM_PAGES);
-- 
2.51.0.869.ge66316f041-goog


