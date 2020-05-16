Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F414E1D610E
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgEPMyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:47565 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbgEPMx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:53:59 -0400
IronPort-SDR: HZ2Yph5G/xNCVNZ2jz/N27q1SUWaHpk2EmgRimSDJnKQcrCrY9aleVm/9XOogEburo36CkaNzM
 PBIacxlSSpow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:53:58 -0700
IronPort-SDR: p6UgVDKu1J9Je+2AfURbSYYPFCYpy5QADCt53LNEa/p6eIdK0W6rwtcu5SCpGMeD9qpgFyG2sb
 Q7bB+Y6XVhCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076581"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:53:55 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 04/11] mmu: spp: Implement functions to {get|set}_subpage permission
Date:   Sat, 16 May 2020 20:55:00 +0800
Message-Id: <20200516125507.5277-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace application can {set|get} subpage permission via
IOCTLs if SPP has been initialized.

Steps for set_permission:
1)Store the permission vectors to SPP bitmap buffer.
2)Flush existing hugepage mapping in rmap so as to avoid
  stale mapping.
3)Walk EPT to check if gfn->pfn 4KB mapping is there,
  mark the existing entry as WP and SPP protected.
4)Zap the entry if gfn->pfn is hugepage mapping so that
  following memory access can trigger EPT page_fault() to
  set up SPP protection.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +
 arch/x86/kvm/mmu.h              |   2 +
 arch/x86/kvm/mmu/spp.c          | 244 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h          |  12 ++
 arch/x86/kvm/mmu_internal.h     |   2 +
 arch/x86/kvm/trace.h            |  22 +++
 arch/x86/kvm/x86.c              |   1 +
 include/uapi/linux/kvm.h        |   8 ++
 8 files changed, 294 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ee4721bd8703..c8fa8a5ebf4b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -723,6 +723,7 @@ struct kvm_vcpu_arch {
 	unsigned nmi_pending; /* NMI queued after currently running handler */
 	bool nmi_injected;    /* Trying to inject an NMI this entry */
 	bool smi_pending;    /* SMI queued after currently running handler */
+	bool spp_pending;    /* SPP has been requested, need to update VMCS */
 
 	struct kvm_mtrr mtrr_state;
 	u64 pat;
@@ -829,6 +830,7 @@ struct kvm_lpage_info {
 
 struct kvm_arch_memory_slot {
 	struct kvm_rmap_head *rmap[KVM_NR_PAGE_SIZES];
+	u32 *subpage_wp_info;
 	struct kvm_lpage_info *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned short *gfn_track[KVM_PAGE_TRACK_MAX];
 };
@@ -985,6 +987,7 @@ struct kvm_arch {
 	struct task_struct *nx_lpage_recovery_thread;
 
 	hpa_t sppt_root;
+	bool spp_active;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index da199f0a69db..10cf86b3c60a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -26,6 +26,8 @@
 #define PT_GLOBAL_MASK (1ULL << 8)
 #define PT64_NX_SHIFT 63
 #define PT64_NX_MASK (1ULL << PT64_NX_SHIFT)
+#define PT_SPP_SHIFT 61
+#define PT_SPP_MASK (1ULL << PT_SPP_SHIFT)
 
 #define PT_PAT_SHIFT 7
 #define PT_DIR_PAT_SHIFT 12
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 8924096df390..df5d79b17ef3 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -2,6 +2,7 @@
 #include <linux/kvm_host.h>
 #include "mmu_internal.h"
 #include "mmu.h"
+#include "trace.h"
 #include "spp.h"
 
 #define for_each_shadow_spp_entry(_vcpu, _addr, _walker)    \
@@ -19,6 +20,68 @@ static void shadow_spp_walk_init(struct kvm_shadow_walk_iterator *iterator,
 	iterator->level = PT64_ROOT_4LEVEL;
 }
 
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long idx;
+
+	if (!slot->arch.subpage_wp_info)
+		return NULL;
+
+	idx = gfn_to_index(gfn, slot->base_gfn, PT_PAGE_TABLE_LEVEL);
+	if (idx > slot->npages - 1)
+		return NULL;
+
+	return &slot->arch.subpage_wp_info[idx];
+}
+
+static bool __rmap_update_subpage_bit(struct kvm *kvm,
+				      struct kvm_rmap_head *rmap_head,
+				      bool setbit)
+{
+	struct rmap_iterator iter;
+	bool flush = false;
+	u64 *sptep;
+	u64 spte;
+
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
+		/*
+		 * SPP works only when the page is write-protected
+		 * and SPP bit is set in EPT leaf entry.
+		 */
+		flush |= spte_write_protect(sptep, false);
+		spte = setbit ? (*sptep | PT_SPP_MASK) :
+				(*sptep & ~PT_SPP_MASK);
+		flush |= mmu_spte_update(sptep, spte);
+	}
+
+	return flush;
+}
+
+static int kvm_spp_update_write_protect(struct kvm *kvm,
+					struct kvm_memory_slot *slot,
+					gfn_t gfn,
+					bool enable)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool flush = false;
+
+	/*
+	 * SPP is only supported with 4KB level1 memory page, check
+	 * if the page is mapped in EPT leaf entry.
+	 */
+	rmap_head = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
+
+	if (!rmap_head->val)
+		return -EFAULT;
+
+	flush |= __rmap_update_subpage_bit(kvm, rmap_head, enable);
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+
+	return 0;
+}
+
 struct kvm_mmu_page *kvm_spp_get_page(struct kvm_vcpu *vcpu,
 				      gfn_t gfn,
 				      unsigned int level)
