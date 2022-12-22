Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590A2653AB2
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiLVCfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiLVCfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:03 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A12C30
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:02 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id b13-20020a056a000a8d00b0057348c50123so290233pfl.18
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6jVBO9S5dbcnt6LQaPOW+OOm7KBKZVW/r/1rxTlv7y0=;
        b=Oo7Qropuw/gdh8zHqxm5y4tH/LW1Zuut2j3i90LaWzm1//jVejmK3t0ed6NX17Pv5j
         Z5OHUTQpFUFenvI4oWoFiCoLJ+I0EuIZK/8I55I53zFB4+ry3RmuEfwzelxYKcdWWLZg
         GPq6Dzv2zwGXrzI5DqVl+cgeh08cdc3EjFSVeDGxQcjhdy0CkU4ppP/+YBk5LKo75SLB
         MO/IQNg1nVXQoJHIkgNmNYodEZF949Th0Xu9IXfEGAoIYB8OL62nKrKu8ZtwfZngXvmC
         nD6GIoiek/7Ls1lDTRlti1yOUj0n1DXw1a1LJ+MROJyWxH1cTjY0/82fooJp4KrK9zkj
         K7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6jVBO9S5dbcnt6LQaPOW+OOm7KBKZVW/r/1rxTlv7y0=;
        b=tJIiS3gHnkCNkln9bJavGQT9G56EBmB6aJvKZ6uFWm6V304QfIUP9Lc8He2upAgiKJ
         DKs3f9AUFStWEyd1ATBzQ/X4AuKcTIwOI3fHxR7UxaFm5eWCSA0vtF7GrHkOvNnX3sMf
         onTZ0a9+Ucxdml8HRYXnMIdfPUca1Og9eQey5bL2tAwpChDnBeMjtNgGnZAlAlHQEwf5
         yLj3HxRuhiHF9rC7eBXyO2M5IYYdMw1anPXY+qoVeKxqxS1TT0r3rMd7k5SO/ZUaIzZp
         vtpr+CLv4Ar14RBm8RRm5mXSOTu6vtBOg9SpvvYAQAXNElShF+Rs/QNsaT5DWHxoz6MI
         cHgQ==
X-Gm-Message-State: AFqh2kq7X6b7Uzlsk4KBD9MCfvsBqHANGVCfDP0QueL8s8ahR1XbCae4
        OL39XXGoNgBGXsr72Npg1v9MOVbq0/mq
X-Google-Smtp-Source: AMrXdXscnJjos0xpFtk0+sb/v4CvHXN/vVCpf4sWeWSpsLgs5nHAFKaZ6pg0jsQ+eZgvw4oz61jBcmjZT8Ng
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:fe0c:b0:189:6077:5598 with SMTP id
 g12-20020a170902fe0c00b0018960775598mr278964plj.100.1671676501765; Wed, 21
 Dec 2022 18:35:01 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:49 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-2-vipinsh@google.com>
Subject: [Patch v3 1/9] KVM: x86/mmu: Repurpose KVM MMU shrinker to purge
 shadow page caches
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_shrink_scan() is very disruptive to VMs. It picks the first
VM in the vm_list, zaps the oldest page which is most likely an upper
level SPTEs and most like to be reused. Prior to TDP MMU, this is even
more disruptive in nested VMs case, considering L1 SPTEs will be the
oldest even though most of the entries are for L2 SPTEs.

As discussed in
https://lore.kernel.org/lkml/Y45dldZnI6OIf+a5@google.com/
shrinker logic has not be very useful in actually keeping VMs performant
and reducing memory usage.

Change mmu_shrink_scan() to free pages from the vCPU's shadow page
cache.  Freeing pages from cache doesn't cause vCPU exits, therefore, a
VM's performance should not be affected.

This also allows to change cache capacities without worrying too much
about high memory usage in cache.

Tested this change by running dirty_log_perf_test while dropping cache
via "echo 2 > /proc/sys/vm/drop_caches" at 1 second interval
continuously. There were WARN_ON(!mc->nobjs) messages printed in kernel
logs from kvm_mmu_memory_cache_alloc(), which is expected.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |   5 +
 arch/x86/kvm/mmu/mmu.c          | 163 +++++++++++++++++++-------------
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c      |   3 +-
 include/linux/kvm_host.h        |   1 +
 virt/kvm/kvm_main.c             |  11 ++-
 6 files changed, 114 insertions(+), 71 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index aa4eb8cfcd7e..89cc809e4a00 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -786,6 +786,11 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
