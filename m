Return-Path: <kvm+bounces-10080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC03B869040
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4917B1F21D56
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33C461419AE;
	Tue, 27 Feb 2024 12:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LAR7DTqR"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB4413DB98
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709036354; cv=none; b=Q4YXEWpZWdHpv+Fz0xSe0pNeRtzdyx4CqwpVU9oe3Wc1FqrfzeshAhBF2/guPDP6jYMNfGHP1LPZQNc3ZtjEVz4NvSZoKHmJ4pmorAgIv1ir4t2+4dtXX5UGJQjO92PW65pJYYPhogSr2VeNAdpzPhXl88x86Wbb9iibHSdsJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709036354; c=relaxed/simple;
	bh=JdLdjKdeWJ/v3poqH3I1m+C59KUbgVnPN3X4XvpuXQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gSXcDiqCRnMr8/mL11Z83CqCiyN10nPEYO9TJT4mgww8x2CQ7rIHZeb/E69sB4Axyf1mVRysQYfBjchiMcvCK9/7yKNQf8MK857YueRb9sEIUA+FSf5H3W2zWNry8GEs+fCxxk9VCkN/bvKSgQ4VE0URbFRSn8JcjSoF4n/LoJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LAR7DTqR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:
	To:From:Reply-To:Content-ID:Content-Description;
	bh=JrfhJQKKvER1SAmrcpc32RKPuhi6mMRmZRONaHwzFYA=; b=LAR7DTqRGOEqUeLzZDA980FpA5
	YXSVpDZi9g1e6vGp8znInkJYo1vhAD114ZOFkCZjMuNZwSZYPwHKq0tf6puVFtZ4voUp26kR5Q8TY
	Cu5vtiiRZVOM82fmcPnhCoEXSgyv17cGWtts+zH5psQAWPlRf5areHbdI69MPQvTuTKVrmTqbGar+
	0+XcDgj+X+PJ/58hsqSJSy162YRyGUQU23Fstw+nktTcN6khajBwvKWmNv3XxkBlEHdDMtZpzF5cG
	vxgaCdbJQA7xdffIXHd6Plh+J4a55T7ZRRJdggKLzbvbnN8yE0TZ+zloQVwTy5UGvOEX39ei6IXQ/
	OwvMX5lw==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4p-00000002JfP-3FY9;
	Tue, 27 Feb 2024 11:56:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4o-000000000wk-0iNb;
	Tue, 27 Feb 2024 11:56:50 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <pdurrant@amazon.com>
Subject: [PATCH v2 8/8] KVM: pfncache: clean up rwlock abuse
Date: Tue, 27 Feb 2024 11:49:22 +0000
Message-ID: <20240227115648.3104-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: David Woodhouse <dwmw@amazon.co.uk>

There is a rwlock in ->lock which readers take to ensure protection
against concurrent changes. But __kvm_gpc_refresh() makes assumptions
that certain fields will not change even while it drops the write lock
and performs MM operations to revalidate the target PFN and kernel
mapping.

Those assumptions *are* valid, because a previous commit expanded the
coverage of the ->refresh_lock mutex to ensure serialization and that
nothing else can change those fields while __kvm_gpc_refresh() drops
the rwlock. But this is not good practice.

Clean up the semantics of hva_to_pfn_retry() so that it no longer does
any locking gymnastics because it no longer operates on the gpc object
at all. It is now called with a uhva and simply returns the
corresponding pfn (pinned), and a mapped khva for it.

Its caller __kvm_gpc_refresh() now sets gpc->uhva and clears gpc->valid
before dropping ->lock, calling hva_to_pfn_retry() and retaking ->lock
for write.

If hva_to_pfn_retry() fails, *or* if the ->uhva or ->active fields in
the gpc changed while the lock was dropped, the new mapping is discarded
and the gpc is not modified. On success with an unchanged gpc, the new
mapping is installed and the current ->pfn and ->uhva are taken into the
local old_pfn and old_khva variables to be unmapped once the locks are
all released.

This simplification means that ->refresh_lock is no longer needed for
correctness, but it does still provide a minor optimisation because it
will prevent two concurrent __kvm_gpc_refresh() calls from mapping a
given PFN, only for one of them to lose the race and discard its
mapping.

The optimisation in hva_to_pfn_retry() where it attempts to use the old
mapping if the pfn doesn't change is dropped, since it makes the pinning
more complex. It's a pointless optimisation anyway, since the odds of
the pfn ending up the same when the uhva has changed (i.e. the odds of
the two userspace addresses both pointing to the same underlying
physical page) are negligible,

