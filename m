Return-Path: <kvm+bounces-27527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA8C986A8F
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 03:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFE951F22F87
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B3B1A3BD8;
	Thu, 26 Sep 2024 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pTYd9M30"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2615818E37A
	for <kvm@vger.kernel.org>; Thu, 26 Sep 2024 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727314530; cv=none; b=fsM25+IQlhefsPSv1mb6/iKyQ1scT45S4zLJfhbhuEvl60+pjTHRambxFLcCJdoYgOELXzGB8gzi4puyw8PTEAc98FiCxM45LOPSb+zOExsbc+9jAvJo41xO2LUhMXwkCd+wrz1wdo3MSUIruh9mP7in71v5+AqNQVLHS0CUFJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727314530; c=relaxed/simple;
	bh=kDtNUQWNt+SQcHHta/bZAK9WcZs+ACOnkP4YoyybjWg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QgzprNrJcT+Ql2YiFa0/fVXVEv+fI70D/H9tGl/BVxfFjwNy6LWt85zBI5KTNV31grrZ+cTgMTRZ13iUfIu1XbFmHeKRwdE9Jys5xOcuTc1qi5MUlNRUuu9v6rFkvYFo/Uuhmwymknq3WxWt4KTfAtjOcp7fv3K5lP6t4nL4uwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pTYd9M30; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e163641feb9so1193552276.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 18:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727314525; x=1727919325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PEKVE3jXTsgIQ3oSBpZASsaX7oLzK9gVxgGb+Q0WSSI=;
        b=pTYd9M30sW29imMHTGG3YgJ2MSDnA1SjUjerKMt1O6uAudzZLN4ieODN0kRgBbflMv
         2LTxiHnhMYUTGCPXpxKHd28OEV5NleG9+9G7s/XKhBtIEvEIUUKNp/uDuU20Yl8zSVKV
         Hz6m4ZqKbKDdiCVx9gKcoTmJ1UEEaFRj+atWYxSSeOSexLuptxX2T/HsPdgKAgPajIJu
         UiQWOCvLnsoNoJIfyG7xGmatO254+BQKNzZAHa7w8IQeW1QHG8c9TPYRPf80Eb0DfErQ
         k/0JkByZhMottH49kI8sgl1GYcdgVRvxSApforIY2ZDlhX4JCNee9m5i0uiHCMF9tJhw
         lhxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727314525; x=1727919325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PEKVE3jXTsgIQ3oSBpZASsaX7oLzK9gVxgGb+Q0WSSI=;
        b=IC4+o0vS7VPH1YeMMXYc6jC0izo4GBEHMMwDf87HhZacjzhi3l8gNkmjVCyLnJsHuK
         WOmmv0qYvJwqoXnzb8ikpD0U1JZX/tcQ31P5xarim774ndwAwtxRLpND4RLr9Rlz4DcE
         Sv69QAxUucsr1u13cAZnfidlogs/WAJQ05zQVrM4ZPBSAUnQVkLUASMWezT8IYKLp3uR
         fek9xGyaba1T4i4+FRGKVj9HN+uNldRTu08U1JoTpJyH3RZ8KkVf7VJkRRB9VArmIYGn
         +vx3fOzPbJ9vnE5UUyY8EtlNisObf4aS9wishmGHw6DFi5fYTPxkMRZuc7akwE322tT1
         Ef3w==
X-Forwarded-Encrypted: i=1; AJvYcCUi5n8LtM01NqaK00UCEnEpfySfB9R/Vyx2f7QB5OWW95B11kgzVxy7+D5nWasBAPq7lT0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+vc4qGDilmUdKi2/z2i+o83DwsnFh7I9eTq2hYzRmmA8Q2WwF
	ov6nKruHODtyS6SVfH8497+5u5+uJLgfcXzamLQjJ30jfuri65XUeSp9se7S4/DaozWl9ryfKYa
	mCFPH56Uv8XHngAMOxQ==
X-Google-Smtp-Source: AGHT+IF3/FYwkPT4bz8o9cvma+KKRWpatKrEO97ngoYUR5+iC7Jt4hs+IFCE9RrvcEVoXK4mDoAHACDMu6yNCXzE
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a5b:704:0:b0:e20:2da6:ed77 with SMTP id
 3f1490d57ef6-e25ca95c803mr24214276.5.1727314524854; Wed, 25 Sep 2024 18:35:24
 -0700 (PDT)
