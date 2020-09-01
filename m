Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EBA258EC3
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 14:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgIAM5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 08:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727970AbgIALzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:55:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84299C061244;
        Tue,  1 Sep 2020 04:55:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id w186so555014pgb.8;
        Tue, 01 Sep 2020 04:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XUvXk7uAdxOXCAYNYYSMpSlE9fm+Z9Gs2q1bnYBY42w=;
        b=cL9oVCmw0qYQARPprOqleb2MVYCqsyuXh5Oqba2wRPIPl5nNywchx2ihKz+EXE8VMo
         EIGXPscJ2EN8eWy5PZnVJJslq/IUjaIVsFqXSCcxQHkJG24GOb5DXRKsOVy9dsWX+69I
         MqzTsrFmArCNwSX7fFVp0nOVbYK4WBvvPv2XTNj6b/AEVv0ORsnT8cTeNWafycwC2GKX
         QCzMKLEwjnMM4NPYezW12Mv0MrMDkPxEDJd6rGX/vcvDOeP2Dq87d4X2xmCI281HL1nF
         9Dan7DZxhVy94/qwb/30nw+WrU9/CTSD7omrJ/7M9xUzojsRF1k/6e2kdpmo/RvCSkAK
         527Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XUvXk7uAdxOXCAYNYYSMpSlE9fm+Z9Gs2q1bnYBY42w=;
        b=bzfSpjUqmDPhUg56CyeepQ6+S7jmQT7D/74hVknrArTfKUU3eP/qy+GKJt+yydDPxB
         ShHoz/SFBv6JQMsxzKz3walbY7CvjUEiR58XuO+jbVojqV/eJMwi5bbWfr3E6Et9qw+v
         tpFJaN7EHPXjhocl1bCkbw55dpWQ03vPSI7SkBuLEjKlyT53C1W2T7lAAztwHg1Bu58D
         5ztYjVtWGZ3LXijd8buDIwmua54Byif6sTH6woFiP3OErgXXBgrU1JbfdH0ybKy7g/gl
         S59zjJ2RSQgRqjHkW8UBZ9KK41CJTOiwN2QbYP24c2XkcGBH6j+45T/deF3KlnvPa3T4
         QWng==
X-Gm-Message-State: AOAM531k/EvT0i4bRfdNbPdmgy9qn9wKu17wp7HjojWCDq0HEfWVSXEH
        0fudQl05B906Bq74oSY/TlI=
X-Google-Smtp-Source: ABdhPJzBDeCYV5Lm44zND6Y+q8H6c+21x59KlXmQ6P3iNU3k8tMYoYGs4JxpfPdRzcM+Sr22z7iuVw==
X-Received: by 2002:a05:6a00:806:: with SMTP id m6mr1572382pfk.184.1598961352974;
        Tue, 01 Sep 2020 04:55:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.65])
        by smtp.gmail.com with ESMTPSA id e18sm1836796pgr.53.2020.09.01.04.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:55:52 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yulei.kernel@gmail.com>,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 7/9] Add migration support when using direct build EPT
Date:   Tue,  1 Sep 2020 19:56:40 +0800
Message-Id: <155ee1e921d840e8ae3bfa746d612ca9d4961ca3.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yulei.kernel@gmail.com>

Make migration available in direct build ept mode whether
pml enabled or not.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu/mmu.c          | 153 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  44 +++++----
 3 files changed, 178 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ab3cbef8c1aa..429a50c89268 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1318,6 +1318,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_mmu_slot_direct_build_handle_wp(struct kvm *kvm,
+					 struct kvm_memory_slot *memslot);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47d2a1c18f36..f03bf8efcefe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -249,6 +249,8 @@ struct kvm_shadow_walk_iterator {
 static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
+static int __kvm_write_protect_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t gfn, int level);
 
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
@@ -1644,11 +1646,18 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     gfn_t gfn_offset, unsigned long mask)
 {
 	struct kvm_rmap_head *rmap_head;
+	gfn_t gfn;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PG_LEVEL_4K, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		if (kvm->arch.global_root_hpa) {
+			gfn = slot->base_gfn + gfn_offset + __ffs(mask);
+
+			__kvm_write_protect_spte(kvm, slot, gfn, PG_LEVEL_4K);
+		} else {
+			rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+						  PG_LEVEL_4K, slot);
+			__rmap_write_protect(kvm, rmap_head, false);
+		}
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -6584,6 +6593,144 @@ void kvm_direct_tdp_release_global_root(struct kvm *kvm)
 	return;
 }
 
