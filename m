Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEBE4D746C
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbiCMKxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiCMKww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1CD47AD1;
        Sun, 13 Mar 2022 03:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168684; x=1678704684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=APrZzjGrkRGG7Lr87LmTfqU/eGtk8ICoc5xUHBUFbwI=;
  b=WE8aIdi5bVLQa8XXUK/9HiEPW5JEFK1A3lWh0QiQQilzrAdwV4tcbt4D
   1D4AX4IpVsT/q9TAkzpuda8QtxqPkd7wpCJHTs9YrPZDaVfHbtkjJXzfE
   z7CxdZYnd8gaEFiLsNzdisDaCMEbq9cYa1dFleWGRYXmr640VcgsvKUQq
   OvtsHI5FI+dtVCz2k+yRzHQSSZciiX7kpPE8Yv/BkOwplPxoOZXgTrh4/
   wpXUbsPu4Ew/2eddsXGwwxdmEoSS7Sdk3ExV++HXEpCaAo7FkdrDuXc2T
   NGIbsQaXIscWjgwS+7VwbW1dNwyk4Q8zPT73i08mXplrpecXgTu7MGVQX
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255590722"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255590722"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:12 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448243"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:09 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 19/21] x86: Flush cache of TDX private memory during kexec()
Date:   Sun, 13 Mar 2022 23:49:59 +1300
Message-Id: <e3db947d341ae544b236fa2e547fd98c63cc9626.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If TDX is ever enabled and/or used to run any TD guests, the cachelines
of TDX private memory, including PAMTs, used by TDX module need to be
flushed before transiting to the new kernel otherwise they may silently
corrupt the new kernel.

TDX module can only be initialized once during its lifetime.  TDX does
not have interface to reset TDX module to an uninitialized state so it
could be initialized again.  If the old kernel has enabled TDX, the new
kernel won't be able to use TDX again.  Therefore, ideally the old
kernel should shut down the TDX module if it is ever initialized so that
no SEAMCALLs can be made to it again.

However, shutting down the TDX module requires calling SEAMCALL, which
requires cpu being in VMX operation (VMXON has been done).  Currently,
only KVM does entering/leaving VMX operation, so there's no guarantee
that all cpus are in VMX operation during kexec().  Therefore, this
implementation doesn't shut down the TDX module, but only does cache
flush and just leave the TDX module open.

And it's fine to leave the module open.  If the new kernel wants to use
TDX, it needs to go through the initialization process, and it will fail
at the first SEAMCALL due to the TDX module is not in the uninitialized
state.  If the new kernel doesn't want to use TDX, then the TDX module
won't run at all.

Following the implementation of SME support, use wbinvd() to flush cache
in stop_this_cpu().  Introduce a new function platform_has_tdx() to only
check whether the platform is TDX-capable and do wbinvd() when it is
true.  platform_has_tdx() returns true when SEAMRR is enabled and there
are enough TDX private KeyIDs to run at least one TD guest (both of
which are detected at boot time).  TDX is enabled on demand at runtime
and it has a state machine with mutex to protect multiple callers to
initialize TDX in parallel.  Getting TDX module state needs to hold the
mutex but stop_this_cpu() runs in interrupt context, so just check
whether platform supports TDX and flush cache.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/tdx.h |  2 ++
 arch/x86/kernel/process.c  | 15 ++++++++++++++-
 arch/x86/virt/vmx/tdx.c    | 14 ++++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b526d41c4bbf..24f2b7e8b280 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -85,10 +85,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 void tdx_detect_cpu(struct cpuinfo_x86 *c);
 int tdx_detect(void);
 int tdx_init(void);
+bool platform_has_tdx(void);
 #else
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
 static inline int tdx_detect(void) { return -ENODEV; }
 static inline int tdx_init(void) { return -ENODEV; }
+static inline bool platform_has_tdx(void) { return false; }
 #endif /* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 71aa12082370..bf3d1c9cb00c 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -766,8 +766,21 @@ void stop_this_cpu(void *dummy)
 	 * without the encryption bit, they don't race each other when flushed
 	 * and potentially end up with the wrong entry being committed to
 	 * memory.
+	 *
+	 * In case of kexec, similar to SME, if TDX is ever enabled, the
+	 * cachelines of TDX private memory (including PAMTs) used by TDX
+	 * module need to be flushed before transiting to the new kernel,
+	 * otherwise they may silently corrupt the new kernel.
+	 *
+	 * Note TDX is enabled on demand at runtime, and enabling TDX has a
+	 * state machine protected with a mutex to prevent concurrent calls
+	 * from multiple callers.  Holding the mutex is required to get the
+	 * TDX enabling status, but this function runs in interrupt context.
+	 * So to make it simple, always flush cache when platform supports
+	 * TDX (detected at boot time), regardless whether TDX is truly
+	 * enabled by kernel.
 	 */
-	if (boot_cpu_has(X86_FEATURE_SME))
+	if (boot_cpu_has(X86_FEATURE_SME) || platform_has_tdx())
 		native_wbinvd();
 	for (;;) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index f2b9c98191ed..d9ad8dc7111e 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1681,3 +1681,17 @@ int tdx_init(void)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdx_init);
+
+/**
+ * platform_has_tdx - Whether platform supports TDX
+ *
+ * Check whether platform supports TDX (i.e. TDX is enabled in BIOS),
+ * regardless whether TDX is truly enabled by kernel.
+ *
+ * Return true if SEAMRR is enabled, and there are sufficient TDX private
+ * KeyIDs to run TD guests.
+ */
+bool platform_has_tdx(void)
+{
+	return seamrr_enabled() && tdx_keyid_sufficient();
+}
-- 
2.35.1