+	/*
+	 * Protects change in size of mmu_shadow_page_cache cache.
+	 */
+	spinlock_t mmu_shadow_page_cache_lock;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 254bc46234e0..157417e1cb6e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -164,7 +164,10 @@ struct kvm_shadow_walk_iterator {
 
 static struct kmem_cache *pte_list_desc_cache;
 struct kmem_cache *mmu_page_header_cache;
-static struct percpu_counter kvm_total_used_mmu_pages;
+/*
+ * Total number of unused pages in MMU shadow page cache.
+ */
+static struct percpu_counter kvm_total_unused_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
 
@@ -655,6 +658,22 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
+				     spinlock_t *cache_lock)
+{
+	int orig_nobjs;
+	int r;
+
+	spin_lock(cache_lock);
+	orig_nobjs = cache->nobjs;
+	r = kvm_mmu_topup_memory_cache(cache, PT64_ROOT_MAX_LEVEL);
+	if (orig_nobjs != cache->nobjs)
+		percpu_counter_add(&kvm_total_unused_mmu_pages,
+				   (cache->nobjs - orig_nobjs));
+	spin_unlock(cache_lock);
+	return r;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -664,8 +683,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				       PT64_ROOT_MAX_LEVEL);
+	r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+				      &vcpu->arch.mmu_shadow_page_cache_lock);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -678,10 +697,25 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 					  PT64_ROOT_MAX_LEVEL);
 }
 
+static void mmu_free_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
+				     spinlock_t *cache_lock)
+{
+	int orig_nobjs;
+
+	spin_lock(cache_lock);
+	orig_nobjs = cache->nobjs;
+	kvm_mmu_free_memory_cache(cache);
+	if (orig_nobjs)
+		percpu_counter_sub(&kvm_total_unused_mmu_pages, orig_nobjs);
+
+	spin_unlock(cache_lock);
+}
+
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
+	mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+				 &vcpu->arch.mmu_shadow_page_cache_lock);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
@@ -1693,27 +1727,15 @@ static int is_empty_shadow_page(u64 *spt)
 }
 #endif
 
-/*
- * This value is the sum of all of the kvm instances's
- * kvm->arch.n_used_mmu_pages values.  We need a global,
- * aggregate version in order to make the slab shrinker
- * faster
- */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
-{
-	kvm->arch.n_used_mmu_pages += nr;
-	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
-}
-
 static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	kvm_mod_used_mmu_pages(kvm, +1);
+	kvm->arch.n_used_mmu_pages++;
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
 }
 
 static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
-	kvm_mod_used_mmu_pages(kvm, -1);
+	kvm->arch.n_used_mmu_pages--;
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
 }
 
@@ -2150,8 +2172,31 @@ struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *page_header_cache;
 	struct kvm_mmu_memory_cache *shadow_page_cache;
 	struct kvm_mmu_memory_cache *shadowed_info_cache;
+	/*
+	 * Protects change in size of shadow_page_cache cache.
+	 */
+	spinlock_t *shadow_page_cache_lock;
 };
 
+void *kvm_mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache,
+				    spinlock_t *cache_lock)
+{
+	int orig_nobjs;
+	void *page;
+
+	if (!cache_lock) {
+		spin_lock(cache_lock);
+		orig_nobjs = shadow_page_cache->nobjs;
+	}
+	page = kvm_mmu_memory_cache_alloc(shadow_page_cache);
+	if (!cache_lock) {
+		if (orig_nobjs)
+			percpu_counter_dec(&kvm_total_unused_mmu_pages);
+		spin_unlock(cache_lock);
+	}
+	return page;
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
@@ -2161,7 +2206,8 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(caches->shadow_page_cache);
+	sp->spt = kvm_mmu_sp_memory_cache_alloc(caches->shadow_page_cache,
+						caches->shadow_page_cache_lock);
 	if (!role.direct)
 		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
 
@@ -2218,6 +2264,7 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 		.page_header_cache = &vcpu->arch.mmu_page_header_cache,
 		.shadow_page_cache = &vcpu->arch.mmu_shadow_page_cache,
 		.shadowed_info_cache = &vcpu->arch.mmu_shadowed_info_cache,
+		.shadow_page_cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock
 	};
 
 	return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
@@ -5916,6 +5963,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	spin_lock_init(&vcpu->arch.mmu_shadow_page_cache_lock);
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
@@ -6051,11 +6099,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
 }
 
-static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
-{
-	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
-}
-
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
@@ -6277,6 +6320,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 	/* Direct SPs do not require a shadowed_info_cache. */
 	caches.page_header_cache = &kvm->arch.split_page_header_cache;
 	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
+	caches.shadow_page_cache_lock = NULL;
 
 	/* Safe to pass NULL for vCPU since requesting a direct SP. */
 	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
@@ -6646,66 +6690,49 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct kvm *kvm;
-	int nr_to_scan = sc->nr_to_scan;
+	struct kvm_mmu_memory_cache *cache;
+	struct kvm *kvm, *first_kvm = NULL;
 	unsigned long freed = 0;
