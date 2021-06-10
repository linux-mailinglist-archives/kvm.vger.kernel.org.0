Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48863A2B0B
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFJMIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:08:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230343AbhFJMIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623326783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jl9kawmuXJHQDXlliaeVf+5NhkAChMTRODp32/eFII4=;
        b=XKFZLYLCGqDGjR6mcW+l1wQXS6eaLAaSdORSeijJGhj00Pg8WdPyqughW5NZQmX2t2WBRd
        drygHaz2VB/z8YBh3HwDcrs82jDnjaUacB/1IM8GUvfqOPP1uu2gFEpKlk6Zdp24p3TL+Q
        73eX6gBiVC/Lb8TPWDeQAgcVCbupX0U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-Yk0pAoa5Oq-amFcH9KDXDw-1; Thu, 10 Jun 2021 08:06:18 -0400
X-MC-Unique: Yk0pAoa5Oq-amFcH9KDXDw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 766D1C73A0;
        Thu, 10 Jun 2021 12:06:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 158EE19D7C;
        Thu, 10 Jun 2021 12:06:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, bgardon@google.com
Subject: [PATCH 1/2] KVM: Block memslot updates across range_start() and range_end()
Date:   Thu, 10 Jun 2021 08:06:14 -0400
Message-Id: <20210610120615.172224-2-pbonzini@redhat.com>
In-Reply-To: <20210610120615.172224-1-pbonzini@redhat.com>
References: <20210610120615.172224-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We would like to avoid taking mmu_lock for .invalidate_range_{start,end}()
notifications that are unrelated to KVM.  Because mmu_notifier_count
must be modified while holding mmu_lock for write, and must always
be paired across start->end to stay balanced, lock elision must
happen in both or none.  Therefore, in preparation for this change,
this patch prevents memslot updates across range_start() and range_end().

Note, technically flag-only memslot updates could be allowed in parallel,
but stalling a memslot update for a relatively short amount of time is
not a scalability issue, and this is all more than complex enough.

A long note on the locking: a previous version of the patch used an rwsem
to block the memslot update while the MMU notifier run, but this resulted
in the following deadlock involving the pseudo-lock tagged as
"mmu_notifier_invalidate_range_start".

   ======================================================
   WARNING: possible circular locking dependency detected
   5.12.0-rc3+ #6 Tainted: G           OE
   ------------------------------------------------------
   qemu-system-x86/3069 is trying to acquire lock:
   ffffffff9c775ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}, at: __mmu_notifier_invalidate_range_end+0x5/0x190

   but task is already holding lock:
   ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}, at: kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

   which lock already depends on the new lock.

This corresponds to the following MMU notifier logic:

    invalidate_range_start
      take pseudo lock
      down_read()           (*)
      release pseudo lock
    invalidate_range_end
      take pseudo lock      (**)
      up_read()
      release pseudo lock

At point (*) we take the mmu_notifiers_slots_lock inside the pseudo lock;
at point (**) we take the pseudo lock inside the mmu_notifiers_slots_lock.

This could cause a deadlock (ignoring for a second that the pseudo lock
is not a lock):

- invalidate_range_start waits on down_read(), because the rwsem is
held by install_new_memslots

- install_new_memslots waits on down_write(), because the rwsem is
held till (another) invalidate_range_end finishes

- invalidate_range_end sits waits on the pseudo lock, held by
invalidate_range_start.

Removing the fairness of the rwsem breaks the cycle (in lockdep terms,
it would change the *shared* rwsem readers into *shared recursive*
readers), so open-code the wait using a readers count and a
spinlock.  This also allows handling blockable and non-blockable
critical section in the same way.

Losing the rwsem fairness does theoretically allow MMU notifiers to
block install_new_memslots forever.  Note that mm/mmu_notifier.c's own
retry scheme in mmu_interval_read_begin also uses wait/wake_up
and is likewise not fair.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst |  6 +++
 include/linux/kvm_host.h           | 10 ++++-
 virt/kvm/kvm_main.c                | 61 ++++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 35eca377543d..8138201efb09 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -21,6 +21,12 @@ The acquisition orders for mutexes are as follows:
   can be taken inside a kvm->srcu read-side critical section,
   while kvm->slots_lock cannot.
 
