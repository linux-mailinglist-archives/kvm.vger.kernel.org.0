Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1CC141BD2
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 05:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgASEAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 23:00:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:62796 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgASEAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jan 2020 23:00:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jan 2020 20:00:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,336,1574150400"; 
   d="scan'208";a="214910497"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 18 Jan 2020 20:00:31 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 05/10] vmx: spp: Handle SPP induced vmexit and EPT violation
Date:   Sun, 19 Jan 2020 12:05:02 +0800
Message-Id: <20200119040507.23113-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200119040507.23113-1-weijiang.yang@intel.com>
References: <20200119040507.23113-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If write to subpage is prohibited, EPT violation is generated
and handled in fast_page_fault().

In current implementation, SPPT setup is handled in handle_spp()
handler, it's triggered when SPP is enabled in EPT leaf entry
while SPPT entry is invalid.

There could be two kinds of SPP usages, one is for write-protection,
the other is for access-tracking, the differece is the former keeps
memory unchange while the latter just records the memory access and
may let the write take effect. To fit these two cases, when SPP induced
vmexit to userspace, the fault instruction length is returned, the
application may take action according to the specific use-case, re-do
write operation or discard it.

To make SPP operatable with dirty-logging, introduce a free bit in
EPT entry to store SPP bit, after dirty-logging happened, it restores
SPP bit and make entry SPP protected again so that a retry write will
trigger a normal SPP induced vmexit.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +
 arch/x86/include/asm/vmx.h      |  9 +++++
 arch/x86/include/uapi/asm/vmx.h |  2 +
 arch/x86/kvm/mmu/mmu.c          | 66 ++++++++++++++++++++++++++----
 arch/x86/kvm/mmu/spp.c          | 28 +++++++++++++
 arch/x86/kvm/mmu/spp.h          |  5 +++
 arch/x86/kvm/trace.h            | 66 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 72 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  3 ++
 include/uapi/linux/kvm.h        |  6 +++
 10 files changed, 252 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4fb8816a328a..0cf886e58004 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1239,6 +1239,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+
+	int (*get_insn_len)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 1835767aa335..fc69ea8035fb 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -212,6 +212,8 @@ enum vmcs_field {
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
+	SPPT_POINTER			= 0x00002030,
+	SPPT_POINTER_HIGH		= 0x00002031,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
@@ -533,6 +535,13 @@ struct vmx_msr_entry {
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
index dff52763e05c..665923deb4a9 100644
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
@@ -979,6 +982,9 @@ static u64 mark_spte_for_access_track(u64 spte)
 		shadow_acc_track_saved_bits_shift;
 	spte &= ~shadow_acc_track_mask;
 
+	if (spte & PT_SPP_MASK)
+		save_spp_bit(&spte);
+
 	return spte;
 }
 
@@ -1634,9 +1640,16 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 static bool spte_write_protect(u64 *sptep, bool pt_protect)
 {
 	u64 spte = *sptep;
+	bool spp_protected = false;
+
+	if (spte & PT_SPP_MASK) {
+		save_spp_bit(&spte);
+		spp_protected = true;
+	}
 
 	if (!is_writable_pte(spte) &&
-	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
+	    !(pt_protect && spte_can_locklessly_be_made_writable(spte)) &&
+	    !spp_protected)
 		return false;
 
 	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);
@@ -1677,9 +1690,15 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
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
 
@@ -3478,7 +3497,8 @@ static bool page_fault_can_be_fast(u32 error_code)
  */
 static bool
 fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			u64 *sptep, u64 old_spte, u64 new_spte)
+			u64 *sptep, u64 old_spte, u64 new_spte,
+			bool spp_protected)
 {
 	gfn_t gfn;
 
@@ -3499,7 +3519,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
+	if ((is_writable_pte(new_spte) && !is_writable_pte(old_spte)) ||
+	    spp_protected) {
 		/*
 		 * The gfn of direct spte is stable since it is
 		 * calculated by sp->gfn.
@@ -3534,6 +3555,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	bool fault_handled = false;
+	bool spp_protected = false;
 	u64 spte = 0ull;
 	uint retry_count = 0;
 
@@ -3585,7 +3607,30 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
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
+				int len = kvm_x86_ops->get_insn_len(vcpu);
+
+				fault_handled = true;
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = gva;
+				vcpu->run->spp.insn_len = len;
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
@@ -3604,7 +3649,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(error_code, new_spte))
+		    (!is_access_allowed(error_code, new_spte) &&
+		    !spp_protected))
 			break;
 
 		/*
@@ -3614,7 +3660,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
 		 */
 		fault_handled = fast_pf_fix_direct_spte(vcpu, sp,
 							iterator.sptep, spte,
-							new_spte);
+							new_spte,
+							spp_protected);
 		if (fault_handled)
 			break;
 
@@ -5223,7 +5270,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
-
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 	}
@@ -5539,6 +5585,10 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 		r = vcpu->arch.mmu->page_fault(vcpu, cr2,
 					       lower_32_bits(error_code),
 					       false);
+
+		if (vcpu->run->exit_reason == KVM_EXIT_SPP)
+			r = RET_PF_USERSPACE;
+
 		WARN_ON(r == RET_PF_INVALID);
 	}
 
@@ -5547,6 +5597,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	if (r < 0)
 		return r;
 
