Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5BF6127B3
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJ3GYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiJ3GYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B5AA8;
        Sat, 29 Oct 2022 23:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111038; x=1698647038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mIDDpOSSLkQ6ZJq6nWQZVkipSj1876U7znT7QCkvz98=;
  b=FXn13cgljFfbzCEySnSIGmfcIbbFaX3FbSJrmf6WA+yeORLwrdTkVb4V
   5Hf6uwiDcO1Ed2kxa22BvToXBZKR8e0HaegIkDBfsriz5IRuQAM1UwzfJ
   RQYJKeuZ5bVOyUefM6OQCsP1W4b3Pw12gKKKFMLkQ2fCGFuGEUAci89na
   vuzXs7yxHk9QP3w1heUyOI2+kTzhe8PiwXlW6qsPFPU0033XIc8IwnIq1
   eIG0kk5Uenbu3nusBbbLIS0i1HmAoW6OkyXtc8x0/4ONOmgA7+bfUImS0
   gyFE5YO6uQYZfxyuXhZWQeqyXu1uL15N8nQubU5b2u9K5+Qd/Kxm6rk5n
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037111"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037111"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392833"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392833"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 002/108] KVM: x86: Refactor KVM VMX module init/exit functions
Date:   Sat, 29 Oct 2022 23:22:03 -0700
Message-Id: <f9c8a17903b50150f71d8814b54f149dadec732c.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c    | 37 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 95 ++++++++++++++++++--------------------
 arch/x86/kvm/vmx/x86_ops.h |  5 ++
 3 files changed, 88 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 381059631e4b..4c7e71ec3e1d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -153,3 +153,40 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
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
index 0080d88ded20..1963b28a2ea5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8263,48 +8263,8 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+void __init hv_vp_assist_page_init(void)
 {
-#ifdef CONFIG_KEXEC_CORE
-	RCU_INIT_POINTER(crash_vmclear_loaded_vmcss, NULL);
-	synchronize_rcu();
-#endif
-
-	kvm_exit();
-
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs)) {
-		int cpu;
-		struct hv_vp_assist_page *vp_ap;
-		/*
-		 * Reset everything to support using non-enlightened VMCS
-		 * access later (e.g. when we reload the module with
-		 * enlightened_vmcs=0)
-		 */
-		for_each_online_cpu(cpu) {
-			vp_ap =	hv_get_vp_assist_page(cpu);
-
-			if (!vp_ap)
-				continue;
-
-			vp_ap->nested_control.features.directhypercall = 0;
-			vp_ap->current_nested_vmcs = 0;
-			vp_ap->enlighten_vmentry = 0;
-		}
-
-		static_branch_disable(&enable_evmcs);
-	}
-#endif
-	vmx_cleanup_l1d_flush();
-
-	allow_smaller_maxphyaddr = false;
-}
-module_exit(vmx_exit);
-
-static int __init vmx_init(void)
-{
-	int r, cpu;
-
 #if IS_ENABLED(CONFIG_HYPERV)
 	/*
 	 * Enlightened VMCS usage should be recommended and the host needs
@@ -8315,6 +8275,7 @@ static int __init vmx_init(void)
 	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
 	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
 	    KVM_EVMCS_VERSION) {
+		int cpu;
 
 		/* Check that we have assist pages on all online CPUs */
 		for_each_online_cpu(cpu) {
@@ -8337,11 +8298,38 @@ static int __init vmx_init(void)
 		enlightened_vmcs = false;
 	}
 #endif
+}
 
-	r = kvm_init(&vt_init_ops, sizeof(struct vcpu_vmx),
-		__alignof__(struct vcpu_vmx), THIS_MODULE);
-	if (r)
-		return r;
+void hv_vp_assist_page_exit(void)
+{
+#if IS_ENABLED(CONFIG_HYPERV)
+	if (static_branch_unlikely(&enable_evmcs)) {
+		int cpu;
+		struct hv_vp_assist_page *vp_ap;
+		/*
+		 * Reset everything to support using non-enlightened VMCS
+		 * access later (e.g. when we reload the module with
+		 * enlightened_vmcs=0)
+		 */
+		for_each_online_cpu(cpu) {
+			vp_ap =	hv_get_vp_assist_page(cpu);
+
+			if (!vp_ap)
+				continue;
+
+			vp_ap->nested_control.features.directhypercall = 0;
+			vp_ap->current_nested_vmcs = 0;
+			vp_ap->enlighten_vmentry = 0;
+		}
+
+		static_branch_disable(&enable_evmcs);
+	}
+#endif
+}
+
+int __init vmx_init(void)
+{
+	int r, cpu;
 
 	/*
 	 * Must be called after kvm_init() so enable_ept is properly set
@@ -8351,10 +8339,8 @@ static int __init vmx_init(void)
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
+	if (r)
 		return r;
-	}
 
 	vmx_setup_fb_clear_ctrl();
 
@@ -8380,4 +8366,15 @@ static int __init vmx_init(void)
 
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
index 8cc2182fc6d7..83efb7f92a58 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -8,6 +8,11 @@
 
 #include "x86.h"
 
+void __init hv_vp_assist_page_init(void);
+void hv_vp_assist_page_exit(void);
+int __init vmx_init(void);
+void vmx_exit(void);
+
 __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
 __init int vmx_hardware_setup(void);
-- 
2.25.1

