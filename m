Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5629E6AD1EC
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCFWnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCFWmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:42:49 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E7B80E16
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:42:18 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-536cb268ab8so117480527b3.17
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VEQuTMy3BKS8pVuX5PwbgXlx8W41CrsAU35jTKJjWKM=;
        b=PQs6IbkXsJ9lld1VVn0ou53Tj+mD5mN/JMwKSFBqww8CU+k++n9JdjO9+5RKeOjY3j
         z1/gwkem0OA83eaGuvDnX+LX/N5AufzHntpp7rjRkWPcijI5hk20sgV7bwLAddkmSCj3
         ac5RV0oP8KcSnkDPK9DDwAJWAsCw+Reb0+qRKsPT0kFJhdhm6SUGV//tcG3x0gh1lnqt
         EghVyHg1PbXKS8G87VUngcQN+Db7y8HpZLnEKYV83J/P4Uzk7ml77lO9R/1zfUJoGsbY
         GHY2XVCWssNUmg+Ccd1UHPOAasmBZKc7W5I6uIRMz8lPIACX4uuk7GRHJvvYhb8cYleT
         eHKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEQuTMy3BKS8pVuX5PwbgXlx8W41CrsAU35jTKJjWKM=;
        b=nQVsw2MJZS+yuOVMnjUF1NV0pIfvbrvM6PsBkJVy0arJrWJ73nMyd1nLxS8sEHwYK0
         3b7Ul6IbLO9YaRlPl4UtpcJ8u6xtDRkPGNNl4tYgExUq8/VCvg8hAwm965WDjyILxHJt
         ybiGEaWg1MEgNaLA+KwCmIDBppRZl0m1hylvm5qDZkCQ4aFpnBozXHk95AUSLi1J0f6h
         ZXIDmrmO3rOdf+dDk+TGRHnthtADkifF18JlcpJohkC9utYWiDMwcVJ25y3Rp4TVMHlC
         cxTU1Mep0SMR818KKfNiLbwI0z4+5Cq3VvOO/By/HcgGrbSExZy8IA2pRg4kNSLUCnX0
         CsnQ==
X-Gm-Message-State: AO0yUKX1V/CatLK9Xg7PiOWdWh/33uRCUKzhFZLHR5MDaE5/kdX0E7YE
        vhweFekpeO21Hb5Cmu5Px7QFX/6Cobkn
X-Google-Smtp-Source: AK7set8EdZCOmDm00QFWHsxEQuQ2fSZe9k2hobygiUXFHmNiri0mCqYuv/hf7wRRFK4ZJJIrTgckG/2/OuZ/
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6902:c3:b0:9f1:6c48:f95f with SMTP id
 i3-20020a05690200c300b009f16c48f95fmr5863124ybs.5.1678142524427; Mon, 06 Mar
 2023 14:42:04 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:26 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-18-vipinsh@google.com>
Subject: [Patch v4 17/18] KVM: x86/mmu: Allocate shadow mmu page table on huge
 page split on the same NUMA node
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When splitting a huge page and NUMA aware page split option is enabled,
try to allocate new lower level page tables on the same NUMA node of
the huge page. If NUMA aware page split is disabled then fallback to
default policy of using current thread's mempolicy.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 42 ++++++++++++++++++++-------------
 arch/x86/kvm/x86.c              |  8 ++++++-
 3 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 77d3aa368e5e..041302d6132c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1453,7 +1453,7 @@ struct kvm_arch {
 	 *
 	 * Protected by kvm->slots_lock.
 	 */
-	struct kvm_mmu_memory_cache split_shadow_page_cache;
+	struct kvm_mmu_memory_cache split_shadow_page_cache[MAX_NUMNODES];
 	struct kvm_mmu_memory_cache split_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86f0d74d35ed..6d44a4e08328 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6140,7 +6140,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
-	int r;
+	int r, nid;
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
@@ -6159,7 +6159,9 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache);
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
 
-	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache);
+	for_each_node(nid)
+		INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache[nid]);
+
 
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache);
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
@@ -6169,10 +6171,13 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
 {
+	int nid;
+
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
 	mutex_lock(&kvm->slots_lock);
-	mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache);
+	for_each_node(nid)
+		mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid]);
 	mutex_unlock(&kvm->slots_lock);
 }
 
