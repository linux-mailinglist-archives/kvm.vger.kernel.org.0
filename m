Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9186A3C69
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjB0IYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjB0IYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:08 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DACCEC50;
        Mon, 27 Feb 2023 00:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486247; x=1709022247;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2d593n9V4pv+3WndkfsOASE/b7B8vOJz74H2TDmfMbk=;
  b=RTmURD5zq9ERt+JBljtU7YW+RsyBcI6KggktuVO/ivAx9wQWb90MsxAQ
   ys4KZ691Ii3QZHwppmgdO74oqSQRO9ARTeMPIAKIW7Xr7Npf4pn55+3LO
   R14z/vf6K/hkfcj0lofrhU8//JgiaYHjBtgV5bprOuxa+0uyPf+9v3kYa
   ZzHHsFiTtEh7NJvAXK2s+GsWTtLzRNdOxYthHi/SFxCxFGCchHcyI32q4
   y2DyM3hr6fjRj/upq5oa+OjCjC5KCdXimPPNQMNZJhmUvrIhDJwBp/tCw
   SQDMaHi6vn7VtZNb5Mh8WvljbV95dc0C2cC/rGtqA5HmT7YMcMEBbv6h3
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608690"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608690"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:02 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242032"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242032"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:02 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 008/106] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Mon, 27 Feb 2023 00:22:07 -0800
Message-Id: <efc6fd0b6e7e27bd178d7aadaa79f71561d6f526.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/tdx.h  | 54 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c      | 15 ++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h | 51 -----------------------------------
 4 files changed, 85 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 2094d634e1a3..a10bc61e6008 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -105,6 +105,58 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
 
 #ifdef CONFIG_INTEL_TDX_HOST
+struct tdx_cpuid_config {
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
+	DECLARE_FLEX_ARRAY(struct tdx_cpuid_config, cpuid_configs);
+} __packed;
+
+const struct tdsysinfo_struct *tdx_get_sysinfo(void);
 bool platform_tdx_enabled(void);
 int tdx_enable(void);
 int tdx_cpu_online(unsigned int cpu);
@@ -121,6 +173,8 @@ void tdx_guest_keyid_free(int keyid);
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_enable(void)  { return -EINVAL; }
 static inline int tdx_cpu_online(unsigned int cpu) { return 0; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 82239d18fde3..4764c29b6988 100644
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
 	pr_info("TDX is supported.\n");
 	return 0;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index cf5431ee3cf8..79b7b2d73ff5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -357,7 +357,7 @@ static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
  * CMRs, and save them to @sysinfo and @cmr_array.  @sysinfo must have
  * been padded to have enough room to save the TDSYSINFO_STRUCT.
  */
-static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
+static int __tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
 			   struct cmr_info *cmr_array)
 {
 	struct tdx_module_output out;
@@ -382,6 +382,21 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
 	return 0;
 }
 
+static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
+			     TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
+
+const struct tdsysinfo_struct *tdx_get_sysinfo(void)
+{
+	const struct tdsysinfo_struct *r = NULL;
+
+	mutex_lock(&tdx_module_lock);
+	if (tdx_module_status == TDX_MODULE_INITIALIZED)
+		r = &PADDED_STRUCT(tdsysinfo);
+	mutex_unlock(&tdx_module_lock);
+	return r;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -1164,8 +1179,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
-			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
 	static struct cmr_info cmr_array[MAX_CMRS]
 			__aligned(CMR_INFO_ARRAY_ALIGNMENT);
 	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
@@ -1196,7 +1209,7 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
-	ret = tdx_get_sysinfo(sysinfo, cmr_array);
+	ret = __tdx_get_sysinfo(sysinfo, cmr_array);
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4e312c7f9553..66ca6f1f3d23 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -29,15 +29,6 @@ struct cmr_info {
 #define MAX_CMRS			32
 #define CMR_INFO_ARRAY_ALIGNMENT	512
 
-struct cpuid_config {
-	u32	leaf;
-	u32	sub_leaf;
-	u32	eax;
-	u32	ebx;
-	u32	ecx;
-	u32	edx;
-} __packed;
-
 #define DECLARE_PADDED_STRUCT(type, name, size, alignment)	\
 	struct type##_padded {					\
 		union {						\
@@ -48,48 +39,6 @@ struct cpuid_config {
 
 #define PADDED_STRUCT(name)	(name##_padded.name)
 
-#define TDSYSINFO_STRUCT_SIZE		1024
-#define TDSYSINFO_STRUCT_ALIGNMENT	1024
-
-/*
- * The size of this structure itself is flexible.  The actual structure
- * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE and be
- * aligned to TDSYSINFO_STRUCT_ALIGNMENT using DECLARE_PADDED_STRUCT().
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

