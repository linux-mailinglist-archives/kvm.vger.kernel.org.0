Return-Path: <kvm+bounces-37200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C69CA268C6
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FEC67A1B2F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:43:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C81198E76;
	Tue,  4 Feb 2025 00:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kA5Sn7zU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f202.google.com (mail-vk1-f202.google.com [209.85.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722A91487F4
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738629665; cv=none; b=CGHKWBuP7uTdu0E3eqNpsvzOYb6j3RdZ1lCYaCkIrMLauvhH3hJ5z1qKKYgKeJaM1dRJ7e/4/xX3rnWYcm/1Z8msL4Pb6IwYaCrQ1SFsGOcwyNzOR5Yo1MOL33w4ZnmHjwTh40HednJWS8NrfAo0nT46NQfOElZjVF0BfYP37KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738629665; c=relaxed/simple;
	bh=Zy4oye91lFdBLcv+ukgYWg+1Vp5yzDO7e3LTrEFoLk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=I700U3X4j9dO7fE2tskw1q9U980Ka47MfBHpY7thodJ0T15l9jTtb833bJ1+4CZMoR67L9vvlTFuEVh4J9KzjcyqoCATGhw7k6Xox7hKAtU3eGbYIyochgLAtEpaDr8ZnuWWSCxV4KHr6uYRkzeKXzAlU08ptuqV9Qutq4LRYXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kA5Sn7zU; arc=none smtp.client-ip=209.85.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f202.google.com with SMTP id 71dfb90a1353d-51844b3dbdaso706144e0c.1
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738629662; x=1739234462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eWoO+lMMXqWIzaVuugfET0/bTOkUIXS847FK2QmI/tI=;
        b=kA5Sn7zUMab4I3lAMkTkTosZQedg+WL1kLH87/ChT6Og4OaVKpMsEuvBZdCfnxRIOz
         cc6XrlcgM9HkLG5YN8h5bIJK7pKTuXw5iRKBhfhVGg+VgKhkSpqk5aisG0Ku8XXeRegN
         15g2bFqyeMHtI0GzcLNGfGa4Af+qHi+n7WCykOKvv3sjVMY6T3J7rtr2b3yTTu1103QP
         GAXLgwlispCrjNoWHZDD3vQfh7nwiIIzs1+Chidc6LOPQLDJj44oMp2YfuPyNyO8Hpnv
         CAGS5cPbv/l5chByXW4dtGLdUHNg8W1Y/g8+TSPI1LTYULSr1NxZdjcmt4NtUIduLhxG
         xxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738629662; x=1739234462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eWoO+lMMXqWIzaVuugfET0/bTOkUIXS847FK2QmI/tI=;
        b=TO50i3le+qcBU6trFJzqtjCGxy1MQkbrqJ9KhYg4OG1uHqD/aooKq37AAYsAOQyrZM
         F0Oy9VvGoIOu1XCfDoLGowSjcUwHlkFXSL6zwk9BEqTrNhc+6WfBu/GzjUKw6gwlGzAO
         4Lti/UXbR0VBasVeQvxBVe8F7skebhe9WsU0JJf4IH9musbItm3mLyMPlb3xwGMg9OBR
         KZYV2LYmUR0nCjlq47iBOg4t/xfLV6PJL+r7yS2r3U71COYbV4/Vmke19CTijudIVtRf
         HBJmFz7wqN5dhiljvoIzPn5WE4k0t6/KHx+slDkDOBihU+23utBbkdOS43rT3VkwP4An
         441A==
X-Forwarded-Encrypted: i=1; AJvYcCVexk2032rAw/mZidgBrmVgSPxhudxTWy8RSeZy3SBGaHCl1kGGC/tcdtiLM/08Tefhdbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGWd4nG0AADgddeC2AUHqRpwUslk8xg7S0wTU+QPXluo+0lC6h
	FAXcFqdPzoXWJbBscnRQe+8IY0wMsjuw1rl+Wr11cJpgvX5J2gkFWqKl8ceI/M1ymHH/GIiVwIL
	qVIgvLE7tFC7JqFlxLA==
X-Google-Smtp-Source: AGHT+IGwZC+pQj5KVs1BoZvl9VTW+YoD2540d5PUuKxlYB7xTw8o5JqIwG6QPjFodj3FS42DjhlUFnaztBK8rSbO
X-Received: from vkbej7.prod.google.com ([2002:a05:6122:2707:b0:51c:f313:dfc6])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:240c:b0:518:859e:87c3 with SMTP id 71dfb90a1353d-51e9e3edb13mr19459670e0c.7.1738629662372;
 Mon, 03 Feb 2025 16:41:02 -0800 (PST)
Date: Tue,  4 Feb 2025 00:40:36 +0000
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250204004038.1680123-1-jthoughton@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204004038.1680123-10-jthoughton@google.com>
Subject: [PATCH v9 09/11] KVM: x86/mmu: Add infrastructure to allow walking
 rmaps outside of mmu_lock
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
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
 arch/x86/kvm/mmu/mmu.c          | 107 ++++++++++++++++++++++++++++----
 2 files changed, 98 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0e44fc1cec0d..bd18fde99116 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -28,6 +28,7 @@
 #include <linux/kfifo.h>
 #include <linux/sched/vhost_task.h>
 #include <linux/call_once.h>
+#include <linux/atomic.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -406,7 +407,7 @@ union kvm_cpu_role {
 };
 
 struct kvm_rmap_head {
-	unsigned long val;
+	atomic_long_t val;
 };
 
 struct kvm_pio_request {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a24cf8ddca7f..267cf2d4c3e3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -853,11 +853,95 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
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
+			cpu_relax();
+			old_val = atomic_long_read(&rmap_head->val);
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
+	 * kvm_rmap_lock.
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
+	 * Pairs with the atomic_long_try_cmpxchg_acquire in kvm_rmap_lock.
+	 */
+	atomic_long_set_release(&rmap_head->val, new_val);
+}
+
+static unsigned long kvm_rmap_get(struct kvm_rmap_head *rmap_head)
+{
+	return atomic_long_read(&rmap_head->val) & ~KVM_RMAP_LOCKED;
+}
+
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
@@ -868,7 +952,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	struct pte_list_desc *desc;
 	int count = 0;
 
-	old_val = rmap_head->val;
+	old_val = kvm_rmap_lock(rmap_head);
 
 	if (!old_val) {
 		new_val = (unsigned long)spte;
@@ -900,7 +984,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		desc->sptes[desc->spte_count++] = spte;
 	}
 
-	rmap_head->val = new_val;
+	kvm_rmap_unlock(rmap_head, new_val);
 
 	return count;
 }
@@ -948,7 +1032,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
 		goto out;
 
@@ -974,7 +1058,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	}
 
 out:
-	rmap_head->val = rmap_val;
+	kvm_rmap_unlock(rmap_head, rmap_val);
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -992,7 +1076,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (!rmap_val)
 		return false;
 
@@ -1011,13 +1095,13 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
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
@@ -1083,7 +1167,7 @@ struct rmap_iterator {
 static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
-	unsigned long rmap_val = rmap_head->val;
+	unsigned long rmap_val = kvm_rmap_get(rmap_head);
 	u64 *sptep;
 
 	if (!rmap_val)
@@ -1418,7 +1502,7 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	while (++iterator->rmap <= iterator->end_rmap) {
 		iterator->gfn += KVM_PAGES_PER_HPAGE(iterator->level);
 
-		if (iterator->rmap->val)
+		if (atomic_long_read(&iterator->rmap->val))
 			return;
 	}
 
@@ -2444,7 +2528,8 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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
2.48.1.362.g079036d154-goog


