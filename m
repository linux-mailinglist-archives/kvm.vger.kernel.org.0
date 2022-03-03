Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA6A4CC64F
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiCCTlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236213AbiCCTkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:40:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B356D1A58E2
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kT0bGQxraXhTkdJRdu0nvE9rqQyGeiDCm5hpgEWBNU=;
        b=IeD/twoSJPIdBI/N6usBSr6jskJzFKirTUn9psls6vrM7gTClfoiKRuWvGAPH/F4ao+Rpy
        6xEGSQDQzymnnLvp0ML3Aj6eK/Rmck5y2Fo3R/7UNz9vbRFqwDbqHffy4y7tGdjOEhwYkI
        DnxEYVTeDjYxt38Z0+hCi57SkS00W68=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-203-xZX_qMyrOQ2uSKaGQtlkEw-1; Thu, 03 Mar 2022 14:39:15 -0500
X-MC-Unique: xZX_qMyrOQ2uSKaGQtlkEw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8341B1091DAD;
        Thu,  3 Mar 2022 19:39:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF4BA5FC22;
        Thu,  3 Mar 2022 19:39:12 +0000 (UTC)
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
Subject: [PATCH v4 22/30] KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU root
Date:   Thu,  3 Mar 2022 14:38:34 -0500
Message-Id: <20220303193842.370645-23-pbonzini@redhat.com>
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

Allow yielding when zapping SPTEs after the last reference to a valid
root is put.  Because KVM must drop all SPTEs in response to relevant
mmu_notifier events, mark defunct roots invalid and reset their refcount
prior to zapping the root.  Keeping the refcount elevated while the zap
is in-progress ensures the root is reachable via mmu_notifier until the
zap completes and the last reference to the invalid, defunct root is put.

Allowing kvm_tdp_mmu_put_root() to yield fixes soft lockup issues if the
root in being put has a massive paging structure, e.g. zapping a root
that is backed entirely by 4kb pages for a guest with 32tb of memory can
take hundreds of seconds to complete.

  watchdog: BUG: soft lockup - CPU#49 stuck for 485s! [max_guest_memor:52368]
  RIP: 0010:kvm_set_pfn_dirty+0x30/0x50 [kvm]
   __handle_changed_spte+0x1b2/0x2f0 [kvm]
   handle_removed_tdp_mmu_page+0x1a7/0x2b8 [kvm]
   __handle_changed_spte+0x1f4/0x2f0 [kvm]
   handle_removed_tdp_mmu_page+0x1a7/0x2b8 [kvm]
   __handle_changed_spte+0x1f4/0x2f0 [kvm]
   tdp_mmu_zap_root+0x307/0x4d0 [kvm]
   kvm_tdp_mmu_put_root+0x7c/0xc0 [kvm]
   kvm_mmu_free_roots+0x22d/0x350 [kvm]
   kvm_mmu_reset_context+0x20/0x60 [kvm]
   kvm_arch_vcpu_ioctl_set_sregs+0x5a/0xc0 [kvm]
   kvm_vcpu_ioctl+0x5bd/0x710 [kvm]
   __se_sys_ioctl+0x77/0xc0
   __x64_sys_ioctl+0x1d/0x20
   do_syscall_64+0x44/0xa0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

KVM currently doesn't put a root from a non-preemptible context, so other
than the mmu_notifier wrinkle, yielding when putting a root is safe.

Yield-unfriendly iteration uses for_each_tdp_mmu_root(), which doesn't
take a reference to each root (it requires mmu_lock be held for the
entire duration of the walk).

tdp_mmu_next_root() is used only by the yield-friendly iterator.

tdp_mmu_zap_root_work() is explicitly yield friendly.

kvm_mmu_free_roots() => mmu_free_root_page() is a much bigger fan-out,
but is still yield-friendly in all call sites, as all callers can be
traced back to some combination of vcpu_run(), kvm_destroy_vm(), and/or
kvm_create_vm().

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-21-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 93 +++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ed1bb63b342d..408e21e4009c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -144,20 +144,46 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	WARN_ON(!root->tdp_mmu_page);
 
