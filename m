Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFB627933B
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgIYVXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729231AbgIYVXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:36 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CA4C0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:36 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id m13so3419885pfk.19
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2ZW97evDdGZ1vZX3rJE1h1hcVRAtHA0th2WLnrerXFE=;
        b=rcO6+on5bvD26jOOTJ3pOOYuGTkqfwYFC2emDtlAgUI2igLZjBi49pSvzd/SNLCrhx
         bGwrsMwhm1nJI2YUtnl6TLktq1Br9eg6iw9fHvWwXLo6kGabTddTZv1Lfwi1HEDSkqJd
         dJtkevhjDUvyMh0C8odOucJVXLzeK7tkVVph+T/mIvo+ezLqm3pC5NTOKUnH4I06HQeJ
         gHF9i5plGAyiYFI0X5igAAN5NbR6QeFJWLjF+G/MmNWqW9cnpSRC96NkCUsYVtfHGEAL
         2DQmye1AZ2SKfmuHvJXxXiveWNZQQ+jJvDaqvNG/3jO5XaumXd1LNvO/13jy1KzMGtTd
         bmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2ZW97evDdGZ1vZX3rJE1h1hcVRAtHA0th2WLnrerXFE=;
        b=Re19UmL7gfr3cfYAfyIjevdF9GHJdkcOnAGRDUNPvCwYMfz6JiGlBn4HDjjHKpGchV
         9B0yj+Pr9yNVJ1e+3syxHV1jX5yaPqv2Wfg5YNO3BBCX72l2h9jGmFPlCZGE+0UHo5Oh
         zbwdVxbryRNDSZacwfquXirm/tMjei6w0ofQlSdSbuFVDyAtYGXCb7th5P9251IetdFF
         Mc+GdLUthgRppzHvv0p8w6SocAmQipCFhNTuraeSf4iPg3PWhS5SuDnOSZqYceloqyaR
         r3ImS2+/nHGZclOrlrctW/snOxu1a/lXA6zx0Cbb6yExHBY2hmDxFKtc/8QC8KyTxaF1
         dDpQ==
X-Gm-Message-State: AOAM53390K4xAgS2vbbFk4yxTCImtqdJ+gGFgFnhxfpgtEDEFFAZE2aR
        lfiU/gNE+x9ERnbyCiIVDkr5P8FO+vBm
X-Google-Smtp-Source: ABdhPJxOnXFh3ugXDvH7iih5//M0RhAFbKOi44WgqPGt00bT5oGQJZK6p+S9qNOEz7cHOrDCuqRQESiiEZQk
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90b:941:: with SMTP id
 dw1mr29935pjb.1.1601069015590; Fri, 25 Sep 2020 14:23:35 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:55 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-16-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 15/22] kvm: mmu: Support changed pte notifier in tdp MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
a hook and handle the change_pte MMU notifier.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 46 +++++++++++++------------
 arch/x86/kvm/mmu/mmu_internal.h | 13 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 61 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++
 4 files changed, 102 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8c1e806b3d53f..0d80abe82ca93 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -122,9 +122,6 @@ module_param(dbg, bool, 0644);
 
 #define PTE_PREFETCH_NUM		8
 
-#define PT_FIRST_AVAIL_BITS_SHIFT 10
-#define PT64_SECOND_AVAIL_BITS_SHIFT 54
-
 /*
  * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
  * Access Tracking SPTEs.
@@ -147,13 +144,6 @@ module_param(dbg, bool, 0644);
 #define PT32_INDEX(address, level)\
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
-
-#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
-#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
-#else
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
-#endif
-
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
@@ -170,9 +160,6 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
-#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
-
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
@@ -1708,6 +1695,21 @@ static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return kvm_zap_rmapp(kvm, rmap_head);
 }
 
+u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
+{
+	u64 new_spte;
+
+	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
+	new_spte |= (u64)new_pfn << PAGE_SHIFT;
+
+	new_spte &= ~PT_WRITABLE_MASK;
+	new_spte &= ~SPTE_HOST_WRITEABLE;
+
+	new_spte = mark_spte_for_access_track(new_spte);
+
+	return new_spte;
+}
+
 static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
 			     unsigned long data)
@@ -1733,13 +1735,8 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
 		} else {
-			new_spte = *sptep & ~PT64_BASE_ADDR_MASK;
-			new_spte |= (u64)new_pfn << PAGE_SHIFT;
-
-			new_spte &= ~PT_WRITABLE_MASK;
-			new_spte &= ~SPTE_HOST_WRITEABLE;
-
-			new_spte = mark_spte_for_access_track(new_spte);
+			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
+					*sptep, new_pfn);
 
 			mmu_spte_clear_track_bits(sptep);
 			mmu_spte_set(sptep, new_spte);
@@ -1895,7 +1892,14 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
-	return kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+	int r;
+
+	r = kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		r |= kvm_tdp_mmu_set_spte_hva(kvm, hva, &pte);
+
+	return r;
 }
 
 static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 228bda0885552..8eaa6e4764bce 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -80,6 +80,12 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
 						* PT64_LEVEL_BITS))) - 1))
 
+#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
+#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#else
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#endif
+
 extern u64 shadow_user_mask;
 extern u64 shadow_accessed_mask;
 extern u64 shadow_present_mask;
@@ -89,6 +95,12 @@ extern u64 shadow_present_mask;
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
+#define PT_FIRST_AVAIL_BITS_SHIFT 10
+#define PT64_SECOND_AVAIL_BITS_SHIFT 54
+
+#define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
+#define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
+
 /* Functions for interpreting SPTEs */
 kvm_pfn_t spte_to_pfn(u64 pte);
 bool is_mmio_spte(u64 spte);
@@ -138,5 +150,6 @@ bool is_nx_huge_page_enabled(void);
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 u64 mark_spte_for_access_track(u64 spte);
+u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0a4b98669b3ef..3119583409131 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -722,3 +722,64 @@ int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
 					    test_age_gfn);
 }
+
+/*
+ * Handle the changed_pte MMU notifier for the TDP MMU.
+ * data is a pointer to the new pte_t mapping the HVA specified by the MMU
+ * notifier.
+ * Returns non-zero if a flush is needed before releasing the MMU lock.
+ */
+static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
+			unsigned long data)
+{
+	struct tdp_iter iter;
+	pte_t *ptep = (pte_t *)data;
+	kvm_pfn_t new_pfn;
+	u64 new_spte;
+	int need_flush = 0;
+	int as_id = kvm_mmu_page_as_id(root);
+
+	WARN_ON(pte_huge(*ptep));
+
+	new_pfn = pte_pfn(*ptep);
+
+	for_each_tdp_pte_root(iter, root, gfn, gfn + 1) {
+		if (iter.level != PG_LEVEL_4K)
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			break;
+
+		*iter.sptep = 0;
+		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				    new_spte, iter.level);
+
+		kvm_flush_remote_tlbs_with_address(kvm, iter.gfn, 1);
+
+		if (!pte_write(*ptep)) {
+			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
+					iter.old_spte, new_pfn);
+
+			*iter.sptep = new_spte;
+			handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+					    new_spte, iter.level);
+		}
+
+		need_flush = 1;
+	}
+
+	if (need_flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+
+	return 0;
+}
+
+int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
+			     pte_t *host_ptep)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, address, address + 1,
+					    (unsigned long)host_ptep,
+					    set_tdp_spte);
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index f316773b7b5a8..5a399aa60b8d8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -25,4 +25,7 @@ int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
 int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
+
+int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
+			     pte_t *host_ptep);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

