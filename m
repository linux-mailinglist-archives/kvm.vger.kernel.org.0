Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4AD55CC45
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241416AbiF0VzJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241219AbiF0Vyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:51 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE98855BA;
        Mon, 27 Jun 2022 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366890; x=1687902890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RmwS4at7KcMMcvFWZ+jMDE/6pPfqsSM/BZDJBCrcQTI=;
  b=mkAobFtHiZmVBJOaZ2yMwWkjPt9fOPUxxvnX1kJ2gAWA7o03BxfU4f/o
   0rbjEIn1bU2P/KBoMkzXkVtZFrIJZHm8LG0QjzCovYj2OxLCKE7TruKig
   B2oueGJ730ICVPg+1pe+Ueu1IgxigkNgYZSj+eJ9sYObHe2O5UKSRmvLR
   OnDHp+KKJ49xE4D9s1Eo1THcYCt6BE0UcxW2R1Km3FjPag4FUUmarf/0J
   ffzuerAifLgpp4mdsrsoGtM7JlHX9M4sGliKxz/KhpxXZiEBk4RzS8z9a
   xYb93cU0+uZVYjJtM+bJnwbIrOJyjPzAQJY2b43UulePecDyQxGDMUH01
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609502"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609502"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863452"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 008/102] KVM: x86: Refactor KVM VMX module init/exit functions
Date:   Mon, 27 Jun 2022 14:53:00 -0700
Message-Id: <b8761fc945630d6f264ff22a388d286394a2904f.1656366338.git.isaku.yamahata@intel.com>
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

Currently, KVM VMX module initialization/exit functions are a single
function each.  Refactor KVM VMX module initialization functions into KVM
common part and VMX part so that TDX specific part can be added cleanly.
Opportunistically refactor module exit function as well.

The current module initialization flow is, 1.) calculate the sizes of VMX
kvm structure and VMX vcpu structure, 2.) hyper-v specific initialization
3.) report those sizes to the KVM common layer and KVM common
initialization, and 4.) VMX specific system-wide initialization.

Refactor the KVM VMX module initialization function into functions with a
wrapper function to separate VMX logic in vmx.c from a file, main.c, common
among VMX and TDX.  We have a wrapper function, "vt_init() {vmx kvm/vcpu
size calculation; hv_vp_assist_page_init(); kvm_init(); vmx_init(); }" in
main.c, and hv_vp_assist_page_init() and vmx_init() in vmx.c.
hv_vp_assist_page_init() initializes hyper-v specific assist pages,
kvm_init() does system-wide initialization of the KVM common layer, and
vmx_init() does system-wide VMX initialization.

The KVM architecture common layer allocates struct kvm with reported size
for architecture-specific code.  The KVM VMX module defines its structure
as struct vmx_kvm { struct kvm; VMX specific members;} and uses it as
struct vmx kvm.  Similar for vcpu structure. TDX KVM patches will define
TDX specific kvm and vcpu structures, add tdx_pre_kvm_init() to report the
sizes of them to the KVM common layer.

The current module exit function is also a single function, a combination
of VMX specific logic and common KVM logic.  Refactor it into VMX specific
logic and KVM common logic.  This is just refactoring to keep the VMX
specific logic in vmx.c from main.c.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  38 +++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 106 ++++++++++++++++++-------------------
 arch/x86/kvm/vmx/x86_ops.h |   6 +++
 3 files changed, 95 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fabf5f22c94f..371dad728166 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -169,3 +169,41 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static int __init vt_init(void)
