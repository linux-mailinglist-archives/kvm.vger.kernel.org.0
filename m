Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA1A7A2CA8
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbjIPApk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238567AbjIPApT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:45:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0E818E
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81d85aae7cso2246436276.0
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824764; x=1695429564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Cj9kWw04pNJMtISmJeHkwKC2N/5/ZVS25i920GH/+3E=;
        b=rVc8HV2YAqHN13X6dpScqho2WoQPca2aFH6eLGGXY+Ae5rCRsV4kKxt+rAo82psqst
         NeYkQUQjPBvQDw2QnZf5YYwafQ0pYFr3GReIzlR4QADp7/9qBL58LuXt8jd0w6/NoMR0
         jJfjqIkbI4yDlw6oQKlBsZ/ZZBvOmL4RyqJhkMfBuEyJGGbpT632Wb1qOaQPquZz0dqe
         lTzWg5AWnFMZjyJC/NqosIJGSOZsH2etnVynI/zSvSE1T7lenPMZdAwIG+LmPY5bb9u2
         ZsAB9M2FXhGNZS71Qo91QiNbuicj9JioosKEdpBWF6c0fq5xgVC/f+2UBesobV9og5gU
         xkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824764; x=1695429564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cj9kWw04pNJMtISmJeHkwKC2N/5/ZVS25i920GH/+3E=;
        b=P+e2wUPw9eXxq9HwW9cXnz41zw2Tp9xd4uzhIj741qB/LsDFBNa1cw5Oy8i55/vK9d
         4DhYYd7EJnxTDSp9NM9LwuaMDUdVaxLlUnul65Nb+CdcoGKbYlltlbXSuIEuL05nTfun
         ub+F2eLOYm205ahxkrQCXCv1xY4AvuUBncyPKDk2ClO/c9rvzzUcx6ZYxNBSw6CCSzYL
         ujNupiCQPultZFphV/4PDMgLbMH8Dy9QTJhRg4nzvRjUMmMF9DgwajGdDNg8tABW4fS/
         +yZNTqp7cvGocFEVMhttHDpX9NC0m9G97ly7HxzhirNHT9jzvOe2k11lYoOS6yYu7AFz
         Lctg==
X-Gm-Message-State: AOJu0YyiulyFo4CXLJcipxO18+dcsLy/LOL6i4eKJ0DbX1OYCtVNJnLE
        sNP7FtzJjXLIqLUJ+dLG9Dbq8ChGDKw=
X-Google-Smtp-Source: AGHT+IGDu08KgobyXwEGtcWy5d6Zb6nBPRhoIKfuJ257ue472s/YqHrP1KRVeg1nNqD4WezPfWNiCDJlzsc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ab47:0:b0:d7e:78db:d264 with SMTP id
 u65-20020a25ab47000000b00d7e78dbd264mr185764ybi.5.1694824764466; Fri, 15 Sep
 2023 17:39:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:39:16 -0700
In-Reply-To: <20230916003916.2545000-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003916.2545000-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003916.2545000-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86/mmu: Stop zapping invalidated TDP MMU roots asynchronously
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stop zapping invalidate TDP MMU roots via work queue now that KVM
preserves TDP MMU roots until they are explicitly invalidated.  Zapping
roots asynchronously was effectively a workaround to avoid stalling a vCPU
for an extended during if a vCPU unloaded a root, which at the time
happened whenever the guest toggled CR0.WP (a frequent operation for some
guest kernels).

While a clever hack, zapping roots via an unbound worker had subtle,
unintended consequences on host scheduling, especially when zapping
multiple roots, e.g. as part of a memslot.  Because the work of zapping a
root is no longer bound to the task that initiated the zap, things like
the CPU affinity and priority of the original task get lost.  Losing the
affinity and priority can be especially problematic if unbound workqueues
aren't affined to a small number of CPUs, as zapping multiple roots can
cause KVM to heavily utilize the majority of CPUs in the system, *beyond*
the CPUs KVM is already using to run vCPUs.

When deleting a memslot via KVM_SET_USER_MEMORY_REGION, the async root
zap can result in KVM occupying all logical CPUs for ~8ms, and result in
high priority tasks not being scheduled in in a timely manner.  In v5.15,
which doesn't preserve unloaded roots, the issues were even more noticeable
as KVM would zap roots more frequently and could occupy all CPUs for 50ms+.

Consuming all CPUs for an extended duration can lead to significant jitter
throughout the system, e.g. on ChromeOS with virtio-gpu, deleting memslots
is a semi-frequent operation as memslots are deleted and recreated with
different host virtual addresses to react to host GPU drivers allocating
and freeing GPU blobs.  On ChromeOS, the jitter manifests as audio blips
during games due to the audio server's tasks not getting scheduled in
promptly, despite the tasks having a high realtime priority.

