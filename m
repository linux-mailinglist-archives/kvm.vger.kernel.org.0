Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D92D653AA7
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbiLVCfM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234967AbiLVCfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:06 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980A8248D3
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:05 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id l63-20020a639142000000b0047942953738so407484pge.15
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+chyPC2pzC5mKivdZn2tXKKp7i5hdJsSiGnXjGpd+qo=;
        b=nHCHJ906sv9cxX8DnY/jDErP4w5InUk/yQ735EsKsvPVAmpXxi0y6/6oFa0Ure2H/v
         hzYxnyKvYvrKkdb7uMSqsnWwhBbO0EhadDcgtpLc22KCypMQx7uCwCa782RsWJA/djXh
         VToUto+d6Ob3eNyF0TG05M2icTNN9rOnPtRuHqrAeoZZawgG/HO/2quETm+y7BdXSAPK
         3XuARlSbS0ji1U90zg9ATDqpNhQy4Ra4Dar/1GHhR8l812S8MSprSWgnsTFSq6tDseSY
         XQXRLkfGe7gPLZJHtk0190ocrakiM/5KtJaA73UsDTTKrqmvqSCLZ8UryxcP8WaMHZlQ
         Lq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+chyPC2pzC5mKivdZn2tXKKp7i5hdJsSiGnXjGpd+qo=;
        b=5gEqjG2uBsnxT2oA5m3amtEWySM47UlxXvT5huc6KYaWQj2AESNxbBZkaTC3fpSE6P
         UHiRKz7F91HYKQEAMlhGsLAPzt5kKCVUBHQQi26D8opKthZqoz+gHE1EMYAzjpdJU1BA
         /TI+RtobYjbGSlkpAc3wIKlaueL4fcmWWxKXmkyxVh25+cHb9esNhVA7ckrkbuznRrML
         kWyOdfjAsXW4PYLFR9JJ4EZqK0pJAm7MFLaoX8Mndlxfv+cSIrOMLT+Zhvzh+lOYQR2V
         vDT2jKc45NCbGsgkUV5rjeLGb1zLCjLhLeHRRu4BSjqyIFSSEO16cQoSe9aWSQTltCV5
         pFyQ==
X-Gm-Message-State: AFqh2koahT7ccfu9dqV38VvtAQs9qO7qVnK0fN/28uUEw9DtO4pRKrlU
        mbe4T0bjBtrVlXXs8Dd6LImDgxatqCXS
X-Google-Smtp-Source: AMrXdXsothIyZZv/0F4TXnv6H6IlW73v2BSr7V+Bexsj6gh/v1vAiynOCYEIOrsxLEPfYDTbw3BlGUXc6gE7
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a63:8c48:0:b0:479:46cd:e2dc with SMTP id
 q8-20020a638c48000000b0047946cde2dcmr163712pgn.547.1671676505112; Wed, 21 Dec
 2022 18:35:05 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:51 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-4-vipinsh@google.com>
Subject: [Patch v3 3/9] KVM: x86/mmu: Shrink split_shadow_page_cache via KVM
 MMU shrinker
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

split_shadow_page_cache is not used after dirty log is disabled. It is a
good candidate to free memory in case of mmu_shrink_scan kicks in.

