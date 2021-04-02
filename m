Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FC23524DC
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhDBA5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234043AbhDBA52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8489C061794
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y13so7578163ybk.20
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=C3aZnevHleE8p3XJKln/4r7iVsuYY+IWqHwKw7jbYZw=;
        b=rqAz0oKwg+xO+mqrd/TjAqHUu8EArbD/uuJGl7OKeBcY3EwrHR9gQRQe0GvHDQcbO1
         TIhniaZ8jINCps9CIjZsN7kHjzSXtmyQjArZQoJmr6yXjaYfIPpYiVrCT4HaPfh1j2yx
         1mTrVvzXlMCQhkTCOXnrqYezeg2n0qnNstVACti7MGtSCc7Mn0xeApxKkkFdybx8Qwa4
         dW6zby8GfzrKIHI+e4hSp5xu7wY/rLusRKL8ViD/EbLaC7KG2YECDq4QlOssGCHrxNP9
         wgUVLhXlSm+YIFfm/2xqy0d1HCwgoyoWZ78lO5MGEaw+LGDqY6eZwfL3ZC4K6ZeIge1Z
         H4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=C3aZnevHleE8p3XJKln/4r7iVsuYY+IWqHwKw7jbYZw=;
        b=ZQVSDhcTZo50urpagShSgpMphSgaceoylDH5eR8FEkKG288g4UeePOYCxLwnfxuFtz
         6P2xOZJnUi1dXsziZLQFKTxQxIcOr/VnzmN5jPp6WQcYzaiOdHm9Fy5hd+50wAEerpfD
         MmwVi8A+gtho2OxWrD26fQIAg/2ZJ1DOT1/hRpvdJx41+ZL9u2lYamwzIbK1CSJjfk0W
         tfIBWvloJzpVMHedKj4N6eDzfcZV7XYnQkalR0J9PwRunlVXFHgQUBqSDa3cQyIwfJfO
         J9dbFedffEx1tMgs2FiogGrPAp5NqL5U5eZuy1etMyU7a3zbwvkvfSbDq5bewZ8Knich
         7GnA==
X-Gm-Message-State: AOAM531qyoXeCUqpBD5Idl9PUyflk8RcZH+3y4ecZ/zWS0BX0p339h2A
        44oGBrWNaeDv47INqZw/Mr8yH48C6CY=
X-Google-Smtp-Source: ABdhPJwqtEf1xCZRZlu0eDHw+f5rnx5wV3GYiZnH8BaCyZHgsIqWaN0RCtqefaVKt0oXIFZucaajI8x4kac=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:a25:74d2:: with SMTP id p201mr16376013ybc.406.1617325041100;
 Thu, 01 Apr 2021 17:57:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:57 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
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

Use a rwsem instead of a rwlock since most notifiers _allow_ blocking,
and the lock will be endl across the entire start() ... end() sequence.
If anything in the sequence sleeps, including the caller or a different
notifier, holding the spinlock would be disastrous.

For notifiers that _disallow_ blocking, e.g. OOM reaping, simply go down
the slow path of unconditionally acquiring mmu_lock.  The sane
alternative would be to try to acquire the lock and force the notifier
to retry on failure.  But since OOM is currently the _only_ scenario
where blocking is disallowed attempting to optimize a guest that has been
marked for death is pointless.

Unconditionally define and use mmu_notifier_slots_lock in the memslots
code, purely to avoid more #ifdefs.  The overhead of acquiring the lock
is negligible when the lock is uncontested, which will always be the case
when the MMU notifiers are not used.

Note, technically flag-only memslot updates could be allowed in parallel,
but stalling a memslot update for a relatively short amount of time is
not a scalability issue, and this is all more than complex enough.

Based heavily on code from Ben Gardon.

Suggested-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  6 ++-
 virt/kvm/kvm_main.c      | 96 +++++++++++++++++++++++++++++++---------
 2 files changed, 80 insertions(+), 22 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 40ac2d40bb5a..bc3dd2838bb8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -472,6 +472,7 @@ struct kvm {
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 	struct mutex slots_lock;
+	struct rw_semaphore mmu_notifier_slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
@@ -660,8 +661,9 @@ static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
 	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
 	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
-			lockdep_is_held(&kvm->slots_lock) ||
-			!refcount_read(&kvm->users_count));
+				      lockdep_is_held(&kvm->slots_lock) ||
+				      lockdep_is_held(&kvm->mmu_notifier_slots_lock) ||
+				      !refcount_read(&kvm->users_count));
 }
 
 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f6697ad741ed..af28f39817a5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -462,6 +462,7 @@ struct kvm_hva_range {
 	pte_t pte;
 	hva_handler_t handler;
 	on_lock_fn_t on_lock;
+	bool must_lock;
 	bool flush_on_ret;
 	bool may_block;
 };
