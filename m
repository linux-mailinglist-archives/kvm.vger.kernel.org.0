Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68B34579D4
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbhKTACD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236328AbhKTABb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:31 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A56C061758
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:28 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w2-20020a627b02000000b0049fa951281fso6456899pfc.9
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SmCSXpJ6Ch03EpbHnZ8Gjzgl3pEb/pHGueUC/l7cmO8=;
        b=PVwnx7oykzYltR5RjyOiSweFy620wA0jgFKtHt4t0z4nIUZlcnRoKWn2M81HeaslDw
         lNrQvSt0+7uDBTAy4vp8ze7+pcYC70o1Do5wEDGa9Bka5JD+yrJQkyQbUs8lU5snUwB3
         pQ2EKNTlyXq+7L1wtTrSR/dDH/4iZpyzpoeg4kWIdfL4xzkHS8gUdyoDE9HCXkXJBoxg
         CWFBi7tQItxjh1LpdSZOkwUUzsVqGaOuAg45eUt5KV7xZv5eWw5Ipu1e1YjJaLy3d1cx
         DeHzgkQWXhY6jJmgAi/YMsDjWGNzXI4SImz+9zsyli6nwydXaLjh4w2ZW3cZlkTp7aXB
         vFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SmCSXpJ6Ch03EpbHnZ8Gjzgl3pEb/pHGueUC/l7cmO8=;
        b=ZseihJTMI9a+jQCGbcvhTKsO31qQlWZN0SB4CuOvyHlSNWpZCrYhF1DtmB4182SSiX
         6WfmUeUcDGgUTr3Ae3zHYjh7OxQCAUIvyTSzMyB0DZekRF0dz0dWIPSdeTWOY/B5d/eo
         0c8n6cNgjHVnzvY+rWhQv8SmxBxnFds/6z7XgPgHH78+kaoBUOqryt6jTnQthVAK9SWv
         9VzLyMQ6fCmOlAnkEfXT+gdscWLL/FQlY/LnOGOjkAayfmNZlNeYNZcXoYOiIsekWQl1
         xmAvREQDiyFEQm3T+/ij/wYBY0IJQFBVKpW2zI9D/lGBgd2efhgmtouwrGFo7Fe9BKx0
         DGcQ==
X-Gm-Message-State: AOAM530qbZM0cfu77xYDRitU06UGLW0/32r6WslL90E7gg1PAWzIeMCY
        cvzkp81MIK8qtvuSDtk2B0yfXSYoQVmtUw==
X-Google-Smtp-Source: ABdhPJzCQPDmO7av7RFy/2wpnWlmH7ZZkywBi1u5O/uKV1PQMaBTqJ2xaOUAvIQTX/I7TkVkL0KcNrOvjwBr9w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:248b:b0:49f:9d7f:84e2 with SMTP
 id c11-20020a056a00248b00b0049f9d7f84e2mr68199503pfv.40.1637366308173; Fri,
 19 Nov 2021 15:58:28 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:55 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 11/15] KVM: x86/mmu: Refactor tdp_mmu iterators to take
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of passing a pointer to the root page table and the root level
seperately, pass in a pointer to the kvm_mmu_page that backs the root.
This reduces the number of arguments by 1, cutting down on line lengths.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c |  5 ++++-
 arch/x86/kvm/mmu/tdp_iter.h | 10 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.c  | 14 +++++---------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index b3ed302c1a35..92b3a075525a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -39,9 +39,12 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * Sets a TDP iterator to walk a pre-order traversal of the paging structure
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
-void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 		    int min_level, gfn_t next_last_level_gfn)
 {
+	u64 *root_pt = root->spt;
+	int root_level = root->role.level;
+
 	WARN_ON(root_level < 1);
 	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index b1748b988d3a..ec1f58013428 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -51,17 +51,17 @@ struct tdp_iter {
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
index 2221e074d8ea..5ca0fa659245 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -632,7 +632,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
-	for_each_tdp_pte(_iter, _root->spt, _root->role.level, _start, _end)
+	for_each_tdp_pte(_iter, _root, _start, _end)
 
 #define tdp_root_for_each_leaf_pte(_iter, _root, _start, _end)	\
 	tdp_root_for_each_pte(_iter, _root, _start, _end)		\
@@ -642,8 +642,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 		else
 
 #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, __va(_mmu->root_hpa),		\
-			 _mmu->shadow_root_level, _start, _end)
+	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root_hpa), _start, _end)
 
 static inline bool tdp_mmu_iter_need_resched(struct kvm *kvm, struct tdp_iter *iter)
 {
@@ -738,8 +737,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
@@ -1201,8 +1199,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	for_each_tdp_pte_min_level(iter, root, min_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
@@ -1450,8 +1447,7 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, gfn, gfn + 1) {
+	for_each_tdp_pte_min_level(iter, root, min_level, gfn, gfn + 1) {
 		if (!is_shadow_present_pte(iter.old_spte) ||
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
-- 
2.34.0.rc2.393.gf8c9666880-goog

