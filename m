Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9BF60EC1F
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbiJZXSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiJZXRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:17:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD51A23CC;
        Wed, 26 Oct 2022 16:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826250; x=1698362250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+SpCN+dQ22o1M5BWK9wviXLnwdQVF8MwFp55TnMGLY=;
  b=aSkkkr6xbiXXBuGLqKjuJ2Nsj0fYDRveSexVwIC4OVNELH5XtUS5BHCC
   RmMkLB99KEQCxBQrVIav+KE9sOczg6q6oZeV+AWHiOqV2w94T9YB1sh9R
   PZ0z3ag8kUUzHi+oJH+3Xxbruj5g9oO+mIoKOb3Kszt7qYtkJfEdgmm+M
   8hC12ymTABy9lDTFYtZpyKICjLl9PWs+bO52jtYvhA6qiw25SA4iwC2EP
   CJQW5plIgvTrVsok7ftx2vAHd3rFED3AhEGr1Kda2dkUqlIpfcekk26ym
   fwR7rF9yC/kiq8sIu70VgFOtITGbto5tWmr5/q9YsBp0SrpWWkxOuC+53
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175504"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175504"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:29 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446315"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446315"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:25 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 07/21] x86/virt/tdx: Shut down TDX module in case of error
Date:   Thu, 27 Oct 2022 12:16:06 +1300
Message-Id: <3f61504e985ade3acd2e36cfa33aa00d3c9ce16f.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v5 -> v6:
 - Removed the seamcall() wrapper to previous patch (Dave).

- v3 -> v5 (no feedback on v4):
 - Added a wrapper of __seamcall() to print error code if SEAMCALL fails.
 - Made the seamcall_on_each_cpu() void.
 - Removed 'seamcall_ret' and 'tdx_module_out' from
   'struct seamcall_ctx', as they must be local variable.
 - Added the comments to tdx_init() and one paragraph to changelog to
   explain the caller should handle VMXON.
 - Called out after shut down, no "TDX module" SEAMCALL can be made.

---
 arch/x86/virt/vmx/tdx/tdx.c | 43 +++++++++++++++++++++++++++++++++----
 arch/x86/virt/vmx/tdx/tdx.h |  5 +++++
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f1154ef15549..5246335abe07 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,8 @@
 #include <linux/mutex.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/smp.h>
+#include <linux/atomic.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -267,15 +269,27 @@ bool platform_tdx_enabled(void)
 	return !!tdx_keyid_num;
 }
 
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
 /*
  * Wrapper of __seamcall() to convert SEAMCALL leaf function error code
  * to kernel error code.  @seamcall_ret and @out contain the SEAMCALL
  * leaf function return code and the additional output respectively if
  * not NULL.
  */
-static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-				    u64 *seamcall_ret,
-				    struct tdx_module_output *out)
+static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+		    u64 *seamcall_ret, struct tdx_module_output *out)
 {
 	u64 sret;
 
@@ -309,6 +323,25 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	}
 }
 
+static void seamcall_smp_call_function(void *data)
+{
+	struct seamcall_ctx *sc = data;
+	int ret;
+
+	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9, NULL, NULL);
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
@@ -324,7 +357,9 @@ static int init_tdx_module(void)
 
 static void shutdown_tdx_module(void)
 {
-	/* TODO: Shut down the TDX module */
+	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
+
+	seamcall_on_each_cpu(&sc);
 }
 
 static int __tdx_enable(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 92a8de957dc7..215cc1065d78 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -12,6 +12,11 @@
 /* MSR to report KeyID partitioning between MKTME and TDX */
 #define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
 
+/*
+ * TDX module SEAMCALL leaf functions
+ */
+#define TDH_SYS_LP_SHUTDOWN	44
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.37.3

