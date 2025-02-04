Return-Path: <kvm+bounces-37201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A20DFA268C8
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D65FA7A0564
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:43:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D201487F4;
	Tue,  4 Feb 2025 00:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="20rFfx47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A69B153828
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629666; cv=none; b=EvRB8J9CzJRHptCfGVVzH1lqo/cXxrE/4hSahVUinpg3Q2wXhulCslgH5WKPv8dWG0wRzPZncJX2sk0EKogo0Euk6k/xyoZyWt7KGX0JN5LS+J1rxuuS/c7vARR75lIHTYWWJrtRwcIaGAcoewhEVwL6awZmk4To91Z6ajydi4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629666; c=relaxed/simple;
	bh=FDFCk2LogfvC6RP8YTOSiGFoYjSxrG9RdMJhIpmoHow=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YrzzD8PlOj2dHZFPpY0cNr8dtsrKXjBTlC5yjOyRpjkiPvKE8lOWXoZn/+P/C1550xzILJlq2XGrA16bY4B0VjrAkObBvE13wzx/Vkr8hP0sYnGOd6Lvms7/CplRilFHHLPtnq50LrDMhBLdRU5sm5yYVzXSQ1+fLecL3TSR1uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=20rFfx47; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4affab6057dso648490137.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629663; x=1739234463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NT/1Ea4uOdT49wXiAqqe8cJlC1P1xI9VIain2UmREN0=;
        b=20rFfx473GOBjoNUYs4JozDIW1yedvGFdyY9+PnUN34sLDpUhoNZNDrk3NsGTX2BJy
         eZQZgQUPh4x0Ao3HKHj/0T97hDgMuclZVFrtinNJjfwmjTK1GBlFY+qc9ngm4mfSGdRe
         pWY0YfVRjGzyFL+nGBt8/LPJeCumCEoqwJ4cV0zqHQBtYOSv8aXd3h4Y5fr76IcCKfmG
         QE/T1jx64XD7P1XOb85oAat7S5a5ZyPA5uUmY3fn2KTFGSw1oi8edZJA05xRbQFPoFie
         lRQXscmyKUP7LZvynWFvcMGOW1d8uBq8SjAV41qRYE3IgkKevpS2OAb1uf1dpVeE1r7k
         n9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629663; x=1739234463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NT/1Ea4uOdT49wXiAqqe8cJlC1P1xI9VIain2UmREN0=;
        b=TYs6AYFcb/oKAeStV7Dm1ZyfUAkTg7l1Nz4uSG7LOXBxRHrEyauv4Ag8MpDapeoRd4
         qno3k6d6hH9laNdRnJPmZ785X5qK4NvsWmy1gOTtZnDWsBSjvZ8T7HhPTCTNeA/2lj+I
         z/QPNV4Y+eTKSnrJsO997YJhPFQVY9mvzomZZ1+eQDUkdENs7krboaBb7a+2X9xpLS26
         knS+phLTo1sUQW9GxHSbRYtTtw04mNoWAMvugWl7JPIbkzv0wGQfsI2avMuCld67VXYI
         LlG8dkMKuujXH3OIQr32aTHpXMnPUTNqZVd6PQC7zx1Q8pI1LgXj8Cjs/ovDOfeW84iL
         i0+A==
X-Forwarded-Encrypted: i=1; AJvYcCUoqvUDRD5O8QQiM7vD1P4gZV22NPqYHUqrTuYBBSseVUS17SpljTw4n69yq/3KXFPkK2k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWc6g7Q8Hn7X+lMQyUHPzmpj1nTagj7Pqq0WXvlYTvP23NNihp
	CMd0qJ/nM0I6yuNrMBQE64PuT2CaRf1KExwKcBe2gri6p84loc1DoUi/yOg3HtYkAq1TTCeYf0J
	NmtTJN02TwRukB5E70A==
X-Google-Smtp-Source: AGHT+IGvEefJIQ+qh5TNzlPbwPP5FFWQIpGkJTgioLbeggYzaRqHQ2iUX4TpLwM9epwUB9f8udHnoz355QhDxYKM
X-Received: from vkbci31.prod.google.com ([2002:a05:6122:321f:b0:516:25ed:28e4])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:3913:b0:4b6:20a5:8a11 with SMTP id ada2fe7eead31-4b9a4ec0890mr18276154137.1.1738629663101;
 Mon, 03 Feb 2025 16:41:03 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:37 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-11-jthoughton@google.com>
Subject: [PATCH v9 10/11] KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Add a lockless version of for_each_rmap_spte(), which is pretty much the
same as the normal version, except that it doesn't BUG() the host if a
non-present SPTE is encountered.  When mmu_lock is held, it should be
impossible for a different task to zap a SPTE, _and_ zapped SPTEs must
be removed from their rmap chain prior to dropping mmu_lock.  Thus, the
normal walker BUG()s if a non-present SPTE is encountered as something is
wildly broken.

