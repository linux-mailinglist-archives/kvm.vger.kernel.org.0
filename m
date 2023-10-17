Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A267CC060
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbjJQKQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343702AbjJQKQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:16:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E38E129;
        Tue, 17 Oct 2023 03:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697537754; x=1729073754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e1uTa2H5Z7R0c9eEVYABnYt1akVnOfTLvml2iXOGIs0=;
  b=d3J4BfEBJ2rKottUtWX5Wknnf47ouxu+11r3bxSLJCPwMrlq5skedZvc
   q6mWsT+usBWKRTfHABlkprDP2qxGTb/f+spH+Gdi5bEAEEUsWdd9FniL/
   jVWb++TKiXh1L+dYWJfsrS/babJaO2s+RlVAMoO8CilApfrAy3WvfhdfE
   3XtCsP4SvTVVzs8uOUrCfuTEzxnWXqoOk94FNU6aM0ZGAns07TsZEwuwv
   pHIwR5FfhWPR4i8joyEWeTsd9ItwlyBvEADvTyxOY4L/d2JBOTsCDUjVR
   0bOxtWt4Z0j7xmyyR5ujRrwYbTgRTVEERpmJ3tNLlGzpZZIVGRLyHIyE2
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="452226840"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="452226840"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:15:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="872503578"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="872503578"
Received: from chowe-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.64])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 03:15:47 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, peterz@infradead.org,
        tony.luck@intel.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, rafael@kernel.org, david@redhat.com,
        dan.j.williams@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v14 08/23] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Tue, 17 Oct 2023 23:14:32 +1300
Message-ID: <8c4f4f25ab24aa7267e3274b756a3cbc082f49d0.1697532085.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1697532085.git.kai.huang@intel.com>
References: <cover.1697532085.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Start to transit out the "multi-steps" to initialize the TDX module.

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, TDX introduced the concept of a "Convertible Memory Region"
(CMR).  During boot, the firmware builds a list of all of the memory
ranges which can provide the TDX security guarantees.

CMRs tell the kernel which memory is TDX compatible.  The kernel takes
CMRs (plus a little more metadata) and constructs "TD Memory Regions"
(TDMRs).  TDMRs let the kernel grant TDX protections to some or all of
the CMR areas.

The TDX module also reports necessary information to let the kernel
build TDMRs and run TDX guests in structure 'tdsysinfo_struct'.  The
list of CMRs, along with the TDX module information, is available to
the kernel by querying the TDX module.

As a preparation to construct TDMRs, get the TDX module information and
the list of CMRs.  Print out CMRs to help user to decode which memory
regions are TDX convertible.

The 'tdsysinfo_struct' is fairly large (1024 bytes) and contains a lot
of info about the TDX module.  Fully define the entire structure, but
only use the fields necessary to build the TDMRs and pr_info() some
basics about the module.  The rest of the fields will get used by KVM.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v13 -> v14:
 - Added Kirill's tag.

v12 -> v13:
 - Allocate TDSYSINFO and CMR array separately. (Kirill)
 - Added comment around TDH.SYS.INFO. (Peter)

v11 -> v12:
 - Changed to use dynamic allocation for TDSYSINFO_STRUCT and CMR array
   (Kirill).
 - Keep SEAMCALL leaf macro definitions in order (Kirill)
 - Removed is_cmr_empty() but open code directly (David)
 - 'atribute' -> 'attribute' (David)

v10 -> v11:
 - No change.

v9 -> v10:
 - Added back "start to transit out..." as now per-cpu init has been
   moved out from tdx_enable().

v8 -> v9:
 - Removed "start to trransit out ..." part in changelog since this patch
   is no longer the first step anymore.
 - Changed to declare 'tdsysinfo' and 'cmr_array' as local static, and
   changed changelog accordingly (Dave).
 - Improved changelog to explain why to declare  'tdsysinfo_struct' in
   full but only use a few members of them (Dave).

v7 -> v8: (Dave)
 - Improved changelog to tell this is the first patch to transit out the
   "multi-steps" init_tdx_module().
 - Removed all CMR check/trim code but to depend on later SEAMCALL.
 - Variable 'vertical alignment' in print TDX module information.
 - Added DECLARE_PADDED_STRUCT() for padded structure.
 - Made tdx_sysinfo and tdx_cmr_array[] to be function local variable
   (and rename them accordingly), and added -Wframe-larger-than=4096 flag
   to silence the build warning.

 ...

---
 arch/x86/virt/vmx/tdx/tdx.c | 94 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h | 64 +++++++++++++++++++++++++
 2 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 36db33133cd5..b18f1e9c92dc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -16,8 +16,11 @@
 #include <linux/spinlock.h>
 #include <linux/percpu-defs.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/math.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/page.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -162,12 +165,91 @@ int tdx_cpu_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_cpu_enable);
 
