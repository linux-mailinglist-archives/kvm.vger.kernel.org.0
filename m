Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8E653AA8
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiLVCf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiLVCfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:37 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A17E25EA5
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:14 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id 191-20020a6214c8000000b00577ab8701b0so322830pfu.0
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OqpNn9k+U+hG3YogdgDR/fOEr/aI6IdVDrzcvJRoBmQ=;
        b=LZCil3LEBuiqPglCaABHVnyyRktcG83zDWgYL8mZt4giWucmb8FzbuHkl/qRDPEfTL
         sho0PmZ83Kz1PVrv7LxQITDU73TzGBV57cqQUyLCGPrx9sfwBeRiioD2DlM4/tip3fqi
         o4IJFivw5AtKaKsdUfv+TfoKhPRPMShpd4EbkgwFft29q/MNo2D6I6u6PD7ToZ52tz4W
         VKhny6D60ScNULutdaRX1NMuignZ1Y+Q42SR/GGwjeDOYE8dXqUceH2wQdl+BQh9qtF5
         92z74m16CNnw3BzXc5KaYuQ6cZkc4YU7xlvloYt7f+L5x8vmyokePQB0TBCZVG3vF0Yg
         INTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OqpNn9k+U+hG3YogdgDR/fOEr/aI6IdVDrzcvJRoBmQ=;
        b=2/j0vMn2n98y9Xjtb+09kp5Jq8emtj2JwrnR4hFbAXD+MdxuvZNihVm7l24lQ/Hw6F
         w8fasERwhsmz5oNaseUUmjz++EfIkkWWD2oR2v684Z74ZbawXfAeC1YBlkkGxDJ3zpl/
         IPI6HDoyOJWHNJfjn9RKYMvPlcGzyWQ9hkiozuMRrmzqgHgMGJi77aQSKz7WYpSRdsKQ
         GSpD9kS13F0dfGKfH3VLGM7lwi6Ui3WaL2ZmZ+N+1uMyXjmv3ivRWDwaFBEdyai7Y4wk
         MyqA6KxNRlU295Yb5LSKGdUeRrAYJ1UselkcEP70AKkqnBi/0uqEM1eA+o2HUbzbRwSq
         v83Q==
X-Gm-Message-State: AFqh2kqtP1Eg59gpCqxCkAOEfUaovXH7bGDWFkHk0nVCSx0S/EBMBDuh
        rQDpYcOc89GdR9g0pZnd3avH6y7MbxkZ
X-Google-Smtp-Source: AMrXdXsdS1uAeaLst9k9vclVCCOLWIbxK9Lx9IWWeNQ8BLMOiOd/S8VYUSYeV2+muAopSD1+l7BaJNjs32ck
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:7d92:b0:18e:bd50:f19a with SMTP id
 a18-20020a1709027d9200b0018ebd50f19amr219700plm.81.1671676513459; Wed, 21 Dec
 2022 18:35:13 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:56 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-9-vipinsh@google.com>
Subject: [Patch v3 8/9] KVM: x86/mmu: Make split_shadow_page_cache NUMA aware
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
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

Make split_shadow_page_cache NUMA aware and allocate page table's pages
during the split based on the underlying physical page's NUMA node.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 50 ++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b1f319ad6f89..7b3f36ae37a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1410,7 +1410,7 @@ struct kvm_arch {
 	 *
 	 * Protected by kvm->slots_lock.
 	 */
-	struct kvm_mmu_memory_cache split_shadow_page_cache;
+	struct kvm_mmu_memory_cache split_shadow_page_cache[MAX_NUMNODES];
 	struct kvm_mmu_memory_cache split_page_header_cache;
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 511c6ef265ee..7454bfc49a51 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6126,7 +6126,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
-	int r;
+	int r, nid;
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
@@ -6145,8 +6145,9 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_page_header_cache,
 				  mmu_page_header_cache, NUMA_NO_NODE);
 
-	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache,
-				  NULL, NUMA_NO_NODE);
+	for_each_node(nid)
+		INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_shadow_page_cache[nid],
+					  NULL, NUMA_NO_NODE);
 	spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
 
 	INIT_KVM_MMU_MEMORY_CACHE(&kvm->arch.split_desc_cache,
@@ -6157,10 +6158,13 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 
 static void mmu_free_vm_memory_caches(struct kvm *kvm)
 {
+	int nid;
+
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
-	mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache,
-				 &kvm->arch.split_shadow_page_cache_lock);
+	for_each_node(nid)
+		mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid],
+					 &kvm->arch.split_shadow_page_cache_lock);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -6269,7 +6273,7 @@ static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
 	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
 }
 
