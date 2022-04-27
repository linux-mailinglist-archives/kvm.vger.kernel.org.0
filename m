Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9486510E18
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 03:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356923AbiD0Bnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 21:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356883AbiD0Bnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 21:43:33 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803C13F6D
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:19 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o7-20020a17090a0a0700b001d93c491131so2505459pjo.6
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 18:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc:content-transfer-encoding;
        bh=8TMYzuplXVBJjftIf0wWJwIwTvZInrXR9aSkWsO9tM8=;
        b=pR21KqiH+heq1AXiJUy5J/tRw6+j/6AeYxYPc05VIqlwxRwT+13vU4jLMlbVMO4Tt4
         rFRt4eUip8LFde3wtT9xX4AnHsRDes3ri7bhxY2X44KokV/Y4gY9OtfDkAD3Jzn+q62A
         YTkANdzuqo7oMgiJX+wr/jmDEdTgJ2wbTADbC3ltNJKSJdPp85Cw0RcD3vISL7tkf34L
         oJ3BEZ9yRP6G6cmA3VkHaBaQ24ET6kA7nu1Ud90wUPkZDtVTaC6QBWsnlhRijEySN73Z
         W/pktQhX5oj7Ug4vKS4Ql/UOwBCe1fuBiBrsN24cBqRpKgCdnL27GWZB394p0dWa/k7M
         I39g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc
         :content-transfer-encoding;
        bh=8TMYzuplXVBJjftIf0wWJwIwTvZInrXR9aSkWsO9tM8=;
        b=17fuAgM+1gmhNGUuoDtUlcP2AyafIy3AGI1KOc31gflvI7Jw+ZtgVGV9vMlugALnlT
         H2DSVlX0ZWYiRlBEMJZ9yT0bLMzDe15nzW6xKN5a4cZiMeEaIZqAc6znlUdGS4fRAtI2
         qF1m7qiJqtOcyQDX/9wMwjPGfoJ6fdYVVj/H7Ls+Rl48YvVVJg0V9hM5XVdL77q/Fis5
         in83guH4105CultimKyTUnK3Tcs4N4noVlvNRVhBrfExnflEmj6atx4A4IMo2Hfq0XLH
         XJxJv0OVUYtptAx8zSU0nC3e2BncgGJXHSbplq+rhy1OgRUp6wILJgpmzYLSmMpWDj2Q
         QGxA==
X-Gm-Message-State: AOAM533Pr+/x3RaYTNfeOWlrrNdiHFZsOKT73X7amMuu2UOEHmNurWdc
        Vk60PHAcqv9FhFbaMEVh485wpUpmgzc=
X-Google-Smtp-Source: ABdhPJxu7HQKSDyKxDWejft8wIx2gqh6LYqranx0Clfvo3O3OyjbgQPAEniOr3qipQk1Ydjn56mi8llXxDY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1502:b0:50d:8077:18bc with SMTP id
 q2-20020a056a00150200b0050d807718bcmr1105402pfu.63.1651023619319; Tue, 26 Apr
 2022 18:40:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Apr 2022 01:40:02 +0000
In-Reply-To: <20220427014004.1992589-1-seanjc@google.com>
Message-Id: <20220427014004.1992589-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220427014004.1992589-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 6/8] KVM: Fix multiple races in gfn=>pfn cache refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework the gfn=3D>pfn cache (gpc) refresh logic to address multiple races
between the cache itself, and between the cache and mmu_notifier events.

The existing refresh code attempts to guard against races with the
mmu_notifier by speculatively marking the cache valid, and then marking
it invalid if a mmu_notifier invalidation occurs.  That handles the case
where an invalidation occurs between dropping and re-acquiring gpc->lock,
but it doesn't handle the scenario where the cache is refreshed after the
cache was invalidated by the notifier, but before the notifier elevates
mmu_notifier_count.  The gpc refresh can't use the "retry" helper as its
invalidation occurs _before_ mmu_notifier_count is elevated and before
mmu_notifier_range_start is set/updated.

  CPU0                                    CPU1
  ----                                    ----

  gfn_to_pfn_cache_invalidate_start()
  |
  -> gpc->valid =3D false;
                                          kvm_gfn_to_pfn_cache_refresh()
                                          |
                                          |-> gpc->valid =3D true;

                                          hva_to_pfn_retry()
                                          |
                                          -> acquire kvm->mmu_lock
                                             kvm->mmu_notifier_count =3D=3D=
 0
                                             mmu_seq =3D=3D kvm->mmu_notifi=
