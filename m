Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA9A4F6272
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiDFPBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiDFPAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:00:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056B244E5B5;
        Tue,  5 Apr 2022 21:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220614; x=1680756614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O4RpktnBj9oVWn2CFbXTXcz/tlOO8+KU7JX2IGLZkdk=;
  b=OVxoHrrB/UA4r2ZyfLnBp3dh8Wf+03/GvILywONRdaQc46jp7zjq10qj
   vCBEUJ2t4whjN5vmVv/1Pho+M9T96IK9T3lEAQH1tliKR+VLKtqbAatqs
   A3okzqvoLLo8aom4LPi7uE9+F3bAzFiU4hHM9uj/B6EoUCGZEMMexJYC5
   4qDZsqLJherYOWalNQbYw/NekdAZ57EXpSitc7Swo/1v1wZh5SSgRKSsL
   Oyzt70lpGPM78DiGITZPqbztXS916eoP0iVRh0Xna5gWdINmbOvjlBVsN
   lXDawFkfW+rP6u0akiBDNI7dJSZ0j0+3HY93pxaHILrFkz3+DYDCyM99n
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089809"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089809"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:12 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302246"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:09 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 07/21] x86/virt/tdx: Do TDX module global initialization
Date:   Wed,  6 Apr 2022 16:49:19 +1200
Message-Id: <66e6aa1dc1bade544b81120d7976cb0601f0528b.1649219184.git.kai.huang@intel.com>
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

Do the TDX module global initialization which requires calling
TDH.SYS.INIT once on any logical cpu.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index faf8355965a5..5c2f3a30be2f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index dcc1f6dfe378..f0983b1936d8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -38,6 +38,7 @@ struct p_seamldr_info {
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INIT		33
 #define TDH_SYS_LP_SHUTDOWN	44
 
 struct tdx_module_output;
-- 
2.35.1

