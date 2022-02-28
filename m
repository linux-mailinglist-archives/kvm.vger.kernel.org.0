Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386054C60F6
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiB1CQR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiB1CPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:51 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF936C929;
        Sun, 27 Feb 2022 18:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014506; x=1677550506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlVoP3N/KiiurWcxJiuR+/mHqMX2/n+WVAGHxE3ZUUY=;
  b=G259cS6X5J3jNjJ5Ozurn9xiC2GeogKBCRmjg39AVz306GRVE7j9EJJX
   oYTWrpO3oAnve75w+PiWZgkLbjRJcAxgV/t81U0VRPVeodjZTV9MU+IOs
   1ilxNuwUlQ1sJTw8T+fgLmt5iYbuKYLGPsc+gGxomT5wZIwW0hFLnv+Iz
   XDpvxEkN9IqD2fXaFm61ExMirXj9iW0hDBMaowC4fjXj8VpAb98ReeqFN
   5ZoYo7YXOfg2O9cdzhBt0oI62fq73Xni/nmhhwULpKrbBsggbivlk5LTf
   T6si/xmSH4w2+vzNfGeLITRs+YHVbDdqUPReM/lVHwNGMVDGuIFxHv7dc
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240192052"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240192052"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:15:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777937039"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:15:01 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     x86@kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@intel.com, luto@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, hpa@zytor.com,
        peterz@infradead.org, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tony.luck@intel.com,
        ak@linux.intel.com, dan.j.williams@intel.com,
        chang.seok.bae@intel.com, keescook@chromium.org,
        hengqi.arch@bytedance.com, laijs@linux.alibaba.com,
        metze@samba.org, linux-kernel@vger.kernel.org, kai.huang@intel.com
Subject: [RFC PATCH 19/21] x86: Flush cache of TDX private memory during kexec()
Date:   Mon, 28 Feb 2022 15:13:07 +1300
Message-Id: <64bb89cf1108e85057f4b426406fbb5ec5172273.1646007267.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1646007267.git.kai.huang@intel.com>
References: <cover.1646007267.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

However, SEAMCALL requires cpu being in VMX operation (VMXON has been
done).  Currently, only KVM handles VMXON and when KVM is unloaded, all
cpus leave VMX operation.  Theoretically, during kexec() there's no
guarantee all cpus are in VMX operation.  Adding VMXON handling to the
core kernel isn't trivial so this implementation depends on the caller
of TDX to guarantee that.  This means it's not easy to shut down TDX
module during kexec().  Therefore, this implementation doesn't shut down
TDX module, but only does cache flush and just leave TDX module open.

And it's fine to leave the module open.  If the new kernel wants to use
TDX, it needs to go through the initialization process which will fail
at the first SEAMCALL due to TDX module is not in uninitialized state.
If the new kernel doesn't want to use TDX, then TDX module won't run at
all.

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
 arch/x86/kernel/process.c  | 26 +++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx.c    | 14 ++++++++++++++
 3 files changed, 41 insertions(+), 1 deletion(-)

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
index 71aa12082370..70eea43d1f32 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -766,8 +766,32 @@ void stop_this_cpu(void *dummy)
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
+	 *
+	 * TDX module can only be initialized once during its lifetime. So
+	 * if TDX is enabled in old kernel, the new kernel won't be able to
+	 * use TDX again, because when new kernel go through the TDX module
+	 * initialization process, it will fail immediately at the first
+	 * SEAMCALL.  Ideally, it's better to shut down TDX module, but this
+	 * requires SEAMCALL, which requires CPU already being in VMX
+	 * operation.  It's not trival to do VMXON here so to keep it simple
+	 * just leave the module open.  And leaving TDX module open is OK.
+	 * The new kernel cannot use TDX anyway.  The TDX module won't run
+	 * at all in the new kernel.
 	 */
-	if (boot_cpu_has(X86_FEATURE_SME))
+	if (boot_cpu_has(X86_FEATURE_SME) || platform_has_tdx())
 		native_wbinvd();
 	for (;;) {
 		/*
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 2760c10a430a..f704fddc9dfc 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -1602,3 +1602,17 @@ int tdx_init(void)
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
2.33.1

