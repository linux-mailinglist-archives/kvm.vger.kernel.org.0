Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5424D7466
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiCMKwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiCMKv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:51:56 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4684437AA0;
        Sun, 13 Mar 2022 03:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168637; x=1678704637;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EFAqTydulIlOdHgbokdDqDaAGrxegpZWdbGMR3Kq/z0=;
  b=g5h+Dhg1Ms2RpCDsohLe8VSNp6GTX8+QfbNzWdzZT6TIo7oAv8jY775o
   uo9eJu0TNXEq0OWknT3Sye0r660gLUzp7kx51jdX9VM3WP8ScCOPK0mQ7
   6eMl22/97UKT3KDvGnh6snBwwHWGtVobqZzW9RCQEx798gNxtCmk+t432
   SuOyE893F1KdwdNorDBNTAbf7yR30BkvMR3U7YBfhoLlanN331jFygfnf
   cFS1DCQ6QKtth7Wvuf94b9sefg2DkP61p7jX5sVBxB9PEw7gUvye9xnrS
   6sX61yasloiGvgKAlHvTMZaawibyNbAIOwV6LEJ5SZY5Yf3RJML5rtOoU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="254689533"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="254689533"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:36 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448125"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:33 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 08/21] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Sun, 13 Mar 2022 23:49:48 +1300
Message-Id: <cbfadff812dd3e25a485b867025cde4ba39d16f1.1647167475.git.kai.huang@intel.com>
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

Logical-cpu scope initialization requires calling TDH.SYS.LP.INIT on all
BIOS-enabled cpus, otherwise the TDH.SYS.CONFIG SEAMCALL will fail.
TDH.SYS.LP.INIT can be called concurrently on all cpus.

Following global initialization, do the logical-cpu scope initialization
by calling TDH.SYS.LP.INIT on all online cpus.  Whether all BIOS-enabled
cpus are online is not checked here for simplicity.  The user of TDX
should guarantee all BIOS-enabled cpus are online.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 12 ++++++++++++
 arch/x86/virt/vmx/tdx.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 45e7404b5d81..4b0c285d844b 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -461,6 +461,13 @@ static int __tdx_detect(void)
 	return -ENODEV;
 }
 
+static int tdx_module_init_cpus(void)
+{
+	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_INIT };
+
+	return seamcall_on_each_cpu(&sc);
+}
+
 static int init_tdx_module(void)
 {
 	int ret;
@@ -470,6 +477,11 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Logical-cpu scope initialization */
+	ret = tdx_module_init_cpus();
+	if (ret)
+		goto out;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index f0983b1936d8..b8cfdd6e12f3 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -39,6 +39,7 @@ struct p_seamldr_info {
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
 
 struct tdx_module_output;
-- 
2.35.1

