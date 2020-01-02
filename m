Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9A412E301
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 07:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgABGKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 01:10:03 -0500
Received: from mga07.intel.com ([134.134.136.100]:3905 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727704AbgABGJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 01:09:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Jan 2020 22:09:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,385,1571727600"; 
   d="scan'208";a="224706754"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Jan 2020 22:09:30 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at vmentry/vmexit
Date:   Thu,  2 Jan 2020 14:13:15 +0800
Message-Id: <20200102061319.10077-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200102061319.10077-1-weijiang.yang@intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If write to subpage is not allowed, EPT violation generates
and it's handled in fast_page_fault().

In current implementation, SPPT setup is only handled in handle_spp()
vmexit handler, it's triggered when SPP bit is set in EPT leaf
entry while SPPT entries are not ready.

A SPP specific bit(11) is added to exit_qualification and a new
exit reason(66) is introduced for SPP.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/vmx.h      |  9 ++++
 arch/x86/include/uapi/asm/vmx.h |  2 +
 arch/x86/kvm/mmu/mmu.c          | 69 +++++++++++++++++++++++++---
 arch/x86/kvm/mmu/spp.c          | 13 ++++++
 arch/x86/kvm/mmu/spp.h          |  2 +
 arch/x86/kvm/trace.h            | 66 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 80 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  4 ++
 include/uapi/linux/kvm.h        |  6 +++
 9 files changed, 244 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index de79a4de0723..81faf6607a9e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -213,6 +213,8 @@ enum vmcs_field {
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
+	SPPT_POINTER			= 0x00002030,
+	SPPT_POINTER_HIGH		= 0x00002031,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
@@ -534,6 +536,13 @@ struct vmx_msr_entry {
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
+/*
+ * Exit Qualifications for SPPT-Induced vmexits
+ */
+#define SPPT_INDUCED_EXIT_TYPE_BIT     11
+#define SPPT_INDUCED_EXIT_TYPE         (1 << SPPT_INDUCED_EXIT_TYPE_BIT)
+#define SPPT_INTR_INFO_UNBLOCK_NMI     INTR_INFO_UNBLOCK_NMI
+
 /*
  * VM-instruction error numbers
  */
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 3eb8411ab60e..4833a39a799b 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -86,6 +86,7 @@
 #define EXIT_REASON_PML_FULL            62
 #define EXIT_REASON_XSAVES              63
 #define EXIT_REASON_XRSTORS             64
+#define EXIT_REASON_SPP                 66
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
 
@@ -145,6 +146,7 @@
 	{ EXIT_REASON_ENCLS,                 "ENCLS" }, \
 	{ EXIT_REASON_RDSEED,                "RDSEED" }, \
 	{ EXIT_REASON_PML_FULL,              "PML_FULL" }, \
+	{ EXIT_REASON_SPP,                   "SPP" }, \
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
 	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f92b40d798c..c41791ebee65 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -20,6 +20,7 @@
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
+#include "spp.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -177,6 +178,7 @@ module_param(dbg, bool, 0644);
 /* The mask for the R/X bits in EPT PTEs */
 #define PT64_EPT_READABLE_MASK			0x1ull
 #define PT64_EPT_EXECUTABLE_MASK		0x4ull
+#define PT64_SPP_SAVED_BIT	(1ULL << (PT64_SECOND_AVAIL_BITS_SHIFT + 1))
 
 #include <trace/events/kvm.h>
 
@@ -200,6 +202,7 @@ enum {
 	RET_PF_RETRY = 0,
 	RET_PF_EMULATE = 1,
 	RET_PF_INVALID = 2,
+	RET_PF_USERSPACE = 3,
 };
 
 struct pte_list_desc {
@@ -979,6 +982,11 @@ static u64 mark_spte_for_access_track(u64 spte)
 		shadow_acc_track_saved_bits_shift;
 	spte &= ~shadow_acc_track_mask;
 
+	if (spte & PT_SPP_MASK) {
+		spte &= ~PT_SPP_MASK;
+		spte |= PT64_SPP_SAVED_BIT;
+	}
+
 	return spte;
 }
 
@@ -1677,9 +1685,15 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
+	bool was_spp_armed = test_and_clear_bit(PT_SPP_SHIFT,
+					       (unsigned long *)sptep);
+
 	if (was_writable && !spte_ad_enabled(*sptep))
 		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
 
+	if (was_spp_armed)
+		*sptep |= PT64_SPP_SAVED_BIT;
+
 	return was_writable;
 }
 
@@ -3478,7 +3492,8 @@ static bool page_fault_can_be_fast(u32 error_code)
  */
 static bool
 fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			u64 *sptep, u64 old_spte, u64 new_spte)
+			u64 *sptep, u64 old_spte, u64 new_spte,
+			bool spp_protected)
 {
 	gfn_t gfn;
 
@@ -3499,7 +3514,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
+	if ((is_writable_pte(new_spte) && !is_writable_pte(old_spte)) ||
+	    spp_protected) {
 		/*
 		 * The gfn of direct spte is stable since it is
 		 * calculated by sp->gfn.
@@ -3534,6 +3550,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	bool fault_handled = false;
+	bool spp_protected = false;
 	u64 spte = 0ull;
 	uint retry_count = 0;
 
@@ -3585,7 +3602,30 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		if ((error_code & PFERR_WRITE_MASK) &&
 		    spte_can_locklessly_be_made_writable(spte))
 		{
-			new_spte |= PT_WRITABLE_MASK;
+			/*
+			 * Record write protect fault caused by
+			 * Sub-page Protection, let VMI decide
+			 * the next step.
+			 */
+			if (spte & PT_SPP_MASK) {
+				int len = kvm_x86_ops->get_inst_len(vcpu);
+
+				fault_handled = true;
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = gva;
+				vcpu->run->spp.ins_len = len;
+				trace_kvm_spp_induced_page_fault(vcpu,
+								 gva,
+								 len);
+				break;
+			}
+
+			if (was_spp_armed(new_spte)) {
+				restore_spp_bit(&new_spte);
+				spp_protected = true;
+			} else {
+				new_spte |= PT_WRITABLE_MASK;
+			}
 
 			/*
 			 * Do not fix write-permission on the large spte.  Since
@@ -3604,7 +3644,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(error_code, new_spte))
+		    (!is_access_allowed(error_code, new_spte) &&
+		    !spp_protected))
 			break;
 
 		/*
@@ -3614,7 +3655,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		 */
 		fault_handled = fast_pf_fix_direct_spte(vcpu, sp,
 							iterator.sptep, spte,
-							new_spte);
+							new_spte,
+							spp_protected);
 		if (fault_handled)
 			break;
 
@@ -3740,6 +3782,12 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
 					   &invalid_list);
