Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7BA68A2F6
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 20:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjBCT2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 14:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbjBCT2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 14:28:31 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E7CA8A04
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 11:28:29 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id az1-20020a170902a58100b00198c85df72bso2624192plb.10
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 11:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ak5zcwBMhePTPGhWw+9Y0sgu3ygPb+KvfrYr09hJ3Yk=;
        b=qZfkHXGGr1qHpXZJvKaEUSahiehmsi/2hWFtvV03HTTdOPrfyNEML/o9tHSOHWGqJj
         HTDm7EQ+xPnvX4pp24MFsSYtGLuEAcJxCrY7l0CY11mqiV/AfHXTU2MHaKfoNy3eu+9f
         TcEGcpXdv9TUsfcLjALKCicgVFuTyqyWg2ZHcSLaAGXOFBugjpmPo5o5LISp/NZW5/dW
         /chBexL1SIqKTJWFn80Nx3IcK6ziBiW1bt4oz/1FO3Z/X6PJpA57To9fYyinnQiBChXG
         5EzN/m151xiuEbOLOjHA5W5a8CD8OXzA4WtwkemGddRtywIQSDPADkBldJuwJHGHwm4r
         uZ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ak5zcwBMhePTPGhWw+9Y0sgu3ygPb+KvfrYr09hJ3Yk=;
        b=Tv/wYViEfZoc5/chsXL61To+nooPdqG5GGYaD8Veky+uedObQJfI/Tg59uyF22Ngnk
         d4hpZ1sN9p7DQXpgStwa+qdc8oIUFkajWXMgOY7BsSshvzY2jOs6zwog6Jtk9kcaE6Ws
         IUTd5Jk3akVZz4/FZok6y9xWtKMAcvRvMFNTziQIJo2ZkjtzTpA7NJbYuN68gDix1Flf
         r9936KxKdslY2pbrMP95GFgnOXxAMoNJNEZEwAD/dUhOaqlQXRDh6ORY0V7RJqwoP26V
         JNliKI97fYSFGAc+KJUul77MB0aQh34+pSoQljPC0O+QRFpqrjc5b7Q9RUROZBVrfmbk
         s3Ww==
X-Gm-Message-State: AO0yUKU7rzTXCHyYhDs+PX8yiF5wBcIA3S4X0eQw14sd1J83GCwTvCNo
        M2NXRZUJojEmiWz7Vu3bN4FwJeNBo/Wk
X-Google-Smtp-Source: AK7set/yoP+AlbF0CwwPb+QFwnYSo1Go/wSqxib0qS+RulrV8Rjv0sNR2/J13dk1ohDtx4hpMs9krsm3axnG
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:eb12:b0:225:eaa2:3f5d with SMTP id
 j18-20020a17090aeb1200b00225eaa23f5dmr3601pjz.2.1675452508924; Fri, 03 Feb
 2023 11:28:28 -0800 (PST)
Date:   Fri,  3 Feb 2023 11:28:19 -0800
In-Reply-To: <20230203192822.106773-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203192822.106773-3-vipinsh@google.com>
Subject: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for clear-dirty-log
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to check all of the conditions in __handle_changed_spte() as
clearing dirty log only involves resetting dirty or writable bit.

Make atomic change to dirty or writable bit and mark pfn dirty.

Tested on 160 VCPU-160 GB VM and found that performance of clear dirty
log stage improved by ~38% in dirty_log_perf_test

Before optimization:
--------------------

Test iterations: 3
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory: [0x3fd7c0000000, 0x3fffc0000000)
Populate memory time: 6.298459671s
Setting dirty log mode took : 0.000000052s

Enabling dirty logging time: 0.003815691s

Iteration 1 dirty memory time: 0.185538848s
Iteration 1 get dirty log time: 0.002562641s
Iteration 1 clear dirty log time: 3.638543593s
Iteration 2 dirty memory time: 0.192226071s
Iteration 2 get dirty log time: 0.001558446s
Iteration 2 clear dirty log time: 3.145032742s
Iteration 3 dirty memory time: 0.193606295s
Iteration 3 get dirty log time: 0.001559425s
Iteration 3 clear dirty log time: 3.142340358s
Disabling dirty logging time: 3.002873664s
Get dirty log over 3 iterations took 0.005680512s.
(Avg 0.001893504s/iteration)
Clear dirty log over 3 iterations took 9.925916693s. (Avg 3.308638897s/iteration)

After optimization:
-------------------