+static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
+{
+	int i;
+
+	for (i = 0; i < nr_cmrs; i++) {
+		struct cmr_info *cmr = &cmr_array[i];
+
+		/*
+		 * The array of CMRs reported via TDH.SYS.INFO can
+		 * contain tail empty CMRs.  Don't print them.
+		 */
+		if (!cmr->size)
+			break;
+
+		pr_info("CMR: [0x%llx, 0x%llx)\n", cmr->base,
+				cmr->base + cmr->size);
+	}
+}
+
+static int get_tdx_sysinfo(struct tdsysinfo_struct *tdsysinfo,
+			   struct cmr_info *cmr_array)
+{
+	struct tdx_module_args args = {};
+	int ret;
+
+	/*
+	 * TDH.SYS.INFO writes the TDSYSINFO_STRUCT and the CMR array
+	 * to the buffers provided by the kernel (via RCX and R8
+	 * respectively).  The buffer size of the TDSYSINFO_STRUCT
+	 * (via RDX) and the maximum entries of the CMR array (via R9)
+	 * passed to this SEAMCALL must be at least the size of
+	 * TDSYSINFO_STRUCT and MAX_CMRS respectively.
+	 *
+	 * Upon a successful return, R9 contains the actual entries
+	 * written to the CMR array.
+	 */
+	args.rcx = __pa(tdsysinfo);
+	args.rdx = TDSYSINFO_STRUCT_SIZE;
+	args.r8 = __pa(cmr_array);
+	args.r9 = MAX_CMRS;
+	ret = seamcall_prerr_ret(TDH_SYS_INFO, &args);
+	if (ret)
+		return ret;
+
+	pr_info("TDX module: attributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
+		tdsysinfo->attributes,    tdsysinfo->vendor_id,
+		tdsysinfo->major_version, tdsysinfo->minor_version,
+		tdsysinfo->build_date,    tdsysinfo->build_num);
+
+	print_cmrs(cmr_array, args.r9);
+
+	return 0;
+}
+
 static int init_tdx_module(void)
 {
+	struct tdsysinfo_struct *tdsysinfo;
+	struct cmr_info *cmr_array;
+	int tdsysinfo_size;
+	int cmr_array_size;
+	int ret;
+
+	tdsysinfo_size = round_up(TDSYSINFO_STRUCT_SIZE,
+			TDSYSINFO_STRUCT_ALIGNMENT);
+	tdsysinfo = kzalloc(tdsysinfo_size, GFP_KERNEL);
+	if (!tdsysinfo)
+		return -ENOMEM;
+
+	cmr_array_size = sizeof(struct cmr_info) * MAX_CMRS;
+	cmr_array_size = round_up(cmr_array_size, CMR_INFO_ARRAY_ALIGNMENT);
+	cmr_array = kzalloc(cmr_array_size, GFP_KERNEL);
+	if (!cmr_array) {
+		kfree(tdsysinfo);
+		return -ENOMEM;
+	}
+
+
+	/* Get the TDSYSINFO_STRUCT and CMRs from the TDX module. */
+	ret = get_tdx_sysinfo(tdsysinfo, cmr_array);
+	if (ret)
+		goto out;
+
 	/*
 	 * TODO:
 	 *
-	 *  - Get TDX module information and TDX-capable memory regions.
 	 *  - Build the list of TDX-usable memory regions.
 	 *  - Construct a list of "TD Memory Regions" (TDMRs) to cover
 	 *    all TDX-usable memory regions.
@@ -177,7 +259,15 @@ static int init_tdx_module(void)
 	 *
 	 *  Return error before all steps are done.
 	 */
-	return -EINVAL;
+	ret = -EINVAL;
+out:
+	/*
+	 * For now both @sysinfo and @cmr_array are only used during
+	 * module initialization, so always free them.
+	 */
+	kfree(tdsysinfo);
+	kfree(cmr_array);
+	return ret;
 }
 
 static int __tdx_enable(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a3c52270df5b..fff36af71448 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -2,6 +2,10 @@
 #ifndef _X86_VIRT_TDX_H
 #define _X86_VIRT_TDX_H
 
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler_attributes.h>
+
 /*
  * This file contains both macros and data structures defined by the TDX
  * architecture and Linux defined software data structures and functions.
@@ -12,9 +16,69 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 
+struct cmr_info {
+	u64	base;
+	u64	size;
+} __packed;
+
+#define MAX_CMRS	32
+#define CMR_INFO_ARRAY_ALIGNMENT	512
+
+struct cpuid_config {
+	u32	leaf;
+	u32	sub_leaf;
+	u32	eax;
+	u32	ebx;
+	u32	ecx;
+	u32	edx;
+} __packed;
+
+#define TDSYSINFO_STRUCT_SIZE		1024
+#define TDSYSINFO_STRUCT_ALIGNMENT	1024
+
+/*
+ * The size of this structure itself is flexible.  The actual structure
+ * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE bytes
+ * and TDSYSINFO_STRUCT_ALIGNMENT bytes aligned.
+ */
+struct tdsysinfo_struct {
+	/* TDX-SEAM Module Info */
+	u32	attributes;
+	u32	vendor_id;
+	u32	build_date;
+	u16	build_num;
+	u16	minor_version;
+	u16	major_version;
+	u8	reserved0[14];
+	/* Memory Info */
+	u16	max_tdmrs;
+	u16	max_reserved_per_tdmr;
+	u16	pamt_entry_size;
+	u8	reserved1[10];
+	/* Control Struct Info */
+	u16	tdcs_base_size;
+	u8	reserved2[2];
+	u16	tdvps_base_size;
+	u8	tdvps_xfam_dependent_size;
+	u8	reserved3[9];
+	/* TD Capabilities */
+	u64	attributes_fixed0;
+	u64	attributes_fixed1;
+	u64	xfam_fixed0;
+	u64	xfam_fixed1;
+	u8	reserved4[32];
+	u32	num_cpuid_config;
+	/*
+	 * The actual number of CPUID_CONFIG depends on above
+	 * 'num_cpuid_config'.
+	 */
+	DECLARE_FLEX_ARRAY(struct cpuid_config, cpuid_configs);
+} __packed;
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.41.0

