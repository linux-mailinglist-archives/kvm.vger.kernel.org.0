Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD8C647E1E
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiLIG4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiLIG4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:56:03 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38684AE4D3;
        Thu,  8 Dec 2022 22:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568867; x=1702104867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r1pswkKPmCuwe3o1L5UTwD6LpxkqI/Lu1UdlGzXTNBc=;
  b=D1JJT1gvcmgonF/O8kBB5LqYwixtDGOeOEA6/s5dkUgdQPk0g/JaMSKR
   7Jxfjth4kBvq4yDlOb570R1A9/RHROsL/ZyerNgSDViiXtre/91jS7Tld
   Vr8X417UAybuRmYArEUQDL/PCLBqpuJN0N8uJ5fuPyG8PqinP/uWZZA+S
   5KnikKilupFwZi2o5wsRwJ4VpTC+92vgZesZxLO+LyFCzhz/O+kDkX6K8
   B6Y8cOrsSS2kbDUUcNSMTiwQyfNhxzuBReTnG1TtatKuMzVoEFILR95O8
   gJlJgzCjarQ85LIDBzfcZWVzdrIggrKCxlBWoAIErmjUjKxG0WfIpP0iE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551477"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551477"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679837108"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679837108"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:54:02 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, dave.hansen@intel.com, peterz@infradead.org,
        tglx@linutronix.de, seanjc@google.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, rafael.j.wysocki@intel.com,
        kirill.shutemov@linux.intel.com, ying.huang@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, ak@linux.intel.com, isaku.yamahata@intel.com,
        chao.gao@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v8 13/16] x86/virt/tdx: Configure global KeyID on all packages
Date:   Fri,  9 Dec 2022 19:52:34 +1300
Message-Id: <383a2fb52a36d1e772bc547c289c5aeb8ea5d9cb.1670566861.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670566861.git.kai.huang@intel.com>
References: <cover.1670566861.git.kai.huang@intel.com>
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

TDH.SYS.KEY.CONFIG needs to be done on one (any) cpu for each package.
Also, it cannot run concurrently on different cpus, so just use
smp_call_function_single() to do it one by one.

Note to keep things simple, neither the function to configure the global
KeyID on all packages nor the tdx_enable() checks whether there's at
least one online cpu for each package.  Also, neither of them explicitly
prevents any cpu from going offline.  It is caller's responsibility to
guarantee this.

Intel hardware doesn't guarantee cache coherency across different
KeyIDs.  The kernel needs to flush PAMT's dirty cachelines (associated
with KeyID 0) before the TDX module uses the global KeyID to access the
PAMT.  Otherwise, those dirty cachelines can silently corrupt the TDX
module's metadata.  Note this breaks TDX from functionality point of
view but TDX's security remains intact.

Following the TDX module specification, flush cache before configuring
the global KeyID on all packages.  Given the PAMT size can be large
(~1/256th of system RAM), just use WBINVD on all CPUs to flush.

Note if any TDH.SYS.KEY.CONFIG fails, the TDX module may already have
used the global KeyID to write any PAMT.  Therefore, need to use WBINVD
to flush cache before freeing the PAMTs back to the kernel.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 97 +++++++++++++++++++++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 2 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ab961443fed5..4c779e8412f1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -946,6 +946,66 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	return ret;
 }
 
+static void do_global_key_config(void *data)
+{
+	int ret;
+
+	/*
+	 * TDH.SYS.KEY.CONFIG may fail with entropy error (which is a
+	 * recoverable error).  Assume this is exceedingly rare and
+	 * just return error if encountered instead of retrying.
+	 */
+	ret = seamcall(TDH_SYS_KEY_CONFIG, 0, 0, 0, 0, NULL, NULL);
+
+	*(int *)data = ret;
+}
+
+/*
+ * Configure the global KeyID on all packages by doing TDH.SYS.KEY.CONFIG
+ * on one online cpu for each package.  If any package doesn't have any
+ * online
+ *
+ * Note:
+ *
+ * This function neither checks whether there's at least one online cpu
+ * for each package, nor explicitly prevents any cpu from going offline.
+ * If any package doesn't have any online cpu then the SEAMCALL won't be
+ * done on that package and the later step of TDX module initialization
+ * will fail.  The caller needs to guarantee this.
+ */
+static int config_global_keyid(void)
+{
+	cpumask_var_t packages;
+	int cpu, ret = 0;
+
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	for_each_online_cpu(cpu) {
+		int err;
+
+		if (cpumask_test_and_set_cpu(topology_physical_package_id(cpu),
+					packages))
+			continue;
+
+		/*
+		 * TDH.SYS.KEY.CONFIG cannot run concurrently on
+		 * different cpus, so just do it one by one.
+		 */
+		ret = smp_call_function_single(cpu, do_global_key_config, &err,
+				true);
+		if (ret)
+			break;
+		if (err) {
+			ret = err;
+			break;
+		}
+	}
+
+	free_cpumask_var(packages);
+	return ret;
+}
+
 static int init_tdx_module(void)
 {
 	/*
@@ -998,19 +1058,46 @@ static int init_tdx_module(void)
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
 	 * TODO:
 	 *
-	 *  - Configure the global KeyID on all packages.
 	 *  - Initialize all TDMRs.
 	 *
 	 *  Return error before all steps are done.
 	 */
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
+
 		tdmrs_free_pamt_all(&tdmr_list);
-	else
+	} else
 		pr_info("%lu pages allocated for PAMT.\n",
 				tdmrs_count_pamt_pages(&tdmr_list));
 out_free_tdmrs:
@@ -1057,7 +1144,9 @@ static int __tdx_enable(void)
  * tdx_enable - Enable TDX by initializing the TDX module
  *
  * The caller must make sure all online cpus are in VMX operation before
- * calling this function.
+ * calling this function.  Also, the caller must make sure there is at
+ * least one online cpu for each package, and to prevent any cpu from
+ * going offline during this function.
  *
  * This function can be called in parallel by multiple callers.
  *
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4d2edd477480..f5c12a2543d4 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -19,6 +19,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_CONFIG		45
 
-- 
2.38.1