+			if (vcpu->kvm->arch.spp_active) {
+				vcpu->kvm->arch.spp_active = false;
+				mmu_free_root_page(vcpu->kvm,
+						   &vcpu->kvm->arch.sppt_root,
+						   &invalid_list);
+			}
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -5223,6 +5271,8 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+		if (!vcpu->kvm->arch.spp_active)
+			vcpu->kvm->arch.sppt_root = INVALID_PAGE;
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
@@ -5539,6 +5589,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		r = vcpu->arch.mmu->page_fault(vcpu, cr2,
 					       lower_32_bits(error_code),
 					       false);
+
+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			r = RET_PF_USERSPACE;
+
 		WARN_ON(r == RET_PF_INVALID);
 	}
 
@@ -5546,7 +5600,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		return 1;
 	if (r < 0)
 		return r;
-
+	if (r == RET_PF_USERSPACE)
+		return 0;
 	/*
 	 * Before emulating the instruction, check if the error code
 	 * was due to a RO violation while translating the guest page.
@@ -6372,6 +6427,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 	return nr_mmu_pages;
 }
 
+#include "spp.c"
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 6f611e04e817..3ec434140967 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -17,6 +17,18 @@ static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
 	iterator->level = PT64_ROOT_4LEVEL;
 }
 
+/* Restore an spp armed PTE */
+void restore_spp_bit(u64 *spte)
+{
+	*spte &= ~PT64_SPP_SAVED_BIT;
+	*spte |= PT_SPP_MASK;
+}
+
+bool was_spp_armed(u64 spte)
+{
+	return !!(spte & PT64_SPP_SAVED_BIT);
+}
+
 u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	unsigned long idx;
