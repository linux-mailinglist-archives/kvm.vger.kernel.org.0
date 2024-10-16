Return-Path: <kvm+bounces-28961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9678B99FCB6
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 02:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B1C01F258BE
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 00:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD233C0B;
	Wed, 16 Oct 2024 00:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhFxdRos"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621E5A31
	for <kvm@vger.kernel.org>; Wed, 16 Oct 2024 00:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729037094; cv=none; b=avQ7KpYVCCNXfM3iL3j1yDUB84Y+RkB0YrnG05n6M1WiUfrWnxUceoCyHgFl+s5TyKYJp3UORJM1EE6SGcXTRWSJEdBM7ziHiKYf3pIcggInhotwpC/S1iNo1T63x1ksF+zcA1Y1fkJYVXR5nKroHEyqMgr5qXFMgzwcTqHkR3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729037094; c=relaxed/simple;
	bh=Bhnb0qay+f8vRpouxT282hVgPPlYUERdpqC9TZwTrzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qo82mwpIPM6oHWaZF6pxbchTMvMPsi7V0QTADziCIE86zZ2X38PMRG1cTE/8tilsGiy78Ho+IHUTyN+7qKFoUrYsVI1iCYuv6e9O2qRLoe6oRKY6lLTGOOXVPP0YEyxQutAbrW+Gu+byiFBnImKFbCgP38dBNy4LlfWpGsLYaE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhFxdRos; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7d4f9974c64so3613348a12.1
        for <kvm@vger.kernel.org>; Tue, 15 Oct 2024 17:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729037091; x=1729641891; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QpfyuceG/urxxbR8/JU8hdOJ7xVumIOeEoRPhWi+pQk=;
        b=QhFxdRoso72PxEeedEcIuf8nGKpDUnwvGFyod6bXF8L8Ra9RPED8A7NvKuuwsycWGI
         jxcjMureWsJwQv56nOjqTI6z93C7PFLi35gSavjrw4Bxs+dYFD7EnUp6zIp38hZDqg9S
         xKEje7lHGXz5effo/QWQm/Tf0HgBYc/T48Vnb0gEYx9iiZ9u6P8gyHlfyebDLToBZMMp
         d70wYRFykASW9/+ZgYGzgv0O0RiI0DOAZ+MS81vBjmPYL6BXfQs8QzJQh3ugcQiwODVU
         SDxVGF57HR+bS59hZnsJJmih/x5h5uFwQO8UVbjVhzJY7YiEVtDV1bwfDSzGwdrrVrA1
         Bi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729037091; x=1729641891;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QpfyuceG/urxxbR8/JU8hdOJ7xVumIOeEoRPhWi+pQk=;
        b=T8gc+NyHkdxlCMoN20ZLj7dnQ49eFR0dig8v8XcKTo5GrTeQDSpYcZrA+oWSQLYWRN
         87lEYNGe1IgLazOwwMy9mUdcsTbOO8vZYMmUo9w/JC15Vwc/QY/6KJvcIatWJTYnClip
         //qt+R2I4lsuCLAcm7EsdTWAjXL8KZs0HuHYMHgxMsd6KTwOWUG7PzHUPrGOxHHvBVSX
         WMkXsIV2rV7FiwDvmMd4xKZolDflQynwm2xMCcuX9pWyCOuPnPqI+YhAB3Lk7gdYXbG9
         gp0Z8P1fmDP3YAuyhgtgn7bBlgIdfUoL+mP2Gyxhl3obMul9NRY3tbyEo/wErOm7EbKn
         Pm9A==
X-Forwarded-Encrypted: i=1; AJvYcCWGoZMuFcuz7+iFaLysUilaY3cJJTEpnetgdofwlVFtFW4bsTWSec70yJK2SZ/MvLuXLuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGHtBGHkgzwxjQhmu9KJJWH97EB7LCE1y1PqKBWSdYFXDTPaKz
	F1I4lqTSPOSONnSTQPfyptDWEMNmZoLgu5rXyunRALtvP/+BXL1DWrW+qe1UVk917t0SijoZERk
	cpw==
