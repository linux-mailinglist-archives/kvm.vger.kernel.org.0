Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936D44A7D1A
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348707AbiBCBBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348709AbiBCBBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:35 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A0C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:35 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 125-20020a630383000000b0035d88cc4fedso549099pgd.20
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZsqQTkXhg8Ie3Ecu3y1aWjvt5l3mqJi5K8xgwpfLxrw=;
        b=NI/XjNPfaKWmpX4pvyx6v2BFMvv8n0NI0tsjEZjaLJzKWqofQ3CeXyQ3s2PjoPZzqJ
         BHk4HvtE+5o3gFTr86LFtv6PVouPnXCnAt1hz32h3yH3cKQ2XbMoUmTj3FGpPLlVspSI
         LNGPBXQRFjAIZmw67hYNOIitCNv3GD1LGFsfw0daPzmt1zE5QcOB5gZT7esj0E7UlBKI
         AUeLhTtkk6yAFiirE8ODKRJrdsIZjNSd1YmNCy8DOVGbpfmvDLo+pLp8p8fS766qJAUG
         uJCCbFPu2NK4nw1k/adJUVcZiKdHqk8Wt2OZh6XU6z91A0TOx1uOe7dlQI9lRooSNVN/
         SiTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZsqQTkXhg8Ie3Ecu3y1aWjvt5l3mqJi5K8xgwpfLxrw=;
        b=tOuFEsczdvHjhoHXaEU4E+iQVAPh6PYQY6UPQYXpiMC+Qtd6npl5f3FwIIoNv5/k5W
         0ooIZt3j5df7oJSUdlcoRuUb5eQfRcdhZkbj9sMBojWqz7D7yuw95cViHM587myiw5jt
         1+Dc/29j+Qu3bHQuO2lnjEFpTumE5ke7a+6rKX+kFhIpYlzmxjXWpZfrcMbVgxS9ep8t
         1vRnMJ4CxxyncUjr7n9uAe858J5t7XQF8KU5HU3kpb+n3aF3Kyr/GAI4kQjGE+j1v49P
         7otFGFHO9AlIr2WH7k+Re98Drx6El7yeN7BvMYo3KjDzQVZz7ZHPX97c4OmJJr8knjjv
         J0ZA==
X-Gm-Message-State: AOAM531wdUIM0a01EtCjSOPmyu/mGcTv/J5Ny6qsO1/K12cKjm7uXlRL
        NqxFl9EdU28WwLqApj2254aXcWCe3Z4zMw==
X-Google-Smtp-Source: ABdhPJy9ejZI4VsRf2Kga9TJenxF4gjw8WSy+IUooYXexJ3+3Ti7kdlLU8J9uhVbm4mXyrp35b13oFdYrQSt5w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:9634:: with SMTP id
 r20mr31763851pfg.57.1643850095023; Wed, 02 Feb 2022 17:01:35 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:49 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-22-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 21/23] KVM: x86/mmu: Fully split huge pages that require extra
 pte_list_desc structs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When splitting a huge page we need to add all of the lower level SPTEs
to the memslot rmap. The current implementation of eager page splitting
bails if adding an SPTE would require allocating an extra pte_list_desc
struct. Fix this limitation by allocating enough pte_list_desc structs
before splitting the huge page.

This eliminates the need for TLB flushing under the MMU lock because the
huge page is always entirely split (no subregion of the huge page is
unmapped).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h |  10 ++++
 arch/x86/kvm/mmu/mmu.c          | 101 ++++++++++++++++++--------------
 2 files changed, 67 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d0b12bfe5818..a0f7578f7a26 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1232,6 +1232,16 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	/*
+	 * Memory cache used to allocate pte_list_desc structs while splitting
+	 * huge pages. In the worst case, to split one huge page we need 512
+	 * pte_list_desc structs to add each new lower level leaf sptep to the
+	 * memslot rmap.
+	 */
+#define HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY 512
+	__DEFINE_KVM_MMU_MEMORY_CACHE(huge_page_split_desc_cache,
+				      HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY);
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 825cfdec589b..c7981a934237 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5905,6 +5905,11 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
+
+	kvm->arch.huge_page_split_desc_cache.capacity =
+		HUGE_PAGE_SPLIT_DESC_CACHE_CAPACITY;
+	kvm->arch.huge_page_split_desc_cache.kmem_cache = pte_list_desc_cache;
+	kvm->arch.huge_page_split_desc_cache.gfp_zero = __GFP_ZERO;
 }
 
 void kvm_mmu_uninit_vm(struct kvm *kvm)
