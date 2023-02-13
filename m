Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC45694526
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbjBMMDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjBMMDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:03:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDDB1A65F;
        Mon, 13 Feb 2023 04:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289765; x=1707825765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gV7imOVz4HnigCq8Nw4/g/zyr45AbaY82hHOJD6E8Zc=;
  b=hFiIdds5XwTNqZMnXojK/Tll4v20XiFm+4vpBYbciutvugvBLlbSRLx9
   mPx9gZ1uDLCwzciwLeCsAtEU72MLPsroa5kcq+fDzO7u1QHuTvV3YvsTa
   VT9m+vu+o4nLN+SY3mKUYFqyM5LFqAia2Ct74Nut9Q7aFB71y+BuevRgY
   EXQnIU0w06BI/8pqLDQ0DgPW2hQoYBEF/HjbLWeqJVNqLS1ZyylGR9rzj
   1rW8ts0ujf65nbb40jX6lVXUhprpGvo0lWdjOI8kn+9U+Tv289kc84PoE
   BKgsSsqBf4XgYYFPCP7nFzLsaNZHvl6J4rNvj6aGZF+K1yqKm39YtCeem
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283487"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283487"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243521"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243521"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:01:27 -0800
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
Subject: [PATCH v9 15/18] x86/virt/tdx: Configure global KeyID on all packages
Date:   Tue, 14 Feb 2023 00:59:22 +1300
Message-Id: <d78c2dc83a6e1623707eaf35b7bcbb3a95cd0d3b.1676286526.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1676286526.git.kai.huang@intel.com>
References: <cover.1676286526.git.kai.huang@intel.com>
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
 arch/x86/virt/vmx/tdx/tdx.c | 92 ++++++++++++++++++++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5a4163d40f58..ff6f2c9d9838 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1031,6 +1031,61 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	return ret;
 }
 
+static int smp_func_config_global_keyid(void *data)
+{
+	cpumask_var_t packages = data;
+	int pkg, ret;
+
+	pkg = topology_physical_package_id(smp_processor_id());
+
+	/*
+	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is a
+	 * recoverable error).  Assume this is exceedingly rare and
+	 * just return error if encountered instead of retrying.
+	 *
+	 * All '0's are just unused parameters.
+	 */
+	ret = seamcall(TDH_SYS_KEY_CONFIG, 0, 0, 0, 0, NULL, NULL);
+	if (!ret)
+		cpumask_set_cpu(pkg, packages);
+
+	return ret;
+}
+
+static bool skip_func_config_global_keyid(int cpu, void *data)
+{
+	cpumask_var_t packages = data;
+
+	return cpumask_test_cpu(topology_physical_package_id(cpu),
+			packages);
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
+	int ret;
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = tdx_on_each_cpu_cond(smp_func_config_global_keyid, packages,
+			skip_func_config_global_keyid, packages);
+
+	free_cpumask_var(packages);
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
@@ -1100,10 +1155,24 @@ static int init_tdx_module(void)
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
@@ -1111,8 +1180,18 @@ static int init_tdx_module(void)
 
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
 		tdmrs_free_pamt_all(&tdx_tdmr_list);
+	}
 	else
 		pr_info("%lu KBs allocated for PAMT.\n",
 				tdmrs_count_pamt_pages(&tdx_tdmr_list) * 4);
@@ -1166,11 +1245,7 @@ static int __tdx_enable(void)
  */
 static void disable_tdx_module(void)
 {
-	/*
-	 * TODO: module clean up in reverse to steps in
-	 * init_tdx_module().  Remove this comment after
-	 * all steps are done.
-	 */
+	wbinvd_on_all_cpus();
 	tdmrs_free_pamt_all(&tdx_tdmr_list);
 	free_tdmr_list(&tdx_tdmr_list);
 	free_tdx_memlist(&tdx_memlist);
@@ -1228,6 +1303,9 @@ static int __tdx_enable_online_cpus(void)
  * This function internally calls cpus_read_lock()/unlock() to prevent
  * any cpu from going online and offline.
  *
+ * This function requires there's at least one online cpu for each CPU
+ * package to succeed.
+ *
  * This function assumes all online cpus are already in VMX operation.
  *
  * This function can be called in parallel by multiple callers.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 7b34ac257b9a..ca4e2edbf4bc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -16,6 +16,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_CONFIG		45
 
-- 
2.39.1