+static int __kvm_write_protect_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t gfn, int level)
+{
+	int ret = 0;
+	/* add write protect on pte, tear down the page table if large page is enabled */
+	struct kvm_shadow_walk_iterator iterator;
+	unsigned long i;
+	kvm_pfn_t pfn;
+	struct page *page;
+	u64 *sptep;
+	u64 spte, t_spte;
+
+	for_each_direct_build_shadow_entry(iterator, kvm->arch.global_root_hpa,
+			gfn << PAGE_SHIFT, max_tdp_level) {
+		if (iterator.level == level) {
+			break;
+		}
+	}
+
+	if (level != PG_LEVEL_4K) {
+		sptep = iterator.sptep;
+
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!page)
+			return ret;
+
+		t_spte = page_to_phys(page) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
+			shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
+
+		for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++) {
+
+			for_each_direct_build_shadow_entry(iterator, t_spte & PT64_BASE_ADDR_MASK,
+					gfn << PAGE_SHIFT, level - 1) {
+				if (iterator.level == PG_LEVEL_4K) {
+					break;
+				}
+
+				if (!is_shadow_present_pte(*iterator.sptep)) {
+					struct page *page;
+					page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+					if (!page) {
+						__kvm_walk_global_page(kvm, t_spte & PT64_BASE_ADDR_MASK, level - 1);
+						return ret;
+					}
+					spte = page_to_phys(page) | PT_PRESENT_MASK | PT_WRITABLE_MASK |
+						shadow_user_mask | shadow_x_mask | shadow_accessed_mask;
+					mmu_spte_set(iterator.sptep, spte);
+				}
+			}
+
+			pfn = gfn_to_pfn_try_write(slot, gfn);
+			if ((pfn & KVM_PFN_ERR_FAULT) || is_noslot_pfn(pfn))
+				return ret;
+
+			if (kvm_x86_ops.slot_enable_log_dirty)
+				direct_build_tdp_set_spte(kvm, slot, iterator.sptep,
+						ACC_ALL, iterator.level, gfn, pfn, false, false, true);
+
+			else
+				direct_build_tdp_set_spte(kvm, slot, iterator.sptep,
+						ACC_EXEC_MASK | ACC_USER_MASK, iterator.level, gfn, pfn, false, true, true);
+			gfn++;
+		}
+		WARN_ON(!is_last_spte(*sptep, level));
+		pfn = spte_to_pfn(*sptep);
+		mmu_spte_clear_track_bits(sptep);
+		kvm_release_pfn_clean(pfn);
+		mmu_spte_set(sptep, t_spte);
+	} else {
+		if (kvm_x86_ops.slot_enable_log_dirty)
+			spte_clear_dirty(iterator.sptep);
+		else
+			spte_write_protect(iterator.sptep, false);
+	}
+	return ret;
+}
+
+static void __kvm_remove_wp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+					gfn_t gfn, int level)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	kvm_pfn_t pfn;
+	u64 addr, spte;
+
+	for_each_direct_build_shadow_entry(iterator, kvm->arch.global_root_hpa,
+			gfn << PAGE_SHIFT, max_tdp_level) {
+		if (iterator.level == level)
+			break;
+	}
+
+	if (level != PG_LEVEL_4K) {
+		if (is_shadow_present_pte(*iterator.sptep)) {
+			addr = (*iterator.sptep) & PT64_BASE_ADDR_MASK;
+
+			pfn = gfn_to_pfn_try_write(slot, gfn);
+			if ((pfn & KVM_PFN_ERR_FAULT) || is_noslot_pfn(pfn)) {
+				printk("Failed to alloc page\n");
+				return;
+			}
+			mmu_spte_clear_track_bits(iterator.sptep);
+			direct_build_tdp_set_spte(kvm, slot, iterator.sptep,
+					ACC_ALL, level, gfn, pfn, false, true, true);
+
+			__kvm_walk_global_page(kvm, addr, level - 1);
+		}
+	} else {
+		if (is_shadow_present_pte(*iterator.sptep)) {
+			if (kvm_x86_ops.slot_enable_log_dirty) {
+				spte_set_dirty(iterator.sptep);
+			} else {
+				spte = (*iterator.sptep) | PT_WRITABLE_MASK;
+				mmu_spte_update(iterator.sptep, spte);
+			}
+		}
+	}
+}
+
+void kvm_mmu_slot_direct_build_handle_wp(struct kvm *kvm,
+					 struct kvm_memory_slot *memslot)
+{
+	gfn_t gfn = memslot->base_gfn;
+	int host_level;
+
+	/* remove write mask from PTE */
+	for (gfn = memslot->base_gfn; gfn < memslot->base_gfn + memslot->npages; ) {
+
+		host_level = direct_build_mapping_level(kvm, memslot, gfn);
+
+		if (memslot->flags & KVM_MEM_LOG_DIRTY_PAGES)
+			__kvm_write_protect_spte(kvm, memslot, gfn, host_level);
+		else
+			__kvm_remove_wp_spte(kvm, memslot, gfn, host_level);
+		gfn += KVM_PAGES_PER_HPAGE(host_level);
+	}
+
+	kvm_flush_remote_tlbs(kvm);
+}
+
 /*
  * Calculate mmu pages needed for kvm.
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 599d73206299..ee898003f22f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10196,9 +10196,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 *		kvm_arch_flush_shadow_memslot()
 	 */
 	if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-	    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		kvm_mmu_zap_collapsible_sptes(kvm, new);
