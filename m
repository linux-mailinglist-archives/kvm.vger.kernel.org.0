Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F976AC308
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 15:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjCFOVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 09:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjCFOUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 09:20:24 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681F27A97;
        Mon,  6 Mar 2023 06:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678112374; x=1709648374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hyIxSyvqxe/Ll/ub5N3wAG+yNxCYWUHwwuM+uOyiu2c=;
  b=UN63t7Yu6VLDuTNHxl2m46MUXADIxKmMnGWM7wbKltBy5euXzP0pqgEO
   k+n5Gt3vtX6+oicknUQ/JCCVNDVB2CX2rPUAM4ZlrcAQo42KBbHMppS2Y
   bMVJcpcCioe03LYyvyBWqhD/mAgh+/f8NBNo0Yuu+HiKwTLxqx+/xQQ/Q
   QbiPqrz9PO18qxIp/Bs0uyMOecgWAtUQEtFi9QSNs265cHBE4qTMGwldm
   d5IwqJp934Mi1RCQtkAMHNbnennVbYNl8Hr1ZTHXWkjegNwRJvPpL9Lc6
   Ko2NpzRQwj6SIqmWVEzZtx/M39wh5q+dFqgpw/ATquL1w1c2wQE3Fqui4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="337080282"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="337080282"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:15:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="765232484"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="765232484"
Received: from jwhisle1-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.92.57])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:15:27 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        david@redhat.com, bagasdotme@gmail.com, sagis@google.com,
        imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v10 13/16] x86/virt/tdx: Configure global KeyID on all packages
Date:   Tue,  7 Mar 2023 03:13:58 +1300
Message-Id: <857bc698517a66d45ef85d38efbbfb4e715bb77b.1678111292.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678111292.git.kai.huang@intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the list of TDMRs and the global KeyID are configured to the TDX
module, the kernel needs to configure the key of the global KeyID on all
packages using TDH.SYS.KEY.CONFIG.

Just use the helper, which conditionally calls function on all online
cpus, to configure the global KeyID on all packages.  Loop all online
cpus, keep track which packages have been called and skip all cpus for
those already called packages.

To keep things simple, this implementation takes no affirmative steps to
online cpus to make sure there's at least one cpu for each package.  The
callers (aka. KVM) can ensure success by ensuring that.

Intel hardware doesn't guarantee cache coherency across different
KeyIDs.  The PAMTs are transitioning from being used by the kernel
mapping (KeyId 0) to the TDX module's "global KeyID" mapping.

This means that the kernel must flush any dirty KeyID-0 PAMT cachelines
before the TDX module uses the global KeyID to access the PAMT.
Otherwise, if those dirty cachelines were written back, they would
corrupt the TDX module's metadata.  Aside: This corruption would be
detected by the memory integrity hardware on the next read of the memory
with the global KeyID.  The result would likely be fatal to the system
but would not impact TDX security.

Following the TDX module specification, flush cache before configuring
the global KeyID on all packages.  Given the PAMT size can be large
(~1/256th of system RAM), just use WBINVD on all CPUs to flush.

Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
used the global KeyID to write any PAMT.  Therefore, use WBINVD to flush
cache before freeing the PAMTs back to the kernel.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

v9 -> v10:
 - Changed to use 'smp_call_on_cpu()' directly to do key configuration.

v8 -> v9:
 - Improved changelog (Dave).
 - Improved comments to explain the function to configure global KeyID
   "takes no affirmative action to online any cpu". (Dave).
 - Improved other comments suggested by Dave.

v7 -> v8: (Dave)
 - Changelog changes:
  - Point out this is the step of "multi-steps" of init_tdx_module().
  - Removed MOVDIR64B part.
  - Other changes due to removing TDH.SYS.SHUTDOWN and TDH.SYS.LP.INIT.
 - Changed to loop over online cpus and use smp_call_function_single()
   directly as the patch to shut down TDX module has been removed.
 - Removed MOVDIR64B part in comment.

