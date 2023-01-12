Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6AE667B4F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240645AbjALQlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbjALQhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:33 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B723140FA;
        Thu, 12 Jan 2023 08:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541233; x=1705077233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IrMgL5L0+5vJWFAChbo9zwiHS6DM3k7Plua0iODYg10=;
  b=QUKiHJ8WT6yLWoVp4lYfgZucIDQhDhZu/c1dy7Cz0XgFs0np4wqUPxpD
   y3UVtfqYD8SxbkEzono2v/7iJ7xokhLpVewllGXop3E3yllKaEo8NxUgZ
   P31Zza8c8tmGS6eR12E76K+HogqzuMNfJnLLVhfJqGfDXnL8dFYY5aTGZ
   vjJCsjiqgwhco4tv7bTOODJtXXs7aK/HsbSIJ2rVrAcTiwP+i5cdKe/Rj
   NHhX1FThj+X/0dihqP0ziObvNu80AAxObSsV5O6ALD7VEGVE8D3N0i3Zs
   i89FFWVvlFuHOSO40+1A9eDiwfsKvulrZs48/ZOMl6llh/439Xc+mlyPK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811699"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811699"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151666"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151666"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 013/113] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Thu, 12 Jan 2023 08:31:21 -0800
Message-Id: <241994f1f6782753f3307fe999a3dad434477c16.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX private host key id (HKID) is assigned to guest TD.  The memory
controller encrypts guest TD memory with the assigned TDX HKID.  Add helper
functions to allocate/free TDX private HKID so that TDX KVM can manage it.

Also export the global TDX private HKID that is used to encrypt TDX module,
its memory and some dynamic data (TDR).  When VMM releasing encrypted page
to reuse it, the page needs to be flushed with the used HKID.  VMM needs
the global TDX private HKID to flush such pages.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0f71d3856ede..ed9cf61ff8b4 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -107,11 +107,23 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #ifdef CONFIG_INTEL_TDX_HOST
 bool platform_tdx_enabled(void);
 int tdx_enable(void);
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
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_enable(void)  { return -EINVAL; }
+static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index eba7e62cebec..d18ab5c4d447 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -51,6 +51,10 @@ static DEFINE_MUTEX(tdx_module_lock);
 /* All TDX-usable memory regions */
 static LIST_HEAD(tdx_memlist);
 
+/* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
+u32 tdx_global_keyid __read_mostly;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
+
 /*
  * tdx_keyid_start and nr_tdx_keyids indicate that TDX is uninitialized.
  * This is used in TDX initialization error paths to take it from
@@ -132,6 +136,31 @@ static struct notifier_block tdx_memory_nb = {
 	.notifier_call = tdx_memory_notifier,
 };
 
+/* TDX KeyID pool */
+static DEFINE_IDA(tdx_keyid_pool);
+
+int tdx_keyid_alloc(void)
+{
+	if (WARN_ON_ONCE(!tdx_keyid_start || !nr_tdx_keyids))
+		return -EINVAL;
+
+	/* The first keyID is reserved for the global key. */
+	return ida_alloc_range(&tdx_keyid_pool, tdx_keyid_start + 1,
+			       tdx_keyid_start + nr_tdx_keyids - 1,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
+
+void tdx_keyid_free(int keyid)
+{
+	/* keyid = 0 is reserved. */
+	if (WARN_ON_ONCE(keyid <= 0))
+		return;
+
+	ida_free(&tdx_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_free);
+
 static int __init tdx_init(void)
 {
 	int err;
@@ -1161,6 +1190,12 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
+	/*
+	 * Reserve the first TDX KeyID as global KeyID to protect
+	 * TDX module metadata.
+	 */
+	tdx_global_keyid = tdx_keyid_start;
+
 	/* Initialize TDMRs to complete the TDX module initialization */
 	ret = init_tdmrs(&tdmr_list);
 	if (ret)
-- 
2.25.1

