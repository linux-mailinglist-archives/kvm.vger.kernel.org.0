Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3ED6B6921
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCLR65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbjCLR62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:58:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0C0E5;
        Sun, 12 Mar 2023 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643879; x=1710179879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W9FepXWYyR2uQK2SyZESVB1pZPHNuVq5h+lX9gxTpiw=;
  b=Hkd644AwNqW6+NX5/MTx72toJ/hLaoSl4Fj31QhYNanSJfRO8r6sBhxL
   7wpQfC/vT3b0HJTMEDMu+d9jnGEggfhIDDhNWDRkTwGfKc3ANZcwX3L6C
   M1CjovqoFKkZn0YfDHfmImDKRctNVIhCuXqJPIFI8B5JvKSpFAkjoB2/6
   FJIQ+gslGeQZjDR9t5dEyynoyF8Lq6mGrdUp7tGlv6RNy//4SYes/hxPj
   /dKQGv6Kwyzp65Uekn51iWH9etf/gQFWMj0BWEZQrOpq4nyNqdYZKYKuS
   rr4YyYTwLNEhUmYXLnNfnaUc6ltWh0/NRJWsRrrF0EKjl6wWnd3lo8Rds
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863594"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863594"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396949"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396949"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 014/113] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Sun, 12 Mar 2023 10:55:38 -0700
Message-Id: <c88b3dc84d64f0e73039670acecbbb07dc5c6a54.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/virt/vmx/tdx/tdx.c | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6c01ab572c1f..7d99a48a98cc 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -104,6 +104,16 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 bool platform_tdx_enabled(void);
 int tdx_cpu_enable(void);
 int tdx_enable(void);
+/*
+ * Key id globally used by TDX module: TDX module maps TDR with this TDX global
+ * key id.  TDR includes key id assigned to the TD.  Then TDX module maps other
+ * TD-related pages with the assigned key id.  TDR requires this TDX global key
+ * id for cache flush unlike other TD-related pages.
+ */
+extern u32 tdx_global_keyid __ro_after_init;
+int tdx_guest_keyid_alloc(void);
+void tdx_guest_keyid_free(int keyid);
+
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
@@ -112,6 +122,8 @@ static inline int tdx_cpu_enable(void) { return -EINVAL; }
 static inline int tdx_enable(void)  { return -EINVAL; }
 static inline u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 			     struct tdx_module_output *out) { return TDX_SEAMCALL_UD; };
+static inline int tdx_guest_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_guest_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ee94a7327d93..3251fdf74667 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -33,7 +33,8 @@
 #include <asm/tdx.h>
 #include "tdx.h"
 
-static u32 tdx_global_keyid __ro_after_init;
+u32 tdx_global_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
@@ -138,6 +139,31 @@ static struct notifier_block tdx_memory_nb = {
 	.notifier_call = tdx_memory_notifier,
 };
 
+/* TDX KeyID pool */
+static DEFINE_IDA(tdx_guest_keyid_pool);
+
+int tdx_guest_keyid_alloc(void)
+{
+	if (WARN_ON_ONCE(!tdx_guest_keyid_start || !tdx_nr_guest_keyids))
+		return -EINVAL;
+
+	/* The first keyID is reserved for the global key. */
+	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start + 1,
+			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
+
+void tdx_guest_keyid_free(int keyid)
+{
+	/* keyid = 0 is reserved. */
+	if (WARN_ON_ONCE(keyid <= 0))
+		return;
+
+	ida_free(&tdx_guest_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
+
 static int __init tdx_init(void)
 {
 	u32 tdx_keyid_start, nr_tdx_keyids;
@@ -1218,6 +1244,12 @@ static int init_tdx_module(void)
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
 
-- 
2.25.1

