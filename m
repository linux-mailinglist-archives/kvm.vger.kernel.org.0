Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03454CC63A
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiCCTks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiCCTkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3064C19F476
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iy/jaUvnd38iJrWQOt6A9klmdFb114INM7xfw+WzAXw=;
        b=FGwp6e98Xegm83sPP83CBMsZqpCTvweHQrqsVgniBbl16w7E+lOWgRObAoMoYYtJuU9qA6
        8TIxTYc8fqWg2JExdldZcFatrXJ96cFW/qBP884LY1/W54+p7ee21hDFkBsTbEc8T7FUft
        suKuQrw97RoVipX8HN8qsrkzgsjb7SU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-_t3vHPKFOa6T5DNF6mCRtw-1; Thu, 03 Mar 2022 14:39:14 -0500
X-MC-Unique: _t3vHPKFOa6T5DNF6mCRtw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9529651F4;
        Thu,  3 Mar 2022 19:39:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1F865FC22;
        Thu,  3 Mar 2022 19:39:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via asynchronous worker
Date:   Thu,  3 Mar 2022 14:38:33 -0500
Message-Id: <20220303193842.370645-22-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the system work queue also for roots invalidated by the TDP MMU's
"fast zap" mechanism implemented by kvm_tdp_mmu_invalidate_all_roots().
Currently this is done by kvm_tdp_mmu_zap_invalidated_roots(), but
there is no need to duplicate the code between the "normal"
kvm_tdp_mmu_put_root() path and the invalidation case.  The
only issue is that kvm_tdp_mmu_invalidate_all_roots() now
assumes that there is at least one reference in kvm->users_count;
so if the VM is dying just go through the slow path, as there is
nothing to gain by using the fast zapping.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu/mmu.c          |   6 +-
 arch/x86/kvm/mmu/mmu_internal.h |   8 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 158 +++++++++++++++-----------------
 4 files changed, 86 insertions(+), 88 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c45ab8b5c37f..fd05ad52b65c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -15,6 +15,7 @@
 #include <linux/cpumask.h>
 #include <linux/irq_work.h>
 #include <linux/irq.h>
+#include <linux/workqueue.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -1218,6 +1219,7 @@ struct kvm_arch {
 	 * the thread holds the MMU lock in write mode.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+	struct workqueue_struct *tdp_mmu_zap_wq;
 #endif /* CONFIG_X86_64 */
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0b88592495f8..9287ee078c49 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5730,7 +5730,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_FREE_OBSOLETE_ROOTS);
 
 	kvm_zap_obsolete_pages(kvm);
-
 	write_unlock(&kvm->mmu_lock);
 
 	/*
@@ -5741,11 +5740,8 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 * Deferring the zap until the final reference to the root is put would
 	 * lead to use-after-free.
 	 */
-	if (is_tdp_mmu_enabled(kvm)) {
-		read_lock(&kvm->mmu_lock);
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
-		read_unlock(&kvm->mmu_lock);
-	}
 }
 
 static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index be063b6c91b7..1bff453f7cbe 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,13 @@ struct kvm_mmu_page {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
 	};
-	DECLARE_BITMAP(unsync_child_bitmap, 512);
+	union {
+		DECLARE_BITMAP(unsync_child_bitmap, 512);
+		struct {
+			struct work_struct tdp_mmu_async_work;
+			void *tdp_mmu_async_data;
+		};
+	};
 
 	struct list_head lpage_disallowed_link;
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5038de0c872d..ed1bb63b342d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -25,6 +25,8 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
+	kvm->arch.tdp_mmu_zap_wq =
+		alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 
 	return true;
 }
@@ -49,11 +51,15 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
+	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
+
 	/*
 	 * Ensure that all the outstanding RCU callbacks to free shadow pages
-	 * can run before the VM is torn down.
+	 * can run before the VM is torn down.  Work items on tdp_mmu_zap_wq
+	 * can call kvm_tdp_mmu_put_root and create new callbacks.
 	 */
 	rcu_barrier();
+	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 }
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
@@ -81,6 +87,53 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			     bool shared);
 
