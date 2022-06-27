Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2500955C602
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbiF0VzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiF0Vyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343FB5F7F;
        Mon, 27 Jun 2022 14:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366891; x=1687902891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bTiX+yBNdL2eTTnzcCWVKq+r0jw8enSd44GcJacs9Eg=;
  b=ngNau+1+G9ZEHMZS/VcqE7hWWZmNl+cfx02o7cFFnARGGpbadvzd3cqE
   gngau0R6FzmizQ12HrXSJPmAggdjmhLJW8cn9/eYaqhT78BtkFJl7PQSg
   yXa6zZf5HFaDCAL8ERzqfv9+shybRqCt5Krn+5J3GDMhZ2bLaqis+gEms
   kgs4DYMTVpWuHv73Mfzn22HPG00ZXUSnCYMPANPihDGU9S1KDEiOK9Wn6
   90C8+A6h++F/5637pc57Saq9rURM8kjMwRp1nYyVFG+kMQnDdM7NpF2iV
   /xQ5F7gf3KLS7KvruEUe7yUEPrZ9s/YE0ujZazp9NisW1NpAomI1EHcZJ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609505"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609505"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863463"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v7 011/102] KVM: TDX: Initialize TDX module when loading kvm_intel.ko
Date:   Mon, 27 Jun 2022 14:53:03 -0700
Message-Id: <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
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

To use TDX functionality, TDX module needs to be loaded and initialized.
A TDX host patch series[1] implements the detection of the TDX module,
tdx_detect() and its initialization, tdx_init().

This patch is to call those functions, tdx_detect() and tdx_init(), when
loading kvm_intel.ko.

Add a hook, kvm_arch_post_hardware_enable_setup, to module initialization
while hardware is enabled, i.e. after hardware_enable_all() and before
hardware_disable_all().  Because TDX requires all present CPUs to enable
VMX (VMXON).

[1] https://lore.kernel.org/lkml/cover.1649219184.git.kai.huang@intel.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/main.c         | 11 ++++++
 arch/x86/kvm/vmx/tdx.c          | 60 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |  4 +++
 arch/x86/kvm/x86.c              |  8 +++++
 5 files changed, 84 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 62dec97f6607..aa11525500d3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1639,6 +1639,7 @@ struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
 	int (*hardware_setup)(void);
+	int (*post_hardware_enable_setup)(void);
 	unsigned int (*handle_intel_pt_intr)(void);
 
 	struct kvm_x86_ops *runtime_ops;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 349534412216..ac788af17d92 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -23,6 +23,16 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int __init vt_post_hardware_enable_setup(void)
+{
+	enable_tdx = enable_tdx && !tdx_module_setup();
+	/*
+	 * Even if it failed to initialize TDX module, conventional VMX is
+	 * available.  Keep VMX usable.
+	 */
+	return 0;
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -165,6 +175,7 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.cpu_has_kvm_support = vmx_cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
 	.hardware_setup = vt_hardware_setup,
+	.post_hardware_enable_setup = vt_post_hardware_enable_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2617389ef466..9cb36716b0f3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,6 +13,66 @@
 static u64 hkid_mask __ro_after_init;
 static u8 hkid_start_pos __ro_after_init;
 
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
+static struct tdx_capabilities tdx_caps;
+
+int __init tdx_module_setup(void)
+{
+	const struct tdsysinfo_struct *tdsysinfo;
+	int ret = 0;
+
+	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
+	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
+
+	ret = tdx_init();
+	if (ret) {
+		pr_info("Failed to initialize TDX module.\n");
+		return ret;
+	}
+
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
+	return 0;
+}
+
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
 	u32 max_pa;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 060bf48ec3d6..54d7a26ed9ee 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,6 +3,8 @@
 #define __KVM_X86_TDX_H
 
 #ifdef CONFIG_INTEL_TDX_HOST
+int tdx_module_setup(void);
+
 struct kvm_tdx {
 	struct kvm kvm;
 	/* TDX specific members follow. */
@@ -37,6 +39,8 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 #else
+static inline int tdx_module_setup(void) { return -ENODEV; };
+
 struct kvm_tdx {
 	struct kvm kvm;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 30af2bd0b4d5..fb7a33fbc136 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11792,6 +11792,14 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
+int kvm_arch_post_hardware_enable_setup(void *opaque)
+{
+	struct kvm_x86_init_ops *ops = opaque;
+	if (ops->post_hardware_enable_setup)
+		return ops->post_hardware_enable_setup();
+	return 0;
+}
+
 void kvm_arch_hardware_unsetup(void)
 {
 	kvm_unregister_perf_callbacks();
-- 
2.25.1

