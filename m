Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9774F5748
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 10:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385845AbiDFHYU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 03:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456892AbiDFGor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 02:44:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A15D39B1;
        Tue,  5 Apr 2022 21:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220664; x=1680756664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9gK6ukJipXBNl/xV9In8MOBFfm49FnqwURztoNRxISs=;
  b=WgP5884SOAmV69zoKxAFLYLOdoAGQ0pcE1NwgB2kX6cP47lqv1jDRCai
   gBt0LyaecNdTGwBKhA+PuIlRpnXcsrhl8KstAdL7+sY57hfjYdZXDHCG5
   NmeZIDLITW/iz6dj/h0iUiaW1HmvAubv+l+Lx54QAN3LB5Sv1LFj7KhP6
   ABtmoQOrTz9ZTrxEM2DP+2wjobVZweSUlmFFaXQIF0SDD+lYuxOvdvoGA
   Yo4rrMH1fqdJoS2wH5MiwNkMnrz548rJmcMceKG1q3jr5+ybeEOphjRFQ
   XQ19NO+6PIp1f/cEuuxVWv1U6oTdm61vFHi6HKnYZpc4T870DAnoqgoVr
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089923"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089923"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:51:03 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302499"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:51:00 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 20/21] x86/virt/tdx: Add kernel command line to opt-in TDX host support
Date:   Wed,  6 Apr 2022 16:49:32 +1200
Message-Id: <0d50d13e5f9bd590ee97ff150f1393c4d99a8fa0.1649219184.git.kai.huang@intel.com>
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

Enabling TDX consumes additional memory (used by TDX as metadata) and
additional initialization time.  Introduce a kernel command line to
allow to opt-in TDX host kernel support when user truly wants to use
TDX.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  6 ++++++
 arch/x86/virt/vmx/tdx/tdx.c                     | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3f1cc5e317ed..cfa5b36890ea 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5790,6 +5790,12 @@
 
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 031af7b83cea..fee243cd454f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
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
@@ -500,6 +510,10 @@ static int detect_p_seamldr(void)
 
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

