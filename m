Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C894C60FE
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbiB1CQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiB1CPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:51 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D595D55BF6;
        Sun, 27 Feb 2022 18:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014505; x=1677550505;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dBqfqKzkRy/LMqeH/7Z1ov6sQ73SASKU5eXWSGhoaek=;
  b=fQrZS8OtoYk/sRwQR2QGR/5RvztvNGkwm1JvV1GB8jSUTfDhlWltBakI
   MWArxoUtyDM/qDQlZtNH3rrgAzmMNVSBbLBsFFLxLbtyb97U2XEZseD39
   dPZgV699djr2fg00Xsp/NkkJo0eRXJxDzbvp8mfPN8+J/swvZzBJjnJyg
   txedR1eVJM9YMpW3HsTL+ENfR+HYWs/8AtKAVHNbzSBh9J1IeOd7ayK48
   z3TTFe8+93Rygp8Rej1pJbraw6pGm2TGVZOXkgd8BfyoXOC7DPIT7+jzw
   lircWJb2F73/3lvAtBJcYH1qFWDTaM65J3C0las3Jnv8n7BAjFTBcQpEH
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240192036"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240192036"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:15:01 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936989"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:57 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 18/21] x86/virt/tdx: Initialize all TDMRs
Date:   Mon, 28 Feb 2022 15:13:06 +1300
Message-Id: <cb045d8b247031a68d74e20cd40e1b743b5234c5.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 22cbc43873c9..2760c10a430a 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1293,6 +1293,65 @@ static int config_global_keyid(u64 global_keyid)
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
@@ -1374,11 +1433,12 @@ static int init_tdx_module(void)
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
@@ -1401,6 +1461,11 @@ static int init_tdx_module(void)
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
2.33.1

