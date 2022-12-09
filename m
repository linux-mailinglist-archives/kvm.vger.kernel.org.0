Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23A2647CAB
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 05:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiLIDdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 22:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIDdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 22:33:47 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0326B1D304;
        Thu,  8 Dec 2022 19:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670556817; x=1702092817;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vq9nMkdKxWUfGxjoZszTdIqmn0HDQzbbMF06hbT4nuU=;
  b=cvYMeTtz/GCPH9JPBHzmNYSpG8q2nqZkVgfsvo5NgewLkfzraTk55f1t
   0uNkc0S8NjbtdCVyZnUtdHrBioUx+3mUsy0OXVb9CnSsVcGQTOwaj89mP
   qNxiPT+iq14rbd3kMmQE0w+/dzjfn54Zsp7l7dwAxqbNvEhq8FEJmyoF2
   MHosa6zvA2H5GmkFJwb2UxSZlpZLEf9A5nnfAxPhuRUmu5sqAk5NUFkWF
   xZCXIPtFKnI9iknhdEYjjasZgHGWQWFUrqDy87PwtFszWWWdPJ0qbl9R6
   vKNCulhw0f1+gKYHIdfsoC/D80bITxVJ1+9PhCDb8rtKVYsG4BgRb7Q7p
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="300790107"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="300790107"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 19:26:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892508970"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="892508970"
Received: from skxmcp01.bj.intel.com ([10.240.193.86])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 19:26:13 -0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: X86: Use the common definition - 'GPA_INVALID' for X86
Date:   Fri,  9 Dec 2022 10:36:22 +0800
Message-Id: <20221209023622.274715-1-yu.c.zhang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in
kvm_types.h, and it is used by ARM and X86 xen code. We do
not need a replicated 'INVALID_GPA' for X86 specifically.
Just replace it with the common one.

Tested by rebuilding KVM.

No functional change intended.

Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 -
 arch/x86/kvm/hyperv.c           |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  6 +--
 arch/x86/kvm/svm/nested.c       |  4 +-
 arch/x86/kvm/svm/svm.c          |  4 +-
 arch/x86/kvm/vmx/nested.c       | 66 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/sgx.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  6 +--
 arch/x86/kvm/x86.c              | 18 ++++-----
 9 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d1013c4f673c..461c0b699a38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -134,8 +134,6 @@
 #define INVALID_PAGE (~(hpa_t)0)
 #define VALID_PAGE(x) ((x) != INVALID_PAGE)
 
-#define INVALID_GPA (~(gpa_t)0)
-
 /* KVM Hugepage definitions for x86 */
 #define KVM_MAX_HUGEPAGE_LEVEL	PG_LEVEL_1G
 #define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - PG_LEVEL_4K + 1)
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 2c7f2a26421e..09282f0cf0cd 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1945,7 +1945,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 	 */
 	if (!hc->fast && is_guest_mode(vcpu)) {
 		hc->ingpa = translate_nested_gpa(vcpu, hc->ingpa, 0, NULL);
-		if (unlikely(hc->ingpa == INVALID_GPA))
+		if (unlikely(hc->ingpa == GPA_INVALID))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 	}
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0f6455072055..2709c135a798 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -378,7 +378,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		 * information to fix the exit_qualification or exit_info_1
 		 * fields.
 		 */
-		if (unlikely(real_gpa == INVALID_GPA))
+		if (unlikely(real_gpa == GPA_INVALID))
 			return 0;
 
 		host_addr = kvm_vcpu_gfn_to_hva_prot(vcpu, gpa_to_gfn(real_gpa),
@@ -431,7 +431,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 #endif
 
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(gfn), access, &walker->fault);
-	if (real_gpa == INVALID_GPA)
+	if (real_gpa == GPA_INVALID)
 		return 0;
 
 	walker->gfn = real_gpa >> PAGE_SHIFT;
@@ -962,7 +962,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			       struct x86_exception *exception)
 {
 	struct guest_walker walker;
-	gpa_t gpa = INVALID_GPA;
+	gpa_t gpa = GPA_INVALID;
 	int r;
 
 #ifndef CONFIG_X86_64
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bc9cd7086fa9..5531263f6045 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1169,7 +1169,7 @@ void svm_free_nested(struct vcpu_svm *svm)
 	 *
 	 * When the vmcb02 is freed, this optimization becomes invalid.
 	 */
-	svm->nested.last_vmcb12_gpa = INVALID_GPA;
+	svm->nested.last_vmcb12_gpa = GPA_INVALID;
 
 	svm->nested.initialized = false;
 }
