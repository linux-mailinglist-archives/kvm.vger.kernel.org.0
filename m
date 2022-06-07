Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FFC539731
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347489AbiEaTlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347387AbiEaTlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:41:04 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9E39D06B;
        Tue, 31 May 2022 12:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026050; x=1685562050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uEWAgvM6AJUFCw+XPvgs6kSHjflUwsfX8nA7wzWhL2A=;
  b=kxTdT6qN+O+NdW/1RWQCjMR7Z53PCxAyBNKVhagbnNbdyy0hnXQUy5JA
   KPlqXOctQ5OujL5NXf+8KXaTrxXGa9Oii/mFiiOJwgOX/sLfoNrR2yiz0
   8v7MNENxRN6DdY1QpPFvj+vrOkLo5xf5o6vtCi26ivTTIbpfVpiYSBTxj
   kWwQ8uzj2xVthxaVa/KF99Ddv6wUkaB1wlfXBAqUupb2moxDiV6gqHHA6
   Y8kfLPbyH66smrmWN13/X0XmwfoPNKhO3NZ4fdHGbU8AOvBYC8Ypz7XV3
   5eHf03ezvucZPQhcNKB068KSvajVhmfLwruZjvrd73OstF+RnJJTq7SnT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935085"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935085"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164368"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 09/22] x86/virt/tdx: Detect TDX module by doing module global initialization
Date:   Wed,  1 Jun 2022 07:39:32 +1200
Message-Id: <d5af78e80a538a17752a06a75e0a601cac15714d.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

- v3 -> v4:
 - Add detecting TDX module.

---
 arch/x86/virt/vmx/tdx/tdx.c | 39 +++++++++++++++++++++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8e0fe314eb44..37a5f37dc013 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -186,6 +186,21 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
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
@@ -195,8 +210,28 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
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
2.35.3