Deleting memslots isn't exactly a fast path and should be avoided when
possible, and ChromeOS is working towards utilizing MAP_FIXED to avoid the
memslot shenanigans, but KVM is squarely in the wrong.  Not to mention
that removing the async zapping eliminates a non-trivial amount of
complexity.

Note, one of the subtle behaviors hidden behind the async zapping is that
KVM would zap invalidated roots only once (ignoring partial zaps from
things like mmu_notifier events).  Preserve this behavior by adding a flag
to identify roots that are scheduled to be zapped versus roots that have
already been zapped but not yet freed.

Add a comment calling out why kvm_tdp_mmu_invalidate_all_roots() can
encounter invalid roots, as it's not at all obvious why zapping
invalidated roots shouldn't simply zap all invalid roots.

Reported-by: Pattara Teerapong <pteerapong@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Yiwei Zhang<zzyiwei@google.com>
Cc: Paul Hsia <paulhsia@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/kvm/mmu/mmu.c          |  13 +---
 arch/x86/kvm/mmu/mmu_internal.h |  13 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 116 +++++++++++++-------------------
 arch/x86/kvm/mmu/tdp_mmu.h      |   2 +-
 arch/x86/kvm/x86.c              |   5 +-
 6 files changed, 59 insertions(+), 93 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..17715cb8731d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1419,7 +1419,6 @@ struct kvm_arch {
 	 * the thread holds the MMU lock in write mode.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
-	struct workqueue_struct *tdp_mmu_zap_wq;
 #endif /* CONFIG_X86_64 */
 
 	/*
@@ -1835,7 +1834,7 @@ void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_mmu_create(struct kvm_vcpu *vcpu);
-int kvm_mmu_init_vm(struct kvm *kvm);
+void kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 54f94f644b42..f7901cb4d2fa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6167,20 +6167,15 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
-int kvm_mmu_init_vm(struct kvm *kvm)
+void kvm_mmu_init_vm(struct kvm *kvm)
 {
-	int r;
-
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
 	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
 
-	if (tdp_mmu_enabled) {
-		r = kvm_mmu_init_tdp_mmu(kvm);
-		if (r < 0)
-			return r;
-	}
+	if (tdp_mmu_enabled)
+		kvm_mmu_init_tdp_mmu(kvm);
 
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
@@ -6189,8 +6184,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
-
-	return 0;
 }
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b102014e2c60..93b9d50c24ad 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -58,7 +58,10 @@ struct kvm_mmu_page {
 
 	bool tdp_mmu_page;
 	bool unsync;
-	u8 mmu_valid_gen;
+	union {
+		u8 mmu_valid_gen;
+		bool tdp_mmu_scheduled_root_to_zap;
+	};
 
 	 /*
 	  * The shadow page can't be replaced by an equivalent huge page
@@ -100,13 +103,7 @@ struct kvm_mmu_page {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
 	};
-	union {
-		DECLARE_BITMAP(unsync_child_bitmap, 512);
-		struct {
-			struct work_struct tdp_mmu_async_work;
-			void *tdp_mmu_async_data;
-		};
-	};
+	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 	/*
 	 * Tracks shadow pages that, if zapped, would allow KVM to create an NX
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7cb1902ae032..ca3304c2c00c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -12,18 +12,10 @@
 #include <trace/events/kvm.h>
 
 /* Initializes the TDP MMU for the VM, if enabled. */
-int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
+void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
-	struct workqueue_struct *wq;
-
-	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
-	if (!wq)
-		return -ENOMEM;
-
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
-	kvm->arch.tdp_mmu_zap_wq = wq;
-	return 1;
 }
 
 /* Arbitrarily returns true so that this may be used in if statements. */
@@ -46,20 +38,15 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	 * ultimately frees all roots.
 	 */
 	kvm_tdp_mmu_invalidate_all_roots(kvm);
-
-	/*
-	 * Destroying a workqueue also first flushes the workqueue, i.e. no
-	 * need to invoke kvm_tdp_mmu_zap_invalidated_roots().
-	 */
-	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
+	kvm_tdp_mmu_zap_invalidated_roots(kvm);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
 	 * Ensure that all the outstanding RCU callbacks to free shadow pages
-	 * can run before the VM is torn down.  Work items on tdp_mmu_zap_wq
-	 * can call kvm_tdp_mmu_put_root and create new callbacks.
+	 * can run before the VM is torn down.  Putting the last reference to
+	 * zapped roots will create new callbacks.
 	 */
 	rcu_barrier();
 }
@@ -89,43 +76,6 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			     bool shared);
 
