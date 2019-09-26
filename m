Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B26BFBD4
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfIZXTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:06 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:45657 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfIZXTF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:05 -0400
Received: by mail-pf1-f202.google.com with SMTP id a2so495902pfo.12
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rbCHVX8S6Xv1F39QkuhFsIHrv/52XI+U8N8+e+hW8gw=;
        b=q8U3azyEov9GNtxrO8ip4/DIsryx6EgcujtMFmFSX0+OfjGrK+uNy8V5mCeW6s8eKW
         XtFWG4IoXLdm4Vpqk3abJ404vCOFR9GPFwMrbYs0oWsQF2SMBMLSvnJnLs3qzDaXLTXv
         G2ESGTx5i7t4Jdc+YwKF11J+YWAuY9iTOqOzUXGcnil7Q9YBsKwxNcmxjQsoaTdAlFq9
         ME+hxmwzghij5DB9dRdgw+L/jJ91VlQLj7+bMQ74KMaqGoHYwyY5YMfGuWh2DAdUWCjY
         ZyVvBX8RO3Hdef92cUo0kLDEM0+TB59pJa7MDPnmhfjhupUzCbVEA6lpqwD803w9e2T0
         soWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rbCHVX8S6Xv1F39QkuhFsIHrv/52XI+U8N8+e+hW8gw=;
        b=Va0DqQRC0L4httkdlrjJ/vuR7Jsn8qvhji+RIleFzg19C2t4MVnkyaQZr4Z5UND8lP
         jr0mPIEwWOxKfCYgIlc60brcDY5jCcDlgaNKqyCt5PMowvBFEG5bZgL5lOlWlycOqBF6
         UVJM68/RRvXGi31KMsngMn6h7MQ+sZgr5Uij5vfyRRQPUhk2opP9QpGO7sCKdvZTGSbE
         4rIQc++P+co8TkOINwHPCfGIEpMR8OqRApoT8fs0y1SZGrviDoMGcWdNx6wHprx777lT
         I6AQGuHC/szQsutYYZxwzbT2VzJ3VQLuXgSnCRpjQHXVveYtBtIiilyqeE/lUNWp9ONY
         aFFg==
X-Gm-Message-State: APjAAAWhPzfxFY4V7r7aVz1aacUH9xiPBV8jGruQ+Zk42oxk4WN0XuAP
        x96uwVpwGrzJsCZJGEFw3zxhwVXF1RuixMH4nk4Igac+ns3HEp78Wl1IDe2DXpY/CPzSnEYsL3g
        sllopuvVH7zL6Ll8pvoIF9iNMNF93bEwwykD7faXQDkPFznWLIV9VPIEnfWEy
X-Google-Smtp-Source: APXvYqyzLY70mk2MDnm2hHzEF95H4ysEgJkbwxekRuBokTH7fm+rfbx8OVdb6AEmuIT9fv5ORsZIR1N86B40
X-Received: by 2002:a63:5745:: with SMTP id h5mr6179668pgm.268.1569539944225;
 Thu, 26 Sep 2019 16:19:04 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:12 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-17-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 16/28] kvm: mmu: Add direct MMU page fault handler
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds handler functions to replace __direct_map in handling direct page
faults. These functions, unlike __direct_map can handle page faults on
multiple VCPUs simultaneously.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 192 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 179 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f0696658b527c..f3a26a32c8174 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1117,6 +1117,24 @@ static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 	return mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
 }
 
+/*
+ * Return an unused object to the specified cache. The object's memory should
+ * be zeroed before being returned if that memory was modified after allocation
+ * from the cache.
+ */
+static void mmu_memory_cache_return(struct kvm_mmu_memory_cache *mc,
+				     void *obj)
+{
+	/*
+	 * Since this object was allocated from the cache, the cache should
+	 * have at least one spare capacity to put the object back.
+	 */
+	BUG_ON(mc->nobjs >= ARRAY_SIZE(mc->objects));
+
+	mc->objects[mc->nobjs] = obj;
+	mc->nobjs++;
+}
+
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
@@ -2426,6 +2444,21 @@ static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
 	return r;
 }
 
