Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B94E53972A
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347456AbiEaTmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347538AbiEaTmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:42:05 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0CFC1A;
        Tue, 31 May 2022 12:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654026099; x=1685562099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q2kJ+jopwDxjTVuA+3nShc2Fq8Mx5AtT0kgAvD1QMyU=;
  b=gfyc/eapPRVFaIkMvkFzl+bOlOtQjndPPU6N4H2YZLJSTje1Bks6BIJv
   OZakv7wXBmL87iaO1drZbMNZ2JHAA2eYG53do3OkGhdGIEyGZ5uUC/0uE
   16u56IR0KCEPkepUvYM5x5aAdZoDfJuHpPSW4In1q0RGIxTmlqgMn6FSq
   ij4ysQ145kfHzboLfUt40fcH8JiU1yMbhh6QEq9rHKCHVWDDzELYP6BH2
   ptL8K0T5z6Hjy4YdUrqPsZC7nZb4R4Vn0B9rKpNp+nhIcy67k59AvEizw
   O9HHj+oa5cbBiQs6JGCOHawaHeom8YU17KoODpcNyWVZI4oVerwTvN1V3
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10364"; a="272935283"
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="272935283"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="645164729"
Received: from maciejwo-mobl1.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.36.207])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 12:40:56 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v4 19/22] x86/virt/tdx: Configure global KeyID on all packages
Date:   Wed,  1 Jun 2022 07:39:42 +1200
Message-Id: <1efdd2576917551d30fa3ef1faa62e761c12678d.1654025431.git.kai.huang@intel.com>
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

After the array of TDMRs and the global KeyID are configured to the TDX
module, use TDH.SYS.KEY.CONFIG to configure the key of the global KeyID
on all packages.

TDH.SYS.KEY.CONFIG must be done on one (any) cpu for each package.  And
it cannot run concurrently on different CPUs.  Implement a helper to
run SEAMCALL on one cpu for each package one by one, and use it to
configure the global KeyID on all packages.

Intel hardware doesn't guarantee cache coherency across different
KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
with KeyID 0) before the TDX module uses the global KeyID to access the
PAMT.  Following the TDX module specification, flush cache before
configuring the global KeyID on all packages.

Given the PAMT size can be large (~1/256th of system RAM), just use
WBINVD on all CPUs to flush.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 83 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7d49531e8e0b..0a59b196787a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -200,6 +200,46 @@ static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
 	on_each_cpu(seamcall_smp_call_function, sc, true);
 }
 
+/*
+ * Call one SEAMCALL on one (any) cpu for each physical package in
+ * serialized way.  Return immediately in case of any error if
+ * SEAMCALL fails on any cpu.
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
 /*
  * Do TDX module global initialization.  It also detects whether the
  * module has been loaded or not.
@@ -970,6 +1010,21 @@ static int config_tdx_module(struct tdmr_info *tdmr_array, int tdmr_num,
 	return ret ? -EFAULT : 0;
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
 /*
  * Detect and initialize the TDX module.
  *
@@ -1042,15 +1097,39 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
+	/*
+	 * Hardware doesn't guarantee cache coherency across different
+	 * KeyIDs.  The kernel needs to flush PAMT's dirty cachelines
+	 * (associated with KeyID 0) before the TDX module can use the
+	 * global KeyID to access the PAMT.  Given PAMTs are potentially
+	 * large (~1/256th of system RAM), just use WBINVD on all cpus
+	 * to flush the cache.
+	 *
+	 * Follow the TDX spec to flush cache before configuring the
+	 * global KeyID on all packages.
+	 */
+	wbinvd_on_all_cpus();
+
+	/* Config the key of global KeyID on all packages */
+	ret = config_global_keyid();
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
 	 */
 	ret = -EINVAL;
 out_free_pamts:
-	if (ret)
+	if (ret) {
+		/*
+		 * Part of PAMT may already have been initialized by
+		 * TDX module.  Flush cache before returning PAMT back
+		 * to the kernel.
+		 */
+		wbinvd_on_all_cpus();
 		tdmrs_free_pamt_all(tdmr_array, tdmr_num);
-	else
+	} else
 		pr_info("%lu pages allocated for PAMT.\n",
 				tdmrs_get_pamt_pages(tdmr_array, tdmr_num));
 out_free_tdmrs:
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b9bc499b965b..2d25a93b89ef 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -49,6 +49,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
-- 
2.35.3