@@ -84,6 +147,20 @@ static void spp_spte_set(u64 *sptep, u64 new_spte)
 	__set_spte(sptep, new_spte);
 }
 
+static int kvm_spp_level_pages(gfn_t gfn_lower, gfn_t gfn_upper, int level)
+{
+	int page_num = KVM_PAGES_PER_HPAGE(level);
+	gfn_t gfn_max = (gfn_lower & ~(page_num - 1)) + page_num - 1;
+	int ret;
+
+	if (gfn_upper <= gfn_max)
+		ret = gfn_upper - gfn_lower + 1;
+	else
+		ret = gfn_max - gfn_lower + 1;
+
+	return ret;
+}
+
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			    u32 access_map, gfn_t gfn)
 {
@@ -127,3 +204,170 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 	kvm_flush_remote_tlbs(vcpu->kvm);
 	return ret;
 }
+
+int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map)
+{
+	u32 *access;
+	struct kvm_memory_slot *slot;
+	int i;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot)
+			return -EFAULT;
+		access = gfn_to_subpage_wp_info(slot, gfn);
+		if (!access)
+			return -EFAULT;
+		access_map[i] = *access;
+	}
+
+	return i;
+}
+
+static void kvm_spp_zap_pte(struct kvm *kvm, u64 *spte, int level)
+{
+	u64 pte;
+
+	pte = *spte;
+	if (is_shadow_present_pte(pte) && is_last_spte(pte, level)) {
+		drop_spte(kvm, spte);
+		if (is_large_pte(pte))
+			--kvm->stat.lpages;
+	}
+}
+
+static bool kvm_spp_flush_rmap(struct kvm *kvm, u64 gfn_min, u64 gfn_max)
+{
+	u64 *sptep;
+	struct rmap_iterator iter;
+	struct kvm_rmap_head *rmap_head;
+	int level;
+	struct kvm_memory_slot *slot;
+	bool flush = false;
+
+	slot = gfn_to_memslot(kvm, gfn_min);
+	if (!slot)
+		return false;
+
+	for (; gfn_min <= gfn_max; gfn_min++) {
+		for (level = PT_PAGE_TABLE_LEVEL;
+		     level <= PT_DIRECTORY_LEVEL; level++) {
+			rmap_head = __gfn_to_rmap(gfn_min, level, slot);
+			for_each_rmap_spte(rmap_head, &iter, sptep) {
+				pte_list_remove(rmap_head, sptep);
+				flush = true;
+			}
+		}
+	}
+
+	return flush;
+}
+
+int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map)
+{
+	gfn_t old_gfn = gfn;
+	u32 *access;
+	struct kvm_memory_slot *slot;
+	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_vcpu *vcpu;
+	gfn_t gfn_end;
+	int i, count, level;
+	bool flush = false;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (!VALID_PAGE(vcpu->kvm->arch.sppt_root))
+		return -EFAULT;
+
+	for (i = 0; i < npages; i++, gfn++) {
+		slot = gfn_to_memslot(kvm, gfn);
+		if (!slot)
+			return -EFAULT;
+
+		access = gfn_to_subpage_wp_info(slot, gfn);
+		if (!access)
+			return -EFAULT;
+		*access = access_map[i];
+		trace_kvm_spp_set_subpages(vcpu, gfn, *access);
+	}
+
+	gfn = old_gfn;
+	gfn_end = gfn + npages - 1;
+	vcpu = kvm_get_vcpu(kvm, 0);
+
+	if (!vcpu || (vcpu && !VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		goto out;
+
+	/* Flush any existing stale mappings in EPT before set up SPP */
+	flush = kvm_spp_flush_rmap(kvm, gfn, gfn_end);
+
+	for (i = 0; gfn <= gfn_end; i++, gfn++) {
+		for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
+			if (!is_shadow_present_pte(*iterator.sptep))
+				break;
+
+			if (iterator.level == PT_PAGE_TABLE_LEVEL) {
+				if (kvm_spp_mark_protection(kvm,
+							    gfn,
+							    access_map[i]) < 0)
+					return -EFAULT;
+				break;
+			} else if (is_large_pte(*iterator.sptep)) {
+				level = iterator.level;
+				if (access_map[i] == FULL_SPP_ACCESS)
+					break;
+				count = kvm_spp_level_pages(gfn,
+							    gfn_end,
+							    level);
+				/*
+				 * Zap existing hugepage entry so that eligible
+				 * 4KB mappings can be rebuilt in page_fault.
+				 */
+				kvm_spp_zap_pte(kvm, iterator.sptep, level);
+				flush = true;
+				if (count >= npages)
+					goto out;
+				gfn += count - 1;
+			}
+		}
+	}
+out:
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	return npages;
+}
+
+int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_rmap_head *rmap_head;
+	int ret = 0;
+	bool enable;
+
+	if (!kvm->arch.spp_active)
+		return -ENODEV;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot)
+		return -EFAULT;
+
+	/*
+	 * check whether the target 4KB page exists in EPT leaf
+	 * entry.If it's there, just flag SPP bit of the entry,
+	 * defer the setup to SPPT miss induced vm-exit  handler.
+	 */
+	rmap_head = __gfn_to_rmap(gfn, PT_PAGE_TABLE_LEVEL, slot);
+
+	if (rmap_head->val) {
+		enable = access != FULL_SPP_ACCESS;
+		ret = kvm_spp_update_write_protect(kvm, slot, gfn, enable);
+	}
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 03e4dfad595a..9171e682be1f 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -2,4 +2,16 @@
 #ifndef __KVM_X86_VMX_SPP_H
 #define __KVM_X86_VMX_SPP_H
 
