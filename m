Return-Path: <kvm+bounces-27525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73794986A8B
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A441F22316
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D313519AD56;
	Thu, 26 Sep 2024 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="m/VTRhi4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1550118133C
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314529; cv=none; b=CjdgOjcC7MoB0wNcG/X3hQVsyvi2uWEMTsAQBH2PeR7MMP6PLLRX7dVimkT3fl0mGb3hspWl/hA391I5DaKndGFaz8yLrmuZrQ9uhg3HMkWJMO2WG7qQc69EOndC7L6e3yRj1hC+L5mR46C/PWCCICxbeTQx+2CZo+tUhFMABuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314529; c=relaxed/simple;
	bh=0raPSAp7HnmbBOxblzsQepM7TqKA7NY1yCc61VEgCKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lm+OjA0xuROBgiOK81n69CPBn/jbNXTlY+z+5ma6V5wxcojjeObbWID/T6xYxkS96/7zgdKJopQ8w64jPECuVvN28x2l1P/1aLce6cyLVhNGApPmTDpXI4pcHBQRBY4pvQQChx8pIKORtEbSlUY2Ubi5mtDb5cpOHhiJZcYIYqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=m/VTRhi4; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6dbffbae597so10507187b3.2
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314526; x=1727919326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MfYThc4u3zoEwhsYqTZzHZoRr9LypPNnm95GFpy1spA=;
        b=m/VTRhi4Vb+l3sQ9+TsKzd34SVYj5ofUYIRw29d46kdZg/s++sbiH2HxV6TUSI+WVe
         qrvHnx2MdK5vGGg7epJE12uX2HJOeFDslmOQvTk+RW6WJqC/GIttuF5sNSWF2IDe6r84
         Oyl3FwIKr2RwMmIGCk06foCowlPWYirhsg5auSAa1k2dFNi/fcTElYCMWW0g9JrQCR8Q
         RnZw2JSWLo2sbZpZx2YFITuhzBYe2UAHX3CfkY8Ofe7gULoecF/Wfp1c+cyBdt5dJB8M
         Z9MCwdscIWgwu8MHVeq7SYR0pGIa7TpFAEsABLL5UCGNWygeUXj11bZIfoczL/UeldZR
         DvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314526; x=1727919326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MfYThc4u3zoEwhsYqTZzHZoRr9LypPNnm95GFpy1spA=;
        b=HM9gnF0+Xh1jZY3pa1Ie3HUFhDGo3mRIjCeMWbqkwf+2AeZ1NMq+Xa47l2DGdeIajP
         rfNlcVXkzgCb743qAsB972Bhm1WTuDyMCxUDNmk4ZJevya2EI/Sks50U2IaOAlCV+lAq
         XB3NiysdD2jpfi3QAJ79krFtRwUFajQ0q2XOAqn5Hw7fURhXLafHy0VS/NE9UMHUPYvc
         ANkOKnmedO4TXV0z+7lZzsbloJwzA+KOWupcBjMD5zy3nIp7SQhyq7g2suUi3UAgQ3iC
         7z9VvsH3PSgq9pxb06AHSm0sPw8c2klCpG9C02k1qynBxYa+ZOoFR8MzUPKFpo413+Bh
         91Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXaFl9nLZdiCGj0oJ0kUDUBL8xfjWLyD7Zm+YlaZkysV6s+tSA9ku3ku2eJ9a/Lag2iF6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLOLMYCEmY3Oz7XB0NFhkpT/9p919yAsiABs1LlN0XVEFQxovc
	pSzMoYbIBiVzGGUwkhN6eJR3Z+OoQ8JVn7Sq/kmew88HUfjiJqyHblrc0axkBxNbqe5xQ9zejAd
	S4wmXoh6GYkuO/Kdtig==
X-Google-Smtp-Source: AGHT+IFc2BTb/n/6/Pa4YiRnYJohGJI1GOQLPmGDGx2avUwnGUEvHFpkm5PUE1m++wXUG9sRJDYpg95gpRMXrHPb
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:5086:b0:6e2:1b8c:39bf with
 SMTP id 00721157ae682-6e21d835b06mr289447b3.2.1727314525948; Wed, 25 Sep 2024
 18:35:25 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:57 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-10-jthoughton@google.com>
Subject: [PATCH v7 09/18] KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
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
[jthoughton: Added lockdep assertion for kvm_rmap_lock, synchronization fixup]
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 75 +++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 79676798ba77..72c682fa207a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -932,7 +932,7 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
  */
 #define KVM_RMAP_LOCKED	BIT(1)
 
-static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+static unsigned long __kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
 {
 	unsigned long old_val, new_val;
 
@@ -976,14 +976,25 @@ static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
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
 
+static unsigned long kvm_rmap_lock(struct kvm *kvm,
+				   struct kvm_rmap_head *rmap_head)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	return __kvm_rmap_lock(rmap_head);
+}
+
 static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
 			    unsigned long new_val)
 {
-	WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
+	KVM_MMU_WARN_ON(new_val & KVM_RMAP_LOCKED);
 	/*
 	 * Ensure that all accesses to the rmap have completed
 	 * before we actually unlock the rmap.
@@ -1023,14 +1034,14 @@ static void kvm_rmap_unlock_readonly(struct kvm_rmap_head *rmap_head,
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
@@ -1110,7 +1121,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = kvm_rmap_lock(rmap_head);
+	rmap_val = kvm_rmap_lock(kvm, rmap_head);
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
 		goto out;
 
@@ -1154,7 +1165,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = kvm_rmap_lock(rmap_head);
+	rmap_val = kvm_rmap_lock(kvm, rmap_head);
 	if (!rmap_val)
 		return false;
 
@@ -1246,23 +1257,18 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
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
@@ -1272,14 +1278,11 @@ static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
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
@@ -1287,20 +1290,24 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
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
@@ -1396,11 +1403,12 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	struct rmap_iterator iter;
 	bool flush = false;
 
-	for_each_rmap_spte(rmap_head, &iter, sptep)
+	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		if (spte_ad_need_write_protect(*sptep))
 			flush |= spte_wrprot_for_clear_dirty(sptep);
 		else
 			flush |= spte_clear_dirty(sptep);
+	}
 
 	return flush;
 }
@@ -1710,7 +1718,7 @@ static void __rmap_add(struct kvm *kvm,
 	kvm_update_page_stats(kvm, sp->role.level, 1);
 
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	rmap_count = pte_list_add(cache, spte, rmap_head);
+	rmap_count = pte_list_add(kvm, cache, spte, rmap_head);
 
 	if (rmap_count > kvm->stat.max_mmu_rmap_size)
 		kvm->stat.max_mmu_rmap_size = rmap_count;
@@ -1859,13 +1867,14 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
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
@@ -2555,7 +2564,7 @@ static void __link_shadow_page(struct kvm *kvm,
 
 	mmu_spte_set(sptep, spte);
 
-	mmu_page_add_parent_pte(cache, sp, sptep);
+	mmu_page_add_parent_pte(kvm, cache, sp, sptep);
 
 	/*
 	 * The non-direct sub-pagetable must be updated before linking.  For
-- 
2.46.0.792.g87dc391469-goog


