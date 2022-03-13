Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD224D7458
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiCMKwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiCMKvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:51:43 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B2436324;
        Sun, 13 Mar 2022 03:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168633; x=1678704633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1/CFhMw+zoD/9IrIuLin35o8R0ap4GLkb9GXsqkEG84=;
  b=aDewddJqVCRAQ1ssP5t3bkSEeBCDJrRwr1k9tZ0mkjJko4R7PD7Z61Iw
   NdwQ04Ia6vf+9ISjef6Zzyix9T2zp4h5uqROgB9b8pfYoIXSJWJIO9E4C
   dtbAdTWkU9hREp8OU73CdxbJEr0hUymTMG6K2GMcQwep3mIknrHnrGg0U
   efH5yCsVM6u7i5dElWe0MWX+RLC8Wgn3S0JgtpdSKp8HVd7Q56xu1RIj9
   /cQMIp7mGrLoJafktzu5UPKLKP25mAymL5DQEBLW402eClZ2nOr6txDaq
   TODTTBciplt1MUrnQ2OHyaa42alCe+HaXxITPzXY9RMYfBkr2kPAb2qeL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255810449"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255810449"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:33 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448109"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:29 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 07/21] x86/virt/tdx: Do TDX module global initialization
Date:   Sun, 13 Mar 2022 23:49:47 +1300
Message-Id: <35c2921238bab117fea6ce6feb8604e83750ac39.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do the TDX module global initialization which requires calling
TDH.SYS.INIT once on any logical cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 11 ++++++++++-
 arch/x86/virt/vmx/tdx.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index d87af534db51..45e7404b5d81 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -463,11 +463,20 @@ static int __tdx_detect(void)
 
 static int init_tdx_module(void)
 {
+	int ret;
+
+	/* TDX module global initialization */
+	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
+	if (ret)
+		goto out;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
 	 */
-	return -EFAULT;
+	ret = -EFAULT;
+out:
+	return ret;
 }
 
 static void shutdown_tdx_module(void)
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index dcc1f6dfe378..f0983b1936d8 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -38,6 +38,7 @@ struct p_seamldr_info {
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INIT		33
 #define TDH_SYS_LP_SHUTDOWN	44
 
 struct tdx_module_output;
-- 
2.35.1