@@ -1180,7 +1180,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 
 	if (is_guest_mode(vcpu)) {
 		svm->nested.nested_run_pending = 0;
-		svm->nested.vmcb12_gpa = INVALID_GPA;
+		svm->nested.vmcb12_gpa = GPA_INVALID;
 
 		leave_guest_mode(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 91352d692845..4d88f5293968 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1275,8 +1275,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->current_vmcb->asid_generation = 0;
 	svm->asid = 0;
 
-	svm->nested.vmcb12_gpa = INVALID_GPA;
-	svm->nested.last_vmcb12_gpa = INVALID_GPA;
+	svm->nested.vmcb12_gpa = GPA_INVALID;
+	svm->nested.last_vmcb12_gpa = GPA_INVALID;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
 		control->pause_filter_count = pause_filter_count;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b28be793de29..b903957b2b0b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -192,7 +192,7 @@ static int nested_vmx_fail(struct kvm_vcpu *vcpu, u32 vm_instruction_error)
 	 * failValid writes the error number to the current VMCS, which
 	 * can't be done if there isn't a current VMCS.
 	 */
-	if (vmx->nested.current_vmptr == INVALID_GPA &&
+	if (vmx->nested.current_vmptr == GPA_INVALID &&
 	    !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		return nested_vmx_failInvalid(vcpu);
 
@@ -219,7 +219,7 @@ static inline u64 vmx_control_msr(u32 low, u32 high)
 static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
-	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
+	vmcs_write64(VMCS_LINK_POINTER, GPA_INVALID);
 	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
@@ -236,7 +236,7 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
 	if (hv_vcpu) {
-		hv_vcpu->nested.pa_page_gpa = INVALID_GPA;
+		hv_vcpu->nested.pa_page_gpa = GPA_INVALID;
 		hv_vcpu->nested.vm_id = 0;
 		hv_vcpu->nested.vp_id = 0;
 	}
@@ -304,10 +304,10 @@ static void free_nested(struct kvm_vcpu *vcpu)
 
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
-	vmx->nested.vmxon_ptr = INVALID_GPA;
+	vmx->nested.vmxon_ptr = GPA_INVALID;
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.current_vmptr = INVALID_GPA;
+	vmx->nested.current_vmptr = GPA_INVALID;
 	if (enable_shadow_vmcs) {
 		vmx_disable_shadow_vmcs(vmx);
 		vmcs_clear(vmx->vmcs01.shadow_vmcs);
@@ -667,7 +667,7 @@ static void nested_cache_shadow_vmcs12(struct kvm_vcpu *vcpu,
 	struct gfn_to_hva_cache *ghc = &vmx->nested.shadow_vmcs12_cache;
 
 	if (!nested_cpu_has_shadow_vmcs(vmcs12) ||
-	    vmcs12->vmcs_link_pointer == INVALID_GPA)
+	    vmcs12->vmcs_link_pointer == GPA_INVALID)
 		return;
 
 	if (ghc->gpa != vmcs12->vmcs_link_pointer &&
@@ -686,7 +686,7 @@ static void nested_flush_cached_shadow_vmcs12(struct kvm_vcpu *vcpu,
 	struct gfn_to_hva_cache *ghc = &vmx->nested.shadow_vmcs12_cache;
 
 	if (!nested_cpu_has_shadow_vmcs(vmcs12) ||
-	    vmcs12->vmcs_link_pointer == INVALID_GPA)
+	    vmcs12->vmcs_link_pointer == GPA_INVALID)
 		return;
 
 	if (ghc->gpa != vmcs12->vmcs_link_pointer &&
@@ -2008,7 +2008,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	}
 
 	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
-		vmx->nested.current_vmptr = INVALID_GPA;
+		vmx->nested.current_vmptr = GPA_INVALID;
 
 		nested_release_evmcs(vcpu);
 
@@ -2197,7 +2197,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	}
 
 	if (cpu_has_vmx_encls_vmexit())
-		vmcs_write64(ENCLS_EXITING_BITMAP, INVALID_GPA);
+		vmcs_write64(ENCLS_EXITING_BITMAP, GPA_INVALID);
 
 	if (kvm_notify_vmexit_enabled(kvm))
 		vmcs_write32(NOTIFY_WINDOW, kvm->arch.notify_window);
@@ -2219,7 +2219,7 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 {
 	prepare_vmcs02_constant_state(vmx);
 
-	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA);
+	vmcs_write64(VMCS_LINK_POINTER, GPA_INVALID);
 
 	if (enable_vpid) {
 		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
@@ -2984,7 +2984,7 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
 	struct gfn_to_hva_cache *ghc = &vmx->nested.shadow_vmcs12_cache;
 	struct vmcs_hdr hdr;
 
-	if (vmcs12->vmcs_link_pointer == INVALID_GPA)
+	if (vmcs12->vmcs_link_pointer == GPA_INVALID)
 		return 0;
 
 	if (CC(!page_address_valid(vcpu, vmcs12->vmcs_link_pointer)))
@@ -3242,7 +3242,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			 * Write an illegal value to VIRTUAL_APIC_PAGE_ADDR to
 			 * force VM-Entry to fail.
 			 */
-			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, INVALID_GPA);
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, GPA_INVALID);
 		}
 	}
 
@@ -3567,7 +3567,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (CC(!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) &&
-	       vmx->nested.current_vmptr == INVALID_GPA))
+	       vmx->nested.current_vmptr == GPA_INVALID))
 		return nested_vmx_failInvalid(vcpu);
 
 	vmcs12 = get_vmcs12(vcpu);