Test iterations: 3
Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory: [0x3fd7c0000000, 0x3fffc0000000)
Populate memory time: 6.581448437s
Setting dirty log mode took : 0.000000058s

Enabling dirty logging time: 0.003981283s

Iteration 1 dirty memory time: 0.285693420s
Iteration 1 get dirty log time: 0.002743004s
Iteration 1 clear dirty log time: 2.384343157s
Iteration 2 dirty memory time: 0.290414476s
Iteration 2 get dirty log time: 0.001720445s
Iteration 2 clear dirty log time: 1.882770288s
Iteration 3 dirty memory time: 0.289965965s
Iteration 3 get dirty log time: 0.001728232s
Iteration 3 clear dirty log time: 1.881043086s
Disabling dirty logging time: 2.930387523s
Get dirty log over 3 iterations took 0.006191681s.
(Avg 0.002063893s/iteration)
Clear dirty log over 3 iterations took 6.148156531s. (Avg 2.049385510s/iteration)

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_iter.h | 13 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c  | 51 +++++++++++++++----------------------
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 30a52e5e68de..21046b34f94e 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -121,4 +121,17 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
+static inline u64 kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
+{
+	atomic64_t *sptep;
+
+	if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level)) {
+		sptep = (atomic64_t *)rcu_dereference(iter->sptep);
+		return (u64)atomic64_fetch_and(~mask, sptep);
+	}
+
+	__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
+	return iter->old_spte;
+}
+
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bba33aea0fb0..83f15052aa6c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -710,18 +710,13 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  *		      notifier for access tracking. Leaving record_acc_track
  *		      unset in that case prevents page accesses from being
  *		      double counted.
- * @record_dirty_log: Record the page as dirty in the dirty bitmap if
- *		      appropriate for the change being made. Should be set
- *		      unless performing certain dirty logging operations.
- *		      Leaving record_dirty_log unset in that case prevents page
- *		      writes from being double counted.
  *
  * Returns the old SPTE value, which _may_ be different than @old_spte if the
  * SPTE had voldatile bits.
  */
 static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
-			      bool record_acc_track, bool record_dirty_log)
+			      bool record_acc_track)
 {
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
@@ -740,42 +735,34 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	if (record_acc_track)
 		handle_changed_spte_acc_track(old_spte, new_spte, level);
-	if (record_dirty_log)
-		handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
-					      new_spte, level);
+
+	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte, new_spte,
+				      level);
 	return old_spte;
 }
 
 static inline void _tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				     u64 new_spte, bool record_acc_track,
-				     bool record_dirty_log)
+				     u64 new_spte, bool record_acc_track)
 {
 	WARN_ON_ONCE(iter->yielded);
 
 	iter->old_spte = __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
 					    iter->old_spte, new_spte,
 					    iter->gfn, iter->level,
-					    record_acc_track, record_dirty_log);
+					    record_acc_track);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	_tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
-}
-
-static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
-						 struct tdp_iter *iter,
-						 u64 new_spte)
-{
-	_tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
+	_tdp_mmu_set_spte(kvm, iter, new_spte, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -925,7 +912,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 		return false;
 
 	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
-			   sp->gfn, sp->role.level + 1, true, true);
+			   sp->gfn, sp->role.level + 1, true);
 
 	return true;
 }
@@ -1678,7 +1665,7 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 				  gfn_t gfn, unsigned long mask, bool wrprot)
 {
 	struct tdp_iter iter;
-	u64 new_spte;
+	u64 clear_bits;
 
 	rcu_read_lock();
 
@@ -1694,18 +1681,22 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		mask &= ~(1UL << (iter.gfn - gfn));
 
 		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
-			if (is_writable_pte(iter.old_spte))
-				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
-			else
+			if (!is_writable_pte(iter.old_spte))
 				continue;
+
+			clear_bits = PT_WRITABLE_MASK;
 		} else {
-			if (iter.old_spte & shadow_dirty_mask)
-				new_spte = iter.old_spte & ~shadow_dirty_mask;
-			else
+			if (!(iter.old_spte & shadow_dirty_mask))
 				continue;
+
+			clear_bits = shadow_dirty_mask;
 		}
 
-		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		iter.old_spte = kvm_tdp_mmu_clear_spte_bit(&iter, clear_bits);
+		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
+					       iter.old_spte,
+					       iter.old_spte & ~clear_bits);
+		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
 	}
 
 	rcu_read_unlock();
-- 
2.39.1.519.gcb327c4b5f-goog

