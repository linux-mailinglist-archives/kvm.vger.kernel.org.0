Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C90B60EC2B
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiJZXSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiJZXSE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:18:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026BEB7F56;
        Wed, 26 Oct 2022 16:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666826262; x=1698362262;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E8j3vx0qguuGV2c4QM857hctS11gsJ6r6LjWfPy0DrU=;
  b=m4gsjzMOq2E93x+QHUWCo68Zz5B3QsHii0DrUyGfUy+nysnWeO3wIySn
   jDlRtXcbmFR0vCGEt3o3zDHW4FImLRxUk6V4PyBKEPMwQo67bKS/DVvvs
   mKnQjvuXLhFIgFXp3kCWcG2z9whmVfzVmbiD4mQy6Ze/me7CGJxIR46Od
   lhTgFXAypR1lY9+VNp2/vBu9x0o7sjzhyZ1qewy/FeEPmnOi7AeL409xF
   ywu0MXyGbGqz0qoFkfvTu1RdKrv6n/O2KFw6H20S9VaxKa9lG8Xwn0VKG
   Agck/jM6qZ+ssd3ZYpeut1UFvKOAufI7+ldbTRJ81W/WWpad9YlHrjW/3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309175555"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="309175555"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:41 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737446344"
X-IronPort-AV: E=Sophos;i="5.95,215,1661842800"; 
   d="scan'208";a="737446344"
Received: from fordon1x-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.24.177])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2022 16:17:37 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        reinette.chatre@intel.com, len.brown@intel.com,
        tony.luck@intel.com, peterz@infradead.org, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v6 10/21] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Thu, 27 Oct 2022 12:16:09 +1300
Message-Id: <49af9b06fe205ada7ef8dd9b6b294656535d84ce.1666824663.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666824663.git.kai.huang@intel.com>
References: <cover.1666824663.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
ranges which can provide the TDX security guarantees.  The list of these
ranges, along with TDX module information, is available to the kernel by
querying the TDX module via TDH.SYS.INFO SEAMCALL.

The host kernel can choose whether or not to use all convertible memory
regions as TDX-usable memory.  Before the TDX module is ready to create
any TDX guests, the kernel needs to configure the TDX-usable memory
regions by passing an array of "TD Memory Regions" (TDMRs) to the TDX
module.  Constructing the TDMR array requires information of both the
TDX module (TDSYSINFO_STRUCT) and the Convertible Memory Regions.  Call
TDH.SYS.INFO to get this information as preparation.

Use static variables for both TDSYSINFO_STRUCT and CMR array to avoid
having to pass them as function arguments when constructing the TDMR
array.  And they are too big to be put to the stack anyway.  Also, KVM
needs to use the TDSYSINFO_STRUCT to create TDX guests.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 135 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  61 ++++++++++++++++
 2 files changed, 196 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8a1c98d961f3..7d7205615873 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -54,6 +54,11 @@ static enum tdx_module_status_t tdx_module_status;
 /* Prevent concurrent attempts on TDX detection and initialization */
 static DEFINE_MUTEX(tdx_module_lock);
 
