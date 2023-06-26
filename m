Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF2173E1D1
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjFZOQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjFZOQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:16:07 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE52D19B7;
        Mon, 26 Jun 2023 07:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788936; x=1719324936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ICV6BLRH+DXa0G/pBwxcns0kdCV9sy111ORM4w+kuUQ=;
  b=gj0Z7r3k02+WKh8qmLlVqitDb9NcnvrURRISMsTzDgqMQNDnH8YX6SBu
   F5v15vjoA9n+D9fnUcfMt8d4feVThgJ1g8gqHVVeAQ0lHZ/CmH1fAfVJ4
   SnERRxRcA98sO11WNlXTkQ80gwCpnmHnOsPYxujZYFrd9FIl69WCA+GaV
   rwikTlMeryVf6/v8pEiwqLlxB4bgC+JyEHlRMzVm0GHoaT55AeWlv45IF
   sneI3X/4PpT0zRNf7kBJM9iYs77MYpLWxx8WEjZcDLHBwi5KByPwSXxOG
   +Pm00QlfEwhYPVCFcEITbR5XOH4u9bJCCiFh+X91p2dYc+UnNiIVPoZog
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346033973"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346033973"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292413"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292413"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:15:09 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v12 15/22] x86/virt/tdx: Configure global KeyID on all packages
Date:   Tue, 27 Jun 2023 02:12:45 +1200
Message-Id: <0c5a74c4c3aeac57b623c98d456aa059f833ebdd.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
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

After the list of TDMRs and the global KeyID are configured to the TDX
module, the kernel needs to configure the key of the global KeyID on all
packages using TDH.SYS.KEY.CONFIG.

This SEAMCALL cannot run parallel on different cpus.  Loop all online
cpus and use smp_call_on_cpu() to call this SEAMCALL on the first cpu of
each package.

To keep things simple, this implementation takes no affirmative steps to
online cpus to make sure there's at least one cpu for each package.  The
callers (aka. KVM) can ensure success by ensuring sufficient CPUs are
online for this to succeed.

Intel hardware doesn't guarantee cache coherency across different
KeyIDs.  The PAMTs are transitioning from being used by the kernel
mapping (KeyId 0) to the TDX module's "global KeyID" mapping.

This means that the kernel must flush any dirty KeyID-0 PAMT cachelines
before the TDX module uses the global KeyID to access the PAMTs.
Otherwise, if those dirty cachelines were written back, they would
corrupt the TDX module's metadata.  Aside: This corruption would be
detected by the memory integrity hardware on the next read of the memory
with the global KeyID.  The result would likely be fatal to the system
but would not impact TDX security.

Following the TDX module specification, flush cache before configuring
the global KeyID on all packages.  Given the PAMT size can be large
(~1/256th of system RAM), just use WBINVD on all CPUs to flush.

If TDH.SYS.KEY.CONFIG fails, the TDX module may already have used the
global KeyID to write the PAMTs.  Therefore, use WBINVD to flush cache
before returning the PAMTs back to the kernel.  Also convert all PAMTs
back to normal by using MOVDIR64B as suggested by the TDX module spec,
although on the platform without the "partial write machine check"
erratum it's OK to leave PAMTs as is.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v11 -> v12:
 - Added Kirill's tag
 - Improved changelog (Nikolay)

v10 -> v11:
 - Convert PAMTs back to normal when module initialization fails.
 - Fixed an error in changelog

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
 arch/x86/virt/vmx/tdx/tdx.c | 135 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |   1 +
 2 files changed, 134 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 1992245290de..f5d4dbc11aee 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -31,6 +31,7 @@
 #include <asm/msr.h>
 #include <asm/archrandom.h>
 #include <asm/page.h>
+#include <asm/special_insns.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -577,7 +578,8 @@ static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_base,
 	*pamt_size = pamt_sz;
 }
 
-static void tdmr_free_pamt(struct tdmr_info *tdmr)
+static void tdmr_do_pamt_func(struct tdmr_info *tdmr,
+		void (*pamt_func)(unsigned long base, unsigned long size))
 {
 	unsigned long pamt_base, pamt_size;
 
@@ -590,9 +592,19 @@ static void tdmr_free_pamt(struct tdmr_info *tdmr)
 	if (WARN_ON_ONCE(!pamt_base))
 		return;
 
+	(*pamt_func)(pamt_base, pamt_size);
+}
+
+static void free_pamt(unsigned long pamt_base, unsigned long pamt_size)
+{
 	free_contig_range(pamt_base >> PAGE_SHIFT, pamt_size >> PAGE_SHIFT);
 }
 
+static void tdmr_free_pamt(struct tdmr_info *tdmr)
+{
+	tdmr_do_pamt_func(tdmr, free_pamt);
+}
+
 static void tdmrs_free_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
@@ -621,6 +633,41 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
 	return ret;
 }
 
+/*
+ * Convert TDX private pages back to normal by using MOVDIR64B to
+ * clear these pages.  Note this function doesn't flush cache of
+ * these TDX private pages.  The caller should make sure of that.
+ */
+static void reset_tdx_pages(unsigned long base, unsigned long size)
+{
+	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
+	unsigned long phys, end;
+
+	end = base + size;
+	for (phys = base; phys < end; phys += 64)
+		movdir64b(__va(phys), zero_page);
+
+	/*
+	 * MOVDIR64B uses WC protocol.  Use memory barrier to
+	 * make sure any later user of these pages sees the
+	 * updated data.
+	 */
+	mb();
+}
+
+static void tdmr_reset_pamt(struct tdmr_info *tdmr)
+{
+	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
+}
+
+static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
+{
+	int i;
+
+	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
+		tdmr_reset_pamt(tdmr_entry(tdmr_list, i));
+}
+
 static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
 {
 	unsigned long pamt_size = 0;
@@ -898,6 +945,55 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
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
 	struct tdsysinfo_struct *sysinfo;
@@ -956,15 +1052,47 @@ static int init_tdx_module(void)
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
+		goto out_reset_pamts;
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
+out_reset_pamts:
+	if (ret) {
+		/*
+		 * Part of PAMTs may already have been initialized by the
+		 * TDX module.  Flush cache before returning PAMTs back
+		 * to the kernel.
+		 */
+		wbinvd_on_all_cpus();
+		/*
+		 * According to the TDX hardware spec, if the platform
+		 * doesn't have the "partial write machine check"
+		 * erratum, any kernel read/write will never cause #MC
+		 * in kernel space, thus it's OK to not convert PAMTs
+		 * back to normal.  But do the conversion anyway here
+		 * as suggested by the TDX spec.
+		 */
+		tdmrs_reset_pamt_all(&tdmr_list);
+	}
 out_free_pamts:
 	if (ret)
 		tdmrs_free_pamt_all(&tdmr_list);
@@ -1019,6 +1147,9 @@ static int __tdx_enable(void)
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
index c386aa3afe2a..a0438513bec0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -21,6 +21,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
-- 
2.40.1

