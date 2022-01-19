Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB504943AB
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357857AbiASXJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344356AbiASXIH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:07 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845ECC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:06 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id z3-20020a17090a468300b001b4df1f5a6eso2736445pjf.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=d5uxOLMY02+aBC8yKnGiHIkhgr9+Yp4wHSTMVG68uAQ=;
        b=r6VnYXb5zYYD5SKWbRpgrdI/VAFBVT6tDjUhrOHxsaR3wr5zFjAOucfXkGipalUJ2D
         DHzoCEdEIGKHBSWvCDjTfJFIq70aDLsCMhewINvEOFXs1uswTV0ZOYXHMU82brG/GAQT
         UfZziZDQoR9f6m2GPdD+frHDpfjczANCAk4fgbRwaWDT5u6dGa6cKvnQ6MRK6qDQhxnH
         +/5jT9t7mtxR9Ww++OU+kTkCM4pKsiPD3oVcvBx0QAVwkcbHkuRBXJBzEGpy58jR8e/1
         vJn2bdyBVUqBqaSPVc4AouDr3hkx399Venw/k+r8LfBnf+LVSqTK12zbbuRs7Awqsild
         5Ihg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=d5uxOLMY02+aBC8yKnGiHIkhgr9+Yp4wHSTMVG68uAQ=;
        b=lo3mEDvLDyf8TwVTpeNy26i7OasGxLhXraLKobBRKalpcpDA6dkNKuJbZbD1YVsE20
         l2r4tjeeq+c9/3h4/XZXE5LXETQJXUwWjERW/OjZCKz3BNiJ7MPxjnWP/sm33KXeuAII
         5X/4V89FEuGGTrOomTms2xBqeIKwyH26uULFS+meVqZqQUI6SSj2sef0nDAlM6QUA/eK
         yGv3mnsyHEqx4IfM4j3FavEH71ZAQSxeoVEG2+PEVULUzYWFpRFSKrjfkhCNGQKm8hEk
         USbBoi0Z5sGJgLf3gPN2XhDUa63xK+YrHBiNmi3Y3W/ci0RFIIR3kTEfN2zgZ+u5Uoa2
         xg7A==
X-Gm-Message-State: AOAM5305KiHxoDJD48rQovQlzmVrTf/3uTnjpEFkGVeYU5rp51MxFSrD
        b0CSBMHkjqkTPXoJ3/MTd/QpzEvgLi6Ffg==
X-Google-Smtp-Source: ABdhPJzlrgX4j2rKE0nqZkNwo6RAb5D+2ILaFqpxh3XJjxjjukyRPAp1vdRpOVsDGDcRqQqrXHmoZzSVkSqpoQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:10cd:b0:4bc:a950:41e2 with SMTP
 id d13-20020a056a0010cd00b004bca95041e2mr33400165pfu.30.1642633686015; Wed,
 19 Jan 2022 15:08:06 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:32 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 11/18] KVM: x86/mmu: Refactor TDP MMU iterators to take
 kvm_mmu_page root
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of passing a pointer to the root page table and the root level
separately, pass in a pointer to the root kvm_mmu_page struct.  This
reduces the number of arguments by 1, cutting down on line lengths.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  8 +++++---
 arch/x86/kvm/mmu/tdp_iter.h | 10 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++---------
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index caa96c270b95..be3f096db2eb 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -40,17 +40,19 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * Sets a TDP iterator to walk a pre-order traversal of the paging structure
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
-void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn)
 {
+	int root_level = root->role.level;
+
 	WARN_ON(root_level < 1);
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
 	iter->next_last_level_gfn = next_last_level_gfn;
 	iter->root_level = root_level;
 	iter->min_level = min_level;
-	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root_pt;
-	iter->as_id = kvm_mmu_page_as_id(sptep_to_sp(root_pt));
+	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root->spt;
+	iter->as_id = kvm_mmu_page_as_id(root);
 
 	tdp_iter_restart(iter);
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index e19cabbcb65c..216ebbe76ddd 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -57,17 +57,17 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, root, root_level, min_level, start, end) \
-	for (tdp_iter_start(&iter, root, root_level, min_level, start); \
+#define for_each_tdp_pte_min_level(iter, root, min_level, start, end) \
+	for (tdp_iter_start(&iter, root, min_level, start); \
 	     iter.valid && iter.gfn < end;		     \
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte(iter, root, root_level, start, end) \
-	for_each_tdp_pte_min_level(iter, root, root_level, PG_LEVEL_4K, start, end)
+#define for_each_tdp_pte(iter, root, start, end) \
+	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end)
 
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
-void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f6144db48367..38ec5a61dbff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -624,7 +624,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
+	for_each_tdp_pte(_iter, _root, _start, _end)
 
 #define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
 	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
@@ -634,8 +634,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 		else
 
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
-			 _mmu->shadow_root_level, _start, _end)
+	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root_hpa), _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -724,8 +723,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
@@ -1197,8 +1195,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1437,8 +1434,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
-- 
2.35.0.rc0.227.g00780c9af4-goog

