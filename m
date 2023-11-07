Return-Path: <kvm+bounces-909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FEA7E4257
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FC6A2811A2
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A774034CDE;
	Tue,  7 Nov 2023 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSAZPGJI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1CA321AE
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:57:53 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4019C11A;
	Tue,  7 Nov 2023 06:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369072; x=1730905072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=79uI0n9y/4+6M74yd/YjpS6ZJfrnUAhmwow37sswjSM=;
  b=hSAZPGJI9M/tjsmGHrOye9i/qx49bGGVX+kunwYji0SgRjLH/X9ULoLe
   Nhg0B4UatN3Fj8+njKHLZImOn0GWpkMs9DKn0TNR1T8DuP9Om3TV5wV7s
   D8GprqtC4Xn53JpUBvWihqF5tfPUQqBkMDoRt0oQ20eE2Qcmf217kT1GU
   sN1bFjyo/w+g4DPOyMwrEtj7i4/r2/+Rnb3GmnPOxBL8WxQAI0+AbPCxV
   h4vm+oa0gFT1bBcIe28YYfPLEdsEVDQHMjuDDxqZZy88EmfNONNllXdhK
   OecPAOBubg90gguSitd1gynBLBM0HYOF7cfh9CMGdh+HeRrY9yumQ4q5p
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555764"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555764"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10444036"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:50 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 015/116] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date: Tue,  7 Nov 2023 06:55:41 -0800
Message-Id: <69281f4f2e4d2c3c906518d83bc6ec9c0debda16.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index b7cfdf084860..3b648f290af3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -114,6 +114,16 @@ int tdx_cpu_enable(void);
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
@@ -132,6 +142,8 @@ static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
 static inline void tdx_reset_memory(void) { }
 static inline bool tdx_is_private_mem(unsigned long phys) { return false; }
+static inline int tdx_guest_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_guest_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 38ec6815a42a..c01cbfc81fbb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -37,7 +37,8 @@
 #include <asm/tdx.h>
 #include "tdx.h"
 
-static u32 tdx_global_keyid __ro_after_init;
+u32 tdx_global_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
@@ -105,6 +106,31 @@ static inline int sc_retry_prerr(sc_func_t func, sc_err_func_t err_func,
 #define seamcall_prerr_ret(__fn, __args)					\
 	sc_retry_prerr(__seamcall_ret, seamcall_err_ret, (__fn), (__args))
 
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
  * Do the module global initialization once and return its result.
  * It can be done on any cpu.  It's always called with interrupts
-- 
2.25.1


