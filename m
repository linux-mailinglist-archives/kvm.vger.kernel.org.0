Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943216EB3E3
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 23:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjDUVuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 17:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233724AbjDUVtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 17:49:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B8DDD
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 14:49:49 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5187bd3d365so2345534a12.3
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 14:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682113789; x=1684705789;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p7cetrvLKSRH9Q0XivzSmZyLoL8IS5OHMZStKa6lsTY=;
        b=cRW3iY54MsV/uSQYhCEhAWc/m9IOMhOiDrMj4LGEkUIm4U6Iyoplhs08YwS3BzxDwE
         Orq2zrv8ASDM/5M/bgXJmzhkCsthT/cxK+agw6wnMoWSpeMSJZe+MTKTSLkwKQIgaQ9O
         F2CpIwv+z2tp7z5fT3WgCa9Zqis9fJYgWshlK/Gk4xOz7BOEeNCUn6r4yzxYeSrStXd1
         mUT+WZYg7eCf1Oi+XSZ9/sFcQt7kP1hgh9E90vlUEVNja7tpqzZCF5PcqdSHA+iEhf8q
         HnvBsJMf/vQ9fvxkYdiKUKNiPDfdgC4NzZSiN4vKJQ3mgxQc2p1eNBJ4OpCAs8WZVeLo
         qZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682113789; x=1684705789;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p7cetrvLKSRH9Q0XivzSmZyLoL8IS5OHMZStKa6lsTY=;
        b=IC3KMZuckWrqxIQgpxeuh5tv9UNQouxy4AzN9vTWaYaQQvfnqJj9Mb66njcvS2lv/z
         W48RyMHlxEL7XpYRU47aEh6ncTF974ohZjMjAiyj0WeUsL5zxbSr64lfNKi9YWC9SCZE
         FKAEACmPOYtcFG/xk47xBu8rzqomTyKPRgOgO86dxMjdtDBTIklF7zk6IXYZ56jvskDB
         hOf8LIgokvc6fvP5x9Mg9/vgmGTyVhoDqv7opJW4yIuRYvjuMb1cMym+GROicgpI96jZ
         DafnA09tQ9rPjvWAu5nMMc8kZQfO/qvysAH9cNgOc9PmDYRTLuiFxolJmnKiJUIepOrW
         /+Qw==
X-Gm-Message-State: AAQBX9dxntVPlqCDszSK2bXqSBj8oiJ+a2lyJj+ATXN+1VOOl7eInHTP
        QV/Ol0aOlifj9e6SYNVEH+WC0zTCTc4=
X-Google-Smtp-Source: AKy350bsadFZl60XlSJ7N4EJ0FmTtxReihz8/+sXFdGiaVG68qnXvx7nQ7JWbdwYHKbf2oAos1RdNXdj6TU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:668d:0:b0:513:a748:c7d5 with SMTP id
 b13-20020a65668d000000b00513a748c7d5mr941948pgw.3.1682113789525; Fri, 21 Apr
 2023 14:49:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 21 Apr 2023 14:49:46 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421214946.2571580-1-seanjc@google.com>
Subject: [PATCH v2] KVM: x86: Preserve TDP MMU roots until they are explicitly invalidated
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Preserve TDP MMU roots until they are explicitly invalidated by gifting
the TDP MMU itself a reference to a root when it is allocated.  Keeping a
reference in the TDP MMU fixes a flaw where the TDP MMU exhibits terrible
performance, and can potentially even soft-hang a vCPU, if a vCPU
frequently unloads its roots, e.g. when KVM is emulating SMI+RSM.

