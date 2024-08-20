Return-Path: <kvm+bounces-24665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A5308958F35
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 22:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 310BC1F22FE2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 20:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195F41C461C;
	Tue, 20 Aug 2024 20:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WWShBPYN"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456A51B86F8;
	Tue, 20 Aug 2024 20:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724186116; cv=none; b=QDbfaN5CNoClkujw1OIuaKin3PjV/w+Y9KqhgM7yf/dSCXUeRlqVoBwvcbQTfzE6beS56aIUrzGCxa3mo4UZ+vY/3/jOdncjYwO4RGMHjfNCt5ywGwlUMeRYrCzrmYBx5fD/dTVsMMoC7UKqeuMrSIDXr4FTtI0dfIEHdFMSH/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724186116; c=relaxed/simple;
	bh=MGMA81T4YmzbdFsPkaV1PkSIDiQ4tVixnTrVYvOJU8w=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=oybKLeAN57T9TnMhMs4ajmL1rPg17mjULbBorEwEOv5tTRLfp00mLxF0CF3dlPCdMADj25UQVSYPy1ZbjYEDHHIQdubdia4gqF5JBxkwCd++FVAd1IJsBzc4xip8bgOMX2qSq7OpxgpzsvWSMxTqjOVwVXtzV3kjyD90vt3/KUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WWShBPYN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:Date:Cc:To:
	From:Subject:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=0SWc1274y6UTZON/gZ6tkr7X/lABDMbH36NdjKzAmbQ=; b=WWShBPYNI28846OtngOSpWpHXI
	406VYBLMCorJLAnR/QeIKAH1myLnvBB/SxJGoucpPZnjegWWExpZ+b+XjGGMBudzwRH3PQWoVTlUQ
	3GrLnrUbV8hH/u/YC+dYzOcbZPicrElB2FyTpK/SphvptqhyZajJEgmlFmUGjontHETQgYCpbRqCA
	bLiB27M72Q4U0DnEx82jTLXH6PcgVAx6jZhuXSQyI76UwcodUFAl2sndoiGeNCQn/DeoigP5KhBJJ
	eU4AC6YHyCTuYA3ge0jIfSpiBRGz5rR8/nqh1ThE1sft+shGI1DqknIg8j9bZQqBpYeNfOP+QFWcB
	+Rnarbrw==;