Account for split_shadow_page_cache via kvm_total_unused_mmu_pages and
use it in mmu_shrink_scan.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++
 arch/x86/kvm/mmu/mmu.c          | 63 +++++++++++++++++++--------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f89f02e18080..293994fabae3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1413,6 +1413,11 @@ struct kvm_arch {
 	struct kvm_mmu_memory_cache split_shadow_page_cache;
 	struct kvm_mmu_memory_cache split_page_header_cache;
 
+	/*
+	 * Protects change in size of split_shadow_page_cache cache.
+	 */
+	spinlock_t split_shadow_page_cache_lock;
+
 	/*
 	 * Memory cache used to allocate pte_list_desc structs while splitting
 	 * huge pages. In the worst case, to split one huge page, 512
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3364760a1695..6f6a10d7a871 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -659,14 +659,15 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 }
 
 static int mmu_topup_sp_memory_cache(struct kvm_mmu_memory_cache *cache,
-				     spinlock_t *cache_lock)
+				     spinlock_t *cache_lock,
+				     int min)
 {
 	int orig_nobjs;
 	int r;
 
 	spin_lock(cache_lock);
 	orig_nobjs = cache->nobjs;
-	r = kvm_mmu_topup_memory_cache(cache, PT64_ROOT_MAX_LEVEL);
+	r = kvm_mmu_topup_memory_cache(cache, min);
 	if (orig_nobjs != cache->nobjs)
 		percpu_counter_add(&kvm_total_unused_mmu_pages,
 				   (cache->nobjs - orig_nobjs));
@@ -684,7 +685,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 	if (r)
 		return r;
 	r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
-				      &vcpu->arch.mmu_shadow_page_cache_lock);
+				      &vcpu->arch.mmu_shadow_page_cache_lock,
+				      PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
 	if (maybe_indirect) {
@@ -2184,16 +2186,12 @@ void *kvm_mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *shadow_page_cac
 	int orig_nobjs;
 	void *page;
 
-	if (!cache_lock) {
-		spin_lock(cache_lock);
-		orig_nobjs = shadow_page_cache->nobjs;
-	}
+	spin_lock(cache_lock);
+	orig_nobjs = shadow_page_cache->nobjs;
 	page = kvm_mmu_memory_cache_alloc(shadow_page_cache);
-	if (!cache_lock) {
-		if (orig_nobjs)
-			percpu_counter_dec(&kvm_total_unused_mmu_pages);
-		spin_unlock(cache_lock);
-	}
+	if (orig_nobjs)
+		percpu_counter_dec(&kvm_total_unused_mmu_pages);
+	spin_unlock(cache_lock);
 	return page;
 }
 
@@ -6130,6 +6128,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	kvm->arch.split_page_header_cache.gfp_zero = __GFP_ZERO;
 
 	kvm->arch.split_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	spin_lock_init(&kvm->arch.split_shadow_page_cache_lock);
 
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
@@ -6141,7 +6140,8 @@ static void mmu_free_vm_memory_caches(struct kvm *kvm)
 {
 	kvm_mmu_free_memory_cache(&kvm->arch.split_desc_cache);
 	kvm_mmu_free_memory_cache(&kvm->arch.split_page_header_cache);
-	kvm_mmu_free_memory_cache(&kvm->arch.split_shadow_page_cache);
+	mmu_free_sp_memory_cache(&kvm->arch.split_shadow_page_cache,
+				 &kvm->arch.split_shadow_page_cache_lock);
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -6295,7 +6295,9 @@ static int topup_split_caches(struct kvm *kvm)
 	if (r)
 		return r;
 
-	return kvm_mmu_topup_memory_cache(&kvm->arch.split_shadow_page_cache, 1);
+	return mmu_topup_sp_memory_cache(&kvm->arch.split_shadow_page_cache,
+					 &kvm->arch.split_shadow_page_cache_lock,
+					 1);
 }
 
 static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *huge_sptep)
@@ -6320,7 +6322,7 @@ static struct kvm_mmu_page *shadow_mmu_get_sp_for_split(struct kvm *kvm, u64 *hu
 	/* Direct SPs do not require a shadowed_info_cache. */
 	caches.page_header_cache = &kvm->arch.split_page_header_cache;
 	caches.shadow_page_cache = &kvm->arch.split_shadow_page_cache;
-	caches.shadow_page_cache_lock = NULL;
+	caches.shadow_page_cache_lock = &kvm->arch.split_shadow_page_cache_lock;
 
 	/* Safe to pass NULL for vCPU since requesting a direct SP. */
 	return __kvm_mmu_get_shadow_page(kvm, NULL, &caches, gfn, role);
@@ -6687,14 +6689,23 @@ void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 	}
 }
 
+static unsigned long mmu_shrink_cache(struct kvm_mmu_memory_cache *cache,
+				      spinlock_t *cache_lock)
+{
+	unsigned long freed = 0;
+
+	spin_lock(cache_lock);
+	if (cache->nobjs)
+		freed = kvm_mmu_empty_memory_cache(cache);
+	spin_unlock(cache_lock);
+	return freed;
+}
+
 static unsigned long
 mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	struct kvm_mmu_memory_cache *cache;
 	struct kvm *kvm, *first_kvm = NULL;
 	unsigned long freed = 0;
-	/* spinlock for memory cache */
-	spinlock_t *cache_lock;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
@@ -6707,15 +6718,15 @@ mmu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 			first_kvm = kvm;
 		list_move_tail(&kvm->vm_list, &vm_list);
 
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			cache = &vcpu->arch.mmu_shadow_page_cache;
-			cache_lock = &vcpu->arch.mmu_shadow_page_cache_lock;
-			if (READ_ONCE(cache->nobjs)) {
-				spin_lock(cache_lock);
-				freed += kvm_mmu_empty_memory_cache(cache);
-				spin_unlock(cache_lock);
-			}
+		freed += mmu_shrink_cache(&kvm->arch.split_shadow_page_cache,
+					  &kvm->arch.split_shadow_page_cache_lock);
 
+		if (freed >= sc->nr_to_scan)
+			break;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			freed += mmu_shrink_cache(&vcpu->arch.mmu_shadow_page_cache,
+						  &vcpu->arch.mmu_shadow_page_cache_lock);
 		}
 
 		if (freed >= sc->nr_to_scan)
-- 
2.39.0.314.g84b9a713c41-goog

