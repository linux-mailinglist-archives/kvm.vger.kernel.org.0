Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA33A4CC633
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236093AbiCCTkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbiCCTkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C288019DE8F
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aQoDHlVtrcSMoo1UFCKrxhQ0omxkP0XsMPj2xm4Z4J8=;
        b=SNMW04+o59UP1QKrTqFu320MREpvDRHZ0H2RUAipCJRP99LYRXIQQuBqLZQFAO4ReNtUbb
        lu9OJltKksWs4FELev0jE0qJDj2C7gLiIYtYkP/t5i2E68d+8qQ+VlK6M/Ev8fTVI63XVN
        ydDCa5iR6WCwLWzVeA//8+PeMg8AN/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-WLC65XjFNP25u6vCQjptzg-1; Thu, 03 Mar 2022 14:39:03 -0500
X-MC-Unique: WLC65XjFNP25u6vCQjptzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2208A801AAD;
        Thu,  3 Mar 2022 19:39:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4EB295DF2E;
        Thu,  3 Mar 2022 19:39:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 18/30] KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
Date:   Thu,  3 Mar 2022 14:38:30 -0500
Message-Id: <20220303193842.370645-19-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Zap only leaf SPTEs in the TDP MMU's zap_gfn_range(), and rename various
functions accordingly.  When removing mappings for functional correctness
(except for the stupid VFIO GPU passthrough memslots bug), zapping the
leaf SPTEs is sufficient as the paging structures themselves do not point
at guest memory and do not directly impact the final translation (in the
TDP MMU).

Note, this aligns the TDP MMU with the legacy/full MMU, which zaps only
the rmaps, a.k.a. leaf SPTEs, in kvm_zap_gfn_range() and
kvm_unmap_gfn_range().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-18-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c | 41 ++++++++++----------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  8 +-------
 3 files changed, 14 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8408d7db8d2a..febdcaaa7b94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5834,8 +5834,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush);
+			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
+						      gfn_end, true, flush);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f3939ce4a115..c71debdbc732 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -834,10 +834,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 }
 
 /*
- * Tears down the mappings for the range of gfns, [start, end), and frees the
- * non-root pages mapping GFNs strictly within that range. Returns true if
- * SPTEs have been cleared and a TLB flush is needed before releasing the
- * MMU lock.
+ * Zap leafs SPTEs for the range of gfns, [start, end). Returns true if SPTEs
+ * have been cleared and a TLB flush is needed before releasing the MMU lock.
  *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -845,42 +843,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
  * the caller must ensure it does not supply too large a GFN range, or the
  * operation can cause a soft lockup.
  */
-static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush)
+static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
+			      gfn_t start, gfn_t end, bool can_yield, bool flush)
 {
-	bool zap_all = (start == 0 && end >= tdp_mmu_max_gfn_host());
 	struct tdp_iter iter;
 
-	/*
-	 * No need to try to step down in the iterator when zapping all SPTEs,
-	 * zapping the top-level non-leaf SPTEs will recurse on their children.
-	 */
-	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
-
 	end = min(end, tdp_mmu_max_gfn_host());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
 
-		if (!is_shadow_present_pte(iter.old_spte))
-			continue;
-
-		/*
-		 * If this is a non-last-level SPTE that covers a larger range
-		 * than should be zapped, continue, and zap the mappings at a
-		 * lower level, except when zapping all SPTEs.
-		 */
-		if (!zap_all &&
-		    (iter.gfn < start ||
-		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
+		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
@@ -898,13 +879,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
  */
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush)
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+			   bool can_yield, bool flush)
 {
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
 
 	return flush;
 }
@@ -1202,8 +1183,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, range->slot->as_id, range->start,
-					   range->end, range->may_block, flush);
+	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
+				     range->end, range->may_block, flush);
 }
 
 typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5e5ef2576c81..54bc8118c40a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -15,14 +15,8 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared);
 
-bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
 				 gfn_t end, bool can_yield, bool flush);
-static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush)
-{
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
-}
-
 bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
-- 
2.31.1


