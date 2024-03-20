Return-Path: <kvm+bounces-12203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DC138808BD
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 01:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0DFE1F22BEC
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C92D64C7E;
	Wed, 20 Mar 2024 00:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WttWwMgx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28476BA45
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710895843; cv=none; b=mhygpvLWwh3FKypKFsD6cHeJZ7NDLh+QkRinFTxYfhD5+6hbXqwkZveL/3iscp4VFHHDcgn63y48qqymTcO+V/o2WwF/OAWlyxUgXWb30VGgPnv44r4G6ZyWNFAyDH0YpzAkNDuONN1IM8d07YX4hxebjUzZJMtJ8gRj2boUdGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710895843; c=relaxed/simple;
	bh=6Q073mfOFIAzI7qEkWQQriqWiadvjFFWhpEnWTr6mGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q0omE7u3b8QJuH7iC3wPlT5EdBAlShBUZw5+27OodSobMIuVevmFJVaXExRyboIcw2TLQdZk0E2gqbKr0ETIBO2c6PwyX343c3vLCxCWdEIrh3caeWjSCCo+c1VETNK33wMEhursqBLd/jNCa/FUpXr58/VKxCxk2n7jQ+aAI50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WttWwMgx; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc743cc50a6so8755118276.2
        for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 17:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710895840; x=1711500640; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tCQ96HrZSAyrK2o8U8Il1owTWIbaazqQ6Mo14S4OZD0=;
        b=WttWwMgxtGpVvtn2QKUbc7ntn5HXROz/8C4aE1U/UxEpopfsZFknIgPCcyod2MQG97
         k+nm18Nb6jbK6xMi3DeEYfNxM+mqCrYbxTt6GaeZbkFl08MiL72ZKy3ve4V5oZW2Jp2c
         Qba7SRICjI8NtfQUp5IOLM482eA65wyC1Cll9kyH8pQmC+XaiCUdxrtyi6983Qhf+ZZk
         YtQ58+S2pWl1+j2uHa87a31LJeGGQLZCLMABSnKfvcE9W4DWN5EcVqrTAK1fmud5TnNW
         03FGUDRa3u0dXtyTPReewmpDQl9XdbSiPDA5TwaRG7dcO4iembcbCp6DGilOkM2ceTGC
         u9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710895840; x=1711500640;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tCQ96HrZSAyrK2o8U8Il1owTWIbaazqQ6Mo14S4OZD0=;
        b=BzMpBK2Mxlvd9ETwqlQcqFDLvh5IxvrGghmXDLNFeqS+plZIjOfq/okUSs14GLXz/u
         2nbEFhQB2igJVhMUQ+GJW3gqwBjV3JhTg1F7+ag2eOQnyH3xuMWd+j8FJZmQow1ltyhQ
         5x5TufdvaX1Gn8Q8e/ouFAQ5694geaTHp5RzVvYCuSVPTO9IgzPI71W8TQFoo6oHnPJx
         DDuIAQ4U+BDSevxhr6l405GxT3j2MKK0TJQ1ut6wTtcoThWoX2+mAqd4oHntHnCe3BrS
         hE7pOwKWvOy2vy8MRoSwmz0LV4CYFI8brgB/96/FxJvxde66AhAO7Pvpr9ZoV3tP9r7e
         iDRQ==
X-Gm-Message-State: AOJu0YzUEhqzvdWm69ecd9yK4dVSi6dHuNj1xnt/AnkSv1GZ9GrVpHq7
	oTqe6579cNd0Vt101anbw23Pt6BwCedwC+kRHSTgG6AO6jhcvr3SCRnW0MvslD/P3xydhY6hbHm
	Bwg==
X-Google-Smtp-Source: AGHT+IGdMqF4vD2v9QPypYeBdDU6pK+MEXTo/9biMAJ+aCjODjdQpdDK43t7qA4l+VUTFWj/TlgTKU/7WCE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:e0d:b0:dcd:b593:6503 with SMTP id
 df13-20020a0569020e0d00b00dcdb5936503mr974695ybb.2.1710895840275; Tue, 19 Mar
 2024 17:50:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Mar 2024 17:50:22 -0700
In-Reply-To: <20240320005024.3216282-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240320005024.3216282-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240320005024.3216282-3-seanjc@google.com>
Subject: [RFC PATCH 2/4] KVM: x86/mmu: Mark folio dirty when creating SPTE,
 not when zapping/modifying
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Stevens <stevensd@chromium.org>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"

