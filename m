Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF36E360ADA
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhDONo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:44:27 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41556 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233390AbhDONoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:44:21 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id D512520B8004;
        Thu, 15 Apr 2021 06:43:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D512520B8004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618494237;
        bh=bjFWBm3C0rCcnRbxotR3avNITEUwe7JpyQCntP3sOFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUUP+MjYu6FAMDqikhRRX7Yhz7J1eeWGNSbck3BWnRgS96FrRHTrTwteQF9AQ8Qad
         DiMebclNXe+T1ZbPwcIaizVZfRwzK/LqCjDoZ4XpEd3B4E5BVhIa7V9D3yrlXN+3FN
         cIDbOLr2QE6YdRchSzJXGACQfnlCy9vNghV2I1CU=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 3/7] KVM: x86: hyper-v: Move the remote TLB flush logic out of vmx
Date:   Thu, 15 Apr 2021 13:43:38 +0000
Message-Id: <92207433d0784e123347caaa955c04fbec51eaa7.1618492553.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently the remote TLB flush logic is specific to VMX.
Move it to a common place so that SVM can use it as well.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/include/asm/kvm_host.h | 14 +++++
 arch/x86/kvm/hyperv.c           | 87 +++++++++++++++++++++++++++++
 arch/x86/kvm/hyperv.h           | 20 +++++++
 arch/x86/kvm/vmx/vmx.c          | 97 +++------------------------------
 arch/x86/kvm/vmx/vmx.h          | 10 ----
 arch/x86/kvm/x86.c              |  9 ++-
 6 files changed, 136 insertions(+), 101 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 877a4025d8da..ed84c15d18bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -838,6 +838,15 @@ struct kvm_vcpu_arch {
 
 	/* Protected Guests */
 	bool guest_state_protected;
+
+#if IS_ENABLED(CONFIG_HYPERV)
+	/*
+	 * Two Dimensional paging CR3
+	 * EPTP for Intel
+	 * nCR3 for AMD
+	 */
+	u64 tdp_pointer;
+#endif
 };
 
 struct kvm_lpage_info {
@@ -1079,6 +1088,11 @@ struct kvm_arch {
 	 */
 	spinlock_t tdp_mmu_pages_lock;
 #endif /* CONFIG_X86_64 */
+
+#if IS_ENABLED(CONFIG_HYPERV)
+	int tdp_pointers_match;
+	spinlock_t tdp_pointer_lock;
+#endif
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 58fa8c029867..614b4448a028 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -32,6 +32,7 @@
 #include <linux/eventfd.h>
 
 #include <asm/apicdef.h>
+#include <asm/mshyperv.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -2180,3 +2181,89 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 
 	return 0;
 }
+
+#if IS_ENABLED(CONFIG_HYPERV)
+/* check_tdp_pointer() should be under protection of tdp_pointer_lock. */
+static void check_tdp_pointer_match(struct kvm *kvm)
+{
+	u64 tdp_pointer = INVALID_PAGE;
+	bool valid_tdp = false;
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!valid_tdp) {
+			tdp_pointer = vcpu->arch.tdp_pointer;
+			valid_tdp = true;
+			continue;
+		}
+
+		if (tdp_pointer != vcpu->arch.tdp_pointer) {
+			kvm->arch.tdp_pointers_match = TDP_POINTERS_MISMATCH;
+			return;
+		}
+	}
+
+	kvm->arch.tdp_pointers_match = TDP_POINTERS_MATCH;
+}
+
+static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
+		void *data)
+{
+	struct kvm_tlb_range *range = data;
+
+	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
+			range->pages);
+}
+
+static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
+		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
+{
+	u64 tdp_pointer = vcpu->arch.tdp_pointer;
+
+	/*
+	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
+	 * of the base of EPT PML4 table, strip off EPT configuration
+	 * information.
+	 */
+	if (range)
+		return hyperv_flush_guest_mapping_range(tdp_pointer & PAGE_MASK,
+				kvm_fill_hv_flush_list_func, (void *)range);
+	else
+		return hyperv_flush_guest_mapping(tdp_pointer & PAGE_MASK);
+}
+
+int kvm_hv_remote_flush_tlb_with_range(struct kvm *kvm,
+		struct kvm_tlb_range *range)
+{
+	struct kvm_vcpu *vcpu;
+	int ret = 0, i;
+
+	spin_lock(&kvm->arch.tdp_pointer_lock);
+
+	if (kvm->arch.tdp_pointers_match == TDP_POINTERS_CHECK)
+		check_tdp_pointer_match(kvm);
+
+	if (kvm->arch.tdp_pointers_match != TDP_POINTERS_MATCH) {
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			/* If tdp_pointer is invalid pointer, bypass flush request. */
+			if (VALID_PAGE(vcpu->arch.tdp_pointer))
+				ret |= __hv_remote_flush_tlb_with_range(
+					kvm, vcpu, range);
+		}
+	} else {
+		ret = __hv_remote_flush_tlb_with_range(kvm,
+				kvm_get_vcpu(kvm, 0), range);
+	}
+
+	spin_unlock(&kvm->arch.tdp_pointer_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_hv_remote_flush_tlb_with_range);
+
+int kvm_hv_remote_flush_tlb(struct kvm *kvm)
+{
+	return kvm_hv_remote_flush_tlb_with_range(kvm, NULL);
+}
+EXPORT_SYMBOL_GPL(kvm_hv_remote_flush_tlb);
+#endif
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index e951af1fcb2c..b27c6f47f58d 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -50,6 +50,12 @@
 /* Hyper-V HV_X64_MSR_SYNDBG_OPTIONS bits */
 #define HV_X64_SYNDBG_OPTION_USE_HCALLS		BIT(2)
 