+	/* spinlock for memory cache */
+	spinlock_t *cache_lock;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 
 	mutex_lock(&kvm_lock);
 
 	list_for_each_entry(kvm, &vm_list, vm_list) {
-		int idx;
-		LIST_HEAD(invalid_list);
-
-		/*
-		 * Never scan more than sc->nr_to_scan VM instances.
-		 * Will not hit this condition practically since we do not try
-		 * to shrink more than one VM and it is very unlikely to see
-		 * !n_used_mmu_pages so many times.
-		 */
-		if (!nr_to_scan--)
+		if (first_kvm == kvm)
 			break;
-		/*
-		 * n_used_mmu_pages is accessed without holding kvm->mmu_lock
-		 * here. We may skip a VM instance errorneosly, but we do not
-		 * want to shrink a VM that only started to populate its MMU
-		 * anyway.
-		 */
-		if (!kvm->arch.n_used_mmu_pages &&
-		    !kvm_has_zapped_obsolete_pages(kvm))
-			continue;
+		if (!first_kvm)
+			first_kvm = kvm;
+		list_move_tail(&kvm->vm_list, &vm_list);
 
-		idx = srcu_read_lock(&kvm->srcu);
-		write_lock(&kvm->mmu_lock);
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			cache = &vcpu->arch.mmu_shadow_page_cache;
+			cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock;
+			if (READ_ONCE(cache->nobjs)) {
+				spin_lock(cache_lock);
+				freed += kvm_mmu_empty_memory_cache(cache);
+				spin_unlock(cache_lock);
+			}
 
-		if (kvm_has_zapped_obsolete_pages(kvm)) {
-			kvm_mmu_commit_zap_page(kvm,
-			      &kvm->arch.zapped_obsolete_pages);
-			goto unlock;
 		}
 
-		freed = kvm_mmu_zap_oldest_mmu_pages(kvm, sc->nr_to_scan);
-
-unlock:
-		write_unlock(&kvm->mmu_lock);
-		srcu_read_unlock(&kvm->srcu, idx);
-
-		/*
-		 * unfair on small ones
-		 * per-vm shrinkers cry out
-		 * sadness comes quickly
-		 */
-		list_move_tail(&kvm->vm_list, &vm_list);
-		break;
+		if (freed >= sc->nr_to_scan)
+			break;
 	}
 
+	if (freed)
+		percpu_counter_sub(&kvm_total_unused_mmu_pages, freed);
 	mutex_unlock(&kvm_lock);
+	percpu_counter_sync(&kvm_total_unused_mmu_pages);
 	return freed;
 }
 
 static unsigned long
 mmu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 {
-	return percpu_counter_read_positive(&kvm_total_used_mmu_pages);
+	return percpu_counter_sum_positive(&kvm_total_unused_mmu_pages);
 }
 
 static struct shrinker mmu_shrinker = {
@@ -6820,7 +6847,7 @@ int kvm_mmu_vendor_module_init(void)
 	if (!mmu_page_header_cache)
 		goto out;
 
-	if (percpu_counter_init(&kvm_total_used_mmu_pages, 0, GFP_KERNEL))
+	if (percpu_counter_init(&kvm_total_unused_mmu_pages, 0, GFP_KERNEL))
 		goto out;
 
 	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
@@ -6830,7 +6857,7 @@ int kvm_mmu_vendor_module_init(void)
 	return 0;
 
 out_shrinker:
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
+	percpu_counter_destroy(&kvm_total_unused_mmu_pages);
 out:
 	mmu_destroy_caches();
 	return ret;
@@ -6847,7 +6874,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 void kvm_mmu_vendor_module_exit(void)
 {
 	mmu_destroy_caches();
-	percpu_counter_destroy(&kvm_total_used_mmu_pages);
+	percpu_counter_destroy(&kvm_total_unused_mmu_pages);
 	unregister_shrinker(&mmu_shrinker);
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ac00bfbf32f6..c2a342028b6a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -325,4 +325,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+void *kvm_mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cache,
+				    spinlock_t *cache_lock);
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 764f7c87286f..4974fa96deff 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -264,7 +264,8 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	sp->spt = kvm_mmu_sp_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache,
+						&vcpu->arch.mmu_shadow_page_cache_lock);
 
 	return sp;
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 01aad8b74162..efd9b38ea9a2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1362,6 +1362,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
+int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc);
 void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e88297f999..f2d762878b97 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -438,8 +438,10 @@ int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
 	return mc->nobjs;
 }
 
-void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+int kvm_mmu_empty_memory_cache(struct kvm_mmu_memory_cache *mc)
 {
+	int freed = mc->nobjs;
+
 	while (mc->nobjs) {
 		if (mc->kmem_cache)
 			kmem_cache_free(mc->kmem_cache, mc->objects[--mc->nobjs]);
@@ -447,8 +449,13 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
 			free_page((unsigned long)mc->objects[--mc->nobjs]);
 	}
 
-	kvfree(mc->objects);
+	return freed;
+}
 
+void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
+{
+	kvm_mmu_empty_memory_cache(mc);
+	kvfree(mc->objects);
 	mc->objects = NULL;
 	mc->capacity = 0;
 }
-- 
2.39.0.314.g84b9a713c41-goog

