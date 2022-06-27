Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE77C55D787
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbiF0Vzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241335AbiF0Vy4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:56 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C466333;
        Mon, 27 Jun 2022 14:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366894; x=1687902894;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VWj1q7F255VWvoli/gyPtDrh6sKSr26y6yon2ebiLDc=;
  b=lRqWow2xwj2vM5TrbqEBFqdb7ONeiDNjmQEyqiIr9MwlQ+1qsXLxgxIY
   dfr8Fp0/n5G+IL3XmDZFrTfZ635yEAM4ei/z1JudU+rB/uhPI5dgvYttf
   Av35x8ru4in+VwJ0C5i5AkDYaJc21el2X53xYo8ybrHU0sRYKxEaFk9NO
   rb8cD5vkkK+scxndjiU9UnZtsxKNYFqsOu/CXNqclI2769Hmms6HFthPP
   ROlmz8vI5A2kNIycyxj+Mc1hhvMUxP7hA1YTqtotSN2udrKh71s9qo+3l
   deRqC1fucZdbt+mR4/ky9E+yrhkM+85d4uKi1aM/mn8IrRXwRSVtqip2A
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609517"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609517"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863500"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 021/102] x86/cpu: Add helper functions to allocate/free TDX private host key id
Date:   Mon, 27 Jun 2022 14:53:13 -0700
Message-Id: <86a3e7e9c3e8a4f3dd72d72ec370239d8e96306f.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index c887618e3cec..6c0925e73a27 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -144,6 +144,10 @@ struct tdsysinfo_struct {
 bool platform_tdx_enabled(void);
 int tdx_init(void);
 const struct tdsysinfo_struct *tdx_get_sysinfo(void);
+u32 tdx_get_global_keyid(void);
+int tdx_keyid_alloc(void);
+void tdx_keyid_free(int keyid);
+
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
@@ -151,6 +155,9 @@ static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_init(void)  { return -ENODEV; }
 struct tdsysinfo_struct;
 static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
+static inline u32 tdx_get_global_keyid(void) { return 0; };
+static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_keyid_free(int keyid) { }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 14f53494156c..322b6e0ac7dc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -57,7 +57,13 @@ static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMEN
 static int tdx_cmr_num;
 
 /* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
-static u32 tdx_global_keyid;
+static u32 __read_mostly tdx_global_keyid;
+
+u32 tdx_get_global_keyid(void)
+{
+	return tdx_global_keyid;
+}
+EXPORT_SYMBOL_GPL(tdx_get_global_keyid);
 
 /* Detect whether CPU supports SEAM */
 static int detect_seam(void)
@@ -81,6 +87,31 @@ static int detect_seam(void)
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