v6 -> v7:
 - Improved changelong and comment to explain why MOVDIR64B isn't used
   when returning PAMTs back to the kernel.


---
 arch/x86/virt/vmx/tdx/tdx.c | 80 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 28562cf88414..0a3b3374c5cb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1059,6 +1059,55 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	return ret;
 }
 
+static int do_global_key_config(void *data)
+{
+	/*
+	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is a
+	 * recoverable error).  Assume this is exceedingly rare and
+	 * just return error if encountered instead of retrying.
+	 *
+	 * All '0's are just unused parameters.
+	 */
+	return seamcall(TDH_SYS_KEY_CONFIG, 0, 0, 0, 0, NULL, NULL);
+}
+
+/*
+ * Attempt to configure the global KeyID on all physical packages.
+ *
+ * This requires running code on at least one CPU in each package.  If a
+ * package has no online CPUs, that code will not run and TDX module
+ * initialization (TDMR initialization) will fail.
+ *
+ * This code takes no affirmative steps to online CPUs.  Callers (aka.
+ * KVM) can ensure success by ensuring sufficient CPUs are online for
+ * this to succeed.
+ */
+static int config_global_keyid(void)
+{
+	cpumask_var_t packages;
+	int cpu, ret = -EINVAL;
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
+					packages))
+			continue;
+
+		/*
+		 * TDH.SYS.KEY.CONFIG cannot run concurrently on
+		 * different cpus, so just do it one by one.
+		 */
+		ret = smp_call_on_cpu(cpu, do_global_key_config, NULL, true);
+		if (ret)
+			break;
+	}
+
+	free_cpumask_var(packages);
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
@@ -1104,10 +1153,24 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out_free_pamts;
 
+	/*
+	 * Hardware doesn't guarantee cache coherency across different
+	 * KeyIDs.  The kernel needs to flush PAMT's dirty cachelines
+	 * (associated with KeyID 0) before the TDX module can use the
+	 * global KeyID to access the PAMT.  Given PAMTs are potentially
+	 * large (~1/256th of system RAM), just use WBINVD on all cpus
+	 * to flush the cache.
+	 */
+	wbinvd_on_all_cpus();
+
+	/* Config the key of global KeyID on all packages */
+	ret = config_global_keyid();
+	if (ret)
+		goto out_free_pamts;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Configure the global KeyID on all packages.
 	 *  - Initialize all TDMRs.
 	 *
 	 *  Return error before all steps are done.
@@ -1115,8 +1178,18 @@ static int init_tdx_module(void)
 
 	ret = -EINVAL;
 out_free_pamts:
-	if (ret)
+	if (ret) {
+		/*
+		 * Part of PAMT may already have been initialized by the
+		 * TDX module.  Flush cache before returning PAMT back
+		 * to the kernel.
+		 *
+		 * No need to worry about integrity checks here.  KeyID
+		 * 0 has integrity checking disabled.
+		 */
+		wbinvd_on_all_cpus();
 		tdmrs_free_pamt_all(&tdmr_list);
+	}
 	else
 		pr_info("%lu KBs allocated for PAMT.\n",
 				tdmrs_count_pamt_pages(&tdmr_list) * 4);
@@ -1168,6 +1241,9 @@ static int __tdx_enable(void)
  * lock to prevent any new cpu from becoming online; 2) done both VMXON
  * and tdx_cpu_enable() on all online cpus.
  *
+ * This function requires there's at least one online cpu for each CPU
+ * package to succeed.
+ *
  * This function can be called in parallel by multiple callers.
  *
  * Return 0 if TDX is enabled successfully, otherwise error.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 6cab15184af5..880e90dedb3f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -20,6 +20,7 @@
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_INFO		32
 #define TDH_SYS_CONFIG		45
+#define TDH_SYS_KEY_CONFIG	31
 
 struct cmr_info {
 	u64	base;
-- 
2.39.2

