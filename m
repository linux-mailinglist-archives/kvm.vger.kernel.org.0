Return-Path: <kvm+bounces-24799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1D695A5DF
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:29:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8EDBB23D9D
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 20:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDF117B4F6;
	Wed, 21 Aug 2024 20:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bY44l8fB"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48CC176FC5;
	Wed, 21 Aug 2024 20:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272115; cv=none; b=mxId/fUPMcvBqcG7a6ZK60eAwYOd2wtXaMgG8vrzTA9b2z1FELVoEOnKp4sx5uNmjcRvDwSEltv2pfi54FuJv2t0U2YIYUZOqhJil6hHyWYSFKEPfV1JflFTXboMAdhXTidfJ3jpTemKLp7FZMya00FxW/oYaenu8ai4EnBjCBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272115; c=relaxed/simple;
	bh=4TZCEcMeHRDVkViBccCJGrdtaKSVz1KZdVpM6a0h8Ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLbjB5rMhEIFKsoUZTwVA0OJQnec0fF/q6yywSpZMg1/bB+a1NweT3v2rv8scP68oB0ZfBtb1JEB73fmkyQgoW89Sz0vjzN7vJ0GmRr8nJfETcAvSarepfIF3nOrXHZxWrJeyxIlgja5LGNN9uCSR4yIcYH4N3A1pQ+IIfhHoSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bY44l8fB; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZN2vyfIr2V0Pa6Fea5QC6HdpJRzhC2n5uBNf9IpQsyc=; b=bY44l8fBEVRWaH+Tp5N/hgRLQd
	eMNkSgLj29QNKmBL17iqa38jKqBP9pbhq3OQp8ZsANSB3MHWsmcu3D37ZcZlp2zn+7rAG+qcvtVha
	lzYln6d3RX4uM/3chlkRcT3H61BblqzxXA31jNrTQuMQHEDxwOFK8KAINbh3kNkyZHwZv1vziAHsN
	tCYcHpMW2R4i6S/c7xFCmCDTo2WBy9hSU4JxTAL49g3tTFgVpKsSVSC3d2efVI7aaRxDYSZOM+aNk
	JKdMcjIZsrdzSANOM7/2A/t75yxnVp8e14lh8Mg16K8qaGlNDMX1kgbdBaHWCe+B1iqPwVJxIpJ4N
	hk4piS4w==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwG-00000009hcn-1fL9;
	Wed, 21 Aug 2024 20:28:20 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwE-00000002z8s-0XVy;
	Wed, 21 Aug 2024 21:28:14 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Hussain, Mushahid" <hmushi@amazon.co.uk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Jim Mattson <jmattson@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingwei Zhang <mizhang@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 2/5] KVM: pfncache: Implement range-based invalidation check for hva_to_pfn_retry()
Date: Wed, 21 Aug 2024 21:28:10 +0100
Message-ID: <20240821202814.711673-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240821202814.711673-1-dwmw2@infradead.org>
References: <20240821202814.711673-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
If there are any concurrent invalidations running, it's effectively just
a complex busy wait loop because its local mmu_notifier_retry_cache()
function will always return true.

Since multiple invalidations can be running in parallel, this can result
in a situation where hva_to_pfn_retry() just backs off and keep retrying
for ever, not making any progress.

Solve this by being a bit more selective about when to retry. In
addition to the ->needs_invalidation flag added in a previous commit,
check before calling hva_to_pfn() if there is any pending invalidation
(i.e. between invalidate_range_start() and invalidate_range_end()) which
affects the uHVA of the GPC being updated. This catches the case where
hva_to_pfn() would return a soon-to-be-stale mapping of a range for which
the invalidate_range_start() hook had already been called before the uHVA
was even set in the GPC and the ->needs_invalidation flag set.

An invalidation which *starts* after the lock is dropped in the loop is
fine because it will clear the ->needs_revalidation flag and also trigger
a retry.