Received: from [2001:8b0:10b:5:cb53:8564:1f06:36f6] (helo=u3832b3a9db3152.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgVZD-00000008NiV-0W9p;
	Tue, 20 Aug 2024 20:34:59 +0000
Message-ID: <04f67b56610fc0122f44468d6c330eede67b54d9.camel@infradead.org>
Subject: [PATCH v2] KVM: Move gfn_to_pfn_cache invalidation to
 invalidate_range_end hook
From: David Woodhouse <dwmw2@infradead.org>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>,  "Hussain, Mushahid" <hmushi@amazon.co.uk>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li
 <wanpengli@tencent.com>,  Jim Mattson <jmattson@google.com>, Joerg Roedel
 <joro@8bytes.org>, kvm@vger.kernel.org,  linux-kernel@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Date: Tue, 20 Aug 2024 21:34:58 +0100
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-eQauqdbr86jGHD3EBdgN"
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-eQauqdbr86jGHD3EBdgN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

The existing retry loop in hva_to_pfn_retry() is extremely pessimistic.
If there are any concurrent invalidations running, it's effectively just
a complex busy wait loop because its local mmu_notifier_retry_cache()
function will always return true.

Since multiple invalidations can be running in parallel, this can result
in a situation where hva_to_pfn_retry() just backs off and keep retrying
for ever, not making any progress.

Solve this by being a bit more selective about when to retry.

Introduce a separate 'needs invalidation' flag to the GPC, which allows
it to be marked invalid even while hva_to_pfn_retry() has dropped the
lock to map the newly-found PFN. This allows the invalidation to moved
to the range_end hook, and the retry loop only occurs for a given GPC if
its particular uHVA is affected.

However, the contract for invalidate_range_{start,end} is not like a
simple TLB; the pages may have been freed by the time the end hook is
called. A "device" may not create new mappings after the _start_ hook is
called. To meet this requirement, hva_to_pfn_retry() now waits until no
invalidations are currently running which may affect its uHVA, before
finally setting the ->valid flag and returning.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
v2:=20
 =E2=80=A2 Do not mark the nascent cache as valid until there are no pendin=
g
   invalidations which could affect it.

Tested with Sean's torture test, forward ported and in the tip of the
tree at
https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dshortlog;h=3Drefs/=
heads/pfncache-2

 include/linux/kvm_host.h  |   3 ++
 include/linux/kvm_types.h |   1 +
 virt/kvm/kvm_main.c       |  54 +++++++++++++------
 virt/kvm/kvm_mm.h         |  12 ++---
 virt/kvm/pfncache.c       | 106 ++++++++++++++++++++++++++------------
 5 files changed, 122 insertions(+), 54 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 79a6b1a63027..a0739c343da5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -770,6 +770,9 @@ struct kvm {
 	/* For management / invalidation of gfn_to_pfn_caches */
 	spinlock_t gpc_lock;
 	struct list_head gpc_list;
+	u64 mmu_gpc_invalidate_range_start;
+	u64 mmu_gpc_invalidate_range_end;
+	wait_queue_head_t gpc_invalidate_wq;
=20
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 827ecc0b7e10..4d8fbd87c320 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -69,6 +69,7 @@ struct gfn_to_pfn_cache {
 	void *khva;
 	kvm_pfn_t pfn;
 	bool active;
+	bool needs_invalidation;
 	bool valid;
 };
=20
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 92901656a0d4..01cde6284180 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -775,20 +775,26 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
 	 */
 	spin_lock(&kvm->mn_invalidate_lock);
 	kvm->mn_active_invalidate_count++;
+	if (likely(kvm->mn_active_invalidate_count =3D=3D 1)) {
+		kvm->mmu_gpc_invalidate_range_start =3D range->start;
+		kvm->mmu_gpc_invalidate_range_end =3D range->end;
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
+		kvm->mmu_gpc_invalidate_range_start =3D
+			min(kvm->mmu_gpc_invalidate_range_start, range->start);
+		kvm->mmu_gpc_invalidate_range_end =3D
+			max(kvm->mmu_gpc_invalidate_range_end, range->end);
+	}
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
-	/*
-	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
-	 * before acquiring mmu_lock, to avoid holding mmu_lock while acquiring
-	 * each cache's lock.  There are relatively few caches in existence at
-	 * any given time, and the caches themselves can check for hva overlap,
-	 * i.e. don't need to rely on memslot overlap checks for performance.
-	 * Because this runs without holding mmu_lock, the pfn caches must use
-	 * mn_active_invalidate_count (see above) instead of
-	 * mmu_invalidate_in_progress.
-	 */
-	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
-
 	/*
 	 * If one or more memslots were found and thus zapped, notify arch code
 	 * that guest memory has been reclaimed.  This needs to be done *after*
@@ -842,19 +848,33 @@ static void kvm_mmu_notifier_invalidate_range_end(str=
uct mmu_notifier *mn,
=20
 	__kvm_handle_hva_range(kvm, &hva_range);
=20
+	/*
+	 * It's safe to invalidate the gfn_to_pfn_caches from this 'end'
+	 * hook, because hva_to_pfn_retry() will wait until no active
+	 * invalidations could be affecting the corresponding uHVA
+	 * before before allowing a newly mapped GPC to become valid.
+	 */
+	gfn_to_pfn_cache_invalidate(kvm, range->start, range->end);
+
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
 	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
 		--kvm->mn_active_invalidate_count;
 	wake =3D !kvm->mn_active_invalidate_count;
+	if (wake) {
+		kvm->mmu_gpc_invalidate_range_start =3D KVM_HVA_ERR_BAD;
+		kvm->mmu_gpc_invalidate_range_end =3D KVM_HVA_ERR_BAD;
+	}
 	spin_unlock(&kvm->mn_invalidate_lock);
=20
 	/*
 	 * There can only be one waiter, since the wait happens under
 	 * slots_lock.
 	 */
-	if (wake)
+	if (wake) {
+		wake_up(&kvm->gpc_invalidate_wq);
 		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+	}
 }
=20
 static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
@@ -1164,7 +1184,9 @@ static struct kvm *kvm_create_vm(unsigned long type, =
const char *fdname)
=20
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
-
+	init_waitqueue_head(&kvm->gpc_invalidate_wq);
+	kvm->mmu_gpc_invalidate_range_start =3D KVM_HVA_ERR_BAD;
+	kvm->mmu_gpc_invalidate_range_end =3D KVM_HVA_ERR_BAD;
 	INIT_LIST_HEAD(&kvm->devices);
 	kvm->max_vcpus =3D KVM_MAX_VCPUS;
=20
@@ -1340,8 +1362,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	 * in-progress invalidations.
 	 */
 	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
-	if (kvm->mn_active_invalidate_count)
+	if (kvm->mn_active_invalidate_count) {
 		kvm->mn_active_invalidate_count =3D 0;
+		wake_up(&kvm->gpc_invalidate_wq);
+	}
 	else
 		WARN_ON(kvm->mmu_invalidate_in_progress);
 #else
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..34e4e67f09f8 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -24,13 +24,13 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, b=
ool interruptible,
 		     bool *async, bool write_fault, bool *writable);
