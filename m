Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DB355496A
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357396AbiFVLSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357240AbiFVLRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:17:34 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671F63CA4A;
        Wed, 22 Jun 2022 04:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896644; x=1687432644;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R7yojN39hyqmL+OvLZikI2Tqp65QvZbCf9dpqdDXoeg=;
  b=d73pPxeabPMUzjQDVpsR6LdVsnk+yOm5lU7XAj9bWL8+SGlqRRYWzgEf
   Xq/QGYoCbfl9lA+vf4UZMGZtwugWAkPwOFPVMJA0TUR39xdznBMYQFtZp
   X+rVguMUPBn4ivaM3wqWX9kxV2LqEE/sVpl3qZihEWNKULWRmktjJzSBl
   OANNHSyoKolI4S7T9KWeaKG8vpkHtc0oeL0XN8ZvswEGJguW82+C+7J1F
   lWh6mjaVg43EFprvrHzxLWFIA0NnolF8jACrGL0tOIsZYHJ7PK+bd9cS2
   6Z3RRs/4zYg2Qmznt3jBBfIRBi6iSoLutL6ouCaQ9ccueZ4ZE5EfhdMc3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281464728"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281464728"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730302235"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:17:19 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 11/22] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Wed, 22 Jun 2022 23:17:00 +1200
Message-Id: <24bab3c465ccc84b046f032e88bb1c79e6b17bed.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
needs the TDSYSINFO_STRUCT to create TDX guests.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 137 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  61 ++++++++++++++++
 2 files changed, 198 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f3f6e20aa30e..1bc97756bc0d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -45,6 +45,11 @@ static enum tdx_module_status_t tdx_module_status;
 /* Prevent concurrent attempts on TDX detection and initialization */
 static DEFINE_MUTEX(tdx_module_lock);
 
+/* Below two are used in TDH.SYS.INFO SEAMCALL ABI */
+static struct tdsysinfo_struct tdx_sysinfo;
+static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
+static int tdx_cmr_num;
+
 /* Detect whether CPU supports SEAM */
 static int detect_seam(void)
 {
@@ -204,6 +209,135 @@ static int tdx_module_init_cpus(void)
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
+	 * cmr_num).  Starting with next entry of @i since it has already
+	 * been checked.
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
+static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
+			   struct cmr_info *cmr_array,
+			   int *actual_cmr_num)
+{
+	struct tdx_module_output out;
+	u64 ret;
+
+	BUILD_BUG_ON(sizeof(struct tdsysinfo_struct) != TDSYSINFO_STRUCT_SIZE);
+
+	ret = seamcall(TDH_SYS_INFO, __pa(tdsysinfo), TDSYSINFO_STRUCT_SIZE,
+			__pa(cmr_array), MAX_CMRS, &out);
+	if (ret)
+		return -EFAULT;
+
+	/* R9 contains the actual entries written the CMR array. */
+	*actual_cmr_num = out.r9;
+
+	pr_info("TDX module: vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
+		tdsysinfo->vendor_id, tdsysinfo->major_version,
+		tdsysinfo->minor_version, tdsysinfo->build_date,
+		tdsysinfo->build_num);
+
+	/*
+	 * check_cmrs() updates the actual number of CMRs by dropping all
+	 * tail invalid CMRs.
+	 */
+	return check_cmrs(cmr_array, actual_cmr_num);
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -233,6 +367,9 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	ret = tdx_get_sysinfo(&tdx_sysinfo, tdx_cmr_array, &tdx_cmr_num);
+	if (ret)
+		goto out;
 
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 56164bf27378..63b1edd11660 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -49,10 +49,71 @@
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
  * Do not put any hardware-defined TDX structure representations below this
  * comment!
-- 
2.36.1