This is slightly more complex than it needs to be; moving the
invalidation to occur in the invalidate_range_end() hook will make life
simpler, in a subsequent commit.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_host.h |  2 ++
 virt/kvm/kvm_main.c      | 20 ++++++++++++++
 virt/kvm/pfncache.c      | 60 +++++++++++++++++++++-------------------
 3 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79a6b1a63027..1bfe2e8d52cd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -770,6 +770,8 @@ struct kvm {
 	/* For management / invalidation of gfn_to_pfn_caches */
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
+	u64 mmu_gpc_invalidate_range_start;
+	u64 mmu_gpc_invalidate_range_end;
 
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92901656a0d4..84eb1ebb6f47 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -775,6 +775,24 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 */
 	spin_lock(&kvm->mn_invalidate_lock);
 	kvm->mn_active_invalidate_count++;
+	if (likely(kvm->mn_active_invalidate_count == 1)) {
+		kvm->mmu_gpc_invalidate_range_start = range->start;
+		kvm->mmu_gpc_invalidate_range_end = range->end;
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
+			min(kvm->mmu_gpc_invalidate_range_start, range->start);
+		kvm->mmu_gpc_invalidate_range_end =
+			max(kvm->mmu_gpc_invalidate_range_end, range->end);
+	}
 	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
@@ -1164,6 +1182,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
+	kvm->mmu_gpc_invalidate_range_start = KVM_HVA_ERR_BAD;
+	kvm->mmu_gpc_invalidate_range_end = KVM_HVA_ERR_BAD;
 
 	INIT_LIST_HEAD(&kvm->devices);
 	kvm->max_vcpus = KVM_MAX_VCPUS;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 7007d32d197a..eeb9bf43c04a 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -129,32 +129,17 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
 
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
+static bool gpc_invalidations_pending(struct gfn_to_pfn_cache *gpc)
 {
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
+	 * No need for locking on GPC here because these fields are protected
+	 * by gpc->refresh_lock.
 	 */
-	if (kvm->mn_active_invalidate_count)
-		return true;
+	guard(spinlock)(&gpc->kvm->mn_invalidate_lock);
 
-	/*
-	 * Ensure mn_active_invalidate_count is read before
-	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
-	 * mmu_notifier_invalidate_range_end() to guarantee either the
-	 * old (non-zero) value of mn_active_invalidate_count or the
-	 * new (incremented) value of mmu_invalidate_seq is observed.
-	 */
-	smp_rmb();
-	return kvm->mmu_invalidate_seq != mmu_seq;
+	return unlikely(gpc->kvm->mn_active_invalidate_count) &&
+		(gpc->kvm->mmu_gpc_invalidate_range_start <= gpc->uhva) &&
+		(gpc->kvm->mmu_gpc_invalidate_range_end > gpc->uhva);
 }
 
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
@@ -163,7 +148,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
-	unsigned long mmu_seq;
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
@@ -177,9 +161,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	gpc->valid = false;
 
 	do {
-		mmu_seq = gpc->kvm->mmu_invalidate_seq;
-		smp_rmb();
-
 		/*
 		 * The translation made by hva_to_pfn() below could be made
 		 * invalid as soon as it's mapped. But the uhva is already
@@ -193,6 +174,29 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 		write_unlock_irq(&gpc->lock);
 
+		/*
+		 * Invalidation occurs from the invalidate_range_start() hook,
+		 * which could already have happened before __kvm_gpc_refresh()
+		 * (or the previous turn around this loop) took gpc->lock().
+		 * If so, and if the corresponding invalidate_range_end() hook
+		 * hasn't happened yet, hva_to_pfn() could return a mapping
+		 * which is about to be stale and which should not be used. So
+		 * check if there are any currently-running invalidations which
+		 * affect the uHVA of this GPC, and retry if there are. Any
+		 * invalidation which starts after gpc->needs_invalidation is
+		 * set is fine, because it will clear that flag and trigger a
+		 * retry. And any invalidation which *completes* by having its
+		 * invalidate_range_end() hook called immediately prior to this
+		 * check is also fine, because the page tables are guaranteed
+		 * to have been changted already, so hva_to_pfn() won't return
+		 * a stale mapping in that case anyway.
+		 */
+		while (gpc_invalidations_pending(gpc)) {
+			cond_resched();
+			write_lock_irq(&gpc->lock);
+			continue;
+		}
+
 		/*
 		 * If the previous iteration "failed" due to an mmu_notifier
 		 * event, release the pfn and unmap the kernel virtual address
@@ -233,6 +237,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			goto out_error;
 		}
 
+
 		write_lock_irq(&gpc->lock);
 
 		/*
@@ -240,8 +245,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (!gpc->needs_invalidation ||
-		 mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+	} while (!gpc->needs_invalidation);
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;
-- 
2.44.0


