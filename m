Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A898F4F579C
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 10:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384180AbiDFHYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 03:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456650AbiDFGon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 02:44:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4DE1624A7;
        Tue,  5 Apr 2022 21:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220661; x=1680756661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zl4wuB3hvdv3gjR+XZpjE+wS0F3OX5rinqQh5T1Gs7Q=;
  b=nsNEaaPGAznUK92tiArA+QoXkZ70etVsHd8dH501Gjdp5ytgCI9C/QKe
   SvCgRfXfKlTeQ3hfB+83IToINMXcRPG8i1IuacOMZGlXlb/RLby4kDdO7
   iOZT31N7Cl8o04JDjEywXqO6qtAm4chyancpE/Pb2UggXHyLgA3zsFxJc
   y4djIutIAiDSXD4U5RO+I3LKUzzCmNw1Yg6O/x+W8ltXxPTb3ZFls2pw9
   jLZUHPdw9mSAvHo3t9mRyio6QCaQmtGJCT2o0+iJXuSJOVreAqC/VvSDG
   pHCObcX2sjRKY8Tm/heID/YC1JZibiojisAgNxxZn5zFC0/NIRkLEdUjJ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089918"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089918"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:59 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302481"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:56 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 19/21] x86: Flush cache of TDX private memory during kexec()
Date:   Wed,  6 Apr 2022 16:49:31 +1200
Message-Id: <2a2134dede7ab456154567b01d0c8f4243d9d3d6.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
flush and leaves the TDX module open.

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
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kernel/process.c   | 15 ++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 14 ++++++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index c8af2ba6bb8a..513b9ce9a870 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -94,10 +94,12 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
index dbaf12c43fe1..0238bd29af8a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -769,8 +769,21 @@ void __noreturn stop_this_cpu(void *dummy)
 	 *
 	 * Test the CPUID bit directly because the machine might've cleared
 	 * X86_FEATURE_SME due to cmdline options.
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
-	if (cpuid_eax(0x8000001f) & BIT(0))
+	if ((cpuid_eax(0x8000001f) & BIT(0)) || platform_has_tdx())
 		native_wbinvd();
 	for (;;) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 11bd1daffee3..031af7b83cea 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1687,3 +1687,17 @@ int tdx_init(void)
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

