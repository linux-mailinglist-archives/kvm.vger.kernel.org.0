Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B608B6317C4
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKUAbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiKUAa2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:30:28 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F035E9F5;
        Sun, 20 Nov 2022 16:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990537; x=1700526537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3LwZ/2jAQ0M9UrYz1pvBJwdZZg6HBZnO8RRBVvS9No4=;
  b=MEWNWzv7JAUBF48uSWNG2sSZ3wzkfCIr540XtHyg5JHJDcgYWp9O7RDR
   q9Jgh7t58bqjgrnVtkf9e1wOyU7CetgPLG3bso9IjTH/IeVBgksl8dzmp
   Cfb72x7Uu1ZNlmR2gsG48uFzMhfg4sRyYbbrrLP2RL4NfGbD7IO2v+2de
   zw2j9eD0kB4hi0MmD1o4LlF1L1iX2k5/UFLYUo6yVPMnW62uzdpOPanhq
   u4xy1gYyVEPhb/wgPxHXVI5UGQmDQYdfL68E7z7MOn4ZLax52oTjf1d0V
   K7vWjSTaguOAgf/OmifHTjidF0Za9wU9r1eKCB7VOAYwfnObwLHxmjrys
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="377705762"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="377705762"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825550"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825550"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:28:09 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 18/20] x86/virt/tdx: Initialize all TDMRs
Date:   Mon, 21 Nov 2022 13:26:40 +1300
Message-Id: <2337c8e9086a006aaa2c4b99caf478420d1fc640.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

v6 -> v7:
 - Removed need_resched() check. -- Andi.

---
 arch/x86/virt/vmx/tdx/tdx.c | 69 ++++++++++++++++++++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 65 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 99d1be5941a7..9bcdb30b7a80 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1066,6 +1066,65 @@ static int config_global_keyid(void)
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
+		cond_resched();
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
@@ -1172,11 +1231,11 @@ static int init_tdx_module(void)
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
2.38.1

