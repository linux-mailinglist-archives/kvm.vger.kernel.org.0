Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4357A7CB0D0
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbjJPQ7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbjJPQ72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:59:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958686A41;
        Mon, 16 Oct 2023 09:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473314; x=1729009314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1xSP6uanUKdg9rgP66c0/W4OhGgvmt147mwn/SU8AmY=;
  b=TdwWbOU9WWr4JweXw11t/4FisilNl17voAQTzK5cqCdyb8H76QQtFv7M
   UbvB3+oI+0W7VV5tFtKyVYRuUAyg7cjr0K6B4GP57ZW9Js6++caqeqINA
   uoDRXmbutpjuklEj/9hkqDXdaZhy+jkWLcMdGZb7qxulZCGe+Pnsl69BT
   2l2t4KSwlZoPmw0qyLa0jzmNZyl7WznYX+7G0ykG8ZVfV5nTXeg9f/L4H
   YbOT33qdWM2e/TlMxJkTHPfxa271auS15vhwOn/HpQWovSJVtzoD39c03
   XngMS5dh0Didyf2SH2iLa8oiX9vW+MUq3h3BE+mMdvRWKYEiaazc2Vazd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825934"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825934"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126010"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126010"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:27 -0700
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
Subject: [PATCH v16 015/116] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Mon, 16 Oct 2023 09:13:27 -0700
Message-Id: <9bbcc2c3d24bbebfc7fd50bb686fc9e1f3f0591b.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/tdx.h  | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index ec2b8e67fe07..e50129a1f13e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -115,6 +115,16 @@ int tdx_cpu_enable(void);
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
+extern u32 tdx_global_keyid;
+int tdx_guest_keyid_alloc(void);
+void tdx_guest_keyid_free(int keyid);
 #else
 static inline u64 __seamcall(u64 fn, struct tdx_module_args *args)
 {
@@ -133,6 +143,8 @@ static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
 static inline void tdx_reset_memory(void) { }
 static inline bool tdx_is_private_mem(unsigned long phys) { return false; }
+static inline int tdx_guest_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_guest_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 04b3c81b35e5..5b8f2085d293 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -118,7 +118,8 @@ static __always_inline bool seamcall_err_is_kernel_defined(u64 err)
 	SEAMCALL_PRERR(seamcall_saved_ret, (__fn), (__args),			\
 			seamcall_err_saved_ret)
 
-static u32 tdx_global_keyid __ro_after_init;
+u32 tdx_global_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
@@ -136,6 +137,31 @@ static struct tdmr_info_list tdx_tdmr_list;
 
 static atomic_t tdx_may_have_private_mem;
 
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
  * Do the module global initialization if not done yet.  It can be
  * done on any cpu.  It's always called with interrupts disabled.
-- 
2.25.1