@@ -6035,9 +6040,42 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
+static int min_descs_for_split(const struct kvm_memory_slot *slot, u64 *huge_sptep)
+{
+	struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
+	int split_level = huge_sp->role.level - 1;
+	int i, min = 0;
+	gfn_t gfn;
+
+	gfn = kvm_mmu_page_get_gfn(huge_sp, huge_sptep - huge_sp->spt);
 
-static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp, gfp_t gfp)
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		if (rmap_need_new_pte_list_desc(slot, gfn, split_level))
+			min++;
+
+		gfn += KVM_PAGES_PER_HPAGE(split_level);
+	}
+
+	return min;
+}
+
+static int topup_huge_page_split_desc_cache(struct kvm *kvm, int min, gfp_t gfp)
+{
+	struct kvm_mmu_memory_cache *cache =
+		&kvm->arch.huge_page_split_desc_cache;
+
+	return __kvm_mmu_topup_memory_cache(cache, min, gfp);
+}
+
+static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp,
+				  int min_descs, gfp_t gfp)
 {
+	int r;
+
+	r = topup_huge_page_split_desc_cache(kvm, min_descs, gfp);
+	if (r)
+		return r;
+
 	if (*spp)
 		return 0;
 
@@ -6050,9 +6088,9 @@ static int prepare_to_split_huge_page(struct kvm *kvm,
 				      const struct kvm_memory_slot *slot,
 				      u64 *huge_sptep,
 				      struct kvm_mmu_page **spp,
-				      bool *flush,
 				      bool *dropped_lock)
 {
+	int min_descs = min_descs_for_split(slot, huge_sptep);
 	int r = 0;
 
 	*dropped_lock = false;
@@ -6063,22 +6101,18 @@ static int prepare_to_split_huge_page(struct kvm *kvm,
 	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
 		goto drop_lock;
 
-	r = alloc_memory_for_split(kvm, spp, GFP_NOWAIT | __GFP_ACCOUNT);
+	r = alloc_memory_for_split(kvm, spp, min_descs, GFP_NOWAIT | __GFP_ACCOUNT);
 	if (r)
 		goto drop_lock;
 
 	return 0;
 
 drop_lock:
-	if (*flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
-
-	*flush = false;
 	*dropped_lock = true;
 
 	write_unlock(&kvm->mmu_lock);
 	cond_resched();
-	r = alloc_memory_for_split(kvm, spp, GFP_KERNEL_ACCOUNT);
+	r = alloc_memory_for_split(kvm, spp, min_descs, GFP_KERNEL_ACCOUNT);
 	write_lock(&kvm->mmu_lock);
 
 	return r;
@@ -6122,10 +6156,10 @@ static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
 
 static int kvm_mmu_split_huge_page(struct kvm *kvm,
 				   const struct kvm_memory_slot *slot,
-				   u64 *huge_sptep, struct kvm_mmu_page **spp,
-				   bool *flush)
+				   u64 *huge_sptep, struct kvm_mmu_page **spp)
 
 {
+	struct kvm_mmu_memory_cache *cache;
 	struct kvm_mmu_page *split_sp;
 	u64 huge_spte, split_spte;
 	int split_level, index;
@@ -6138,9 +6172,9 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 		return -EOPNOTSUPP;
 
 	/*
-	 * Since we did not allocate pte_list_desc_structs for the split, we
-	 * cannot add a new parent SPTE to parent_ptes. This should never happen
-	 * in practice though since this is a fresh SP.
+	 * We did not allocate an extra pte_list_desc struct to add huge_sptep
+	 * to split_sp->parent_ptes. An extra pte_list_desc struct should never
+	 * be necessary in practice though since split_sp is brand new.
 	 *
 	 * Note, this makes it safe to pass NULL to __link_shadow_page() below.
 	 */
@@ -6151,6 +6185,7 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 
 	split_level = split_sp->role.level;
 	access = split_sp->role.access;
+	cache = &kvm->arch.huge_page_split_desc_cache;
 
 	for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
 		split_sptep = &split_sp->spt[index];
@@ -6158,25 +6193,11 @@ static int kvm_mmu_split_huge_page(struct kvm *kvm,
 
 		BUG_ON(is_shadow_present_pte(*split_sptep));
 
-		/*
-		 * Since we did not allocate pte_list_desc structs for the
-		 * split, we can't add a new SPTE that maps this GFN.
-		 * Skipping this SPTE means we're only partially mapping the
-		 * huge page, which means we'll need to flush TLBs before
-		 * dropping the MMU lock.
-		 *
-		 * Note, this make it safe to pass NULL to __rmap_add() below.
-		 */
-		if (rmap_need_new_pte_list_desc(slot, split_gfn, split_level)) {
-			*flush = true;
-			continue;
-		}
-
 		split_spte = make_huge_page_split_spte(
 				huge_spte, split_level + 1, index, access);
 
 		mmu_spte_set(split_sptep, split_spte);
-		__rmap_add(kvm, NULL, slot, split_sptep, split_gfn, access);
+		__rmap_add(kvm, cache, slot, split_sptep, split_gfn, access);
 	}
 
 	/*
@@ -6222,7 +6243,6 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 	struct kvm_mmu_page *sp = NULL;
 	struct rmap_iterator iter;
 	u64 *huge_sptep, spte;
-	bool flush = false;
 	bool dropped_lock;
 	int level;
 	gfn_t gfn;
@@ -6237,7 +6257,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 		level = sptep_to_sp(huge_sptep)->role.level;
 		gfn = sptep_to_gfn(huge_sptep);
 
-		r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &flush, &dropped_lock);
+		r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &dropped_lock);
 		if (r) {
 			trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
 			break;
@@ -6246,7 +6266,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 		if (dropped_lock)
 			goto restart;
 
-		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp, &flush);
+		r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp);
 
 		trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
 
@@ -6261,7 +6281,7 @@ static bool rmap_try_split_huge_pages(struct kvm *kvm,
 	if (sp)
 		kvm_mmu_free_sp(sp);
 
-	return flush;
+	return false;
 }
 
 static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
@@ -6269,7 +6289,6 @@ static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
 					  gfn_t start, gfn_t end,
 					  int target_level)
 {
-	bool flush;
 	int level;
 
 	/*
@@ -6277,21 +6296,15 @@ static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
 	 * down to the target level. This ensures pages are recursively split
 	 * all the way to the target level. There's no need to split pages
 	 * already at the target level.
-	 *
-	 * Note that TLB flushes must be done before dropping the MMU lock since
-	 * rmap_try_split_huge_pages() may partially split any given huge page,
-	 * i.e. it may effectively unmap (make non-present) a portion of the
-	 * huge page.
 	 */
 	for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
-		flush = slot_handle_level_range(kvm, slot,
-						rmap_try_split_huge_pages,
-						level, level, start, end - 1,
-						true, flush);
+		slot_handle_level_range(kvm, slot,
+					rmap_try_split_huge_pages,
+					level, level, start, end - 1,
+					true, false);
 	}
 
-	if (flush)
-		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+	kvm_mmu_free_memory_cache(&kvm->arch.huge_page_split_desc_cache);
 }
 
 /* Must be called with the mmu_lock held in write-mode. */
-- 
2.35.0.rc2.247.g8bbb082509-goog