Date: Thu, 26 Sep 2024 01:34:56 +0000
In-Reply-To: <20240926013506.860253-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240926013506.860253-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
Message-ID: <20240926013506.860253-9-jthoughton@google.com>
Subject: [PATCH v7 08/18] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
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

Steal another bit from rmap entries (which are word aligned pointers, i.e.
have 2 free bits on 32-bit KVM, and 3 free bits on 64-bit KVM), and use
the bit to implement a *very* rudimentary per-rmap spinlock.  The only
anticipated usage of the lock outside of mmu_lock is for aging gfns, and
collisions between aging and other MMU rmap operations are quite rare,
e.g. unless userspace is being silly and aging a tiny range over and over
in a tight loop, time between contention when aging an actively running VM
is O(seconds).  In short, a more sophisticated locking scheme shouldn't be
necessary.

Note, the lock only protects the rmap structure itself, SPTEs that are
pointed at by a locked rmap can still be modified and zapped by another
task (KVM drops/zaps SPTEs before deleting the rmap entries)

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: James Houghton <jthoughton@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/mmu/mmu.c          | 129 +++++++++++++++++++++++++++++---
 2 files changed, 120 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index adc814bad4bb..d1164ca3e840 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <linux/irqbypass.h>
 #include <linux/hyperv.h>
 #include <linux/kfifo.h>
+#include <linux/atomic/atomic-long.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -401,7 +402,7 @@ union kvm_cpu_role {
 };
 
 struct kvm_rmap_head {
-	unsigned long val;
+	atomic_long_t val;
 };
 
 struct kvm_pio_request {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 17de470f542c..79676798ba77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -909,11 +909,117 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
  * About rmap_head encoding:
  *
  * If the bit zero of rmap_head->val is clear, then it points to the only spte
- * in this rmap chain. Otherwise, (rmap_head->val & ~1) points to a struct
+ * in this rmap chain. Otherwise, (rmap_head->val & ~3) points to a struct
  * pte_list_desc containing more mappings.
  */
 #define KVM_RMAP_MANY	BIT(0)
 
+/*
+ * rmaps and PTE lists are mostly protected by mmu_lock (the shadow MMU always
+ * operates with mmu_lock held for write), but rmaps can be walked without
+ * holding mmu_lock so long as the caller can tolerate SPTEs in the rmap chain
+ * being zapped/dropped _while the rmap is locked_.
+ *
+ * Other than the KVM_RMAP_LOCKED flag, modifications to rmap entries must be
+ * done while holding mmu_lock for write.  This allows a task walking rmaps
+ * without holding mmu_lock to concurrently walk the same entries as a task
+ * that is holding mmu_lock but _not_ the rmap lock.  Neither task will modify
+ * the rmaps, thus the walks are stable.
+ *
+ * As alluded to above, SPTEs in rmaps are _not_ protected by KVM_RMAP_LOCKED,
+ * only the rmap chains themselves are protected.  E.g. holding an rmap's lock
+ * ensures all "struct pte_list_desc" fields are stable.
+ */
+#define KVM_RMAP_LOCKED	BIT(1)
+
+static unsigned long kvm_rmap_lock(struct kvm_rmap_head *rmap_head)
+{
+	unsigned long old_val, new_val;
+
+	/*
+	 * Elide the lock if the rmap is empty, as lockless walkers (read-only
+	 * mode) don't need to (and can't) walk an empty rmap, nor can they add
+	 * entries to the rmap.  I.e. the only paths that process empty rmaps
+	 * do so while holding mmu_lock for write, and are mutually exclusive.
+	 */
+	old_val = atomic_long_read(&rmap_head->val);
+	if (!old_val)
+		return 0;
+
+	do {
+		/*
+		 * If the rmap is locked, wait for it to be unlocked before
+		 * trying acquire the lock, e.g. to bounce the cache line.
+		 */
+		while (old_val & KVM_RMAP_LOCKED) {
+			old_val = atomic_long_read(&rmap_head->val);
+			cpu_relax();
+		}
+
+		/*
+		 * Recheck for an empty rmap, it may have been purged by the
+		 * task that held the lock.
+		 */
+		if (!old_val)
+			return 0;
+
+		new_val = old_val | KVM_RMAP_LOCKED;
+	/*
+	 * Use try_cmpxchg_acquire to prevent reads and writes to the rmap
+	 * from being reordered outside of the critical section created by
+	 * __kvm_rmap_lock.
+	 *
+	 * Pairs with smp_store_release in kvm_rmap_unlock.
+	 *
+	 * For the !old_val case, no ordering is needed, as there is no rmap
+	 * to walk.
+	 */
+	} while (!atomic_long_try_cmpxchg_acquire(&rmap_head->val, &old_val, new_val));
+
+	/* Return the old value, i.e. _without_ the LOCKED bit set. */
+	return old_val;
+}
+
+static void kvm_rmap_unlock(struct kvm_rmap_head *rmap_head,
+			    unsigned long new_val)
+{
+	WARN_ON_ONCE(new_val & KVM_RMAP_LOCKED);
+	/*
+	 * Ensure that all accesses to the rmap have completed
+	 * before we actually unlock the rmap.
+	 *
+	 * Pairs with the atomic_long_try_cmpxchg_acquire in __kvm_rmap_lock.
+	 */
+	atomic_long_set_release(&rmap_head->val, new_val);
+}
+
+static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
+{
+	return atomic_long_read(&rmap_head->val) & ~KVM_RMAP_LOCKED;
+}
+
+/*
+ * If mmu_lock isn't held, rmaps can only locked in read-only mode.  The actual
+ * locking is the same, but the caller is disallowed from modifying the rmap,
+ * and so the unlock flow is a nop if the rmap is/was empty.
+ */
+__maybe_unused
+static unsigned long kvm_rmap_lock_readonly(struct kvm_rmap_head *rmap_head)
+{
+	return __kvm_rmap_lock(rmap_head);
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
+	atomic_long_set(&rmap_head->val, old_val);
+}
+
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
@@ -924,7 +1030,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	struct pte_list_desc *desc;
 	int count = 0;
 
-	old_val = rmap_head->val;
+	old_val = kvm_rmap_lock(rmap_head);
 
 	if (!old_val) {
 		new_val = (unsigned long)spte;
@@ -956,7 +1062,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		desc->sptes[desc->spte_count++] = spte;
 	}
 
-	rmap_head->val = new_val;
+	kvm_rmap_unlock(rmap_head, new_val);
 
 	return count;
 }