+static u64 generate_nonleaf_pte(u64 *child_pt, bool ad_disabled)
+{
+	u64 pte;
+
+	pte = __pa(child_pt) | shadow_present_mask | PT_WRITABLE_MASK |
+	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
+
+	if (ad_disabled)
+		pte |= shadow_acc_track_value;
+	else
+		pte |= shadow_accessed_mask;
+
+	return pte;
+}
+
 /**
  * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
@@ -3432,13 +3465,7 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
 
-	spte = __pa(sp->spt) | shadow_present_mask | PT_WRITABLE_MASK |
-	       shadow_user_mask | shadow_x_mask | shadow_me_mask;
-
-	if (sp_ad_disabled(sp))
-		spte |= shadow_acc_track_value;
-	else
-		spte |= shadow_accessed_mask;
+	spte = generate_nonleaf_pte(sp->spt, sp_ad_disabled(sp));
 
 	mmu_spte_set(sptep, spte);
 
@@ -4071,6 +4098,126 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	return ret;
 }
 
+static int direct_page_fault_handle_target_level(struct kvm_vcpu *vcpu,
+		int write, int map_writable, struct direct_walk_iterator *iter,
+		kvm_pfn_t pfn, bool prefault)
+{
+	u64 new_pte;
+	int ret = 0;
+	int generate_pte_ret = 0;
+
+	if (unlikely(is_noslot_pfn(pfn)))
+		new_pte = generate_mmio_pte(vcpu, iter->pte_gfn_start, ACC_ALL);
+	else {
+		generate_pte_ret = generate_pte(vcpu, ACC_ALL, iter->level,
+						iter->pte_gfn_start, pfn,
+						iter->old_pte, prefault, false,
+						map_writable, false, &new_pte);
+		/* Failed to construct a PTE. Retry the page fault. */
+		if (!new_pte)
+			return RET_PF_RETRY;
+	}
+
+	/*
+	 * If the page fault was caused by a write but the page is write
+	 * protected, emulation is needed. If the emulation was skipped,
+	 * the vcpu would have the same fault again.
+	 */
+	if ((generate_pte_ret & SET_SPTE_WRITE_PROTECTED_PT) && write)
+		ret = RET_PF_EMULATE;
+
+	/* If an MMIO PTE was installed, the MMIO will need to be emulated. */
+	if (unlikely(is_mmio_spte(new_pte)))
+		ret = RET_PF_EMULATE;
+
+	/*
+	 * If this would not change the PTE then some other thread must have
+	 * already fixed the page fault and there's no need to proceed.
+	 */
+	if (iter->old_pte == new_pte)
+		return ret;
+
+	/*
+	 * If this warning were to trigger, it would indicate that there was a
+	 * missing MMU notifier or this thread raced with some notifier
+	 * handler. The page fault handler should never change a present, leaf
+	 * PTE to point to a differnt PFN. A notifier handler should have
+	 * zapped the PTE before the main MM's page table was changed.
+	 */
+	WARN_ON(is_present_direct_pte(iter->old_pte) &&
+		is_present_direct_pte(new_pte) &&
+		is_last_spte(iter->old_pte, iter->level) &&
+		is_last_spte(new_pte, iter->level) &&
+		spte_to_pfn(iter->old_pte) != spte_to_pfn(new_pte));
+
+	/*
+	 * If the page fault handler lost the race to set the PTE, retry the
+	 * page fault.
+	 */
+	if (!direct_walk_iterator_set_pte(iter, new_pte))
+		return RET_PF_RETRY;
+
+	/*
+	 * Update some stats for this page fault, if the page
+	 * fault was not speculative.
+	 */
+	if (!prefault)
+		vcpu->stat.pf_fixed++;
+
+	return ret;
+
+}
+
+static int handle_direct_page_fault(struct kvm_vcpu *vcpu,
+		unsigned long mmu_seq, int write, int map_writable, int level,
+		gpa_t gpa, gfn_t gfn, kvm_pfn_t pfn, bool prefault)
+{
+	struct direct_walk_iterator iter;
+	struct kvm_mmu_memory_cache *pf_pt_cache = &vcpu->arch.mmu_page_cache;
+	u64 *child_pt;
+	u64 new_pte;
+	int ret = RET_PF_RETRY;
+
+	direct_walk_iterator_setup_walk(&iter, vcpu->kvm,
+			kvm_arch_vcpu_memslots_id(vcpu), gpa >> PAGE_SHIFT,
+			(gpa >> PAGE_SHIFT) + 1, MMU_READ_LOCK);
+	while (direct_walk_iterator_next_pte(&iter)) {
+		if (iter.level == level) {
+			ret = direct_page_fault_handle_target_level(vcpu,
+					write, map_writable, &iter, pfn,
+					prefault);
+
+			break;
+		} else if (!is_present_direct_pte(iter.old_pte) ||
+			   is_large_pte(iter.old_pte)) {
+			/*
+			 * The leaf PTE for this fault must be mapped at a
+			 * lower level, so a non-leaf PTE must be inserted into
+			 * the paging structure. If the assignment below
+			 * succeeds, it will add the non-leaf PTE and a new
+			 * page of page table memory. Then the iterator can
+			 * traverse into that new page. If the atomic compare/
+			 * exchange fails, the iterator will repeat the current
+			 * PTE, so the only thing this function must do
+			 * differently is return the page table memory to the
+			 * vCPU's fault cache.
+			 */
+			child_pt = mmu_memory_cache_alloc(pf_pt_cache);
+			new_pte = generate_nonleaf_pte(child_pt, false);
+
+			if (!direct_walk_iterator_set_pte(&iter, new_pte))
+				mmu_memory_cache_return(pf_pt_cache, child_pt);
+		}
+	}
+	direct_walk_iterator_end_traversal(&iter);
+
+	/* If emulating, flush this vcpu's TLB. */
+	if (ret == RET_PF_EMULATE)
+		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
+
+	return ret;
+}
+
 static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *tsk)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, PAGE_SHIFT, tsk);
