Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38BF144CCC0
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhKJWdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhKJWdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:18 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B821C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:30 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id c140-20020a624e92000000b0044d3de98438so2705650pfb.14
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WwHJW5gdPl9g8jWdOt95giCAKwWO4RT74eVa/es5zQQ=;
        b=njPMi+C7jKAk4+T8RVs6iWwXpbM0cbtjRZI7h1bNzQiTKSRmIaKzyez3PcrHiMYBi6
         X1New7+hdWb8ybGRK5IgZl4XrsvPp4ZcWCx3wHuGPYoWBVscNgrbDlME5XqpxSxtxbEn
         dFm5ro6yF5zX4MbX1XSHYjYi0mS7SNlpnNIcAHP16ilhadK/30us8urvvMzM2zNDNp0R
         KE24vqnYV8f7ZIqjfNgRNmK4vzNJF1OfcUuVsJpQZFKRErCFhKdqMFaKg/YzK5URJoQu
         aOAXS7ddnxMCPoVMScoY1wBnWgbF1KXaA8EqoQ+En3biiObqU1gKG7yRNprQwgrTVvym
         YViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WwHJW5gdPl9g8jWdOt95giCAKwWO4RT74eVa/es5zQQ=;
        b=nCB1e3yDNwklZMN9iHC1F5qtPgwR7zl1OiOs6VvAXZb5VOxdRrqM87Wxg3HWdE6JSV
         iKqMjyxBozHjdkxIa0IH9C6zzacVZjPrDII+TUte4+FwMjxYmz6snd3FtQjiglYdYLHw
         UJJD3mvG2ELgPasHRWC/mm2AIhg3pgIuwyk+uK/HX1w/I2++Roz+U5b7NXZojIxH21Ca
         rf4nbnAMCFUoSPFRMeZnqWG8RiOW4Kew6vQcrPy/IE/uieY6mADh7p5kWIQDJxFtn3NY
         eyYwlBdmVwArox+CuN1TuSWXl5aEiiQPdDYHYtxOpn6NSDWe1wIL87sAiWu5xtbOpRwP
         vchw==
X-Gm-Message-State: AOAM530qtAS658TmnGTa3jVyERcrTnCzHBr6jIbMOiRBpZRO5YhRHtr4
        TeYmvE4yMPDKJj+CLGUtlrimnMCgICEi
X-Google-Smtp-Source: ABdhPJxJD90fTkFGyFahnWqmQ7219qdj9g4VUJ/pjZrd1ITQO6ACMS08VDjnCpbq52RgldJ7tzBolDkQgEoT
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:902:8f94:b0:143:8e81:3ec1 with SMTP id
 z20-20020a1709028f9400b001438e813ec1mr2869588plo.52.1636583429698; Wed, 10
 Nov 2021 14:30:29 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:54 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-4-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 03/19] KVM: x86/mmu: Factor flush and free up when zapping under
 MMU write lock
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When zapping a GFN range under the MMU write lock, there is no need to
flush the TLBs for every zap. Instead, follow the lead of the Legacy MMU
can collect disconnected sps to be freed after a flush at the end of
the routine.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5b31d046df78..a448f0f2d993 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -623,10 +623,9 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  */
 static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
-				      bool record_dirty_log)
+				      bool record_dirty_log,
+				      struct list_head *disconnected_sps)
 {
-	LIST_HEAD(disconnected_sps);
-
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -641,7 +640,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false, &disconnected_sps);
+			      new_spte, iter->level, false, disconnected_sps);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
@@ -649,28 +648,32 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
 					      iter->old_spte, new_spte,
 					      iter->level);
+}
 
-	handle_disconnected_sps(kvm, &disconnected_sps);
+static inline void tdp_mmu_zap_spte(struct kvm *kvm, struct tdp_iter *iter,
+				    struct list_head *disconnected_sps)
+{
+	__tdp_mmu_set_spte(kvm, iter, 0, true, true, disconnected_sps);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true, NULL);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true, NULL);
 }
 
 static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false, NULL);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -757,6 +760,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool zap_all = (start == 0 && end >= max_gfn_host);
 	struct tdp_iter iter;
+	LIST_HEAD(disconnected_sps);
 
 	/*
 	 * No need to try to step down in the iterator when zapping all SPTEs,
@@ -799,7 +803,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!shared) {
-			tdp_mmu_set_spte(kvm, &iter, 0);
+			tdp_mmu_zap_spte(kvm, &iter, &disconnected_sps);
 			flush = true;
 		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
 			/*
@@ -811,6 +815,12 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		}
 	}
 
+	if (!list_empty(&disconnected_sps)) {
+		kvm_flush_remote_tlbs(kvm);
+		handle_disconnected_sps(kvm, &disconnected_sps);
+		flush = false;
+	}
+
 	rcu_read_unlock();
 	return flush;
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

