Return-Path: <kvm+bounces-1334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 46ED37E6A15
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:57:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EABF72815D4
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30511DA35;
	Thu,  9 Nov 2023 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZQ7w78o"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83E81DA27
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:57:50 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ED435B7;
	Thu,  9 Nov 2023 03:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531070; x=1731067070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RwhsHIfndC/kgfS0lpvceqOtYlRuwQY+/PqF7bSkrMk=;
  b=KZQ7w78oUY/R0PGaMwwqXJhrFUir38rIwK8/C9EBYWKdbuZ/Pa++Lbu7
   Pf5ALN0uyZNVqwoT0ZE+F0FB43mi+tMkV/rxMvwzJsHQLxulY9I2/2uTj
   VC6PtGXOFiAJwmYY3k5bsCnUCtwB10rfek2XaMl5g3USYpbhJhjhUv+bT
   QhMj13tHPVcW10VGaeYsyuruv1TR/RXesDgMXJnryfyjtEQdqqvh/oZHk
   ekexuujZmc14ZKJJxF8owVUjHG7Q1F70b5kLfolyR2fUfyi1DzyzFn9Qd
   mq3Pb7BEVyHSWGFOlHJCIcXgOe9tQp8zGH6r4DFmXFyoy928d1H5FCY6o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936661"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936661"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766976794"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766976794"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:57:43 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 15/23] x86/virt/tdx: Configure global KeyID on all packages
Date: Fri, 10 Nov 2023 00:55:52 +1300
Message-ID: <27ae2c6407ceeab4effcf2f93454a39d9c6735e3.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---

v14 -> v15:
 - No change

v13 -> v14:
 - No change

v12 -> v13:
 - Added Yuan's tag.

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


---
 arch/x86/virt/vmx/tdx/tdx.c | 130 +++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h |   1 +
 2 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index aba851e11c72..329d233c11da 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -28,6 +28,7 @@
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
+#include <asm/special_insns.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -592,7 +593,8 @@ static void tdmr_get_pamt(struct tdmr_info *tdmr, unsigned long *pamt_base,
 	*pamt_size = pamt_sz;
 }
 
-static void tdmr_free_pamt(struct tdmr_info *tdmr)
+static void tdmr_do_pamt_func(struct tdmr_info *tdmr,
+		void (*pamt_func)(unsigned long base, unsigned long size))
 {
 	unsigned long pamt_base, pamt_size;
 
@@ -605,9 +607,19 @@ static void tdmr_free_pamt(struct tdmr_info *tdmr)
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
@@ -636,6 +648,41 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
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
@@ -915,6 +962,50 @@ static int config_tdx_module(struct tdmr_info_list *tdmr_list, u64 global_keyid)
 	return ret;
 }
 
+static int do_global_key_config(void *data)
+{
+	struct tdx_module_args args = {};
+
+	return seamcall_prerr(TDH_SYS_KEY_CONFIG, &args);
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
 	struct tdx_tdmr_sysinfo tdmr_sysinfo;
@@ -956,15 +1047,47 @@ static int init_tdx_module(void)
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
@@ -1013,6 +1136,9 @@ static int __tdx_enable(void)
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
index fa5bcf8b5a9c..dd35baf756b8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -14,6 +14,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_KEY_CONFIG	31
 #define TDH_SYS_INIT		33
 #define TDH_SYS_RD		34
 #define TDH_SYS_LP_INIT		35
-- 
2.41.0