When walking rmaps without holding mmu_lock, the SPTEs pointed at by the
rmap chain can be zapped/dropped, and so a lockless walk can observe a
non-present SPTE if it runs concurrently with a different operation that
is zapping SPTEs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 135 ++++++++++++++++++++++++++++-------------
 1 file changed, 94 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 267cf2d4c3e3..a0f735eeaaeb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -876,10 +876,12 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
  */
 #define KVM_RMAP_LOCKED	BIT(1)
 
-static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+static unsigned long __kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 {
 	unsigned long old_val, new_val;
 
+	lockdep_assert_preemption_disabled();
+
 	/*
 	 * Elide the lock if the rmap is empty, as lockless walkers (read-only
 	 * mode) don't need to (and can't) walk an empty rmap, nor can they add
@@ -911,7 +913,7 @@ static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 	/*
 	 * Use try_cmpxchg_acquire to prevent reads and writes to the rmap
 	 * from being reordered outside of the critical section created by
-	 * kvm_rmap_lock.
+	 * __kvm_rmap_lock.
 	 *
 	 * Pairs with smp_store_release in kvm_rmap_unlock.
 	 *
@@ -920,21 +922,42 @@ static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 	 */
 	} while (!atomic_long_try_cmpxchg_acquire(&rmap_head->val, &old_val, new_val));
 
-	/* Return the old value, i.e. _without_ the LOCKED bit set. */
+	/*
+	 * Return the old value, i.e. _without_ the LOCKED bit set.  It's
+	 * impossible for the return value to be 0 (see above), i.e. the read-
+	 * only unlock flow can't get a false positive and fail to unlock.
+	 */
 	return old_val;
 }
 
-static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
-			    unsigned long new_val)
+static unsigned long kvm_rmap_lock(struct kvm *kvm,
+				   struct kvm_rmap_head *rmap_head)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	return __kvm_rmap_lock(rmap_head);
+}
+
+static void __kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
+			      unsigned long val)
 {
-	WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
+	KVM_MMU_WARN_ON(val & KVM_RMAP_LOCKED);
 	/*
 	 * Ensure that all accesses to the rmap have completed
 	 * before we actually unlock the rmap.
 	 *
-	 * Pairs with the atomic_long_try_cmpxchg_acquire in kvm_rmap_lock.
+	 * Pairs with the atomic_long_try_cmpxchg_acquire in __kvm_rmap_lock.
 	 */
-	atomic_long_set_release(&rmap_head->val, new_val);
+	atomic_long_set_release(&rmap_head->val, val);
+}
+
+static void kvm_rmap_unlock(struct kvm *kvm,
+			    struct kvm_rmap_head *rmap_head,
+			    unsigned long new_val)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	__kvm_rmap_unlock(rmap_head, new_val);
 }
 
 static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
@@ -942,17 +965,49 @@ static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
 	return atomic_long_read(&rmap_head->val) & ~KVM_RMAP_LOCKED;
 }
 
+/*
+ * If mmu_lock isn't held, rmaps can only be locked in read-only mode.  The
+ * actual locking is the same, but the caller is disallowed from modifying the
+ * rmap, and so the unlock flow is a nop if the rmap is/was empty.
+ */
+__maybe_unused
+static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
+{
+	unsigned long rmap_val;
+
+	preempt_disable();
+	rmap_val = __kvm_rmap_lock(rmap_head);
+
+	if (!rmap_val)
+		preempt_enable();
+
+	return rmap_val;
+}
+
+__maybe_unused
+static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
+				     unsigned long old_val)
+{
+	if (!old_val)
+		return;
+
+	KVM_MMU_WARN_ON(old_val != kvm_rmap_get(rmap_head));
+
+	__kvm_rmap_unlock(rmap_head, old_val);
+	preempt_enable();
+}
+
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
-static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
-			struct kvm_rmap_head *rmap_head)
+static int pte_list_add(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
+			u64 *spte, struct kvm_rmap_head *rmap_head)
 {
 	unsigned long old_val, new_val;
 	struct pte_list_desc *desc;
 	int count = 0;
 
-	old_val = kvm_rmap_lock(rmap_head);
+	old_val = kvm_rmap_lock(kvm, rmap_head);
 
 	if (!old_val) {
 		new_val = (unsigned long)spte;
@@ -984,7 +1039,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		desc->sptes[desc->spte_count++] = spte;
 	}
 
-	kvm_rmap_unlock(rmap_head, new_val);
+	kvm_rmap_unlock(kvm, rmap_head, new_val);
 
 	return count;
 }
@@ -1032,7 +1087,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = kvm_rmap_lock(rmap_head);
+	rmap_val = kvm_rmap_lock(kvm, rmap_head);
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
 		goto out;
 
@@ -1058,7 +1113,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	}
 
 out:
