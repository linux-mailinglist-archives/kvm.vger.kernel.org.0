Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4664CDEC0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiCDUGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiCDUFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:05:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B0030CA85;
        Fri,  4 Mar 2022 12:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424048; x=1677960048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2VYyDBp716atpLdIeTCIy/lhUdjnWQmuOi4aigMsSJU=;
  b=UHVvVtTvAU+0NvYf2IftUqBp6ItSTrYsFG2Y5xskI39JDMp7dUHJMg21
   AmQE7Qe8KzZrfoksEYy7CZCWiOhxPJanCaDInHl7+Xho+onoHnUOcghxa
   Z+VH1v4UhCZUwTBnk2tJXJs9RYhSIkvag58qA7iP9T0zmkYFc/UHCAIH8
   T0W2AVg9TpbNXjA2E9Rjxa6xBD2HuAK3IZa7BxgIvEb7DTAgfjTNoTX4P
   EUTbqntEV1FRROTAqPvIESKO48N5OnNEZHoYO/2xNpRoPnFdhTxTa4imO
   X5eLsnWzxXp/sXYSesoclfydjntFSQhhjwWUoVG72LXPOpQcuWoQuHa4u
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983309"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983309"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344107"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:05 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize TDX module
Date:   Fri,  4 Mar 2022 11:48:24 -0800
Message-Id: <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/tdx.c | 89 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h |  4 ++
 2 files changed, 93 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8ed3ec342e28..8adc87ad1807 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,9 +13,98 @@
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
+	ret = tdx_detect();
+	if (ret) {
+		pr_info("Failed to detect TDX module.\n");
+		return ret;
+	}
+
+	ret = tdx_init();
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
index daf6bfc6502a..d448e019602c 100644
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
@@ -35,6 +37,8 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 #else
+static inline int tdx_module_setup(void) { return -ENODEV; };
+
 struct kvm_tdx;
 struct vcpu_tdx;
 
-- 
2.25.1

