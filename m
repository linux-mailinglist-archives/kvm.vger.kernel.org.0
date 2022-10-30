Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38186127DD
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiJ3GZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJ3GYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44D6D8;
        Sat, 29 Oct 2022 23:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111043; x=1698647043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c3by2T16lzjQJuySZXCKjj7l+xnufSG16l0hxS0c+aE=;
  b=Fuzv+ajVo81/Z4+iMCpSWCflVcPzwIBayhJYgEhvGmtn+P7UD0zkGt2+
   a72tW1qrysTojRd7z87WDEfhvIheMjFOB2QgC9ZrrmpdIva9efv3jey0N
   s+j0MMWd4Z2EnLPdAgjt+KMmzOebU86wws8G4mseXoQ+u748i1+xPs408
   W+dHOFVqddoUUEBLyoCSflHQ7MVXaA7JfzjETs+1Shk2SwYRMb26wI7DD
   zNB4mRsfA/2liqoqWJBye+OptCx/fmadFvKIHs1Y5Ds8bz+Sc1P+U3ANa
   8MerpF0zAsuFjrUvK+7ggNT/cZmB+1SLDV99+OZxv7zXVuSP/2Rp4wPkp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037127"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037127"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:59 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392876"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392876"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 015/108] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Sat, 29 Oct 2022 23:22:16 -0700
Message-Id: <5ee7c6dc4ba03b5d5166e015c148ef534ee53f8e.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX private host key id is assigned to guest TD.  The memory controller
encrypts guest TD memory with the assigned TDX private host key id (HIKD).
Add helper functions to allocate/free TDX private host key id so that TDX
KVM manage it.

Also export the global TDX private host key id that is used to encrypt TDX
module, its memory and some dynamic data (TDR).  When VMM releasing
encrypted page to reuse it, the page needs to be flushed with the used host
key id.  VMM needs the global TDX private host key id to flush such pages
TDX module accesses with the global TDX private host key id.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 13 +++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index ba2e4c69fb9f..cd304d323d33 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -186,6 +186,17 @@ struct tdsysinfo_struct {
 const struct tdsysinfo_struct *tdx_get_sysinfo(void);
 bool platform_tdx_enabled(void);
 int tdx_enable(void);
+
+/*
+ * Key id globally used by TDX module: TDX module maps TDR with this TDX global
+ * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
+ * TD-related pages with the assigned key id.  TDR requires this TDX global key
+ * id for cache flush unlike other TD-related pages.
+ */
+extern u32 tdx_global_keyid __read_mostly;
+int tdx_keyid_alloc(void);
+void tdx_keyid_free(int keyid);
+
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
@@ -193,6 +204,8 @@ struct tdsysinfo_struct;
 static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_enable(void)  { return -ENODEV; }
+static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 6fb630fa7d09..0625ced219d7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -64,7 +64,8 @@ static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMEN
 static int tdx_cmr_num;
 
 /* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
-static u32 tdx_global_keyid;
+u32 tdx_global_keyid __read_mostly;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 
 /*
  * Detect TDX private KeyIDs to see whether TDX has been enabled by the
@@ -113,6 +114,31 @@ static void __init clear_tdx(void)
 	tdx_keyid_start = tdx_keyid_num = 0;
 }
 
+/* TDX KeyID pool */
+static DEFINE_IDA(tdx_keyid_pool);
+
+int tdx_keyid_alloc(void)
+{
+	if (WARN_ON_ONCE(!tdx_keyid_start || !tdx_keyid_num))
+		return -EINVAL;
+
+	/* The first keyID is reserved for the global key. */
+	return ida_alloc_range(&tdx_keyid_pool, tdx_keyid_start + 1,
+			       tdx_keyid_start + tdx_keyid_num - 1,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
+
+void tdx_keyid_free(int keyid)
+{
+	/* keyid = 0 is reserved. */
+	if (!keyid || keyid <= 0)
+		return;
+
+	ida_free(&tdx_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_free);
+
 static void __init tdx_memory_destroy(void)
 {
 	while (!list_empty(&tdx_memlist)) {
-- 
2.25.1