@@ -479,6 +480,25 @@ static void kvm_null_fn(void)
 }
 #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
 
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
@@ -495,16 +515,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 
 	idx = srcu_read_lock(&kvm->srcu);
 
-	/* The on_lock() path does not yet support lock elision. */
-	if (!IS_KVM_NULL_FN(range->on_lock)) {
-		locked = true;
-		KVM_MMU_LOCK(kvm);
-
-		range->on_lock(kvm, range->start, range->end);
-
-		if (IS_KVM_NULL_FN(range->handler))
-			goto out_unlock;
-	}
+	if (range->must_lock &&
+	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
+		goto out_unlock;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
@@ -534,10 +547,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
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
@@ -568,6 +580,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.pte		= pte,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.must_lock	= false,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
@@ -587,6 +600,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.pte		= __pte(0),
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.must_lock	= false,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
@@ -603,11 +617,15 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	trace_kvm_set_spte_hva(address);
 
 	/*
-	 * .change_pte() must be bookended by .invalidate_range_{start,end}(),
-	 * and so always runs with an elevated notifier count.  This obviates
-	 * the need to bump the sequence count.
+	 * .change_pte() must be bookended by .invalidate_range_{start,end}().
+	 * If mmu_notifier_count is zero, then start() didn't find a relevant
+	 * memslot and wasn't forced down the slow path; rechecking here is
+	 * unnecessary.  This can only occur if memslot updates are blocked.
 	 */
-	WARN_ON_ONCE(!kvm->mmu_notifier_count);
+	if (!kvm->mmu_notifier_count) {
+		lockdep_assert_held(&kvm->mmu_notifier_slots_lock);
+		return;
+	}
 
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
@@ -644,6 +662,7 @@ static void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
+	bool blockable = mmu_notifier_range_blockable(range);
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
@@ -651,12 +670,29 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.pte		= __pte(0),
 		.handler	= kvm_unmap_gfn_range,
 		.on_lock	= kvm_inc_notifier_count,
+		.must_lock	= !blockable,
 		.flush_on_ret	= true,
-		.may_block	= mmu_notifier_range_blockable(range),
+		.may_block	= blockable,
 	};
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
 
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
 	__kvm_handle_hva_range(kvm, &hva_range);
 
 	return 0;
@@ -683,6 +719,7 @@ static void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
 static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
+	bool blockable = mmu_notifier_range_blockable(range);
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	const struct kvm_hva_range hva_range = {
 		.start		= range->start,
@@ -690,12 +727,17 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.pte		= __pte(0),
 		.handler	= (void *)kvm_null_fn,
 		.on_lock	= kvm_dec_notifier_count,
+		.must_lock	= !blockable,
 		.flush_on_ret	= true,
-		.may_block	= mmu_notifier_range_blockable(range),
+		.may_block	= blockable,
 	};
 
 	__kvm_handle_hva_range(kvm, &hva_range);
 
+	/* Pairs with the lock in range_start(). */
+	if (blockable)
+		up_read(&kvm->mmu_notifier_slots_lock);
+
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
 
@@ -908,6 +950,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
+	init_rwsem(&kvm->mmu_notifier_slots_lock);
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -1028,6 +1071,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_coalesced_mmio_free(kvm);
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+	/*
+	 * Reset the lock used to prevent memslot updates between MMU notifier
+	 * invalidate_range_start() and invalidate_range_end().  At this point,
+	 * no more MMU notifiers will run and pending calls to ...start() have
+	 * completed.  But, the lock could still be held if KVM's notifier was
+	 * removed between ...start() and ...end().  No threads can be waiting
+	 * on the lock as the last reference on KVM has been dropped.  If the
+	 * lock is still held, freeing memslots will deadlock.
+	 */
+	init_rwsem(&kvm->mmu_notifier_slots_lock);
 #else
 	kvm_arch_flush_shadow_all(kvm);
 #endif
@@ -1279,7 +1332,10 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
+	down_write(&kvm->mmu_notifier_slots_lock);
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
+	up_write(&kvm->mmu_notifier_slots_lock);
+
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	/*
-- 
2.31.0.208.g409f899ff0-goog

