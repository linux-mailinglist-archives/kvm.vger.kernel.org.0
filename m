Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DC04E7C4C
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiCYXFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 19:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiCYXF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 19:05:29 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290DA22AC64
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:03:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y27-20020aa7943b000000b004f6decccdb5so4787226pfo.1
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=vIZny/CAiv+ANOXSTnw9s080uSQEaVCa1l5Fcgc1E+w=;
        b=Rb44Mwugw4jLeCPcJ8XmiEkJxqSQGlAZvT7J82evV17/LUbc5ZBMaJFePJXClt4Wz0
         hl7x5t/82xJsJ8wDQXMZl8OjIX3pHssHP/i+pg9XmQH/DsDkj4hqhfL+twswvwpyzbC0
         VtU6qaq4jYjo70TfXznFHaGNgqsIXzGR+dzIzPGtoowCJnkCMlIFJL3JsL/e4OBAIb+x
         pggRVIt2cOSKRZwOIpP8OK03rU/gi31d6HFYU4zkaQKU6owzhw2NJSKoZVn+i5o7QLFK
         f+mVMHae2CCMJAs76ycnkUZvfO/6ZLbc2arHUeWWYhOl12pelzotYp5vgjYZ+vS/kxE8
         Ridg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=vIZny/CAiv+ANOXSTnw9s080uSQEaVCa1l5Fcgc1E+w=;
        b=iDDgQARcLCmFDD4yleJvs9pON/QJSxDi+lJ0iSHorjooSmFck3WV0xRQvfKz1Ce6AY
         hJrAMn0Qi7K9DKG8YYIOp55xYV77TrMxt3mhTX/ejcVzbzIsMFYegh32Dy4tt7P90ieM
         WhudLl+/MU7xunBam4cQztKnI/KlqoNdTnxBk5mYYfy3P/BtekjQALl2ut3W4IlXZT0G
         Gmhzmk1bxe3rGTtR4pQW5e7kjaOlC9U1hYKMqJmOFP9cESlFlya7Wi+2KhZI+6XOThq+
         99T/sGUe/0j+Pn5FyuaLc9QoQO0tmT5RlNFqthCEyMTVQm5ES3gIab5Vu4D8YbCIIJOq
         QLTg==
X-Gm-Message-State: AOAM530oUg3MkrlR6Ss18NEnnF/MYrNDEuXdC29/LAu3SdjylPl8nhJE
        j/n6qVqYr1J4LO5B+Txk5jHkY4Kw8pg=
X-Google-Smtp-Source: ABdhPJzPnngNKEJBH0DaKmfP4tX1bXr8Ad234yp3dVBNE/d9/Wux63kXd1L3alZF5q8TN0eEVvmycd8PWvM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74a:b0:153:f956:1cf5 with SMTP id
 p10-20020a170902e74a00b00153f9561cf5mr13634773plf.138.1648249433032; Fri, 25
 Mar 2022 16:03:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 25 Mar 2022 23:03:48 +0000
Message-Id: <20220325230348.2587437-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH] KVM: x86/mmu: Zap only TDP MMU leafs in zap range and
 mmu_notifier unmap
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-introduce zapping only leaf SPTEs in kvm_zap_gfn_range() and
kvm_tdp_mmu_unmap_gfn_range(), this time without losing a pending TLB
flush when processing multiple roots (including nested TDP shadow roots).
Dropping the TLB flush resulted in random crashes when running Hyper-V
Server 2019 in a guest with KSM enabled in the host (or any source of
mmu_notifier invalidations, KSM is just the easiest to force).

This effectively revert commits 873dd122172f8cce329113cfb0dfe3d2344d80c0
and fcb93eb6d09dd302cbef22bd95a5858af75e4156, and thus restores commit
cf3e26427c08ad9015956293ab389004ac6a338e, plus this delta on top:

bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
        struct kvm_mmu_page *root;

        for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, false);
+               flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);

        return flush;
 }

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 +--
 arch/x86/kvm/mmu/tdp_mmu.c | 57 +++++++++++---------------------------
 arch/x86/kvm/mmu/tdp_mmu.h |  8 +-----
 3 files changed, 19 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1361eb4599b4..a7cb877f3784 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5842,8 +5842,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 
 	if (is_tdp_mmu_enabled(kvm)) {
 		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush);
+			flush = kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
+						      gfn_end, true, flush);
 	}
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b3b6426725d4..c4333efb9e9c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -906,10 +906,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -917,44 +915,25 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
-	 * Do not do it above the 1GB level, to avoid making tdp_mmu_set_spte's
-	 * recursion too expensive and allow yielding.
-	 */
-	int min_level = zap_all ? PG_LEVEL_1G : PG_LEVEL_4K;
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
 
@@ -962,17 +941,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		flush = true;
 	}
 
+	rcu_read_unlock();
+
 	/*
-	 * Need to flush before releasing RCU.  TODO: do it only if intermediate
-	 * page tables were zapped; there is no need to flush under RCU protection
-	 * if no 'struct kvm_mmu_page' is freed.
+	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
+	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
 	 */
-	if (flush)
-		kvm_flush_remote_tlbs_with_address(kvm, start, end - start);
-
-	rcu_read_unlock();
-
-	return false;
+	return flush;
 }
 
 /*
@@ -981,13 +956,13 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
+		flush = tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
 
 	return flush;
 }
@@ -1235,8 +1210,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

base-commit: 19164ad08bf668bca4f4bfbaacaa0a47c1b737a6
-- 
2.35.1.1021.g381101b075-goog