X-Google-Smtp-Source: AGHT+IEucvEfpcrtr1xXnnkRwEOva3mGmTFBIm+/apWzQAkvXaf1hb8y2eOmu41fkhcTJr/lgxSvsxMEKnI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:744f:0:b0:7ea:6cb6:6e8b with SMTP id
 41be03b00d2f7-7eaa6c5a0c7mr1702a12.3.1729037090411; Tue, 15 Oct 2024 17:04:50
 -0700 (PDT)
Date: Tue, 15 Oct 2024 17:04:48 -0700
In-Reply-To: <20240821202814.711673-2-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240821202814.711673-1-dwmw2@infradead.org> <20240821202814.711673-2-dwmw2@infradead.org>
Message-ID: <Zw8DINUkJJKDByXE@google.com>
Subject: Re: [PATCH v3 2/5] KVM: pfncache: Implement range-based invalidation
 check for hva_to_pfn_retry()
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Mushahid Hussain <hmushi@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="oDMvAmx7QP3BxXt9"


--oDMvAmx7QP3BxXt9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2024, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
> If there are any concurrent invalidations running, it's effectively just
> a complex busy wait loop because its local mmu_notifier_retry_cache()
> function will always return true.
> 
> Since multiple invalidations can be running in parallel, this can result
> in a situation where hva_to_pfn_retry() just backs off and keep retrying
> for ever, not making any progress.
> 
> Solve this by being a bit more selective about when to retry. In
> addition to the ->needs_invalidation flag added in a previous commit,
> check before calling hva_to_pfn() if there is any pending invalidation
> (i.e. between invalidate_range_start() and invalidate_range_end()) which
> affects the uHVA of the GPC being updated. This catches the case where
> hva_to_pfn() would return a soon-to-be-stale mapping of a range for which
> the invalidate_range_start() hook had already been called before the uHVA
> was even set in the GPC and the ->needs_invalidation flag set.
> 
> An invalidation which *starts* after the lock is dropped in the loop is
> fine because it will clear the ->needs_revalidation flag and also trigger
> a retry.
> 
> This is slightly more complex than it needs to be; moving the
> invalidation to occur in the invalidate_range_end() hook will make life
> simpler, in a subsequent commit.

I'm pretty sure that's still more complex than it needs to be.  And even if the
gpc implementation isn't any more/less complex, diverging from the page fault
side of things makes KVM overall more complex.

Maybe I'm just not seeing some functionality that needs_invalidation provides,
but I still don't understand why it's necessary. 

Omitting context to keep this short, I think the below is what we can end up at;
see attached (very lightly tested) patches for the full idea.  So long as either
the invalidation side marks the gpc invalid, or the refresh side is guaranteed
to check for an invalidation, I don't see why needs_invalidation is required.

If the cache is invalid, or the uhva is changing, then the event doesn't need to
do anything because refresh() will hva_to_pfn_retry() to re-resolve the pfn.  So
at that point, KVM just needs to ensure either hva_to_pfn_retry() observes the
in-progress range, or the event sees valid==true.

Note, the attached patches include the "wait" idea, but I'm not convinced that's
actually a good idea.  I'll respond more to your last patch.

gfn_to_pfn_cache_invalidate_start():

	...

	/*
	 * Ensure that either each cache sees the to-be-invalidated range and
	 * retries if necessary, or that this task sees the cache's valid flag
	 * and invalidates the cache before completing the mmu_notifier event.
	 * Note, gpc->uhva must be set before gpc->valid, and if gpc->uhva is
	 * modified the cache must be re-validated.  Pairs with the smp_mb() in
	 * hva_to_pfn_retry().
	 */
	smp_mb__before_atomic();

	spin_lock(&kvm->gpc_lock);
	list_for_each_entry(gpc, &kvm->gpc_list, list) {
		if (!gpc->valid || gpc->uhva < start || gpc->uhva >= end)
			continue;

		write_lock_irq(&gpc->lock);

		/*
		 * Verify the cache still needs to be invalidated after
		 * acquiring gpc->lock, to avoid an unnecessary invalidation
		 * in the unlikely scenario the cache became valid with a
		 * different userspace virtual address.
		 */
		if (gpc->valid && gpc->uhva >= start && gpc->uhva < end)
			gpc->valid = false;
		write_unlock_irq(&gpc->lock);
	}
	spin_unlock(&kvm->gpc_lock);

