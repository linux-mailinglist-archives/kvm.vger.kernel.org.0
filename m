Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADA3349FAC
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhCZCVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhCZCUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B927C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o9so8231540yba.18
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MPc01z273sWoKotX8Qo0ceeU7wfqOn4djZ7tWO1HqQw=;
        b=oRZN7Er/jTO0JwT0oKSSka1YhWa2PlQIYMpGu92ncg6e1E3YFeTMq/MUwiylTuzqmy
         6szo2kBiPHr7OyPl8HPKwOAgMxv+2EZBT+gM6NfZHo/Y4LQ4pzeXgDuVA6YL7y3+ruFQ
         Pjt5BRi9G0XgHWVYPdHTwgWnr01QQmXF6ndEMk11Jk2C+v5gtkez0qZlxxOpQOTG2am7
         vnXE1P7+7NflNJgvaK22y+ku115V63osmcvdIM8lBUsuZFn7fLFk1uFd5BK+s71loL/L
         y9JtTgFUPEdDwTzXfFq+DRjsA9VSfj7kFsh6laahlqZQf/wdRe2ZRt/5P5n4sxt74mZT
         9CAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MPc01z273sWoKotX8Qo0ceeU7wfqOn4djZ7tWO1HqQw=;
        b=p9qjFS1ADctdBtQ6dRoy/txLF1fAIn9i04o9YfcZtWcNhd5YJPayhjAc86JERmLxpr
         uaYxvT8LfBABy2uXFsaKegd8Ndt33manQChZPToqr6aqEiG54wBpjgLTDLjN5o5qMXjr
         jX5Izwo1R/Ryi9mfpC2cr7H4O74wqxjvcIaRXMH3sTT7viNJZyKmdg7ZunQBxUtCd0UZ
         Qt7Ikq9u9xGP223Ak5eJb+iAl8fmj+xlOr/3erOBry73V8vW4rjCayLXSwEB7aYmfw4q
         FyuR4AxTO6Nhd4mV7Q7iY1re4Jv0yzY8pIeOpTsy1z9gCsUtKD9FfgemD961r+Xj79du
         KiUQ==
X-Gm-Message-State: AOAM531g1cOht7z1bQTkLcy247snWS4rXdh+dFCA9KG9DJn2H2oEqEj4
        QQ813pZHLuTuf8JTIxu0Wri+Nu40qTY=
X-Google-Smtp-Source: ABdhPJxX4MIsUEfB0Uh5/Djl4Kfv52yIB+lxKn2YepBTM+7LrWOGL64erI1hTb+J5ndxOUOKW1qXZZpbd+A=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a05:6902:4e9:: with SMTP id
 w9mr16839298ybs.409.1616725247572; Thu, 25 Mar 2021 19:20:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:55 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation unless necessary
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Avoid taking mmu_lock for unrelated .invalidate_range_{start,end}()
notifications.  Because mmu_notifier_count must be modified while holding
mmu_lock for write, and must always be paired across start->end to stay
balanced, lock elision must happen in both or none.  To meet that
requirement, add a rwsem to prevent memslot updates across range_start()
and range_end().

For notifiers that disallow blocking, e.g. OOM reaping, simply go down
the slow path of unconditionally acquiring mmu_lock.  The sane
alternative would be to try to acquire the lock and force the notifier
to retry on failure.  But since OOM is currently the _only_ scenario
where blocking is disallowed attempting to optimize a guest that has been
marked for death is pointless.

Note, technically flag-only memslot updates could be allowed in parallel,
but stalling a memslot update for a relatively short amount of time is
not a scalability issue, and this is all more than complex enough.

Based heavily on code from Ben Gardon.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |   8 +-
 virt/kvm/kvm_main.c      | 174 ++++++++++++++++++++++++++++++---------
 2 files changed, 142 insertions(+), 40 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 40ac2d40bb5a..2cc0f87d936e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -523,6 +523,7 @@ struct kvm {
 	long mmu_notifier_count;
 	unsigned long mmu_notifier_range_start;
 	unsigned long mmu_notifier_range_end;
+	struct rw_semaphore mmu_notifier_slots_lock;
 #endif
 	long tlbs_dirty;
 	struct list_head devices;
@@ -660,8 +661,11 @@ static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
 	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
 	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
-			lockdep_is_held(&kvm->slots_lock) ||
-			!refcount_read(&kvm->users_count));
+				      lockdep_is_held(&kvm->slots_lock) ||
+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+				      lockdep_is_held(&kvm->mmu_notifier_slots_lock) ||
+#endif
+				      !refcount_read(&kvm->users_count));
 }
 
 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0c2aff8a4aa1..9ebc6d3e4a21 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -453,20 +453,56 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 
 typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
+typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
+			     unsigned long end);
+
 struct kvm_hva_range {
 	unsigned long start;
 	unsigned long end;
 	pte_t pte;
 	hva_handler_t handler;
-	bool caller_locked;
+	on_lock_fn_t on_lock;
+	bool must_lock;
 	bool flush_on_ret;
 	bool may_block;
 };
 
+/*
+ * Use a dedicated stub instead of NULL to indicate that there is no callback
+ * function/handler.  The compiler technically can't guarantee that a real
+ * function will have a non-zero address, and so it will generate code to
+ * check for !NULL, whereas comparing against a stub will be elided at compile
+ * time (unless the compiler is getting long in the tooth, e.g. gcc 4.9).
+ */
+static void kvm_null_fn(void)
+{
+
+}
+#define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
+
+
+/* Acquire mmu_lock if necessary.  Returns %true if @handler is "null" */
+static __always_inline bool kvm_mmu_lock_and_check_handler(struct kvm *kvm,
+							   const struct kvm_hva_range *range,
+							   bool *locked)
+{
+	if (*locked)
+		return false;
+
+	*locked = true;
+
+	KVM_MMU_LOCK(kvm);
+
+	if (!IS_KVM_NULL_FN(range->on_lock))
+		range->on_lock(kvm, range->start, range->end);
+
+	return IS_KVM_NULL_FN(range->handler);
+}
+
 static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 						  const struct kvm_hva_range *range)
 {
-	bool ret = false, locked = range->caller_locked;
+	bool ret = false, locked = false;
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
 	struct kvm_memslots *slots;
@@ -474,6 +510,10 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 
 	idx = srcu_read_lock(&kvm->srcu);
 
+	if (range->must_lock &&
+	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
+		goto out_unlock;
+
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(slot, slots) {
@@ -502,10 +542,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
 
-			if (!locked) {
-				locked = true;
-				KVM_MMU_LOCK(kvm);
-			}
+			if (kvm_mmu_lock_and_check_handler(kvm, range, &locked))
+				goto out_unlock;
+
 			ret |= range->handler(kvm, &gfn_range);
 		}
 	}
@@ -513,7 +552,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
 		kvm_flush_remote_tlbs(kvm);
 
-	if (locked && !range->caller_locked)
+out_unlock:
+	if (locked)
 		KVM_MMU_UNLOCK(kvm);
 
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -534,10 +574,12 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.end		= end,
 		.pte		= pte,
 		.handler	= handler,
-		.caller_locked	= false,
+		.on_lock	= (void *)kvm_null_fn,
+		.must_lock	= false,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
+
 	return __kvm_handle_hva_range(kvm, &range);
 }
 
@@ -552,7 +594,8 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.end		= end,
 		.pte		= __pte(0),
 		.handler	= handler,
-		.caller_locked	= false,
+		.on_lock	= (void *)kvm_null_fn,
+		.must_lock	= false,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
@@ -569,23 +612,9 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
 
-static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
-					const struct mmu_notifier_range *range)
+static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
+				   unsigned long end)
 {
-	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	const struct kvm_hva_range hva_range = {
-		.start		= range->start,
-		.end		= range->end,
-		.pte		= __pte(0),
-		.handler	= kvm_unmap_gfn_range,
-		.caller_locked	= true,
-		.flush_on_ret	= true,
-		.may_block	= mmu_notifier_range_blockable(range),
-	};
-
-	trace_kvm_unmap_hva_range(range->start, range->end);
-
-	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
 	 * spte can be established without taking the mmu_lock and
@@ -593,8 +622,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 */
 	kvm->mmu_notifier_count++;
 	if (likely(kvm->mmu_notifier_count == 1)) {
-		kvm->mmu_notifier_range_start = range->start;
-		kvm->mmu_notifier_range_end = range->end;
+		kvm->mmu_notifier_range_start = start;
+		kvm->mmu_notifier_range_end = end;
 	} else {
 		/*
 		 * Fully tracking multiple concurrent ranges has dimishing
@@ -606,24 +635,54 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		 * complete.
 		 */
 		kvm->mmu_notifier_range_start =
-			min(kvm->mmu_notifier_range_start, range->start);
+			min(kvm->mmu_notifier_range_start, start);
 		kvm->mmu_notifier_range_end =
-			max(kvm->mmu_notifier_range_end, range->end);
+			max(kvm->mmu_notifier_range_end, end);
 	}
-
-	__kvm_handle_hva_range(kvm, &hva_range);
-
-	KVM_MMU_UNLOCK(kvm);
-
-	return 0;
 }
 