-static void tdp_mmu_zap_root_work(struct work_struct *work)
-{
-	struct kvm_mmu_page *root = container_of(work, struct kvm_mmu_page,
-						 tdp_mmu_async_work);
-	struct kvm *kvm = root->tdp_mmu_async_data;
-
-	read_lock(&kvm->mmu_lock);
-
-	/*
-	 * A TLB flush is not necessary as KVM performs a local TLB flush when
-	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
-	 * to a different pCPU.  Note, the local TLB flush on reuse also
-	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
-	 * intermediate paging structures, that may be zapped, as such entries
-	 * are associated with the ASID on both VMX and SVM.
-	 */
-	tdp_mmu_zap_root(kvm, root, true);
-
-	/*
-	 * Drop the refcount using kvm_tdp_mmu_put_root() to test its logic for
-	 * avoiding an infinite loop.  By design, the root is reachable while
-	 * it's being asynchronously zapped, thus a different task can put its
-	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for an
-	 * asynchronously zapped root is unavoidable.
-	 */
-	kvm_tdp_mmu_put_root(kvm, root, true);
-
-	read_unlock(&kvm->mmu_lock);
-}
-
-static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root)
-{
-	root->tdp_mmu_async_data = kvm;
-	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
-	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
-}
-
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -917,18 +867,47 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
+	struct kvm_mmu_page *root;
+
+	read_lock(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
+		if (!root->tdp_mmu_scheduled_root_to_zap)
+			continue;
+
+		root->tdp_mmu_scheduled_root_to_zap = false;
+		KVM_BUG_ON(!root->role.invalid, kvm);
+
+		/*
+		 * A TLB flush is not necessary as KVM performs a local TLB
+		 * flush when allocating a new root (see kvm_mmu_load()), and
+		 * when migrating a vCPU to a different pCPU.  Note, the local
+		 * TLB flush on reuse also invalidates paging-structure-cache
+		 * entries, i.e. TLB entries for intermediate paging structures,
+		 * that may be zapped, as such entries are associated with the
+		 * ASID on both VMX and SVM.
+		 */
+		tdp_mmu_zap_root(kvm, root, true);
+
+		/*
+		 * The referenced needs to be put *after* zapping the root, as
+		 * the root must be reachable by mmu_notifiers while it's being
+		 * zapped
+		 */
+		kvm_tdp_mmu_put_root(kvm, root, true);
+	}
+
+	read_unlock(&kvm->mmu_lock);
 }
 
 /*
  * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
  * is about to be zapped, e.g. in response to a memslots update.  The actual
- * zapping is performed asynchronously.  Using a separate workqueue makes it
- * easy to ensure that the destruction is performed before the "fast zap"
- * completes, without keeping a separate list of invalidated roots; the list is
- * effectively the list of work items in the workqueue.
+ * zapping is done separately so that it happens with mmu_lock with read,
+ * whereas invalidating roots must be done with mmu_lock held for write (unless
+ * the VM is being destroyed).
  *
- * Note, the asynchronous worker is gifted the TDP MMU's reference.
+ * Note, kvm_tdp_mmu_zap_invalidated_roots() is gifted the TDP MMU's reference.
  * See kvm_tdp_mmu_get_vcpu_root_hpa().
  */
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
@@ -953,19 +932,20 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	/*
 	 * As above, mmu_lock isn't held when destroying the VM!  There can't
 	 * be other references to @kvm, i.e. nothing else can invalidate roots
-	 * or be consuming roots, but walking the list of roots does need to be
-	 * guarded against roots being deleted by the asynchronous zap worker.
+	 * or get/put references to roots.
 	 */
-	rcu_read_lock();
-
-	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		/*
+		 * Note, invalid roots can outlive a memslot update!  Invalid
+		 * roots must be *zapped* before the memslot update completes,
+		 * but a different task can acquire a reference and keep the
+		 * root alive after its been zapped.
+		 */
 		if (!root->role.invalid) {
+			root->tdp_mmu_scheduled_root_to_zap = true;
 			root->role.invalid = true;
-			tdp_mmu_schedule_zap_root(kvm, root);
 		}
 	}
-
-	rcu_read_unlock();
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bc088953f929..733a3aef3a96 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -7,7 +7,7 @@
 
 #include "spte.h"
 
-int kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..9f18b06bbda6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12308,9 +12308,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out;
 
-	ret = kvm_mmu_init_vm(kvm);
-	if (ret)
-		goto out_page_track;
+	kvm_mmu_init_vm(kvm);
 
 	ret = static_call(kvm_x86_vm_init)(kvm);
 	if (ret)
@@ -12355,7 +12353,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 out_uninit_mmu:
 	kvm_mmu_uninit_vm(kvm);
-out_page_track:
 	kvm_page_track_cleanup(kvm);
 out:
 	return ret;
-- 
2.42.0.459.ge4e396fd5e-goog

