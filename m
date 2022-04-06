Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDE34F57A3
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 10:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbiDFHYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 03:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456665AbiDFGon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 02:44:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F8C1624A2;
        Tue,  5 Apr 2022 21:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220659; x=1680756659;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+dWPDiE4xf63aSyJo77PiXg+mtIis/JHI1I6V04uBU=;
  b=VnYeP5a6xZf1ud7WMcSOMT3bckQN5oFJHRqp0knZRRoey2yd7tJON/46
   SYNkVS7ijNxPTFjvUxPYi6AcOp6FM/zh74VamAPn09iW6GM/Uoykah68S
   1SCUU5xJphPVAde5UTEEUJnJVNgI1WAwgfoKPwpWnMADfaEY+92MUev+p
   65FJnx+U8cQE/5wC9ESohiY+UDwXrMXqlAVNQsIJw93KVMLQaMDwBAMo0
   Qw+2Ubg97fOsJTxpJkG7YQaQj0KM5M7HTGm8Dxc4IcRGMQFgv3/hKa8B+
   cUTf/Q175MWycEGy+U5PmeujMFMRTf4nIp5gHbu+fVEwGlJCvVlnhZwRC
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089913"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089913"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:56 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302468"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:52 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 18/21] x86/virt/tdx: Initialize all TDMRs
Date:   Wed,  6 Apr 2022 16:49:30 +1200
Message-Id: <9c180b4f34956a5d43bbf7894c423fcbe75fc7a9.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/x86/virt/vmx/tdx/tdx.c | 75 ++++++++++++++++++++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index bb15122fb8bd..11bd1daffee3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1376,6 +1376,65 @@ static int config_global_keyid(void)
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
@@ -1457,11 +1516,12 @@ static int init_tdx_module(void)
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
@@ -1484,6 +1544,11 @@ static int init_tdx_module(void)
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
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index bba8cabea4bb..212f83374c0a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -126,6 +126,7 @@ struct tdmr_info {
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_LP_SHUTDOWN	44
 #define TDH_SYS_CONFIG		45
 
-- 
2.35.1