When KVM emulates something that invalidates _all_ TLB entries, e.g. SMI
and RSM, KVM unloads all of the vCPUs roots (KVM keeps a small per-vCPU
cache of previous roots).  Unloading roots is a simple way to ensure KVM
flushes and synchronizes all roots for the vCPU, as KVM flushes and syncs
when allocating a "new" root (from the vCPU's perspective).

In the shadow MMU, KVM keeps track of all shadow pages, roots included, in
a per-VM hash table.  Unloading a shadow MMU root just wipes it from the
per-vCPU cache; the root is still tracked in the per-VM hash table.  When
KVM loads a "new" root for the vCPU, KVM will find the old, unloaded root
in the per-VM hash table.

Unlike the shadow MMU, the TDP MMU doesn't track "inactive" roots in a
per-VM structure, where "active" in this case means a root is either
in-use or cached as a previous root by at least one vCPU.  When a TDP MMU
root becomes inactive, i.e. the last vCPU reference to the root is put,
KVM immediately frees the root (asterisk on "immediately" as the actual
freeing may be done by a worker, but for all intents and purposes the root
is gone).

The TDP MMU behavior is especially problematic for 1-vCPU setups, as
unloading all roots effectively frees all roots.  The issue is mitigated
to some degree in multi-vCPU setups as a different vCPU usually holds a
reference to an unloaded root and thus keeps the root alive, allowing the
vCPU to reuse its old root after unloading (with a flush+sync).

The TDP MMU flaw has been known for some time, as until very recently,
KVM's handling of CR0.WP also triggered unloading of all roots.  The
CR0.WP toggling scenario was eventually addressed by not unloading roots
when _only_ CR0.WP is toggled, but such an approach doesn't Just Work
for emulating SMM as KVM must emulate a full TLB flush on entry and exit
to/from SMM.  Given that the shadow MMU plays nice with unloading roots
at will, teaching the TDP MMU to do the same is far less complex than
modifying KVM to track which roots need to be flushed before reuse.

Note, preserving all possible TDP MMU roots is not a concern with respect
to memory consumption.  Now that the role for direct MMUs doesn't include
information about the guest, e.g. CR0.PG, CR0.WP, CR4.SMEP, etc., there
are _at most_ six possible roots (where "guest_mode" here means L2):

  1. 4-level !SMM !guest_mode
  2. 4-level  SMM !guest_mode
  3. 5-level !SMM !guest_mode
  4. 5-level  SMM !guest_mode
  5. 4-level !SMM guest_mode
  6. 5-level !SMM guest_mode

And because each vCPU can track 4 valid roots, a VM can already have all
6 root combinations live at any given time.  Not to mention that, in
practice, no sane VMM will advertise different guest.MAXPHYADDR values
across vCPUs, i.e. KVM won't ever use both 4-level and 5-level roots for
a single VM.  Furthermore, the vast majority of modern hypervisors will
utilize EPT/NPT when available, thus the guest_mode=%true cases are also
unlikely to be utilized.

Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Link: https://lore.kernel.org/all/959c5bce-beb5-b463-7158-33fc4a4f910c@linux.microsoft.com
Link: https://lkml.kernel.org/r/20220209170020.1775368-1-pbonzini%40redhat.com
Link: https://lore.kernel.org/all/20230322013731.102955-1-minipli@grsecurity.net
Link: https://lore.kernel.org/all/000000000000a0bc2b05f9dd7fab@google.com
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: stable@vger.kernel.org
Tested-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

David, I dropped your review as adding RCU protection is trivial from a code
perspective, but at the same time quite subtle.

I did keep Jeremi's tag, because protecting the walk with RCU during
invalidation isn't really relevant to what Jeremi was testing (performance and
core functionality).

 arch/x86/kvm/mmu/tdp_mmu.c | 106 ++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b2fca11b91ff..9925f8e39ea6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -40,7 +40,17 @@ static __always_inline bool kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
 
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
-	/* Also waits for any queued work items.  */
+	/*
+	 * Invalidate all roots, which besides the obvious, schedules all roots
+	 * for zapping and thus puts the TDP MMU's reference to each root, i.e.
+	 * ultimately frees all roots.
+	 */
+	kvm_tdp_mmu_invalidate_all_roots(kvm);
+
+	/*
+	 * Destroying a workqueue also first flushes the workqueue, i.e. no
+	 * need to invoke kvm_tdp_mmu_zap_invalidated_roots().
+	 */
 	destroy_workqueue(kvm->arch.tdp_mmu_zap_wq);
 
 	WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
@@ -116,16 +126,6 @@ static void tdp_mmu_schedule_zap_root(struct kvm *kvm, struct kvm_mmu_page *root
 	queue_work(kvm->arch.tdp_mmu_zap_wq, &root->tdp_mmu_async_work);
 }
 
-static inline bool kvm_tdp_root_mark_invalid(struct kvm_mmu_page *page)
-{
-	union kvm_mmu_page_role role = page->role;
-	role.invalid = true;
-
-	/* No need to use cmpxchg, only the invalid bit can change.  */
-	role.word = xchg(&page->role.word, role.word);
-	return role.invalid;
-}
-
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -134,45 +134,12 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
 
