Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6196A773BCD
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 17:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjHHPz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 11:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjHHPyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:54:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240D559D4;
        Tue,  8 Aug 2023 08:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691509411; x=1723045411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=qfj3FVS8H3992HtbiZET/Z3mfEMOWbWqbIvMBxejMBs=;
  b=VypfmUs9y/Z/xA7v1oTWj0ZTFWH8A64nIe8q/P4tTjC/RWrlso0AO9dj
   dSfWNzdKXEKHxW/8N/HaF8jBNdwb0t8xNqYN1BJyLhjJ9ozglKlhnLFXF
   WMticBUGRgMSY88YQZmtMuZ0lZbyGXQg43/DcB8B1xgw0ytpX8xDQrJF+
   bQuoZkGzHDmfkUVF/hiNUsH+jlIpUPY92ZfNPBW6HnFQdZky1+vjMz4bQ
   khBgGRj+OhFIDEu1y5boYi5vP3bdQOlJkRzDaR6oD4tR7CUgA1uKJb/85
   gUa2IpYkgq4kEWjytGd6mIfSSP7/ba9wcP0IVUhnnVvxrsn26aJU8iRNd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="457152687"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="457152687"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:19:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="734448258"
X-IronPort-AV: E=Sophos;i="6.01,263,1684825200"; 
   d="scan'208";a="734448258"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 02:19:55 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Remove dead code in .change_pte() handler in x86 TDP MMU
Date:   Tue,  8 Aug 2023 16:53:06 +0800
Message-Id: <20230808085306.14742-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230808085056.14644-1-yan.y.zhao@intel.com>
References: <20230808085056.14644-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the dead code set_spte_gfn() in x86 TDP MMU's .change_pte() handler
to save CPU cycles and to prepare for the optimization in next patch.

As explained in commit c13fda237f08 ("KVM: Assert that notifier count is
elevated in .change_pte()"),

when .change_pte() was added by commit 828502d30073 ("ksm: add mmu_notifier
set_pte_at_notify()"), .change_pte() was invoked without any surrounding
notifications;

However, since commit 6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify
with invalidate_range_start and invalidate_range_end"), all calls to
.change_pte() are guaranteed to be surrounded by .invalidate_range_start()
and .invalidate_range_end() pair.

As .invalidate_range_start() will always cause KVM to zap related SPTE, and
page fault path will not install new SPTEs successfully before
.invalidate_range_end(), kvm_set_spte_gfn() should not be able to find any
shadow present leaf entries to operate on and therefore set_spte_gfn()
is never called any more.

So, in TDP MMU, just drop the set_spte_gfn() and only keep warning of huge
pages.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 40 ++++----------------------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6250bd3d20c1..89a1f222e823 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1235,36 +1235,6 @@ bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
 }
 
-static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
-			 struct kvm_gfn_range *range)
-{
-	u64 new_spte;
-
-	/* Huge pages aren't expected to be modified without first being zapped. */
-	WARN_ON(pte_huge(range->arg.pte) || range->start + 1 != range->end);
-
-	if (iter->level != PG_LEVEL_4K ||
-	    !is_shadow_present_pte(iter->old_spte))
-		return false;
-
-	/*
-	 * Note, when changing a read-only SPTE, it's not strictly necessary to
-	 * zero the SPTE before setting the new PFN, but doing so preserves the
-	 * invariant that the PFN of a present * leaf SPTE can never change.
-	 * See handle_changed_spte().
-	 */
-	tdp_mmu_iter_set_spte(kvm, iter, 0);
-
-	if (!pte_write(range->arg.pte)) {
-		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
-								  pte_pfn(range->arg.pte));
-
-		tdp_mmu_iter_set_spte(kvm, iter, new_spte);
-	}
-
-	return true;
-}
-
 /*
  * Handle the changed_pte MMU notifier for the TDP MMU.
  * data is a pointer to the new pte_t mapping the HVA specified by the MMU
@@ -1273,12 +1243,10 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
  */
 bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	/*
-	 * No need to handle the remote TLB flush under RCU protection, the
-	 * target SPTE _must_ be a leaf SPTE, i.e. cannot result in freeing a
-	 * shadow page. See the WARN on pfn_changed in handle_changed_spte().
-	 */
-	return kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
+	/* Huge pages aren't expected to be modified */
+	WARN_ON(pte_huge(range->arg.pte) || range->start + 1 != range->end);
+
+	return false;
 }
 
 /*
-- 
2.17.1

