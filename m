Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5057667B53
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240655AbjALQle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbjALQhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C11915F27;
        Thu, 12 Jan 2023 08:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541234; x=1705077234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bcDa4fYN1iV6Ek3rgxou0zEqNM1V2Xv6HRciLpFuqcE=;
  b=lvaUbGtInSVYpop8NVoGUNx6jeK+24smXCHmLVnfVsjXzTVQdEjiM6Mw
   iMDJgWzN5PJOQKX6w2qWDqBHv5j343lAOPbIyJqaKXySINXiz/PSvzYTU
   S5uplt3Cmhj/d6EMXR5finVKsd7AUumlgWGJipOHixcwOcWtu8Cksdt/7
   O4A98hM0L3UtK1eBRWAddACafumkbrZwUFm88g9DykuNOR6VxqxW5dC3t
   gN+CUtIxIstqWsUkiRJsrh69iQZFyBPVs0Gf+XPoOC/xgHA97fyxPLbmO
   eM1KHUDmJKJszFqqKv1Sqdx7Rirc0R0DHnCQdM36YCO1MZXnlMwnUGJYD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811702"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811702"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151670"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151670"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 014/113] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Thu, 12 Jan 2023 08:31:22 -0800
Message-Id: <3c7b93a184e36729aeaad2df2b5f450fb564ee92.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module, struct
tdsysinfo_struct.  Add a helper function tdx_get_sysinfo() to return it
instead of KVM getting it with various error checks.  Make KVM call the
function and stash the info.  Move out the struct definition about it to
common place arch/x86/include/asm/tdx.h.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 54 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c      | 49 ++++++++++++++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 21 ++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h | 51 -----------------------------------
 4 files changed, 119 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index ed9cf61ff8b4..2ca6e8ce1e43 100644
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
 /*
@@ -120,6 +172,8 @@ void tdx_keyid_free(int keyid);
 u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
 #else	/* !CONFIG_INTEL_TDX_HOST */
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_enable(void)  { return -EINVAL; }
 static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6c7d9ec53046..2adf5551ab26 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -11,9 +11,34 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#define TDX_MAX_NR_CPUID_CONFIGS					\
+	((TDSYSINFO_STRUCT_SIZE -					\
+		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
+		/ sizeof(struct tdx_cpuid_config))
+
+struct tdx_capabilities {
+	u8 tdcs_nr_pages;
+	u8 tdvpx_nr_pages;
+
+	u64 attrs_fixed0;
+	u64 attrs_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+
+	u32 nr_cpuid_configs;
+	struct tdx_cpuid_config cpuid_configs[TDX_MAX_NR_CPUID_CONFIGS];
+};
+
+/* Capabilities of KVM + the TDX module. */
+static struct tdx_capabilities tdx_caps;
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
@@ -21,6 +46,28 @@ static int __init tdx_module_setup(void)
 		return ret;
 	}
 
+	tdsysinfo = tdx_get_sysinfo();
+	if (tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS)
+		return -EIO;
+
+	tdx_caps = (struct tdx_capabilities) {
+		.tdcs_nr_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
+		/*
+		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
+		 * -1 for TDVPR.
+		 */
+		.tdvpx_nr_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
+		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
+		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
+		.xfam_fixed0 =	tdsysinfo->xfam_fixed0,
+		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
+		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
+	};
+	if (!memcpy(tdx_caps.cpuid_configs, tdsysinfo->cpuid_configs,
+			tdsysinfo->num_cpuid_config *
+			sizeof(struct tdx_cpuid_config)))
+		return -EIO;
+
 	pr_info("TDX is supported.\n");
 	return 0;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d18ab5c4d447..65c0024fd3a9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -279,7 +279,7 @@ static void print_cmrs(struct cmr_info *cmr_array, int nr_cmrs)
  * kernel stack.  @sysinfo must have been padded to have enough room
  * to save the TDSYSINFO_STRUCT.
  */
-static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
+static int __tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
 			   struct cmr_info *cmr_array)
 {
 	struct tdx_module_output out;
@@ -308,6 +308,21 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *sysinfo,
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
@@ -1118,8 +1133,6 @@ static int init_tdx_module(void)
 	 * They are 1024 bytes and 512 bytes respectively but it's fine to
 	 * keep them in the stack as this function is only called once.
 	 */
-	DECLARE_PADDED_STRUCT(tdsysinfo_struct, tdsysinfo,
-			TDSYSINFO_STRUCT_SIZE, TDSYSINFO_STRUCT_ALIGNMENT);
 	struct cmr_info cmr_array[MAX_CMRS] __aligned(CMR_INFO_ARRAY_ALIGNMENT);
 	struct tdsysinfo_struct *sysinfo = &PADDED_STRUCT(tdsysinfo);
 	struct tdmr_info_list tdmr_list;
@@ -1134,7 +1147,7 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
-	ret = tdx_get_sysinfo(sysinfo, cmr_array);
+	ret = __tdx_get_sysinfo(sysinfo, cmr_array);
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 8abfbcc23be1..9658cd89b579 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -34,15 +34,6 @@ struct cmr_info {
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
@@ -53,48 +44,6 @@ struct cpuid_config {
 
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

