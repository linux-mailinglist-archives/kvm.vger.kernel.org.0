Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB0A647A1D
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiLHXgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiLHXgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:36:04 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39796BC9B;
        Thu,  8 Dec 2022 15:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542559; x=1702078559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=evLGS0Ysb2C50awEgkYSSa/pcL5o4ysLqfSgQX2aZMQ=;
  b=kx9t+P60XYxObBRurtVa+M2S82eYBF1lDYGmvDX1kw34VJc5SxQFFDwq
   CabbFWYM65rYk9PyHndhJN6/3WbmSfqs4bBBjL0ePbI4TTVNZmdFBwOJ1
   9qT9ug828+SNceb/qLiG8pQmi28AOgChrCVuljvPYj/cwFBfZxFQ6YUP+
   WRHDut1STje1tU4u9Q3vck1UfqQQAAEkGonto/1TawIdYcwEWodhcBLjS
   ec1ns3CQlvXZv2Xa4gu5Tp0jFJob8mMVENPiwPwDWdl3C1Efin1gITH22
   IF+bJCVt0JO20tumDhPe7MmpIukapajDNbW61HoKFWwbvVuyGGnxOUM/q
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586544"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586544"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950990"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950990"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:58 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 10/15] KVM: x86/tdp_mmu: Split the large page when zap leaf
Date:   Thu,  8 Dec 2022 15:35:45 -0800
Message-Id: <7edb5526907c1d36e78647577cbf562e9155a76a.1670541736.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1670541736.git.isaku.yamahata@intel.com>
References: <cover.1670541736.git.isaku.yamahata@intel.com>
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
---
 arch/x86/kvm/mmu/mmu.c          |  9 +++++
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 62 +++++++++++++++++++++++++++++++--
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 02adc3c23627..7f56b1dd76fa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7318,6 +7318,15 @@ static bool linfo_is_mixed(struct kvm_lpage_info *linfo)
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
index 641afc4e90cb..2b7c16dfdf5e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -435,6 +435,8 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+bool kvm_mem_attr_is_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+
 #ifndef CONFIG_HAVE_KVM_RESTRICTED_MEM
 static inline int kvm_restricted_mem_get_pfn(struct kvm_memory_slot *slot,
 					gfn_t gfn, kvm_pfn_t *pfn, int *order)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cb36089a40da..e9af8c95a3ae 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1102,6 +1102,14 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
@@ -1113,6 +1121,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 			      gfn_t start, gfn_t end, bool can_yield, bool flush,
 			      bool zap_private)
 {
+	struct kvm_mmu_page *split_sp = NULL;
 	struct tdp_iter iter;
 
 	end = min(end, tdp_mmu_max_gfn_exclusive());
@@ -1144,12 +1153,63 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		if (kvm_gfn_shared_mask(kvm) && is_large_pte(iter.old_spte)) {
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
+				} else {
+					WARN_ON(iter.yielded);
+					if (flush) {
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
@@ -1691,8 +1751,6 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 
 	KVM_BUG_ON(kvm_mmu_page_role_is_private(role) !=
 		   is_private_sptep(iter->sptep), kvm);
-	/* TODO: Large page isn't supported for private SPTE yet. */
-	KVM_BUG_ON(kvm_mmu_page_role_is_private(role), kvm);
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
-- 
2.25.1