er_seq
                                             drop kvm->mmu_lock
                                             return pfn 'X'
  acquire kvm->mmu_lock
  kvm_inc_notifier_count()
  drop kvm->mmu_lock()
  kernel frees pfn 'X'
                                          kvm_gfn_to_pfn_cache_check()
                                          |
                                          |-> gpc->valid =3D=3D true

                                          caller accesses freed pfn 'X'

Key off of mn_active_invalidate_count to detect that a pfncache refresh
needs to wait for an in-progress mmu_notifier invalidation.  While
mn_active_invalidate_count is not guaranteed to be stable, it is
guaranteed to be elevated prior to an invalidation acquiring gpc->lock,
so either the refresh will see an active invalidation and wait, or the
invalidation will run after the refresh completes.

Speculatively marking the cache valid is itself flawed, as a concurrent
kvm_gfn_to_pfn_cache_check() would see a valid cache with stale pfn/khva
values.  The KVM Xen use case explicitly allows/wants multiple users;
even though the caches are allocated per vCPU, __kvm_xen_has_interrupt()
can read a different vCPU (or vCPUs).  Address this race by invalidating
the cache prior to dropping gpc->lock (this is made possible by fixing
the above mmu_notifier race).

Finally, the refresh logic doesn't protect against concurrent refreshes
with different GPAs (which may or may not be a desired use case, but its
allowed in the code), nor does it protect against a false negative on the
memslot generation.  If the first refresh sees a stale memslot generation,
it will refresh the hva and generation before moving on to the hva=3D>pfn
translation.  If it then drops gpc->lock, a different user can come along,
acquire gpc->lock, see that the memslot generation is fresh, and skip
the hva=3D>pfn update due to the userspace address also matching (because
it too was updated).  Address this race by adding an "in-progress" flag
so that the refresh that acquires gpc->lock first runs to completion
before other users can start their refresh.

Complicating all of this is the fact that both the hva=3D>pfn resolution
and mapping of the kernel address can sleep, i.e. must be done outside
of gpc->lock

Fix the above races in one fell swoop, trying to fix each individual race
in a sane manner is impossible, for all intents and purposes.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation sup=
port")
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Mingwei Zhang <mizhang@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_types.h |   1 +
 virt/kvm/kvm_main.c       |   9 ++
 virt/kvm/pfncache.c       | 209 +++++++++++++++++++++++++-------------
 3 files changed, 148 insertions(+), 71 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index ac1ebb37a0ff..83dcb97dddf1 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -74,6 +74,7 @@ struct gfn_to_pfn_cache {
 	enum pfn_cache_usage usage;
 	bool active;
 	bool valid;
+	bool refresh_in_progress;
 };
=20
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dfb7dabdbc63..0848430f36c6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -705,6 +705,15 @@ static int kvm_mmu_notifier_invalidate_range_start(str=
uct mmu_notifier *mn,
 	kvm->mn_active_invalidate_count++;
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
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
=20
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 05cb0bcbf662..b1665d0e6c32 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -112,31 +112,122 @@ static void gpc_release_pfn_and_khva(struct kvm *kvm=
, kvm_pfn_t pfn, void *khva)
 	}
 }