-	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-	list_del_rcu(&root->link);
-	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-
 	/*
-	 * A TLB flush is not necessary as KVM performs a local TLB flush when
-	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
-	 * to a different pCPU.  Note, the local TLB flush on reuse also
-	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
-	 * intermediate paging structures, that may be zapped, as such entries
-	 * are associated with the ASID on both VMX and SVM.
+	 * The root now has refcount=0.  It is valid, but readers already
+	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
+	 * rejects it.  This remains true for the rest of the execution
+	 * of this function, because readers visit valid roots only
+	 * (except for tdp_mmu_zap_root_work(), which however
+	 * does not acquire any reference itself).
+	 *
+	 * Even though there are flows that need to visit all roots for
+	 * correctness, they all take mmu_lock for write, so they cannot yet
+	 * run concurrently. The same is true after kvm_tdp_root_mark_invalid,
+	 * since the root still has refcount=0.
+	 *
+	 * However, tdp_mmu_zap_root can yield, and writers do not expect to
+	 * see refcount=0 (see for example kvm_tdp_mmu_invalidate_all_roots()).
+	 * So the root temporarily gets an extra reference, going to refcount=1
+	 * while staying invalid.  Readers still cannot acquire any reference;
+	 * but writers are now allowed to run if tdp_mmu_zap_root yields and
+	 * they might take an extra reference is they themselves yield.  Therefore,
+	 * when the reference is given back after tdp_mmu_zap_root terminates,
+	 * there is no guarantee that the refcount is still 1.  If not, whoever
+	 * puts the last reference will free the page, but they will not have to
+	 * zap the root because a root cannot go from invalid to valid.
 	 */
-	tdp_mmu_zap_root(kvm, root, shared);
+	if (!kvm_tdp_root_mark_invalid(root)) {
+		refcount_set(&root->tdp_mmu_root_count, 1);
+		tdp_mmu_zap_root(kvm, root, shared);
+
+		/*
+		 * Give back the reference that was added back above.  We now
+		 * know that the root is invalid, so go ahead and free it if
+		 * no one has taken a reference in the meanwhile.
+		 */
+		if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
+			return;
+	}
 
+	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+	list_del_rcu(&root->link);
+	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
@@ -799,12 +825,23 @@ static inline gfn_t tdp_mmu_max_gfn_host(void)
 static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			     bool shared)
 {
-	bool root_is_unreachable = !refcount_read(&root->tdp_mmu_root_count);
 	struct tdp_iter iter;
 
 	gfn_t end = tdp_mmu_max_gfn_host();
 	gfn_t start = 0;
 
+	/*
+	 * The root must have an elevated refcount so that it's reachable via
+	 * mmu_notifier callbacks, which allows this path to yield and drop
+	 * mmu_lock.  When handling an unmap/release mmu_notifier command, KVM
+	 * must drop all references to relevant pages prior to completing the
+	 * callback.  Dropping mmu_lock with an unreachable root would result
+	 * in zapping SPTEs after a relevant mmu_notifier callback completes
+	 * and lead to use-after-free as zapping a SPTE triggers "writeback" of
+	 * dirty accessed bits to the SPTE's associated struct page.
+	 */
+	WARN_ON_ONCE(!refcount_read(&root->tdp_mmu_root_count));
+
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	rcu_read_lock();
@@ -815,42 +852,16 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 */
 	for_each_tdp_pte_min_level(iter, root, root->role.level, start, end) {
 retry:
-		/*
-		 * Yielding isn't allowed when zapping an unreachable root as
-		 * the root won't be processed by mmu_notifier callbacks.  When
-		 * handling an unmap/release mmu_notifier command, KVM must
-		 * drop all references to relevant pages prior to completing
-		 * the callback.  Dropping mmu_lock can result in zapping SPTEs
-		 * for an unreachable root after a relevant callback completes,
-		 * which leads to use-after-free as zapping a SPTE triggers
-		 * "writeback" of dirty/accessed bits to the SPTE's associated
-		 * struct page.
-		 */
-		if (!root_is_unreachable &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
-		if (!shared) {
+		if (!shared)
 			tdp_mmu_set_spte(kvm, &iter, 0);
-		} else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
-			/*
-			 * cmpxchg() shouldn't fail if the root is unreachable.
-			 * Retry so as not to leak the page and its children.
-			 */
-			WARN_ONCE(root_is_unreachable,
-				  "Contended TDP MMU SPTE in unreachable root.");
+		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
 			goto retry;
-		}
-
-		/*
-		 * WARN if the root is invalid and is unreachable, all SPTEs
-		 * should've been zapped by kvm_tdp_mmu_zap_invalidated_roots(),
-		 * and inserting new SPTEs under an invalid root is a KVM bug.
-		 */
-		WARN_ON_ONCE(root_is_unreachable && root->role.invalid);
 	}
 
 	rcu_read_unlock();
-- 
2.31.1


