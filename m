Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63B4C60E5
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiB1CPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiB1CPc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:32 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB09E527EF;
        Sun, 27 Feb 2022 18:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014495; x=1677550495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KCebEsUOr3JNBClpva5gMOxkilzblBWkeHW/AoIsJDM=;
  b=mxfoZTTV7sDP5hG6Iu8Y/+bTS7rxKeTbMuTkjJBHUkdZ8uSpJGr04Q/B
   6Q+Cpk8UwAHx1A/AnRN50e2RzerZ3zznxB9L+Dy/gfxAbQVaxCOvSrwI3
   Ki15W9Tt4CFXiPPMMHw1QDT3tI2TH/XI+OFXYeVinMQABQIyAQFDK3RTF
   E/U9KTmMDR+Oh9ymzQeFSrOloYa/zpHjVXKGKvT9Kcpm5D0wuq1kg29V9
   zuRvHW4I2D3FMjKxb6GdQ7FJNhxWD6/iNwqyt+DPzFi54pr1psgWUXgvs
   d7Yf0jR6eWCm4aCaqpeAbTZY7C0GIDm//wI5stPsh2vHWcVXbZi2USsKG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191919"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191919"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936917"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:13 -0800
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
Subject: [RFC PATCH 08/21] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Mon, 28 Feb 2022 15:12:56 +1300
Message-Id: <3e36f9d3a3b98d6273c296aa17cd0105a27d44ab.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 197c721d5388..c9de3d6f903d 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -462,6 +462,13 @@ static int __tdx_detect(void)
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
@@ -471,6 +478,11 @@ static int init_tdx_module(void)
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
2.33.1

