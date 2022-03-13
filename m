Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC24C4D746F
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 11:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiCMKxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 06:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiCMKws (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 06:52:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09B712CC1D;
        Sun, 13 Mar 2022 03:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647168672; x=1678704672;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vgFg1Mm5KzCdUKJl8VJiZqAJHtuAoK2zOLziK5r/MyM=;
  b=eN2LfVIcPl+o7PinVj1+qTP5fGo4DxJ1xtDNj2KjE8fEu1YwMK2ClINw
   tn4DPwdjjquWtBz+gpUXPslMdvToV+Q6T8wtia20059fOrYChTlFsrTrr
   S+0zhHsX6c6bN5cv2WW7aitR28FMKQd/AbSEQzaeFA0SOSVqGVJdBGcEz
   Q5/ROTGRAh6RnHhzZ8Gfz8yU07Q2C38k/B6AQVoDFoZrVcx359kevWW3r
   H6glmDJCOgMfgNrqevVy/2MXT2m8cOjaZ9QLoBN+zB2jOJnvZLEGCGiXP
   ZCIPDY2P1QtP9xq5tVVmd0qvZNq7R4lN5Tb8B9vgl0wE7ZXBx2JU8dRxw
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10284"; a="255590711"
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="255590711"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,178,1643702400"; 
   d="scan'208";a="645448227"
Received: from mvideche-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.130.249])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2022 03:51:02 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dave.hansen@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, ak@linux.intel.com, dan.j.williams@intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v2 17/21] x86/virt/tdx: Configure global KeyID on all packages
Date:   Sun, 13 Mar 2022 23:49:57 +1300
Message-Id: <c36456b0fd4bd50720bc8e8aa35fbb124185ae98.1647167475.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647167475.git.kai.huang@intel.com>
References: <cover.1647167475.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e03dc3e420db..39b1b7d0417d 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -23,6 +23,7 @@
 #include <asm/virtext.h>
 #include <asm/e820/api.h>
 #include <asm/pgtable.h>
+#include <asm/smp.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -398,6 +399,47 @@ static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
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
@@ -1316,6 +1358,18 @@ static int config_tdx_module(struct tdmr_info **tdmr_array, int tdmr_num,
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
@@ -1366,6 +1420,37 @@ static int init_tdx_module(void)
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
@@ -1376,8 +1461,15 @@ static int init_tdx_module(void)
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
2.35.1

