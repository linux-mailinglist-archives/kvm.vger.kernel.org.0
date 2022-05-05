Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7151C6ED
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241821AbiEESUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383081AbiEEST1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F8EA14024;
        Thu,  5 May 2022 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774544; x=1683310544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kj6DgUMuVhHYbdH5XNKmLJ6UF+Qnim280mYzIBKMa0Q=;
  b=Yt6Mvm1OdkxH8YWncGPNlxKGQ4FETP+OZzXxBbWZPb5/x+IHPMdnM2z/
   YXH1AXqFm0zqaEcWo76p84QpDXXt1dXjctRadfP6tYcTjTQCoHQR7Kh1K
   o+ICOgjriCg8Jg2XL8+i0HO6RE0o/b3mng72Rbl0sEbO6lM0ASY34CYJu
   gr8j9srBA2aOL1seXAWYorrVoyvAs8BOyqJWWHN4qQAm8+HOmwsPG6p4k
   PIiG01rgSMSfPz6v9VTjbtkp5W34OvdFoUdbnqUpZ926mBseowod2Vlzm
   tT1d3FqUKTYSICDGrdbO6aMJTgO23/jjaHK6we6j8GVQ2hZDozwkZcJct
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746230"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746230"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083160"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:40 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 010/104] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Thu,  5 May 2022 11:14:04 -0700
Message-Id: <2da654ee581dfcc8ea375bc4dbd313038fc1fe5f.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 arch/x86/virt/vmx/tdx/tdx.c | 16 +++++++++--
 arch/x86/virt/vmx/tdx/tdx.h | 52 -----------------------------------
 3 files changed, 69 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f8f459e28254..0670c86de015 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -91,17 +91,72 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
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
 bool __seamrr_enabled(void);
 void tdx_detect_cpu(struct cpuinfo_x86 *c);
 int tdx_detect(void);
 int tdx_init(void);
 bool platform_has_tdx(void);
+const struct tdsysinfo_struct *tdx_get_sysinfo(void);
 #else
 static inline bool __seamrr_enabled(void) { return false; }
 static inline void tdx_detect_cpu(struct cpuinfo_x86 *c) { }
 static inline int tdx_detect(void) { return -ENODEV; }
 static inline int tdx_init(void) { return -ENODEV; }
 static inline bool platform_has_tdx(void) { return false; }
+struct tdsysinfo_struct;
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
 #endif /* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index e8044114079d..1ef22c445126 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -645,7 +645,7 @@ static int sanitize_cmrs(struct cmr_info *cmr_array, int cmr_num)
 	return 0;
 }
 
-static int tdx_get_sysinfo(void)
+static int __tdx_get_sysinfo(void)
 {
 	struct tdx_module_output out;
 	u64 tdsysinfo_sz, cmr_num;
@@ -680,6 +680,18 @@ static int tdx_get_sysinfo(void)
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
 /* Check whether one e820 entry is RAM and could be used as TDX memory */
 static bool e820_entry_is_ram(struct e820_entry *entry)
 {
@@ -1467,7 +1479,7 @@ static int init_tdx_module(void)
 		goto out;
 
 	/* Get TDX module information and CMRs */
-	ret = tdx_get_sysinfo();
+	ret = __tdx_get_sysinfo();
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 212f83374c0a..b071d299327b 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
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