Mark pages/folios dirty when creating SPTEs to map PFNs into the guest,
not when zapping or modifying SPTEs, as marking folios dirty when zapping
or modifying SPTEs can be extremely inefficient.  E.g. when KVM is zapping
collapsible SPTEs to reconstitute a hugepage after disbling dirty logging,
KVM will mark every 4KiB pfn as dirty, even though _at least_ 512 pfns are
guaranteed to be in a single folio (the SPTE couldn't potentially be huge
if that weren't the case).  The problem only becomes worse for 1GiB
HugeTLB pages, as KVM can mark a single folio dirty 512*512 times.

Marking a folio dirty when mapping is functionally safe as KVM drops all
relevant SPTEs in response to an mmu_notifier invalidation, i.e. ensures
that the guest can't dirty a folio after access has been removed.

And because KVM already marks folios dirty when zapping/modifying SPTEs
for KVM reasons, i.e. not in response to an mmu_notifier invalidation,
there is no danger of "prematurely" marking a folio dirty.  E.g. if a
filesystems cleans a folio without first removing write access, then there
already exists races where KVM could mark a folio dirty before remote TLBs
are flushed, i.e. before guest writes are guaranteed to stop.  Furthermore,
x86 is literally the only architecture that marks folios dirty on the
backend; every other KVM architecture marks folios dirty at map time.

x86's unique behavior likely stems from the fact that x86's MMU predates
mmu_notifiers.  Long, long ago, before mmu_notifiers were added, marking
pages dirty when zapping SPTEs was logical, and perhaps even necessary, as
KVM held references to pages, i.e. kept a page's refcount elevated while
the page was mapped into the guest.  At the time, KVM's rmap_remove()
simply did:

        if (is_writeble_pte(*spte))
                kvm_release_pfn_dirty(pfn);
        else
                kvm_release_pfn_clean(pfn);

i.e. dropped the refcount and marked the page dirty at the same time.
After mmu_notifiers were introduced, commit acb66dd051d0 ("KVM: MMU:
dont hold pagecount reference for mapped sptes pages") removed the
refcount logic, but kept the dirty logic, i.e. converted the above to:

	if (is_writeble_pte(*spte))
		kvm_release_pfn_dirty(pfn);

And for KVM x86, that's essentially how things have stayed over the last
~15 years, without anyone revisiting *why* KVM marks pages/folios dirty at
zap/modification time, e.g. the behavior was blindly carried forward to
the TDP MMU.

Practically speaking, the only downside to marking a folio dirty during
mapping is that KVM could trigger writeback of memory that was never
actually written.  Except that can't actually happen if KVM marks folios
during if and only if a writable SPTE is created (as done here), because
KVM always marks writable SPTEs as dirty during make_spte().  See commit
9b51a63024bd ("KVM: MMU: Explicitly set D-bit for writable spte."), circa
2015.

Note, KVM's access tracking logic for prefetched SPTEs is a bit odd.  If a
guest PTE is dirty and writable, KVM will create a writable SPTE, but then
mark the SPTE for access tracking.  Which isn't wrong, just a bit odd, as
it results in _more_ precise dirty tracking for MMUs _without_ A/D bits.

To keep things simple, mark the folio dirty before access tracking comes
into play, as an access-tracked SPTE can be restored in the fast page
fault path, i.e. without holding mmu_lock.  While writing SPTEs and
accessing memslots outside of mmu_lock is safe, marking a folio dirty is
not.  E.g. if the fast path gets interrupted _just_ after setting a SPTE,
the primary MMU could theoretically invalidate and free a folio before KVM
marks it dirty.  Unlike the shadow MMU, which waits for CPUs to respond to
an IPI, the TDP MMU only guarantees the page tables themselves won't be
freed (via RCU).

Opportunistically update a few stale comments.

Cc: David Hildenbrand <david@redhat.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Stevens <stevensd@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 29 ++++-------------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  7 +++----
 arch/x86/kvm/mmu/spte.c        | 13 ++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c     | 12 ------------
 4 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e4cc7f764980..bd2240b94ff6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -544,10 +544,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 	}
 
-	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
+	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
 		flush = true;
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
-	}
 
 	return flush;
 }
@@ -590,9 +588,6 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	if (is_accessed_spte(old_spte))
 		kvm_set_pfn_accessed(pfn);
 
-	if (is_dirty_spte(old_spte))
-		kvm_set_pfn_dirty(pfn);
-
 	return old_spte;
 }
 
@@ -623,13 +618,6 @@ static bool mmu_spte_age(u64 *sptep)
 		clear_bit((ffs(shadow_accessed_mask) - 1),
 			  (unsigned long *)sptep);
 	} else {
-		/*
-		 * Capture the dirty status of the page, so that it doesn't get
-		 * lost when the SPTE is marked for access tracking.
-		 */
-		if (is_writable_pte(spte))
-			kvm_set_pfn_dirty(spte_to_pfn(spte));
-
 		spte = mark_spte_for_access_track(spte);
 		mmu_spte_update_no_track(sptep, spte);
 	}
