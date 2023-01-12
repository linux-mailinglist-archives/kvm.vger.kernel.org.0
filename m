Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E767667C54
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbjALRPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240599AbjALROO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:14:14 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4C78060D;
        Thu, 12 Jan 2023 08:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673542161; x=1705078161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HuHoeUekyFSAUzPPvkzdyR3yLNoy8R+YlxBP1c0vyVQ=;
  b=ebi0eAwYjHXO/n1sVHug6cQXxkf1UEYfjsCADR2o9TU9oGA7ikecJfO4
   aiG5yKxW0RYWJPvBpgcwZOtAcFzNJFxQ/8O+SeqxQzh4C1FoyQ2qAG/VI
   Mns/fVkqSK4MO5Wd8HgcdbVXOGhDD7UoxQ007v4Hha8RcHSi4sAGMnxwF
   ngJdvdtYuHqbzF/eWrv1APjn9MxGPoV9CItzpqYXFq7mWQOkGcD0VPAg3
   /m1pCGOg8LaCbMnYwFxZeoBJaLshRowcIoZeZO6hrN3F97xohX4jt+o7f
   9XVraTm2a9JLEbAh+8AhjlOsyGmSaK9qIsmhjDHr/jNk6G/RbnQH/jFTM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323816326"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323816326"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="986658355"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="986658355"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:44:17 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v3 11/16] KVM: x86/tdp_mmu: Split the large page when zap leaf
Date:   Thu, 12 Jan 2023 08:44:03 -0800
Message-Id: <1fccbab5db35fe1c9ea552fc24ef4da6eca0a393.1673541292.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673541292.git.isaku.yamahata@intel.com>
References: <cover.1673541292.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

When TDX enabled, a large page cannot be zapped if it contains mixed
pages. In this case, it has to split the large page.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c          |  9 +++++
 arch/x86/kvm/mmu/mmu_internal.h |  2 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 68 +++++++++++++++++++++++++++++++--
 3 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 10d7c46b3bf5..961e103e674a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7250,6 +7250,15 @@ static bool linfo_is_mixed(struct kvm_lpage_info *linfo)
 	return linfo->disallow_lpage & KVM_LPAGE_PRIVATE_SHARED_MIXED;
 }
 
+bool kvm_mem_attr_is_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+       struct kvm_lpage_info *linfo = lpage_info_slot(gfn & KVM_HPAGE_MASK(level),
+						      slot, level);
+
+       WARN_ON_ONCE(level == PG_LEVEL_4K);
+       return linfo_is_mixed(linfo);
+}
+
 static void linfo_set_mixed(gfn_t gfn, struct kvm_memory_slot *slot,
 			    int level, bool mixed)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e51fc5a5cabc..b2774c164abb 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -434,6 +434,8 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+bool kvm_mem_attr_is_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+
 #ifndef CONFIG_HAVE_KVM_RESTRICTED_MEM
 static inline int kvm_restricted_mem_get_pfn(struct kvm_memory_slot *slot,
 					gfn_t gfn, kvm_pfn_t *pfn, int *order)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1a71aad62bd3..2e55454c3e51 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1121,6 +1121,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -1132,13 +1140,15 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -1163,12 +1173,66 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
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
+			if (kvm_mem_attr_is_mixed(slot, gfn, iter.level) ||
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
 		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
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
@@ -1713,8 +1777,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
 	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
 		   is_private_sptep(iter->sptep), kvm);
-	/* TODO: Large page isn't supported for private SPTE yet. */
-	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
-- 
2.25.1