hva_to_pfn_retry():

	do {
		/*
		 * Invalidate the cache prior to dropping gpc->lock, the
		 * gpa=>uhva assets have already been updated and so a check()
		 * from a different task may not fail the gpa/uhva/generation
		 * checks, i.e. must observe valid==false.
		 */
		gpc->valid = false;

		write_unlock_irq(&gpc->lock);

		...

		write_lock_irq(&gpc->lock);

		/*
		 * Other tasks must wait for _this_ refresh to complete before
		 * attempting to refresh.
		 */
		WARN_ON_ONCE(gpc->valid);
		gpc->valid = true;

		/*
		 * Ensure valid is visible before checking if retry is needed.
		 * Pairs with the smp_mb__before_atomic() in
		 * gfn_to_pfn_cache_invalidate().
		 */
		smp_mb();
	} while (gpc_invalidate_retry_hva(gpc, mmu_seq));

> @@ -193,6 +174,29 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  
>  		write_unlock_irq(&gpc->lock);
>  
> +		/*
> +		 * Invalidation occurs from the invalidate_range_start() hook,
> +		 * which could already have happened before __kvm_gpc_refresh()
> +		 * (or the previous turn around this loop) took gpc->lock().
> +		 * If so, and if the corresponding invalidate_range_end() hook
> +		 * hasn't happened yet, hva_to_pfn() could return a mapping
> +		 * which is about to be stale and which should not be used. So
> +		 * check if there are any currently-running invalidations which
> +		 * affect the uHVA of this GPC, and retry if there are. Any
> +		 * invalidation which starts after gpc->needs_invalidation is
> +		 * set is fine, because it will clear that flag and trigger a
> +		 * retry. And any invalidation which *completes* by having its
> +		 * invalidate_range_end() hook called immediately prior to this
> +		 * check is also fine, because the page tables are guaranteed
> +		 * to have been changted already, so hva_to_pfn() won't return

s/changted/changed

> +		 * a stale mapping in that case anyway.
> +		 */
> +		while (gpc_invalidations_pending(gpc)) {
> +			cond_resched();
> +			write_lock_irq(&gpc->lock);
> +			continue;

Heh, our testcase obviously isn't as robust as we hope it is.  Or maybe only the
"wait" version was tested.  The "continue" here will continue the
while(gpc_invalidations_pending) loop, not the outer while loop.  That will cause
deadlock due to trying acquiring gpc->lock over and over.

> +		}
> +
>  		/*
>  		 * If the previous iteration "failed" due to an mmu_notifier
>  		 * event, release the pfn and unmap the kernel virtual address
> @@ -233,6 +237,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
>  			goto out_error;
>  		}
>  
> +

Spurious whitespace.

>  		write_lock_irq(&gpc->lock);
>  
>  		/*


--oDMvAmx7QP3BxXt9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-pfncache-Snapshot-mmu_invalidate_seq-immediately.patch"

From 4e34801acab175913b6fd5b6c7c4aa1350d5e571 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 15 Oct 2024 16:35:15 -0700
Subject: [PATCH 1/5] KVM: pfncache: Snapshot mmu_invalidate_seq immediately
 before hva_to_pfn()

Grab the snapshot of the mmu_notifier sequence counter immediately before
calling hva_to_pfn() when refreching a gpc, as there's no requirement that
the snapshot be taken while holding gpc->lock; the sequence counter is
completely independent of locking.  This will allow waiting on in-progress
invalidations to complete, instead of actively trying to resolve a pfn
that KVM is guaranteed to discard (because either the invalidation will
still be in-progress, or it will have completed and bumped the sequence
counter).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..4afbc1262e3f 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -172,9 +172,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	gpc->valid = false;
 
 	do {
-		mmu_seq = gpc->kvm->mmu_invalidate_seq;
-		smp_rmb();
-
 		write_unlock_irq(&gpc->lock);
 
 		/*
@@ -197,6 +194,9 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			cond_resched();
 		}
 
+		mmu_seq = gpc->kvm->mmu_invalidate_seq;
+		smp_rmb();
+
 		/* We always request a writeable mapping */
 		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.47.0.rc1.288.g06298d1525-goog