-	kvm_rmap_unlock(rmap_head, rmap_val);
+	kvm_rmap_unlock(kvm, rmap_head, rmap_val);
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -1076,7 +1131,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = kvm_rmap_lock(rmap_head);
+	rmap_val = kvm_rmap_lock(kvm, rmap_head);
 	if (!rmap_val)
 		return false;
 
@@ -1095,7 +1150,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	}
 out:
 	/* rmap_head is meaningless now, remember to reset it */
-	kvm_rmap_unlock(rmap_head, 0);
+	kvm_rmap_unlock(kvm, rmap_head, 0);
 	return true;
 }
 
@@ -1168,23 +1223,18 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
 	unsigned long rmap_val = kvm_rmap_get(rmap_head);
-	u64 *sptep;
 
 	if (!rmap_val)
 		return NULL;
 
 	if (!(rmap_val & KVM_RMAP_MANY)) {
 		iter->desc = NULL;
-		sptep = (u64 *)rmap_val;
-		goto out;
+		return (u64 *)rmap_val;
 	}
 
 	iter->desc = (struct pte_list_desc *)(rmap_val & ~KVM_RMAP_MANY);
 	iter->pos = 0;
-	sptep = iter->desc->sptes[iter->pos];
-out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
-	return sptep;
+	return iter->desc->sptes[iter->pos];
 }
 
 /*
@@ -1194,14 +1244,11 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
  */
 static u64 *rmap_get_next(struct rmap_iterator *iter)
 {
-	u64 *sptep;
-
 	if (iter->desc) {
 		if (iter->pos < PTE_LIST_EXT - 1) {
 			++iter->pos;
-			sptep = iter->desc->sptes[iter->pos];
-			if (sptep)
-				goto out;
+			if (iter->desc->sptes[iter->pos])
+				return iter->desc->sptes[iter->pos];
 		}
 
 		iter->desc = iter->desc->more;
@@ -1209,20 +1256,24 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 		if (iter->desc) {
 			iter->pos = 0;
 			/* desc->sptes[0] cannot be NULL */
-			sptep = iter->desc->sptes[iter->pos];
-			goto out;
+			return iter->desc->sptes[iter->pos];
 		}
 	}
 
 	return NULL;
-out:
-	BUG_ON(!is_shadow_present_pte(*sptep));
-	return sptep;
 }
 
-#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)			\
-	for (_spte_ = rmap_get_first(_rmap_head_, _iter_);		\
-	     _spte_; _spte_ = rmap_get_next(_iter_))
+#define __for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)	\
+	for (_sptep_ = rmap_get_first(_rmap_head_, _iter_);	\
+	     _sptep_; _sptep_ = rmap_get_next(_iter_))
+
+#define for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)			\
+	__for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)			\
+		if (!WARN_ON_ONCE(!is_shadow_present_pte(*(_sptep_))))	\
+
+#define for_each_rmap_spte_lockless(_rmap_head_, _iter_, _sptep_, _spte_)	\
+	__for_each_rmap_spte(_rmap_head_, _iter_, _sptep_)			\
+		if (is_shadow_present_pte(_spte_ = mmu_spte_get_lockless(sptep)))
 
 static void drop_spte(struct kvm *kvm, u64 *sptep)
 {
@@ -1308,12 +1359,13 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	struct rmap_iterator iter;
 	bool flush = false;
 
-	for_each_rmap_spte(rmap_head, &iter, sptep)
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		if (spte_ad_need_write_protect(*sptep))
 			flush |= test_and_clear_bit(PT_WRITABLE_SHIFT,
 						    (unsigned long *)sptep);
 		else
 			flush |= spte_clear_dirty(sptep);
+	}
 
 	return flush;
 }
@@ -1634,7 +1686,7 @@ static void __rmap_add(struct kvm *kvm,
 	kvm_update_page_stats(kvm, sp->role.level, 1);
 
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	rmap_count = pte_list_add(cache, spte, rmap_head);
+	rmap_count = pte_list_add(kvm, cache, spte, rmap_head);
 
 	if (rmap_count > kvm->stat.max_mmu_rmap_size)
 		kvm->stat.max_mmu_rmap_size = rmap_count;
@@ -1768,13 +1820,14 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
 
-static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
+static void mmu_page_add_parent_pte(struct kvm *kvm,
+				    struct kvm_mmu_memory_cache *cache,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	if (!parent_pte)
 		return;
 
-	pte_list_add(cache, parent_pte, &sp->parent_ptes);
+	pte_list_add(kvm, cache, parent_pte, &sp->parent_ptes);
 }
 
 static void mmu_page_remove_parent_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
@@ -2464,7 +2517,7 @@ static void __link_shadow_page(struct kvm *kvm,
 
 	mmu_spte_set(sptep, spte);
 
-	mmu_page_add_parent_pte(cache, sp, sptep);
+	mmu_page_add_parent_pte(kvm, cache, sp, sptep);
 
 	/*
 	 * The non-direct sub-pagetable must be updated before linking.  For
-- 
2.48.1.362.g079036d154-goog


