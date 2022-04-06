Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CBF4F6196
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiDFO1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 10:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbiDFO05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 10:26:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04BD44E5BC;
        Tue,  5 Apr 2022 21:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220617; x=1680756617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JEHzGZUx8hYUK4MYh5P32wAhLE7c3yWf9l91nEbGSFw=;
  b=VfzPQ2LaG8In1grZPBDmwZMfcosuYwV7ocloc3lEh1gNYlgbOLRP91m9
   jH6ArEYOfTQw6MRHSJT791QwaPW5Ebgy8IPE7/UgOLVmzTZSDhcozy/YV
   nhyOHo1EDr7MEf06olGtNSaIbvnSV3vsQ9C0z5rKWW/cKsifIzkz6QWys
   oNGt2QYMn/v8+bzHcPZ5tgVezUUW7AxmjT/TfjEECa+ZfBuZU5hZxUlCd
   qeD1wIeLe6EAeyx+hhEMvdpgABLI4AJtU8aTWf5v+lJyfGw4drpvm7yGW
   hoJFzdbzOSR39jUJI7x5Cin0ep+m4PSEs7OkJTbvs7HX6jIIqdeddqyHV
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089819"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089819"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302280"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:12 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 08/21] x86/virt/tdx: Do logical-cpu scope TDX module initialization
Date:   Wed,  6 Apr 2022 16:49:20 +1200
Message-Id: <35081dba60ef61c313c2d7334815247248b8d1da.1649219184.git.kai.huang@intel.com>
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

Logical-cpu scope initialization requires calling TDH.SYS.LP.INIT on all
BIOS-enabled cpus, otherwise the TDH.SYS.CONFIG SEAMCALL will fail.
TDH.SYS.LP.INIT can be called concurrently on all cpus.

Following global initialization, do the logical-cpu scope initialization
by calling TDH.SYS.LP.INIT on all online cpus.  Whether all BIOS-enabled
cpus are online is not checked here for simplicity.  The caller of
tdx_init() should guarantee all BIOS-enabled cpus are online.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5c2f3a30be2f..ef2718423f0f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index f0983b1936d8..b8cfdd6e12f3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -39,6 +39,7 @@ struct p_seamldr_info {
  * TDX module SEAMCALL leaf functions
  */
 #define TDH_SYS_INIT		33
+#define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
 
 struct tdx_module_output;
-- 
2.35.1

