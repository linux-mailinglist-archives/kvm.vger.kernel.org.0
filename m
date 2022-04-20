Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9A8507DC7
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 02:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346869AbiDTAv6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 20:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350618AbiDTAvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 20:51:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC10A37A12
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:49:03 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f17e110a9bso3035637b3.0
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 17:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SDL9MFIe7Bs280dPgs9gNMtR+FqJHh0cLQq02+aHMEM=;
        b=D9ocaWs++kMrG7M6NBGRLsuCM/zv7JBy1xaSMv1ZDnl6aBom+xyvQDVW9krblJDF7P
         Sv5/GNoDIDAtWymoPqGm8Z2qSxSFazroou4g5QzDWYTaJunRqKSGXDbSjH36nPyIoGyr
         R6bC1XH7AarlduiwGnzcXV9vz8WsALau8z2SqWjG3e0HqvDgXiDak5K9hUl9EE2RkMAs
         p4x/vdP72mxc0cqdFwLKHvtaFmpuMieUgj1MafR1ZoQyVKUJGmYR90odADpAcS/QxvBB
         n0Xwa6ykUv2COlqiriWJIJ7ubCssxudlkBdOLDNmRyfgqFCtbkVLVEFZH1+5TA2kHyMg
         fpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SDL9MFIe7Bs280dPgs9gNMtR+FqJHh0cLQq02+aHMEM=;
        b=3x4+RldIcI/FwOcoa2lSeCGhxMwfLggjFh48uCzN8qED6AXlj/5sk+XhYmImB4eA40
         T8G24TV52ydaa+rqUr2iIbB1i2y9jQiqAoGWD17Xv77aGE/lGthfWPuvjriQU+FU6Ydd
         EGBSIlj+h9IDj88m56+n69Tw93+gl5JQQDiaB3agQzdaP1ARGxENolGv39KMEWejalFu
         MZNUYWYEgOvjhIeTjMwaNxVXmXVlvjC8lmbtuDlYUkHohSxLIOd6gZ0ieo3tUABvr10y
         wTtq7ZhNCUYXx4D3B+zcgM/4p58xzZ6t4vGTxfTisu/C2Xn9K1GQkCjSX7SsDD35OJXA
         m+jg==
X-Gm-Message-State: AOAM531sNAGTdHcC7Zr97vhkb41hgRiSVyibr62434Muk3NNvQhF5UKp
        fefm6WnrhMb6pk93h5risstRYryetus=
X-Google-Smtp-Source: ABdhPJxdHb6JIqQnXBO4L3T13WZV3yySmAJgBqs9oaulleLHkFlL0hhSD3svzNgWE7eYVl1HmDW2sj7iNss=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a81:fe01:0:b0:2e5:85ba:f316 with SMTP id
 j1-20020a81fe01000000b002e585baf316mr19493312ywn.33.1650415743043; Tue, 19
 Apr 2022 17:49:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 20 Apr 2022 00:48:58 +0000
In-Reply-To: <20220420004859.3298837-1-seanjc@google.com>
Message-Id: <20220420004859.3298837-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220420004859.3298837-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH 1/2] KVM: Fix race between mmu_notifier invalidation and
 pfncache refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>
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

Key off of mn_active_invalidate_count to detect that a pfncache refresh
needs to wait for an in-progress mmu_notifier invalidation.  Using the
common "retry" approach is broken as the invalidation occurs _before_
mmu_notifier_count is elevated and before mmu_notifier_range_start is
set/updated.  The cache refresh handles the race where an invalidation
occurs between dropping and re-acquiring gpc->lock, but it doesn't handle
the scenario where the cache is refreshed after the cache was invalidated
by the notifier, but before the notifier elevates mmu_notifier_count.

  CPU0                                    CPU1
  ----                                    ----

  gfn_to_pfn_cache_invalidate_start()
  |
  -> gpc->valid = false;
                                          kvm_gfn_to_pfn_cache_refresh()
                                          |
                                          |-> gpc->valid = true;

                                          hva_to_pfn_retry()
                                          |
                                          -> acquire kvm->mmu_lock
                                             kvm->mmu_notifier_count == 0
                                             mmu_seq == kvm->mmu_notifier_seq
                                             drop kvm->mmu_lock
                                             return pfn 'X'
  acquire kvm->mmu_lock
  kvm_inc_notifier_count()
  drop kvm->mmu_lock()
  kernel frees pfn 'X'
                                          kvm_gfn_to_pfn_cache_check()
                                          |
                                          |-> gpc->valid == true

                                          caller accesses freed pfn 'X'

While mn_active_invalidate_count is not guaranteed to be stable, it is
guaranteed to be elevated prior to an invalidation acquiring gpc->lock,
so either the refresh will see an active invalidation and wait, or the
invalidation will run after the refresh completes.

Waiting for in-progress invalidations to complete also obviates the need
to mark gpc->valid before calling hva_to_pfn_retry(), which is in itself
flawed as a concurrent kvm_gfn_to_pfn_cache_check() would see a "valid"
cache with garbage pfn/khva values.  That issue will be remedied in a
future commit.

