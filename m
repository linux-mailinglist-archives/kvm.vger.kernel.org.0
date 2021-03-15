Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4282033C598
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 19:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhCOS1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 14:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhCOS1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 14:27:14 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9E3C06174A
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:27:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id i1so23707951qvu.12
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 11:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YJ4LYikLJ6LnYtflKHwYLFORojLmasAvwJZ1SOdvg4k=;
        b=R4U454aE0SCZ0ShHHqVFDB7cWipimWRK+MqPBvlPKTI+UubfEhsJ9LeScntpFJUV9D
         G0dPrTC6J2LQiXlDhpjXkuLLXoC+VQb37WFsMpn/rtQA8SdEvBd7QuUfyLR0ojoYTfq2
         mU0ln5HmEE546LUukBzF8jH+yHNDveMOs315Ksl0K5Tts2L733Y6L2obPOrNpAEyJ9Hl
         ycmnxWP3kFJlmSPNDj97YvC5zxTdCo5jxpvDztsTslptRRoxm3hTuko9N2cGYpyrkKBl
         MDgpOPi6Bp5YeWZtLFKQm89ebCxaeR6/PRTUn7Gd6p39r1zuXhJxeOE6vdUC9lIaVbVL
         n/kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YJ4LYikLJ6LnYtflKHwYLFORojLmasAvwJZ1SOdvg4k=;
        b=VNNpdseYyGcVh8JXSJy8iJ3afLA0bVvOhcvdvYHv+qSVCTpGCYYypj+Q3r65jvCajH
         rxm5eKqah2xnKY1cC7oF6NvILhi3WaCDYh9/bqjbViUj5sb4HDREbdBnDljTCVf/Y42r
         /TXwaLndYNhxLVOfNpZ3inMKQ8mulvA3lw7lBm0a/1xTGrFA3FBH8bP5/QiOWPBSeJ7G
         edhdpQj58vxvZEPrm2d9EwID31kw1sC7sWff6kSRmab4xZLZ8DQuEdfsY8MSmwOBbwjm
         SgiN86ydHElbCJdhrXu0ZRHUV3FczY5ZkEqqa/YsnvuQ6kGatcczt3wMr/GTZKwcAVCK
         UYyg==
X-Gm-Message-State: AOAM530NYuniGMh4bQBpo2pmIjItdyYtYRIZyXvtHGqpcaQluF94tTku
        +kJPSk555rwOa2X4zYWM0uHB+vjK0EdN
X-Google-Smtp-Source: ABdhPJwbVQiLfVe2Db5rkIEg6KzSZtaX141pcPBDUyBP93Xmq6wAChQpbIRa1w7i0Lz1G5vf2ZWzAU3ZLQ+8
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:888a:4e22:67:844a])
 (user=bgardon job=sendgmr) by 2002:a0c:b89a:: with SMTP id
 y26mr12061368qvf.49.1615832833135; Mon, 15 Mar 2021 11:27:13 -0700 (PDT)
Date:   Mon, 15 Mar 2021 11:26:43 -0700
In-Reply-To: <20210315182643.2437374-1-bgardon@google.com>
Message-Id: <20210315182643.2437374-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210315182643.2437374-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v2 4/4] KVM: x86/mmu: Store the address space ID in the TDP iterator
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store the address space ID in the TDP iterator so that it can be
retrieved without having to bounce through the root shadow page.  This
streamlines the code and fixes a Sparse warning about not properly using
rcu_dereference() when grabbing the ID from the root on the fly.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  5 +++++
 arch/x86/kvm/mmu/tdp_iter.c     |  6 +-----
 arch/x86/kvm/mmu/tdp_iter.h     |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 23 +++++------------------
 4 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ec4fc28b325a..1f6f98c76bdf 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -78,6 +78,11 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 	return to_shadow_page(__pa(sptep));
 }
 
+static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
+{
+	return sp->role.smm ? 1 : 0;
+}
+
 static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index f7f94ea65243..b3ed302c1a35 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -49,6 +49,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	iter->root_level = root_level;
 	iter->min_level = min_level;
 	iter->pt_path[iter->root_level - 1] = (tdp_ptep_t)root_pt;
+	iter->as_id = kvm_mmu_page_as_id(sptep_to_sp(root_pt));
 
 	tdp_iter_restart(iter);
 }
@@ -169,8 +170,3 @@ void tdp_iter_next(struct tdp_iter *iter)
 	iter->valid = false;
 }
 
-tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
-{
-	return iter->pt_path[iter->root_level - 1];
-}
-
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 8eb424d17c91..b1748b988d3a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -36,6 +36,8 @@ struct tdp_iter {
 	int min_level;
 	/* The iterator's current level within the paging structure */
 	int level;
+	/* The address space ID, i.e. SMM vs. regular. */
+	int as_id;
 	/* A snapshot of the value at sptep */
 	u64 old_spte;
 	/*
@@ -62,7 +64,6 @@ tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
-tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 38b6b6936171..462b1f71c77f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -203,11 +203,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
-static int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
-{
-	return sp->role.smm ? 1 : 0;
-}
-
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
@@ -497,10 +492,6 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter,
 					   u64 new_spte)
 {
-	u64 *root_pt = tdp_iter_root_pt(iter);
-	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
-	int as_id = kvm_mmu_page_as_id(root);
-
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
 	/*
@@ -514,8 +505,8 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		      new_spte) != iter->old_spte)
 		return false;
 
-	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			    iter->level, true);
+	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			    new_spte, iter->level, true);
 
 	return true;
 }
@@ -569,10 +560,6 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
-	tdp_ptep_t root_pt = tdp_iter_root_pt(iter);
-	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
-	int as_id = kvm_mmu_page_as_id(root);
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -586,13 +573,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
-	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			      iter->level, false);
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			      new_spte, iter->level, false);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
 	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
+		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
 					      iter->old_spte, new_spte,
 					      iter->level);
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