+{
+	unsigned int vcpu_size, vcpu_align;
+	int r;
+
+	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
+	vcpu_size = sizeof(struct vcpu_vmx);
+	vcpu_align = __alignof__(struct vcpu_vmx);
+
+	hv_vp_assist_page_init();
+	vmx_init_early();
+
+	r = kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
+	if (r)
+		goto err_vmx_post_exit;
+
+	r = vmx_init();
+	if (r)
+		goto err_kvm_exit;
+
+	return 0;
+
+err_kvm_exit:
+	kvm_exit();
+err_vmx_post_exit:
+	hv_vp_assist_page_exit();
+	return r;
+}
+module_init(vt_init);
+
+static void vt_exit(void)
+{
+	vmx_exit();
+	kvm_exit();
+	hv_vp_assist_page_exit();
+}
+module_exit(vt_exit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 286947c00638..b30d73d28e75 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8181,15 +8181,45 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+void __init hv_vp_assist_page_init(void)
 {
-#ifdef CONFIG_KEXEC_CORE
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
-#endif
+#if IS_ENABLED(CONFIG_HYPERV)
+	/*
+	 * Enlightened VMCS usage should be recommended and the host needs
+	 * to support eVMCS v1 or above. We can also disable eVMCS support
+	 * with module parameter.
+	 */
+	if (enlightened_vmcs &&
+	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
+	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
+	    KVM_EVMCS_VERSION) {
+		int cpu;
+
+		/* Check that we have assist pages on all online CPUs */
+		for_each_online_cpu(cpu) {
+			if (!hv_get_vp_assist_page(cpu)) {
+				enlightened_vmcs = false;
+				break;
+			}
+		}
 
-	kvm_exit();
+		if (enlightened_vmcs) {
+			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
+			static_branch_enable(&enable_evmcs);
+		}
+
+		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
+			vt_x86_ops.enable_direct_tlbflush
+				= hv_enable_direct_tlbflush;
 
+	} else {
+		enlightened_vmcs = false;
+	}
+#endif
+}
+
+void hv_vp_assist_page_exit(void)
+{
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (static_branch_unlikely(&enable_evmcs)) {
 		int cpu;
@@ -8213,14 +8243,10 @@ static void vmx_exit(void)
 		static_branch_disable(&enable_evmcs);
 	}
 #endif
-	vmx_cleanup_l1d_flush();
-
-	allow_smaller_maxphyaddr = false;
 }
-module_exit(vmx_exit);
 
 /* initialize before kvm_init() so that hardware_enable/disable() can work. */
-static void __init vmx_init_early(void)
+void __init vmx_init_early(void)
 {
 	int cpu;
 
@@ -8228,49 +8254,10 @@ static void __init vmx_init_early(void)
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 }
 
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	/*
-	 * Enlightened VMCS usage should be recommended and the host needs
-	 * to support eVMCS v1 or above. We can also disable eVMCS support
-	 * with module parameter.
-	 */
-	if (enlightened_vmcs &&
-	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
-	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
-	    KVM_EVMCS_VERSION) {
-
-		/* Check that we have assist pages on all online CPUs */
-		for_each_online_cpu(cpu) {
-			if (!hv_get_vp_assist_page(cpu)) {
-				enlightened_vmcs = false;
-				break;
-			}
-		}
-
-		if (enlightened_vmcs) {
-			pr_info("KVM: vmx: using Hyper-V Enlightened VMCS\n");
-			static_branch_enable(&enable_evmcs);
-		}
-
-		if (ms_hyperv.nested_features & HV_X64_NESTED_DIRECT_FLUSH)
-			vt_x86_ops.enable_direct_tlbflush
-				= hv_enable_direct_tlbflush;
-
-	} else {
-		enlightened_vmcs = false;
-	}
-#endif
-
-	vmx_init_early();
-	r = kvm_init(&vt_init_ops, sizeof(struct vcpu_vmx),
-		__alignof__(struct vcpu_vmx), THIS_MODULE);
-	if (r)
-		return r;
-
 	/*
 	 * Must be called after kvm_init() so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
@@ -8279,10 +8266,8 @@ static int __init vmx_init(void)
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
+	if (r)
 		return r;
-	}
 
 	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
@@ -8303,4 +8288,15 @@ static int __init vmx_init(void)
 
 	return 0;
 }
-module_init(vmx_init);
+
+void vmx_exit(void)
+{
+#ifdef CONFIG_KEXEC_CORE
+	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
+	synchronize_rcu();
+#endif
+
+	vmx_cleanup_l1d_flush();
+
+	allow_smaller_maxphyaddr = false;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 0a5967a91e26..2abead2f60f7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -8,6 +8,12 @@
 
 #include "x86.h"
 
+void __init hv_vp_assist_page_init(void);
+void hv_vp_assist_page_exit(void);
+void __init vmx_init_early(void);
+int __init vmx_init(void);
+void vmx_exit(void);
+
 __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
 __init int vmx_hardware_setup(void);
-- 
2.25.1