@@ -5083,7 +5083,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	if (!vmx->nested.cached_vmcs12)
 		goto out_cached_vmcs12;
 
-	vmx->nested.shadow_vmcs12_cache.gpa = INVALID_GPA;
+	vmx->nested.shadow_vmcs12_cache.gpa = GPA_INVALID;
 	vmx->nested.cached_shadow_vmcs12 = kzalloc(VMCS12_SIZE, GFP_KERNEL_ACCOUNT);
 	if (!vmx->nested.cached_shadow_vmcs12)
 		goto out_cached_shadow_vmcs12;
@@ -5194,7 +5194,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->nested.current_vmptr == INVALID_GPA)
+	if (vmx->nested.current_vmptr == GPA_INVALID)
 		return;
 
 	copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
@@ -5214,7 +5214,7 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 
 	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 
-	vmx->nested.current_vmptr = INVALID_GPA;
+	vmx->nested.current_vmptr = GPA_INVALID;
 }
 
 /* Emulate the VMXOFF instruction */
@@ -5312,12 +5312,12 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 
 	if (!evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
 		/*
-		 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
+		 * In VMX non-root operation, when the VMCS-link pointer is GPA_INVALID,
 		 * any VMREAD sets the ALU flags for VMfailInvalid.
 		 */
-		if (vmx->nested.current_vmptr == INVALID_GPA ||
+		if (vmx->nested.current_vmptr == GPA_INVALID ||
 		    (is_guest_mode(vcpu) &&
-		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
+		     get_vmcs12(vcpu)->vmcs_link_pointer == GPA_INVALID))
 			return nested_vmx_failInvalid(vcpu);
 
 		offset = get_vmcs12_field_offset(field);
@@ -5422,12 +5422,12 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/*
-	 * In VMX non-root operation, when the VMCS-link pointer is INVALID_GPA,
+	 * In VMX non-root operation, when the VMCS-link pointer is GPA_INVALID,
 	 * any VMWRITE sets the ALU flags for VMfailInvalid.
 	 */
-	if (vmx->nested.current_vmptr == INVALID_GPA ||
+	if (vmx->nested.current_vmptr == GPA_INVALID ||
 	    (is_guest_mode(vcpu) &&
-	     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
+	     get_vmcs12(vcpu)->vmcs_link_pointer == GPA_INVALID))
 		return nested_vmx_failInvalid(vcpu);
 
 	if (instr_info & BIT(10))
@@ -5880,7 +5880,7 @@ bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 	gpa_t bitmap, last_bitmap;
 	u8 b;
 
-	last_bitmap = INVALID_GPA;
+	last_bitmap = GPA_INVALID;
 	b = -1;
 
 	while (size > 0) {
@@ -6364,8 +6364,8 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		.format = KVM_STATE_NESTED_FORMAT_VMX,
 		.size = sizeof(kvm_state),
 		.hdr.vmx.flags = 0,
-		.hdr.vmx.vmxon_pa = INVALID_GPA,
-		.hdr.vmx.vmcs12_pa = INVALID_GPA,
+		.hdr.vmx.vmxon_pa = GPA_INVALID,
+		.hdr.vmx.vmcs12_pa = GPA_INVALID,
 		.hdr.vmx.preemption_timer_deadline = 0,
 	};
 	struct kvm_vmx_nested_state_data __user *user_vmx_nested_state =
@@ -6391,7 +6391,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 
 			if (is_guest_mode(vcpu) &&
 			    nested_cpu_has_shadow_vmcs(vmcs12) &&
-			    vmcs12->vmcs_link_pointer != INVALID_GPA)
+			    vmcs12->vmcs_link_pointer != GPA_INVALID)
 				kvm_state.size += sizeof(user_vmx_nested_state->shadow_vmcs12);
 		}
 
@@ -6467,7 +6467,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		return -EFAULT;
 
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
-	    vmcs12->vmcs_link_pointer != INVALID_GPA) {
+	    vmcs12->vmcs_link_pointer != GPA_INVALID) {
 		if (copy_to_user(user_vmx_nested_state->shadow_vmcs12,
 				 get_shadow_vmcs12(vcpu), VMCS12_SIZE))
 			return -EFAULT;
@@ -6499,11 +6499,11 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_VMX)
 		return -EINVAL;
 
