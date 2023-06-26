Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173D473E1BD
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjFZOPN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjFZOOz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:14:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DF210C6;
        Mon, 26 Jun 2023 07:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788867; x=1719324867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ixw5+FCRyQHe1x1K29AuSwyiCMpy80rpmMrG2obNERo=;
  b=XRrLSCijnxsq4FI22RHIIAcZMIu+eYh26ZQO8Z4yAnfsq3T5HLRh6ylR
   W6I0BUrjPo0zo3S0Gczkb45OWkNtQM9VgfJhNopyg5kQTrfW5Pk/HeerL
   BHahJAWf7oC4SO/FJpBAzStzCP8MTFnmNMrKkR3+PQV4u5/8tffOyWlpS
   ZNNaGIFoOMcVJxSQstmvzt2+ddr/6uvKbImUzZ/nF9wYc0xJSEj/4d1Zv
   Ltk5f8hSf34b6S+MQ8yawnYhdKlihUrDBm7OTUu5jWT7qw3niv3ocRTlz
   Q9PUIebiHbOXz8EYK4Vnj1+Xfs5u9UriakryLChJAVBjDFRJIR0EvhJ4H
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346033732"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346033732"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292329"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292329"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:20 -0700
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
Subject: [PATCH v12 08/22] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Tue, 27 Jun 2023 02:12:38 +1200
Message-Id: <a33f372df345f6232b55e26d498ea67d4adc18f0.1687784645.git.kai.huang@intel.com>
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
---

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

v6 -> v7:
 - Simplified the check of CMRs due to the fact that TDX actually
   verifies CMRs (that are passed by the BIOS) before enabling TDX.
 - Changed the function name from check_cmrs() -> trim_empty_cmrs().
 - Added CMR page aligned check so that later patch can just get the PFN
   using ">> PAGE_SHIFT".

v5 -> v6:
 - Added to also print TDX module's attribute (Isaku).
 - Removed all arguments in tdx_gete_sysinfo() to use static variables
   of 'tdx_sysinfo' and 'tdx_cmr_array' directly as they are all used
   directly in other functions in later patches.
 - Added Isaku's Reviewed-by.

- v3 -> v5 (no feedback on v4):
 - Renamed sanitize_cmrs() to check_cmrs().
 - Removed unnecessary sanity check against tdx_sysinfo and tdx_cmr_array
   actual size returned by TDH.SYS.INFO.
 - Changed -EFAULT to -EINVAL in couple places.
 - Added comments around tdx_sysinfo and tdx_cmr_array saying they are
   used by TDH.SYS.INFO ABI.
 - Changed to pass 'tdx_sysinfo' and 'tdx_cmr_array' as function
   arguments in tdx_get_sysinfo().
 - Changed to only print BIOS-CMR when check_cmrs() fails.


---
 arch/x86/virt/vmx/tdx/tdx.c | 79 ++++++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h | 60 ++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 29ca18f66d61..a2129cbe056e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -20,6 +20,7 @@
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/archrandom.h>
+#include <asm/page.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -159,12 +160,79 @@ int tdx_cpu_enable(void)
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
+static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
+			   struct cmr_info *cmr_array)
+{
+	struct tdx_module_output out;
+	u64 sysinfo_pa, cmr_array_pa;
+	int ret;
+
+	sysinfo_pa = __pa(sysinfo);
+	cmr_array_pa = __pa(cmr_array);
+	ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,
+			cmr_array_pa, MAX_CMRS, NULL, &out);
+	if (ret)
+		return ret;
+
+	pr_info("TDX module: attributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
+		sysinfo->attributes,	sysinfo->vendor_id,
+		sysinfo->major_version, sysinfo->minor_version,
+		sysinfo->build_date,	sysinfo->build_num);
+
+	/* R9 contains the actual entries written to the CMR array. */
+	print_cmrs(cmr_array, out.r9);
+
+	return 0;
+}
+
 static int init_tdx_module(void)
 {
+	struct tdsysinfo_struct *sysinfo;
+	struct cmr_info *cmr_array;
+	int ret;
+
+	/*
+	 * Get the TDSYSINFO_STRUCT and CMRs from the TDX module.
+	 *
+	 * The buffers of the TDSYSINFO_STRUCT and the CMR array passed
+	 * to the TDX module must be 1024-bytes and 512-bytes aligned
+	 * respectively.  Allocate one page to accommodate them both and
+	 * also meet those alignment requirements.
+	 */
+	sysinfo = (struct tdsysinfo_struct *)__get_free_page(GFP_KERNEL);
+	if (!sysinfo)
+		return -ENOMEM;
+	cmr_array = (struct cmr_info *)((unsigned long)sysinfo + PAGE_SIZE / 2);
+
+	BUILD_BUG_ON(PAGE_SIZE / 2 < TDSYSINFO_STRUCT_SIZE);
+	BUILD_BUG_ON(PAGE_SIZE / 2 < sizeof(struct cmr_info) * MAX_CMRS);
+
+	ret = tdx_get_sysinfo(sysinfo, cmr_array);
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
@@ -174,7 +242,14 @@ static int init_tdx_module(void)
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
+	free_page((unsigned long)sysinfo);
+	return ret;
 }
 
 static int __tdx_enable(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 9fb46033c852..8ab2d40971ea 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -3,6 +3,8 @@
 #define _X86_VIRT_TDX_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler_attributes.h>
 
 /*
  * This file contains both macros and data structures defined by the TDX
@@ -19,9 +21,67 @@
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
+
+/*
+ * The size of this structure itself is flexible.  The actual structure
+ * passed to TDH.SYS.INFO must be padded to 1024 bytes and be 1204-bytes
+ * aligned.
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
2.40.1

