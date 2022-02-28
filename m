Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096924C6102
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiB1CQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiB1CQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:16:11 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFD26E574;
        Sun, 27 Feb 2022 18:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014510; x=1677550510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MG7YwQYNhM95znuG+4mcnHJ5sWVxwUkOe5978DG+uVE=;
  b=fMsSaFDyH/wNprUn0qvPWqSaxFsGPePtk2IdzyPSawaB2ydcZgY4fg/e
   8ueav75iWPhZNPhW0Ikc+Tm1lkoOCfBO0l/o6yKRZZnkKY3Zx8JCQn63w
   gzNttv6/IpOgUhVMd9QOa7txMPlw1ZxbXAHc4pDCt2hYBEWv6frKB/J8c
   BOCkazO2GrX+Z+yETDKEks/jKO+YYOZ8EN5Y+x0/jcwBLBOI7Sv1BaWOm
   Q8yW7MJmPkAODn4Yfd3zDTUo3/ZZfa9UzVqd3ZCAzRn9AW8s8Nk9OT2Wn
   T4V1yZitV1ggA0MXNZNSGnSi+dVHLhA6b1ibkzu8DwDpdf3yIOmLgdXjp
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="313500618"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="313500618"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:15:10 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777937068"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:15:05 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 20/21] x86/virt/tdx: Add kernel command line to opt-in TDX host support
Date:   Mon, 28 Feb 2022 15:13:08 +1300
Message-Id: <25473dbb7c2f70bdef8a7361f5131b5266e4be95.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index f704fddc9dfc..60d58b2daabd 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -115,6 +115,16 @@ static struct tdsysinfo_struct tdx_sysinfo;
 /* TDX global KeyID to protect TDX metadata */
 static u32 tdx_global_keyid;
 
+static bool enable_tdx_host;
+
+static int __init tdx_host_setup(char *s)
+{
+	if (!strcmp(s, "on"))
+		enable_tdx_host = true;
+	return 0;
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
 	/*
 	 * TDX module cannot be possibly loaded if SEAMRR is disabled.
 	 * Also do not report TDX module as loaded if there's no enough
-- 
2.33.1