=20
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
-				       unsigned long start,
-				       unsigned long end);
+void gfn_to_pfn_cache_invalidate(struct kvm *kvm,
+				 unsigned long start,
+				 unsigned long end);
 #else
-static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
-						     unsigned long start,
-						     unsigned long end)
+static inline void gfn_to_pfn_cache_invalidate(struct kvm *kvm,
+					       unsigned long start,
+					       unsigned long end)
 {
 }
 #endif /* HAVE_KVM_PFNCACHE */
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e..3f48df8cd6e5 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -20,10 +20,15 @@
 #include "kvm_mm.h"
=20
 /*
- * MMU notifier 'invalidate_range_start' hook.
+ * MMU notifier 'invalidate_range_end' hook. The hva_to_pfn_retry() functi=
on
+ * below may look up a PFN just before it is zapped, and may be mapping it
+ * concurrently with the actual invalidation (with the GPC lock dropped). =
By
+ * using a separate 'needs_invalidation' flag, the concurrent invalidation
+ * can handle this case, causing hva_to_pfn_retry() to drop its result and
+ * retry correctly.
  */
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long star=
t,
-				       unsigned long end)
+void gfn_to_pfn_cache_invalidate(struct kvm *kvm, unsigned long start,
+				 unsigned long end)
 {
 	struct gfn_to_pfn_cache *gpc;
=20
@@ -32,7 +37,7 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, u=
nsigned long start,
 		read_lock_irq(&gpc->lock);
=20
 		/* Only a single page so no need to care about length */
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		if (gpc->needs_invalidation && !is_error_noslot_pfn(gpc->pfn) &&
 		    gpc->uhva >=3D start && gpc->uhva < end) {
 			read_unlock_irq(&gpc->lock);
=20
@@ -45,9 +50,11 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, =
unsigned long start,
 			 */
=20
 			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >=3D start && gpc->uhva < end)
+			if (gpc->needs_invalidation && !is_error_noslot_pfn(gpc->pfn) &&
+			    gpc->uhva >=3D start && gpc->uhva < end) {
+				gpc->needs_invalidation =3D false;
 				gpc->valid =3D false;
+			}
 			write_unlock_irq(&gpc->lock);
 			continue;
 		}
@@ -93,6 +100,9 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigne=
d long len)
 	if (!gpc->valid)
 		return false;
=20
+	/* If it's valid, it needs invalidation! */
+	WARN_ON_ONCE(!gpc->needs_invalidation);
+
 	return true;
 }
