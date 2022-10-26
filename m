Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B58560EC21
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiJZXSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiJZXRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:47 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7F4ACF62;
        Wed, 26 Oct 2022 16:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826254; x=1698362254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AnNqiBNPSUbWaB3MXTzWbDZrRWoVAeYEttaIkn2Vg/8=;
  b=RZLd4VguzbxWyM586ZOm5+vPEOOWS6quCFkxC88ubqWBxvoG5MXUWPZ9
   LEkH0SOcsyIpds7eEXLynJhzQg18Z2Q4Yjs17SY7s3h2eXW62dW8PM2lu
   jOzc/TXoF7muOnA96rYXODmqQngWSEmu3VUJxCd7gIQR+RBhlkYDHJ3R1
   N/e29HGg+xaOVRh5qhlRrYFoLY5Bo+FoFPnwjIb3WIHwR/ZNTb1AGPzn3
   L2XI+YPPfHSjacV+yUt06iPA//iKtWXXe/DZz+QR4M9o8MKY3QjWTyWd3
   Ji1nsS1d/FR/XPKPOdq5Yx20Y/vCQ1QyOHZddCaKnjsaqtUyDd+OFUFv3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175521"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175521"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446322"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446322"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:29 -0700
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
Subject: [PATCH v6 08/21] x86/virt/tdx: Do TDX module global initialization
Date:   Thu, 27 Oct 2022 12:16:07 +1300
Message-Id: <9ec7128604aa5e23542a60c86c74053bb197a722.1666824663.git.kai.huang@intel.com>
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

So far the TDX module hasn't been detected yet.  __seamcall() returns
TDX_SEAMCALL_VMFAILINVALID when the target SEAM software is not loaded.
loaded.  Just use __seamcall() to detect the TDX module.

The first step of initializing the module is to call TDH.SYS.INIT once
on any logical cpu to do module global initialization.  Do the module
global initialization and detect the TDX module.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5246335abe07..68fb9bc201d6 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -351,8 +351,23 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
  */
 static int init_tdx_module(void)
 {
-	/* The TDX module hasn't been detected */
-	return -ENODEV;
+	int ret;
+
+	/*
+	 * Call TDH.SYS.INIT to do the global initialization of
+	 * the TDX module.  It also detects the module.
+	 */
+	ret = seamcall(TDH_SYS_INIT, 0, 0, 0, 0, NULL, NULL);
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
index 215cc1065d78..0b415805c921 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,6 +15,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INIT		33
 #define TDH_SYS_LP_SHUTDOWN	44
 
 /*
-- 
2.37.3

