Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D7C7CC07C
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343896AbjJQKS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343794AbjJQKRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:17:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61EDFC;
        Tue, 17 Oct 2023 03:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537820; x=1729073820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R4C2hloBV4Q5RxIUeP/DUfELz3hN3esJuwfm4O46dow=;
  b=BZa/WJ/1xgxzUeQl+MImeDmCECDEfxfjoVR8NQOrL/PoSJEIuIuVhozf
   xrd5q3uqrw7WWuJKpKt6GpLVJBjBc4LrBPHu5KFChZvzZu4Z/HEAEcNG9
   hv8IIlbFHdiXJV/5gCJFsg0g7hYNn1jnO0WGOHbWhETQXbBpkad8lBjaZ
   yUEXT6lnthNLQ1WxKPR5mBofTgYtXCCevEBqK3RQOKR/5eJhcpxncCrMl
   9Xst6WmtFPYEoCz6jSLgQ0BssdzkfQRLphXk8I8NIlFvjtz+po7iqNyuY
   Ebpk0ZA/Fzgwcdw4J21VCY1FeP1pAfIVKEdmLppYNFpNV0NOsiPTnxTsM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471972595"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="471972595"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:17:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503894"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503894"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:16:54 -0700
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
Subject: [PATCH v14 19/23] x86/virt/tdx: Improve readability of module initialization error handling
Date:   Tue, 17 Oct 2023 23:14:43 +1300
Message-ID: <7709417c896a28f0b2d4bd1fb08492a1f2ec99fb.1697532085.git.kai.huang@intel.com>
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

With keeping TDMRs upon successful TDX module initialization, now only
put_online_mems() and freeing the buffers of the TDSYSINFO_STRUCT and
the CMR array still need to be done even when module initialization is
successful.  On the other hand, all other four "out_*" labels before
them explicitly check the return value and only clean up when module
initialization fails.

This isn't ideal.  Make all other four "out_*" labels only reachable
when module initialization fails to improve the readability of error
handling.  Rename them from "out_*" to "err_*" to reflect the fact.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v13 -> v14:
 - Fix spell typo (Rick)
 - Add Kirill/Rick's tags

v12 -> v13:
  - New patch to improve error handling. (Kirill, Nikolay)

---
 arch/x86/virt/vmx/tdx/tdx.c | 67 +++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9a02b9237612..3aaf8d8b4920 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1104,17 +1104,17 @@ static int init_tdx_module(void)
 	/* Allocate enough space for constructing TDMRs */
 	ret = alloc_tdmr_list(&tdx_tdmr_list, tdsysinfo);
 	if (ret)
-		goto out_free_tdxmem;
+		goto err_free_tdxmem;
 
 	/* Cover all TDX-usable memory regions in TDMRs */
 	ret = construct_tdmrs(&tdx_memlist, &tdx_tdmr_list, tdsysinfo);
 	if (ret)
-		goto out_free_tdmrs;
+		goto err_free_tdmrs;
 
 	/* Pass the TDMRs and the global KeyID to the TDX module */
 	ret = config_tdx_module(&tdx_tdmr_list, tdx_global_keyid);
 	if (ret)
-		goto out_free_pamts;
+		goto err_free_pamts;
 
 	/*
 	 * Hardware doesn't guarantee cache coherency across different
@@ -1129,40 +1129,16 @@ static int init_tdx_module(void)
 	/* Config the key of global KeyID on all packages */
 	ret = config_global_keyid();
 	if (ret)
-		goto out_reset_pamts;
+		goto err_reset_pamts;
 
 	/* Initialize TDMRs to complete the TDX module initialization */
 	ret = init_tdmrs(&tdx_tdmr_list);
-out_reset_pamts:
-	if (ret) {
-		/*
-		 * Part of PAMTs may already have been initialized by the
-		 * TDX module.  Flush cache before returning PAMTs back
-		 * to the kernel.
-		 */
-		wbinvd_on_all_cpus();
-		/*
-		 * According to the TDX hardware spec, if the platform
-		 * doesn't have the "partial write machine check"
-		 * erratum, any kernel read/write will never cause #MC
-		 * in kernel space, thus it's OK to not convert PAMTs
-		 * back to normal.  But do the conversion anyway here
-		 * as suggested by the TDX spec.
-		 */
-		tdmrs_reset_pamt_all(&tdx_tdmr_list);
-	}
-out_free_pamts:
 	if (ret)
-		tdmrs_free_pamt_all(&tdx_tdmr_list);
-	else
-		pr_info("%lu KBs allocated for PAMT\n",
-				tdmrs_count_pamt_kb(&tdx_tdmr_list));
-out_free_tdmrs:
-	if (ret)
-		free_tdmr_list(&tdx_tdmr_list);
-out_free_tdxmem:
-	if (ret)
-		free_tdx_memlist(&tdx_memlist);
+		goto err_reset_pamts;
+
+	pr_info("%lu KBs allocated for PAMT\n",
+			tdmrs_count_pamt_kb(&tdx_tdmr_list));
+
 out_put_tdxmem:
 	/*
 	 * @tdx_memlist is written here and read at memory hotplug time.
@@ -1177,6 +1153,31 @@ static int init_tdx_module(void)
 	kfree(tdsysinfo);
 	kfree(cmr_array);
 	return ret;
+
+err_reset_pamts:
+	/*
+	 * Part of PAMTs may already have been initialized by the
+	 * TDX module.  Flush cache before returning PAMTs back
+	 * to the kernel.
+	 */
+	wbinvd_on_all_cpus();
+	/*
+	 * According to the TDX hardware spec, if the platform
+	 * doesn't have the "partial write machine check"
+	 * erratum, any kernel read/write will never cause #MC
+	 * in kernel space, thus it's OK to not convert PAMTs
+	 * back to normal.  But do the conversion anyway here
+	 * as suggested by the TDX spec.
+	 */
+	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+err_free_pamts:
+	tdmrs_free_pamt_all(&tdx_tdmr_list);
+err_free_tdmrs:
+	free_tdmr_list(&tdx_tdmr_list);
+err_free_tdxmem:
+	free_tdx_memlist(&tdx_memlist);
+	/* Do things irrelevant to module initialization result */
+	goto out_put_tdxmem;
 }
 
 static int __tdx_enable(void)
-- 
2.41.0