=20
@@ -124,32 +134,37 @@ static void gpc_unmap(kvm_pfn_t pfn, void *khva)
 #endif
 }
=20
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long=
 mmu_seq)
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
+	return unlikely(gpc->kvm->mn_active_invalidate_count) &&
+		(gpc->kvm->mmu_gpc_invalidate_range_start <=3D gpc->uhva) &&
+		(gpc->kvm->mmu_gpc_invalidate_range_end > gpc->uhva);
+}
=20
-	/*
-	 * Ensure mn_active_invalidate_count is read before
-	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
-	 * mmu_notifier_invalidate_range_end() to guarantee either the
-	 * old (non-zero) value of mn_active_invalidate_count or the
-	 * new (incremented) value of mmu_invalidate_seq is observed.
-	 */
-	smp_rmb();
-	return kvm->mmu_invalidate_seq !=3D mmu_seq;
+static void gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
+{
+	spin_lock(&gpc->kvm->mn_invalidate_lock);
+	if (gpc_invalidations_pending(gpc)) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&gpc->kvm->gpc_invalidate_wq, &wait,
+					TASK_UNINTERRUPTIBLE);
+
+			if (!gpc_invalidations_pending(gpc))
+				break;
+
+			spin_unlock(&gpc->kvm->mn_invalidate_lock);
+			schedule();
+			spin_lock(&gpc->kvm->mn_invalidate_lock);
+		}
+		finish_wait(&gpc->kvm->gpc_invalidate_wq, &wait);
+	}
+	spin_unlock(&gpc->kvm->mn_invalidate_lock);
 }
=20
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
@@ -158,7 +173,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cac=
he *gpc)
 	void *old_khva =3D (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn =3D KVM_PFN_ERR_FAULT;
 	void *new_khva =3D NULL;
-	unsigned long mmu_seq;
=20
 	lockdep_assert_held(&gpc->refresh_lock);
=20
@@ -172,8 +186,16 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 	gpc->valid =3D false;
=20
 	do {
-		mmu_seq =3D gpc->kvm->mmu_invalidate_seq;
-		smp_rmb();
+		/*
+		 * The translation made by hva_to_pfn() below could be made
+		 * invalid as soon as it's mapped. But the uhva is already
+		 * known and that's all that gfn_to_pfn_cache_invalidate()
+		 * looks at. So set the 'needs_invalidation' flag to allow
+		 * the GPC to be marked invalid from the moment the lock is
+		 * dropped, before the corresponding PFN is even found (and,
+		 * more to the point, immediately afterwards).
+		 */
+		gpc->needs_invalidation =3D true;
=20
 		write_unlock_irq(&gpc->lock);
=20
@@ -217,6 +239,15 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 			goto out_error;
 		}
=20
+		/*
+		 * Avoid populating a GPC with a user address which is already
+		 * being invalidated, if the invalidate_range_start() notifier
+		 * has already been called. The actual invalidation happens in
+		 * the invalidate_range_end() callback, so wait until there are
+		 * no active invalidations (for the relevant HVA).
+		 */
+		gpc_wait_for_invalidations(gpc);
+
 		write_lock_irq(&gpc->lock);
=20
 		/*
@@ -224,7 +255,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_ca=
che *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+
+		/*
+		 * Since gfn_to_pfn_cache_invalidate() is called from the
+		 * kvm_mmu_notifier_invalidate_range_end() callback, it can
+		 * invalidate the GPC the moment after hva_to_pfn() returned
+		 * a valid PFN. If that happens, retry.
+		 */
+	} while (!gpc->needs_invalidation);
=20
 	gpc->valid =3D true;
 	gpc->pfn =3D new_pfn;
@@ -339,6 +377,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *g=
pc, gpa_t gpa, unsigned l
 	 */
 	if (ret) {
 		gpc->valid =3D false;
+		gpc->needs_invalidation =3D false;
 		gpc->pfn =3D KVM_PFN_ERR_FAULT;
 		gpc->khva =3D NULL;
 	}