-	if (kvm_state->hdr.vmx.vmxon_pa == INVALID_GPA) {
+	if (kvm_state->hdr.vmx.vmxon_pa == GPA_INVALID) {
 		if (kvm_state->hdr.vmx.smm.flags)
 			return -EINVAL;
 
-		if (kvm_state->hdr.vmx.vmcs12_pa != INVALID_GPA)
+		if (kvm_state->hdr.vmx.vmcs12_pa != GPA_INVALID)
 			return -EINVAL;
 
 		/*
@@ -6557,7 +6557,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	vmx_leave_nested(vcpu);
 
-	if (kvm_state->hdr.vmx.vmxon_pa == INVALID_GPA)
+	if (kvm_state->hdr.vmx.vmxon_pa == GPA_INVALID)
 		return 0;
 
 	vmx->nested.vmxon_ptr = kvm_state->hdr.vmx.vmxon_pa;
@@ -6570,13 +6570,13 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		/* See vmx_has_valid_vmcs12.  */
 		if ((kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE) ||
 		    (kvm_state->flags & KVM_STATE_NESTED_EVMCS) ||
-		    (kvm_state->hdr.vmx.vmcs12_pa != INVALID_GPA))
+		    (kvm_state->hdr.vmx.vmcs12_pa != GPA_INVALID))
 			return -EINVAL;
 		else
 			return 0;
 	}
 
