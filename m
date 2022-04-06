Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D22A54F5B9F
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 12:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351080AbiDFKXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 06:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243496AbiDFKWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 06:22:03 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9445216249F;
        Tue,  5 Apr 2022 21:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220657; x=1680756657;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PxZ+GxynIkoMLEUiFgS85yx4Qd2Ez7/qEzRgLcnxHFY=;
  b=ev6BxZpAiHMSpmj7Bemzw9NgL/mYTQdHLJDqKaZgTdrhgPecD5v6vX2N
   AQtCwWZZdwitVHpuyX9lJgoiuaSXrqo4hWTSShr4Qv5VbmprRzULupuXG
   ugCdqfg3Q2J+InpP7rWMHirv+DastwUQmXGZR1/fgkJqO7PdyGCyk/tmO
   285ngxAmRlQXArQbiyL+ewW+sQlxJVDH2uUdBfQ1NpudF8Npo/mu0uV9A
   DkRmrme5qpxDQo5CSIxftfT/Yv+gyz+lYZoaAm/UDngHPOX+YGxm3CZTV
   VkPhrkVZ3qjKc+Ke6EiVRTwyEqgqx1rLmVKJJkBGRY0IlJ2a2ddmTbvNg
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089893"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089893"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302458"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:48 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 17/21] x86/virt/tdx: Configure global KeyID on all packages
Date:   Wed,  6 Apr 2022 16:49:29 +1200
Message-Id: <ccf14e7fef0a3eab6ad877204ddc1113763c8a63.1649219184.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 96 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2bf49d3d7cfe..bb15122fb8bd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -23,6 +23,7 @@
 #include <asm/virtext.h>
 #include <asm/e820/api.h>
 #include <asm/pgtable.h>
+#include <asm/smp.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -398,6 +399,46 @@ static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
 	return atomic_read(&sc->err);
 }
 
+/*
+ * Call the SEAMCALL on one (any) cpu for each physical package in
+ * serialized way.  Return immediately in case of any error while
+ * calling SEAMCALL on any cpu.
+ *
+ * Note for serialized calls 'struct seamcall_ctx::err' doesn't have
+ * to be atomic, but for simplicity just reuse it instead of adding
+ * a new one.
+ */
+static int seamcall_on_each_package_serialized(struct seamcall_ctx *sc)
+{
+	cpumask_var_t packages;
+	int cpu, ret = 0;
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
+			break;
+
+		/*
+		 * Doesn't have to use atomic_read(), but it doesn't
+		 * hurt either.
+		 */
+		ret = atomic_read(&sc->err);
+		if (ret)
+			break;
+	}
+
+	free_cpumask_var(packages);
+	return ret;
+}
+
 static inline bool p_seamldr_ready(void)
 {
 	return !!p_seamldr_info.p_seamldr_ready;
@@ -1320,6 +1361,21 @@ static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
 	return ret;
 }
 
+static int config_global_keyid(void)
+{
+	struct seamcall_ctx sc = { .fn = TDH_SYS_KEY_CONFIG };
+
+	/*
+	 * Configure the key of the global KeyID on all packages by
+	 * calling TDH.SYS.KEY.CONFIG on all packages.
+	 *
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
@@ -1370,6 +1426,37 @@ static int init_tdx_module(void)
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
+	ret = config_global_keyid();
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
@@ -1380,8 +1467,15 @@ static int init_tdx_module(void)
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index d8e2800397af..bba8cabea4bb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -122,6 +122,7 @@ struct tdmr_info {
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
-- 
2.35.1

