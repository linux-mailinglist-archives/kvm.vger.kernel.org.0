Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD867886E9
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244684AbjHYMQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244715AbjHYMQb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:16:31 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15972102;
        Fri, 25 Aug 2023 05:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965787; x=1724501787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZRK745TCeG+DajwLnyIceViJ+Tgi6rEEIjGythz+qSs=;
  b=Yd1kIIDcUrq/098cN/DURO/T2Htad8f69Pc5/eMO8iXUDRToJ1lVANAA
   uV7Vcbu9iAlEJJYzFyiGMlPkqyj61CWN63jKcJlHXBZXC4XN7BtEJiYev
   XJWdwKmPi0kiTNnbeBI9IyMX8/cqi46To+AykIy/p4tVflkxXTsdIV0cu
   jR+PnsNttDdm0jHybd75ofdF+t+/hpC5o58NeW5U3uG5JnBdYf3z4iOFi
   S2RndR9mu0cAuR/minOtmATH44cy7nxuOtJcgLLEcRgDPC0K46K0spulj
   +ScH3e6bCQsFkBUInq8SrV33LChAWKIcWOKcJLdvUMIdxgi1mj4oFKQAf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639414"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639414"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158755"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:27 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v13 16/22] x86/virt/tdx: Initialize all TDMRs
Date:   Sat, 26 Aug 2023 00:14:35 +1200
Message-ID: <621aa1bcc6d7d8bcd392fc987585a10be7b20b9e.1692962263.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692962263.git.kai.huang@intel.com>
References: <cover.1692962263.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the global KeyID has been configured on all packages, initialize
all TDMRs to make all TDX-usable memory regions that are passed to the
TDX module become usable.

This is the last step of initializing the TDX module.

Initializing TDMRs can be time consuming on large memory systems as it
involves initializing all metadata entries for all pages that can be
used by TDX guests.  Initializing different TDMRs can be parallelized.
For now to keep it simple, just initialize all TDMRs one by one.  It can
be enhanced in the future.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v12 -> v13:
 - Added Yuan's tag.

v11 -> v12:
 - Added Kirill's tag

v10 -> v11:
 - No update

v9 -> v10:
 - Code change due to change static 'tdx_tdmr_list' to local 'tdmr_list'.

v8 -> v9:
 - Improved changlog to explain why initializing TDMRs can take long
   time (Dave).
 - Improved comments around 'next-to-initialize' address (Dave).

v7 -> v8: (Dave)
 - Changelog:
   - explicitly call out this is the last step of TDX module initialization.
   - Trimed down changelog by removing SEAMCALL name and details.
 - Removed/trimmed down unnecessary comments.
 - Other changes due to 'struct tdmr_info_list'.

v6 -> v7:
 - Removed need_resched() check. -- Andi.


---
 arch/x86/virt/vmx/tdx/tdx.c | 60 ++++++++++++++++++++++++++++++++-----
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2e9fffc35f7e..b410fe66fd74 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1027,6 +1027,56 @@ static int config_global_keyid(void)
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
+		struct tdx_module_args args = {
+			.rcx = tdmr->base,
+		};
+		int ret;
+
+		ret = seamcall_prerr_ret(TDH_SYS_TDMR_INIT, &args);
+		if (ret)
+			return ret;
+		/*
+		 * RDX contains 'next-to-initialize' address if
+		 * TDH.SYS.TDMR.INIT did not fully complete and
+		 * should be retried.
+		 */
+		next = args.rdx;
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
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++) {
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
 	struct tdsysinfo_struct *tdsysinfo;
@@ -1102,14 +1152,8 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_reset_pamts;
 
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
 out_reset_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 2427ae40fc3c..6e41b0731e48 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -20,6 +20,7 @@
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_CONFIG		45
 
 struct cmr_info {
-- 
2.41.0

