Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93649539736
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347559AbiEaTmY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347546AbiEaTmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:42:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5240E3B4;
        Tue, 31 May 2022 12:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026100; x=1685562100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WPRrxoxL43+8moAbr4TYSZMvvLUkYwL9yUoXOyZiIOY=;
  b=SlCGA3Bme5XCgVYMKYFoGcDeQo9b8IZPWh7H7h3uMhw7IYNLqDSCyKeq
   J+Lfya1Jh2YsFQIrP0GcgyGZbCd64Ng67Q8uZ+RbgV4IQJJ5hf8ZgpbPR
   eTvaqKw7Q92AUHNdz4dL4PeLhACfWv2J4Dy6q1sc0kKCQ/McbViP+0niQ
   aPCSwtvDHmGLbP5yGpmvM1cKKXTInluw61FSKnbvIRFoEO7XIv/soBd0Z
   Ch14dnh957hPkAdwp0zyD8Et+rX3oWh5ZEI8f5k+fL9UWMiz77NnGG5YD
   Gi5BrfEjiBAhXYTjbMxrghhUVZlF7UaLv9RxWjmcq/pNcco3Fwm7SgVUo
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935297"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935297"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:41:02 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164766"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:59 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 20/22] x86/virt/tdx: Initialize all TDMRs
Date:   Wed,  1 Jun 2022 07:39:43 +1200
Message-Id: <5690e2cd4fd005d269be79423cfc6e839d73bb82.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initialize TDMRs via TDH.SYS.TDMR.INIT as the last step to complete the
TDX initialization.

All TDMRs need to be initialized using TDH.SYS.TDMR.INIT SEAMCALL before
the memory pages can be used by the TDX module.  The time to initialize
TDMR is proportional to the size of the TDMR because TDH.SYS.TDMR.INIT
internally initializes the PAMT entries using the global KeyID.

To avoid long latency caused in one SEAMCALL, TDH.SYS.TDMR.INIT only
initializes an (implementation-specific) subset of PAMT entries of one
TDMR in one invocation.  The caller needs to call TDH.SYS.TDMR.INIT
iteratively until all PAMT entries of the given TDMR are initialized.

TDH.SYS.TDMR.INITs can run concurrently on multiple CPUs as long as they
are initializing different TDMRs.  To keep it simple, just initialize
all TDMRs one by one.  On a 2-socket machine with 2.2G CPUs and 64GB
memory, each TDH.SYS.TDMR.INIT roughly takes ~7us on average, and it
takes roughly ~100ms to complete initializing all TDMRs while system is
idle.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 70 ++++++++++++++++++++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0a59b196787a..1363998ce1a9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1025,6 +1025,65 @@ static int config_global_keyid(void)
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
+		u64 ret;
+
+		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, &out);
+		if (ret)
+			return -EFAULT;
+		/*
+		 * RDX contains 'next-to-initialize' address if
+		 * TDH.SYS.TDMR.INT succeeded.
+		 */
+		next = out.rdx;
+		/* Allow scheduling when needed */
+		if (need_resched())
+			cond_resched();
+	} while (next < tdmr->base + tdmr->size);
+
+	return 0;
+}
+
+/* Initialize all TDMRs */
+static int init_tdmrs(struct tdmr_info *tdmr_array, int tdmr_num)
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
+		ret = init_tdmr(tdmr_array_entry(tdmr_array, i));
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -1115,11 +1174,12 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
-	/*
-	 * Return -EINVAL until all steps of TDX module initialization
-	 * process are done.
-	 */
-	ret = -EINVAL;
+	/* Initialize TDMRs to complete the TDX module initialization */
+	ret = init_tdmrs(tdmr_array, tdmr_num);
+	if (ret)
+		goto out_free_pamts;
+
+	tdx_module_status = TDX_MODULE_INITIALIZED;
 out_free_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 2d25a93b89ef..e0309558be13 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,6 +53,7 @@
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_LP_SHUTDOWN	44
 #define TDH_SYS_CONFIG		45
 
-- 
2.35.3

