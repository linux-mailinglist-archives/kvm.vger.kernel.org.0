Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B65855472C
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357424AbiFVLTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357421AbiFVLTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:19:17 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D6028728;
        Wed, 22 Jun 2022 04:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896691; x=1687432691;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MTnlyo2iHdW3o9QWbyFBSiwA5KoWcP+Jxwe6wW1Mb8M=;
  b=c8uC54EtovDBuhl2JLJTGjnVzYA70ti07Nhfdg53GH9Ywj8myBUs5v4T
   Sy0LokuDLBoanVAtylzokGcVtAwXUAR/fGX6KLDGJmST+IOrgc9rtZTpm
   iK4GhGou/vbiax7GfgwFT9J9qcouXphOSdP5tC9VOhmQP/2RuJQriJNDZ
   JvT6/fogqZjaSw1Ce/iNQ0OarqJolVMPg6vEqblaHvTVTUpsfZDW7OfoC
   Dqslg9d2i42HOyr87YhVQ1PeMuZLodiQHcEjcKOZP3SqtS8rsMDwJqvaq
   Wo6TsuQ1vX6NyiyEQpmZxVXZkNq1W7asj1u85rynNpXj88kHHhodD+P/m
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305841148"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305841148"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302335"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:43 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 18/22] x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
Date:   Wed, 22 Jun 2022 23:17:07 +1200
Message-Id: <2e7d7e7e36e81ec9f13f8c796dee24517169b39c.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the TDX-usable memory regions are constructed in an array of TDMRs
and the global KeyID is reserved, configure them to the TDX module using
TDH.SYS.CONFIG SEAMCALL.  TDH.SYS.CONFIG can only be called once and can
be done on any logical cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 38 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index df87a9f9ee24..06e26379b632 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -18,6 +18,7 @@
 #include <linux/sizes.h>
 #include <linux/memblock.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/align.h>
 #include <linux/sort.h>
 #include <asm/cpufeatures.h>
@@ -932,6 +933,37 @@ static int construct_tdmrs_memeblock(struct tdmr_info *tdmr_array,
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
+				global_keyid, 0, NULL);
+
+	/* Free the array as it is not required any more. */
+	kfree(tdmr_pa_array);
+
+	return ret ? -EFAULT : 0;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -999,11 +1031,17 @@ static int init_tdx_module(void)
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
index 55d6c69ab900..b9bc499b965b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -53,6 +53,7 @@
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
+#define TDH_SYS_CONFIG		45
 
 struct cmr_info {
 	u64	base;
@@ -120,6 +121,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
-- 
2.36.1

