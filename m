Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8F7626D4
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjGYWgQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjGYWfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10EA30ED;
        Tue, 25 Jul 2023 15:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324159; x=1721860159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OU7ojYtC0WxT+JCz1oHVSaHOmjttkjr2k55F1N8lGt0=;
  b=Qx3p0vwnE29rLwM/aB/szAPGVO7j/xcCSPsJ/QtS5askc9l8zkaI6Erk
   hyPJxpAxMS5CObkH2V0wfOVTTjSxrc5+V0rbwk6lyRMkRq0AZ2wB0uQtB
   EzWNxJBfd3uxmOqPH3AAoedSr+Gn/Hblr44VOQEW3GQRS3tdLILan1Z6O
   00GHNHN6IjZItwq6mZLF7Ttjt6Bg6Ic6N/1ir5uyRWUbvPXJORxh94VFK
   8imBlb0FX0f1tVmOaV431Fqxp5cI1mFr0AyLGB8Hhr3aIsTb9JoMlUpI0
   eBbN1gjGAMPK7dlDCjpweu5OFefdQ7oqGuBuGIU3RkHBGci4/GKpL+579
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467136"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467136"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855814"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855814"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:11 -0700
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
Subject: [RFC PATCH v4 08/16] KVM: TDX: Pin pages via get_page() right before ADD/AUG'ed to TDs
Date:   Tue, 25 Jul 2023 15:23:54 -0700
Message-Id: <1519e0b3af4df9de3fe07f750896b44896cdc591.1690323516.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690323516.git.isaku.yamahata@intel.com>
References: <cover.1690323516.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c122160142fd..bd1582e6b693 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1361,7 +1361,8 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
+static void tdx_unpin(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+		      enum pg_level level)
 {
 	int i;
 
@@ -1397,12 +1398,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx))) {
 		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 		if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
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
@@ -1425,7 +1426,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1443,7 +1444,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1472,7 +1473,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn, level);
+		tdx_unpin(kvm, gfn, pfn, level);
 		return 0;
 	}
 
@@ -1505,7 +1506,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 			r = -EIO;
 		} else {
 			tdx_clear_page(hpa, PAGE_SIZE);
-			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+			tdx_unpin(kvm, gfn + i, pfn + i, PG_LEVEL_4K);
 		}
 		hpa += PAGE_SIZE;
 	}
-- 
2.25.1