=20
-static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
+static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache=
 *gpc)
 {
+	/* Note, the new page offset may be different than the old! */
+	void *old_khva =3D gpc->khva - offset_in_page(gpc->khva);
+	kvm_pfn_t new_pfn =3D KVM_PFN_ERR_FAULT;
+	void *new_khva =3D NULL;
 	unsigned long mmu_seq;
-	kvm_pfn_t new_pfn;
-	int retry;
=20
-	do {
+	lockdep_assert_held_write(&gpc->lock);
+
+	/*
+	 * Invalidate the cache prior to dropping gpc->lock, gpc->uhva has
+	 * already been updated and so a concurrent refresh from a different
+	 * task will not detect that gpa/uhva changed.
+	 */
+	gpc->valid =3D false;
+
+	for (;;) {
 		mmu_seq =3D kvm->mmu_notifier_seq;
 		smp_rmb();
=20
+		write_unlock_irq(&gpc->lock);
+
+		/*
+		 * If the previous iteration "failed" due to an mmu_notifier
+		 * event, release the pfn and unmap the kernel virtual address
+		 * from the previous attempt.  Unmapping might sleep, so this
+		 * needs to be done after dropping the lock.  Opportunistically
+		 * check for resched while the lock isn't held.
+		 */
+		if (new_pfn !=3D KVM_PFN_ERR_FAULT) {
+			/*
+			 * Keep the mapping if the previous iteration reused
+			 * the existing mapping and didn't create a new one.
+			 */
+			if (new_khva =3D=3D old_khva)
+				new_khva =3D NULL;
+
+			gpc_release_pfn_and_khva(kvm, new_pfn, new_khva);
+
+			cond_resched();
+		}
+
 		/* We always request a writeable mapping */
-		new_pfn =3D hva_to_pfn(uhva, false, NULL, true, NULL);
+		new_pfn =3D hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
-			break;
+			goto out_error;
+
+		/*
+		 * Obtain a new kernel mapping if KVM itself will access the
+		 * pfn.  Note, kmap() and memremap() can both sleep, so this
+		 * too must be done outside of gpc->lock!
+		 */
+		if (gpc->usage & KVM_HOST_USES_PFN) {
+			if (new_pfn =3D=3D gpc->pfn) {
+				new_khva =3D old_khva;
+			} else if (pfn_valid(new_pfn)) {
+				new_khva =3D kmap(pfn_to_page(new_pfn));
+#ifdef CONFIG_HAS_IOMEM
+			} else {
+				new_khva =3D memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
+			}
+			if (!new_khva) {
+				kvm_release_pfn_clean(new_pfn);
+				goto out_error;
+			}
+		}
+
+		write_lock_irq(&gpc->lock);
=20
-		KVM_MMU_READ_LOCK(kvm);
-		retry =3D mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
-		KVM_MMU_READ_UNLOCK(kvm);
-		if (!retry)
+		/*
+		 * Other tasks must wait for _this_ refresh to complete before
+		 * attempting to refresh.
+		 */
+		WARN_ON_ONCE(gpc->valid);
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
+		if (kvm->mmu_notifier_seq =3D=3D mmu_seq)
 			break;
+	}
+
+	gpc->valid =3D true;
+	gpc->pfn =3D new_pfn;
+	gpc->khva =3D new_khva + (gpc->gpa & ~PAGE_MASK);
+	return 0;
=20
-		cond_resched();
-	} while (1);
+out_error:
+	write_lock_irq(&gpc->lock);
=20
-	return new_pfn;
+	return -EFAULT;
 }
=20
 int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache =
*gpc,
@@ -147,7 +238,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struc=
t gfn_to_pfn_cache *gpc,
 	kvm_pfn_t old_pfn, new_pfn;
 	unsigned long old_uhva;
 	void *old_khva;
-	bool old_valid;
 	int ret =3D 0;
=20
 	/*
@@ -159,10 +249,23 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, str=
uct gfn_to_pfn_cache *gpc,
=20
 	write_lock_irq(&gpc->lock);
=20
+	/*
+	 * If another task is refreshing the cache, wait for it to complete.
+	 * There is no guarantee that concurrent refreshes will see the same
+	 * gpa, memslots generation, etc..., so they must be fully serialized.
+	 */
+	while (gpc->refresh_in_progress) {
+		write_unlock_irq(&gpc->lock);
+
+		cond_resched();
+
+		write_lock_irq(&gpc->lock);
+	}
+	gpc->refresh_in_progress =3D true;
+
 	old_pfn =3D gpc->pfn;
 	old_khva =3D gpc->khva - offset_in_page(gpc->khva);
 	old_uhva =3D gpc->uhva;