-
+	    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
+		if (kvm->arch.global_root_hpa)
+			kvm_mmu_slot_direct_build_handle_wp(kvm, (struct kvm_memory_slot *)new);
+		else
+			kvm_mmu_zap_collapsible_sptes(kvm, new);
+	}
 	/*
 	 * Enable or disable dirty logging for the slot.
 	 *
@@ -10228,25 +10231,30 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * is enabled the D-bit or the W-bit will be cleared.
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-		if (kvm_x86_ops.slot_enable_log_dirty) {
-			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
+		if (kvm->arch.global_root_hpa) {
+			kvm_mmu_slot_direct_build_handle_wp(kvm, new);
 		} else {
-			int level =
-				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
-				PG_LEVEL_2M : PG_LEVEL_4K;
+			if (kvm_x86_ops.slot_enable_log_dirty) {
+				kvm_x86_ops.slot_enable_log_dirty(kvm, new);
+			} else {
+				int level =
+					kvm_dirty_log_manual_protect_and_init_set(kvm) ?
+					PG_LEVEL_2M : PG_LEVEL_4K;
 
-			/*
-			 * If we're with initial-all-set, we don't need
-			 * to write protect any small page because
-			 * they're reported as dirty already.  However
-			 * we still need to write-protect huge pages
-			 * so that the page split can happen lazily on
-			 * the first write to the huge page.
-			 */
-			kvm_mmu_slot_remove_write_access(kvm, new, level);
+				/*
+				 * If we're with initial-all-set, we don't need
+				 * to write protect any small page because
+				 * they're reported as dirty already.  However
+				 * we still need to write-protect huge pages
+				 * so that the page split can happen lazily on
+				 * the first write to the huge page.
+				 */
+				kvm_mmu_slot_remove_write_access(kvm, new, level);
+			}
 		}
 	} else {
-		if (kvm_x86_ops.slot_disable_log_dirty)
+		if (kvm_x86_ops.slot_disable_log_dirty
+			&& !kvm->arch.global_root_hpa)
 			kvm_x86_ops.slot_disable_log_dirty(kvm, new);
 	}
 }
-- 
2.17.1

