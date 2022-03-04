Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1760A4CDE82
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiCDUGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiCDUFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:05:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34012A2C9E;
        Fri,  4 Mar 2022 12:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424047; x=1677960047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=duz8fwzFTXoOSqbIIEtfY9dmoTFru5E+r7AFwAvpVMY=;
  b=FWOulfiEm1ptewjecgKhMEA+jWPRWaIcotqsyQd4efTU2q8OKHMBZWlM
   IeYrQ47OTMsTXDGutykMQp0ceifpqhX4CuRM75Uikt1GrbbdlhNs/1CmT
   KIpRLBge7MJGXB1KnuBlAi5gwAaSEeN+hnrdzanM+aA+5dNEhNh9dG+/1
   Q7vbJuUdAbSFN9B1eI5yuBKUaXI9QqmRZRweHeShRXxB8yUhn+rrk1R0d
   ZFxN7bGUheiErDic/+SUka93/aOOep7/5QF7NHrea3C1TeUiqAB27dhK4
   HG7ZHfbRBAllADla5TmnN0w+t3R6zqff3aUL3B7hHJacIgLL8CfYp85Hl
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983304"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983304"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:04 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344097"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:04 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 007/104] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Fri,  4 Mar 2022 11:48:23 -0800
Message-Id: <0a942626c76824cb225995fcb6499fea51113d43.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
 arch/x86/include/asm/tdx.h | 55 ++++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx.c    | 16 +++++++++--
 arch/x86/virt/vmx/tdx.h    | 52 -----------------------------------
 3 files changed, 69 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 24f2b7e8b280..9a8dc6afcb63 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -82,15 +82,70 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
 void tdx_detect_cpu(struct cpuinfo_x86 *c);
 int tdx_detect(void);
 int tdx_init(void);
 bool platform_has_tdx(void);
+const struct tdsysinfo_struct *tdx_get_sysinfo(void);
 #else
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
 static inline int tdx_detect(void) { return -ENODEV; }
 static inline int tdx_init(void) { return -ENODEV; }
 static inline bool platform_has_tdx(void) { return false; }
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 #endif /* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx.c b/arch/x86/virt/vmx/tdx.c
index da4d1df95503..e45f188479cb 100644
--- a/arch/x86/virt/vmx/tdx.c
+++ b/arch/x86/virt/vmx/tdx.c
@@ -641,7 +641,7 @@ static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
 	return 0;
 }
 
-static int tdx_get_sysinfo(void)
+static int __tdx_get_sysinfo(void)
 {
 	struct tdx_module_output out;
 	u64 tdsysinfo_sz, cmr_num;
@@ -676,6 +676,18 @@ static int tdx_get_sysinfo(void)
 	return sanitize_cmrs(tdx_cmr_array, cmr_num);
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
  * Only E820_TYPE_RAM and E820_TYPE_PRAM are considered as candidate for
  * TDX usable memory.  The latter is treated as RAM because it is created
@@ -1383,7 +1395,7 @@ static int init_tdx_module(void)
 		goto out;
 
 	/* Get TDX module information and CMRs */
-	ret = tdx_get_sysinfo();
+	ret = __tdx_get_sysinfo();
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/virt/vmx/tdx.h b/arch/x86/virt/vmx/tdx.h
index 212f83374c0a..b071d299327b 100644
--- a/arch/x86/virt/vmx/tdx.h
+++ b/arch/x86/virt/vmx/tdx.h
@@ -37,58 +37,6 @@ struct cmr_info {
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