--oDMvAmx7QP3BxXt9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-pfncache-Wait-for-in-progress-invalidations-to-c.patch"

From b023d3ada9c856cbfe38839068861e5f2e19489f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 15 Oct 2024 16:33:58 -0700
Subject: [PATCH 2/5] KVM: pfncache: Wait for in-progress invalidations to
 complete during refresh

When refreshing a gpc, wait for in-progress invalidations to complete
before reading the sequence counter and resolving the pfn.  Resolving the
pfn when there is an in-progress invalidation is worse than pointless, as
the pfn is guaranteed to be discarded, and trying to resolve the pfn could
contended for resources, e.g. mmap_lock, and make the invalidation and
thus refresh take longer to complete.

Suggested-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 4afbc1262e3f..957f739227ab 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -194,6 +194,18 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			cond_resched();
 		}
 
+		/*
+		 * Wait for in-progress invalidations to complete if the user
+		 * already being invalidated.  Unlike the page fault path, this
+		 * task _must_ complete the refresh, i.e. there's no value in
+		 * trying to race ahead in the hope that a different task makes
+		 * the cache valid.
+		 */
+		while (READ_ONCE(gpc->kvm->mn_active_invalidate_count)) {
+			if (!cond_resched())
+				cpu_relax();
+		}
+
 		mmu_seq = gpc->kvm->mmu_invalidate_seq;
 		smp_rmb();
 
-- 
2.47.0.rc1.288.g06298d1525-goog


--oDMvAmx7QP3BxXt9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0003-KVM-pfncache-Implement-range-based-invalidation-chec.patch"

From 98de4aad0c442958b95ca62e0a9ff1a736b71bb7 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Tue, 15 Oct 2024 12:49:06 -0700
Subject: [PATCH 3/5] KVM: pfncache: Implement range-based invalidation check
 for hva_to_pfn_retry()

The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
If there are any concurrent invalidations running, it's effectively just
a complex busy wait loop because its local mmu_notifier_retry_cache()
function will always return true.  Even worse, caches are forced to wait
even if the invalidations do not affect the cache's virtual address range.

Since multiple invalidations can be running in parallel, this can result
in a situation where hva_to_pfn_retry() just backs off and keeps retrying
forever, not making any progress.

Mitigate the badness by being a bit more selective about when to retry.
Specifically, retry only if an in-progress invalidation range affects the
cache, i.e. implement range-based invalidation for caches, similar to how
KVM imlements range-based invalidation for page faults.

