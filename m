Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A89B647E20
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiLIG5C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIG4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:56:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C14AF4C6;
        Thu,  8 Dec 2022 22:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568870; x=1702104870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pEzHyd4Ac6oG5xApJ9gB+fF+e/HTbnBocyb4jHOlMgw=;
  b=EM9LWwvWnteHyZfx3QTWLi9fciiyoxZBr5+upEk0o38LPpnw2qD73mYI
   VhUFHJnMD/FcfhLSNZEt0Ere2OPx4JTh6Pg6wMrlJnmGhiq27MhMcBu3L
   ToFcohpOMD3mbdlO/1dBj2ebAdTICHFhm2e7HE9Ov5hPu3+mXNLmfIzkH
   w0tMvBZLuVebmzIMWxYQt5MIrZe0VHjaToHri5nYZsIiVSNbmgJKnms/H
   gNYklZtJXyKhIjzEcqS3ar3EV5VJgWFmzZeNUNz0bIkRgBrA3iyu3eNtD
   unB6sq+bKv7yn0t+WcvC5BRx3CfKMMuS/OlBT95M+sqDOsl7yj2/T5gmU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551509"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551509"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:14 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679837143"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679837143"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:09 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 14/16] x86/virt/tdx: Initialize all TDMRs
Date:   Fri,  9 Dec 2022 19:52:35 +1300
Message-Id: <16d47f9611d53c0f07a4af2b5739ed83e41b6e48.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the global KeyID has been configured on all packages, initialize
all TDMRs to make all TDX-usable memory regions that are passed to the
TDX module become usable.

This is the last step of initializing the TDX module.

Initializing different TDMRs can be parallelized.  For now to keep it
simple, just initialize all TDMRs one by one.  It can be enhanced in the
future.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v7 -> v8: (Dave)
 - Changelog:
   - explicitly call out this is the last step of TDX module initialization.
   - Trimed down changelog by removing SEAMCALL name and details.
 - Removed/trimmed down unnecessary comments.
 - Other changes due to 'struct tdmr_info_list'.

v6 -> v7:
 - Removed need_resched() check. -- Andi.

---
 arch/x86/virt/vmx/tdx/tdx.c | 61 ++++++++++++++++++++++++++++++++-----
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4c779e8412f1..8b7314f19df2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1006,6 +1006,55 @@ static int config_global_keyid(void)
 	return ret;
 }
 
+static int init_tdmr(struct tdmr_info *tdmr)
+{
+	u64 next;
+
+	/*
+	 * Initializing a TDMR can be time consuming.  To avoid long
+	 * SEAMCALLs, the TDX module may only initialize a part of the
+	 * TDMR in each call.
+	 */
+	do {
+		struct tdx_module_output out;
+		int ret;
+
+		/* All 0's are unused parameters, they mean nothing. */
+		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, NULL,
+				&out);
+		if (ret)
+			return ret;
+		/*
+		 * RDX contains 'next-to-initialize' address if
+		 * TDH.SYS.TDMR.INT succeeded.
+		 */
+		next = out.rdx;
+		cond_resched();
+		/* Keep making SEAMCALLs until the TDMR is done */
+	} while (next < tdmr->base + tdmr->size);
+
+	return 0;
+}
+
+static int init_tdmrs(struct tdmr_info_list *tdmr_list)
+{
+	int i;
+
+	/*
+	 * This operation is costly.  It can be parallelized,
+	 * but keep it simple for now.
+	 */
+	for (i = 0; i < tdmr_list->nr_tdmrs; i++) {
+		int ret;
+
+		ret = init_tdmr(tdmr_entry(tdmr_list, i));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int init_tdx_module(void)
 {
 	/*
@@ -1076,14 +1125,10 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
-	/*
-	 * TODO:
-	 *
-	 *  - Initialize all TDMRs.
-	 *
-	 *  Return error before all steps are done.
-	 */
-	ret = -EINVAL;
+	/* Initialize TDMRs to complete the TDX module initialization */
+	ret = init_tdmrs(&tdmr_list);
+	if (ret)
+		goto out_free_pamts;
 out_free_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index f5c12a2543d4..163c4876dee4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -21,6 +21,7 @@
  */
 #define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_CONFIG		45
 
 struct cmr_info {
-- 
2.38.1

