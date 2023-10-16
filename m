Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68D47CAFC8
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbjJPQiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjJPQhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B8783C2;
        Mon, 16 Oct 2023 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473398; x=1729009398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=plOWEmHcszC/a1uSmdrAZhY93JEutDgD1TMhrZRF+cs=;
  b=UklVa7/QuN42L2VjQe4Etd7jcGFaES/o1tShzuOpLGXN6GzbYeKDjOCS
   EmpMHpx4OzKkga7OU0yZ5yH/aUJl0tJ00/uNNlvTUWhTaQN5hfxB8giXL
   QoJgbe2wbq6r4VCI4s0nJPdu/zKaBFqW5m1wnfsxPVb7PvL9a83JJEUw8
   XYEOTFuss2NPq8icpGKWPe9HBZFjEaOAmxGYd827TZdUvYbVg0fYI+Zyw
   XnOjnFwrse/pidg9+nR5mIMAWunKxRSnMMJ7EUY2bqpqcz6rK7Bz9rFV3
   znZLQYHK/eBMmKERED2I5W36CKPgaqgeQm9s4fE0nI2Q/UgBUBLw2TPmU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793214"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793214"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569273"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569273"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [RFC PATCH v5 15/16] KVM: x86/mmu: Make kvm fault handler aware of large page of private memslot
Date:   Mon, 16 Oct 2023 09:21:06 -0700
Message-Id: <f6ea9741b2c5176dca3ec9427b3bd30374ceae25.1697473009.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

struct kvm_page_fault.req_level is the page level which takes care of the
faulted-in page size.  For now its calculation is only for the conventional
kvm memslot by host_pfn_mapping_level() that traverses page table.

However, host_pfn_mapping_level() cannot be used for private kvm memslot
because pages of private kvm memlost aren't mapped into user virtual
address space.  Instead page order is given when getting pfn.  Remember it
in struct kvm_page_fault and use it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          | 34 +++++++++++++++++----------------
 arch/x86/kvm/mmu/mmu_internal.h | 12 +++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 3 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a1a9b0bc4f1a..e77cfe133dfe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3158,10 +3158,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 
 static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot,
-				       gfn_t gfn, int max_level, bool is_private)
+				       gfn_t gfn, int max_level, int host_level,
+				       bool is_private)
 {
 	struct kvm_lpage_info *linfo;
-	int host_level;
 
 	max_level = min(max_level, max_huge_page_level);
 	for ( ; max_level > PG_LEVEL_4K; max_level--) {
@@ -3170,24 +3170,23 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 			break;
 	}
 
-	if (is_private)
-		return max_level;
-
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	if (!is_private) {
+		WARN_ON_ONCE(host_level != PG_LEVEL_NONE);
+		host_level = host_pfn_mapping_level(kvm, gfn, slot);
+	}
+	WARN_ON_ONCE(host_level == PG_LEVEL_NONE);
 	return min(host_level, max_level);
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level)
+			      int max_level, bool faultin_private)
 {
-	bool is_private = kvm_slot_can_be_private(slot) &&
-			  kvm_mem_is_private(kvm, gfn);
-
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level,
+					   PG_LEVEL_NONE, faultin_private);
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -3212,7 +3211,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
 						       fault->gfn, fault->max_level,
-						       fault->is_private);
+						       fault->host_level,
+						       kvm_is_faultin_private(fault));
 	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
 		return;
 
@@ -4328,6 +4328,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
 	int max_order, r;
+	u8 max_level;
 
 	if (!kvm_slot_can_be_private(fault->slot)) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
@@ -4341,8 +4342,9 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 		return r;
 	}
 
-	fault->max_level = min(kvm_max_level_for_order(max_order),
-			       fault->max_level);
+	max_level = kvm_max_level_for_order(max_order);
+	fault->host_level = max_level;
+	fault->max_level = min(max_level, fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 
 	return RET_PF_CONTINUE;
@@ -4392,7 +4394,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 		return -EFAULT;
 	}
 
-	if (fault->is_private)
+	if (kvm_is_faultin_private(fault))
 		return kvm_faultin_pfn_private(vcpu, fault);
 
 	async = false;
@@ -6804,7 +6806,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 */
 		if (sp->role.direct &&
 		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
-							       PG_LEVEL_NUM)) {
+							       PG_LEVEL_NUM, false)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 099e8fe929c6..813d405fc11e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -358,6 +358,9 @@ struct kvm_page_fault {
 	 * is changing its own translation in the guest page tables.
 	 */
 	bool write_fault_to_shadow_pgtable;
+
+	/* valid only for private memslot && private gfn */
+	enum pg_level host_level;
 };
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
@@ -452,7 +455,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level);
+			      int max_level, bool faultin_private);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
@@ -470,4 +473,11 @@ static inline bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t g
 }
 #endif
 
+static inline bool kvm_is_faultin_private(const struct kvm_page_fault *fault)
+{
+	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM))
+		return fault->is_private && kvm_slot_can_be_private(fault->slot);
+	return false;
+}
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9cb63613d831..cac48881c5f1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2302,7 +2302,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 			continue;
 
 		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
+							      iter.gfn, PG_LEVEL_NUM, false);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.25.1

