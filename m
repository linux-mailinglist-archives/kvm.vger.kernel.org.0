Return-Path: <kvm+bounces-24796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E8295A5DB
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 22:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13DA7B238B6
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 20:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794F9178372;
	Wed, 21 Aug 2024 20:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P9ctFq+8"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50345170A07;
	Wed, 21 Aug 2024 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724272113; cv=none; b=rAslv3kNBIjQgTF6ScG9GTwwNlujZLEphdkiRMJi/iOeICl6Z+vx5K/fJ7LnP4Tm9Le7VM3ks4w28Cl6h/uxvseo7PBWZiidVU0Vu6L0Kf4kiqeaI5mY8K2DHVsaCyG4rXEKoRWzRYpioJdmg8ahk0cVka60NtE49Jx/kB+2Bio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724272113; c=relaxed/simple;
	bh=wYWWD6+yxfLHSKpGo2+kCsinNKAJCb8Mt6w4CQ/1j4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9KE6tdpSXTR1J/ps5txQvynHRolbkmxW5yO8ibmDhE1ZuT7nyWMfNKXlz35BGlTZ7hKSFEaGbQTePPnyYpXrIcNtwZxI3IAtUQtv3q0X6vbTyWVI3QudC4QedG+tZFdlpc8P9ThGz2A8TlXa04F3KizYk2X/r6UlKdrnklG61k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P9ctFq+8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IwCwivfLOtSd8/jjj4uzAk46k9+fMxFM3Fu0LYrRtOw=; b=P9ctFq+8xzH9oZuAU1UW84RGE2
	Ljd1YYbCde0pVIgGMW9iGL/VnriPCQhppzMRepx1pXx14dhI8p3+O/JZUpapi1BmHUiOgRXJ2D9Ky
	GZJxEA6LFFgURDlDIkpSk9HDJP9fl3YBL7Zf0FGsForMwXaSY4KxtUbCOvdAB9N3V+TDmcOY9/qEn
	9XcWBydBAv5wksivuGLC7L3hz0uV8frsXfihuy1mWdZukq76TLVTnoU+Z0YF6XVwhqwwSLepWxy1F
	vkoizkZVMdTDR8AnPSYfu1Lz8LDdlKR540k7qIRiqUBzUvgjDV5Tw49B0OCbAELWymrP3WKvYMmlP
	tONzmkXA==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwG-00000009hcp-1d0B;
	Wed, 21 Aug 2024 20:28:18 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sgrwE-00000002z8y-15Xg;
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
Subject: [PATCH v3 4/5] KVM: pfncache: Move invalidation to invalidate_range_end hook
Date: Wed, 21 Aug 2024 21:28:12 +0100
Message-ID: <20240821202814.711673-4-dwmw2@infradead.org>
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

By performing the invalidation from the 'end' hook, the process is a lot
cleaner and simpler because it is guaranteed that ->needs_invalidation
will be cleared after hva_to_pfn() has been called, so the only thing
that hva_to_pfn_retry() needs to do is *wait* for there to be no pending
invalidations.

Another false positive on the range based checks is thus removed as well.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 20 +++++++----------
 virt/kvm/kvm_mm.h   | 12 +++++-----
 virt/kvm/pfncache.c | 55 ++++++++++++++++++++-------------------------
 3 files changed, 38 insertions(+), 49 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e04eb700448b..cca870f1a78c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -795,18 +795,6 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	}
 	spin_unlock(&kvm->mn_invalidate_lock);
 
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
@@ -860,6 +848,14 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 
 	__kvm_handle_hva_range(kvm, &hva_range);
 
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
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01..34e4e67f09f8 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -24,13 +24,13 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 		     bool *async, bool write_fault, bool *writable);
 
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
index fa494eb3d924..3f48df8cd6e5 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -20,10 +20,15 @@
 #include "kvm_mm.h"
 
 /*
- * MMU notifier 'invalidate_range_start' hook.
+ * MMU notifier 'invalidate_range_end' hook. The hva_to_pfn_retry() function
+ * below may look up a PFN just before it is zapped, and may be mapping it
+ * concurrently with the actual invalidation (with the GPC lock dropped). By
+ * using a separate 'needs_invalidation' flag, the concurrent invalidation
+ * can handle this case, causing hva_to_pfn_retry() to drop its result and
+ * retry correctly.
  */
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
-				       unsigned long end)
+void gfn_to_pfn_cache_invalidate(struct kvm *kvm, unsigned long start,
+				 unsigned long end)
 {
 	struct gfn_to_pfn_cache *gpc;
 
@@ -140,15 +145,12 @@ static bool gpc_invalidations_pending(struct gfn_to_pfn_cache *gpc)
 		(gpc->kvm->mmu_gpc_invalidate_range_end > gpc->uhva);
 }
 
