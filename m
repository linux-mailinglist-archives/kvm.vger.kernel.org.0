Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4682114D8F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 09:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfLFIZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 03:25:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:25876 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726971AbfLFIZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 03:25:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 00:25:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="scan'208";a="294797965"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2019 00:25:17 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 06/10] vmx: spp: Set up SPP paging table at vmentry/vmexit
Date:   Fri,  6 Dec 2019 16:26:30 +0800
Message-Id: <20191206082634.21042-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191206082634.21042-1-weijiang.yang@intel.com>
References: <20191206082634.21042-1-weijiang.yang@intel.com>
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
 arch/x86/kvm/mmu/mmu.c          | 47 +++++++++++++++++++-
 arch/x86/kvm/mmu/spp.c          | 12 +++++
 arch/x86/kvm/mmu/spp.h          |  2 +
 arch/x86/kvm/vmx/vmx.c          | 78 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  2 +
 include/uapi/linux/kvm.h        |  6 +++
 8 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index e1137807affc..f41989eae5e2 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -211,6 +211,8 @@ enum vmcs_field {
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
+	SPPT_POINTER			= 0x00002030,
+	SPPT_POINTER_HIGH		= 0x00002031,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
@@ -532,6 +534,13 @@ struct vmx_msr_entry {
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
index f0b0c90dd398..ac67622bac5a 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -85,6 +85,7 @@
 #define EXIT_REASON_PML_FULL            62
 #define EXIT_REASON_XSAVES              63
 #define EXIT_REASON_XRSTORS             64
+#define EXIT_REASON_SPP                 66
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
@@ -141,6 +142,7 @@
 	{ EXIT_REASON_ENCLS,                 "ENCLS" }, \
 	{ EXIT_REASON_RDSEED,                "RDSEED" }, \
 	{ EXIT_REASON_PML_FULL,              "PML_FULL" }, \
+	{ EXIT_REASON_SPP,                   "SPP" }, \
 	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
 	{ EXIT_REASON_XRSTORS,               "XRSTORS" }
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a63964e7cec7..7c1118b81911 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -20,6 +20,7 @@
 #include "x86.h"
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
+#include "spp.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -137,6 +138,7 @@ module_param(dbg, bool, 0644);
 /* The mask for the R/X bits in EPT PTEs */
 #define PT64_EPT_READABLE_MASK			0x1ull
 #define PT64_EPT_EXECUTABLE_MASK		0x4ull
+#define PT64_SPP_SAVED_BIT	(1ULL << (PT64_SECOND_AVAIL_BITS_SHIFT + 1))
 
 #include <trace/events/kvm.h>
 
@@ -160,6 +162,7 @@ enum {
 	RET_PF_RETRY = 0,
 	RET_PF_EMULATE = 1,
 	RET_PF_INVALID = 2,
+	RET_PF_USERSPACE = 3,
 };
 
 struct pte_list_desc {
@@ -918,6 +921,11 @@ static u64 mark_spte_for_access_track(u64 spte)
 		shadow_acc_track_saved_bits_shift;
 	spte &= ~shadow_acc_track_mask;
 
+	if (spte & PT_SPP_MASK) {
+		spte &= ~PT_SPP_MASK;
+		spte |= PT64_SPP_SAVED_BIT;
+	}
+
 	return spte;
 }
 
@@ -1598,9 +1606,14 @@ static bool wrprot_ad_disabled_spte(u64 *sptep)
 {
 	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
 					       (unsigned long *)sptep);
+	bool was_spp_armed = test_and_clear_bit(PT_SPP_SHIFT,
+					       (unsigned long *)sptep);
 	if (was_writable)
 		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
 
+	if (was_spp_armed)
+		*sptep |= PT64_SPP_SAVED_BIT;
+
 	return was_writable;
 }
 
@@ -3453,7 +3466,24 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
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
+				fault_handled = true;
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = gva;
+				vcpu->run->spp.ins_len =
+					kvm_x86_ops->get_inst_len(vcpu);
+				break;
+			}
+
+			if (was_spp_armed(new_spte))
+				restore_spp_bit(&new_spte);
+			else
+				new_spte |= PT_WRITABLE_MASK;
 
 			/*
 			 * Do not fix write-permission on the large spte.  Since
@@ -3604,6 +3634,10 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(vcpu->kvm, &mmu->root_hpa,
 					   &invalid_list);
+			if (vcpu->kvm->arch.spp_active)
+				mmu_free_root_page(vcpu->kvm,
+						   &vcpu->kvm->arch.sppt_root,
+						   &invalid_list);
 		} else {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
@@ -5083,6 +5117,8 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
+		if (!vcpu->kvm->arch.spp_active)
+			vcpu->kvm->arch.sppt_root = INVALID_PAGE;
 
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
@@ -5400,6 +5436,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		r = vcpu->arch.mmu->page_fault(vcpu, cr2,
 					       lower_32_bits(error_code),
 					       false);
+
+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			r = RET_PF_USERSPACE;
+
 		WARN_ON(r == RET_PF_INVALID);
 	}
 
@@ -5407,7 +5447,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		return 1;
 	if (r < 0)
 		return r;
-
+	if (r == RET_PF_USERSPACE)
+		return 0;
 	/*
 	 * Before emulating the instruction, check if the error code
 	 * was due to a RO violation while translating the guest page.
@@ -6165,6 +6206,8 @@ unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm)
 	return nr_mmu_pages;
 }
 
+#include "spp.c"
+
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 85aefc3516b3..6f6e9d77247a 100644
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
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 370a6b71e143..3a2a71cea276 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -11,6 +11,8 @@ int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
 bool is_spp_spte(struct kvm_mmu_page *sp);
+void restore_spp_bit(u64 *spte);
+bool was_spp_armed(u64 spte);
 inline u64 construct_spptp(unsigned long root_hpa);
 int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
 			      u64 gfn,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 10132a2f62c3..1093bdadab7f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2896,6 +2896,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	struct kvm *kvm = vcpu->kvm;
 	unsigned long guest_cr3;
 	u64 eptp;
+	u64 spptp;
 
 	guest_cr3 = cr3;
 	if (enable_ept) {
@@ -2918,6 +2919,12 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		ept_load_pdptrs(vcpu);
 	}
 
+	if (kvm->arch.spp_active && VALID_PAGE(vcpu->kvm->arch.sppt_root)) {
+		spptp = construct_spptp(vcpu->kvm->arch.sppt_root);
+		vmcs_write64(SPPT_POINTER, spptp);
+		vmx_flush_tlb(vcpu, true);
+	}
+
 	vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
@@ -5338,6 +5345,73 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
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
@@ -5554,6 +5628,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
 	[EXIT_REASON_XSAVES]                  = handle_xsaves,
 	[EXIT_REASON_XRSTORS]                 = handle_xrstors,
+	[EXIT_REASON_SPP]                     = handle_spp,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
@@ -5786,6 +5861,9 @@ void dump_vmcs(void)
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
index cdbb3694f22c..85aa13dedb9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9567,6 +9567,8 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 	}
 
 	kvm_page_track_free_memslot(free, dont);
+	if (kvm->arch.spp_active)
+		kvm_spp_free_memslot(free, dont);
 }
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index f3a5a36a6c1c..9fc05f11bbee 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -243,6 +243,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_SPP              28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -398,6 +399,11 @@ struct kvm_run {
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
 		/* Fix the size of the union. */
-- 
2.17.2

