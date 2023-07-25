Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B686E7625E3
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbjGYWQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231422AbjGYWPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9574C173B;
        Tue, 25 Jul 2023 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323341; x=1721859341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QLI5gFKdIox5w0Oi+9+VH1yeFL7uGsPBS1/CMUHOHKo=;
  b=jcizGMC53ibHQ5tOzaPQ4pmXDc5bZjZRWCwHaviJtBJpjeP52XPDD4Yr
   mxyHmMAXkwXtFAQ9qc2dxGwOA4Hm012V7JGoRemHz3/5v5BdxM/Z30FXH
   RICgqwQPieqMvsCbYzC0axgjmf7yOzwbQ9FQLRVOSB/ekrFv/esX2y9cb
   asNXg12NyqI6CmAwRpBlswfe8ee+sXlIASdYHuU7iMzJGocrMSkIgTiTI
   BfXdBUyc6gmqp9pFKSVw5P88w9aDTDDNqPT8Arf9yU5utwbGy+pS5H2eG
   JrkEmkV3E7tNJQdZZOSOpolidU17X61pVOiND9Jo0Vr14HXN8BRZTCilZ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863104"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863104"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938814"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938814"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:21 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 015/115] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Tue, 25 Jul 2023 15:13:26 -0700
Message-Id: <a5d8e804a95641772e6f705c7be157dfdb7986ad.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to allocate/free TDX private host key id (HKID), and
export the global TDX HKID.

The memory controller encrypts TDX memory with the assigned TDX HKIDs.  The
global TDX HKID is to encrypt the TDX module, its memory, and some dynamic
data (TDR).  The private TDX HKID is assigned to guest TD to encrypt guest
memory and the related data.  When VMM releases an encrypted page for
reuse, the page needs a cache flush with the used HKID.  VMM needs the
global TDX HKID and the private TDX HKIDs to flush encrypted pages.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 13 +++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index bf5324b5ea01..245c0c93cf71 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -90,6 +90,17 @@ int tdx_cpu_enable(void);
 int tdx_enable(void);
 void tdx_reset_memory(void);
 bool tdx_is_private_mem(unsigned long phys);
+
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
@@ -100,6 +111,8 @@ static inline void tdx_reset_memory(void) { }
 static inline bool tdx_is_private_mem(unsigned long phys) { return false; }
 static inline u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 			     struct tdx_module_output *out) { return TDX_SEAMCALL_UD; };
+static inline int tdx_guest_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_guest_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5f96c2d866e5..ef3a1d9dcf2f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -35,7 +35,8 @@
 #include <asm/tdx.h>
 #include "tdx.h"
 
-static u32 tdx_global_keyid __ro_after_init;
+u32 tdx_global_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
@@ -53,6 +54,31 @@ static struct tdmr_info_list tdx_tdmr_list;
 
 static atomic_t tdx_may_has_private_mem;
 
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
 /*
  * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
  * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
-- 
2.25.1

