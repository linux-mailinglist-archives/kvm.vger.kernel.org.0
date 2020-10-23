Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045C02973D9
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751720AbgJWQbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751573AbgJWQan (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yhiJXzKFyqqoWqO/EGw6Xzoufz1ZMORVFMnNeOW9iD8=;
        b=YLx5D7WeC+oMuscd8SDFZ2KBWVrW/kYgzCktM5O5BllVNTgzMRF6UTuBYi2zwkVoYoYtbM
        WILsTxq++UKXxy3ACKQq1e5LhW2uWsWzB2Hddllp3Xt46gOFJkxHbkMGfTa6Y3sQyCKKMh
        J2EJs464FZlOlMBzVIQf5CLkmNh1WWM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-z3fvumK9Pm6FhA-7uJuqcw-1; Fri, 23 Oct 2020 12:30:38 -0400
X-MC-Unique: z3fvumK9Pm6FhA-7uJuqcw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8B7410E218E;
        Fri, 23 Oct 2020 16:30:36 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92E4D61983;
        Fri, 23 Oct 2020 16:30:36 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 10/22] kvm: x86/mmu: Support zapping SPTEs in the TDP MMU
Date:   Fri, 23 Oct 2020 12:30:12 -0400
Message-Id: <20201023163024.2765558-11-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Add functions to zap SPTEs to the TDP MMU. These are needed to tear down
TDP MMU roots properly and implement other MMU functions which require
tearing down mappings. Future patches will add functions to populate the
page tables, but as for this patch there will not be any work for these
functions to do.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-8-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c      |  15 +++++
 arch/x86/kvm/mmu/tdp_iter.c |   5 ++
 arch/x86/kvm/mmu/tdp_iter.h |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c  | 113 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h  |   2 +
 5 files changed, 136 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9c8f42e17f44..dd15e519c361 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5371,6 +5371,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm_reload_remote_mmus(kvm);
 
 	kvm_zap_obsolete_pages(kvm);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_all(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -5411,6 +5415,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
+	bool flush;
 
 	spin_lock(&kvm->mmu_lock);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
@@ -5430,6 +5435,12 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
+	if (kvm->arch.tdp_mmu_enabled) {
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
+		if (flush)
+			kvm_flush_remote_tlbs(kvm);
+	}
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -5596,6 +5607,10 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	}
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_all(kvm);
+
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index ad2184cb054c..87b7e16911db 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -175,3 +175,8 @@ void tdp_iter_refresh_walk(struct tdp_iter *iter)
 		       iter->root_level, iter->min_level, goal_gfn);
 }
 
+u64 *tdp_iter_root_pt(struct tdp_iter *iter)
+{
+	return iter->pt_path[iter->root_level - 1];
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index d629a53e1b73..884ed2c70bfe 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -52,5 +52,6 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t goal_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_refresh_walk(struct tdp_iter *iter);
+u64 *tdp_iter_root_pt(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8accfae76bf6..45a182475f68 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -49,8 +49,13 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 	return sp->tdp_mmu_page && sp->root_count;
 }
 
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end);
+
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
+	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+
 	lockdep_assert_held(&kvm->mmu_lock);
 
 	WARN_ON(root->root_count);
@@ -58,6 +63,8 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
+	zap_gfn_range(kvm, root, 0, max_gfn);
+
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
 }
@@ -135,6 +142,11 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level);
 
+static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -242,3 +254,104 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
 }
+
+static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				    u64 new_spte)
+{
+	u64 *root_pt = tdp_iter_root_pt(iter);
+	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
+	int as_id = kvm_mmu_page_as_id(root);
+
+	*iter->sptep = new_spte;
+
+	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			    iter->level);
+}
+
+#define tdp_root_for_each_pte(_iter, _root, _start, _end) \
+	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
+
+/*
+ * Flush the TLB if the process should drop kvm->mmu_lock.
+ * Return whether the caller still needs to flush the tlb.
+ */
+static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		kvm_flush_remote_tlbs(kvm);
+		cond_resched_lock(&kvm->mmu_lock);
+		tdp_iter_refresh_walk(iter);
+		return false;
+	} else {
+		return true;
+	}
+}
+
+/*
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
+ */
+static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			  gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+	bool flush_needed = false;
+
+	tdp_root_for_each_pte(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * If this is a non-last-level SPTE that covers a larger range
+		 * than should be zapped, continue, and zap the mappings at a
+		 * lower level.
+		 */
+		if ((iter.gfn < start ||
+		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		tdp_mmu_set_spte(kvm, &iter, 0);
+
+		flush_needed = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+	}
+	return flush_needed;
+}
+
+/*
+ * Tears down the mappings for the range of gfns, [start, end), and frees the
+ * non-root pages mapping GFNs strictly within that range. Returns true if
+ * SPTEs have been cleared and a TLB flush is needed before releasing the
+ * MMU lock.
+ */
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct kvm_mmu_page *root;
+	bool flush = false;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		kvm_mmu_get_root(kvm, root);
+
+		flush |= zap_gfn_range(kvm, root, start, end);
+
+		kvm_mmu_put_root(kvm, root);
+	}
+
+	return flush;
+}
+
+void kvm_tdp_mmu_zap_all(struct kvm *kvm)
+{
+	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+	bool flush;
+
+	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ac0ef9129442..6de2d007fc03 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -12,4 +12,6 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