+#define FULL_SPP_ACCESS		(u32)(BIT_ULL(32) - 1)
+
+int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map);
+int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
+			   u32 *access_map);
+int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
+
+int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
+			    u32 access_map, gfn_t gfn);
+u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn);
+
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/arch/x86/kvm/mmu_internal.h b/arch/x86/kvm/mmu_internal.h
index 68e8179e7642..e54594941377 100644
--- a/arch/x86/kvm/mmu_internal.h
+++ b/arch/x86/kvm/mmu_internal.h
@@ -124,6 +124,8 @@ void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep);
 
 u64 __get_spte_lockless(u64 *sptep);
 
+void pte_list_remove(struct kvm_rmap_head *rmap_head, u64 *sptep);
+
 u64 mmu_spte_get_lockless(u64 *sptep);
 
 unsigned kvm_page_table_hashfn(gfn_t gfn);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 249062f24b94..035767345763 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1539,6 +1539,28 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
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
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d786c7d27ce5..35e4b57dbabf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10601,3 +10601,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_spp_set_subpages);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 428c7dde6b4b..63a477720a17 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -102,6 +102,14 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SUBPAGES_GET_ACCESS and KVM_SUBPAGES_SET_ACCESS */
+struct kvm_subpage {
+	__u64 gfn_base; /* the first page gfn of the contiguous pages */
+	__u32 npages;   /* number of 4K pages */
+	__u32 flags;    /* reserved to 0 now */
+	__u32 access_map[0]; /* start place of bitmap array */
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
  * other bits are reserved for kvm internal use which are defined in
-- 
2.17.2