The 'hva_changed' local variable in __kvm_gpc_refresh() is also removed,
since it's simpler just to clear gpc->valid if the uhva changed.
Likewise the unmap_old variable is dropped because it's just as easy to
check the old_pfn variable for KVM_PFN_ERR_FAULT.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/pfncache.c | 182 +++++++++++++++++++++-----------------------
 1 file changed, 87 insertions(+), 95 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 43d67f8f064e..f47c1fc44f58 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -139,107 +139,65 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	return kvm->mmu_invalidate_seq != mmu_seq;
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
+/*
+ * Given a user virtual address, obtain a pinned host PFN and kernel mapping
+ * for it. The caller will release the PFN after installing it into the GPC
+ * so that the MMU notifier invalidation mechanism is active.
+ */
+static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva,
+				  kvm_pfn_t *pfn, void **khva)
 {
 	/* Note, the new page offset may be different than the old! */
-	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
 	unsigned long mmu_seq;
 
-	lockdep_assert_held(&gpc->refresh_lock);
-
-	lockdep_assert_held_write(&gpc->lock);
-
-	/*
-	 * Invalidate the cache prior to dropping gpc->lock, the gpa=>uhva
-	 * assets have already been updated and so a concurrent check() from a
-	 * different task may not fail the gpa/uhva/generation checks.
-	 */
-	gpc->valid = false;
-
-	do {
-		mmu_seq = gpc->kvm->mmu_invalidate_seq;
+	for (;;) {
+		mmu_seq = kvm->mmu_invalidate_seq;
 		smp_rmb();
 
-		write_unlock_irq(&gpc->lock);
-
-		/*
-		 * If the previous iteration "failed" due to an mmu_notifier
-		 * event, release the pfn and unmap the kernel virtual address
-		 * from the previous attempt.  Unmapping might sleep, so this
-		 * needs to be done after dropping the lock.  Opportunistically
-		 * check for resched while the lock isn't held.
-		 */
-		if (new_pfn != KVM_PFN_ERR_FAULT) {
-			/*
-			 * Keep the mapping if the previous iteration reused
-			 * the existing mapping and didn't create a new one.
-			 */
-			if (new_khva != old_khva)
-				gpc_unmap(new_pfn, new_khva);
-
-			kvm_release_pfn_clean(new_pfn);
-
-			cond_resched();
-		}
-
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(gpc->uhva, false, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(uhva, false, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
-			goto out_error;
+			return -EFAULT;
 
 		/*
-		 * Obtain a new kernel mapping if KVM itself will access the
-		 * pfn.  Note, kmap() and memremap() can both sleep, so this
-		 * too must be done outside of gpc->lock!
+		 * Always obtain a new kernel mapping. Trying to reuse an
+		 * existing one is more complex than it's worth.
 		 */
-		if (new_pfn == gpc->pfn)
-			new_khva = old_khva;
-		else
-			new_khva = gpc_map(new_pfn);
-
+		new_khva = gpc_map(new_pfn);
 		if (!new_khva) {
 			kvm_release_pfn_clean(new_pfn);
-			goto out_error;
+			return -EFAULT;
 		}
 
-		write_lock_irq(&gpc->lock);
+		if (!mmu_notifier_retry_cache(kvm, mmu_seq))
+			break;
 
 		/*
-		 * Other tasks must wait for _this_ refresh to complete before
-		 * attempting to refresh.
+		 * If this iteration "failed" due to an mmu_notifier event,
+		 * release the pfn and unmap the kernel virtual address, and
+		 * loop around again.
 		 */
-		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
-
-	gpc->valid = true;
-	gpc->pfn = new_pfn;
-	gpc->khva = new_khva + offset_in_page(gpc->uhva);
+		if (new_pfn != KVM_PFN_ERR_FAULT) {
+			gpc_unmap(new_pfn, new_khva);
+			kvm_release_pfn_clean(new_pfn);
+		}
+	}
 
-	/*
-	 * Put the reference to the _new_ pfn.  The pfn is now tracked by the
-	 * cache and can be safely migrated, swapped, etc... as the cache will
-	 * invalidate any mappings in response to relevant mmu_notifier events.
-	 */
-	kvm_release_pfn_clean(new_pfn);
+	*pfn = new_pfn;
+	*khva = new_khva;
 
 	return 0;
-
-out_error:
-	write_lock_irq(&gpc->lock);
-
-	return -EFAULT;
 }
 
-static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long uhva,
-			     unsigned long len)
+static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa,
+			     unsigned long uhva, unsigned long len)
 {
-	unsigned long page_offset;
-	bool unmap_old = false;
+	unsigned long page_offset = kvm_is_error_gpa(gpa) ?
+		offset_in_page(uhva) : offset_in_page(gpa);
 	unsigned long old_uhva;
-	kvm_pfn_t old_pfn;
-	bool hva_change = false;
+	kvm_pfn_t old_pfn = KVM_PFN_ERR_FAULT;
 	void *old_khva;
 	int ret;
 
@@ -275,7 +233,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 		gpc->uhva = PAGE_ALIGN_DOWN(uhva);
 
 		if (gpc->uhva != old_uhva)
-			hva_change = true;
+			gpc->valid = false;
 	} else {
 		struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
@@ -290,7 +248,11 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 
 			if (kvm_is_error_hva(gpc->uhva)) {
 				ret = -EFAULT;
-				goto out;
+
+				gpc->valid = false;
+				gpc->pfn = KVM_PFN_ERR_FAULT;
+				gpc->khva = NULL;
+				goto out_unlock;
 			}
 
 			/*
@@ -298,7 +260,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 			 * HVA may still be the same.
 			 */
 			if (gpc->uhva != old_uhva)
-				hva_change = true;
+				gpc->valid = false;
 		} else {
 			gpc->uhva = old_uhva;
 		}
@@ -311,9 +273,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	 * If the userspace HVA changed or the PFN was already invalid,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
-	if (!gpc->valid || hva_change) {
-		ret = hva_to_pfn_retry(gpc);
-	} else {
+	if (gpc->valid) {
 		/*
 		 * If the HVA→PFN mapping was already valid, don't unmap it.
 		 * But do update gpc->khva because the offset within the page
@@ -321,28 +281,60 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 		 */
 		gpc->khva = old_khva + page_offset;
 		ret = 0;
-		goto out_unlock;
-	}
 
- out:
-	/*
-	 * Invalidate the cache and purge the pfn/khva if the refresh failed.
-	 * Some/all of the uhva, gpa, and memslot generation info may still be
-	 * valid, leave it as is.
-	 */
-	if (ret) {
+		/* old_pfn must not be unmapped because it was reused. */
+		old_pfn = KVM_PFN_ERR_FAULT;
+	} else {
+		kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
+		unsigned long new_uhva = gpc->uhva;
+		void *new_khva = NULL;
+
+		/*
+		 * Invalidate the cache prior to dropping gpc->lock; the
+		 * gpa=>uhva assets have already been updated and so a
+		 * concurrent check() from a different task may not fail
+		 * the gpa/uhva/generation checks as it should.
+		 */
 		gpc->valid = false;
-		gpc->pfn = KVM_PFN_ERR_FAULT;
-		gpc->khva = NULL;
-	}
 
-	/* Detect a pfn change before dropping the lock! */
-	unmap_old = (old_pfn != gpc->pfn);
+		write_unlock_irq(&gpc->lock);
+
+		ret = hva_to_pfn_retry(gpc->kvm, new_uhva, &new_pfn, &new_khva);
+
+		write_lock_irq(&gpc->lock);
+
+		WARN_ON_ONCE(gpc->valid);
+
+		if (ret || !gpc->active || gpc->uhva != new_uhva) {
+			/*
+			 * On failure or if another change occurred while the
+			 * lock was dropped, just purge the new mapping.
+			 */
+			old_pfn = new_pfn;
+			old_khva = new_khva;
+		} else {
+			old_pfn = gpc->pfn;
+			old_khva = gpc->khva;
+
+			gpc->pfn = new_pfn;
+			gpc->khva = new_khva + offset_in_page(gpc->uhva);
+			gpc->valid = true;
+		}
+
+		/*
+		 * Put the reference to the _new_ pfn. On success, the
+		 * pfn is now tracked by the cache and can safely be
+		 * migrated, swapped, etc. as the cache will invalidate
+		 * any mappings in response to relevant mmu_notifier
+		 * events.
+		 */
+		kvm_release_pfn_clean(new_pfn);
+	}
 
 out_unlock:
 	write_unlock_irq(&gpc->lock);
 
-	if (unmap_old)
+	if (old_pfn != KVM_PFN_ERR_FAULT)
 		gpc_unmap(old_pfn, old_khva);
 
 	return ret;
-- 
2.43.0


