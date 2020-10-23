Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63D52973DB
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751724AbgJWQbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751574AbgJWQan (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++OK9aDdWBuG1VAj7qvcjwI6Fhv0axAWeNiqvozQeYo=;
        b=D5Sm+EDt3h5CIpTMj9qHxqfi71+uIX2qzCLF3MlstmFKmXFuJLgtVBkk+sxpZ58cN2QS7Z
        2m6jqpyfrHDFF6L+IpoDkWz2SHXguBka93Qg8GCa/qBpE68b4kC/xZvFDQDni6d4NXRFF6
        ViZUpB6ON0JzYcm5ScJIpjNT5+N1Nv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-mqYQ0OHhMMOGGviad8EoEw-1; Fri, 23 Oct 2020 12:30:38 -0400
X-MC-Unique: mqYQ0OHhMMOGGviad8EoEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAC45804B91;
        Fri, 23 Oct 2020 16:30:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8341E59;
        Fri, 23 Oct 2020 16:30:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 12/22] kvm: x86/mmu: Add TDP MMU PF handler
Date:   Fri, 23 Oct 2020 12:30:14 -0400
Message-Id: <20201023163024.2765558-13-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Add functions to handle page faults in the TDP MMU. These page faults
are currently handled in much the same way as the x86 shadow paging
based MMU, however the ordering of some operations is slightly
different. Future patches will add eager NX splitting, a fast page fault
handler, and parallel page faults.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-11-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          |  53 +++++--------
 arch/x86/kvm/mmu/mmu_internal.h |  32 ++++++++
 arch/x86/kvm/mmu/mmutrace.h     |   8 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 134 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |   4 +
 5 files changed, 194 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6f22c155381d..31d7ba716b44 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -137,23 +137,6 @@ module_param(dbg, bool, 0644);
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
-/*
- * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
- *
- * RET_PF_RETRY: let CPU fault again on the address.
- * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
- * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
- * RET_PF_FIXED: The faulting entry has been fixed.
- * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
- */
-enum {
-	RET_PF_RETRY = 0,
-	RET_PF_EMULATE,
-	RET_PF_INVALID,
-	RET_PF_FIXED,
-	RET_PF_SPURIOUS,
-};
-
 struct pte_list_desc {
 	u64 *sptes[PTE_LIST_EXT];
 	struct pte_list_desc *more;
@@ -233,11 +216,8 @@ static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 			   unsigned int access)
 {
 	u64 mask = make_mmio_spte(vcpu, gfn, access);
-	unsigned int gen = get_mmio_spte_generation(mask);
 
-	access = mask & ACC_ALL;
-
-	trace_mark_mmio_spte(sptep, gfn, access, gen);
+	trace_mark_mmio_spte(sptep, gfn, mask);
 	mmu_spte_set(sptep, mask);
 }
 
@@ -2762,9 +2742,9 @@ static int host_pfn_mapping_level(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
-				   int max_level, kvm_pfn_t *pfnp,
-				   bool huge_page_disallowed, int *req_level)
+int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    int max_level, kvm_pfn_t *pfnp,
+			    bool huge_page_disallowed, int *req_level)
 {
 	struct kvm_memory_slot *slot;
 	struct kvm_lpage_info *linfo;
@@ -2818,10 +2798,10 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return level;
 }
 
-static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
-				       kvm_pfn_t *pfnp, int *levelp)
+void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				kvm_pfn_t *pfnp, int *goal_levelp)
 {
-	int level = *levelp;
+	int level = *goal_levelp;
 
 	if (cur_level == level && level > PG_LEVEL_4K &&
 	    is_shadow_present_pte(spte) &&
@@ -2836,7 +2816,7 @@ static void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 		u64 page_mask = KVM_PAGES_PER_HPAGE(level) -
 				KVM_PAGES_PER_HPAGE(level - 1);
 		*pfnp |= gfn & page_mask;
-		(*levelp)--;
+		(*goal_levelp)--;
 	}
 }
 
@@ -3643,9 +3623,11 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	r = fast_page_fault(vcpu, gpa, error_code);
-	if (r != RET_PF_INVALID)
-		return r;
+	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
+		r = fast_page_fault(vcpu, gpa, error_code);
+		if (r != RET_PF_INVALID)
+			return r;
+	}
 
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
@@ -3667,8 +3649,13 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	r = make_mmu_pages_available(vcpu);
 	if (r)
 		goto out_unlock;
-	r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
-			 prefault, is_tdp);
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
+				    pfn, prefault);
+	else
+		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
+				 prefault, is_tdp);
 
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 564954c6b079..6db40ea85974 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -111,4 +111,36 @@ static inline bool kvm_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return !sp->root_count;
 }
 