+enum tdp_pointers_status {
+	TDP_POINTERS_CHECK = 0,
+	TDP_POINTERS_MATCH = 1,
+	TDP_POINTERS_MISMATCH = 2
+};
+
 static inline struct kvm_hv *to_kvm_hv(struct kvm *kvm)
 {
 	return &kvm->arch.hyperv;
@@ -141,4 +147,18 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args);
 int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		     struct kvm_cpuid_entry2 __user *entries);
 
+#if IS_ENABLED(CONFIG_HYPERV)
+static inline void kvm_update_arch_tdp_pointer(struct kvm *kvm,
+		struct kvm_vcpu *vcpu, u64 tdp_pointer)
+{
+	spin_lock(&kvm->arch.tdp_pointer_lock);
+	vcpu->arch.tdp_pointer = tdp_pointer;
+	kvm->arch.tdp_pointers_match = TDP_POINTERS_CHECK;
+	spin_unlock(&kvm->arch.tdp_pointer_lock);
+}
+
+int kvm_hv_remote_flush_tlb(struct kvm *kvm);
+int kvm_hv_remote_flush_tlb_with_range(struct kvm *kvm,
+		struct kvm_tlb_range *range);
+#endif
 #endif
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 50810d471462..67f607319eb7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -62,6 +62,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "hyperv.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -472,83 +473,6 @@ static const u32 vmx_uret_msrs_list[] = {
 static bool __read_mostly enlightened_vmcs = true;
 module_param(enlightened_vmcs, bool, 0444);
 
