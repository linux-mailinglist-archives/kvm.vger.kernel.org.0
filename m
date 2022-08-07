Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988A758BDED
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiHGWcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242248AbiHGWbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F11E918366;
        Sun,  7 Aug 2022 15:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910731; x=1691446731;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CTJMM/0shdwoQoSS4boE1AzzhW200V6Zj+VgeNun5mA=;
  b=jyNA2pZNncajIgyYQeUPduTNK0nfWSQ4mnTHY003iPtqMyQNZnNaqhlP
   ABBqzK91oJnhcYdIarVdBa4l0IGNk1qQGAIP/SNvMDH2jZ86h62gUopGL
   SLU272way44NuiwBj5t1kUObMInpq9rM/G0N9jA83Rl5/DjYBdCM/wDaI
   dW0+hvqfNHe++lIhRymz+lwFPE159azq+DvhnkgZjEQ653nW4t6+GAwe3
   gtJ+hEXD7zZxchfZrgHFHpvk2ji5PkI1/Bh8ReFMYSVsgoSFSFJQfPKBO
   m9xuZLWeRj8QlnUvRd9SDzZxPFYfi2QGNGESWndi92v/yAA05xZKy5cgo
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852837"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852837"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642330"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 09/13] KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
Date:   Sun,  7 Aug 2022 15:18:42 -0700
Message-Id: <8fa629b2c53c0578ed4025770190e6f960558b9c.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854957.git.isaku.yamahata@intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

When kvm_faultin_pfn(), it doesn't have the info regarding which page level
will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
2M page.

Move the guest private pages pinning logic right before
TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 81d88b1e63ac..2fdf3aa70c57 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1440,12 +1440,22 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin_pfn(struct kvm *kvm, kvm_pfn_t pfn)
+static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+		      enum pg_level level)
 {
-	struct page *page = pfn_to_page(pfn);
+	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
+	int i;
+
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++) {
+		struct page *page = pfn_to_page(pfn + i);
 
-	put_page(page);
-	WARN_ON(!page_count(page) && to_kvm_tdx(kvm)->hkid > 0);
+		put_page(page);
+		WARN_ON(!page_count(page) && to_kvm_tdx(kvm)->hkid > 0);
+	}
+	if (kvm_slot_can_be_private(slot)) {
+		/* Private slot case */
+		return;
+	}
 }
 
 static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1473,7 +1483,7 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-			tdx_unpin_pfn(kvm, pfn);
+			tdx_unpin(kvm, gfn, pfn, level);
 		}
 		return;
 	}
@@ -1492,7 +1502,7 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin_pfn(kvm, pfn);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return;
 	}
 
@@ -1501,7 +1511,7 @@ static void __tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	err = tdh_mem_page_add(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, source_pa, &out);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin_pfn(kvm, pfn);
+		tdx_unpin(kvm, gfn, pfn, level);
 	} else if ((kvm_tdx->source_pa & KVM_TDX_MEASURE_MEMORY_REGION))
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
 
@@ -1547,7 +1557,7 @@ static void tdx_sept_drop_private_spte(
 			if (WARN_ON_ONCE(err))
 				pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 			else
-				tdx_unpin(kvm, gfn + i, pfn + i);
+				tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
 			hpa += PAGE_SIZE;
 		}
 	} else {
@@ -1560,7 +1570,7 @@ static void tdx_sept_drop_private_spte(
 				       false, 0);
 		spin_unlock(&kvm_tdx->seamcall_lock);
 		if (!err)
-			tdx_unpin(kvm, gfn, pfn);
+			tdx_unpin(kvm, gfn, pfn, level);
 	}
 }
 
-- 
2.25.1