@@ -383,7 +422,7 @@ void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct =
kvm *kvm)
 	gpc->pfn =3D KVM_PFN_ERR_FAULT;
 	gpc->gpa =3D INVALID_GPA;
 	gpc->uhva =3D KVM_HVA_ERR_BAD;
-	gpc->active =3D gpc->valid =3D false;
+	gpc->active =3D gpc->valid =3D gpc->needs_invalidation =3D false;
 }
=20
 static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, uns=
igned long uhva,
@@ -453,6 +492,7 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 		write_lock_irq(&gpc->lock);
 		gpc->active =3D false;
 		gpc->valid =3D false;
+		gpc->needs_invalidation =3D false;
=20
 		/*
 		 * Leave the GPA =3D> uHVA cache intact, it's protected by the
--=20
2.44.0



--=-eQauqdbr86jGHD3EBdgN
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkQw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhQwggT8oAMCAQICEQDGvhmWZ0DEAx0oURL6O6l+MA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9y
ZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3GpC2bomUqk+91wLYBzDMcCj5C9m6
oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZHh7htyAkWYVoFsFPrwHounto8xTsy
SSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT9YgcBqKCo65pTFmOnR/VVbjJk4K2
xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNjP+qDrh0db7PAjO1D4d5ftfrsf+kd
RR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy2U+eITZ5LLE5s45mX2oPFknWqxBo
bQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3BgBEmfsYWlBXO8rVXfvPgLs32VdV
NZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/7auNVRmPB3v5SWEsH8xi4Bez2V9U
KxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmdlFYhAflWKQ03Ufiu8t3iBE3VJbc2
5oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9aelIl6vtbhMA+l0nfrsORMa4kobqQ5
C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMBAAGjggHMMIIByDAfBgNVHSMEGDAW
gBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeDMcimo0oz8o1R1Nver3ZVpSkwDgYD
VR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEWF2h0dHBzOi8vc2VjdGln
by5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2VjdGln
b1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUFBwEB
BH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xpZW50
QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5mcmFkZWFkLm9yZzANBgkqhkiG9w0B
AQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQvQ/fzPXmtR9t54rpmI2TfyvcKgOXp
qa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvIlSPrzIB4Z2wyIGQpaPLlYflrrVFK
v9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9ChWFfgSXvrWDZspnU3Gjw/rMHrGnql
Htlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0whpBtXdyDjzBtQTaZJ7zTT/vlehc/
tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9IzCCBhQwggT8oAMCAQICEQDGvhmW
Z0DEAx0oURL6O6l+MA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTIyMDEwNzAwMDAwMFoXDTI1MDEwNjIzNTk1OVowJDEiMCAGCSqGSIb3DQEJ
ARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALQ3
GpC2bomUqk+91wLYBzDMcCj5C9m6oZaHwvmIdXftOgTbCJXADo6G9T7BBAebw2JV38EINgKpy/ZH
h7htyAkWYVoFsFPrwHounto8xTsySSePMiPlmIdQ10BcVSXMUJ3Juu16GlWOnAMJY2oYfEzmE7uT
9YgcBqKCo65pTFmOnR/VVbjJk4K2xE34GC2nAdUQkPFuyaFisicc6HRMOYXPuF0DuwITEKnjxgNj
P+qDrh0db7PAjO1D4d5ftfrsf+kdRR4gKVGSk8Tz2WwvtLAroJM4nXjNPIBJNT4w/FWWc/5qPHJy
2U+eITZ5LLE5s45mX2oPFknWqxBobQZ8a9dsZ3dSPZBvE9ZrmtFLrVrN4eo1jsXgAp1+p7bkfqd3
BgBEmfsYWlBXO8rVXfvPgLs32VdVNZxb/CDWPqBsiYv0Hv3HPsz07j5b+/cVoWqyHDKzkaVbxfq/
7auNVRmPB3v5SWEsH8xi4Bez2V9UKxfYCnqsjp8RaC2/khxKt0A552Eaxnz/4ly/2C7wkwTQnBmd
lFYhAflWKQ03Ufiu8t3iBE3VJbc25oMrglj7TRZrmKq3CkbFnX0fyulB+kHimrt6PIWn7kgyl9ae
lIl6vtbhMA+l0nfrsORMa4kobqQ5C5rveVgmcIad67EDa+UqEKy/GltUwlSh6xy+TrK1tzDvAgMB
AAGjggHMMIIByDAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUzMeD
Mcimo0oz8o1R1Nver3ZVpSkwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYB
BQUHAgEWF2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9j
cmwuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1h
aWxDQS5jcmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdv
LmNvbS9TZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAj
BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAyW6MUir5dm495teKqAQjDJwuFCi35h4xgnQv
Q/fzPXmtR9t54rpmI2TfyvcKgOXpqa7BGXNFfh1JsqexVkIqZP9uWB2J+uVMD+XZEs/KYNNX2PvI
lSPrzIB4Z2wyIGQpaPLlYflrrVFKv9CjT2zdqvy2maK7HKOQRt3BiJbVG5lRiwbbygldcALEV9Ch
WFfgSXvrWDZspnU3Gjw/rMHrGnqlHtlyebp3pf3fSS9kzQ1FVtVIDrL6eqhTwJxe+pXSMMqFiN0w
hpBtXdyDjzBtQTaZJ7zTT/vlehc/tDuqZwGHm/YJy883Ll+GP3NvOkgaRGWEuYWJJ6hFCkXYjyR9
IzGCBMcwggTDAgEBMIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVz
dGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMT
NVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA
xr4ZlmdAxAMdKFES+jupfjANBglghkgBZQMEAgEFAKCCAeswGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMjQwODIwMjAzNDU4WjAvBgkqhkiG9w0BCQQxIgQg9FWh/bf5
9CcoAIFWikPCi58/ogYvfnvrEMkaLz0p+X0wgb0GCSsGAQQBgjcQBDGBrzCBrDCBljELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEYMBYG
A1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0aGVu
dGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAMa+GZZnQMQDHShREvo7qX4wgb8GCyqGSIb3
DQEJEAILMYGvoIGsMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEAxr4Z
lmdAxAMdKFES+jupfjANBgkqhkiG9w0BAQEFAASCAgCpsuphW4qQpjZ6YkWEmhoR/Y3IGJcYAWVA
/b8y3WocIJ9UN9RUmYNOmVzxr7OJcpmCiG9ELQwCBxQd2M569nrjHH8wavyC2WeV26lShNYH042Z
Akm58G5HIIsxuc4syCNFYKlYuQhYug8jk90S3Xwic/7ODpTY8JFY5Jt5DbFsu6y1aoxBkAl11hSx
BecMHAhAs1GaemyJd/djKMaWeHvheDGsAVa/pXsrKNv4DBIbT9YsRDAQSICW2npV322m8ApaNNd3
ADtX98jDmDYzloZr6nrtC5QflVdR1wqTdBRu3TyBjzGLzKvj/fwBx8w8lrQxfBfcuQC13uEl2Jlc
eHyyXQUPbOUIrFtk0Nqg0sILGLBRQUHX5xEEN+JQ6VOTvqozk0NW1NvuQvuoof3hzfv8QIc/GPtu
asJ23bI2oFqtSCSge2GP0Skf0fP91Ei/d3j7DoxjNEI1B3aaqjclpMK48177vYzCJPnH0WPHUD7Q
GXbK+y6kZsYfDCSs+t+KnSg0B7pW6Czp1wB+w7n48T6XDi9IgwD2bJZ2+kgceVoiAdE4e7Le3lUe
Tb0BXTRmD9LP1V/++/0VHe76m3oVAyu94k6Hl1eaTbpUnvLBXjikWs3I3JFzYmhO/IrBOHad+grl
LJ+ZoYt/PZFK6x+22ce+zSIeE347LgPiEX4jBLJ9vwAAAAAAAA==


--=-eQauqdbr86jGHD3EBdgN--