Note, like the existing range-based invalidation, this approach doesn't
completely prevent false positives since the in-progress range never
shrinks.  E.g. if userspace is spamming invalidations *and* simultaneously
invalidates a cache, the cache will still get stuck until the spam stops.
However, that problem already exists with page faults, and precisely
tracking in-progress ranges would add significant complexity.  Defer
trying to address that issue until it actually becomes a problem, which in
all likelihood will never happen.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      |  7 ++--
 virt/kvm/pfncache.c      | 75 ++++++++++++++++++++++++++++------------
 3 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index db567d26f7b9..2c0ed735f0f4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -785,6 +785,8 @@ struct kvm {
 	/* For management / invalidation of gfn_to_pfn_caches */
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
+	u64 mmu_gpc_invalidate_range_start;
+	u64 mmu_gpc_invalidate_range_end;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..b9223ecab2ca 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -775,7 +775,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 */
 	spin_lock(&kvm->mn_invalidate_lock);
 	kvm->mn_active_invalidate_count++;
-	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
 	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
@@ -784,10 +783,10 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * any given time, and the caches themselves can check for hva overlap,
 	 * i.e. don't need to rely on memslot overlap checks for performance.
 	 * Because this runs without holding mmu_lock, the pfn caches must use
-	 * mn_active_invalidate_count (see above) instead of
-	 * mmu_invalidate_in_progress.
+	 * mn_active_invalidate_count instead of mmu_invalidate_in_progress.
 	 */
 	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
+	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
 	 * If one or more memslots were found and thus zapped, notify arch code
@@ -1164,6 +1163,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
+	kvm->mmu_gpc_invalidate_range_start = KVM_HVA_ERR_BAD;
+	kvm->mmu_gpc_invalidate_range_end = KVM_HVA_ERR_BAD;
 
 	INIT_LIST_HEAD(&kvm->devices);
 	kvm->max_vcpus = KVM_MAX_VCPUS;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 957f739227ab..3d5bc9bab3d9 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -27,6 +27,27 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 {
 	struct gfn_to_pfn_cache *gpc;
 
+	lockdep_assert_held(&kvm->mn_invalidate_lock);
+
+	if (likely(kvm->mn_active_invalidate_count == 1)) {
+		kvm->mmu_gpc_invalidate_range_start = start;
+		kvm->mmu_gpc_invalidate_range_end = end;
+	} else {
+		/*
+		 * Fully tracking multiple concurrent ranges has diminishing
+		 * returns. Keep things simple and just find the minimal range
+		 * which includes the current and new ranges. As there won't be
+		 * enough information to subtract a range after its invalidate
+		 * completes, any ranges invalidated concurrently will
+		 * accumulate and persist until all outstanding invalidates
+		 * complete.
+		 */
+		kvm->mmu_gpc_invalidate_range_start =
+			min(kvm->mmu_gpc_invalidate_range_start, start);
+		kvm->mmu_gpc_invalidate_range_end =
+			max(kvm->mmu_gpc_invalidate_range_end, end);
+	}
+
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
 		read_lock_irq(&gpc->lock);
@@ -74,6 +95,8 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
+	lockdep_assert_held(&gpc->lock);
+
 	if (!gpc->active)
 		return false;
 
@@ -124,21 +147,26 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
 
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
+static bool gpc_invalidate_in_progress_hva(struct gfn_to_pfn_cache *gpc)
 {
+	struct kvm *kvm = gpc->kvm;
+
 	/*
-	 * mn_active_invalidate_count acts for all intents and purposes
-	 * like mmu_invalidate_in_progress here; but the latter cannot
-	 * be used here because the invalidation of caches in the
-	 * mmu_notifier event occurs _before_ mmu_invalidate_in_progress
-	 * is elevated.
-	 *
-	 * Note, it does not matter that mn_active_invalidate_count
-	 * is not protected by gpc->lock.  It is guaranteed to
-	 * be elevated before the mmu_notifier acquires gpc->lock, and
-	 * isn't dropped until after mmu_invalidate_seq is updated.
+	 * Ensure the count and range are always read from memory so that
+	 * checking for retry in a loop won't get false negatives on the range,
+	 * and won't result in an infinite retry loop.  Note, the range never
+	 * shrinks, only grows, and so the key to avoiding infinite retry loops
+	 * is observing the 1=>0 transition of the count.
 	 */
-	if (kvm->mn_active_invalidate_count)
+	return unlikely(READ_ONCE(kvm->mn_active_invalidate_count)) &&
+	       READ_ONCE(kvm->mmu_gpc_invalidate_range_start) <= gpc->uhva &&
+	       READ_ONCE(kvm->mmu_gpc_invalidate_range_end) > gpc->uhva;
+}
+
+static bool gpc_invalidate_retry_hva(struct gfn_to_pfn_cache *gpc,
+				     unsigned long mmu_seq)
+{
+	if (gpc_invalidate_in_progress_hva(gpc))
 		return true;
 
 	/*
@@ -149,7 +177,7 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	 * new (incremented) value of mmu_invalidate_seq is observed.
 	 */
 	smp_rmb();
-	return kvm->mmu_invalidate_seq != mmu_seq;
+	return gpc->kvm->mmu_invalidate_seq != mmu_seq;
 }
 
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
@@ -164,14 +192,15 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	lockdep_assert_held_write(&gpc->lock);
 
-	/*
-	 * Invalidate the cache prior to dropping gpc->lock, the gpa=>uhva
-	 * assets have already been updated and so a concurrent check() from a
-	 * different task may not fail the gpa/uhva/generation checks.
-	 */
-	gpc->valid = false;
-
 	do {
+		/*
+		 * Invalidate the cache prior to dropping gpc->lock, the
+		 * gpa=>uhva assets have already been updated and so a check()
+		 * from a different task may not fail the gpa/uhva/generation
+		 * checks, i.e. must observe valid==false.
+		 */
+		gpc->valid = false;
+
 		write_unlock_irq(&gpc->lock);
 
 		/*
@@ -201,7 +230,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * trying to race ahead in the hope that a different task makes
 		 * the cache valid.
 		 */
-		while (READ_ONCE(gpc->kvm->mn_active_invalidate_count)) {
+		while (gpc_invalidate_in_progress_hva(gpc)) {
 			if (!cond_resched())
 				cpu_relax();
 		}
@@ -236,9 +265,9 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+		gpc->valid = true;
+	} while (gpc_invalidate_retry_hva(gpc, mmu_seq));
 
-	gpc->valid = true;
 	gpc->pfn = new_pfn;
 	gpc->khva = new_khva + offset_in_page(gpc->uhva);
 
-- 
2.47.0.rc1.288.g06298d1525-goog


--oDMvAmx7QP3BxXt9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0004-KVM-pfncache-Add-lockless-checking-of-cache-invalida.patch"

From 423be552d22d83a49ce4d0ad7865b8f4e3f1eeb0 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 15 Oct 2024 13:57:54 -0700
Subject: [PATCH 4/5] KVM: pfncache: Add lockless checking of cache
 invalidation events

When handling an mmu_notifier invalidation event, perform the initial check
for overlap with a valid gpc_to_pfn_cache without acquiring the cache's
lock, and instead ensure either the invalidation event observes a valid
cache, or the cache observes the invalidation event.

Locklessly checking gpc->valid and gpc->uhva relies on several existing
invariants:

 - Changing gpc->uhva requires performing a refresh()
 - A cache can be made valid only during refresh()
 - Only one task can execute refresh() at a time
 - Tasks must check() a cache after a successful refresh()
 - check() must hold gpc->lock (usually for read)

The existing invariants means that if KVM observes an invalid gpc, or if
the uhva is unstable, then a refresh() is in-progress or will be performed
prior to consuming the new uhva.  And so KVM simply needs to ensure that
refresh() sees the invalidation and retries, or that the invalidation sees
the fully valid gpc.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 51 ++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 3d5bc9bab3d9..2163bb6b899c 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -48,32 +48,32 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 			max(kvm->mmu_gpc_invalidate_range_end, end);
 	}
 
+	/*
+	 * Ensure that either each cache sees the to-be-invalidated range and
+	 * retries if necessary, or that this task sees the cache's valid flag
+	 * and invalidates the cache before completing the mmu_notifier event.
+	 * Note, gpc->uhva must be set before gpc->valid, and if gpc->uhva is
+	 * modified the cache must be re-validated.  Pairs with the smp_mb() in
+	 * hva_to_pfn_retry().
+	 */
+	smp_mb__before_atomic();
+
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
-		read_lock_irq(&gpc->lock);
-
-		/* Only a single page so no need to care about length */
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-		    gpc->uhva >= start && gpc->uhva < end) {
-			read_unlock_irq(&gpc->lock);
-
-			/*
-			 * There is a small window here where the cache could
-			 * be modified, and invalidation would no longer be
-			 * necessary. Hence check again whether invalidation
-			 * is still necessary once the write lock has been
-			 * acquired.
-			 */
-
-			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >= start && gpc->uhva < end)
-				gpc->valid = false;
-			write_unlock_irq(&gpc->lock);
+		if (!gpc->valid || gpc->uhva < start || gpc->uhva >= end)
 			continue;
-		}
 
