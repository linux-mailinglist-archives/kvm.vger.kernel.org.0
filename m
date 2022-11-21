Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A546317A8
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiKUA1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiKUA1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:21 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7352DAA1;
        Sun, 20 Nov 2022 16:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990441; x=1700526441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hwCT3RUBvAvk7hoIlEmR+DbUGKtOmJbWdTENnqoyMek=;
  b=Zrudpnn80cZTcD+rAl188EsY3CbVD3b7z66ufsiUGtmrtXbnvKGc84r+
   DzwmxPQ4PQd0Q0TJcger+qUuh3g1p46hG8eDjOg3/GLIljC4dxtqkqz3w
   HP+qAA4rOxg073fWCjcAjRbjqsmtXe/Gf0ERTf5Pz2Ak7A/woeDGXod3J
   kb3qBTTuNMPtaaw38lClHcmWpwpo9UMIsxkWuaJkVGc+hJFSi172Ww7Zn
   Colvi7qW+Zha+cjTUKwagPelAFBxbl9gAVKj6oTU8WNAXQqEokIp2q+3y
   uV6EEMb/uKvbQQV7/fUL5DpnbZzpV2XGNGSzIotjn/e2dCjzZw7yA9OrC
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732300"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732300"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825266"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825266"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:16 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of error
Date:   Mon, 21 Nov 2022 13:26:28 +1300
Message-Id: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

v6 -> v7:
 - No change.

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
index b06c1a2bc9cb..5db1a05cb4bd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -13,6 +13,8 @@
 #include <linux/mutex.h>
 #include <linux/cpu.h>
 #include <linux/cpumask.h>
+#include <linux/smp.h>
+#include <linux/atomic.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -124,15 +126,27 @@ bool platform_tdx_enabled(void)
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
 
@@ -166,6 +180,25 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
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
@@ -181,7 +214,9 @@ static int init_tdx_module(void)
 
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
2.38.1