@@ -5014,7 +5161,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	int write = error_code & PFERR_WRITE_MASK;
-	bool map_writable;
+	bool map_writable = false;
 
 	MMU_WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa));
 
@@ -5035,8 +5182,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
 
-	if (fast_page_fault(vcpu, gpa, level, error_code))
-		return RET_PF_RETRY;
+	if (!vcpu->kvm->arch.direct_mmu_enabled)
+		if (fast_page_fault(vcpu, gpa, level, error_code))
+			return RET_PF_RETRY;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
@@ -5048,17 +5196,31 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		return r;
 
 	r = RET_PF_RETRY;
-	write_lock(&vcpu->kvm->mmu_lock);
+	if (vcpu->kvm->arch.direct_mmu_enabled)
+		read_lock(&vcpu->kvm->mmu_lock);
+	else
+		write_lock(&vcpu->kvm->mmu_lock);
+
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
 	if (make_mmu_pages_available(vcpu) < 0)
 		goto out_unlock;
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, gfn, &pfn, &level);
-	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault);
+
+	if (vcpu->kvm->arch.direct_mmu_enabled)
+		r = handle_direct_page_fault(vcpu, mmu_seq, write, map_writable,
+				level, gpa, gfn, pfn, prefault);
+	else
+		r = __direct_map(vcpu, gpa, write, map_writable, level, pfn,
+				 prefault);
 
 out_unlock:
-	write_unlock(&vcpu->kvm->mmu_lock);
+	if (vcpu->kvm->arch.direct_mmu_enabled)
+		read_unlock(&vcpu->kvm->mmu_lock);
+	else
+		write_unlock(&vcpu->kvm->mmu_lock);
+
 	kvm_release_pfn_clean(pfn);
 	return r;
 }
@@ -6242,6 +6404,10 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 {
 	LIST_HEAD(invalid_list);
 
+	if (vcpu->arch.mmu->direct_map && vcpu->kvm->arch.direct_mmu_enabled)
+		/* Reclaim is a todo. */
+		return true;
+
 	if (likely(kvm_mmu_available_pages(vcpu->kvm) >= KVM_MIN_FREE_MMU_PAGES))
 		return 0;
 
-- 
2.23.0.444.g18eeb5a265-goog