+- kvm->mn_active_invalidate_count ensures that pairs of
+  invalidate_range_start() and invalidate_range_end() callbacks
+  use the same memslots array.  kvm->slots_lock and kvm->slots_arch_lock
+  are taken on the waiting side in install_new_memslots, so MMU notifiers
+  must not take either kvm->slots_lock or kvm->slots_arch_lock.
+
 On x86:
 
 - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 11b9b11a5e9b..82bd62cf45d3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -536,6 +536,11 @@ struct kvm {
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
+	/* Used to wait for completion of MMU notifiers.  */
+	spinlock_t mn_invalidate_lock;
+	unsigned long mn_active_invalidate_count;
+	struct rcuwait mn_memslots_update_rcuwait;
+
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
 	 * at the beginning of KVM_CREATE_VCPU.  online_vcpus is only
@@ -721,8 +726,9 @@ static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
 {
 	as_id = array_index_nospec(as_id, KVM_ADDRESS_SPACE_NUM);
 	return srcu_dereference_check(kvm->memslots[as_id], &kvm->srcu,
-			lockdep_is_held(&kvm->slots_lock) ||
-			!refcount_read(&kvm->users_count));
+				      lockdep_is_held(&kvm->slots_lock) ||
+				      READ_ONCE(kvm->mn_active_invalidate_count) ||
+				      !refcount_read(&kvm->users_count));
 }
 
 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fa7e7ebefc79..0dc0726c8d18 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -605,10 +605,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 	/*
 	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),
-	 * and so always runs with an elevated notifier count.  This obviates
-	 * the need to bump the sequence count.
+	 * If mmu_notifier_count is zero, then start() didn't find a relevant
+	 * memslot and wasn't forced down the slow path; rechecking here is
+	 * unnecessary.
 	 */
-	WARN_ON_ONCE(!kvm->mmu_notifier_count);
+	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+	if (!kvm->mmu_notifier_count)
+		return;
 
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
@@ -658,6 +661,18 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
 
+	/*
+	 * Prevent memslot modification between range_start() and range_end()
+	 * so that conditionally locking provides the same result in both
+	 * functions.  Without that guarantee, the mmu_notifier_count
+	 * adjustments will be imbalanced.
+	 *
+	 * Pairs with the decrement in range_end().
+	 */
+	spin_lock(&kvm->mn_invalidate_lock);
+	kvm->mn_active_invalidate_count++;
+	spin_unlock(&kvm->mn_invalidate_lock);
+
 	__kvm_handle_hva_range(kvm, &hva_range);
 
 	return 0;
@@ -694,9 +709,22 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
+	bool wake;
 
 	__kvm_handle_hva_range(kvm, &hva_range);
 
+	/* Pairs with the increment in range_start(). */
+	spin_lock(&kvm->mn_invalidate_lock);
+	wake = (--kvm->mn_active_invalidate_count == 0);
+	spin_unlock(&kvm->mn_invalidate_lock);
+
+	/*
+	 * There can only be one waiter, since the wait happens under
+	 * slots_lock.
+	 */
+	if (wake)
+		rcuwait_wake_up(&kvm->mn_memslots_update_rcuwait);
+
 	BUG_ON(kvm->mmu_notifier_count < 0);
 }
 
@@ -910,6 +938,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	mutex_init(&kvm->slots_arch_lock);
+	spin_lock_init(&kvm->mn_invalidate_lock);
+	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
+
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -1030,6 +1061,16 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_coalesced_mmio_free(kvm);
 #if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+	/*
+	 * At this point, pending calls to invalidate_range_start()
+	 * have completed but no more MMU notifiers will run, so
+	 * mn_active_invalidate_count may remain unbalanced.
+	 * No threads can be waiting in install_new_memslots as the
+	 * last reference on KVM has been dropped, but freeing
+	 * memslots would deadlock without this manual intervention.
+	 */
+	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
+	kvm->mn_active_invalidate_count = 0;
 #else
 	kvm_arch_flush_shadow_all(kvm);
 #endif
@@ -1281,7 +1322,21 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
+	/*
+	 * Do not store the new memslots while there are invalidations in
+	 * progress (preparatory change for the next commit).
+	 */
+	spin_lock(&kvm->mn_invalidate_lock);
+	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
+	while (kvm->mn_active_invalidate_count) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		spin_unlock(&kvm->mn_invalidate_lock);
+		schedule();
+		spin_lock(&kvm->mn_invalidate_lock);
+	}
+	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
+	spin_unlock(&kvm->mn_invalidate_lock);
 
 	/*
 	 * Acquired in kvm_set_memslot. Must be released before synchronize
-- 
2.27.0