-static bool need_topup_split_caches_or_resched(struct kvm *kvm)
+static bool need_topup_split_caches_or_resched(struct kvm *kvm, int nid)
 {
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
 		return true;
@@ -6281,10 +6285,10 @@ static bool need_topup_split_caches_or_resched(struct kvm *kvm)
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
@@ -6314,18 +6318,21 @@ static int topup_split_caches(struct kvm *kvm)
 	if (r)
 		return r;
 
-	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache,
+	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache[nid],
 					 &kvm->arch.split_shadow_page_cache_lock,
 					 1);
 }
 
-static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
+static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm,
+							u64 *huge_sptep,
+							u64 huge_spte)
 {
 	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
 	struct shadow_page_caches caches = {};
 	union kvm_mmu_page_role role;
 	unsigned int access;
 	gfn_t gfn;
+	int nid;
 
 	gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
 	access = kvm_mmu_page_get_access(huge_sp, spte_index(huge_sptep));
@@ -6338,9 +6345,11 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 	 */
 	role = kvm_mmu_child_role(huge_sptep, /*direct=*/true, access);
 
+	nid = kvm_pfn_to_page_table_nid(spte_to_pfn(huge_spte));
+
 	/* Direct SPs do not require a shadowed_info_cache. */
 	caches.page_header_cache = &kvm->arch.split_page_header_cache;
-	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
+	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache[nid];
 	caches.shadow_page_cache_lock = &kvm->arch.split_shadow_page_cache_lock;
 
 	/* Safe to pass NULL for vCPU since requesting a direct SP. */
@@ -6360,7 +6369,7 @@ static void shadow_mmu_split_huge_page(struct kvm *kvm,
 	gfn_t gfn;
 	int index;
 
-	sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep);
+	sp = shadow_mmu_get_sp_for_split(kvm, huge_sptep, huge_spte);
 
 	for (index = 0; index < SPTE_ENT_PER_PAGE; index++) {
 		sptep = &sp->spt[index];
@@ -6398,7 +6407,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 					  u64 *huge_sptep)
 {
 	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
-	int level, r = 0;
+	int level, r = 0, nid;
 	gfn_t gfn;
 	u64 spte;
 
@@ -6406,13 +6415,14 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 	gfn = kvm_mmu_page_get_gfn(huge_sp, spte_index(huge_sptep));
 	level = huge_sp->role.level;
 	spte = *huge_sptep;
+	nid = kvm_pfn_to_page_table_nid(spte_to_pfn(spte));
 
 	if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES) {
 		r = -ENOSPC;
 		goto out;
 	}
 
-	if (need_topup_split_caches_or_resched(kvm)) {
+	if (need_topup_split_caches_or_resched(kvm, nid)) {
 		write_unlock(&kvm->mmu_lock);
 		cond_resched();
 		/*
@@ -6420,7 +6430,7 @@ static int shadow_mmu_try_split_huge_page(struct kvm *kvm,
 		 * rmap iterator should be restarted because the MMU lock was
 		 * dropped.
 		 */
-		r = topup_split_caches(kvm) ?: -EAGAIN;
+		r = topup_split_caches(kvm, nid) ?: -EAGAIN;
 		write_lock(&kvm->mmu_lock);
 		goto out;
 	}
@@ -6709,17 +6719,15 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 }
 
 static unsigned long mmu_shrink_cache(struct kvm_mmu_memory_cache *cache,
-				      int cache_count,
 				      spinlock_t *cache_lock)
 {
 	unsigned long freed = 0;
 	int nid;
 
 	spin_lock(cache_lock);
-	for (nid = 0; nid < cache_count; nid++) {
-		if (node_online(nid) && cache[nid].nobjs)
+	for_each_online_node(nid)
+		if (cache[nid].nobjs)
 			freed += kvm_mmu_empty_memory_cache(&cache[nid]);
-	}
 	spin_unlock(cache_lock);
 	return freed;
 }
@@ -6741,8 +6749,7 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			first_kvm = kvm;
 		list_move_tail(&kvm->vm_list, &vm_list);
 
-		freed += mmu_shrink_cache(&kvm->arch.split_shadow_page_cache,
-					  1,
+		freed += mmu_shrink_cache(kvm->arch.split_shadow_page_cache,
 					  &kvm->arch.split_shadow_page_cache_lock);
 
 		if (freed >= sc->nr_to_scan)
@@ -6750,7 +6757,6 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			freed += mmu_shrink_cache(vcpu->arch.mmu_shadow_page_cache,
-						  MAX_NUMNODES,
 						  &vcpu->arch.mmu_shadow_page_cache_lock);
 		}
 
-- 
2.39.0.314.g84b9a713c41-goog