+	if (r == RET_PF_USERSPACE)
+		return 0;
 	/*
 	 * Before emulating the instruction, check if the error code
 	 * was due to a RO violation while translating the guest page.
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index c9f5180c403b..2f2558c0041d 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -17,6 +17,25 @@ static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
 	iterator->level = PT64_ROOT_4LEVEL;
 }
 
+/* Save reserved bit for SPP armed PTE */
+void save_spp_bit(u64 *spte)
+{
+	*spte |= PT64_SPP_SAVED_BIT;
+	*spte &= ~PT_SPP_MASK;
+}
+
+/* Restore reserved bit for SPP armed PTE */
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
@@ -30,6 +49,7 @@ u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
 
 	return &slot->arch.subpage_wp_info[idx];
 }
+EXPORT_SYMBOL_GPL(gfn_to_subpage_wp_info);
 
 static bool __rmap_update_subpage_bit(struct kvm *kvm,
 				      struct kvm_rmap_head *rmap_head,
@@ -200,6 +220,7 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 	kvm_flush_remote_tlbs(vcpu->kvm);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_spp_setup_structure);
 
 int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages)
 {
@@ -331,6 +352,7 @@ int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 		if (!access)
 			return -EFAULT;
 		*access = access_map[i];
+		trace_kvm_spp_set_subpages(vcpu, gfn, *access);
 	}
 
 	gfn = old_gfn;
@@ -445,3 +467,9 @@ int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
 
 	return ret;
 }
+
+inline u64 construct_spptp(unsigned long root_hpa)
+{
+	return root_hpa & PAGE_MASK;
+}
+EXPORT_SYMBOL_GPL(construct_spptp);
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 75d4bfd64dbd..c3588c20be52 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -4,6 +4,7 @@
 
 #define FULL_SPP_ACCESS		(u32)(BIT_ULL(32) - 1)
 #define KVM_SUBPAGE_MAX_PAGES   512
+#define MAX_ENTRIES_PER_MMUPAGE BIT(9)
 
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
@@ -22,5 +23,9 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			    u32 access_map, gfn_t gfn);
 u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn);
 int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages);
+void save_spp_bit(u64 *spte);
+void restore_spp_bit(u64 *spte);
+bool was_spp_armed(u64 spte);
+u64 construct_spptp(unsigned long root_hpa);
 
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 7c741a0c5f80..afd2ddcc8ebd 100644
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
+	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t gpa, int insn_len),
+	TP_ARGS(vcpu, gpa, insn_len),
+
+	TP_STRUCT__entry(
+		__field(int, vcpu_id)
+		__field(gpa_t, gpa)
+		__field(int, insn_len)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->gpa = gpa;
+		__entry->insn_len = insn_len;
+	),
+
+	TP_printk("vcpu %d gpa %llx insn_len %d",
+		  __entry->vcpu_id,
+		  __entry->gpa,
+		  __entry->insn_len)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e3394c839dea..4032e615ca85 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -60,6 +60,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "mmu/spp.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -1422,6 +1423,11 @@ static bool emulation_required(struct kvm_vcpu *vcpu)
 	return emulate_invalid_guest_state && !guest_state_valid(vcpu);
 }
 
+static int vmx_get_insn_len(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+}
+
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
 
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -5350,6 +5356,69 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_spp(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qualification;
+	struct kvm_memory_slot *slot;
+	gfn_t gfn, gfn_end;
+	u32 *access;
+	gpa_t gpa;
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
+	if (WARN_ON(!(exit_qualification & SPPT_INDUCED_EXIT_TYPE)))
+		goto out_err;
+	/*
+	 * SPPT missing
+	 * We don't set SPP write access for the corresponding
+	 * GPA, if we haven't setup, we need to construct
+	 * SPP table here.
+	 */
+	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
+	gfn = gpa_to_gfn(gpa);
+	trace_kvm_spp_induced_exit(vcpu, gpa, exit_qualification);
+	/*
+	 * In level 1 of SPPT, there's no PRESENT bit, all data is
+	 * regarded as permission vector, so need to check from
+	 * level 2 to set up the vector if target page is protected.
+	 */
+	spin_lock(&vcpu->kvm->mmu_lock);
+	gfn &= ~(MAX_ENTRIES_PER_MMUPAGE - 1);
+	gfn_end = gfn + MAX_ENTRIES_PER_MMUPAGE;
+	for (; gfn < gfn_end; gfn++) {
+		slot = gfn_to_memslot(vcpu->kvm, gfn);
+		if (!slot)
+			continue;
+		access = gfn_to_subpage_wp_info(slot, gfn);
+		if (access && *access != FULL_SPP_ACCESS)
+			kvm_spp_setup_structure(vcpu, *access, gfn);
+	}
+	spin_unlock(&vcpu->kvm->mmu_lock);
+	return 1;
+out_err:
+	/*
+	 * SPPT Misconfig
+	 * This is probably caused by some mis-configuration in SPPT
+	 * entries, cannot handle it here, escalate the fault to
+	 * emulator.
+	 */
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_SPP;
+	return 0;
+}
+
 static int handle_monitor(struct kvm_vcpu *vcpu)
 {
 	printk_once(KERN_WARNING "kvm: MONITOR instruction emulated as NOP!\n");
@@ -5564,6 +5633,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
 	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
+	[EXIT_REASON_SPP]                     = handle_spp,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
@@ -7908,6 +7978,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+
+	.get_insn_len = vmx_get_insn_len,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48871882a00c..e93641d631cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10401,3 +10401,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pml_full);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_set_subpages);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_page_fault);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 04af48ee6452..280a6d52e5ff 100644
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
+			__u8 insn_len;
+		} spp;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
 		/* KVM_EXIT_ARM_NISV */
-- 
2.17.2

