Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459E14D746D
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234299AbiCMKw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiCMKws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3859342488;
        Sun, 13 Mar 2022 03:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168675; x=1678704675;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+PwKqgi1QBSJ18V2BSvNa8Zj3gKKVn9SnP8Q5rkorIs=;
  b=ZqXmY3Mfc7OlHTE4zq2sw/9Rnxyx09LBKjxLBqfZ6TGFfQPGcHzJ23BQ
   IrhxN/KAr0D+1Ko1iDEOy5L6yqdt/OlMTctgwVbll05N7a6/AjPlLfIdi
   09Tk0qyGLQcuqleOHAdyy9VEpM/9PqofIec7o9P9rpiG2gCOTwNzlZsW5
   jJDEIkD/Igih0sl/WvKu3q97+R4XiMEq1jIvI5lLAUUEub/z1tYGMBiVJ
   /56P4BXjl/gfiwRNBUWP4TMIRppXBoJ4xbENlBQsc7/vrdODV4lFaiMIz
   wold3Ky44yuqZWRO9i+bTbkVlgrbfQpX37ZluCazUexTK1AUupN10ogzl
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255590718"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255590718"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448238"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:05 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 18/21] x86/virt/tdx: Initialize all TDMRs
Date:   Sun, 13 Mar 2022 23:49:58 +1300
Message-Id: <3af7ece5cf86dfe83f755b7a7c541d8f691e4133.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize TDMRs via TDH.SYS.TDMR.INIT as the last step to complete the
TDX initialization.

All TDMRs need to be initialized using TDH.SYS.TDMR.INIT SEAMCALL before
the TDX memory can be used to run any TD guest.  The SEAMCALL internally
uses the global KeyID to initialize PAMTs in order to crypto protect
them from malicious host kernel.  TDH.SYS.TDMR.INIT can be done any cpu.

The time of initializing TDMR is proportional to the size of the TDMR.
To avoid long latency caused in one SEAMCALL, TDH.SYS.TDMR.INIT only
initializes an (implementation-specific) subset of PAMT entries of one
TDMR in one invocation.  The caller is responsible for calling
TDH.SYS.TDMR.INIT iteratively until all PAMT entries of the requested
TDMR are initialized.

Current implementation initializes TDMRs one by one.  It takes ~100ms on
a 2-socket machine with 2.2GHz CPUs and 64GB memory when the system is
idle.  Each TDH.SYS.TDMR.INIT takes ~7us on average.

TDX does allow different TDMRs to be initialized concurrently on
multiple CPUs. This parallel scheme could be introduced later when the
total initialization time becomes a real concern, e.g. on a platform
with a much bigger memory size.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 75 ++++++++++++++++++++++++++++++++++++++---
 arch/x86/virt/vmx/tdx.h |  1 +
 2 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 39b1b7d0417d..f2b9c98191ed 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1370,6 +1370,65 @@ static int config_global_keyid(u64 global_keyid)
 	return seamcall_on_each_package_serialized(&sc);
 }
 
+/* Initialize one TDMR */
+static int init_tdmr(struct tdmr_info *tdmr)
+{
+	u64 next;
+
+	/*
+	 * Initializing PAMT entries might be time-consuming (in
+	 * proportion to the size of the requested TDMR).  To avoid long
+	 * latency in one SEAMCALL, TDH.SYS.TDMR.INIT only initializes
+	 * an (implementation-defined) subset of PAMT entries in one
+	 * invocation.
+	 *
+	 * Call TDH.SYS.TDMR.INIT iteratively until all PAMT entries
+	 * of the requested TDMR are initialized (if next-to-initialize
+	 * address matches the end address of the TDMR).
+	 */
+	do {
+		struct tdx_module_output out;
+		int ret;
+
+		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0,
+				NULL, &out);
+		if (ret)
+			return ret;
+		/*
+		 * RDX contains 'next-to-initialize' address if
+		 * TDH.SYS.TDMR.INT succeeded.
+		 */
+		next = out.rdx;
+		if (need_resched())
+			cond_resched();
+	} while (next < tdmr->base + tdmr->size);
+
+	return 0;
+}
+
+/* Initialize all TDMRs */
+static int init_tdmrs(struct tdmr_info **tdmr_array, int tdmr_num)
+{
+	int i;
+
+	/*
+	 * Initialize TDMRs one-by-one for simplicity, though the TDX
+	 * architecture does allow different TDMRs to be initialized in
+	 * parallel on multiple CPUs.  Parallel initialization could
+	 * be added later when the time spent in the serialized scheme
+	 * becomes a real concern.
+	 */
+	for (i = 0; i < tdmr_num; i++) {
+		int ret;
+
+		ret = init_tdmr(tdmr_array[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int init_tdx_module(void)
 {
 	struct tdmr_info **tdmr_array;
@@ -1451,11 +1510,12 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
-	/*
-	 * Return -EFAULT until all steps of TDX module
-	 * initialization are done.
-	 */
-	ret = -EFAULT;
+	/* Initialize TDMRs to complete the TDX module initialization */
+	ret = init_tdmrs(tdmr_array, tdmr_num);
+	if (ret)
+		goto out_free_pamts;
+
+	tdx_module_status = TDX_MODULE_INITIALIZED;
 out_free_pamts:
 	/*
 	 * Free PAMTs allocated in construct_tdmrs() when TDX module
@@ -1478,6 +1538,11 @@ static int init_tdx_module(void)
 	free_tdmrs(tdmr_array, tdmr_num);
 	kfree(tdmr_array);
 out:
+	if (ret)
+		pr_info("Failed to initialize TDX module.\n");
+	else
+		pr_info("TDX module initialized.\n");
+
 	return ret;
 }
 
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index bba8cabea4bb..212f83374c0a 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -126,6 +126,7 @@ struct tdmr_info {
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_LP_SHUTDOWN	44
 #define TDH_SYS_CONFIG		45
 
-- 
2.35.1

