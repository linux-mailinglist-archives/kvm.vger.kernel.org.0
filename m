Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCAB1D6111
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgEPMyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:47569 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgEPMyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:54:04 -0400
IronPort-SDR: 4qK7A/7YYdVYf0j/DdyGtpPiMR79fdTf3AJdOssyvVof0Tb6bPWBAlxUJLmo+nzr0mbhYudOz5
 9Z6KU1iiDI9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:54:03 -0700
IronPort-SDR: p0nbApK4UxXAAZJn/uIbp1SYwsVqw9sAt4sS8sZFwhReAGv78lzaPoHhG6+BwAp4KkavI2MZXN
 2U80goF0WceQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076597"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:54:00 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 06/11] vmx: spp: Handle SPP induced vmexit and EPT violation
Date:   Sat, 16 May 2020 20:55:02 +0800
Message-Id: <20200516125507.5277-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
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
 arch/x86/include/asm/vmx.h      |  9 ++++
 arch/x86/include/uapi/asm/vmx.h |  2 +
 arch/x86/kvm/mmu/mmu.c          | 92 ++++++++++++++++++++++++++-------
 arch/x86/kvm/mmu/spp.c          | 27 ++++++++++
 arch/x86/kvm/mmu/spp.h          |  5 ++
 arch/x86/kvm/mmutrace.h         | 10 ++--
 arch/x86/kvm/trace.h            | 44 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          | 74 ++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |  2 +
 include/uapi/linux/kvm.h        |  6 +++
 11 files changed, 248 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c8fa8a5ebf4b..d34c0b91d427 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1260,6 +1260,8 @@ struct kvm_x86_ops {
 
 	bool (*apic_init_signal_blocked)(struct kvm_vcpu *vcpu);
 	int (*enable_direct_tlbflush)(struct kvm_vcpu *vcpu);
+
+	int (*get_insn_len)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 5e090d1f03f8..93000497ddd9 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -217,6 +217,8 @@ enum vmcs_field {
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
 	ENCLS_EXITING_BITMAP_HIGH	= 0x0000202F,
+	SPPT_POINTER			= 0x00002030,
+	SPPT_POINTER_HIGH		= 0x00002031,
 	TSC_MULTIPLIER                  = 0x00002032,
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
@@ -550,6 +552,13 @@ struct vmx_msr_entry {
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
index e95b72ec19bc..ab58c58e0b1f 100644
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
index 615effaf5814..270dd567272e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -22,6 +22,7 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 #include "cpuid.h"
+#include "spp.h"
 
 #include <linux/kvm_host.h>
 #include <linux/types.h>
@@ -170,6 +171,7 @@ module_param(dbg, bool, 0644);
 /* The mask for the R/X bits in EPT PTEs */
 #define PT64_EPT_READABLE_MASK			0x1ull
 #define PT64_EPT_EXECUTABLE_MASK		0x4ull
+#define PT64_SPP_SAVED_BIT	(1ULL << (PT64_SECOND_AVAIL_BITS_SHIFT + 1))
 
 #include <trace/events/kvm.h>
 
@@ -188,6 +190,7 @@ enum {
 	RET_PF_RETRY = 0,
 	RET_PF_EMULATE = 1,
 	RET_PF_INVALID = 2,
+	RET_PF_USERSPACE = 3,
 };
 
 #define for_each_shadow_entry_lockless(_vcpu, _addr, _walker, spte)	\
@@ -947,6 +950,9 @@ static u64 mark_spte_for_access_track(u64 spte)
 		shadow_acc_track_saved_bits_shift;
 	spte &= ~shadow_acc_track_mask;
 
+	if (spte & PT_SPP_MASK)
+		save_spp_bit(&spte);
+
 	return spte;
 }
 
@@ -1512,9 +1518,16 @@ static void drop_large_spte(struct kvm_vcpu *vcpu, u64 *sptep)
 bool spte_write_protect(u64 *sptep, bool pt_protect)
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
@@ -1555,9 +1568,15 @@ static bool spte_wrprot_for_clear_dirty(u64 *sptep)
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
 
@@ -3399,7 +3418,8 @@ static bool page_fault_can_be_fast(u32 error_code)
  */
 static bool
 fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-			u64 *sptep, u64 old_spte, u64 new_spte)
+			u64 *sptep, u64 old_spte, u64 new_spte,
+			bool spp_protected)
 {
 	gfn_t gfn;
 
@@ -3420,7 +3440,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (cmpxchg64(sptep, old_spte, new_spte) != old_spte)
 		return false;
 
-	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
+	if ((is_writable_pte(new_spte) && !is_writable_pte(old_spte)) ||
+	    spp_protected) {
 		/*
 		 * The gfn of direct spte is stable since it is
 		 * calculated by sp->gfn.
@@ -3446,15 +3467,17 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 
 /*
  * Return value:
- * - true: let the vcpu to access on the same address again.
- * - false: let the real page fault path to fix it.
+ * - RET_PF_INVALID: let the real page fault path to fix it.
+ * - RET_PF_RETRY: the fault has been fixed here.
+ * - RET_PF_USERSPACE: exit to user space to further handle it.
  */
-static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
-	bool fault_handled = false;
+	int ret = RET_PF_INVALID;
+	bool spp_protected = false;
 	u64 spte = 0ull;
 	uint retry_count = 0;
 
@@ -3485,7 +3508,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * they are always ACC_ALL.
 		 */
 		if (is_access_allowed(error_code, spte)) {
-			fault_handled = true;
+			ret = RET_PF_RETRY;
 			break;
 		}
 
@@ -3501,7 +3524,30 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 */
 		if ((error_code & PFERR_WRITE_MASK) &&
 		    spte_can_locklessly_be_made_writable(spte)) {
-			new_spte |= PT_WRITABLE_MASK;
+			/*
+			 * Record write protect fault caused by
+			 * Sub-page Protection, let VMI decide
+			 * the next step.
+			 */
+			if (spte & PT_SPP_MASK) {
+				int len = kvm_x86_ops.get_insn_len(vcpu);
+
+				ret = RET_PF_USERSPACE;
+				vcpu->run->exit_reason = KVM_EXIT_SPP;
+				vcpu->run->spp.addr = cr2_or_gpa;
+				vcpu->run->spp.insn_len = len;
+				trace_kvm_spp_induced_page_fault(vcpu,
+								 cr2_or_gpa,
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
@@ -3520,7 +3566,8 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 		/* Verify that the fault can be handled in the fast path */
 		if (new_spte == spte ||
-		    !is_access_allowed(error_code, new_spte))
+		    (!is_access_allowed(error_code, new_spte) &&
+		    !spp_protected))
 			break;
 
 		/*
@@ -3528,11 +3575,12 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.txt to get more detail.
 		 */
-		fault_handled = fast_pf_fix_direct_spte(vcpu, sp,
-							iterator.sptep, spte,
-							new_spte);
-		if (fault_handled)
-			break;
+		if (fast_pf_fix_direct_spte(vcpu, sp, iterator.sptep, spte,
+					    new_spte,
+					    spp_protected))
+			ret = RET_PF_RETRY;
+		else
+			ret = RET_PF_INVALID;
 
 		if (++retry_count > 4) {
 			printk_once(KERN_WARNING
@@ -3543,10 +3591,10 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	} while (true);
 
 	trace_fast_page_fault(vcpu, cr2_or_gpa, error_code, iterator.sptep,
-			      spte, fault_handled);
+			      spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
-	return fault_handled;
+	return ret;
 }
 
 static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
@@ -4077,8 +4125,10 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (lpage_disallowed)
 		max_level = PT_PAGE_TABLE_LEVEL;
 
-	if (fast_page_fault(vcpu, gpa, error_code))
-		return RET_PF_RETRY;
+	r = fast_page_fault(vcpu, gpa, error_code);
+
+	if (r != RET_PF_INVALID)
+		return r;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -5077,7 +5127,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots)
 		uint i;
 
 		vcpu->arch.mmu->root_hpa = INVALID_PAGE;
-
 		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 			vcpu->arch.mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 	}
@@ -5385,6 +5434,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (r == RET_PF_INVALID) {
 		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
 					  lower_32_bits(error_code), false);
+
 		WARN_ON(r == RET_PF_INVALID);
 	}
 
@@ -5393,6 +5443,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 	if (r < 0)
 		return r;
 
+	if (r == RET_PF_USERSPACE)
+		return 0;
 	/*
 	 * Before emulating the instruction, check if the error code
 	 * was due to a RO violation while translating the guest page.
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 25207f1ac9f8..bb8f298d72da 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -20,6 +20,25 @@ static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
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
@@ -33,6 +52,7 @@ u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
 
 	return &slot->arch.subpage_wp_info[idx];
 }
+EXPORT_SYMBOL_GPL(gfn_to_subpage_wp_info);
 
 static bool __rmap_update_subpage_bit(struct kvm *kvm,
 				      struct kvm_rmap_head *rmap_head,
@@ -204,6 +224,7 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 	kvm_flush_remote_tlbs(vcpu->kvm);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kvm_spp_setup_structure);
 
 int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages)
 {
@@ -450,3 +471,9 @@ int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
 
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
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index ffcd96fc02d0..76942390bcc2 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -245,13 +245,13 @@ TRACE_EVENT(
 );
 
 #define __spte_satisfied(__spte)				\
-	(__entry->retry && is_writable_pte(__entry->__spte))
+	(__entry->ret == RET_PF_RETRY && is_writable_pte(__entry->__spte))
 
 TRACE_EVENT(
 	fast_page_fault,
 	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
-		 u64 *sptep, u64 old_spte, bool retry),
-	TP_ARGS(vcpu, cr2_or_gpa, error_code, sptep, old_spte, retry),
+		 u64 *sptep, u64 old_spte, int ret),
+	TP_ARGS(vcpu, cr2_or_gpa, error_code, sptep, old_spte, ret),
 
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
@@ -260,7 +260,7 @@ TRACE_EVENT(
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
-		__field(bool, retry)
+		__field(int, ret)
 	),
 
 	TP_fast_assign(
@@ -270,7 +270,7 @@ TRACE_EVENT(
 		__entry->sptep = sptep;
 		__entry->old_spte = old_spte;
 		__entry->new_spte = *sptep;
-		__entry->retry = retry;
+		__entry->ret = ret;
 	),
 
 	TP_printk("vcpu %d gva %llx error_code %s sptep %p old %#llx"
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 035767345763..24bf0c18b84a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1561,6 +1561,50 @@ TRACE_EVENT(kvm_spp_set_subpages,
 		  __entry->access)
 );
 
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
index c2c6335a998c..452c93c296a0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -62,6 +62,7 @@
 #include "vmcs12.h"
 #include "vmx.h"
 #include "x86.h"
+#include "mmu/spp.h"
 
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
@@ -1402,6 +1403,13 @@ static bool emulation_required(struct kvm_vcpu *vcpu)
 	return emulate_invalid_guest_state && !guest_state_valid(vcpu);
 }
 
+static int vmx_get_insn_len(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+}
+
+static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
+
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5382,6 +5390,69 @@ static int handle_monitor_trap(struct kvm_vcpu *vcpu)
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
@@ -5596,6 +5667,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVVPID]                 = handle_vmx_instruction,
 	[EXIT_REASON_RDRAND]                  = handle_invalid_op,
 	[EXIT_REASON_RDSEED]                  = handle_invalid_op,
+	[EXIT_REASON_SPP]                     = handle_spp,
 	[EXIT_REASON_PML_FULL]		      = handle_pml_full,
 	[EXIT_REASON_INVPCID]                 = handle_invpcid,
 	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
@@ -7838,6 +7910,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
+
+	.get_insn_len = vmx_get_insn_len,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c0b09d8be31b..4b033a39d6c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10690,3 +10690,5 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_set_subpages);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_exit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_induced_page_fault);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2b70cf0d402a..b81094e1e1c7 100644
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