-static bool gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
+static void gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
 {
-	bool waited = false;
-
 	spin_lock(&gpc->kvm->mn_invalidate_lock);
 	if (gpc_invalidations_pending(gpc)) {
 		DEFINE_WAIT(wait);
 
-		waited = true;
 		for (;;) {
 			prepare_to_wait(&gpc->kvm->gpc_invalidate_wq, &wait,
 					TASK_UNINTERRUPTIBLE);
@@ -163,10 +165,8 @@ static bool gpc_wait_for_invalidations(struct gfn_to_pfn_cache *gpc)
 		finish_wait(&gpc->kvm->gpc_invalidate_wq, &wait);
 	}
 	spin_unlock(&gpc->kvm->mn_invalidate_lock);
-	return waited;
 }
 
-
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 {
 	/* Note, the new page offset may be different than the old! */
@@ -199,28 +199,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 		write_unlock_irq(&gpc->lock);
 
-		/*
-		 * Invalidation occurs from the invalidate_range_start() hook,
-		 * which could already have happened before __kvm_gpc_refresh()
-		 * (or the previous turn around this loop) took gpc->lock().
-		 * If so, and if the corresponding invalidate_range_end() hook
-		 * hasn't happened yet, hva_to_pfn() could return a mapping
-		 * which is about to be stale and which should not be used. So
-		 * check if there are any currently-running invalidations which
-		 * affect the uHVA of this GPC, and retry if there are. Any
-		 * invalidation which starts after gpc->needs_invalidation is
-		 * set is fine, because it will clear that flag and trigger a
-		 * retry. And any invalidation which *completes* by having its
-		 * invalidate_range_end() hook called immediately prior to this
-		 * check is also fine, because the page tables are guaranteed
-		 * to have been changted already, so hva_to_pfn() won't return
-		 * a stale mapping in that case anyway.
-		 */
-		if (gpc_wait_for_invalidations(gpc)) {
-			write_lock_irq(&gpc->lock);
-			continue;
-		}
-
 		/*
 		 * If the previous iteration "failed" due to an mmu_notifier
 		 * event, release the pfn and unmap the kernel virtual address
@@ -261,6 +239,14 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			goto out_error;
 		}
 
+		/*
+		 * Avoid populating a GPC with a user address which is already
+		 * being invalidated, if the invalidate_range_start() notifier
+		 * has already been called. The actual invalidation happens in
+		 * the invalidate_range_end() callback, so wait until there are
+		 * no active invalidations (for the relevant HVA).
+		 */
+		gpc_wait_for_invalidations(gpc);
 
 		write_lock_irq(&gpc->lock);
 
@@ -269,6 +255,13 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
+
+		/*
+		 * Since gfn_to_pfn_cache_invalidate() is called from the
+		 * kvm_mmu_notifier_invalidate_range_end() callback, it can
+		 * invalidate the GPC the moment after hva_to_pfn() returned
+		 * a valid PFN. If that happens, retry.
+		 */
 	} while (!gpc->needs_invalidation);
 
 	gpc->valid = true;
-- 
2.44.0


