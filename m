Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165607CC07A
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbjJQKSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343774AbjJQKRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:17:41 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8797410C6;
        Tue, 17 Oct 2023 03:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537814; x=1729073814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IW2joqa43yE+gdm/hHMD0E7KRPOslCtHQymG4aQhmYo=;
  b=JXnfxopOXaRIsK/rg+06t745tLyRUThRSXWLHxRUjme5Kwpe4YFLOOGr
   yrnsQUo5DLBSBrrdex0AuLnq+tq2Ht603mh/Zt8hhRn56yD7B/sjX9JTJ
   4vx4Af7mQZEiQP7dumO+BpeOw+dyi77Infs1JOP0HAMaoTMzghn37g3E4
   X70S1YPGYd7ZR+z8f4Rvy7KzoPgSsV4w5gBOPBLDU6KMMcYLmFNHjW9sQ
   r7z06ITY+MzBK/8OJB2TyZRDHAE1JMy9Os6072vpH3w2GiRxsqw000Xw2
   W/sOffLoH/m8yxLBz3B2MgpAF8XlAhdln5W76SN2JAxDEM1idmojk0YtQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471972561"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="471972561"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503860"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503860"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:48 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v14 18/23] x86/virt/tdx: Keep TDMRs when module initialization is successful
Date:   Tue, 17 Oct 2023 23:14:42 +1300
Message-ID: <d3fd97f6fa08e213ed4d74354f65369df7e75bdd.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1697532085.git.kai.huang@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
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

On the platforms with the "partial write machine check" erratum, the
kexec() needs to convert all TDX private pages back to normal before
booting to the new kernel.  Otherwise, the new kernel may get unexpected
machine check.

There's no existing infrastructure to track TDX private pages.  Keep
TDMRs when module initialization is successful so that they can be used
to find PAMTs.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v13 -> v14:
 - "Change to keep" -> "Keep" (Kirill)
 - Add Kirill/Rick's tags

v12 -> v13:
  - Split "improve error handling" part out as a separate patch.

v11 -> v12 (new patch):
  - Defer keeping TDMRs logic to this patch for better review
  - Improved error handling logic (Nikolay/Kirill in patch 15)

---
 arch/x86/virt/vmx/tdx/tdx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4f55da1853a9..9a02b9237612 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -46,6 +46,8 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions.  Protected by mem_hotplug_lock. */
 static LIST_HEAD(tdx_memlist);
 
+static struct tdmr_info_list tdx_tdmr_list;
+
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -1058,7 +1060,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 static int init_tdx_module(void)
 {
 	struct tdsysinfo_struct *tdsysinfo;
-	struct tdmr_info_list tdmr_list;
 	struct cmr_info *cmr_array;
 	int tdsysinfo_size;
 	int cmr_array_size;
@@ -1101,17 +1102,17 @@ static int init_tdx_module(void)
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
 
@@ -1131,7 +1132,7 @@ static int init_tdx_module(void)
 		goto out_reset_pamts;
 
 	/* Initialize TDMRs to complete the TDX module initialization */
-	ret = init_tdmrs(&tdmr_list);
+	ret = init_tdmrs(&tdx_tdmr_list);
 out_reset_pamts:
 	if (ret) {
 		/*
@@ -1148,20 +1149,17 @@ static int init_tdx_module(void)
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
 		pr_info("%lu KBs allocated for PAMT\n",
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

