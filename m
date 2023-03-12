Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26296B6923
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjCLR7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjCLR6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:58:44 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2111BC655;
        Sun, 12 Mar 2023 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643880; x=1710179880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3v9snBz//9jCoGwBHFUTys3r1zFvEaMkLUKvKUmRklk=;
  b=DHuggRzW2a9On8Y991CHT1pdJ80SctG6yUqXvQNp3laPhHcj7ci+dtKu
   2mKspcf2XRcliIytcODL5Ic/J+njXEHjvqnGRkBeKtoWSnoU3OaoeOVZq
   c+q5vnH7QNYLNzDIvgyi5+r6y7KOAC7PeNGrf4rmKK6IJaj0ZcYm1dD5N
   FrrHPTJwlJT1DnOqcmY0347/PMytmTho/XVhQJ6WFhXOZs9e+XM14yl83
   Jd/z0di81GoqbDz8qpJbUL8pBXG6N6d6rW9Nrbp+/T/GclDdSiygnYHP7
   v0vQZVoiDI3b4hjMGDRMkzwgXeQKiDrcRyPIjHul/Lv9wbS5a/9ethBjg
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863598"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863598"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396953"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396953"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 015/113] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Sun, 12 Mar 2023 10:55:39 -0700
Message-Id: <5721316c22575997243d2db2833c4faf646a16e2.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
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
index 7d99a48a98cc..05870e5ed131 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -101,6 +101,58 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
 int tdx_cpu_enable(void);
 int tdx_enable(void);
@@ -117,6 +169,8 @@ void tdx_guest_keyid_free(int keyid);
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_cpu_enable(void) { return -EINVAL; }
 static inline int tdx_enable(void)  { return -EINVAL; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 36738904c26a..e9b7aa5654e9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,6 +11,11 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#define TDX_MAX_NR_CPUID_CONFIGS					\
+	((TDSYSINFO_STRUCT_SIZE -					\
+		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
+		/ sizeof(struct tdx_cpuid_config))
+
 int tdx_hardware_enable(void)
 {
 	return tdx_cpu_enable();
@@ -18,7 +23,11 @@ int tdx_hardware_enable(void)
 
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
@@ -26,6 +35,10 @@ static int __init tdx_module_setup(void)
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
index 3251fdf74667..f9f9c1b76501 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -385,7 +385,7 @@ static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
  * CMRs, and save them to @sysinfo and @cmr_array.  @sysinfo must have
  * been padded to have enough room to save the TDSYSINFO_STRUCT.
  */
-static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
+static int __tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
 			   struct cmr_info *cmr_array)
 {
 	struct tdx_module_output out;
@@ -410,6 +410,21 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
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
@@ -1186,15 +1201,13 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	static DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
-			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
 	static struct cmr_info cmr_array[MAX_CMRS]
 			__aligned(CMR_INFO_ARRAY_ALIGNMENT);
 	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
 	struct tdmr_info_list tdmr_list;
 	int ret;
 
-	ret = tdx_get_sysinfo(sysinfo, cmr_array);
+	ret = __tdx_get_sysinfo(sysinfo, cmr_array);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 4e497f202586..db0cbcceb5b3 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -31,15 +31,6 @@ struct cmr_info {
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
@@ -50,48 +41,6 @@ struct cpuid_config {
 
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

