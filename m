Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A573694515
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 13:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjBMMCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 07:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjBMMBy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 07:01:54 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EAEE1A663;
        Mon, 13 Feb 2023 04:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676289682; x=1707825682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OlCT5mi08fJ1Z5E2TiAQqi7R9htjkGCh91LfZCeJLjQ=;
  b=Sr1ZSnyPKROXYLXJJ8GW9YtCnBziBaBPl/qFDAKLWid7oNofTErFZG0Y
   zMiBLYuoF7hF/p89wS0Ih4deht7vE8Ls3Mle1GlN2Knz4VVasOt/CZkGt
   utP+FV93xVHX9akgh88spJ9pjgjKIIua1dX/uyb6povD+XlmqHq8sokp7
   GcPEgxxhsO6KD5EZwg3KG54nsbEN6YY0Hn61T9ijXfjy+VP5TV76GHGnw
   sKRlZCwLosPvWCRqnYQAHs34514CRnaK6bVHf4SDiVnUZKunR/VlNQVNv
   VEXqRz2g/bL7pABzuYpYv4riRzG/SRNgsu4+iRE5MmUi7YQqsC1JUyJ4E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="358283296"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="358283296"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:54 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="701243266"
X-IronPort-AV: E=Sophos;i="5.97,293,1669104000"; 
   d="scan'208";a="701243266"
Received: from wonger-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.188.34])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 04:00:49 -0800
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
Subject: [PATCH v9 08/18] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Tue, 14 Feb 2023 00:59:15 +1300
Message-Id: <7a2bc33fd7103d9b9d9c7fa828658ae1861ada49.1676286526.git.kai.huang@intel.com>
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

For now both 'tdsysinfo_struct' and CMRs are only used during the module
initialization.  But because they are both relatively big, declare them
inside the module initialization function but as static variables.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 65 ++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h | 88 +++++++++++++++++++++++++++++++++++++
 2 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 23b2db28726f..ae8e59294b46 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -17,6 +17,7 @@
 #include <linux/cpu.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/page.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -233,8 +234,67 @@ static int module_lp_init_online_cpus(void)
 			skip_func_module_lp_init_done, NULL);
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
+ * CMRs, and save them to @sysinfo and @cmr_array.  @sysinfo must have
+ * been padded to have enough room to save the TDSYSINFO_STRUCT.
+ */
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
+	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
+			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
+	static struct cmr_info cmr_array[MAX_CMRS]
+			__aligned(CMR_INFO_ARRAY_ALIGNMENT);
+	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
 	int ret;
 
 	/*
@@ -262,10 +322,13 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 30413d7fbee8..e32d9920b3a7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -3,6 +3,94 @@
 #define _X86_VIRT_TDX_H
 
 #include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/compiler_attributes.h>
+
+/*
+ * This file contains both macros and data structures defined by the TDX
+ * architecture and Linux defined software data structures and functions.
+ * The two should not be mixed together for better readability.  The
+ * architectural definitions come first.
+ */
+
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
+/*
+ * Do not put any hardware-defined TDX structure representations below
+ * this comment!
+ */
 
 /*
  * This file contains both macros and data structures defined by the TDX
-- 
2.39.1