@@ -459,6 +471,7 @@ int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 		if (!access)
 			return -EFAULT;
 		*access = access_map[i];
+		trace_kvm_spp_set_subpages(vcpu, gfn, *access);
 	}
 
 	gfn = old_gfn;
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index daa69bd274da..5ffe06d2cd6f 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -11,6 +11,8 @@ int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
 bool is_spp_spte(struct kvm_mmu_page *sp);
+void restore_spp_bit(u64 *spte);
+bool was_spp_armed(u64 spte);
 u64 construct_spptp(unsigned long root_hpa);
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7c741a0c5f80..293b91d516b1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1496,6 +1496,72 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
 		__print_symbolic(__entry->err, VMX_VMENTER_INSTRUCTION_ERRORS))
 );
 
+TRACE_EVENT(kvm_spp_set_subpages,
+	TP_PROTO(struct kvm_vcpu *vcpu, gfn_t gfn, u32 access),
+	TP_ARGS(vcpu, gfn, access),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(gfn_t, gfn)
+		__field(u32, access)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gfn = gfn;
+		__entry->access = access;
+	),
+
+	TP_printk("vcpu %d gfn %llx access %x",
+		  __entry->vcpu_id,
+		  __entry->gfn,
+		  __entry->access)
+);
+
+TRACE_EVENT(kvm_spp_induced_exit,
+	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t gpa, u32 qualification),
+	TP_ARGS(vcpu, gpa, qualification),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(gpa_t, gpa)
+		__field(u32, qualification)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gpa = gpa;
+		__entry->qualification = qualification;
+	),
+
+	TP_printk("vcpu %d gpa %llx qualificaiton %x",
+		  __entry->vcpu_id,
+		  __entry->gpa,
+		  __entry->qualification)
+);
+
+TRACE_EVENT(kvm_spp_induced_page_fault,
+	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t gpa, int inst_len),
+	TP_ARGS(vcpu, gpa, inst_len),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(gpa_t, gpa)
+		__field(int, inst_len)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gpa = gpa;
+		__entry->inst_len = inst_len;
+	),
+
+	TP_printk("vcpu %d gpa %llx inst_len %d",
+		  __entry->vcpu_id,
+		  __entry->gpa,
+		  __entry->inst_len)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 24e4e1c47f42..97d862c79124 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -200,7 +200,6 @@ static const struct {
 	[VMENTER_L1D_FLUSH_EPT_DISABLED] = {"EPT disabled", false},
 	[VMENTER_L1D_FLUSH_NOT_REQUIRED] = {"not required", false},
 };
-
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
@@ -2999,6 +2998,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
 	u64 eptp;
