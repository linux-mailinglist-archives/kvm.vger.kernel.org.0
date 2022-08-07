Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31AF158BD1A
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiHGWCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiHGWCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5F4647F;
        Sun,  7 Aug 2022 15:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909753; x=1691445753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7MxpqLV2Zgr3tAyO4PmMc14M84zbQglI/rfO0pOBxDM=;
  b=VLD9vShHBreObNg6s4wLBocdfiVU5b/jKnGLjUWoo0JChQySrFHEV5Me
   a3bYo392SB0CdpeMbGTg7PVW4G5J/Dl1cv8oOMcPfmq26VDb0hZxfdkbk
   oSu1sQFMGDSMIyGdixDKnmVZKeLGSYHhx1eN5QtnrcmKOSo7LeHdcwH6b
   fYHSpdVK8aKP2VTC0kXJ/ofDf65+ZEvpWa9OLNqBngMjL0YnAG+MhCKYq
   3GQTK+x/f00tOf5uvCj6ov3LqTJyUCy9Q895ftjiSWB2NGXOdB6i1lfTM
   DtvyeD9YjzjRqQZkRYAwnBlhBDzxg+T0PhvQpoY1Me9mWXDhKslL6+U5J
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224055"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224055"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682460"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 008/103] x86/virt/tdx: Add a helper function to return system wide info about TDX module
Date:   Sun,  7 Aug 2022 15:00:53 -0700
Message-Id: <27ed4f21b23b9679919f2941ed50a4a55a76c3ad.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
definition about it to common place arch/x86/include/asm/tdx.h.

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
index 787b26de8f53..b9567a2217df 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -354,9 +354,9 @@ static int check_cmrs(struct cmr_info *cmr_array, int *actual_cmr_num)
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
@@ -383,6 +383,18 @@ static int tdx_get_sysinfo(struct tdsysinfo_struct *tdsysinfo,
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
@@ -1106,7 +1118,7 @@ static int init_tdx_module(void)
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

