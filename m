Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5E32973D0
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751616AbgJWQar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751591AbgJWQaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+79wfcN7sOPjcSkmVYkNoUiPxaQGzr+EIZNN0cNNQEk=;
        b=YP8H3DIuIcF+XbDZ1yN7euBT87gaNacy12GdaUmv0j36HzjbFgmpI4sRHhRk/F9PaixnDM
        xT1UEI52Zj6El7Juh3cdQJcfp66+3gffpv0Y9IYuzb7+l0iVm3LAUtAm1DSUms72ogqEpi
        8NBdlPU3LhdAdw62kB6XbQF0umnZDc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-x6BfkfQeO162Yx8woA2LlQ-1; Fri, 23 Oct 2020 12:30:40 -0400
X-MC-Unique: x6BfkfQeO162Yx8woA2LlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74A9EE9003;
        Fri, 23 Oct 2020 16:30:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9D4260FC2;
        Fri, 23 Oct 2020 16:30:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 15/22] kvm: x86/mmu: Add access tracking for tdp_mmu
Date:   Fri, 23 Oct 2020 12:30:17 -0400
Message-Id: <20201023163024.2765558-16-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. The
main Linux MM uses the access tracking MMU notifiers for swap and other
features. Add hooks to handle the test/flush HVA (range) family of
MMU notifiers.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-14-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  16 +++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 115 +++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |   4 ++
 3 files changed, 128 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 35c277ed6c78..33ec6c4c36d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1558,12 +1558,24 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 {
-	return kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
+	int young = false;
+
+	young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
+	if (kvm->arch.tdp_mmu_enabled)
+		young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
+
+	return young;
 }
 
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 {
-	return kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+	int young = false;
+
+	young = kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+	if (kvm->arch.tdp_mmu_enabled)
+		young |= kvm_tdp_mmu_test_age_hva(kvm, hva);
+
+	return young;
 }
 
 #ifdef MMU_DEBUG
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 96bc6aa39628..dd6b8a8f1c93 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -149,6 +149,18 @@ static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return sp->role.smm ? 1 : 0;
 }
 
+static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
+{
+	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+
+	if (!is_shadow_present_pte(old_spte) || !is_last_spte(old_spte, level))
+		return;
+
+	if (is_accessed_spte(old_spte) &&
+	    (!is_accessed_spte(new_spte) || pfn_changed))
+		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -260,24 +272,48 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level)
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+	handle_changed_spte_acc_track(old_spte, new_spte, level);
 }
 
-static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				    u64 new_spte)
+static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				      u64 new_spte, bool record_acc_track)
 {
 	u64 *root_pt = tdp_iter_root_pt(iter);
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
-	*iter->sptep = new_spte;
+	WRITE_ONCE(*iter->sptep, new_spte);
+
+	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			      iter->level);
+	if (record_acc_track)
+		handle_changed_spte_acc_track(iter->old_spte, new_spte,
+					      iter->level);
+}
+
+static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
+				    u64 new_spte)
+{
+	__tdp_mmu_set_spte(kvm, iter, new_spte, true);
+}
 
-	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			    iter->level);
+static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
+						 struct tdp_iter *iter,
+						 u64 new_spte)
+{
+	__tdp_mmu_set_spte(kvm, iter, new_spte, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
 	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
 
+#define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
+	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
+		if (!is_shadow_present_pte(_iter.old_spte) ||		\
+		    !is_last_spte(_iter.old_spte, _iter.level))		\
+			continue;					\
+		else
+
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
 	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
 			 _mmu->shadow_root_level, _start, _end)
@@ -566,3 +602,72 @@ int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
 					    zap_gfn_range_hva_wrapper);
 }
+
+/*
+ * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
+ * if any of the GFNs in the range have been accessed.
+ */
+static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
+			 struct kvm_mmu_page *root, gfn_t start, gfn_t end,
+			 unsigned long unused)
+{
+	struct tdp_iter iter;
+	int young = 0;
+	u64 new_spte = 0;
+
+	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		/*
+		 * If we have a non-accessed entry we don't need to change the
+		 * pte.
+		 */
+		if (!is_accessed_spte(iter.old_spte))
+			continue;
+
+		new_spte = iter.old_spte;
+
+		if (spte_ad_enabled(new_spte)) {
+			clear_bit((ffs(shadow_accessed_mask) - 1),
+				  (unsigned long *)&new_spte);
+		} else {
+			/*
+			 * Capture the dirty status of the page, so that it doesn't get
+			 * lost when the SPTE is marked for access tracking.
+			 */
+			if (is_writable_pte(new_spte))
+				kvm_set_pfn_dirty(spte_to_pfn(new_spte));
+
+			new_spte = mark_spte_for_access_track(new_spte);
+		}
+
+		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
+		young = 1;
+	}
+
+	return young;
+}
+
+int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
+					    age_gfn_range);
+}
+
+static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
+			unsigned long unused2)
+{
+	struct tdp_iter iter;
+
+	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1)
+		if (is_accessed_spte(iter.old_spte))
+			return 1;
+
+	return 0;
+}
+
+int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
+					    test_age_gfn);
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index af25d2462cb8..ddc1bf12d0fc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -21,4 +21,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
+
+int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
+			      unsigned long end);
+int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


