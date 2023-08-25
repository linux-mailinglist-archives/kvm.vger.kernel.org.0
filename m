Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD737886F0
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244773AbjHYMR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244807AbjHYMRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:17:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB572689;
        Fri, 25 Aug 2023 05:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965809; x=1724501809;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rCdouzPKduBamwW30yrgG5DIdV0HcU/vwdKmioxRUO4=;
  b=P7IZ2eEIFporyP95zYzOC0Bw4qa8ysELpPBKfPnrg+Aad6O91YfDcgrc
   4zv5+H86uLFYA8Js2rVu4F4ZAfuzPWP38DZytfwpe4JSxV7WGNNH6yDvR
   tZBkuV+11ZZygZTp/tLvqKT0Nq3PsHljfO4K80SlkSseFBnnwnQFVQetk
   xX/d4Tk4ly0ARJMPdKyxILeYvwlhiZ6MRrShud4FrCMcxRzZhbJeU57sx
   PveQYaAWTva0KFs5RBKA7JJMek7gkbxHzqzoNPuhnAfG8KFkEVKEoALDP
   5hLO8kg/F+5ZE7vj5o4wlfLX8EvQAKfVp8/rsMG+oIvI123l9G4iyFno/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639437"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639437"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158857"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:37 -0700
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
Subject: [PATCH v13 18/22] x86/virt/tdx: Keep TDMRs when module initialization is successful
Date:   Sat, 26 Aug 2023 00:14:37 +1200
Message-ID: <ee8019b33d57f2a4398a55cc5ebfdf21d918f811.1692962263.git.kai.huang@intel.com>
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

On the platforms with the "partial write machine check" erratum, the
kexec() needs to convert all TDX private pages back to normal before
booting to the new kernel.  Otherwise, the new kernel may get unexpected
machine check.

There's no existing infrastructure to track TDX private pages.  Change
to keep TDMRs when module initialization is successful so that they can
be used to find PAMTs.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v12 -> v13:
  - Split "improve error handling" part out as a separate patch.

v11 -> v12 (new patch):
  - Defer keeping TDMRs logic to this patch for better review
  - Improved error handling logic (Nikolay/Kirill in patch 15)


---
 arch/x86/virt/vmx/tdx/tdx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b410fe66fd74..ea1363ceaa28 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -132,6 +132,8 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+static struct tdmr_info_list tdx_tdmr_list;
+
 /*
  * Do the module global initialization if not done yet.  It can be
  * done on any cpu.  It's always called with interrupts disabled.
@@ -1080,7 +1082,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 static int init_tdx_module(void)
 {
 	struct tdsysinfo_struct *tdsysinfo;
-	struct tdmr_info_list tdmr_list;
 	struct cmr_info *cmr_array;
 	int tdsysinfo_size;
 	int cmr_array_size;
@@ -1123,17 +1124,17 @@ static int init_tdx_module(void)
 		goto out_put_tdxmem;
 
 	/* Allocate enough space for constructing TDMRs */
-	ret = alloc_tdmr_list(&tdmr_list, tdsysinfo);
+	ret = alloc_tdmr_list(&tdx_tdmr_list, tdsysinfo);
 	if (ret)
 		goto out_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
-	ret = construct_tdmrs(&tdx_memlist, &tdmr_list, tdsysinfo);
+	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, tdsysinfo);
 	if (ret)
 		goto out_free_tdmrs;
 
 	/* Pass the TDMRs and the global KeyID to the TDX module */
-	ret = config_tdx_module(&tdmr_list, tdx_global_keyid);
+	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
 	if (ret)
 		goto out_free_pamts;
 
@@ -1153,7 +1154,7 @@ static int init_tdx_module(void)
 		goto out_reset_pamts;
 
 	/* Initialize TDMRs to complete the TDX module initialization */
-	ret = init_tdmrs(&tdmr_list);
+	ret = init_tdmrs(&tdx_tdmr_list);
 out_reset_pamts:
 	if (ret) {
 		/*
@@ -1170,20 +1171,17 @@ static int init_tdx_module(void)
 		 * back to normal.  But do the conversion anyway here
 		 * as suggested by the TDX spec.
 		 */
-		tdmrs_reset_pamt_all(&tdmr_list);
+		tdmrs_reset_pamt_all(&tdx_tdmr_list);
 	}
 out_free_pamts:
 	if (ret)
-		tdmrs_free_pamt_all(&tdmr_list);
+		tdmrs_free_pamt_all(&tdx_tdmr_list);
 	else
 		pr_info("%lu KBs allocated for PAMT.\n",
-				tdmrs_count_pamt_kb(&tdmr_list));
+				tdmrs_count_pamt_kb(&tdx_tdmr_list));
 out_free_tdmrs:
-	/*
-	 * Always free the buffer of TDMRs as they are only used during
-	 * module initialization.
-	 */
-	free_tdmr_list(&tdmr_list);
+	if (ret)
+		free_tdmr_list(&tdx_tdmr_list);
 out_free_tdxmem:
 	if (ret)
 		free_tdx_memlist(&tdx_memlist);
-- 
2.41.0

