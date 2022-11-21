Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C67A6317B0
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiKUA2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiKUA1f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:27:35 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17747616D;
        Sun, 20 Nov 2022 16:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668990454; x=1700526454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Pa4jSAXA0/AWOM55d4JNHw0m9B5twdJCN8J0UtUQn8=;
  b=hyLIKqwq0kO/TATvXx1VJbXLf6jbfOc0ulSCkMEI0AUR42hgeNyKsf7g
   dwCh7zgLtT1qCTeoUBfFPhIxBtWt3nczOPvIavjBb1gf8oaUkbYqm2J4g
   YG8AwyRKg+OQb21Y1OaEXnAbPXGQ2fDJXdYT9hrqEj1QxHcNbx9YTFeCS
   NQnm0tC5UQxLc5pKaFBbi1D6Z1oS1Eo7rlfHjNVJZ6qX5SmTvQZLonkDm
   kf461/v1r3t+NhEqFBntYaPygUgDjFdtaZADY3iCdlynC0eXNS36bv21p
   HlPZgAtiYwGhlh24jUtOScpuhPh1XiQeBI1j+7lLfNohuHDoZQFldPvzH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="399732318"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="399732318"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="729825337"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="729825337"
Received: from tomnavar-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.176.15])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2022 16:27:29 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, peterz@infradead.org,
        ak@linux.intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com, kai.huang@intel.com
Subject: [PATCH v7 09/20] x86/virt/tdx: Get information about TDX module and TDX-capable memory
Date:   Mon, 21 Nov 2022 13:26:31 +1300
Message-Id: <cd23a9583edcfa85e11612d94ecfd2d5e862c1d5.1668988357.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668988357.git.kai.huang@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
TDH.SYS.INFO to get this information as a preparation.

Use static variables for both TDSYSINFO_STRUCT and CMR array to avoid
having to pass them as function arguments when constructing the TDMR
array.  And they are too big to be put to the stack anyway.  Also, KVM
needs to use the TDSYSINFO_STRUCT to create TDX guests.

Reviewed-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---

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
 arch/x86/virt/vmx/tdx/tdx.c | 125 ++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  61 ++++++++++++++++++
 2 files changed, 186 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2cf7090667aa..43227af25e44 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,7 @@
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/atomic.h>
+#include <linux/align.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
@@ -40,6 +41,11 @@ static enum tdx_module_status_t tdx_module_status;
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
@@ -208,6 +214,121 @@ static int tdx_module_init_cpus(void)
 	return atomic_read(&sc.err);
 }
 
+static inline bool is_cmr_empty(struct cmr_info *cmr)
+{
+	return !cmr->size;
+}
+
+static inline bool is_cmr_ok(struct cmr_info *cmr)
+{
+	/* CMR must be page aligned */
+	return IS_ALIGNED(cmr->base, PAGE_SIZE) &&
+		IS_ALIGNED(cmr->size, PAGE_SIZE);
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
+/* Check CMRs reported by TDH.SYS.INFO, and trim tail empty CMRs. */
+static int trim_empty_cmrs(struct cmr_info *cmr_array, int *actual_cmr_num)
+{
+	struct cmr_info *cmr;
+	int i, cmr_num;
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
+	 * if total CMRs are less than 32.  Need to skip them manually.
+	 *
+	 * CMR also must be 4K aligned.  TDX doesn't trust BIOS.  TDX
+	 * actually verifies CMRs before it gets enabled, so anything
+	 * doesn't meet above means kernel bug (or TDX is broken).
+	 */
+	cmr = &cmr_array[0];
+	/* There must be at least one valid CMR */
+	if (WARN_ON_ONCE(is_cmr_empty(cmr) || !is_cmr_ok(cmr)))
+		goto err;
+
+	cmr_num = *actual_cmr_num;
+	for (i = 1; i < cmr_num; i++) {
+		struct cmr_info *cmr = &cmr_array[i];
+		struct cmr_info *prev_cmr = NULL;
+
+		/* Skip further empty CMRs */
+		if (is_cmr_empty(cmr))
+			break;
+
+		/*
+		 * Do sanity check anyway to make sure CMRs:
+		 *  - are 4K aligned
+		 *  - don't overlap
+		 *  - are in address ascending order.
+		 */
+		if (WARN_ON_ONCE(!is_cmr_ok(cmr)))
+			goto err;
+
+		prev_cmr = &cmr_array[i - 1];
+		if (WARN_ON_ONCE((prev_cmr->base + prev_cmr->size) >
+					cmr->base))
+			goto err;
+	}
+
+	/* Update the actual number of CMRs */
+	*actual_cmr_num = i;
+
+	/* Print kernel checked CMRs */
+	print_cmrs(cmr_array, *actual_cmr_num, "Kernel-checked-CMR");
+
+	return 0;
+err:
+	pr_info("[TDX broken ?]: Invalid CMRs detected\n");
+	print_cmrs(cmr_array, cmr_num, "BIOS-CMR");
+	return -EINVAL;
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
+	 * trim_empty_cmrs() updates the actual number of CMRs by
+	 * dropping all tail empty CMRs.
+	 */
+	return trim_empty_cmrs(tdx_cmr_array, &tdx_cmr_num);
+}
+
 /*
  * Detect and initialize the TDX module.
  *
@@ -232,6 +353,10 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
+	ret = tdx_get_sysinfo();
+	if (ret)
+		goto out;
+
 	/*
 	 * Return -EINVAL until all steps of TDX module initialization
 	 * process are done.
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
2.38.1