-		read_unlock_irq(&gpc->lock);
+		write_lock_irq(&gpc->lock);
+
+		/*
+		 * Verify the cache still needs to be invalidated after
+		 * acquiring gpc->lock, to avoid an unnecessary invalidation
+		 * in the unlikely scenario the cache became valid with a
+		 * different userspace virtual address.
+		 */
+		if (gpc->valid && gpc->uhva >= start && gpc->uhva < end)
+			gpc->valid = false;
+		write_unlock_irq(&gpc->lock);
 	}
 	spin_unlock(&kvm->gpc_lock);
 }
@@ -266,6 +266,13 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 */
 		WARN_ON_ONCE(gpc->valid);
 		gpc->valid = true;
+
+		/*
+		 * Ensure valid is visible before checking if retry is needed.
+		 * Pairs with the smp_mb__before_atomic() in
+		 * gfn_to_pfn_cache_invalidate().
+		 */
+		smp_mb();
 	} while (gpc_invalidate_retry_hva(gpc, mmu_seq));
 
 	gpc->pfn = new_pfn;
-- 
2.47.0.rc1.288.g06298d1525-goog


--oDMvAmx7QP3BxXt9
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0005-KVM-pfncache-Wait-for-pending-invalidations-instead-.patch"

From 6df3fbb08269acfbf28b2cf2fab12c1a0e7c52f7 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw@amazon.co.uk>
Date: Tue, 15 Oct 2024 14:55:49 -0700
Subject: [PATCH 5/5] KVM: pfncache: Wait for pending invalidations instead of
 spinning

