Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B007923D11E
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgHET4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbgHEQoM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:44:12 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA13C0086CD;
        Wed,  5 Aug 2020 07:14:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t11so5486145plr.5;
        Wed, 05 Aug 2020 07:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=91YW5ED4v1tRh3CUsEOp6Qs783LYngGUb2jh2KPIkMg=;
        b=rOUemIincMfQVNZ5zPioG6CdDihWgeNjJaP9GBooWAR/0Bc4A4OjuPx+GU54slJWeb
         SN4YPSSc+eQ4BIYFJLmM0+X11Ks0i5s4AVdu0HoxkqiGevWO/omd2oSOnwZ4EcB134TJ
         uhT2cLL5X3RMkiOVyIQJvusFe9Skf0DUK4SBBByKYG4fWyD4YHYmVvgQjVZj2rTfn8X8
         r33p2/O0fVEQnaWJgsE1ixjVUgLCTpLkFF1kf00LQgqkA2Obua3GVlQL7AstS0rhH5yW
         nHkqjbWg7txC49XbeCVvIM96+Vi3uJ82c1a3BCYFUkR73UqfUS1pD8nmVryWZ5SaD5fQ
         pkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=91YW5ED4v1tRh3CUsEOp6Qs783LYngGUb2jh2KPIkMg=;
        b=JYgt06uDmixahDPJUa6TcCxoG56MQQ5h8mDVRUhTWNeKBIX+8WU8uT0K8MWfd7bzvr
         CARBEbM+dOCyQKAdl68TEi6Ey+ItweY8Ig+CmqtXtX6CZ/ODNHCHglMI0K4eGhaU9dv4
         RhzFCHmKi4TLG8euZeflM5KQexxdRUB/Aef+JDg6sWDZ+9WlRzleFpaoTRYjHlWPk7bI
         bBZN8eQf5/1zzE+qdnJ4D5LhrS3uw8KzO2mEyl6i/vaVgrfTyzj7/0drVMEoKAsitrJn
         ixPTjIZ+tJW/WEjX0zrduCkowEptufcGbKj08Ke2nXd/kVAJBLbfbhWa49fmfIbEsdJe
         yXgA==
X-Gm-Message-State: AOAM531eBc7aGH1c3lyRQqx5mBC99TGEDiYMxNVRvd5YRTub10C7Ww3B
        gQqTrzAS7/2K5Z9Qeg/EUbo=
X-Google-Smtp-Source: ABdhPJzspVzoegO673mvpxSae5jtY4cxqu7QXwuzl7RFhlB3MWenVnN4v0CzmBncHaa9Sb6SluIhPw==
X-Received: by 2002:a17:90a:a511:: with SMTP id a17mr3602420pjq.23.1596636884279;
        Wed, 05 Aug 2020 07:14:44 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.gmail.com with ESMTPSA id y196sm3862420pfc.202.2020.08.05.07.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:14:43 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 7/9] Add migration support when using direct build EPT
Date:   Wed,  5 Aug 2020 22:15:33 +0800
Message-Id: <20200805141533.9333-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Make migration available in direct build ept mode whether
pml enabled or not.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu/mmu.c          | 153 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  44 +++++----
 3 files changed, 178 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 69c946831ca7..7063b9d2cac0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1329,6 +1329,8 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 unsigned long kvm_mmu_calculate_default_mmu_pages(struct kvm *kvm);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
+void kvm_mmu_slot_direct_build_handle_wp(struct kvm *kvm,
+					 struct kvm_memory_slot *memslot);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33252e432c1b..485f7287aad2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -244,6 +244,8 @@ static struct kmem_cache *pte_list_desc_cache;
 static struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
+static int __kvm_write_protect_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+				gfn_t gfn, int level);
 static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 static u64 __read_mostly shadow_user_mask;
@@ -1685,11 +1687,18 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     gfn_t gfn_offset, unsigned long mask)
 {
 	struct kvm_rmap_head *rmap_head;
+	gfn_t gfn;
 
 	while (mask) {
-		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
-					  PT_PAGE_TABLE_LEVEL, slot);
-		__rmap_write_protect(kvm, rmap_head, false);
+		if (kvm->arch.global_root_hpa) {
+			gfn = slot->base_gfn + gfn_offset + __ffs(mask);
+
+			__kvm_write_protect_spte(kvm, slot, gfn, PT_PAGE_TABLE_LEVEL);
+		} else {
+			rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
+						  PT_PAGE_TABLE_LEVEL, slot);
+			__rmap_write_protect(kvm, rmap_head, false);
+		}
 
 		/* clear the first set bit */
 		mask &= mask - 1;
@@ -6558,6 +6567,144 @@ void kvm_direct_tdp_release_global_root(struct kvm *kvm)
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
+			gfn << PAGE_SHIFT, kvm_x86_ops.get_tdp_level(NULL)) {
+		if (iterator.level == level) {
+			break;
+		}
+	}
+
+	if (level != PT_PAGE_TABLE_LEVEL) {
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
+				if (iterator.level == PT_PAGE_TABLE_LEVEL) {
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
+			gfn << PAGE_SHIFT, kvm_x86_ops.get_tdp_level(NULL)) {
+		if (iterator.level == level)
+			break;
+	}
+
+	if (level != PT_PAGE_TABLE_LEVEL) {
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
index 738a558c915c..37e11b3588b5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10078,25 +10078,30 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * See the comments in fast_page_fault().
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
-		if (kvm_x86_ops.slot_enable_log_dirty) {
-			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
+		if (kvm->arch.global_root_hpa) {
+			kvm_mmu_slot_direct_build_handle_wp(kvm, new);
 		} else {
-			int level =
-				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
-				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
+			if (kvm_x86_ops.slot_enable_log_dirty) {
+				kvm_x86_ops.slot_enable_log_dirty(kvm, new);
+			} else {
+				int level =
+					kvm_dirty_log_manual_protect_and_init_set(kvm) ?
+					PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
 
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
@@ -10130,9 +10135,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 */
 	if (change == KVM_MR_FLAGS_ONLY &&
 		(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
-		kvm_mmu_zap_collapsible_sptes(kvm, new);
-
+		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
+		if (kvm->arch.global_root_hpa)
+			kvm_mmu_slot_direct_build_handle_wp(kvm, (struct kvm_memory_slot *)new);
+		else
+			kvm_mmu_zap_collapsible_sptes(kvm, new);
+	}
 	/*
 	 * Set up write protection and/or dirty logging for the new slot.
 	 *
-- 
2.17.1

