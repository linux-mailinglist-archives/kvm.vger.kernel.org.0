Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A189E7886EE
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 14:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244756AbjHYMR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 08:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244824AbjHYMRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 08:17:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080782133;
        Fri, 25 Aug 2023 05:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692965816; x=1724501816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WkmrGwM5thkl9YnXz+bYAzgjVOFrfZ/PYDGsMmFmZVk=;
  b=J1OhYwkxv4HUOddx75RHisVKqWXWNm2jI7s231e8hJnzRapZRT3IrH5C
   EEKqOASCw1dDPKpLjrupclVRzLpSAYRLQGW2hO2r1SV1jSezmWDrLZSop
   GyZWBHMtWUQNNSUH3gQKiYaRv3fmaOF7NsrYgSPA4G2Zoc50XgldSQVK4
   fGU59mUoiuuQ+hqWel9Z7TrCrDZtAzeGTKIb+7XSVlKZy4A3ySvsTzWF4
   8q+SIXYvo2jWsUwr2jAHOin39T5oXAFK6ioUYrNxMTcgUJBy1Ot1LwskP
   B3doN04zndT6ctRJpqU2qBDly11rdf+U4obQLzEU6Q7rumNvWxUxNY3wS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10812"; a="438639460"
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="438639460"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="881158885"
Received: from vnaikawa-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.185.177])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 05:16:43 -0700
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
Subject: [PATCH v13 19/22] x86/virt/tdx: Improve readibility of module initialization error handling
Date:   Sat, 26 Aug 2023 00:14:38 +1200
Message-ID: <38ae8367b80d5943e5a86f7efa1acf264316dc06.1692962263.git.kai.huang@intel.com>
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

With keeping TDMRs upon successful TDX module initialization, now only
put_online_mems() and freeing the buffers of the TDSYSINFO_STRUCT and
the CMR array still need to be done even when module initialization is
successful.  On the other hand, all other four "out_*" labels before
them explicitly check the return value and only clean up when module
initialization fails.

This isn't ideal.  Make all other four "out_*" labels only reachable
when module initialization fails to improve the readibility of error
handling.  Rename them from "out_*" to "err_*" to reflect the fact.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v12 -> v13:
  - New patch to improve error handling. (Kirill, Nikolay)

---
 arch/x86/virt/vmx/tdx/tdx.c | 67 +++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ea1363ceaa28..8ee9f94c0fa7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1126,17 +1126,17 @@ static int init_tdx_module(void)
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
@@ -1151,40 +1151,16 @@ static int init_tdx_module(void)
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
-		pr_info("%lu KBs allocated for PAMT.\n",
-				tdmrs_count_pamt_kb(&tdx_tdmr_list));
-out_free_tdmrs:
-	if (ret)
-		free_tdmr_list(&tdx_tdmr_list);
-out_free_tdxmem:
-	if (ret)
-		free_tdx_memlist(&tdx_memlist);
+		goto err_reset_pamts;
+
+	pr_info("%lu KBs allocated for PAMT.\n",
+			tdmrs_count_pamt_kb(&tdx_tdmr_list));
+
 out_put_tdxmem:
 	/*
 	 * @tdx_memlist is written here and read at memory hotplug time.
@@ -1199,6 +1175,31 @@ static int init_tdx_module(void)
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

