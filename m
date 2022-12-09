Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B89647E10
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 07:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiLIGyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 01:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiLIGyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 01:54:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D6045A3E;
        Thu,  8 Dec 2022 22:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670568811; x=1702104811;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2JieH49o0RwYeN8IspHMe+dJXCb9JWOWGaNKYRxbRaQ=;
  b=PCH1pfjXzuXN4VW/gPS1ptQpD/VlQsYpEsBQ8TQcAA6ZyPK7XCMXFYiZ
   7JwmVsz6mSJEor/sOq+QJdP7iWV/si0rZ8AL3xe5tTKZrAK0uRDzB+qP3
   flNldJJPNj2phAoBHhb+n/FNvI93X6x/FMm4oFGJNLAuEDsjw5+HjFRDD
   hT1CM2AnOamypQW+ol7nDn825D1tvLKm+COmaEJc7cgyDeFlmYQw/yF0B
   j8MewYvLv/krX6CcVRG0hzXqvEneu+IfJd6+iAtYMA4iXA7zX5bTtXD7+
   QGzExgsv5WWcNNz6gES1PV2J2rf2L+HGNIvypdR8wDSy+8mZlw5scTvyN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="318551339"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="318551339"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="679836910"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="679836910"
Received: from omiramon-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.28.82])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 22:53:26 -0800
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
Subject: [PATCH v8 06/16] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Fri,  9 Dec 2022 19:52:27 +1300
Message-Id: <7c21a3de810397901bade0b1021912bbbf2d18bd.1670566861.git.kai.huang@intel.com>
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

Start to transit out the "multi-steps" of initializing the TDX module as
listed in the skeleton infrastructure.  Do the first step to get the TDX
module information and the TDX-capable memory regions.

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

The TDX module information tells the kernel TDX module properties such
as metadata entry size, the maximum number of TDMRs, and the maximum
number of reserved areas per TDMR that the module allows, etc.

The list of CMRs, along with the TDX module information, is available to
the kernel by querying the TDX module.

For now, both the TDX module information and CMRs are only used during
the module initialization, so declare them as local.  However, they are
1024 bytes and 512 bytes respectively.  Putting them to the stack
exceeds the default "stack frame size" that the kernel assumes as safe,
and the compiler yields a warning about this.  Add a kernel build flag
to extend the safe stack size to 4K for tdx.c to silence the warning --
the initialization function is only called once so it's safe to have a
4K stack.

Note not all members in the 1024 bytes TDX module information are used
(even by the KVM).

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/Makefile |  1 +
 arch/x86/virt/vmx/tdx/tdx.c    | 85 ++++++++++++++++++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h    | 76 ++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+), 5 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 38d534f2c113..f8a40d15fdfc 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
+CFLAGS_tdx.o += -Wframe-larger-than=4096
 obj-y += tdx.o seamcall.o
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b7cedf0589db..6fe505c32599 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -13,6 +13,7 @@
 #include <linux/errno.h>
 #include <linux/printk.h>
 #include <linux/mutex.h>
+#include <asm/pgtable_types.h>
 #include <asm/msr.h>
 #include <asm/tdx.h>
 #include "tdx.h"
@@ -107,9 +108,8 @@ bool platform_tdx_enabled(void)
  * leaf function return code and the additional output respectively if
  * not NULL.
  */
-static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
-				    u64 *seamcall_ret,
-				    struct tdx_module_output *out)
+static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
+		    u64 *seamcall_ret, struct tdx_module_output *out)
 {
 	u64 sret;
 
@@ -150,12 +150,85 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	}
 }
 
+static inline bool is_cmr_empty(struct cmr_info *cmr)
+{
+	return !cmr->size;
+}
+
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
+		if (is_cmr_empty(cmr))
+			break;
+
+		pr_info("CMR: [0x%llx, 0x%llx)\n", cmr->base,
+				cmr->base + cmr->size);
+	}
+}
+
+/*
+ * Get the TDX module information (TDSYSINFO_STRUCT) and the array of
+ * CMRs, and save them to @sysinfo and @cmr_array, which come from the
+ * kernel stack.  @sysinfo must have been padded to have enough room
+ * to save the TDSYSINFO_STRUCT.
+ */
+static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
+			   struct cmr_info *cmr_array)
+{
+	struct tdx_module_output out;
+	u64 sysinfo_pa, cmr_array_pa;
+	int ret;
+
+	/*
+	 * Cannot use __pa() directly as @sysinfo and @cmr_array
+	 * come from the kernel stack.
+	 */
+	sysinfo_pa = slow_virt_to_phys(sysinfo);
+	cmr_array_pa = slow_virt_to_phys(cmr_array);
+	ret = seamcall(TDH_SYS_INFO, sysinfo_pa, TDSYSINFO_STRUCT_SIZE,
+			cmr_array_pa, MAX_CMRS, NULL, &out);
+	if (ret)
+		return ret;
+
+	pr_info("TDX module: atributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
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
+	/*
+	 * @tdsysinfo and @cmr_array are used in TDH.SYS.INFO SEAMCALL ABI.
+	 * They are 1024 bytes and 512 bytes respectively but it's fine to
+	 * keep them in the stack as this function is only called once.
+	 */
+	DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
+			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
+	struct cmr_info cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
+	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
+	int ret;
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
 	 *  - Construct a list of TDMRs to cover all TDX-usable memory
 	 *    regions.
@@ -166,7 +239,9 @@ static int init_tdx_module(void)
 	 *
 	 *  Return error before all steps are done.
 	 */
-	return -EINVAL;
+	ret = -EINVAL;
+out:
+	return ret;
 }
 
 static int __tdx_enable(void)
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 884357a4133c..6d32f62e4182 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -3,6 +3,8 @@
 #define _X86_VIRT_TDX_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler_attributes.h>
 
 /*
  * This file contains both macros and data structures defined by the TDX
@@ -14,6 +16,80 @@
 /* MSR to report KeyID partitioning between MKTME and TDX */
 #define MSR_IA32_MKTME_KEYID_PARTITIONING	0x00000087
 
+/*
+ * TDX module SEAMCALL leaf functions
+ */
+#define TDH_SYS_INFO		32
+
+struct cmr_info {
+	u64	base;
+	u64	size;
+} __packed;
+
+#define MAX_CMRS			32
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
+#define DECLARE_PADDED_STRUCT(type, name, size, alignment)	\
+	struct type##_padded {					\
+		union {						\
+			struct type name;			\
+			u8 padding[size];			\
+		};						\
+	} name##_padded __aligned(alignment)
+
+#define PADDED_STRUCT(name)	(name##_padded.name)
+
+#define TDSYSINFO_STRUCT_SIZE		1024
+#define TDSYSINFO_STRUCT_ALIGNMENT	1024
+
+/*
+ * The size of this structure itself is flexible.  The actual structure
+ * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE and be
+ * aligned to TDSYSINFO_STRUCT_ALIGNMENT using DECLARE_PADDED_STRUCT().
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
2.38.1

