Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0414BCA3E
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbiBSSua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:50:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242977AbiBSSuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:17 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1E56EB34;
        Sat, 19 Feb 2022 10:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296598; x=1676832598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c5TjtmUvH3v76ft3vrdPXQGN2Fwdl7Eiwurs65tphiE=;
  b=J45jcyD5Ikpgs1s/So/+wPVZhCwzA/4ro/o5PtNx4tsiHXociKYJX0pn
   YcGdhQ/gver/9DwqAXlDccC1LzvCL3QLJFuwRLvehNzma967nERcvk7vL
   Oo8msUylNr9uysOgw2E2wwknRMGVvm16XoTjB5aGmKWh6mXJACfkPmm8Q
   KG0Fy8oyE5OEmJh6PPfhs5UFgTDfr72BZpww87hno1AjwMKesVfFs0q4d
   6b7vYOqgrw4OxmVhed6d92m2E7Ohci03VlYnEtK48KhIloGoOh/flgdRN
   8Q5OipgxpgxSem4afcU6Jsain1nieLyHZMTChmkyDTptqTXt28aU+wjV3
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="312059000"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="312059000"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="507137042"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:56 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 6/8] KVM: TDX: Add a function to initialize TDX module
Date:   Sat, 19 Feb 2022 10:49:51 -0800
Message-Id: <669f8470758eed1f26e7004db59c47da1aa3a937.1645266955.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1645266955.git.isaku.yamahata@intel.com>
References: <cover.1645266955.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Memory used for TDX is encrypted with an encryption key.  An encryption key
is assigned to guest TD, and TDX memory is encrypted.  VMM calculates Trust
Domain Memory Range (TDMR), a range of memory pages that can hold TDX
memory encrypted with an encryption key.  VMM allocates memory regions for
Physical Address Metadata Table (PAMT) which the TDX module uses to track
page states. Used for TDX memory, assigned to which guest TD, etc.  VMM
gives PAMT regions to the TDX module and initializes it which is also
encrypted.

TDX requires more initialization steps in addition to VMX.  As a
preparation step, check if the CPU feature is available and enable VMX
because the TDX module API requires VMX to be enabled to be functional.
The next step is basic platform initialization.  Check if TDX module API is
available, call system-wide initialization API (TDH.SYS.INIT), and call LP
initialization API (TDH.SYS.LP.INIT).  Lastly, get system-wide
parameters (TDH.SYS.INFO), allocate PAMT for TDX module to track page
states (TDH.SYS.CONFIG), configure encryption key (TDH.SYS.KEY.CONFIG), and
initialize PAMT (TDH.SYS.TDMR.INIT).

A TDX host patch series implements those details and it provides APIs,
seamrr_enabled() to check if CPU feature is available, init_tdx() to
initialize the TDX module, tdx_get_tdsysinfo() to get TDX system
parameters.

Add a wrapper function to initialize the TDX module and get system-wide
parameters via those APIs.  Because TDX requires VMX enabled, It will be
called on-demand when the first guest TD is created via x86 KVM init_vm
callback.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 141 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h |   4 ++
 2 files changed, 145 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c714c84a0671..e20c21ca9b0f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -18,12 +18,153 @@ bool seamrr_enabled(void);
 static inline bool seamrr_enabled(void) { return false; }
 #endif
 
+/*
+ * workaround to compile.
+ * TODO: once the TDX module initiation code in x86 host is merged, remove this.
+ */
+#if __has_include(<asm/tdx_host.h>)
+#include <asm/tdx_host.h>
+#else
+struct tdx_cpuid_config {
+	u32 leaf;
+	u32 sub_leaf;
+	u32 eax;
+	u32 ebx;
+	u32 ecx;
+	u32 edx;
+} __packed;
+
+struct tdsysinfo_struct {
+	/* The TDX Module Info */
+	u32 attributes;
+	u32 vendor_id;
+	u32 build_date;
+	u16 build_num;
+	u16 minor_version;
+	u16 major_version;
+	u8 reserved0[14];
+
+	/* Memory Info */
+	u16 max_tdmrs;
+	u16 max_reserved_per_tdmr;
+	u16 pamt_entry_size;
+	u8 reserved1[10];
+
+	/* Control Struct Info */
+	u16 tdcs_base_size;
+	u8 reserved2[2];
+	u16 tdvps_base_size;
+	u8 tdvps_xfam_dependent_size;
+	u8 reserved3[9];
+
+	/* TD Capabilities */
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+	u8 reserved4[32];
+	u32 num_cpuid_config;
+
+	/* TD CPUIDs */
+	union {
+		struct tdx_cpuid_config cpuid_configs[0];
+		u8 reserved5[892];
+	};
+} __packed __aligned(1024);
+
+static inline int init_tdx(void) { return -ENODEV; }
+static inline const struct tdsysinfo_struct *tdx_get_sysinfo(void) { return NULL; }
+#endif
+
 static bool __read_mostly enable_tdx = true;
 module_param_named(tdx, enable_tdx, bool, 0644);
 
+#define TDX_MAX_NR_CPUID_CONFIGS					\
+	((sizeof(struct tdsysinfo_struct) -				\
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
+struct tdx_capabilities tdx_caps;
+
 static u64 hkid_mask __ro_after_init;
 static u8 hkid_start_pos __ro_after_init;
 
+static int __tdx_module_setup(void)
+{
+	const struct tdsysinfo_struct *tdsysinfo;
+	int ret = 0;
+
+	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
+	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
+
+	ret = init_tdx();
+	if (ret) {
+		pr_info("Failed to initialize TDX module.\n");
+		return ret;
+	}
+
+	tdsysinfo = tdx_get_sysinfo();
+	if (tdx_caps.nr_cpuid_configs > TDX_MAX_NR_CPUID_CONFIGS)
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
+	return 0;
+}
+
+int tdx_module_setup(void)
+{
+	static DEFINE_MUTEX(tdx_init_lock);
+	static bool __read_mostly tdx_module_initialized;
+	int ret = 0;
+
+	mutex_lock(&tdx_init_lock);
+
+	if (!tdx_module_initialized) {
+		if (enable_tdx) {
+			ret = __tdx_module_setup();
+			if (ret)
+				enable_tdx = false;
+			else
+				tdx_module_initialized = true;
+		} else
+			ret = -EOPNOTSUPP;
+	}
+
+	mutex_unlock(&tdx_init_lock);
+	return ret;
+}
+
 static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
 	u32 max_pa;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 3876c93da6de..616fbf79b129 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,6 +3,8 @@
 #define __KVM_X86_TDX_H
 
 #ifdef CONFIG_INTEL_TDX_HOST
+int tdx_module_setup(void);
+
 struct kvm_tdx {
 	struct kvm kvm;
 };
@@ -31,6 +33,8 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 #else
+static inline int tdx_module_setup(void) { return -ENODEV; };
+
 struct kvm_tdx;
 struct vcpu_tdx;
 
-- 
2.25.1

