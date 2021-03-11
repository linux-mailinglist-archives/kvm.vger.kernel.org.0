Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C56338151
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 00:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhCKXRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 18:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCKXRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 18:17:37 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1546FC061574
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 15:17:37 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id v136so16889601qkb.9
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 15:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WfbyYdb68xASx0rik3LLH3bJ+u86HlW/YnL+1UN7bRg=;
        b=UFnnkD1qKxAJQAGTGtaWpjjsSj9Gg+i2QLcuMFbcbeO7zkkEc+TsL42Ah7MvWH0ctv
         PFpLu/Nyywbasudcngum2Bk9NphF7J8H51jiABuNCyO9rn//W1sAXrXs0gyjiSwZPOMu
         GugG5vfrsxqaBW8K5coQDu1VytV20y/wMnShJS5mrIR8R5GUHQzPT6K5PBCBGPze5f3E
         /BLfCf48nUy5Y+I0vdOFRTkilK92ZpU9J97qDHxUAYugpe3UlNCiXPyB3AOt3b813mWL
         sKUJBaU+iJbljvOcQSyJKeYZycaYcGO0c8m4VyWtInrQ/CafLAEoLTAOTX1UYku2ravM
         NiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WfbyYdb68xASx0rik3LLH3bJ+u86HlW/YnL+1UN7bRg=;
        b=MxoSlradaGcJm5wwTqb1JdDSMIJuRwhttnudfwfRg6vg25KUZJXzTjGK1k1g3nsjyi
         kUHr3p2ycUouaQVCysP83/w2SQF+kHFRDgwF7vgAXemntcpXVAo3avWHqWhgmnk1VOPW
         YXAKjzYYliGJB56k5kvlnoj6thv5GD2L4a4/hj5CIcBduDm+qU4Jloem6GTEtaYAE0hd
         WA1hsN4kIork6heNYh9yx0eJ20vUbcyJyz4ssGOu1l5AKCu675jHMWEL+9wu3fBGQFR8
         sei2SW4qAFv70R/lzWf/2p0ZbBKA2uax/ysIx4no/PcsruKyW1I0Rl4QcoRMX9XHC4gK
         BJ7A==
X-Gm-Message-State: AOAM530ZrrWyIg9W0hEudSLidN+fOhaxy5k9QBAKW8iEp6dQouAsVNCy
        J9o5Vy0gV6JP7DcYdXVpQ4iKHSVCIb8K
X-Google-Smtp-Source: ABdhPJxrh5lL/RyL27y+kf6kMDDXgW/8luozm42iisMnrZ9+99ldYCymOS7CF1DHuBrFCbDXG0qLHJdKMQTZ
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b4d4:7253:76fa:9c42])
 (user=bgardon job=sendgmr) by 2002:a0c:ed45:: with SMTP id
 v5mr9922106qvq.13.1615504656303; Thu, 11 Mar 2021 15:17:36 -0800 (PST)
Date:   Thu, 11 Mar 2021 15:16:56 -0800
In-Reply-To: <20210311231658.1243953-1-bgardon@google.com>
Message-Id: <20210311231658.1243953-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210311231658.1243953-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 2/4] KVM: x86/mmu: Fix RCU usage for tdp_iter_root_pt
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The root page table in the TDP MMU paging structure is not protected
with RCU, but rather by the root_count in the associated SP. As a result
it is safe for tdp_iter_root_pt to simply return a u64 *. This sidesteps
the complexities assoicated with propagating the __rcu annotation
around.

Reported-by: kernel test robot <lkp@xxxxxxxxx>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.c | 10 ++++++++--
 arch/x86/kvm/mmu/tdp_iter.h |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c  |  4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index e5f148106e20..8e2c053533b6 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -159,8 +159,14 @@ void tdp_iter_next(struct tdp_iter *iter)
 	iter->valid = false;
 }
 
-tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
+u64 *tdp_iter_root_pt(struct tdp_iter *iter)
 {
-	return iter->pt_path[iter->root_level - 1];
+	/*
+	 * Though it is stored in an array of tdp_ptep_t for convenience,
+	 * the root PT is not actually protected by RCU, but by the root
+	 * count on the associated struct kvm_mmu_page. As a result it's
+	 * safe to rcu_dereference and return the value here.
+	 */
+	return rcu_dereference(iter->pt_path[iter->root_level - 1]);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 4cc177d75c4a..5a47c57810ab 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -62,6 +62,6 @@ tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
-tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);
+u64 *tdp_iter_root_pt(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5387ac040f66..6c8824bcc2f2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -558,7 +558,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
-	tdp_ptep_t root_pt = tdp_iter_root_pt(iter);
+	u64 *root_pt = tdp_iter_root_pt(iter);
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
@@ -653,7 +653,7 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 
 		WARN_ON(iter->gfn > iter->next_last_level_gfn);
 
-		tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
+		tdp_iter_start(iter, tdp_iter_root_pt(iter),
 			       iter->root_level, iter->min_level,
 			       iter->next_last_level_gfn);
 
-- 
2.31.0.rc2.261.g7f71774620-goog

