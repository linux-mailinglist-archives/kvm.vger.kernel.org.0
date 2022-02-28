Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6617D4C6100
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 03:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiB1CPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 21:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiB1CPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 21:15:36 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB96255236;
        Sun, 27 Feb 2022 18:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646014497; x=1677550497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mr0RpXWMofozcpe6De6x3hAXcUkujKnR9X9B8qknSc4=;
  b=K1Ii4aFJOlqWCWj1ZcKRTZFZYKw9buaZeAImUn80fza9fwkaX2zgxbvB
   2Py2HHm0GQhHcleT387Ee3yUYDucBZMoTL86uVnT7XU1lYXLlToaQwbv+
   P7IyvL82/STX+Vv+kqbvfjLe2m6kbBtZD0+BGlWeNOJ4Sg2Zh9q4ST2nn
   ULJzcbjLaLXnan2WXqyyG7/tound4o4WOSjQk3/NW1mTNK7Y/N7TGQ7eO
   w5k/v6cqS2dSnQfQZOGDQoUh3V9nxr9d7ElucN1jOgP/NCj6izUaryX1f
   gklq+B1gsgyk5JA3/4WR//C7n79WM1+ewpBkTCDneqYSaPaClkfShpdx6
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10271"; a="240191993"
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="240191993"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:57 -0800
X-IronPort-AV: E=Sophos;i="5.90,142,1643702400"; 
   d="scan'208";a="777936978"
Received: from jdpanhor-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.49.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2022 18:14:52 -0800
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
Subject: [RFC PATCH 17/21] x86/virt/tdx: Configure global KeyID on all packages
Date:   Mon, 28 Feb 2022 15:13:05 +1300
Message-Id: <21b8abec9044667a8137a2b1569c547dbf40641c.1646007267.git.kai.huang@intel.com>
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

Before TDX module can use the global KeyID to access TDX metadata, the
key of the global KeyID must be configured on all physical packages via
TDH.SYS.KEY.CONFIG.  This SEAMCALL cannot run concurrently on different
cpus since it exclusively acquires the TDX module.

Implement a helper to run SEAMCALL on one (any) cpu for all packages in
serialized way, and run TDH.SYS.KEY.CONFIG on all packages using the
helper.

The TDX module uses the global KeyID to initialize its metadata (PAMTs).
Before TDX module can do that, all cachelines of PAMTs must be flushed.
Otherwise, they may silently corrupt the PAMTs later initialized by the
TDX module.

Use wbinvd to flush cache as PAMTs can be potentially large (~1/256th of
system RAM).

Flush cache before configuring the global KeyID on all packages, as
suggested by TDX specification.  In practice, the current generation of
TDX doesn't use the global KeyID in TDH.SYS.KEY.CONFIG.  Therefore in
practice flushing cache can be done after configuring the global KeyID
is done on all packages.  But the future generation of TDX may change
this behaviour, so just follow TDX specification's suggestion to flush
cache before configuring the global KeyID on all packages.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx.c | 94 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx.h |  1 +
 2 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index 008628674a2f..22cbc43873c9 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -22,6 +22,7 @@
 #include <asm/virtext.h>
 #include <asm/e820/api.h>
 #include <asm/pgtable.h>
+#include <asm/smp.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -397,6 +398,47 @@ static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
 	return atomic_read(&sc->err);
 }
 
+/*
+ * Call the SEAMCALL on one (any) cpu for each physical package in
+ * serialized way.  Note for serialized calls 'seamcall_ctx::err'
+ * doesn't have to be atomic, but for simplicity just reuse it
+ * instead of adding a new one.
+ *
+ * Return -ENXIO if IPI SEAMCALL wasn't run on any cpu, or -EFAULT
+ * when SEAMCALL fails, or -EPERM when the cpu where SEAMCALL runs
+ * on is not in VMX operation.  In case of -EFAULT, the error code
+ * of SEAMCALL is in 'struct seamcall_ctx::seamcall_ret'.
+ */
+static int seamcall_on_each_package_serialized(struct seamcall_ctx *sc)
+{
+	cpumask_var_t packages;
+	int cpu, ret;
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
+					packages))
+			continue;
+
+		ret = smp_call_function_single(cpu, seamcall_smp_call_function,
+				sc, true);
+		if (ret)
+			return ret;
+
+		/*
+		 * Doesn't have to use atomic_read(), but it doesn't
+		 * hurt either.
+		 */
+		ret = atomic_read(&sc->err);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static inline bool p_seamldr_ready(void)
 {
 	return !!p_seamldr_info.p_seamldr_ready;
@@ -1239,6 +1281,18 @@ static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
 	return ret;
 }
 
+static int config_global_keyid(u64 global_keyid)
+{
+	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
+
+	/*
+	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is
+	 * a recoverable error).  Assume this is exceedingly rare and
+	 * just return error if encountered instead of retrying.
+	 */
+	return seamcall_on_each_package_serialized(&sc);
+}
+
 static int init_tdx_module(void)
 {
 	struct tdmr_info **tdmr_array;
@@ -1289,6 +1343,37 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
+	/*
+	 * The same physical address associated with different KeyIDs
+	 * has separate cachelines.  Before using the new KeyID to access
+	 * some memory, the cachelines associated with the old KeyID must
+	 * be flushed, otherwise they may later silently corrupt the data
+	 * written with the new KeyID.  After cachelines associated with
+	 * the old KeyID are flushed, CPU speculative fetch using the old
+	 * KeyID is OK since the prefetched cachelines won't be consumed
+	 * by CPU core.
+	 *
+	 * TDX module initializes PAMTs using the global KeyID to crypto
+	 * protect them from malicious host.  Before that, the PAMTs are
+	 * used by kernel (with KeyID 0) and the cachelines associated
+	 * with the PAMTs must be flushed.  Given PAMTs are potentially
+	 * large (~1/256th of system RAM), just use WBINVD on all cpus to
+	 * flush the cache.
+	 *
+	 * In practice, the current generation of TDX doesn't use the
+	 * global KeyID in TDH.SYS.KEY.CONFIG.  Therefore in practice,
+	 * the cachelines can be flushed after configuring the global
+	 * KeyID on all pkgs is done.  But the future generation of TDX
+	 * may change this, so just follow the suggestion of TDX spec to
+	 * flush cache before TDH.SYS.KEY.CONFIG.
+	 */
+	wbinvd_on_all_cpus();
+
+	/* Config the key of global KeyID on all packages */
+	ret = config_global_keyid(tdx_global_keyid);
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
@@ -1299,8 +1384,15 @@ static int init_tdx_module(void)
 	 * Free PAMTs allocated in construct_tdmrs() when TDX module
 	 * initialization fails.
 	 */
-	if (ret)
+	if (ret) {
+		/*
+		 * Part of PAMTs may already have been initialized by
+		 * TDX module.  Flush cache before returning them back
+		 * to kernel.
+		 */
+		wbinvd_on_all_cpus();
 		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
+	}
 out_free_tdmrs:
 	/*
 	 * TDMRs are only used during initializing TDX module.  Always
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index d8e2800397af..bba8cabea4bb 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -122,6 +122,7 @@ struct tdmr_info {
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
-- 
2.33.1