+	u64 spptp;
 
 	guest_cr3 = cr3;
 	if (enable_ept) {
@@ -3027,6 +3027,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 
 	if (update_guest_cr3)
 		vmcs_writel(GUEST_CR3, guest_cr3);
+
+	if (kvm->arch.spp_active && VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
+		spptp = construct_spptp(vcpu->kvm->arch.sppt_root);
+		vmcs_write64(SPPT_POINTER, spptp);
+		vmx_flush_tlb(vcpu, true);
+	}
 }
 
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -5361,6 +5367,74 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+int handle_spp(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qualification;
+	struct kvm_memory_slot *slot;
+	gpa_t gpa;
+	gfn_t gfn;
+
+	exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
+
+	/*
+	 * SPP VM exit happened while executing iret from NMI,
+	 * "blocked by NMI" bit has to be set before next VM entry.
+	 * There are errata that may cause this bit to not be set:
+	 * AAK134, BY25.
+	 */
+	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
+	    (exit_qualification & SPPT_INTR_INFO_UNBLOCK_NMI))
+		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
+			      GUEST_INTR_STATE_NMI);
+
+	vcpu->arch.exit_qualification = exit_qualification;
+	if (exit_qualification & SPPT_INDUCED_EXIT_TYPE) {
+		int page_num = KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL);
+		u32 *access;
+		gfn_t gfn_max;
+
+		/*
+		 * SPPT missing
+		 * We don't set SPP write access for the corresponding
+		 * GPA, if we haven't setup, we need to construct
+		 * SPP table here.
+		 */
+		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+		gfn = gpa >> PAGE_SHIFT;
+		trace_kvm_spp_induced_exit(vcpu, gpa, exit_qualification);
+		/*
+		 * In level 1 of SPPT, there's no PRESENT bit, all data is
+		 * regarded as permission vector, so need to check from
+		 * level 2 to set up the vector if target page is protected.
+		 */
+		spin_lock(&vcpu->kvm->mmu_lock);
+		gfn &= ~(page_num - 1);
+		gfn_max = gfn + page_num - 1;
+		for (; gfn <= gfn_max; gfn++) {
+			slot = gfn_to_memslot(vcpu->kvm, gfn);
+			if (!slot)
+				continue;
+			access = gfn_to_subpage_wp_info(slot, gfn);
+			if (access && *access != FULL_SPP_ACCESS)
+				kvm_spp_setup_structure(vcpu,
+							*access,
+							gfn);
+		}
+		spin_unlock(&vcpu->kvm->mmu_lock);
+		return 1;
+	}
+	/*
+	 * SPPT Misconfig
+	 * This is probably caused by some mis-configuration in SPPT
+	 * entries, cannot handle it here, escalate the fault to
+	 * emulator.
+	 */
+	WARN_ON(1);
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_SPP;
+	return 0;
+}
+
 static int handle_monitor(struct kvm_vcpu *vcpu)
 {
 	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
@@ -5575,6 +5649,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
 	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
+	[EXIT_REASON_SPP]                     = handle_spp,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
@@ -5807,6 +5882,9 @@ void dump_vmcs(void)
 		pr_err("PostedIntrVec = 0x%02x\n", vmcs_read16(POSTED_INTR_NV));
 	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT))
 		pr_err("EPT pointer = 0x%016llx\n", vmcs_read64(EPT_POINTER));
+	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_SPP))
+		pr_err("SPPT pointer = 0x%016llx\n", vmcs_read64(SPPT_POINTER));
+
 	n = vmcs_read32(CR3_TARGET_COUNT);
 	for (i = 0; i + 1 < n; i += 4)
 		pr_err("CR3 target%u=%016lx target%u=%016lx\n",
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb7da000ceaf..a9d7fc21dad6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9782,6 +9782,7 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	}
 
 	kvm_page_track_free_memslot(free, dont);
+	kvm_spp_free_memslot(free, dont);
 }
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
@@ -10406,3 +10407,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_set_subpages);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_page_fault);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 09e5e8e6e6dd..c0f3162ee46a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -244,6 +244,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_SPP              29
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -401,6 +402,11 @@ struct kvm_run {
 		struct {
 			__u8 vector;
 		} eoi;
+		/* KVM_EXIT_SPP */
+		struct {
+			__u64 addr;
+			__u8 ins_len;
+		} spp;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
 		/* KVM_EXIT_ARM_NISV */
-- 
2.17.2