+static void tdp_mmu_zap_root_work(struct work_struct *work)
+{
+	struct kvm_mmu_page *root = container_of(work, struct kvm_mmu_page,
+						 tdp_mmu_async_work);
+	struct kvm *kvm = root->tdp_mmu_async_data;
+
+	read_lock(&kvm->mmu_lock);
+
+	/*
+	 * A TLB flush is not necessary as KVM performs a local TLB flush when
+	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
+	 * to a different pCPU.  Note, the local TLB flush on reuse also
+	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
+	 * intermediate paging structures, that may be zapped, as such entries
+	 * are associated with the ASID on both VMX and SVM.
+	 */
+	tdp_mmu_zap_root(kvm, root, true);
+
+	/*
+	 * Drop the refcount using kvm_tdp_mmu_put_root() to test its logic for
+	 * avoiding an infinite loop.  By design, the root is reachable while
+	 * it's being asynchronously zapped, thus a different task can put its
+	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for an
+	 * asynchronously zapped root is unavoidable.
+	 */
+	kvm_tdp_mmu_put_root(kvm, root, true);
+
+	read_unlock(&kvm->mmu_lock);
+}
+
+static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root)
+{
+	root->tdp_mmu_async_data = kvm;
+	INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_work);
+	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
+}
+
+static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
+{
+	union kvm_mmu_page_role role = page->role;
+	role.invalid = true;
+
+	/* No need to use cmpxchg, only the invalid bit can change.  */
+	role.word = xchg(&page->role.word, role.word);
+	return role.invalid;
+}
+
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -892,6 +945,13 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	int i;
 
 	/*
+	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
+	 * before returning to the caller.  Zap directly even if the root is
+	 * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
+	 * all that expensive and mmu_lock is already held, which means the
+	 * worker has yielded, i.e. flushing the work instead of zapping here
+	 * isn't guaranteed to be any faster.
+	 *
 	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
 	 * KVM_RUN is unreachable, i.e. no vCPUs will ever service the request.
@@ -902,96 +962,28 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	}
 }
 
-static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
-						  struct kvm_mmu_page *prev_root)
-{
-	struct kvm_mmu_page *next_root;
-
-	if (prev_root)
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &prev_root->link,
-						  typeof(*prev_root), link);
-	else
-		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						   typeof(*next_root), link);
-
-	while (next_root && !(next_root->role.invalid &&
-			      refcount_read(&next_root->tdp_mmu_root_count)))
-		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
-						  &next_root->link,
-						  typeof(*next_root), link);
-
-	return next_root;
-}
-
 /*
  * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
- * zap" completes.  Since kvm_tdp_mmu_invalidate_all_roots() has acquired a
- * reference to each invalidated root, roots will not be freed until after this
- * function drops the gifted reference, e.g. so that vCPUs don't get stuck with
- * tearing down paging structures.
+ * zap" completes.
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	struct kvm_mmu_page *next_root;
-	struct kvm_mmu_page *root;
-
-	lockdep_assert_held_read(&kvm->mmu_lock);
-
-	rcu_read_lock();
-
-	root = next_invalidated_root(kvm, NULL);
-
-	while (root) {
-		next_root = next_invalidated_root(kvm, root);
-
-		rcu_read_unlock();
-
-		/*
-		 * A TLB flush is unnecessary, invalidated roots are guaranteed
-		 * to be unreachable by the guest (see kvm_tdp_mmu_put_root()
-		 * for more details), and unlike the legacy MMU, no vCPU kick
-		 * is needed to play nice with lockless shadow walks as the TDP
-		 * MMU protects its paging structures via RCU.  Note, zapping
-		 * will still flush on yield, but that's a minor performance
-		 * blip and not a functional issue.
-		 */
-		tdp_mmu_zap_root(kvm, root, true);
-
-		/*
-		 * Put the reference acquired in
-		 * kvm_tdp_mmu_invalidate_roots
-		 */
-		kvm_tdp_mmu_put_root(kvm, root, true);
-
-		root = next_root;
-
-		rcu_read_lock();
-	}
-
-	rcu_read_unlock();
+	flush_workqueue(kvm->arch.tdp_mmu_zap_wq);
 }
 
 /*
  * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
- * is about to be zapped, e.g. in response to a memslots update.  The caller is
- * responsible for invoking kvm_tdp_mmu_zap_invalidated_roots() to do the actual
- * zapping.
- *
- * Take a reference on all roots to prevent the root from being freed before it
- * is zapped by this thread.  Freeing a root is not a correctness issue, but if
- * a vCPU drops the last reference to a root prior to the root being zapped, it
- * will get stuck with tearing down the entire paging structure.
+ * is about to be zapped, e.g. in response to a memslots update.  The actual
+ * zapping is performed asynchronously, so a reference is taken on all roots.
+ * Using a separate workqueue makes it easy to ensure that the destruction is
+ * performed before the "fast zap" completes, without keeping a separate list
+ * of invalidated roots; the list is effectively the list of work items in
+ * the workqueue.
  *
- * Get a reference even if the root is already invalid,
- * kvm_tdp_mmu_zap_invalidated_roots() assumes it was gifted a reference to all
- * invalid roots, e.g. there's no epoch to identify roots that were invalidated
- * by a previous call.  Roots stay on the list until the last reference is
- * dropped, so even though all invalid roots are zapped, a root may not go away
- * for quite some time, e.g. if a vCPU blocks across multiple memslot updates.
- *
- * Because mmu_lock is held for write, it should be impossible to observe a
- * root with zero refcount, i.e. the list of roots cannot be stale.
+ * Get a reference even if the root is already invalid, the asynchronous worker
+ * assumes it was gifted a reference to the root it processes.  Because mmu_lock
+ * is held for write, it should be impossible to observe a root with zero refcount,
+ * i.e. the list of roots cannot be stale.
  *
  * This has essentially the same effect for the TDP MMU
  * as updating mmu_valid_gen does for the shadow MMU.
@@ -1002,8 +994,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
-		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
+		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
 			root->role.invalid = true;
+			tdp_mmu_schedule_zap_root(kvm, root);
+		}
 	}
 }
 
-- 
2.31.1