The busy loop in hva_to_pfn_retry() is worse than a normal page fault
retry loop because it spins even while it's waiting for the invalidation
to complete. It isn't just that a page might get faulted out again before
it's actually accessed.

Introduce a wait queue to be woken when kvm->mn_active_invalidate_count
reaches zero, and wait on it if there is any pending invalidation which
affects the GPC being refreshed.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
[sean: massage comment as part of rebasing]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  9 ++++++---
 virt/kvm/pfncache.c      | 30 ++++++++++++++++++++++++++----
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c0ed735f0f4..a9d7b2200b6f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -787,6 +787,7 @@ struct kvm {
 	struct list_head gpc_list;
 	u64 mmu_gpc_invalidate_range_start;
 	u64 mmu_gpc_invalidate_range_end;
+	wait_queue_head_t gpc_invalidate_wq;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b9223ecab2ca..3ba6d109a941 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -849,11 +849,13 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
-	 * There can only be one waiter, since the wait happens under
-	 * slots_lock.
+	 * There can only be one memslots waiter, since the wait happens under
+	 * slots_lock, but there can be multiple gpc waiters.
 	 */
-	if (wake)
+	if (wake) {
+		wake_up(&kvm->gpc_invalidate_wq);
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+	}
 }
 
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
@@ -1163,6 +1165,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
+	init_waitqueue_head(&kvm->gpc_invalidate_wq);
 	kvm->mmu_gpc_invalidate_range_start = KVM_HVA_ERR_BAD;
 	kvm->mmu_gpc_invalidate_range_end = KVM_HVA_ERR_BAD;
 
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2163bb6b899c..77cc5633636a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -180,6 +180,30 @@ static bool gpc_invalidate_retry_hva(struct gfn_to_pfn_cache *gpc,
 	return gpc->kvm->mmu_invalidate_seq != mmu_seq;
 }
 
+static void gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
+{
+	struct kvm *kvm = gpc->kvm;
+
+	spin_lock(&kvm->mn_invalidate_lock);
+	if (gpc_invalidate_in_progress_hva(gpc)) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&kvm->gpc_invalidate_wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+
+			if (!gpc_invalidate_in_progress_hva(gpc))
+				break;
+
+			spin_unlock(&kvm->mn_invalidate_lock);
+			schedule();
+			spin_lock(&kvm->mn_invalidate_lock);
+		}
+		finish_wait(&kvm->gpc_invalidate_wq, &wait);
+	}
+	spin_unlock(&kvm->mn_invalidate_lock);
+}
+
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
@@ -230,10 +254,8 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * trying to race ahead in the hope that a different task makes
 		 * the cache valid.
 		 */
-		while (gpc_invalidate_in_progress_hva(gpc)) {
-			if (!cond_resched())
-				cpu_relax();
-		}
+		while (gpc_invalidate_in_progress_hva(gpc))
+			gpc_wait_for_invalidations(gpc);
 
 		mmu_seq = gpc->kvm->mmu_invalidate_seq;
 		smp_rmb();
-- 
2.47.0.rc1.288.g06298d1525-goog


--oDMvAmx7QP3BxXt9--

