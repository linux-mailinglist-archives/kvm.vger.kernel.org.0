Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3755DC61
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241404AbiF0VzC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbiF0Vyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F3162F0;
        Mon, 27 Jun 2022 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366890; x=1687902890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o9/BCJNrP7c2xBDfX2aghdTq8XSqQcpeG8cUezzbHO8=;
  b=ZNnxCKG8ZFWVpla5DoUJ226JyY1teTG17JDgszvPRavH75UFa5jC5LZU
   IADtdVohhqfSWjmuZUnvDrZlDvAwuM4ATFIHoDofHpHrtXeOPgjLyYMa6
   EegeHR7kMy5eHaDYXjOsF8lIuycjH/Okb4PR7nv3yEhrloBcgHwlijI4F
   zo5U03h7xKMkHXll4i71Hkgr89ZW96Q5XHt5cWiF1CW1rdMKwe3PUbzdg
   eHjwCgyjIJn6fBBJxsxCzCq35QmHSqwQg/FhCLOs4bryZ8eatbkfM3oZi
   0pb45maiCwVSlEu5teHn3Xr57A37sQHuubkwDb54MZuhX/VyrgbEQ7/tA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609504"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609504"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863460"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 010/102] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Mon, 27 Jun 2022 14:53:02 -0700
Message-Id: <2e722b58684c3cfbedda7d2a5a446255784a615e.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module, struct
tdsysinfo_struct.  Add a helper function tdx_get_sysinfo() to return it
instead of KVM getting it with various error checks.  Move out the struct
definition about it to common place tdx_host.h.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  | 55 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 20 +++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h | 52 -----------------------------------
 3 files changed, 71 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 801f6e10b2db..dfea0dd71bc1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -89,11 +89,66 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
+		struct tdx_cpuid_config	cpuid_configs[0];
+		u8			reserved5[892];
+	};
+} __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
+
 bool platform_tdx_enabled(void);
 int tdx_init(void);
+const struct tdsysinfo_struct *tdx_get_sysinfo(void);
 #else	/* !CONFIG_INTEL_TDX_HOST */
 static inline bool platform_tdx_enabled(void) { return false; }
 static inline int tdx_init(void)  { return -ENODEV; }
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f9a6f8bdade8..14f53494156c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -364,9 +364,9 @@ static int check_cmrs(struct cmr_info *cmr_array, int *actual_cmr_num)
 	return 0;
 }
 
-static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
-			   struct cmr_info *cmr_array,
-			   int *actual_cmr_num)
+static int __tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
+			     struct cmr_info *cmr_array,
+			     int *actual_cmr_num)
 {
 	struct tdx_module_output out;
 	u64 ret;
@@ -393,6 +393,18 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
 	return check_cmrs(cmr_array, actual_cmr_num);
 }
 
+const struct tdsysinfo_struct *tdx_get_sysinfo(void)
+{
+       const struct tdsysinfo_struct *r = NULL;
+
+       mutex_lock(&tdx_module_lock);
+       if (tdx_module_status == TDX_MODULE_INITIALIZED)
+	       r = &tdx_sysinfo;
+       mutex_unlock(&tdx_module_lock);
+       return r;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
 /*
  * Skip the memory region below 1MB.  Return true if the entire
  * region is skipped.  Otherwise, the updated range is returned.
@@ -1116,7 +1128,7 @@ static int init_tdx_module(void)
 	if (ret)
 		goto out;
 
-	ret = tdx_get_sysinfo(&tdx_sysinfo, tdx_cmr_array, &tdx_cmr_num);
+	ret = __tdx_get_sysinfo(&tdx_sysinfo, tdx_cmr_array, &tdx_cmr_num);
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index e0309558be13..c08e4ee2d0bf 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -65,58 +65,6 @@ struct cmr_info {
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
-#define TDSYSINFO_STRUCT_SIZE		1024
-#define TDSYSINFO_STRUCT_ALIGNMENT	1024
-
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
-	 * 'num_cpuid_config'.  The size of 'struct tdsysinfo_struct'
-	 * is 1024B defined by TDX architecture.  Use a union with
-	 * specific padding to make 'sizeof(struct tdsysinfo_struct)'
-	 * equal to 1024.
-	 */
-	union {
-		struct cpuid_config	cpuid_configs[0];
-		u8			reserved5[892];
-	};
-} __packed __aligned(TDSYSINFO_STRUCT_ALIGNMENT);
-
 struct tdmr_reserved_area {
 	u64 offset;
 	u64 size;
-- 
2.25.1

