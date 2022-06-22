Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFA85546D1
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357373AbiFVLRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357396AbiFVLRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:17:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5863C736;
        Wed, 22 Jun 2022 04:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896628; x=1687432628;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AQ+lrHitEV8+b6N1UB3Rz8HQXBcp9HIoxbqfRTWJ56w=;
  b=afAakwIkQSYZvhGheI+E9H/d9pPY/jdMIhrO7Fhf+wFsPxcetVMPStCk
   aE/BKHB8ptUGXSeSBJxNOWeGrB3CkdtzMc4wuqCP5L2G4/qexJ46UQeXt
   OOLAzTTrHSFEfT924TYNoRCeNTXkfj/iZ8ktahRFqIqH//zIGPNEIUnXv
   gnD3jNDRCR+bzFJ0sTqnqfVwS36W/+rFyCu949UA/6if5W+UW2DS0LKFA
   8IJwwvPFVGbdxkddCgv6Shr0ZyEltBvpj0UTCkzlIv06PHBXQox5a9UZB
   XBoInMXLy3ZvcKjDXnPbxQRurlqMScxOXhbrObSy3UGkdd6mmYSLouRo2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="344380030"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="344380030"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="834065780"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:04 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 09/22] x86/virt/tdx: Detect TDX module by doing module global initialization
Date:   Wed, 22 Jun 2022 23:16:32 +1200
Message-Id: <168253372035629fda418628af278a1c3044cda6.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far the TDX module hasn't been detected yet.  __seamcall() returns
TDX_SEAMCALL_VMFAILINVALID when the target SEAM software module is not
loaded.  Just use __seamcall() to the TDX module to detect the TDX
module.

The first step of initializing the module is to call TDH.SYS.INIT once
on any logical cpu to do module global initialization.  Just use it to
detect the module since it needs to be done anyway.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v5 (no feedback on v4):
 - Add detecting TDX module.

---
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 31ce4522100a..de4efc16ed45 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -180,6 +180,21 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
 	on_each_cpu(seamcall_smp_call_function, sc, true);
 }
 
+/*
+ * Do TDX module global initialization.  It also detects whether the
+ * module has been loaded or not.
+ */
+static int tdx_module_init_global(void)
+{
+	u64 ret;
+
+	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL);
+	if (ret == TDX_SEAMCALL_VMFAILINVALID)
+		return -ENODEV;
+
+	return ret ? -EFAULT : 0;
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -189,8 +204,28 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
  */
 static int init_tdx_module(void)
 {
-	/* The TDX module hasn't been detected */
-	return -ENODEV;
+	int ret;
+
+	/*
+	 * Whether the TDX module is loaded is still unknown.  SEAMCALL
+	 * instruction fails with VMfailInvalid if the target SEAM
+	 * software module is not loaded, so it can be used to detect the
+	 * module.
+	 *
+	 * The first step of initializing the TDX module is module global
+	 * initialization.  Just use it to detect the module.
+	 */
+	ret = tdx_module_init_global();
+	if (ret)
+		goto out;
+
+	/*
+	 * Return -EINVAL until all steps of TDX module initialization
+	 * process are done.
+	 */
+	ret = -EINVAL;
+out:
+	return ret;
 }
 
 static void shutdown_tdx_module(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 95d4eb884134..9e694789eb91 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -49,6 +49,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INIT		33
 #define TDH_SYS_LP_SHUTDOWN	44
 
 /*
-- 
2.36.1

