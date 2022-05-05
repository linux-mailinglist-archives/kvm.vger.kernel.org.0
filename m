Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F6351C725
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355384AbiEESZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383173AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D682819C33;
        Thu,  5 May 2022 11:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774549; x=1683310549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ApxzvG9f2c2buqwxf9g/IY+QsPLdO7qoBpdMaSG3x0c=;
  b=kJYkWjbPjcQRcjLVIyMVwjS5dmLk3KGahqqYodr1btfC6P/0zZcHW3uL
   Zkmup/WEH72NC9lSGJ45/B57m7+fTV0XRvZS98iB8Km3y4MLlZVzOXn/L
   Q508/lo6/EBR1PeR2yLa7KMH3m5ZEvH61KkNU0IgABCmf3LGor6JGDI89
   CJqqfBy1ufAVdLiaGn5q6jPxEeim0pVviZPVCQjXRwFZCBAplGYJ9LKHp
   3b4y0/Yd8VRZTBWLHe9WhW92EsSr1PrZH7Crrwf6wVEiSb/MwbjpcD2mt
   Qb0aDO9CLeLf8DCvdxmn+KeyxrnfHteuzIjM0Q4xghcwCmzdMFxt9IIjv
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746251"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746251"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:42 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083197"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 021/104] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Thu,  5 May 2022 11:14:15 -0700
Message-Id: <37cbab674de44e0563f81cbe147216a9031a1704.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 arch/x86/include/asm/tdx.h  |  7 +++++++
 arch/x86/virt/vmx/tdx/tdx.c | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 3a4fb2844f66..7da43ed0e216 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -149,6 +149,10 @@ int tdx_detect(void);
 int tdx_init(void);
 bool platform_has_tdx(void);
 const struct tdsysinfo_struct *tdx_get_sysinfo(void);
+u32 tdx_get_global_keyid(void);
+int tdx_keyid_alloc(void);
+void tdx_keyid_free(int keyid);
+
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else
@@ -159,6 +163,9 @@ static inline int tdx_init(void) { return -ENODEV; }
 static inline bool platform_has_tdx(void) { return false; }
 struct tdsysinfo_struct;
 static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
+static inline u32 tdx_get_global_keyid(void) { return 0; };
+static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_keyid_free(int keyid) { }
 #endif /* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1ef22c445126..799a26e56f11 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -114,7 +114,13 @@ static int tdx_cmr_num;
 static struct tdsysinfo_struct tdx_sysinfo;
 
 /* TDX global KeyID to protect TDX metadata */
-static u32 tdx_global_keyid;
+static u32 __read_mostly tdx_global_keyid;
+
+u32 tdx_get_global_keyid(void)
+{
+	return tdx_global_keyid;
+}
+EXPORT_SYMBOL_GPL(tdx_get_global_keyid);
 
 static bool enable_tdx_host;
 
@@ -191,6 +197,31 @@ static void detect_seam(struct cpuinfo_x86 *c)
 		detect_seam_ap(c);
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
 static void detect_tdx_keyids_bsp(struct cpuinfo_x86 *c)
 {
 	u64 keyid_part;
-- 
2.25.1

