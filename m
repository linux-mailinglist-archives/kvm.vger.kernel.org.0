Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F88647A1B
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiLHXgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbiLHXf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:58 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF1B6BCB3;
        Thu,  8 Dec 2022 15:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542557; x=1702078557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=55CT66bcMdxZrRpBG4Gr5xUaPrsTcdj1LMl8jhgsMD8=;
  b=Aa0evoS9bfohRZQopQNhzqPoBHCqm2M6cLOWBNZVdOg8aCOoDRZ2dSMA
   Z2y/oOgL8/6rEbl7pN2AiHD1CDg102xovrC5yGWNZbieecWUSt1+Dq5QC
   lRIuNOQV7ky6cu5xUcglf+jNdFdrWhbI/RgcUvgNTm2VrzFMTVgccULOu
   MFBtNO3MuQO0+lok2FFXFn9jLWGwS+UsiJlU3Sn+hpEmzXJX7SMm1LWUN
   adWxGza4M3e/RIFj8CySEJ+XalrP4Y+dRO+NCwMoWSWGWmbmzpEEnZIDS
   Q1tqtfa/9AhS+mMvwMFLpq3AkFlsr2NeRKm6jpBxfysIuIP16emRVq/Sb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586521"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586521"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950961"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950961"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:56 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 08/15] KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
Date:   Thu,  8 Dec 2022 15:35:43 -0800
Message-Id: <dca4917a815a212d6598093f189f12d920887362.1670541736.git.isaku.yamahata@intel.com>
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

When kvm_faultin_pfn(), it doesn't have the info regarding which page level
will the gfn be mapped at. Hence it doesn't know to pin a 4K page or a
2M page.

Move the guest private pages pinning logic right before
TDH_MEM_PAGE_ADD/AUG() since at that time it knows the page level info.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 51b9e250437e..fad7413f7eab 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1297,7 +1297,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
+static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+		      enum pg_level level)
 {
 	int i;
 
@@ -1330,12 +1331,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx))) {
 		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
 		if (err == TDX_ERROR_SEPT_BUSY) {
-			tdx_unpin(kvm, pfn, level);
+			tdx_unpin(kvm, gfn, pfn, level);
 			return -EAGAIN;
 		}
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-			tdx_unpin(kvm, pfn, level);
+			tdx_unpin(kvm, gfn, pfn, level);
 			return -EIO;
 		}
 		return 0;
@@ -1358,7 +1359,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1376,7 +1377,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	} while (err == TDX_ERROR_SEPT_BUSY);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1405,7 +1406,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return 0;
 	}
 
@@ -1437,7 +1438,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
 			r = -EIO;
 		} else
-			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+			tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
 		hpa += PAGE_SIZE;
 	}
 	return r;
-- 
2.25.1

