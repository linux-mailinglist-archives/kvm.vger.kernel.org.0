Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193BA60EC3A
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiJZXTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiJZXTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:19:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075AFCC817;
        Wed, 26 Oct 2022 16:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826291; x=1698362291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M9FpQkMtuwuHWG3RNoBQzkj2OGSvTQQjbz1P66pflQM=;
  b=PhYe5ju3BGNq1EIcbSgV5dbhDvu3bFjNuKu88BuZjqrdHKR5lDDix3m+
   7IzJNhhodgl7JbYBF/7DJXRAOlIrED0nvUAcSJoOyEKa1vqs9fyDjNWit
   Gveu/BT7kFYA5m4UcfO4d5S7CmwD2J3DGHDNha2M1cPR2JMaqGU79qwD/
   lmZBrBmWtwWLcDnPYTfVa9eiyFfMV9rXPdiZe4jI0tNPxRyHuPnDRl00M
   Jy5YfJmdq9HzobMs7Y+rydhn7zhg4P2uxgyOJm4Un1UnPnug2obgu/UEM
   CyqiWt4gFUH6ijaaWSF+ID9cCyCq5UrlprPDC05FLKsBxa3wOQD1jmuux
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175642"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175642"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:10 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446520"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446520"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:18:06 -0700
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
Subject: [PATCH v6 17/21] x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
Date:   Thu, 27 Oct 2022 12:16:16 +1300
Message-Id: <3ad05326024d476ee8d9bc12944d63b035ca2e23.1666824663.git.kai.huang@intel.com>
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

After the TDX-usable memory regions are constructed in an array of TDMRs
and the global KeyID is reserved, configure them to the TDX module using
TDH.SYS.CONFIG SEAMCALL.  TDH.SYS.CONFIG can only be called once and can
be done on any logical cpu.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 38 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 0820ba781f97..fdfce715dda6 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -17,6 +17,7 @@
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/align.h>
 #include <linux/atomic.h>
 #include <linux/sort.h>
@@ -1064,6 +1065,37 @@ static int construct_tdmrs(struct tdmr_info *tdmr_array, int *tdmr_num)
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
+			     u64 global_keyid)
+{
+	u64 *tdmr_pa_array;
+	int i, array_sz;
+	u64 ret;
+
+	/*
+	 * TDMR_INFO entries are configured to the TDX module via an
+	 * array of the physical address of each TDMR_INFO.  TDX module
+	 * requires the array itself to be 512-byte aligned.  Round up
+	 * the array size to 512-byte aligned so the buffer allocated
+	 * by kzalloc() will meet the alignment requirement.
+	 */
+	array_sz = ALIGN(tdmr_num * sizeof(u64), TDMR_INFO_PA_ARRAY_ALIGNMENT);
+	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
+	if (!tdmr_pa_array)
+		return -ENOMEM;
+
+	for (i = 0; i < tdmr_num; i++)
+		tdmr_pa_array[i] = __pa(tdmr_array_entry(tdmr_array, i));
+
+	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array), tdmr_num,
+				global_keyid, 0, NULL, NULL);
+
+	/* Free the array as it is not required anymore. */
+	kfree(tdmr_pa_array);
+
+	return ret;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -1122,11 +1154,17 @@ static int init_tdx_module(void)
 	 */
 	tdx_global_keyid = tdx_keyid_start;
 
+	/* Pass the TDMRs and the global KeyID to the TDX module */
+	ret = config_tdx_module(tdmr_array, tdmr_num, tdx_global_keyid);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
 	 */
 	ret = -EINVAL;
+out_free_pamts:
 	if (ret)
 		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
 	else
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a737f2b51474..c26bab2555ca 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -86,6 +87,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.37.3

