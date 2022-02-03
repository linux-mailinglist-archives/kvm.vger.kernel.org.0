Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B604A7D25
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348678AbiBCBBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348675AbiBCBBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:20 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDFAC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:20 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t7-20020a634447000000b0036579648983so582303pgk.3
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y4ZDSzE5ON4YdtRzBulHie84tQs+2RQs6E8TDceZkmE=;
        b=Co+cTdlUHj6lqw8GTk8KzU6DETBKf8ntBjmrbNAz1o6lemkOI0FbHKtvkY9lzpzDxF
         JQ8kZGur4tqwj2oGY7X9ewYLLflS45UdFJ2ow8bqIHUYAe22Z9VkAyElxGbMw0jPCd1q
         VnM0fGakYQ95lM46AyzTRYouAqjBp0oy76lGkYvgZ7g7KJ4fYzbK6WP3qaOEMWdBcIOf
         l+IVctVgAOIO//jmBRRbeaELjCIKowHcMcUX3RId8pNAMsKLsZUdkjwa49sjfhG2R0Py
         lxZD6QhCSGdy1V1d4fVkojcGyL8ytCbgERnbmb2VSS4s98nLgZkWlkEF4W5/ZuavhQl5
         /1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y4ZDSzE5ON4YdtRzBulHie84tQs+2RQs6E8TDceZkmE=;
        b=U8iyOdLaFBt3fQ5HeDxmehjZaFJW1sDbasQgCL368DHFCmQaXz2onuBtIbH4zmo6uP
         Xg46vc8I1xU7zkITn+Ga8l5uUjwmwAXJTiwheYo0xQ4J7tmKJXT93bgCc3jVEfAZoclu
         H7QOA1vBhrRrWkHN5S7oHKMxyxsBWE/ermzDUGd0A7SzVR1mBJyX2G7fi4mPjieYSZMB
         bkYCZo9h6vU7576th1awZpBMMaIOpjjWy9D0afogoA+hKvA8ewT4yoZi2kAFRNhYq1Et
         mSXWCaa2yw9l01WeZMM3CAFKm0oCDKKuJ9BpD0n75iUwPYnvplQf2WgdYVmHp120B7bU
         mnbg==
X-Gm-Message-State: AOAM532ke2ZUakZOu2oyryEivy7Rmq7oPoW5iZzyJntc7TUTQxhgJfqq
        j2yzAzwjcZmaUK4kWMtS/roPV9jJs1PBqg==
X-Google-Smtp-Source: ABdhPJxFw07Ea+BRSOjqA2kzJDJL1A+Kj6A3wosxu5j9kIWlPxhLwG/ZtLiFj7D5RjnRd1Qf3SwYv7+y7+Bwcg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:230e:: with SMTP id
 h14mr32502294pfh.10.1643850080107; Wed, 02 Feb 2022 17:01:20 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:40 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 12/23] KVM: x86/mmu: Decouple rmap_add() and
 link_shadow_page() from kvm_vcpu
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

Allow adding new entries to the rmap and linking shadow pages without a
struct kvm_vcpu pointer by moving the implementation of rmap_add() and
link_shadow_page() into inner helper functions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 43 +++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index de7c47ee0def..c2f7f026d414 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -736,9 +736,9 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
+static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
 {
-	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	return kvm_mmu_memory_cache_alloc(cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -885,7 +885,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 /*
  * Returns the number of pointers in the rmap chain, not counting the new one.
  */
-static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
+static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 			struct kvm_rmap_head *rmap_head)
 {
 	struct pte_list_desc *desc;
@@ -896,7 +896,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
 		rmap_printk("%p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_pte_list_desc(vcpu);
+		desc = mmu_alloc_pte_list_desc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
@@ -908,7 +908,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
 			if (!desc->more) {
-				desc->more = mmu_alloc_pte_list_desc(vcpu);
+				desc->more = mmu_alloc_pte_list_desc(cache);
 				desc = desc->more;
 				desc->spte_count = 0;
 				break;
@@ -1607,8 +1607,10 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 #define RMAP_RECYCLE_THRESHOLD 1000
 
-static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn)
+static void __rmap_add(struct kvm *kvm,
+		       struct kvm_mmu_memory_cache *cache,
+		       const struct kvm_memory_slot *slot,
+		       u64 *spte, gfn_t gfn)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
@@ -1617,15 +1619,21 @@ static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
 	sp = sptep_to_sp(spte);
 	kvm_mmu_page_set_gfn(sp, spte - sp->spt, gfn);
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
-	rmap_count = pte_list_add(vcpu, spte, rmap_head);
+	rmap_count = pte_list_add(cache, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		kvm_unmap_rmapp(kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 		kvm_flush_remote_tlbs_with_address(
-				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
+				kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}
 }
 
+static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
+		     u64 *spte, gfn_t gfn)
+{
+	__rmap_add(vcpu->kvm, &vcpu->arch.mmu_pte_list_desc_cache, slot, spte, gfn);
+}
+
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
@@ -1693,13 +1701,13 @@ static unsigned kvm_page_table_hashfn(gfn_t gfn)
 	return hash_64(gfn, KVM_MMU_HASH_SHIFT);
 }
 
-static void mmu_page_add_parent_pte(struct kvm_vcpu *vcpu,
+static void mmu_page_add_parent_pte(struct kvm_mmu_memory_cache *cache,
 				    struct kvm_mmu_page *sp, u64 *parent_pte)
 {
 	if (!parent_pte)
 		return;
 
-	pte_list_add(vcpu, parent_pte, &sp->parent_ptes);
+	pte_list_add(cache, parent_pte, &sp->parent_ptes);
 }
 
 static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
@@ -2297,8 +2305,8 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 	__shadow_walk_next(iterator, *iterator->sptep);
 }
 
-static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
-			     struct kvm_mmu_page *sp)
+static void __link_shadow_page(struct kvm_mmu_memory_cache *cache, u64 *sptep,
+			       struct kvm_mmu_page *sp)
 {
 	u64 spte;
 
@@ -2308,12 +2316,17 @@ static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
 
 	mmu_spte_set(sptep, spte);
 
-	mmu_page_add_parent_pte(vcpu, sp, sptep);
+	mmu_page_add_parent_pte(cache, sp, sptep);
 
 	if (sp->unsync_children || sp->unsync)
 		mark_unsync(sptep);
 }
 
+static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep, struct kvm_mmu_page *sp)
+{
+	__link_shadow_page(&vcpu->arch.mmu_pte_list_desc_cache, sptep, sp);
+}
+
 static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 				   unsigned direct_access)
 {
-- 
2.35.0.rc2.247.g8bbb082509-goog

