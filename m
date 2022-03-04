Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022BB4CDE27
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiCDUGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiCDUGP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:06:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF042A2E15;
        Fri,  4 Mar 2022 12:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424102; x=1677960102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p4K/gmqXDxXdRUzf9TmVyz0WUmZV+enBJQ9EkmF3YDs=;
  b=TeG66tMMCUQSC49G1ZF4hnwqL1IeRLAjwKjip79ZNYilm3kJoTLRxg/O
   uhqXKIsvHdItmMhm1jTTMtH58TDR5FTfKXNUWMWe5Y5SSzieTmhjGTdVe
   aKV1z+q1GFZlcbzQln838dJvQeXtGExsuvCD0Hs1LHnTtNlLs0Q3XLPkE
   4o53I76akKpyzPnstAqT0syUSl0Y8parfwL0gPuspvbHyBsAkwxL0Nbld
   Sv94O0S+XINsFv/PlAjM/EioKX9z3EvYifVBHgqB+dgtpbmttTQ1Pd4qo
   LrVzBJaZGvspDNoBRz596/g18l3asGqNqdRL5ckCnUOPV75n0+GabvHuR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983394"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983394"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:14 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344254"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:13 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 023/104] x86/cpu: Add helper functions to allocate/free MKTME keyid
Date:   Fri,  4 Mar 2022 11:48:39 -0800
Message-Id: <a1d1e4f26c6ef44a557e873be2818e6a03e12038.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

MKTME keyid is assigned to guest TD.  The memory controller encrypts guest
TD memory with key id.  Add helper functions to allocate/free MKTME keyid
so that TDX KVM assign keyid.

Also export MKTME global keyid that is used to encrypt TDX module and its
memory.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h |  6 ++++++
 arch/x86/virt/vmx/tdx.c    | 33 ++++++++++++++++++++++++++++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9a8dc6afcb63..73bb472bd515 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -139,6 +139,9 @@ int tdx_detect(void);
 int tdx_init(void);
 bool platform_has_tdx(void);
 const struct tdsysinfo_struct *tdx_get_sysinfo(void);
+u32 tdx_get_global_keyid(void);
+int tdx_keyid_alloc(void);
+void tdx_keyid_free(int keyid);
 #else
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
 static inline int tdx_detect(void) { return -ENODEV; }
@@ -146,6 +149,9 @@ static inline int tdx_init(void) { return -ENODEV; }
 static inline bool platform_has_tdx(void) { return false; }
 struct tdsysinfo_struct;
 static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
+static inline u32 tdx_get_global_keyid(void) { return 0; };
+static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
+static inline void tdx_keyid_free(int keyid) { }
 #endif /* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index e45f188479cb..d714106321d4 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -113,7 +113,13 @@ static int tdx_cmr_num;
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
 
@@ -189,6 +195,31 @@ static void detect_seam(struct cpuinfo_x86 *c)
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

