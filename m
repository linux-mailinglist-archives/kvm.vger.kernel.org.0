Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF8D539726
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347357AbiEaTlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347381AbiEaTlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:41:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F03B9C2DB;
        Tue, 31 May 2022 12:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026050; x=1685562050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=02fJdKugq59zflAM6mtPgQ0J0cddzIaPgRlR9y5GAGQ=;
  b=jHN52t2u27spSk1IaUR4fBKgSDjoQqp329n+5FP6H5M1iMywThPI4ZXn
   8u/fGlFq9epAGwwpTmUlq7heNJs609ozvqZHgoYuKr6sfct8aNyy23fkB
   CDkwwHbGh99HLlO02btuJpwjc176dU81tGFBanL9p5nhK0vkWtjG7FPi5
   G8YBdUzow96u3NfE0tsPyghTGn0hsgP0xAm4qkPeCCNqQaOoyFAg1uvyc
   04fXGwhNbGzxhC42esB/WQsviBPmGrNFWDk7yZvaFm6bTKHDlAmjBky94
   KCdYnF89AB2DqJ673uz5OjOW8HcF0zSLsP7doX/VwV94vLd11SpYWD54y
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935072"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935072"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:23 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164343"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:20 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 08/22] x86/virt/tdx: Shut down TDX module in case of error
Date:   Wed,  1 Jun 2022 07:39:31 +1200
Message-Id: <3681924471131164f151569334ff57a8d22df618.1654025431.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1654025430.git.kai.huang@intel.com>
References: <cover.1654025430.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX supports shutting down the TDX module at any time during its
lifetime.  After the module is shut down, no further TDX module SEAMCALL
leaf functions can be made to the module on any logical cpu.

Shut down the TDX module in case of any error during the initialization
process.  It's pointless to leave the TDX module in some middle state.

Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
BIOS-enabled CPUs, and the SEMACALL can run concurrently on different
CPUs.  Implement a mechanism to run SEAMCALL concurrently on all online
CPUs and use it to shut down the module.  Later logical-cpu scope module
initialization will use it too.

Also add a wrapper of __seamcall() which additionally prints out the
error information if SEAMCALL fails.  It will be useful during the TDX
module initialization as it provides more error information to the user.

SEAMCALL instruction causes #UD if CPU is not in VMX operation (VMXON
has been done).  So far only KVM supports VMXON.  It guarantees all
online CPUs are in VMX operation when there's any VM still exists.  As
so far KVM is also the only user of TDX, choose to just let the caller
to guarantee all CPUs are in VMX operation during tdx_init().

Adding the support of VMXON/VMXOFF to the core-kernel isn't trivial.
In the long term, more kernel components will likely need to use TDX so
a reference-based approach to do VMXON/VMXOFF will likely be needed.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

- v3 -> v4:
 - Added a wrapper of __seamcall() to print error code if SEAMCALL fails.
 - Made the seamcall_on_each_cpu() void.
 - Removed 'seamcall_ret' and 'tdx_module_out' from
   'struct seamcall_ctx', as they must be local variable.
 - Added the comments to tdx_init() and one paragraph to changelog to
   explain the caller should handle VMXON.
 - Called out after shut down, no "TDX module" SEAMCALL can be made.

---
 arch/x86/virt/vmx/tdx/tdx.c | 71 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  5 +++
 2 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 77e1ec219625..8e0fe314eb44 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -13,6 +13,8 @@
 #include <linux/mutex.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/smp.h>
+#include <linux/atomic.h>
 #include <asm/cpufeatures.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
@@ -123,6 +125,67 @@ static int __init tdx_early_detect(void)
 }
 early_initcall(tdx_early_detect);
 
+/*
+ * Data structure to make SEAMCALL on multiple CPUs concurrently.
+ * @err is set to -EFAULT when SEAMCALL fails on any cpu.
+ */
+struct seamcall_ctx {
+	u64 fn;
+	u64 rcx;
+	u64 rdx;
+	u64 r8;
+	u64 r9;
+	atomic_t err;
+};
+
+/*
+ * Wrapper of __seamcall().  It additionally prints out the error
+ * informationi if __seamcall() fails normally.  It is useful during
+ * the module initialization by providing more information to the user.
+ */
+static u64 seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+		    struct tdx_module_output *out)
+{
+	u64 ret;
+
+	ret = __seamcall(fn, rcx, rdx, r8, r9, out);
+	if (ret == TDX_SEAMCALL_VMFAILINVALID || !ret)
+		return ret;
+
+#define MODULE_OUTPUT_FMT	\
+	"additional output: rcx 0x%llx, rdx 0x%llx, r8 0x%llx, r9 0x%llx, r10 0x%llx, r11 0x%llx."
+#define MODULE_OUTPUT_ARG(_out)	\
+	(_out)->rcx, (_out)->rdx, (_out)->r8, (_out)->r9, (_out)->r10, (_out)->r11
+
+	if (!out)
+		pr_err("SEAMCALL failed: leaf: 0x%llx, error: 0x%llx\n", fn, ret);
+	else
+		pr_err("SEAMCALL failed: leaf: 0x%llx, error: 0x%llx, " MODULE_OUTPUT_FMT "\n",
+				fn, ret, MODULE_OUTPUT_ARG(out));
+
+	return ret;
+}
+
+static void seamcall_smp_call_function(void *data)
+{
+	struct seamcall_ctx *sc = data;
+	struct tdx_module_output out;
+	u64 ret;
+
+	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9, &out);
+	if (ret)
+		atomic_set(&sc->err, -EFAULT);
+}
+
+/*
+ * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
+ * @sc->err to determine whether any SEAMCALL failed on any cpu.
+ */
+static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
+{
+	on_each_cpu(seamcall_smp_call_function, sc, true);
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -138,7 +201,10 @@ static int init_tdx_module(void)
 
 static void shutdown_tdx_module(void)
 {
-	/* TODO: Shut down the TDX module */
+	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
+
+	seamcall_on_each_cpu(&sc);
+
 	tdx_module_status = TDX_MODULE_SHUTDOWN;
 }
 
@@ -225,6 +291,9 @@ bool platform_tdx_enabled(void)
  * CPU hotplug is temporarily disabled internally to prevent any cpu
  * from going offline.
  *
+ * Caller also needs to guarantee all CPUs are in VMX operation during
+ * this function, otherwise Oops may be triggered.
+ *
  * This function can be called in parallel by multiple callers.
  *
  * Return:
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index f1a2dfb978b1..95d4eb884134 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,11 @@
 #define TDX_KEYID_NUM(_keyid_part)	((u32)((_keyid_part) >> 32))
 
 
+/*
+ * TDX module SEAMCALL leaf functions
+ */
+#define TDH_SYS_LP_SHUTDOWN	44
+
 /*
  * Do not put any hardware-defined TDX structure representations below this
  * comment!
-- 
2.35.3

