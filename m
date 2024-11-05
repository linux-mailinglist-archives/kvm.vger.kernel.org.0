Return-Path: <kvm+bounces-30780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76AF19BD53F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:48:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35E5A283D38
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7BD1F76A6;
	Tue,  5 Nov 2024 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dhNl0CTA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE81F6678
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832233; cv=none; b=C4QfrSy5QeurzqBBBzzx8bOTPB051S2lDz7o6naYR7388RX4y0CjbHNopaA/xfRfW2A74Ydc8bYSufFquIB7Yjh0TqCX68Wb9jhm3HBTxAR2Y+FtNT7ieLidOAULyE17OKCoZyHXwoWkFcc8k/Bmx3Hm+aWcY9xnyJsVsx3zqdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832233; c=relaxed/simple;
	bh=xcAjcBrdvWnNDb0k2Wn43m9HQBwOqnf9onULqJo8QpA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VtcVrxr5JkTAXJ+F3EBf/R0gm4KTBPX/FEuN5+KBwf+eReycBEOU0yz7eEI66ryV2DHHG6ovFPPSOCK6Lre3oOjxMVjbIHRsBVXVCh3xpnRJXuTWK/ZBZxBalNgpDAkWPSUHCg8amJqAek3Bn0/7PBvoWOiBG1N9UDFFUAdri+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dhNl0CTA; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e30d7b4205eso9219908276.2
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 10:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730832231; x=1731437031; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=01wePMH4+QHc02SMeyCoSvZeRWpbLNfwimxdT99GW8o=;
        b=dhNl0CTAeC0vgLMM+zN1R4N8FXJIINZVnLJhd+EeBtSyuFZy7FqyOKSQG/7FHYjv9S
         MiREmEYT/YY3kKPU66dOVgrcNkyYPzT2uD9s+pKIKIOa4n9JKXrDfxh8Q9wf9SEb9PTq
         7II3TJQBHTXefXQt4lQVze9dOEgqq1CPzAFMU/XYkfc5Ak5JPGxIbMvfEOnYqNePB/YG
         AZP0t/sSjCUdwNwC/M/kydeZcSV70RBi5GuQOEnVeHZKp+WA7UBgZJYPR6YnJcyR3lB3
         ZIIyu+5gA74cxCNur9wTGpkBalsJp9VDv5bqiAPtWJBaKlb9QBEMNBtANun/qleDSDbO
         /QLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730832231; x=1731437031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=01wePMH4+QHc02SMeyCoSvZeRWpbLNfwimxdT99GW8o=;
        b=eGrBhEH1KoW+Hghu7hDFYxrpM8rKaDSOkqGOMWJqGL0MhsXO1N90jIeYCC1iqV+Fz2
         a1YYYEx4fT50U8n+BHCFv4UVtXXhlhZGcHvzsZzFsT7RJdkdahGFIAqpKs+e6aXuSnkd
         6W1M6rN0qmJyDoWcZFKBiuI1yJbxHiCR062y1001q7MF7wkC8Zya3No+WVU4qjqEDr//
         2Ri8ZqocSJE0LyLHFQ4zLKurzMoho6jNv/B/rmTB9bh/nwYTj9jVzWNWRyqmtFvxik/3
         tgxGn6YTmcjxbPPC7Cl2/LgkdaKv2+3KQkwBkwCJ4rMHJ6piu0tI1+nURv5ePYl8nxdo
         jkoA==
X-Forwarded-Encrypted: i=1; AJvYcCUluhLZJG0pkjGKtVu9XhOx/brY9giDz7psFq31MJWQ+tJTB6+6lVLlBx85KAwGJgm0mFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxybYS+upZoG7FU1P0kmX/yVKxCFkGFjGelD06OSyMI0vvZwsqj
	andZ6EmZP2dkb3Q6N3NqWX6QynTZQLf/UZs8zDhOzoQ3lKy21OVTs/Pz1yNJDYaHdD4Nx/h2UEz
	GAvWflsodKn4Q8RlyTQ==
X-Google-Smtp-Source: AGHT+IGik+DLwPnAj/ZpDJXHf21XyU3PCl7bJk+sYnaFfsbhLbfn2IFNWxplY+ZU6Y8yYe4uBthq2BbYiZhjOB24
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:13d:fb22:ac12:a84b])
 (user=jthoughton job=sendgmr) by 2002:a25:7449:0:b0:e2e:330b:faab with SMTP
 id 3f1490d57ef6-e30e59194c3mr15938276.0.1730832231123; Tue, 05 Nov 2024
 10:43:51 -0800 (PST)
Date: Tue,  5 Nov 2024 18:43:30 +0000
In-Reply-To: <20241105184333.2305744-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
X-Mailer: git-send-email 2.47.0.199.ga7371fff76-goog
Message-ID: <20241105184333.2305744-9-jthoughton@google.com>
Subject: [PATCH v8 08/11] KVM: x86/mmu: Add infrastructure to allow walking
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
 arch/x86/kvm/mmu/mmu.c          | 129 +++++++++++++++++++++++++++++---
 2 files changed, 120 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 84ee08078686..378b87ff5b1f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -26,6 +26,7 @@
 #include <linux/irqbypass.h>
 #include <linux/hyperv.h>
 #include <linux/kfifo.h>
+#include <linux/atomic.h>
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -402,7 +403,7 @@ union kvm_cpu_role {
 };
 
 struct kvm_rmap_head {
-	unsigned long val;
+	atomic_long_t val;
 };
 
 struct kvm_pio_request {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 145ea180963e..1cdb77df0a4d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -847,11 +847,117 @@ static struct kvm_memory_slot *gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu
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
@@ -862,7 +968,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	struct pte_list_desc *desc;
 	int count = 0;
 
-	old_val = rmap_head->val;
+	old_val = kvm_rmap_lock(rmap_head);
 
 	if (!old_val) {
 		new_val = (unsigned long)spte;
@@ -894,7 +1000,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		desc->sptes[desc->spte_count++] = spte;
 	}
 
-	rmap_head->val = new_val;
+	kvm_rmap_unlock(rmap_head, new_val);
 
 	return count;
 }
@@ -942,7 +1048,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (KVM_BUG_ON_DATA_CORRUPTION(!rmap_val, kvm))
 		goto out;
 
@@ -968,7 +1074,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	}
 
 out:
-	rmap_head->val = rmap_val;
+	kvm_rmap_unlock(rmap_head, rmap_val);
 }
 
 static void kvm_zap_one_rmap_spte(struct kvm *kvm,
@@ -986,7 +1092,7 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
 	unsigned long rmap_val;
 	int i;
 
-	rmap_val = rmap_head->val;
+	rmap_val = kvm_rmap_lock(rmap_head);
 	if (!rmap_val)
 		return false;
 
@@ -1005,13 +1111,13 @@ static bool kvm_zap_all_rmap_sptes(struct kvm *kvm,
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
@@ -1077,7 +1183,7 @@ struct rmap_iterator {
 static u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
 			   struct rmap_iterator *iter)
 {
-	unsigned long rmap_val = rmap_head->val;
+	unsigned long rmap_val = kvm_rmap_get(rmap_head);
 	u64 *sptep;
 
 	if (!rmap_val)
@@ -1412,7 +1518,7 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	while (++iterator->rmap <= iterator->end_rmap) {
 		iterator->gfn += KVM_PAGES_PER_HPAGE(iterator->level);
 
-		if (iterator->rmap->val)
+		if (atomic_long_read(&iterator->rmap->val))
 			return;
 	}
 
@@ -2450,7 +2556,8 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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
2.47.0.199.ga7371fff76-goog


