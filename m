Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E51F4D7470
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbiCMKxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiCMKwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A829E4AE1F;
        Sun, 13 Mar 2022 03:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168686; x=1678704686;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9l+LPMkLtqeMSWP1b4SOmyqedQ8aVLN9kIwR5ZjsVQI=;
  b=FPIY3K61Wm18luhGAlMcGtML5U1+CJz/pJI+pPfM1iaov/ABZwJ4Wd5D
   FzJ6SLL1ejjxNAWRa3ZLQb2TdrPm9NlqxS9cxf/6+7bOyy47Fb8jQJ5oI
   uUOAPVhZvZbFMYorxjOI4o1Z6BxqNC3GXW9eowZVudogx9hr7zwHc/Nsq
   XFK6waO/bUo3AksjjSGbRp2BJj1tL118fHWsLZvoiQxvQxIGp3yUTLwms
   ItjT77AN5MHcgIvCoqjzMAb02XbjIyC3/lP3/8s7G24Rk2Qnulod25KZo
   X0xwan0a4hDMEjwV+wcoM+oRQ5BYSz8blTzzc7MMTbuMH04KnGRkgRr2v
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255590723"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255590723"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448251"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:12 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 20/21] x86/virt/tdx: Add kernel command line to opt-in TDX host support
Date:   Sun, 13 Mar 2022 23:50:00 +1300
Message-Id: <97c3539843a2c9cfdfd4a4ba2786be9b76afdd78.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enabling TDX consumes additional memory (used by TDX as metadata) and
additional initialization time.  Introduce a kernel command line to
allow to opt-in TDX host kernel support when user truly wants to use
TDX.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  6 ++++++
 arch/x86/virt/vmx/tdx.c                         | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f5a27f067db9..9f85cafd0c2d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5707,6 +5707,12 @@
 
 	tdfx=		[HW,DRM]
 
+	tdx_host=	[X86-64, TDX]
+			Format: {on|off}
+			on: Enable TDX host kernel support
+			off: Disable TDX host kernel support
+			Default is off.
+
 	test_suspend=	[SUSPEND][,N]
 			Specify "mem" (for Suspend-to-RAM) or "standby" (for
 			standby suspend) or "freeze" (for suspend type freeze)
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index d9ad8dc7111e..2022f9c019b8 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -116,6 +116,16 @@ static struct tdsysinfo_struct tdx_sysinfo;
 /* TDX global KeyID to protect TDX metadata */
 static u32 tdx_global_keyid;
 
+static bool enable_tdx_host;
+
+static int __init tdx_host_setup(char *s)
+{
+	if (!strcmp(s, "on"))
+		enable_tdx_host = true;
+	return 1;
+}
+__setup("tdx_host=", tdx_host_setup);
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -501,6 +511,10 @@ static int detect_p_seamldr(void)
 
 static int __tdx_detect(void)
 {
+	/* Disabled by kernel command line */
+	if (!enable_tdx_host)
+		goto no_tdx_module;
+
 	/* The TDX module is not loaded if SEAMRR is disabled */
 	if (!seamrr_enabled()) {
 		pr_info("SEAMRR not enabled.\n");
-- 
2.35.1