-	old_valid =3D gpc->valid;
=20
 	/* If the userspace HVA is invalid, refresh that first */
 	if (gpc->gpa !=3D gpa || gpc->generation !=3D slots->generation ||
@@ -175,7 +278,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struc=
t gfn_to_pfn_cache *gpc,
 		gpc->uhva =3D gfn_to_hva_memslot(gpc->memslot, gfn);
=20
 		if (kvm_is_error_hva(gpc->uhva)) {
-			gpc->pfn =3D KVM_PFN_ERR_FAULT;
 			ret =3D -EFAULT;
 			goto out;
 		}
@@ -185,60 +287,8 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc,
 	 * If the userspace HVA changed or the PFN was already invalid,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
-	if (!old_valid || old_uhva !=3D gpc->uhva) {
-		unsigned long uhva =3D gpc->uhva;
-		void *new_khva =3D NULL;
-
-		/* Placeholders for "hva is valid but not yet mapped" */
-		gpc->pfn =3D KVM_PFN_ERR_FAULT;
-		gpc->khva =3D NULL;
-		gpc->valid =3D true;
-
-		write_unlock_irq(&gpc->lock);
-
-		new_pfn =3D hva_to_pfn_retry(kvm, uhva);
-		if (is_error_noslot_pfn(new_pfn)) {
-			ret =3D -EFAULT;
-			goto map_done;
-		}
-
-		if (gpc->usage & KVM_HOST_USES_PFN) {
-			if (new_pfn =3D=3D old_pfn) {
-				/*
-				 * Reuse the existing pfn and khva, but put the
-				 * reference acquired hva_to_pfn_retry(); the
-				 * cache still holds a reference to the pfn
-				 * from the previous refresh.
-				 */
-				gpc_release_pfn_and_khva(kvm, new_pfn, NULL);
-
-				new_khva =3D old_khva;
-				old_pfn =3D KVM_PFN_ERR_FAULT;
-				old_khva =3D NULL;
-			} else if (pfn_valid(new_pfn)) {
-				new_khva =3D kmap(pfn_to_page(new_pfn));
-#ifdef CONFIG_HAS_IOMEM
-			} else {
-				new_khva =3D memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
-#endif
-			}
-			if (new_khva)
-				new_khva +=3D page_offset;
-			else
-				ret =3D -EFAULT;
-		}
-
-	map_done:
-		write_lock_irq(&gpc->lock);
-		if (ret) {
-			gpc->valid =3D false;
-			gpc->pfn =3D KVM_PFN_ERR_FAULT;
-			gpc->khva =3D NULL;
-		} else {
-			/* At this point, gpc->valid may already have been cleared */
-			gpc->pfn =3D new_pfn;
-			gpc->khva =3D new_khva;
-		}
+	if (!gpc->valid || old_uhva !=3D gpc->uhva) {
+		ret =3D hva_to_pfn_retry(kvm, gpc);
 	} else {
 		/* If the HVA=E2=86=92PFN mapping was already valid, don't unmap it. */
 		old_pfn =3D KVM_PFN_ERR_FAULT;
@@ -246,9 +296,26 @@ int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, stru=
ct gfn_to_pfn_cache *gpc,
 	}
=20
  out:
+	/*
+	 * Invalidate the cache and purge the pfn/khva if the refresh failed.
+	 * Some/all of the uhva, gpa, and memslot generation info may still be
+	 * valid, leave it as is.
+	 */
+	if (ret) {
+		gpc->valid =3D false;
+		gpc->pfn =3D KVM_PFN_ERR_FAULT;
+		gpc->khva =3D NULL;
+	}
+
+	gpc->refresh_in_progress =3D false;
+
+	/* Snapshot the new pfn before dropping the lock! */
+	new_pfn =3D gpc->pfn;
+
 	write_unlock_irq(&gpc->lock);
=20
-	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
+	if (old_pfn !=3D new_pfn)
+		gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
=20
 	return ret;
 }
--=20
2.36.0.rc2.479.g8af0fa9b8e-goog

