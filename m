Return-Path: <kvm+bounces-64813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AA79FC8C939
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 072D034598F
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7279629BD88;
	Thu, 27 Nov 2025 01:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YN9vO+kX"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD0227F75F
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207321; cv=none; b=douwHfLjNYRk/QynX97vNnThaWb8lhU4YAFHPjuzLC27PfpLFz14ubYswC+c+43NcDUsJy7ncYOElCQbJtZhqVZ87fI5qKrjo/bvbbHFlecyfNN7xoN07CCd46TcU2igMoQI0dACB46TmHda+6fWIXjTI6+AHI6htPvML+aHWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207321; c=relaxed/simple;
	bh=oHdUSiYVEwzSaWXrV9eMyKLDzfN4fxnAZloLFDC3cC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQcSsIMFe/gZMWTmu75U70i0o7RVY189K380xgqXsJz63x7RHQ20Wn6amh/FGCmAuUm1Rw7CxF29KMZlWhM4+T5Bn2cBfpZLtrZSJaaMa6snnap6KnAHOaHTCdWyDDhjOqBZgFF+Ibe4V2rBsGrbBMdgAAsj4k8eaKcHmzqZI2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YN9vO+kX; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J1c/DO+GLRLRMECkRI/ad1pfHPuVmFzReD3sWFGUK6o=;
	b=YN9vO+kXFHy7tNmw6FflQpjVmLWG1BzADhw/pd+i664OERXSXlgcZk/PSRXCaWhUEWWEiM
	5PIrqrTL2qgoncADfxphr1o8n7XwIM71f1hqdjgDKd38ezUnbWGB+Z80QRkayoJxSlqIYZ
	qztJaOGlwR3lnVnzT0BaBKu5uO9Y3Bg=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 13/16] KVM: selftests: Add support for nested NPTs
Date: Thu, 27 Nov 2025 01:34:37 +0000
Message-ID: <20251127013440.3324671-14-yosry.ahmed@linux.dev>
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

Implement nCR3 and NPT initialization functions, similar to the EPT
equivalents, and create common TDP helpers for enablement checking and
initialization. Enable NPT for nested guests by default if the TDP MMU
was initialized, similar to VMX.

Reuse the PTE masks from the main MMU in the NPT MMU, except for the C
and S bits related to confidential VMs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/processor.h     |  2 ++
 .../selftests/kvm/include/x86/svm_util.h      |  9 ++++++++
 .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
 .../testing/selftests/kvm/lib/x86/processor.c | 15 +++++++++++++
 tools/testing/selftests/kvm/lib/x86/svm.c     | 22 +++++++++++++++++++
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  4 ++--
 6 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 95216b513379..920abd14f3a6 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1487,6 +1487,8 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
+void vm_enable_tdp(struct kvm_vm *vm);
+bool kvm_cpu_has_tdp(void);
 void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index b74c6dcddcbd..5d7c42534bc4 100644
--- a/tools/testing/selftests/kvm/include/x86/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
@@ -27,6 +27,9 @@ struct svm_test_data {
 	void *msr; /* gva */
 	void *msr_hva;
 	uint64_t msr_gpa;
+
+	/* NPT */
+	uint64_t ncr3_gpa;
 };
 
 static inline void vmmcall(void)
@@ -57,6 +60,12 @@ struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
+static inline bool kvm_cpu_has_npt(void)
+{
+	return kvm_cpu_has(X86_FEATURE_NPT);
+}
+void vm_enable_npt(struct kvm_vm *vm);
+
 int open_sev_dev_path_or_exit(void);
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 3319cb57a78d..407abfc34909 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -82,9 +82,9 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 	int vcpu_id;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
-	TEST_REQUIRE(kvm_cpu_has_ept());
+	TEST_REQUIRE(kvm_cpu_has_tdp());
 
-	vm_enable_ept(vm);
+	vm_enable_tdp(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		vcpu_alloc_vmx(vm, &vmx_gva);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 517a8185eade..b22c8c1bfdc3 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -8,7 +8,9 @@
 #include "kvm_util.h"
 #include "pmu.h"
 #include "processor.h"
+#include "svm_util.h"
 #include "sev.h"
+#include "vmx.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -467,6 +469,19 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
+void vm_enable_tdp(struct kvm_vm *vm)
+{
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vm_enable_ept(vm);
+	else
+		vm_enable_npt(vm);
+}
+
+bool kvm_cpu_has_tdp(void)
+{
+	return kvm_cpu_has_ept() || kvm_cpu_has_npt();
+}
+
 /*
  * Map a range of TDP guest physical addresses to the VM's physical address
  *
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index d239c2097391..cf3b98802164 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -59,6 +59,23 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
+void vm_enable_npt(struct kvm_vm *vm)
+{
+	struct pte_masks pte_masks;
+
+	TEST_ASSERT(kvm_cpu_has_npt(), "KVM doesn't supported nested NPT");
+
+	if (vm->arch.nested.mmu)
+		return;
+
+	/* NPTs use the same PTE format, except for C/S bits */
+	pte_masks = vm->arch.mmu->pte_masks;
+	pte_masks.c = 0;
+	pte_masks.s = 0;
+
+	vm->arch.nested.mmu = mmu_create(vm, vm->pgtable_levels, &pte_masks);
+}
+
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
 {
 	struct vmcb *vmcb = svm->vmcb;
@@ -102,6 +119,11 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	vmcb->save.rip = (u64)guest_rip;
 	vmcb->save.rsp = (u64)guest_rsp;
 	guest_regs.rdi = (u64)svm;
+
+	if (svm->ncr3_gpa) {
+		ctrl->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		ctrl->nested_cr3 = svm->ncr3_gpa;
+	}
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 370f8d3117c2..032ab8bf60a4 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -93,7 +93,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	if (enable_ept)
-		vm_enable_ept(vm);
+		vm_enable_tdp(vm);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
@@ -170,7 +170,7 @@ int main(int argc, char *argv[])
 
 	test_vmx_dirty_log(/*enable_ept=*/false);
 
-	if (kvm_cpu_has_ept())
+	if (kvm_cpu_has_tdp())
 		test_vmx_dirty_log(/*enable_ept=*/true);
 
 	return 0;
-- 
2.52.0.158.g65b55ccf14-goog


