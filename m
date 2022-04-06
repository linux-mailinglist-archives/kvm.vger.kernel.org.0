Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6E84F6270
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiDFPBC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbiDFPAi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:00:38 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD4E44E5AC;
        Tue,  5 Apr 2022 21:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220610; x=1680756610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SDYGwWRipsleBRGVaBxblRNs6WOMicKlRx1n0NSrBG8=;
  b=HA8U+Go9IwQDUe8Dvfs2UjfEJEVYUsMZjsIM3ZVE3gWRMXTnkf8avrob
   BCI73xn7vEZtvJ4bG+vzdOiugi9qbRrNUTV4GWofae1U5FvwSf4nF6dkS
   Zo/fGj/0jRMPzCUQLFctFJh8xE3XDsjQh5j+bjshhnNTx5B6RPRJyHTIj
   eAut1wvpOfEBCpgjo3G5hn2hFuHqaa7sCf/fWbnbVkMM/5pVpJYQF17Sc
   RLZ/kBBUv1jNA9E6Szzf93MD7Po4DtS3UXQ0M0fi/+KfZ64533t37VsPy
   nOvGMnk5qOtdcc+J5py1Zd1WfjNvstP+5v70xjrWx0L/YksAklXRp1e3J
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089801"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089801"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302212"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:05 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of error
Date:   Wed,  6 Apr 2022 16:49:18 +1200
Message-Id: <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  5 +++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 674867bccc14..faf8355965a5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
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
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 6990c93198b3..dcc1f6dfe378 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
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

