Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28C64F5DC3
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 14:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiDFMW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 08:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbiDFMWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 08:22:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC02D451D46;
        Tue,  5 Apr 2022 21:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649220620; x=1680756620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DUBLkToKIcUrOVeBYiDzWv7vjJBibg0NhwBA4E7Uri4=;
  b=A9B3yv0OMgS97aAjM6rzjlBpcnCib2AdGoraUv1ew84Oc+IqXNnpvW/H
   3ntpEaOfXyrhqtHtBUvEtito3cbMQ6nKLWq+mMng5tRH1cqTTVSpKfGo0
   2h9lp1KbCCnV9q9kiZjrDtgUFqSkQfIxC3SCj2LJrKEUehnvA5aigU0LH
   eW2IMkzqy3dY/+WMCDzX+2WU0aXcjB+B7fbeIO/dkmgyrzc3A247sCKtl
   0Jto+xEOzF/+kiJgxKa9MQQOsy4XHSdswpBLhzSRnRpiKlY2/QThBnLSN
   l8PiVslNS7Bpah5F8E+JDKyUBtcAAh1eEms6+YlPr66l97nt4srw2p4jH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10308"; a="243089825"
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="243089825"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:20 -0700
X-IronPort-AV: E=Sophos;i="5.90,239,1643702400"; 
   d="scan'208";a="524302311"
Received: from dchang1-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.17])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 21:50:16 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v3 09/21] x86/virt/tdx: Get information about TDX module and convertible memory
Date:   Wed,  6 Apr 2022 16:49:21 +1200
Message-Id: <145620795852bf24ba2124a3f8234fd4aaac19d4.1649219184.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649219184.git.kai.huang@intel.com>
References: <cover.1649219184.git.kai.huang@intel.com>
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

TDX provides increased levels of memory confidentiality and integrity.
This requires special hardware support for features like memory
encryption and storage of memory integrity checksums.  Not all memory
satisfies these requirements.

As a result, TDX introduced the concept of a "Convertible Memory Region"
(CMR).  During boot, the firmware builds a list of all of the memory
ranges which can provide the TDX security guarantees.  The list of these
ranges, along with TDX module information, is available to the kernel by
querying the TDX module via TDH.SYS.INFO SEAMCALL.

Host kernel can choose whether or not to use all convertible memory
regions as TDX memory.  Before TDX module is ready to create any TD
guests, all TDX memory regions that host kernel intends to use must be
configured to the TDX module, using specific data structures defined by
TDX architecture.  Constructing those structures requires information of
both TDX module and the Convertible Memory Regions.  Call TDH.SYS.INFO
to get this information as preparation to construct those structures.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 131 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  61 +++++++++++++++++
 2 files changed, 192 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ef2718423f0f..482e6d858181 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -80,6 +80,11 @@ static DEFINE_MUTEX(tdx_module_lock);
 
 static struct p_seamldr_info p_seamldr_info;
 
+/* Base address of CMR array needs to be 512 bytes aligned. */
+static struct cmr_info tdx_cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
+static int tdx_cmr_num;
+static struct tdsysinfo_struct tdx_sysinfo;
+
 static bool __seamrr_enabled(void)
 {
 	return (seamrr_mask & SEAMRR_ENABLED_BITS) == SEAMRR_ENABLED_BITS;
@@ -468,6 +473,127 @@ static int tdx_module_init_cpus(void)
 	return seamcall_on_each_cpu(&sc);
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
+static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
+{
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
+			pr_err("Firmware bug: CMRs not in address ascending order.\n");
+			return -EFAULT;
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
+	for (j = i + 1; j < cmr_num; j++)
+		if (cmr_valid(&cmr_array[j])) {
+			pr_err("Firmware bug: invalid CMR(s) among valid CMRs.\n");
+			return -EFAULT;
+		}
+
+	/*
+	 * Trim all tail invalid empty CMRs.  BIOS should generate at
+	 * least one valid CMR, otherwise it's a TDX firmware bug.
+	 */
+	tdx_cmr_num = i;
+	if (!tdx_cmr_num) {
+		pr_err("Firmware bug: No valid CMR.\n");
+		return -EFAULT;
+	}
+
+	/* Print kernel sanitized CMRs */
+	print_cmrs(tdx_cmr_array, tdx_cmr_num, "Kernel-sanitized-CMR");
+
+	return 0;
+}
+
+static int tdx_get_sysinfo(void)
+{
+	struct tdx_module_output out;
+	u64 tdsysinfo_sz, cmr_num;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct tdsysinfo_struct) != TDSYSINFO_STRUCT_SIZE);
+
+	ret = seamcall(TDH_SYS_INFO, __pa(&tdx_sysinfo), TDSYSINFO_STRUCT_SIZE,
+			__pa(tdx_cmr_array), MAX_CMRS, NULL, &out);
+	if (ret)
+		return ret;
+
+	/*
+	 * If TDH.SYS.CONFIG succeeds, RDX contains the actual bytes
+	 * written to @tdx_sysinfo and R9 contains the actual entries
+	 * written to @tdx_cmr_array.  Sanity check them.
+	 */
+	tdsysinfo_sz = out.rdx;
+	cmr_num = out.r9;
+	if (WARN_ON_ONCE((tdsysinfo_sz > sizeof(tdx_sysinfo)) || !tdsysinfo_sz ||
+				(cmr_num > MAX_CMRS) || !cmr_num))
+		return -EFAULT;
+
+	pr_info("TDX module: vendor_id 0x%x, major_version %u, minor_version %u, build_date %u, build_num %u",
+		tdx_sysinfo.vendor_id, tdx_sysinfo.major_version,
+		tdx_sysinfo.minor_version, tdx_sysinfo.build_date,
+		tdx_sysinfo.build_num);
+
+	/* Print BIOS provided CMRs */
+	print_cmrs(tdx_cmr_array, cmr_num, "BIOS-CMR");
+
+	return sanitize_cmrs(tdx_cmr_array, cmr_num);
+}
+
 static int init_tdx_module(void)
 {
 	int ret;
@@ -482,6 +608,11 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	/* Get TDX module information and CMRs */
+	ret = tdx_get_sysinfo();
+	if (ret)
+		goto out;
+
 	/*
 	 * Return -EFAULT until all steps of TDX module
 	 * initialization are done.
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index b8cfdd6e12f3..2f21c45df6ac 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -29,6 +29,66 @@ struct p_seamldr_info {
 	u8	reserved2[88];
 } __packed __aligned(P_SEAMLDR_INFO_ALIGNMENT);
 
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
  * P-SEAMLDR SEAMCALL leaf function
  */
@@ -38,6 +98,7 @@ struct p_seamldr_info {
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_SYS_INFO		32
 #define TDH_SYS_INIT		33
 #define TDH_SYS_LP_INIT		35
 #define TDH_SYS_LP_SHUTDOWN	44
-- 
2.35.1

