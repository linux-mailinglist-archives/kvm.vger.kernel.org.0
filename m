Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E301D51C6FA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383443AbiEESUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383082AbiEEST1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E5A14081;
        Thu,  5 May 2022 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774544; x=1683310544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eZnEaulazRXd6HNzQIj0/VmrZv00fy3MDt+VIsVcMYQ=;
  b=CTE9JvCCwW80eyUQQAOGaCOo3/BxBPw57KktG4AL6Y3TQyYpPgaRbYq6
   ncCdqNHGi4GZZ2KQomXcmsx/aHWyCscpunawl0Hr0A84mCzdnyL+f+fFm
   m/GaMPtdWbYZrsVZ5nbIIowNp2oNOiSpVqo6ZslDlc+HZABbJoKyDKvYq
   5AfTta4MZ2isjZ+6FXhmxmj2GV4uKzvChjCoDHOsmsE87DgnNGNoXptfr
   rqM3vAijgNTgy+hfsj/qK6EFTEZpnbu+r4xFg0rA1F4W4V1JhJJjiqRQj
   I4iFSO39tp+3X96CDFoKVniMhWS8KqK/PShZt2686kGOplfUf7S2oyUib
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746231"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746231"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083163"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:40 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 011/104] KVM: TDX: Initialize TDX module when loading kvm_intel.ko
Date:   Thu,  5 May 2022 11:14:05 -0700
Message-Id: <752bc449e13cb3e6874ba2d82f790f6f6018813c.1651774250.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/tdx.c          | 66 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |  4 ++
 arch/x86/kvm/x86.c              |  8 ++++
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             | 11 ++++++
 7 files changed, 102 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5bea36d2d5a4..24c15cfe6c32 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1543,6 +1543,7 @@ struct kvm_x86_init_ops {
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
index 5d2b4e87b9b7..34aac9b5d43e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -13,6 +13,72 @@
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
index 65f725a49e67..bf77a8b64647 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11725,6 +11725,14 @@ int kvm_arch_hardware_setup(void *opaque)
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
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1aead3921a16..55dd08cca5d2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1441,6 +1441,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+int kvm_arch_post_hardware_enable_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6b9dbc55af9e..6edce5de54ff 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5686,6 +5686,11 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
+__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
+{
+	return 0;
+}
+
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
@@ -5720,6 +5725,12 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	r = hardware_enable_all();
 	if (r)
 		goto out_free_2;
+	/*
+	 * Arch specific initialization that requires to enable virtualization
+	 * feature.  e.g. TDX module initialization requires VMXON on all
+	 * present CPUs.
+	 */
+	kvm_arch_post_hardware_enable_setup(opaque);
 	hardware_disable_all();
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
-- 
2.25.1

