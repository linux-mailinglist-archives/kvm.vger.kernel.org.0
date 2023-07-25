Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD527626CE
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjGYWgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjGYWfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:35:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FEA04C08;
        Tue, 25 Jul 2023 15:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690324159; x=1721860159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oB1g3HDX/2ILd1F96KlXTi/i5o86ajLaJDq3SHY3oYA=;
  b=jIYWLS7+MK9vYqFlGcU+myXts2cP4l0hgk2s0ZKdCitnSApem/HckajM
   VyxpgczUopPaQ6Uxy7yYqJwTwJ9gcmf/STFyCLzH0fqCP0pjtdQlPwjdE
   V6wRttu60FZVo3cfWvGRFx7A6JVy794ZHIseXVAryubor1AUsp1Aan26Q
   ChG+s/LGlsNMaIb1KRoFo793seeKXcWQrNJLL8JBrCbxI8gao5/8SdWfR
   Obo0cFEb1HrDTqaj902sV+QLrSUmk9J7CFVfuUeCOUnCBMjNQFvrNDUfB
   zwgJqmU1kq/h7s9PT24z35hcpSd53kFTosLv9JLxCvmEBJutoR5I6Pp0V
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="371467123"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="371467123"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="972855804"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="972855804"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:24:10 -0700
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
Subject: [RFC PATCH v4 06/16] KVM: TDX: Update tdx_sept_{set,drop}_private_spte() to support large page
Date:   Tue, 25 Jul 2023 15:23:52 -0700
Message-Id: <8966f24bcc328361588c04c5eae069ad9a4359e1.1690323516.git.isaku.yamahata@intel.com>
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

Allow large page level AUG and REMOVE for TDX pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 66 ++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 86cfbf435671..9d6c951bb625 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1361,11 +1361,12 @@ static void tdx_measure_page(struct kvm_tdx *kvm_tdx, hpa_t gpa, int size)
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
@@ -1379,6 +1380,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	hpa_t source_pa;
 	bool measure;
 	u64 err;
+	int i;
 
 	/*
 	 * Because restricted mem doesn't support page migration with
@@ -1388,22 +1390,19 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * TODO: Once restricted mem introduces callback on page migration,
 	 * implement it and remove get_page/put_page().
 	 */
-	get_page(pfn_to_page(pfn));
+	for (i = 0; i < KVM_PAGES_PER_HPAGE(level); i++)
+		get_page(pfn_to_page(pfn + i));
 
 	/* Build-time faults are induced and handled via TDH_MEM_PAGE_ADD. */
 	if (likely(is_td_finalized(kvm_tdx))) {
-		/* TODO: handle large pages. */
-		if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-			return -EINVAL;
-
 		err = tdh_mem_page_aug(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
 		if (unlikely(err == TDX_ERROR_SEPT_BUSY)) {
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
@@ -1426,7 +1425,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * always uses vcpu 0's page table and protected by vcpu->mutex).
 	 */
 	if (KVM_BUG_ON(kvm_tdx->source_pa == INVALID_PAGE, kvm)) {
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EINVAL;
 	}
 
@@ -1444,7 +1443,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MEM_PAGE_ADD, err, &out);
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return -EIO;
 	} else if (measure)
 		tdx_measure_page(kvm_tdx, gpa, KVM_HPAGE_SIZE(level));
@@ -1461,11 +1460,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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
 
 	if (unlikely(!is_hkid_assigned(kvm_tdx))) {
 		/*
@@ -1475,7 +1472,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdx_reclaim_page(hpa, level, false, 0);
 		if (KVM_BUG_ON(err, kvm))
 			return -EIO;
-		tdx_unpin(kvm, pfn);
+		tdx_unpin(kvm, pfn, level);
 		return 0;
 	}
 
@@ -1492,22 +1489,27 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
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
-	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
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
+		} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err, NULL);
+			r = -EIO;
+		} else {
+			tdx_clear_page(hpa, PAGE_SIZE);
+			tdx_unpin(kvm, pfn + i, PG_LEVEL_4K);
+		}
+		hpa += PAGE_SIZE;
 	}
-	tdx_clear_page(hpa, PAGE_SIZE);
-	tdx_unpin(kvm, pfn);
-	return 0;
+	return r;
 }
 
 static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-- 
2.25.1