-/* check_ept_pointer() should be under protection of ept_pointer_lock. */
-static void check_ept_pointer_match(struct kvm *kvm)
-{
-	struct kvm_vcpu *vcpu;
-	u64 tmp_eptp = INVALID_PAGE;
-	int i;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!VALID_PAGE(tmp_eptp)) {
-			tmp_eptp = to_vmx(vcpu)->ept_pointer;
-		} else if (tmp_eptp != to_vmx(vcpu)->ept_pointer) {
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_MISMATCH;
-			return;
-		}
-	}
-
-	to_kvm_vmx(kvm)->ept_pointers_match = EPT_POINTERS_MATCH;
-}
-
-static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
-		void *data)
-{
-	struct kvm_tlb_range *range = data;
-
-	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
-			range->pages);
-}
-
-static inline int __hv_remote_flush_tlb_with_range(struct kvm *kvm,
-		struct kvm_vcpu *vcpu, struct kvm_tlb_range *range)
-{
-	u64 ept_pointer = to_vmx(vcpu)->ept_pointer;
-
-	/*
-	 * FLUSH_GUEST_PHYSICAL_ADDRESS_SPACE hypercall needs address
-	 * of the base of EPT PML4 table, strip off EPT configuration
-	 * information.
-	 */
-	if (range)
-		return hyperv_flush_guest_mapping_range(ept_pointer & PAGE_MASK,
-				kvm_fill_hv_flush_list_func, (void *)range);
-	else
-		return hyperv_flush_guest_mapping(ept_pointer & PAGE_MASK);
-}
-
-static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
-		struct kvm_tlb_range *range)
-{
-	struct kvm_vcpu *vcpu;
-	int ret = 0, i;
-
-	spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-
-	if (to_kvm_vmx(kvm)->ept_pointers_match == EPT_POINTERS_CHECK)
-		check_ept_pointer_match(kvm);
-
-	if (to_kvm_vmx(kvm)->ept_pointers_match != EPT_POINTERS_MATCH) {
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			/* If ept_pointer is invalid pointer, bypass flush request. */
-			if (VALID_PAGE(to_vmx(vcpu)->ept_pointer))
-				ret |= __hv_remote_flush_tlb_with_range(
-					kvm, vcpu, range);
-		}
-	} else {
-		ret = __hv_remote_flush_tlb_with_range(kvm,
-				kvm_get_vcpu(kvm, 0), range);
-	}
-
-	spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-	return ret;
-}
-static int hv_remote_flush_tlb(struct kvm *kvm)
-{
-	return hv_remote_flush_tlb_with_range(kvm, NULL);
-}
-
 static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
 {
 	struct hv_enlightened_vmcs *evmcs;
@@ -3115,13 +3039,10 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 		eptp = construct_eptp(vcpu, pgd, pgd_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
-		if (kvm_x86_ops.tlb_remote_flush) {
-			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-			to_vmx(vcpu)->ept_pointer = eptp;
-			to_kvm_vmx(kvm)->ept_pointers_match
-				= EPT_POINTERS_CHECK;
-			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
-		}
+#if IS_ENABLED(CONFIG_HYPERV)
+		if (kvm_x86_ops.tlb_remote_flush)
+			kvm_update_arch_tdp_pointer(kvm, vcpu, eptp);
+#endif
 
 		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
@@ -6989,8 +6910,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
 	vmx->pi_desc.sn = 1;
 
-	vmx->ept_pointer = INVALID_PAGE;
-
 	return 0;
 
 free_vmcs:
@@ -7007,8 +6926,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_vm_init(struct kvm *kvm)
 {
-	spin_lock_init(&to_kvm_vmx(kvm)->ept_pointer_lock);
-
 	if (!ple_gap)
 		kvm->arch.pause_in_guest = true;
 
@@ -7818,9 +7735,9 @@ static __init int hardware_setup(void)
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
 	    && enable_ept) {
-		vmx_x86_ops.tlb_remote_flush = hv_remote_flush_tlb;
+		vmx_x86_ops.tlb_remote_flush = kvm_hv_remote_flush_tlb;
 		vmx_x86_ops.tlb_remote_flush_with_range =
-				hv_remote_flush_tlb_with_range;
+				kvm_hv_remote_flush_tlb_with_range;
 	}
 #endif
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 89da5e1251f1..d2e2ab46f5bb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -325,7 +325,6 @@ struct vcpu_vmx {
 	 */
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
-	u64 ept_pointer;
 
 	struct pt_desc pt_desc;
 	struct lbr_desc lbr_desc;
@@ -338,21 +337,12 @@ struct vcpu_vmx {
 	} shadow_msr_intercept;
 };
 
-enum ept_pointers_status {
-	EPT_POINTERS_CHECK = 0,
-	EPT_POINTERS_MATCH = 1,
-	EPT_POINTERS_MISMATCH = 2
-};
-
 struct kvm_vmx {
 	struct kvm kvm;
 
 	unsigned int tss_addr;
 	bool ept_identity_pagetable_done;
 	gpa_t ept_identity_map_addr;
-
-	enum ept_pointers_status ept_pointers_match;
-	spinlock_t ept_pointer_lock;
 };
 
 bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2a20ce60152e..f566e78b59b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10115,6 +10115,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.pending_external_vector = -1;
 	vcpu->arch.preempted_in_kernel = false;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	vcpu->arch.tdp_pointer = INVALID_PAGE;
+#endif
+
 	r = static_call(kvm_x86_vcpu_create)(vcpu);
 	if (r)
 		goto free_guest_fpu;
@@ -10470,7 +10474,6 @@ void kvm_arch_free_vm(struct kvm *kvm)
 	vfree(kvm);
 }
 
-
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	if (type)
@@ -10498,6 +10501,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.guest_can_read_msr_platform_info = true;
 
+#if IS_ENABLED(CONFIG_HYPERV)
+	spin_lock_init(&kvm->arch.tdp_pointer_lock);
+#endif
+
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
-- 
2.25.1