-	if (kvm_state->hdr.vmx.vmcs12_pa != INVALID_GPA) {
+	if (kvm_state->hdr.vmx.vmcs12_pa != GPA_INVALID) {
 		if (kvm_state->hdr.vmx.vmcs12_pa == kvm_state->hdr.vmx.vmxon_pa ||
 		    !page_address_valid(vcpu, kvm_state->hdr.vmx.vmcs12_pa))
 			return -EINVAL;
@@ -6621,7 +6621,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 
 	ret = -EINVAL;
 	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
-	    vmcs12->vmcs_link_pointer != INVALID_GPA) {
+	    vmcs12->vmcs_link_pointer != GPA_INVALID) {
 		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
 
 		if (kvm_state->size <
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 8f95c7c01433..7c5a9bbe2908 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -79,7 +79,7 @@ static int sgx_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t gva, bool write,
 	else
 		*gpa = kvm_mmu_gva_to_gpa_read(vcpu, gva, &ex);
 
-	if (*gpa == INVALID_GPA) {
+	if (*gpa == GPA_INVALID) {
 		kvm_inject_emulated_page_fault(vcpu, &ex);
 		return -EFAULT;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cea8c07f5229..21109269b88a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4593,7 +4593,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	if (cpu_has_vmx_msr_bitmap())
 		vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
 
-	vmcs_write64(VMCS_LINK_POINTER, INVALID_GPA); /* 22.3.1.5 */
+	vmcs_write64(VMCS_LINK_POINTER, GPA_INVALID); /* 22.3.1.5 */
 
 	/* Control */
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
@@ -4712,8 +4712,8 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
 	vcpu_setup_sgx_lepubkeyhash(vcpu);
 
 	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.vmxon_ptr = INVALID_GPA;
-	vmx->nested.current_vmptr = INVALID_GPA;
+	vmx->nested.vmxon_ptr = GPA_INVALID;
+	vmx->nested.current_vmptr = GPA_INVALID;
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
 	vcpu->arch.microcode_version = 0x100000000ULL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72ac6bf05c8b..fe984df5c602 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -871,7 +871,7 @@ int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 */
 	real_gpa = kvm_translate_gpa(vcpu, mmu, gfn_to_gpa(pdpt_gfn),
 				     PFERR_USER_MASK | PFERR_WRITE_MASK, NULL);
-	if (real_gpa == INVALID_GPA)
+	if (real_gpa == GPA_INVALID)
 		return 0;
 
 	/* Note the offset, PDPTRs are 32 byte aligned when using PAE paging. */
@@ -7200,7 +7200,7 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
 		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 
-		if (gpa == INVALID_GPA)
+		if (gpa == GPA_INVALID)
 			return X86EMUL_PROPAGATE_FAULT;
 		ret = kvm_vcpu_read_guest_page(vcpu, gpa >> PAGE_SHIFT, data,
 					       offset, toread);
@@ -7231,7 +7231,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
 	/* Inline kvm_read_guest_virt_helper for speed.  */
 	gpa_t gpa = mmu->gva_to_gpa(vcpu, mmu, addr, access|PFERR_FETCH_MASK,
 				    exception);
-	if (unlikely(gpa == INVALID_GPA))
+	if (unlikely(gpa == GPA_INVALID))
 		return X86EMUL_PROPAGATE_FAULT;
 
 	offset = addr & (PAGE_SIZE-1);
@@ -7292,7 +7292,7 @@ static int kvm_write_guest_virt_helper(gva_t addr, void *val, unsigned int bytes
 		unsigned towrite = min(bytes, (unsigned)PAGE_SIZE - offset);
 		int ret;
 
-		if (gpa == INVALID_GPA)
+		if (gpa == GPA_INVALID)
 			return X86EMUL_PROPAGATE_FAULT;
 		ret = kvm_vcpu_write_guest(vcpu, gpa, data, towrite);
 		if (ret < 0) {
@@ -7406,7 +7406,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 
 	*gpa = mmu->gva_to_gpa(vcpu, mmu, gva, access, exception);
 
-	if (*gpa == INVALID_GPA)
+	if (*gpa == GPA_INVALID)
 		return -1;
 
 	return vcpu_is_mmio_gpa(vcpu, gva, *gpa, write);
@@ -7643,7 +7643,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 
 	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, NULL);
 
-	if (gpa == INVALID_GPA ||
+	if (gpa == GPA_INVALID ||
 	    (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
 		goto emul_write;
 
@@ -8439,7 +8439,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * If the mapping is invalid in guest, let cpu retry
 		 * it to generate fault.
 		 */
-		if (gpa == INVALID_GPA)
+		if (gpa == GPA_INVALID)
 			return true;
 	}
 
@@ -11426,7 +11426,7 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	gpa = kvm_mmu_gva_to_gpa_system(vcpu, vaddr, NULL);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	tr->physical_address = gpa;
-	tr->valid = gpa != INVALID_GPA;
+	tr->valid = gpa != GPA_INVALID;
 	tr->writeable = 1;
 	tr->usermode = 0;
 
@@ -13096,7 +13096,7 @@ void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_c
 		(PFERR_WRITE_MASK | PFERR_FETCH_MASK | PFERR_USER_MASK);
 
 	if (!(error_code & PFERR_PRESENT_MASK) ||
-	    mmu->gva_to_gpa(vcpu, mmu, gva, access, &fault) != INVALID_GPA) {
+	    mmu->gva_to_gpa(vcpu, mmu, gva, access, &fault) != GPA_INVALID) {
 		/*
 		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the page
 		 * tables probably do not match the TLB.  Just proceed
-- 
2.25.1

