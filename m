Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52E834D7451
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbiCMKvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbiCMKvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:51:39 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144DC36B72;
        Sun, 13 Mar 2022 03:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168630; x=1678704630;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HimONfpfA8ZUNJ57DL6YyWiMd/sDi6k2uK0GLmkOfLk=;
  b=nTxAKlh+BLqoLZu1LLSTEmNWQ5Mrb2nZnWZaE7wEBzCh4TPsq5MFjMlP
   mr1iB7NK+/EkH8QWFu8R9EVfs0Ny6FBRAP1yOvSmAU+31wOPl2wR1X6Uv
   zMse0wK9Dz86h1Wh9eQW9QScd31BxofcrpcdtZFr2CioEgXJGOj49i0tN
   wVQe2HhxZrQVw1pu4AjTppjs0kZvUAqo7Ace5nveVZppHUs09Pk2UdBul
   nwEiOXJlH5wLFs9KPO4i6XCHstBjeOLWtwjh9eoo2FovQRqRcxPgxT2Wx
   Ff8PldossO0RyOdGcsvF6LgrN2zfYTFeJZmsgU5kQlXyft5XUqUT+0JZO
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255810443"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255810443"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448100"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:50:26 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 06/21] x86/virt/tdx: Shut down TDX module in case of error
Date:   Sun, 13 Mar 2022 23:49:46 +1300
Message-Id: <c8f76a29735d7a51a22ebf094acf98cc316c0dcd.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
BIOS-enabled cpus, and the SEMACALL can run concurrently on different
cpus.  Implement a mechanism to run SEAMCALL concurrently on all online
cpus.  Logical-cpu scope initialization will use it too.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 40 +++++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx.h |  5 +++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index b04f792f1e65..d87af534db51 100644
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
+ * Call the SEAMCALL on all online cpus concurrently.
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
@@ -437,7 +472,10 @@ static int init_tdx_module(void)
 
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
2.35.1

