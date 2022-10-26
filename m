Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8F660EC40
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiJZXTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234290AbiJZXTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:19:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E3BB40D4;
        Wed, 26 Oct 2022 16:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826299; x=1698362299;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X8yqBDHPAxZ58eQMTu8KK6VQiFYdhPWhN364id0KIxU=;
  b=edkqe28hXStfb9q7+RFvFUbRg6R3poLLaiwymQgVf4Kg1ZrF3eClfGyA
   PeALnlY4C08pdZaIaIpwGSsznAw1Dl9UvS03hDFRMZywuLCdIURbcz3vG
   vXURN/gTNBdV6IyogJXNeocJlf6byn4772iiSop4nO2GBFPguNdMWyFD6
   FNJk5bDZkxF3VLZMzwNy5xSIakutxA3qy0ldzXtDVluwZs69dtYgUJJmO
   E3/o9iVJ4KKw9NpcPYyrQCWhl511H5+FubSTnKzGbL8DGbi/ElYSeikud
   39YH+eMqu7CKsCzsFKvYHlzvqzPochppRja9twdJErIGHyVg44bgmQxhP
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175656"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175656"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:18 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446554"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446554"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:14 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 19/21] x86/virt/tdx: Initialize all TDMRs
Date:   Thu, 27 Oct 2022 12:16:18 +1300
Message-Id: <c78e41604f5c5274da3d5a9a01632abfad0926a5.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
memory, each TDH.SYS.TDMR.INIT roughly takes couple of microseconds on
average, and it takes roughly dozens of milliseconds to complete the
initialization of all TDMRs while system is idle.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 70 ++++++++++++++++++++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9cfb01e7666a..68ec1ebecb49 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1151,6 +1151,66 @@ static int config_global_keyid(void)
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
+		ret = seamcall(TDH_SYS_TDMR_INIT, tdmr->base, 0, 0, 0, NULL,
+				&out);
+		if (ret)
+			return ret;
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
@@ -1232,11 +1292,11 @@ static int init_tdx_module(void)
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
 out_free_pamts:
 	if (ret) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 768d097412ab..891691b1ea50 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
+#define TDH_SYS_TDMR_INIT	36
 #define TDH_SYS_LP_SHUTDOWN	44
 #define TDH_SYS_CONFIG		45
 
-- 
2.37.3