@@ -6282,7 +6287,7 @@ static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
 	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
 }
 
-static bool need_topup_split_caches_or_resched(struct kvm *kvm)
+static bool need_topup_split_caches_or_resched(struct kvm *kvm, int nid)
 {
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
 		return true;
@@ -6294,10 +6299,10 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
 	 */
 	return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_MIN_NR_OBJECTS) ||
 	       need_topup(&kvm->arch.split_page_header_cache, 1) ||
-	       need_topup(&kvm->arch.split_shadow_page_cache, 1);
+	       need_topup(&kvm->arch.split_shadow_page_cache[nid], 1);
 }
 
-static int topup_split_caches(struct kvm *kvm)
+static int topup_split_caches(struct kvm *kvm, int nid)
 {
 	/*
 	 * Allocating rmap list entries when splitting huge pages for nested
@@ -6327,10 +6332,11 @@ static int topup_split_caches(struct kvm *kvm)
 	if (r)
 		return r;
 
-	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
+	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid], 1);
 }
 
-static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
+static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep,
+							int nid)
 {
 	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
 	struct shadow_page_caches caches = {};
@@ -6351,7 +6357,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 
 	/* Direct SPs do not require a shadowed_info_cache. */
 	caches.page_header_cache = &kvm->arch.split_page_header_cache;
-	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
+	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache[nid];
 
 	/* Safe to pass NULL for vCPU since requesting a direct SP. */
 	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
@@ -6359,7 +6365,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 
 static void shadow_mmu_split_huge_page(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
-				       u64 *huge_sptep)
+				       u64 *huge_sptep, int nid)
 
 {
 	struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
@@ -6370,7 +6376,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 	gfn_t gfn;
 	int index;
 
-	sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep);
+	sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep, nid);
 
 	for (index = 0; index < SPTE_ENT_PER_PAGE; index++) {
 		sptep = &sp->spt[index];
@@ -6408,7 +6414,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 					  u64 *huge_sptep)
 {
 	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
-	int level, r = 0;
+	int level, r = 0, nid;
 	gfn_t gfn;
 	u64 spte;
 
@@ -6422,7 +6428,9 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 		goto out;
 	}
 
-	if (need_topup_split_caches_or_resched(kvm)) {
+	nid = kvm_pfn_to_mmu_cache_nid(kvm, spte_to_pfn(spte));
+
+	if (need_topup_split_caches_or_resched(kvm, nid)) {
 		write_unlock(&kvm->mmu_lock);
 		cond_resched();
 		/*
@@ -6430,12 +6438,12 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 		 * rmap iterator should be restarted because the MMU lock was
 		 * dropped.
 		 */
-		r = topup_split_caches(kvm) ?: -EAGAIN;
+		r = topup_split_caches(kvm, nid) ?: -EAGAIN;
 		write_lock(&kvm->mmu_lock);
 		goto out;
 	}
 
-	shadow_mmu_split_huge_page(kvm, slot, huge_sptep);
+	shadow_mmu_split_huge_page(kvm, slot, huge_sptep, nid);
 
 out:
 	trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
@@ -6761,8 +6769,8 @@ static unsigned long mmu_shrink_scan(struct shrinker *shrink,
 			if (freed >= sc->nr_to_scan)
 				goto out;
 		}
-		freed += mmu_memory_cache_try_empty(&kvm->arch.split_shadow_page_cache,
-						    1, &kvm->slots_lock);
+		freed += mmu_memory_cache_try_empty(kvm->arch.split_shadow_page_cache,
+						    MAX_NUMNODES, &kvm->slots_lock);
 		if (freed >= sc->nr_to_scan)
 			goto out;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 71728abd7f92..d8ea39b248cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6176,7 +6176,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
-	int r;
+	int r, nid;
 
 	if (cap->flags)
 		return -EINVAL;
@@ -6397,6 +6397,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		mutex_lock(&kvm->lock);
 		if (!kvm->created_vcpus) {
 			kvm->arch.numa_aware_page_table = true;
+
+			mutex_lock(&kvm->slots_lock);
+			for_each_node(nid) {
+				kvm->arch.split_shadow_page_cache[nid].node = nid;
+			}
+			mutex_unlock(&kvm->slots_lock);
 			r = 0;
 		}
 		mutex_unlock(&kvm->lock);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