-	WARN_ON(!is_tdp_mmu_page(root));
-
 	/*
-	 * The root now has refcount=0.  It is valid, but readers already
-	 * cannot acquire a reference to it because kvm_tdp_mmu_get_root()
-	 * rejects it.  This remains true for the rest of the execution
-	 * of this function, because readers visit valid roots only
-	 * (except for tdp_mmu_zap_root_work(), which however
-	 * does not acquire any reference itself).
-	 *
-	 * Even though there are flows that need to visit all roots for
-	 * correctness, they all take mmu_lock for write, so they cannot yet
-	 * run concurrently. The same is true after kvm_tdp_root_mark_invalid,
-	 * since the root still has refcount=0.
-	 *
-	 * However, tdp_mmu_zap_root can yield, and writers do not expect to
-	 * see refcount=0 (see for example kvm_tdp_mmu_invalidate_all_roots()).
-	 * So the root temporarily gets an extra reference, going to refcount=1
-	 * while staying invalid.  Readers still cannot acquire any reference;
-	 * but writers are now allowed to run if tdp_mmu_zap_root yields and
-	 * they might take an extra reference if they themselves yield.
-	 * Therefore, when the reference is given back by the worker,
-	 * there is no guarantee that the refcount is still 1.  If not, whoever
-	 * puts the last reference will free the page, but they will not have to
-	 * zap the root because a root cannot go from invalid to valid.
+	 * The TDP MMU itself holds a reference to each root until the root is
+	 * explicitly invalidated, i.e. the final reference should be never be
+	 * put for a valid root.
 	 */
-	if (!kvm_tdp_root_mark_invalid(root)) {
-		refcount_set(&root->tdp_mmu_root_count, 1);
-
-		/*
-		 * Zapping the root in a worker is not just "nice to have";
-		 * it is required because kvm_tdp_mmu_invalidate_all_roots()
-		 * skips already-invalid roots.  If kvm_tdp_mmu_put_root() did
-		 * not add the root to the workqueue, kvm_tdp_mmu_zap_all_fast()
-		 * might return with some roots not zapped yet.
-		 */
-		tdp_mmu_schedule_zap_root(kvm, root);
-		return;
-	}
+	KVM_BUG_ON(!is_tdp_mmu_page(root) || !root->role.invalid, kvm);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_del_rcu(&root->link);
@@ -320,7 +287,14 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	root = tdp_mmu_alloc_sp(vcpu);
 	tdp_mmu_init_sp(root, NULL, 0, role);
 
-	refcount_set(&root->tdp_mmu_root_count, 1);
+	/*
+	 * TDP MMU roots are kept until they are explicitly invalidated, either
+	 * by a memslot update or by the destruction of the VM.  Initialize the
+	 * refcount to two; one reference for the vCPU, and one reference for
+	 * the TDP MMU itself, which is held until the root is invalidated and
+	 * is ultimately put by tdp_mmu_zap_root_work().
+	 */
+	refcount_set(&root->tdp_mmu_root_count, 2);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
 	list_add_rcu(&root->link, &kvm->arch.tdp_mmu_roots);
@@ -946,32 +920,34 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 /*
  * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
  * is about to be zapped, e.g. in response to a memslots update.  The actual
- * zapping is performed asynchronously, so a reference is taken on all roots.
- * Using a separate workqueue makes it easy to ensure that the destruction is
- * performed before the "fast zap" completes, without keeping a separate list
- * of invalidated roots; the list is effectively the list of work items in
- * the workqueue.
+ * zapping is performed asynchronously.  Using a separate workqueue makes it
+ * easy to ensure that the destruction is performed before the "fast zap"
+ * completes, without keeping a separate list of invalidated roots; the list is
+ * effectively the list of work items in the workqueue.
  *
- * Get a reference even if the root is already invalid, the asynchronous worker
- * assumes it was gifted a reference to the root it processes.  Because mmu_lock
- * is held for write, it should be impossible to observe a root with zero refcount,
- * i.e. the list of roots cannot be stale.
- *
- * This has essentially the same effect for the TDP MMU
- * as updating mmu_valid_gen does for the shadow MMU.
+ * Note, the asynchronous worker is gifted the TDP MMU's reference.
+ * See kvm_tdp_mmu_get_vcpu_root_hpa().
  */
 void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 {
 	struct kvm_mmu_page *root;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
-		if (!root->role.invalid &&
-		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
+	/*
+	 * Note!  mmu_lock isn't held when destroying the VM!  There can't be
+	 * other references to @kvm, i.e. nothing else can invalidate roots,
+	 * but walking the list of roots does need to be guarded against roots
+	 * being deleted by the asynchronous zap worker.
+	 */
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!root->role.invalid) {
 			root->role.invalid = true;
 			tdp_mmu_schedule_zap_root(kvm, root);
 		}
 	}
+
+	rcu_read_unlock();
 }
 
 /*

base-commit: 62cf1e941a1169a5e8016fd8683d4d888ab51e01
-- 
2.40.0.634.g4ca3ef3211-goog

