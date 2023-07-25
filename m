Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E10A7625E9
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbjGYWQY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjGYWPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:44 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D65BE0;
        Tue, 25 Jul 2023 15:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323342; x=1721859342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+rgqfKuT11k4dIaW4W1G9GmV5lM2K7dgjyD0BUyN94I=;
  b=ZC7zr0gIYW47dHz/0ykDfsdKWM3baUUVCpPfX9FRRWyOViE1I57uccLx
   4/AD4G2FabbXFhsTcH07T6l/HQIvgSt1oGhJzvU4hOjo509+UZktXmjeP
   90MdTOjVl9KuhXGxCyBrk+CHSYY/PyfHyvRKwHeG6JuEJc0VpfOfJo5Id
   jMmSoeAE2IE4HiZO2dVqkuQduvrUirddI7sX498QyozHC0AcHo6vuu64q
   h6dqHCCWxAeUnENTnT9ZjOnxRKUYY+tG9gM8czWJYz/xw7PZNWbJJfl5p
   vtBmoIPphECuY5lCWelhuaSDJE0/zQS3gRQSUrdZk4UUjA/qGN/bGudBT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863109"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863109"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938817"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938817"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:21 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 016/115] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Tue, 25 Jul 2023 15:13:27 -0700
Message-Id: <54648132d8e33e266d14bac3e7faec095b2fa385.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module, struct
tdsysinfo_struct.  Add a helper function tdx_get_sysinfo() to return it
instead of KVM getting it with various error checks.  Make KVM call the
function and stash the info.  Move out the struct definition about it to
common place arch/x86/include/asm/tdx.h.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 57 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c      | 15 +++++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++------
 arch/x86/virt/vmx/tdx/tdx.h | 50 --------------------------------
 4 files changed, 88 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 245c0c93cf71..86517add595f 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -85,6 +85,61 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
 
 #ifdef CONFIG_INTEL_TDX_HOST
+struct tdx_cpuid_config {
+	__struct_group(tdx_cpuid_config_leaf, leaf_sub_leaf, __packed,
+		u32 leaf;
+		u32 sub_leaf;
+	);
+	__struct_group(tdx_cpuid_config_value, value, __packed,
+		u32 eax;
+		u32 ebx;
+		u32 ecx;
+		u32 edx;
+	);
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
+	DECLARE_FLEX_ARRAY(struct tdx_cpuid_config, cpuid_configs);
+} __packed;
+
+const struct tdsysinfo_struct *tdx_get_sysinfo(void);
 bool platform_tdx_enabled(void);
 int tdx_cpu_enable(void);
 int tdx_enable(void);
@@ -104,6 +159,8 @@ void tdx_guest_keyid_free(int keyid);
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
 static inline int tdx_enable(void)  { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9d3f593eacb8..b0e3409da5a8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,9 +11,18 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#define TDX_MAX_NR_CPUID_CONFIGS					\
+	((TDSYSINFO_STRUCT_SIZE -					\
+		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
+		/ sizeof(struct tdx_cpuid_config))
+
 static int __init tdx_module_setup(void)
 {
-	int ret;
+	const struct tdsysinfo_struct *tdsysinfo;
+	int ret = 0;
+
+	BUILD_BUG_ON(sizeof(*tdsysinfo) > TDSYSINFO_STRUCT_SIZE);
+	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
 
 	ret = tdx_enable();
 	if (ret) {
@@ -21,6 +30,10 @@ static int __init tdx_module_setup(void)
 		return ret;
 	}
 
+	/* Sanitary check just in case. */
+	tdsysinfo = tdx_get_sysinfo();
+	WARN_ON(tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS);
+
 	return 0;
 }
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ef3a1d9dcf2f..f49a89cd2f34 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -230,7 +230,7 @@ static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
 	}
 }
 
-static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
+static int __tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
 			   struct cmr_info *cmr_array)
 {
 	struct tdx_module_output out;
@@ -255,6 +255,20 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
 	return 0;
 }
 
+static struct tdsysinfo_struct *sysinfo;
+
+const struct tdsysinfo_struct *tdx_get_sysinfo(void)
+{
+	const struct tdsysinfo_struct *r = NULL;
+
+	mutex_lock(&tdx_module_lock);
+	if (tdx_module_status == TDX_MODULE_INITIALIZED)
+		r = sysinfo;
+	mutex_unlock(&tdx_module_lock);
+	return r;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -1083,7 +1097,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdsysinfo_struct *sysinfo;
 	struct cmr_info *cmr_array;
 	int ret;
 
@@ -1103,7 +1116,7 @@ static int init_tdx_module(void)
 	BUILD_BUG_ON(PAGE_SIZE / 2 < TDSYSINFO_STRUCT_SIZE);
 	BUILD_BUG_ON(PAGE_SIZE / 2 < sizeof(struct cmr_info) * MAX_CMRS);
 
-	ret = tdx_get_sysinfo(sysinfo, cmr_array);
+	ret = __tdx_get_sysinfo(sysinfo, cmr_array);
 	if (ret)
 		goto out;
 
@@ -1177,11 +1190,6 @@ static int init_tdx_module(void)
 	 * Lock out memory hotplug code while building it.
 	 */
 	put_online_mems();
-	/*
-	 * For now both @sysinfo and @cmr_array are only used during
-	 * module initialization, so always free them.
-	 */
-	free_page((unsigned long)sysinfo);
 
 	return 0;
 out_reset_pamts:
@@ -1219,6 +1227,7 @@ static int init_tdx_module(void)
 	put_online_mems();
 out:
 	free_page((unsigned long)sysinfo);
+	sysinfo = NULL;
 	return ret;
 }
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 70315263d8d2..91086576651b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -40,56 +40,6 @@ struct cmr_info {
 
 #define MAX_CMRS	32
 
-struct cpuid_config {
-	u32	leaf;
-	u32	sub_leaf;
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	edx;
-} __packed;
-
-#define TDSYSINFO_STRUCT_SIZE		1024
-
-/*
- * The size of this structure itself is flexible.  The actual structure
- * passed to TDH.SYS.INFO must be padded to 1024 bytes and be 1204-bytes
- * aligned.
- */
-struct tdsysinfo_struct {
-	/* TDX-SEAM Module Info */
-	u32	attributes;
-	u32	vendor_id;
-	u32	build_date;
-	u16	build_num;
-	u16	minor_version;
-	u16	major_version;
-	u8	reserved0[14];
-	/* Memory Info */
-	u16	max_tdmrs;
-	u16	max_reserved_per_tdmr;
-	u16	pamt_entry_size;
-	u8	reserved1[10];
-	/* Control Struct Info */
-	u16	tdcs_base_size;
-	u8	reserved2[2];
-	u16	tdvps_base_size;
-	u8	tdvps_xfam_dependent_size;
-	u8	reserved3[9];
-	/* TD Capabilities */
-	u64	attributes_fixed0;
-	u64	attributes_fixed1;
-	u64	xfam_fixed0;
-	u64	xfam_fixed1;
-	u8	reserved4[32];
-	u32	num_cpuid_config;
-	/*
-	 * The actual number of CPUID_CONFIG depends on above
-	 * 'num_cpuid_config'.
-	 */
-	DECLARE_FLEX_ARRAY(struct cpuid_config, cpuid_configs);
-} __packed;
-
 struct tdmr_reserved_area {
 	u64 offset;
 	u64 size;
-- 
2.25.1

