Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE884F5BAA
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242337AbiDFJcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 05:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344855AbiDFJZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 05:25:34 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791CE16249D;
        Tue,  5 Apr 2022 21:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220656; x=1680756656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iC68qSmiZTNL7Prs9cAoa+JCPh9pm5fBnRuabYf0ICw=;
  b=b60JoccvlOMWt730h5IrjAiZrGKl+Sek7aldvGAslijwCsXQKA+HVBhN
   NhoYRGdJAMUQMg37Mrdy1K2Myj7YJTkjeQv1y+sONXZMrVGhXgMOSbKY/
   x3HGW1KzeWj8hedszNg2NDITcAEDFqoilmFZBXSwYPxe4SebpAUCSvuN7
   hATxNWi3eyyVuSf+a4HDtLM8JqdThDP/9lq5Fe/OtKmxAh9tPsxy3KYnM
   Zvo+/RZckXfZ+gMqWuTjlgZjgIYaFPi/UX3pJNb5AZ6Z8Er8jmPfRPvRQ
   mOrvIw7XXWOtsuZo0ABOQ5ns6hCbs6eFrwfU345GsqXO5vPbgznDF8RCo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089887"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089887"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:48 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302447"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:44 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 16/21] x86/virt/tdx: Configure TDX module with TDMRs and global KeyID
Date:   Wed,  6 Apr 2022 16:49:28 +1200
Message-Id: <9cbb09c01bc145c580c084b4fc27c54ada771e72.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the TDX usable memory regions are constructed in an array of TDMRs
and the global KeyID is reserved, configure them to the TDX module.  The
configuration is done via TDH.SYS.CONFIG, which is one call and can be
done on any logical cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 42 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ecd65f7014e2..2bf49d3d7cfe 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1284,6 +1284,42 @@ static int construct_tdmrs(struct tdmr_info **tdmr_array, int *tdmr_num)
 	return ret;
 }
 
+static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
+			     u64 global_keyid)
+{
+	u64 *tdmr_pa_array;
+	int i, array_sz;
+	int ret;
+
+	/*
+	 * TDMR_INFO entries are configured to the TDX module via an
+	 * array of the physical address of each TDMR_INFO.  TDX requires
+	 * the array itself must be 512 aligned.  Round up the array size
+	 * to 512 aligned so the buffer allocated by kzalloc() meets the
+	 * alignment requirement.
+	 */
+	array_sz = ALIGN(tdmr_num * sizeof(u64), TDMR_INFO_PA_ARRAY_ALIGNMENT);
+	tdmr_pa_array = kzalloc(array_sz, GFP_KERNEL);
+	if (!tdmr_pa_array)
+		return -ENOMEM;
+
+	for (i = 0; i < tdmr_num; i++)
+		tdmr_pa_array[i] = __pa(tdmr_array[i]);
+
+	/*
+	 * TDH.SYS.CONFIG fails when TDH.SYS.LP.INIT is not done on all
+	 * BIOS-enabled cpus.  tdx_init() only disables CPU hotplug but
+	 * doesn't do early check whether all BIOS-enabled cpus are
+	 * online, so TDH.SYS.CONFIG can fail here.
+	 */
+	ret = seamcall(TDH_SYS_CONFIG, __pa(tdmr_pa_array), tdmr_num,
+				global_keyid, 0, NULL, NULL);
+	/* Free the array as it is not required any more. */
+	kfree(tdmr_pa_array);
+
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	struct tdmr_info **tdmr_array;
@@ -1329,11 +1365,17 @@ static int init_tdx_module(void)
 	 */
 	tdx_global_keyid = tdx_keyid_start;
 
+	/* Config the TDX module with TDMRs and global KeyID */
+	ret = config_tdx_module(tdmr_array, tdmr_num, tdx_global_keyid);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
 	 */
 	ret = -EFAULT;
+out_free_pamts:
 	/*
 	 * Free PAMTs allocated in construct_tdmrs() when TDX module
 	 * initialization fails.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 05bf9fe6bd00..d8e2800397af 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -95,6 +95,7 @@ struct tdmr_reserved_area {
 } __packed;
 
 #define TDMR_INFO_ALIGNMENT	512
+#define TDMR_INFO_PA_ARRAY_ALIGNMENT	512
 
 struct tdmr_info {
 	u64 base;
@@ -125,6 +126,7 @@ struct tdmr_info {
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
+#define TDH_SYS_CONFIG		45
 
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-- 
2.35.1