+/* Below two are used in TDH.SYS.INFO SEAMCALL ABI */
+static struct tdsysinfo_struct tdx_sysinfo;
+static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
+static int tdx_cmr_num;
+
 /*
  * Detect TDX private KeyIDs to see whether TDX has been enabled by the
  * BIOS.  Both initializing the TDX module and running TDX guest require
@@ -351,6 +356,133 @@ static int tdx_module_init_cpus(void)
 	return atomic_read(&sc.err);
 }
 
+static inline bool cmr_valid(struct cmr_info *cmr)
+{
+	return !!cmr->size;
+}
+
+static void print_cmrs(struct cmr_info *cmr_array, int cmr_num,
+		       const char *name)
+{
+	int i;
+
+	for (i = 0; i < cmr_num; i++) {
+		struct cmr_info *cmr = &cmr_array[i];
+
+		pr_info("%s : [0x%llx, 0x%llx)\n", name,
+				cmr->base, cmr->base + cmr->size);
+	}
+}
+
+/*
+ * Check the CMRs reported by TDH.SYS.INFO and update the actual number
+ * of CMRs.  The CMRs returned by the TDH.SYS.INFO may contain invalid
+ * CMRs after the last valid CMR, but there should be no invalid CMRs
+ * between two valid CMRs.  Check and update the actual number of CMRs
+ * number by dropping all tail empty CMRs.
+ */
+static int check_cmrs(struct cmr_info *cmr_array, int *actual_cmr_num)
+{
+	int cmr_num = *actual_cmr_num;
+	int i, j;
+
+	/*
+	 * Intel TDX module spec, 20.7.3 CMR_INFO:
+	 *
+	 *   TDH.SYS.INFO leaf function returns a MAX_CMRS (32) entry
+	 *   array of CMR_INFO entries. The CMRs are sorted from the
+	 *   lowest base address to the highest base address, and they
+	 *   are non-overlapping.
+	 *
+	 * This implies that BIOS may generate invalid empty entries
+	 * if total CMRs are less than 32.  Skip them manually.
+	 */
+	for (i = 0; i < cmr_num; i++) {
+		struct cmr_info *cmr = &cmr_array[i];
+		struct cmr_info *prev_cmr = NULL;
+
+		/* Skip further invalid CMRs */
+		if (!cmr_valid(cmr))
+			break;
+
+		if (i > 0)
+			prev_cmr = &cmr_array[i - 1];
+
+		/*
+		 * It is a TDX firmware bug if CMRs are not
+		 * in address ascending order.
+		 */
+		if (prev_cmr && ((prev_cmr->base + prev_cmr->size) >
+					cmr->base)) {
+			print_cmrs(cmr_array, cmr_num, "BIOS-CMR");
+			pr_err("Firmware bug: CMRs not in address ascending order.\n");
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Also a sane BIOS should never generate invalid CMR(s) between
+	 * two valid CMRs.  Sanity check this and simply return error in
+	 * this case.
+	 *
+	 * By reaching here @i is the index of the first invalid CMR (or
+	 * cmr_num).  Starting with the next entry of @i since it has
+	 * already been checked.
+	 */
+	for (j = i + 1; j < cmr_num; j++) {
+		if (cmr_valid(&cmr_array[j])) {
+			print_cmrs(cmr_array, cmr_num, "BIOS-CMR");
+			pr_err("Firmware bug: invalid CMR(s) before valid CMRs.\n");
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Trim all tail invalid empty CMRs.  BIOS should generate at
+	 * least one valid CMR, otherwise it's a TDX firmware bug.
+	 */
+	if (i == 0) {
+		print_cmrs(cmr_array, cmr_num, "BIOS-CMR");
+		pr_err("Firmware bug: No valid CMR.\n");
+		return -EINVAL;
+	}
+
+	/* Update the actual number of CMRs */
+	*actual_cmr_num = i;
+
+	/* Print kernel checked CMRs */
+	print_cmrs(cmr_array, *actual_cmr_num, "Kernel-checked-CMR");
+
+	return 0;
+}
+
+static int tdx_get_sysinfo(void)
+{
+	struct tdx_module_output out;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct tdsysinfo_struct) != TDSYSINFO_STRUCT_SIZE);
+
+	ret = seamcall(TDH_SYS_INFO, __pa(&tdx_sysinfo), TDSYSINFO_STRUCT_SIZE,
+			__pa(tdx_cmr_array), MAX_CMRS, NULL, &out);
+	if (ret)
+		return ret;
+
+	/* R9 contains the actual entries written the CMR array. */
+	tdx_cmr_num = out.r9;
+
+	pr_info("TDX module: atributes 0x%x, vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
+		tdx_sysinfo.attributes, tdx_sysinfo.vendor_id,
+		tdx_sysinfo.major_version, tdx_sysinfo.minor_version,
+		tdx_sysinfo.build_date, tdx_sysinfo.build_num);
+
+	/*
+	 * check_cmrs() updates the actual number of CMRs by dropping all
+	 * tail invalid CMRs.
+	 */
+	return check_cmrs(tdx_cmr_array, &tdx_cmr_num);
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -375,6 +507,9 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	ret = tdx_get_sysinfo();
+	if (ret)
+		goto out;
 
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 9ba11808bd45..8e273756098c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,10 +15,71 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
 
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
+#define TDSYSINFO_STRUCT_SIZE		1024
+#define TDSYSINFO_STRUCT_ALIGNMENT	1024
+
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
+	 * 'num_cpuid_config'.  The size of 'struct tdsysinfo_struct'
+	 * is 1024B defined by TDX architecture.  Use a union with
+	 * specific padding to make 'sizeof(struct tdsysinfo_struct)'
+	 * equal to 1024.
+	 */
+	union {
+		struct cpuid_config	cpuid_configs[0];
+		u8			reserved5[892];
+	};
+} __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.37.3

