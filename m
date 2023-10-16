Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29137CAF36
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbjJPQa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjJPQaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:30:55 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5D56186;
        Mon, 16 Oct 2023 09:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473303; x=1729009303;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WC40/RD5FfvvicfUfo6K6EJDLzlvz4ruiVzHAMVz7EY=;
  b=Oi2lgQfZ5ulK7lt362+uMRrtl3Y52ptMQ+VI6NZrxfPFrlGpeImg59pi
   W3xwGq6vqWTmbcqd0/PLkl1u6mX1w5qRJJ+si+FInlDa/NYgfLUBTczXp
   cGnGefLj82ZqJOixPTXFSvs4Fyy/3q4KrMl7w31mCR9NbtdpSST8gEf4s
   O0nIum+UEgz1kUatu31FCfoaHOU0X0/G0ye2LD/f+TjH92OPv6+ryLeE7
   9mDNANIYZrVJ/b7rtFYSMh4GtVKD905+hxDIh9mupPpzHa6SOIZRpPZ6S
   1TjNibc6T3D6+BKi5DrcSA5VYI0s9YIayypBUmU2E8jgcISKoOOQPRW7i
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825941"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825941"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087126016"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087126016"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:27 -0700
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
Subject: [PATCH v16 016/116] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Mon, 16 Oct 2023 09:13:28 -0700
Message-Id: <af1fcfc749da69d704bd1b533065f8059b7ec327.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/tdx.h  | 59 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.c      | 15 +++++++++-
 arch/x86/virt/vmx/tdx/tdx.c | 20 +++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h | 51 --------------------------------
 4 files changed, 91 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e50129a1f13e..800ed1783b94 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -110,6 +110,62 @@ u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
 #define seamcall_saved_ret(__fn, __args)				\
 	SEAMCALL_NO_ENTROPY_RETRY(__seamcall_saved_ret, (__fn), (__args))
 
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
+#define TDSYSINFO_STRUCT_ALIGNMENT	1024
+
+/*
+ * The size of this structure itself is flexible.  The actual structure
+ * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE bytes
+ * and TDSYSINFO_STRUCT_ALIGNMENT bytes aligned.
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
@@ -138,6 +194,9 @@ static inline u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args)
 {
 	return TDX_SEAMCALL_UD;
 }
+
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
index 5b8f2085d293..ec0eb9edfa21 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -284,6 +284,20 @@ static int get_tdx_sysinfo(struct tdsysinfo_struct *tdsysinfo,
 	return 0;
 }
 
+static struct tdsysinfo_struct *tdsysinfo;
+
+const struct tdsysinfo_struct *tdx_get_sysinfo(void)
+{
+	const struct tdsysinfo_struct *r = NULL;
+
+	mutex_lock(&tdx_module_lock);
+	if (tdx_module_status == TDX_MODULE_INITIALIZED)
+		r = tdsysinfo;
+	mutex_unlock(&tdx_module_lock);
+	return r;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
 /*
  * Add a memory region as a TDX memory block.  The caller must make sure
  * all memory regions are added in address ascending order and don't
@@ -1109,7 +1123,6 @@ static int init_tdmrs(struct tdmr_info_list *tdmr_list)
 
 static int init_tdx_module(void)
 {
-	struct tdsysinfo_struct *tdsysinfo;
 	struct cmr_info *cmr_array;
 	int tdsysinfo_size;
 	int cmr_array_size;
@@ -1208,7 +1221,10 @@ static int init_tdx_module(void)
 	 * For now both @sysinfo and @cmr_array are only used during
 	 * module initialization, so always free them.
 	 */
-	kfree(tdsysinfo);
+	if (ret) {
+		kfree(tdsysinfo);
+		tdsysinfo = NULL;
+	}
 	kfree(cmr_array);
 	return ret;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 5bcbfc2fc466..c37a54cff1fa 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -36,57 +36,6 @@ struct cmr_info {
 #define MAX_CMRS	32
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
-#define TDSYSINFO_STRUCT_SIZE		1024
-#define TDSYSINFO_STRUCT_ALIGNMENT	1024
-
-/*
- * The size of this structure itself is flexible.  The actual structure
- * passed to TDH.SYS.INFO must be padded to TDSYSINFO_STRUCT_SIZE bytes
- * and TDSYSINFO_STRUCT_ALIGNMENT bytes aligned.
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