+/*
+ * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
+ *
+ * RET_PF_RETRY: let CPU fault again on the address.
+ * RET_PF_EMULATE: mmio page fault, emulate the instruction directly.
+ * RET_PF_INVALID: the spte is invalid, let the real page fault path update it.
+ * RET_PF_FIXED: The faulting entry has been fixed.
+ * RET_PF_SPURIOUS: The faulting entry was already fixed, e.g. by another vCPU.
+ */
+enum {
+	RET_PF_RETRY = 0,
+	RET_PF_EMULATE,
+	RET_PF_INVALID,
+	RET_PF_FIXED,
+	RET_PF_SPURIOUS,
+};
+
+/* Bits which may be returned by set_spte() */
+#define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
+#define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
+#define SET_SPTE_SPURIOUS		BIT(2)
+
+int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
+			    int max_level, kvm_pfn_t *pfnp,
+			    bool huge_page_disallowed, int *req_level);
+void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
+				kvm_pfn_t *pfnp, int *goal_levelp);
+
+bool is_nx_huge_page_enabled(void);
+
+void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index 2080f9c32213..213699b27b44 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -202,8 +202,8 @@ DEFINE_EVENT(kvm_mmu_page_class, kvm_mmu_prepare_zap_page,
 
 TRACE_EVENT(
 	mark_mmio_spte,
-	TP_PROTO(u64 *sptep, gfn_t gfn, unsigned access, unsigned int gen),
-	TP_ARGS(sptep, gfn, access, gen),
+	TP_PROTO(u64 *sptep, gfn_t gfn, u64 spte),
+	TP_ARGS(sptep, gfn, spte),
 
 	TP_STRUCT__entry(
 		__field(void *, sptep)
@@ -215,8 +215,8 @@ TRACE_EVENT(
 	TP_fast_assign(
 		__entry->sptep = sptep;
 		__entry->gfn = gfn;
-		__entry->access = access;
-		__entry->gen = gen;
+		__entry->access = spte & ACC_ALL;
+		__entry->gen = get_mmio_spte_generation(spte);
 	),
 
 	TP_printk("sptep:%p gfn %llx access %x gen %x", __entry->sptep,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 45a182475f68..ae8ac15b5623 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,6 +2,7 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "mmutrace.h"
 #include "tdp_iter.h"
 #include "tdp_mmu.h"
 #include "spte.h"
@@ -271,6 +272,10 @@ static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
+#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
+	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
+			 _mmu->shadow_root_level, _start, _end)
+
 /*
  * Flush the TLB if the process should drop kvm->mmu_lock.
  * Return whether the caller still needs to flush the tlb.
@@ -355,3 +360,132 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
+
+/*
+ * Installs a last-level SPTE to handle a TDP page fault.
+ * (NPT/EPT violation/misconfiguration)
+ */
+static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
+					  int map_writable,
+					  struct tdp_iter *iter,
+					  kvm_pfn_t pfn, bool prefault)
+{
+	u64 new_spte;
+	int ret = 0;
+	int make_spte_ret = 0;
+
+	if (unlikely(is_noslot_pfn(pfn))) {
+		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+		trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
+	} else
+		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
+					 pfn, iter->old_spte, prefault, true,
+					 map_writable, !shadow_accessed_mask,
+					 &new_spte);
+
+	if (new_spte == iter->old_spte)
+		ret = RET_PF_SPURIOUS;
+	else
+		tdp_mmu_set_spte(vcpu->kvm, iter, new_spte);
+
+	/*
+	 * If the page fault was caused by a write but the page is write
+	 * protected, emulation is needed. If the emulation was skipped,
+	 * the vCPU would have the same fault again.
+	 */
+	if (make_spte_ret & SET_SPTE_WRITE_PROTECTED_PT) {
+		if (write)
+			ret = RET_PF_EMULATE;
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
+
+	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
+	if (unlikely(is_mmio_spte(new_spte)))
+		ret = RET_PF_EMULATE;
+
+	trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
+	if (!prefault)
+		vcpu->stat.pf_fixed++;
+
+	return ret;
+}
+
+/*
+ * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
+ * page tables and SPTEs to translate the faulting guest physical address.
+ */
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		    int map_writable, int max_level, kvm_pfn_t pfn,
+		    bool prefault)
+{
+	bool nx_huge_page_workaround_enabled = is_nx_huge_page_enabled();
+	bool write = error_code & PFERR_WRITE_MASK;
+	bool exec = error_code & PFERR_FETCH_MASK;
+	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	struct tdp_iter iter;
+	struct kvm_mmu_memory_cache *pf_pt_cache =
+			&vcpu->arch.mmu_shadow_page_cache;
+	u64 *child_pt;
+	u64 new_spte;
+	int ret;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int level;
+	int req_level;
+
+	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
+		return RET_PF_RETRY;
+	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
+		return RET_PF_RETRY;
+
+	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
+					huge_page_disallowed, &req_level);
+
+	trace_kvm_mmu_spte_requested(gpa, level, pfn);
+	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+		if (nx_huge_page_workaround_enabled)
+			disallowed_hugepage_adjust(iter.old_spte, gfn,
+						   iter.level, &pfn, &level);
+
+		if (iter.level == level)
+			break;
+
+		/*
+		 * If there is an SPTE mapping a large page at a higher level
+		 * than the target, that SPTE must be cleared and replaced
+		 * with a non-leaf SPTE.
+		 */
+		if (is_shadow_present_pte(iter.old_spte) &&
+		    is_large_pte(iter.old_spte)) {
+			tdp_mmu_set_spte(vcpu->kvm, &iter, 0);
+
+			kvm_flush_remote_tlbs_with_address(vcpu->kvm, iter.gfn,
+					KVM_PAGES_PER_HPAGE(iter.level));
+
+			/*
+			 * The iter must explicitly re-read the spte here
+			 * because the new value informs the !present
+			 * path below.
+			 */
+			iter.old_spte = READ_ONCE(*iter.sptep);
+		}
+
+		if (!is_shadow_present_pte(iter.old_spte)) {
+			child_pt = kvm_mmu_memory_cache_alloc(pf_pt_cache);
+			clear_page(child_pt);
+			new_spte = make_nonleaf_spte(child_pt,
+						     !shadow_accessed_mask);
+
+			trace_kvm_mmu_get_page(sp, true);
+			tdp_mmu_set_spte(vcpu->kvm, &iter, new_spte);
+		}
+	}
+
+	if (WARN_ON(iter.level != level))
+		return RET_PF_RETRY;
+
+	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
+					      pfn, prefault);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6de2d007fc03..aed21a7a3bd6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -14,4 +14,8 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
 bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
+
+int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
+		    int map_writable, int max_level, kvm_pfn_t pfn,
+		    bool prefault);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


