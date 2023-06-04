Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D847217C0
	for <lists+kvm@lfdr.de>; Sun,  4 Jun 2023 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbjFDOaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Jun 2023 10:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjFDOam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Jun 2023 10:30:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CC71B3;
        Sun,  4 Jun 2023 07:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685889035; x=1717425035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k4MMOcKeW3mtE7wFf+wIKDTivgf3+1s3ufWIu5AQpnU=;
  b=laZAjaMNiW/PRnDd+glN/y+Qz6SptmgzG9fI7lzZ7NKdoC5m5LK7uZja
   O0dyBuK6GZY94z0ZPYzq0dU0hoMgOvGH9KYFNdHkMgAGf0MU2X/J+mE19
   0LOgcpQc8X5zd8sFbpz6L42N/L12gOF8GexAf868R94u46HINlHKpfUiP
   gp57aVZXM6cH5IQS3wkdPRDFjzHxBGQ+2HLVHGMZlIVLPp9v0+E0pXgTq
   xfS9sQ3dFBqXGnQ4LQa930j7/wkGIJ75+wTqukWCZFacsc5pkLwT8cUuw
   at7wlo/n0Ed7zdP6ysJ9IMW6VcwjCVt3RLBZmU02SJWKe2LFEr6fU7jf3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="353683665"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="353683665"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10731"; a="1038501187"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="1038501187"
Received: from tdhastx-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.50.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2023 07:29:09 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v11 16/20] x86/virt/tdx: Initialize all TDMRs
Date:   Mon,  5 Jun 2023 02:27:29 +1200
Message-Id: <7bd7d0c6196deb58b54d6e629603775844b1307d.1685887183.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685887183.git.kai.huang@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
---

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
index 4aa6cf27e1c2..8ff07256a515 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1029,6 +1029,56 @@ static int config_global_keyid(void)
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
+		 * TDH.SYS.TDMR.INIT did not fully complete and
+		 * should be retried.
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
 	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
@@ -1088,14 +1138,8 @@ static int init_tdx_module(void)
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
+	ret = init_tdmrs(&tdx_tdmr_list);
 out_reset_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 15e7250e74c7..012153067440 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -26,6 +26,7 @@
 #define TDH_SYS_INFO		32
 #define TDH_SYS_CONFIG		45
 #define TDH_SYS_KEY_CONFIG	31
+#define TDH_SYS_TDMR_INIT	36
 
 struct cmr_info {
 	u64	base;
-- 
2.40.1