@@ -1004,7 +1110,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
 		goto out;
 
@@ -1030,7 +1136,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	}
 
 out:
-	rmap_head->val = rmap_val;
+	kvm_rmap_unlock(rmap_head, rmap_val);
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -1048,7 +1154,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (!rmap_val)
 		return false;
 
@@ -1067,13 +1173,13 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	}
 out:
 	/* rmap_head is meaningless now, remember to reset it */
-	rmap_head->val = 0;
+	kvm_rmap_unlock(rmap_head, 0);
 	return true;
 }
 
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head)
 {
-	unsigned long rmap_val = rmap_head->val;
+	unsigned long rmap_val = kvm_rmap_get(rmap_head);
 	struct pte_list_desc *desc;
 
 	if (!rmap_val)
@@ -1139,7 +1245,7 @@ struct rmap_iterator {
 static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
-	unsigned long rmap_val = rmap_head->val;
+	unsigned long rmap_val = kvm_rmap_get(rmap_head);
 	u64 *sptep;
 
 	if (!rmap_val)
@@ -1483,7 +1589,7 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	while (++iterator->rmap <= iterator->end_rmap) {
 		iterator->gfn += KVM_PAGES_PER_HPAGE(iterator->level);
 
-		if (iterator->rmap->val)
+		if (atomic_long_read(&iterator->rmap->val))
 			return;
 	}
 
@@ -2513,7 +2619,8 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			 * avoids retaining a large number of stale nested SPs.
 			 */
 			if (tdp_enabled && invalid_list &&
-			    child->role.guest_mode && !child->parent_ptes.val)
+			    child->role.guest_mode &&
+			    !atomic_long_read(&child->parent_ptes.val))
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-- 
2.46.0.792.g87dc391469-goog


