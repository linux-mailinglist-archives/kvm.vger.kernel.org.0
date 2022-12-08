Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34014647A17
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 00:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLHXgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 18:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiLHXf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 18:35:56 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8356BC99;
        Thu,  8 Dec 2022 15:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670542555; x=1702078555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dJd8Gz7yMghkD4hZC2xBCpA4xV4eBMzjrPoGrsfEtns=;
  b=GZYLDg1y3/xD/1xYmxhDrhY2YWcmiqwJqS2gubrUGu0HqWStiw5Tmn+p
   l0d2ZigyRVyzY9G2e8xKP7kJKM8dbrd4EsW4TQ4Ox3oFmI0YKgjQeKeqy
   jkaJRCih4Zil8/Q5IKwsDlMg0s8MHClz7V8t5vTDvVxtTxHaHs5plP5g3
   nSjS39e/xoAJ1suJkzT7ZyGrOXeliIUwFszyPB5HC9D/kPrXi4qb6OnzM
   7Jzktj0QQPEp7GkUe12MF3INQBMizpJBCCwDxBOZoPZ+1j3lkXmtvwwZC
   J9Pl1Ze+vocdIxQiFBjBCT5ccX8E9IV/bzQqYSsHE413VTBrKHJy3OPXo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403586507"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403586507"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:55 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="677950926"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="677950926"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 15:35:54 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [RFC PATCH v2 06/15] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date:   Thu,  8 Dec 2022 15:35:41 -0800
Message-Id: <e26917f36b9eb761a51307524c61bedd59fbbbd1.1670541736.git.isaku.yamahata@intel.com>
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

Allow large page level AUG and REMOVE for TDX pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 63 +++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index df213b488f89..d5f93115f3ba 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1297,11 +1297,12 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
 	}
 }
 
-static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn)
+static void tdx_unpin(struct kvm *kvm, kvm_pfn_t pfn, int level)
 {
-	struct page *page = pfn_to_page(pfn);
+	int i;
 
-	put_page(page);
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		put_page(pfn_to_page(pfn + i));
 }
 
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1315,28 +1316,26 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	hpa_t source_pa;
 	bool measure;
 	u64 err;
+	int i;
 
 	if (WARN_ON_ONCE(is_error_noslot_pfn(pfn) ||
 			 !kvm_pfn_to_refcounted_page(pfn)))
 		return 0;
 
 	/* To prevent page migration, do nothing on mmu notifier. */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (likely(is_td_finalized(kvm_tdx))) {
-		/* TODO: handle large pages. */
-		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-			return -EINVAL;
-
 		err = tdh_mem_page_aug(kvm_tdx->tdr.pa, gpa, tdx_level, hpa, &out);
 		if (err == TDX_ERROR_SEPT_BUSY) {
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			return -EAGAIN;
 		}
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error(TDH_MEM_PAGE_AUG, err, &out);
-			tdx_unpin(kvm, pfn);
+			tdx_unpin(kvm, pfn, level);
 			return -EIO;
 		}
 		return 0;
@@ -1359,7 +1358,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1377,7 +1376,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	} while (err == TDX_ERROR_SEPT_BUSY);
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1394,11 +1393,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	hpa_t hpa = pfn_to_hpa(pfn);
 	hpa_t hpa_with_hkid;
+	int r = 0;
 	u64 err;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
+	int i;
 
 	if (!is_hkid_assigned(kvm_tdx)) {
 		/*
@@ -1408,7 +1405,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return 0;
 	}
 
@@ -1425,21 +1422,25 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 
-	hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
-	do {
-		/*
-		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
-		 * this page was removed above, other thread shouldn't be
-		 * repeatedly operating on this page.  Just retry loop.
-		 */
-		err = tdh_phymem_page_wbinvd(hpa_with_hkid);
-	} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
-	if (KVM_BUG_ON(err, kvm)) {
-		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
-		return -EIO;
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++) {
+		hpa_with_hkid = set_hkid_to_hpa(hpa, (u16)kvm_tdx->hkid);
+		do {
+			/*
+			 * TDX_OPERAND_BUSY can happen on locking PAMT entry.
+			 * Because this page was removed above, other thread
+			 * shouldn't be repeatedly operating on this page.
+			 * Simple retry should work.
+			 */
+			err = tdh_phymem_page_wbinvd(hpa_with_hkid);
+		} while (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX));
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			r = -EIO;
+		} else
+			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+		hpa += PAGE_SIZE;
 	}
-	tdx_unpin(kvm, pfn);
-	return 0;
+	return r;
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.25.1

