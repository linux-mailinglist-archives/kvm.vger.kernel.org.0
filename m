Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B5158BD47
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbiHGWDX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiHGWCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5073464C2;
        Sun,  7 Aug 2022 15:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909756; x=1691445756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=geG5IFdM92uMkCmaqJr+2phpNb7HquNXFEIpPDeaO4s=;
  b=SV/kZNCDn01Cija0lYzBdfcdbHY0YMSHJ9fuvhZQzoKwMmwQTxXLCBCE
   T1+ijtQ6ibTlZUKqBv0x5Sx/caNttZYY+22y82f2+3SImBfpE7mF0VTXv
   0AMEq4EVN6X9y8ZnJ41tFedEq1GuOayN/GtepJdqhYbepPDQ2ocmbenMb
   XBNZ5gk/iHd2s539ttujAJFPluhJrENtC0Ttt+V3+6LwnjTppOJHImyk9
   elE4d25wsPm6sC5I3AdwcgyL7fiXU7lHbHa04rIMJuJ0vDNyrGFfiL9yO
   OkwF+6V9VcH/TpGVycRPhhjavBe4xJ2a3mkobbCcdPjpW60Vc2sX+DEOw
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224081"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224081"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682497"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:31 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 019/103] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Sun,  7 Aug 2022 15:01:04 -0700
Message-Id: <b96a789edc879dc2a902c9c31a675e08f1796a00.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/tdx.h  | 12 ++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index c887618e3cec..a32e8881e758 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -144,6 +144,16 @@ struct tdsysinfo_struct {
 bool platform_tdx_enabled(void);
 int tdx_init(void);
 const struct tdsysinfo_struct *tdx_get_sysinfo(void);
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
@@ -151,6 +161,8 @@ static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_init(void)  { return -ENODEV; }
 struct tdsysinfo_struct;
 static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
+static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 918e79159bbf..2168e6133d45 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -56,7 +56,8 @@ static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMEN
 static int tdx_cmr_num;
 
 /* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
-static u32 tdx_global_keyid;
+u32 tdx_global_keyid __read_mostly;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
 
 /* Detect whether CPU supports SEAM */
 static int detect_seam(void)
@@ -80,6 +81,31 @@ static int detect_seam(void)
 	return 0;
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
 static int detect_tdx_keyids(void)
 {
 	u64 keyid_part;
-- 
2.25.1