-static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
+static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
+	bool blockable = mmu_notifier_range_blockable(range);
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_hva_range hva_range = {
+		.start		= range->start,
+		.end		= range->end,
+		.pte		= __pte(0),
+		.handler	= kvm_unmap_gfn_range,
+		.on_lock	= kvm_inc_notifier_count,
+		.must_lock	= !blockable,
+		.flush_on_ret	= true,
+		.may_block	= blockable,
+	};
 
-	KVM_MMU_LOCK(kvm);
+	trace_kvm_unmap_hva_range(range->start, range->end);
+
+	/*
+	 * Prevent memslot modification between range_start() and range_end()
+	 * so that conditionally locking provides the same result in both
+	 * functions.  Without that guarantee, the mmu_notifier_count
+	 * adjustments will be imbalanced.
+	 *
+	 * Skip the memslot-lookup lock elision (set @must_lock above) to avoid
+	 * having to take the semaphore on non-blockable calls, e.g. OOM kill.
+	 * The complexity required to handle conditional locking for this case
+	 * is not worth the marginal benefits, the VM is likely doomed anyways.
+	 *
+	 * Pairs with the unlock in range_end().
+	 */
+	if (blockable)
+		down_read(&kvm->mmu_notifier_slots_lock);
+
+	__kvm_handle_hva_range(kvm, &hva_range);
+
+	return 0;
+}
+
+static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
+				   unsigned long end)
+{
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -637,7 +696,29 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 	 * in conjunction with the smp_rmb in mmu_notifier_retry().
 	 */
 	kvm->mmu_notifier_count--;
-	KVM_MMU_UNLOCK(kvm);
+}
+
+static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
+					const struct mmu_notifier_range *range)
+{
+	bool blockable = mmu_notifier_range_blockable(range);
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_hva_range hva_range = {
+		.start		= range->start,
+		.end		= range->end,
+		.pte		= __pte(0),
+		.handler	= (void *)kvm_null_fn,
+		.on_lock	= kvm_dec_notifier_count,
+		.must_lock	= !blockable,
+		.flush_on_ret	= true,
+		.may_block	= blockable,
+	};
+
+	__kvm_handle_hva_range(kvm, &hva_range);
+
+	/* Pairs with the lock in range_start(). */
+	if (blockable)
+		up_read(&kvm->mmu_notifier_slots_lock);
 
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
@@ -709,6 +790,8 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
 {
+	init_rwsem(&kvm->mmu_notifier_slots_lock);
+
 	kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
 	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
 }
@@ -971,6 +1054,15 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_coalesced_mmio_free(kvm);
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+	/*
+	 * Reset the lock used to prevent memslot updates between MMU notifier
+	 * range_start and range_end.  At this point no more MMU notifiers will
+	 * run, but the lock could still be held if KVM's notifier was removed
+	 * between range_start and range_end.  No threads can be waiting on the
+	 * lock as the last reference on KVM has been dropped.  If the lock is
+	 * still held, freeing memslots will deadlock.
+	 */
+	init_rwsem(&kvm->mmu_notifier_slots_lock);
 #else
 	kvm_arch_flush_shadow_all(kvm);
 #endif
@@ -1222,7 +1314,13 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+	down_write(&kvm->mmu_notifier_slots_lock);
+#endif
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
+#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
+	up_write(&kvm->mmu_notifier_slots_lock);
+#endif
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	/*
-- 
2.31.0.291.g576ba9dcdaf-goog