@@ -1263,16 +1251,6 @@ static bool spte_clear_dirty(u64 *sptep)
 	return mmu_spte_update(sptep, spte);
 }
 
-static bool spte_wrprot_for_clear_dirty(u64 *sptep)
-{
-	bool was_writable = test_and_clear_bit(PT_WRITABLE_SHIFT,
-					       (unsigned long *)sptep);
-	if (was_writable && !spte_ad_enabled(*sptep))
-		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
-
-	return was_writable;
-}
-
 /*
  * Gets the GFN ready for another round of dirty logging by clearing the
  *	- D bit on ad-enabled SPTEs, and
@@ -1288,7 +1266,8 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 	for_each_rmap_spte(rmap_head, &iter, sptep)
 		if (spte_ad_need_write_protect(*sptep))
-			flush |= spte_wrprot_for_clear_dirty(sptep);
+			flush |= test_and_clear_bit(PT_WRITABLE_SHIFT,
+						    (unsigned long *)sptep);
 		else
 			flush |= spte_clear_dirty(sptep);
 
@@ -3392,7 +3371,7 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
 	 * harm. This also avoids the TLB flush needed after setting dirty bit
 	 * so non-PML cases won't be impacted.
 	 *
-	 * Compare with set_spte where instead shadow_dirty_mask is set.
+	 * Compare with make_spte() where instead shadow_dirty_mask is set.
 	 */
 	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
 		return false;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4d4e98fe4f35..ec24a6679153 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -554,7 +554,6 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		return false;
 
 	mmu_set_spte(vcpu, slot, spte, pte_access, gfn, pfn, NULL);
-	kvm_release_pfn_clean(pfn);
 	return true;
 }
 
@@ -891,9 +890,9 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 /*
  * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn()) is
- * safe because:
- * - The spte has a reference to the struct page, so the pfn for a given gfn
- *   can't change unless all sptes pointing to it are nuked first.
+ * safe because SPTEs are protected by mmu_notifiers and memslot generations, so
+ * the pfn for a given gfn can't change unless all SPTEs pointing to the gfn are
+ * nuked first.
  *
  * Returns
  * < 0: failed to sync spte
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b4c1119cc48b..490966bc893c 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -212,8 +212,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * unnecessary (and expensive).
 		 *
 		 * The same reasoning applies to dirty page/folio accounting;
-		 * KVM will mark the folio dirty using the old SPTE, thus
-		 * there's no need to immediately mark the new SPTE as dirty.
+		 * KVM marked the folio dirty when the old SPTE was created,
+		 * thus there's no need to mark the folio dirty again.
 		 *
 		 * Note, both cases rely on KVM not changing PFNs without first
 		 * zapping the old SPTE, which is guaranteed by both the shadow
@@ -235,8 +235,10 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		}
 	}
 
-	if (pte_access & ACC_WRITE_MASK)
+	if (pte_access & ACC_WRITE_MASK) {
 		spte |= spte_shadow_dirty_mask(spte);
+		kvm_set_pfn_dirty(pfn);
+	}
 
 out:
 	if (prefetch)
@@ -246,6 +248,11 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
 
+	/*
+	 * Mark the memslot dirty *after* modifying it for access tracking.
+	 * Unlike folios, memslots can be safely marked dirty out of mmu_lock,
+	 * i.e. in the fast page fault handler.
+	 */
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON_ONCE(level > PG_LEVEL_4K);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d078157e62aa..5866a664f46e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -511,10 +511,6 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	if (is_leaf != was_leaf)
 		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
 
-	if (was_leaf && is_dirty_spte(old_spte) &&
-	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
-
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
 	 * the paging structure.  Note the WARN on the PFN changing without the
@@ -1224,13 +1220,6 @@ static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
 							 iter->level);
 		new_spte = iter->old_spte & ~shadow_accessed_mask;
 	} else {
-		/*
-		 * Capture the dirty status of the page, so that it doesn't get
-		 * lost when the SPTE is marked for access tracking.
-		 */
-		if (is_writable_pte(iter->old_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
-
 		new_spte = mark_spte_for_access_track(iter->old_spte);
 		iter->old_spte = kvm_tdp_mmu_write_spte(iter->sptep,
 							iter->old_spte, new_spte,
@@ -1652,7 +1641,6 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
 					       iter.old_spte,
 					       iter.old_spte & ~dbit);
-		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
 	}
 
 	rcu_read_unlock();
-- 
2.44.0.291.gc1ea87d7ee-goog