Opportunistically change the do-while(1) to a for(;;) to make it easier
to see that it loops until a break condition is encountered, the size of
the loop body makes the while(1) rather difficult to see.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c |  9 ++++++
 virt/kvm/pfncache.c | 70 +++++++++++++++++++++++++++++++--------------
 2 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfb7dabdbc63..0848430f36c6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -705,6 +705,15 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	kvm->mn_active_invalidate_count++;
 	spin_unlock(&kvm->mn_invalidate_lock);
 
+	/*
+	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
+	 * before acquiring mmu_lock, to avoid holding mmu_lock while acquiring
+	 * each cache's lock.  There are relatively few caches in existence at
+	 * any given time, and the caches themselves can check for hva overlap,
+	 * i.e. don't need to rely on memslot overlap checks for performance.
+	 * Because this runs without holding mmu_lock, the pfn caches must use
+	 * mn_active_invalidate_count (see above) instead of mmu_notifier_count.
+	 */
 	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
 					  hva_range.may_block);
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index dd84676615f1..71c84a43024c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -112,29 +112,63 @@ static void __release_gpc(struct kvm *kvm, kvm_pfn_t pfn, void *khva, gpa_t gpa)
 	}
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
+static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
 {
+	bool first_attempt = true;
 	unsigned long mmu_seq;
 	kvm_pfn_t new_pfn;
-	int retry;
 
-	do {
+	lockdep_assert_held_write(&gpc->lock);
+
+	for (;;) {
 		mmu_seq = kvm->mmu_notifier_seq;
 		smp_rmb();
 
+		write_unlock_irq(&gpc->lock);
+
+		/* Opportunistically check for resched while the lock isn't held. */
+		if (!first_attempt)
+			cond_resched();
+
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
+
+		write_lock_irq(&gpc->lock);
+
 		if (is_error_noslot_pfn(new_pfn))
 			break;
 
-		KVM_MMU_READ_LOCK(kvm);
-		retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
-		KVM_MMU_READ_UNLOCK(kvm);
-		if (!retry)
+		first_attempt = false;
+
+		/*
+		 * Wait for mn_active_invalidate_count, not mmu_notifier_count,
+		 * to go away, as the invalidation in the mmu_notifier event
+		 * occurs _before_ mmu_notifier_count is elevated.
+		 *
+		 * Note, mn_active_invalidate_count can change at any time as
+		 * it's not protected by gpc->lock.  But, it is guaranteed to
+		 * be elevated before the mmu_notifier acquires gpc->lock, and
+		 * isn't dropped until after mmu_notifier_seq is updated.  So,
+		 * this task may get a false positive of sorts, i.e. see an
+		 * elevated count and wait even though it's technically safe to
+		 * proceed (becase the mmu_notifier will invalidate the cache
+		 * _after_ it's refreshed here), but the cache will never be
+		 * refreshed with stale data, i.e. won't get false negatives.
+		 */
+		if (kvm->mn_active_invalidate_count)
+			continue;
+
+		/*
+		 * Ensure mn_active_invalidate_count is read before
+		 * mmu_notifier_seq.  This pairs with the smp_wmb() in
+		 * mmu_notifier_invalidate_range_end() to guarantee either the
+		 * old (non-zero) value of mn_active_invalidate_count or the
+		 * new (incremented) value of mmu_notifier_seq is observed.
+		 */
+		smp_rmb();
+		if (kvm->mmu_notifier_seq == mmu_seq)
 			break;
-
-		cond_resched();
-	} while (1);
+	}
 
 	return new_pfn;
 }
@@ -190,7 +224,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
 	if (!old_valid || old_uhva != gpc->uhva) {
-		unsigned long uhva = gpc->uhva;
 		void *new_khva = NULL;
 
 		/* Placeholders for "hva is valid but not yet mapped" */
@@ -198,15 +231,10 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 		gpc->khva = NULL;
 		gpc->valid = true;
 
-		write_unlock_irq(&gpc->lock);
-
-		new_pfn = hva_to_pfn_retry(kvm, uhva);
+		new_pfn = hva_to_pfn_retry(kvm, gpc);
 		if (is_error_noslot_pfn(new_pfn)) {
 			ret = -EFAULT;
-			goto map_done;
-		}
-
-		if (gpc->usage & KVM_HOST_USES_PFN) {
+		} else if (gpc->usage & KVM_HOST_USES_PFN) {
 			if (new_pfn == old_pfn) {
 				new_khva = old_khva;
 				old_pfn = KVM_PFN_ERR_FAULT;
@@ -222,10 +250,10 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
 				new_khva += page_offset;
 			else
 				ret = -EFAULT;
+		} else {
+			/* Nothing more to do, the pfn is consumed only by the guest. */
 		}
 
-	map_done:
-		write_lock_irq(&gpc->lock);
 		if (ret) {
 			gpc->valid = false;
 			gpc->pfn = KVM_PFN_ERR_FAULT;
-- 
2.36.0.rc0.470.gd361397f0d-goog

