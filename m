Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A51694528
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjBMMD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjBMMDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:03:34 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BCA9025;
        Mon, 13 Feb 2023 04:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289776; x=1707825776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TGDot2bjHCtuoG3UVHU78PX2clfks7hjsOzbIQgZuuE=;
  b=ZWN0ZGlvmgshaRmatojKs0052A1lowi1CPUXAxA0HaxHFF4N0+fz+YEV
   xk6gRZUzD61oL7Z8CqCyvdEPVcdq/OzEwfreLFo9SLHB94AShtHavEI8S
   NhIhoyVOjjsXZ2KvxGEM37X+CXjvNQewyA57esdeUbuqiFhnD6Wq6n56O
   ekmwe5lVdgyimAkqShrM/uBLMIEWX/39Yv4opbis2JEA8hY6UCkOUms+S
   HRlccPsUj5I5GM3YtESjIRiDDsfGtA7hEGmy9/eNAp99cXGx0QamiopmC
   GlqDm5S5TP8vPTGRw6wNGTkh5bqw8w7SYJLS+Hg0mrlKpCWCzegFoj6eu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283504"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283504"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243539"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243539"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:32 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v9 16/18] x86/virt/tdx: Initialize all TDMRs
Date:   Tue, 14 Feb 2023 00:59:23 +1300
Message-Id: <f449a6bc28d9a622aa8e3714096faf890eeffe50.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676286526.git.kai.huang@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
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

Initializing TDMRs can be time consuming on large memory systems as it
involves initializing all metadata entries for all pages that can be
used by TDX guests.  Initializing different TDMRs can be parallelized.
For now to keep it simple, just initialize all TDMRs one by one.  It can
be enhanced in the future.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

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
index ff6f2c9d9838..c291fbd29bb0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1086,6 +1086,56 @@ static int config_global_keyid(void)
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
@@ -1170,15 +1220,9 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
-	/*
-	 * TODO:
-	 *
-	 *  - Initialize all TDMRs.
-	 *
-	 *  Return error before all steps are done.
-	 */
+	/* Initialize TDMRs to complete the TDX module initialization */
+	ret = init_tdmrs(&tdx_tdmr_list);
 
-	ret = -EINVAL;
 out_free_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index ca4e2edbf4bc..4e312c7f9553 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -18,6 +18,7 @@
  */
 #define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_CONFIG		45
 
 struct cmr_info {
-- 
2.39.1

