Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429794C60E4
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiB1CPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbiB1CPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:31 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4004C7BC;
        Sun, 27 Feb 2022 18:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014493; x=1677550493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fcnsfbicstrBLUSZ0rlOR7ObIplqUS3uKgzPw2/z/t8=;
  b=bm+P8mHPqrldqc1gH/rYss0ciwLYWV1rn1W64geb6tv6FU4wd1H9swFu
   hMEBu3wto28bDzmTuEhY1ed325Z1GNRt5E+1TXo+tC3BwtD+FAWDVO0cO
   NVrXMCc5fzwEaayY5SBfrE7vm0dgn+nkZdxgzQSShpoZe3yFtwyXO3lB1
   1CIMuQLZLv9cunwAkiHIqq7zepEbWCrkU8twlV5bkqWWDGuzzD45LVBT1
   J42Ek7Yis1Nu0FAgprxIofFtOlnyDXAqbuyVrWCc9q9bXgbaA4lUs1YL5
   gOQkBviJSZsxuIO8Y+NKnSBFwLA6uGL95C6E2WWHYCVIt06Kq94m2c17n
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191909"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191909"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:08 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936882"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:04 -0800
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
Subject: [RFC PATCH 06/21] x86/virt/tdx: Shut down TDX module in case of error
Date:   Mon, 28 Feb 2022 15:12:54 +1300
Message-Id: <baef3b3cd762cd629e1dc59d13bfe3fd4aaf5e3e.1646007267.git.kai.huang@intel.com>
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

TDX supports shutting down the TDX module at any time during its
lifetime.  After TDX module is shut down, no further SEAMCALL can be
made on any logical cpu.

Shut down the TDX module in case of any error happened during the
initialization process.  It's pointless to leave the TDX module in some
middle state.

Shutting down TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
BIOS-enabled cpus, and the SEMACALL can run concurrently on different
cpus.  Implement a mechanism to run SEAMCALL concurrently on all online
cpus.  Logical-cpu scope initialization will use it too.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 40 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx.h |  5 +++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 35116eaa0c1a..17f16ec6cb28 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -11,6 +11,8 @@
 #include <linux/cpumask.h>
 #include <linux/mutex.h>
 #include <linux/cpu.h>
+#include <linux/smp.h>
+#include <linux/atomic.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/cpufeature.h>
@@ -328,6 +330,39 @@ static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	return 0;
 }
 
+/* Data structure to make SEAMCALL on multiple CPUs concurrently */
+struct seamcall_ctx {
+	u64 fn;
+	u64 rcx;
+	u64 rdx;
+	u64 r8;
+	u64 r9;
+	atomic_t err;
+	u64 seamcall_ret;
+	struct tdx_module_output out;
+};
+
+static void seamcall_smp_call_function(void *data)
+{
+	struct seamcall_ctx *sc = data;
+	int ret;
+
+	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9,
+			&sc->seamcall_ret, &sc->out);
+	if (ret)
+		atomic_set(&sc->err, ret);
+}
+
+/*
+ * Call the SEAMCALAL on all online cpus concurrently.
+ * Return error if SEAMCALL fails on any cpu.
+ */
+static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
+{
+	on_each_cpu(seamcall_smp_call_function, sc, true);
+	return atomic_read(&sc->err);
+}
+
 static inline bool p_seamldr_ready(void)
 {
 	return !!p_seamldr_info.p_seamldr_ready;
@@ -438,7 +473,10 @@ static int init_tdx_module(void)
 
 static void shutdown_tdx_module(void)
 {
-	/* TODO: Shut down the TDX module */
+	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
+
+	seamcall_on_each_cpu(&sc);
+
 	tdx_module_status = TDX_MODULE_SHUTDOWN;
 }
 
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index 6990c93198b3..dcc1f6dfe378 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -35,6 +35,11 @@ struct p_seamldr_info {
 #define P_SEAMLDR_SEAMCALL_BASE		BIT_ULL(63)
 #define P_SEAMCALL_SEAMLDR_INFO		(P_SEAMLDR_SEAMCALL_BASE | 0x0)
 
+/*
+ * TDX module SEAMCALL leaf functions
+ */
+#define TDH_SYS_LP_SHUTDOWN	44
+
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
-- 
2.33.1

