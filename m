Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17AC25F0857
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiI3KTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiI3KS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6BC15ED2D;
        Fri, 30 Sep 2022 03:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533134; x=1696069134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kzvGioDqr+rWmmxO+5tT4VLP7I0/691CCzSrwXRqIXc=;
  b=NHvCTxVVNpd+PLXuu+U/um5La6jWDYqVLvW+qnfk0QSRHq5oJ+MApBRi
   Pv57zmVCwtHW6X5eVQzFg71TCsqs/YrVs9InnejZGSCv2i6neL9Ujodrh
   vhqgELwzBmChGSPWkYIpZhxoGLi/O8a38EYr3oWh4h6x7f7EkbPM3Ru6v
   5UKw/T6vU8HKR7YRbKEuGl4E5rSM1l4hRQgjwcNTPC+gIS8fq5DWZ2rCU
   eVbWJXUGRF9PMNq/xSzaVeHo4iCAckzKM3hPJ3aATIl9QNY+jcfcl6X9H
   hoN/WE8D6yyU7NpZg/rafH0AaXVkGFha5PzO06gcdsMdGORwUOzYKUVVK
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="366207470"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="366207470"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:51 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807509"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807509"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 002/105] KVM: x86: Refactor KVM VMX module init/exit functions
Date:   Fri, 30 Sep 2022 03:16:56 -0700
Message-Id: <686a3b29589bbbe0d1d3ebee434008eab8e26599.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 636768f5b985..5b4aff7a31b6 100644
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
index 6d5eb74fedfb..7bad73d5822e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8270,48 +8270,8 @@ static void vmx_cleanup_l1d_flush(void)
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
@@ -8322,6 +8282,7 @@ static int __init vmx_init(void)
 	    ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED &&
 	    (ms_hyperv.nested_features & HV_X64_ENLIGHTENED_VMCS_VERSION) >=
 	    KVM_EVMCS_VERSION) {
+		int cpu;
 
 		/* Check that we have assist pages on all online CPUs */
 		for_each_online_cpu(cpu) {
@@ -8344,11 +8305,38 @@ static int __init vmx_init(void)
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
@@ -8358,10 +8346,8 @@ static int __init vmx_init(void)
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
+	if (r)
 		return r;
-	}
 
 	vmx_setup_fb_clear_ctrl();
 
@@ -8387,4 +8373,15 @@ static int __init vmx_init(void)
 
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
index 85da24ecb25f..c0ff4b88e8f9 100644
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

