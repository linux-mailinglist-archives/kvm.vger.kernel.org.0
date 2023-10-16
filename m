Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F40417CAF66
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbjJPQc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjJPQcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:32:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ABD8276;
        Mon, 16 Oct 2023 09:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473397; x=1729009397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yPrJYT1RFsVP8N8TkF5b62qyZ832rTjB68o4Dhh8k6M=;
  b=kE5odJjZQZFdxaTFL1shqNytEmohyxDTSjoxbfLZh2Jxl5ECJWtPR8B8
   r/VtTFxneuRcYABzfsBWtfjDeP/UIDWlcjNk1NzzZZHJToOnNpGn4AZZb
   REEaHlPAoDS45+7sUNIRrh5+EbORBNeMjQIVu0G4KmPNbCIiOMStHCrSU
   D4nlOLEl4lpXN+ulATgdphSZNAfSK2J4sghuoT+wnb1A3iQEdOazdAZzW
   QSAMfPls3pbElnSRlO6dZml37LsDFRyAhnJdEGHkyD/7pC2JabF1N20Qt
   gAAZDDAaBHgxJN/WjUapew7d/4qaLPucMCfDnkPFSXdpIl64sPuHT0gmo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793183"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793183"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569250"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569250"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:16 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v5 11/16] KVM: x86/tdp_mmu: Split the large page when zap leaf
Date:   Mon, 16 Oct 2023 09:21:02 -0700
Message-Id: <583f8981191122b742bf2b77dab58d1a296da394.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

When TDX enabled, a large page cannot be zapped if it contains mixed
pages. In this case, it has to split the large page.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/Kconfig            |  1 +
 arch/x86/kvm/mmu/mmu.c          |  6 +--
 arch/x86/kvm/mmu/mmu_internal.h |  9 +++++
 arch/x86/kvm/mmu/tdp_mmu.c      | 68 +++++++++++++++++++++++++++++++--
 4 files changed, 78 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e08cc4ad5749..8a2d52aba6f0 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -93,6 +93,7 @@ config KVM_INTEL
 	tristate "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
 	select KVM_SW_PROTECTED_VM if INTEL_TDX_HOST
+	select KVM_GENERIC_MEMORY_ATTRIBUTES if INTEL_TDX_HOST
 	select KVM_PRIVATE_MEM if INTEL_TDX_HOST
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 55574993a13a..a1a9b0bc4f1a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7455,8 +7455,8 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	return kvm_unmap_gfn_range(kvm, range);
 }
 
-static bool hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
-				int level)
+bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
+			     int level)
 {
 	return lpage_info_slot(gfn, slot, level)->disallow_lpage & KVM_LPAGE_MIXED_FLAG;
 }
@@ -7483,7 +7483,7 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return kvm_range_has_memory_attributes(kvm, start, end, attrs);
 
 	for (gfn = start; gfn < end; gfn += KVM_PAGES_PER_HPAGE(level - 1)) {
-		if (hugepage_test_mixed(slot, gfn, level - 1) ||
+		if (kvm_hugepage_test_mixed(slot, gfn, level - 1) ||
 		    attrs != kvm_get_memory_attributes(kvm, gfn))
 			return false;
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 641d4e777b73..099e8fe929c6 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -461,4 +461,13 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+#ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
+bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+#else
+static inline bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	return false;
+}
+#endif
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 75a2fec7a3fa..366f1b58af09 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1118,6 +1118,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return true;
 }
 
+
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       bool shared);
+
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
+
 /*
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -1129,13 +1137,15 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 			      gfn_t start, gfn_t end, bool can_yield, bool flush,
 			      bool zap_private)
 {
+	bool is_private = is_private_sp(root);
+	struct kvm_mmu_page *split_sp = NULL;
 	struct tdp_iter iter;
 
 	end = min(end, tdp_mmu_max_gfn_exclusive());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	WARN_ON_ONCE(zap_private && !is_private_sp(root));
+	WARN_ON_ONCE(zap_private && !is_private);
 	if (!zap_private && is_private_sp(root))
 		return false;
 
@@ -1160,12 +1170,66 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (is_private && kvm_gfn_shared_mask(kvm) &&
+		    is_large_pte(iter.old_spte)) {
+			gfn_t gfn = iter.gfn & ~kvm_gfn_shared_mask(kvm);
+			gfn_t mask = KVM_PAGES_PER_HPAGE(iter.level) - 1;
+			struct kvm_memory_slot *slot;
+			struct kvm_mmu_page *sp;
+
+			slot = gfn_to_memslot(kvm, gfn);
+			if (kvm_hugepage_test_mixed(slot, gfn, iter.level) ||
+			    (gfn & mask) < start ||
+			    end < (gfn & mask) + KVM_PAGES_PER_HPAGE(iter.level)) {
+				WARN_ON_ONCE(!can_yield);
+				if (split_sp) {
+					sp = split_sp;
+					split_sp = NULL;
+					sp->role = tdp_iter_child_role(&iter);
+				} else {
+					WARN_ON(iter.yielded);
+					if (flush && can_yield) {
+						kvm_flush_remote_tlbs(kvm);
+						flush = false;
+					}
+					sp = tdp_mmu_alloc_sp_for_split(kvm, &iter, false);
+					if (iter.yielded) {
+						split_sp = sp;
+						continue;
+					}
+				}
+				KVM_BUG_ON(!sp, kvm);
+
+				tdp_mmu_init_sp(sp, iter.sptep, iter.gfn);
+				if (tdp_mmu_split_huge_page(kvm, &iter, sp, false)) {
+					kvm_flush_remote_tlbs(kvm);
+					flush = false;
+					/* force retry on this gfn. */
+					iter.yielded = true;
+				} else
+					flush = true;
+				continue;
+			}
+		}
+
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 		flush = true;
 	}
 
 	rcu_read_unlock();
 
+	if (split_sp) {
+		WARN_ON(!can_yield);
+		if (flush) {
+			kvm_flush_remote_tlbs(kvm);
+			flush = false;
+		}
+
+		write_unlock(&kvm->mmu_lock);
+		tdp_mmu_free_sp(split_sp);
+		write_lock(&kvm->mmu_lock);
+	}
+
 	/*
 	 * Because this flow zaps _only_ leaf SPTEs, the caller doesn't need
 	 * to provide RCU protection as no 'struct kvm_mmu_page' will be freed.
@@ -1729,8 +1793,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
 	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
 		   is_private_sptep(iter->sptep), kvm);
-	/* TODO: Large page isn't supported for private SPTE yet. */
-	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
-- 
2.25.1

