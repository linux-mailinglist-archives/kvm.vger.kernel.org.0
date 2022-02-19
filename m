Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E7A4BCA3A
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbiBSSuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:50:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiBSSuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:16 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A6C6E783;
        Sat, 19 Feb 2022 10:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296597; x=1676832597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4SblJoZfaTZJ7IcuVaUEt+KX4MYlsSMH/wg41tunZ+M=;
  b=gjRT5ws+hLCxXmdJpFGFp7wpynClzZaPCoBoiBhFiHVMgfFTvDWNgMLJ
   bzpnZPAioOCGrBV3AQgMlSzOBOr7pn7XPlrsr1KLchGCVV0ZgkQALgk2y
   Vs1X7wrq9wuH5J6veSJTfI3YQmcKARijrSNdQvOlXcje03QOgQWNWVvCT
   oTzsisaa0PIprrX3S5TbNY1HPii6IFn8epHwU1B8yGndld7Q153Kn/ZSL
   ctbBzqPzkybGi6b/zv7Ev8sNb/yRYe1zN+gRftjpVT2hZRxJyVT0A9ZXz
   fLU1xY8XyUtz/mjP3fd7q4sFmteoxVYquuVmI73wwJM4Dt5AmAsHb6T+D
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="312058997"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="312058997"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:56 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="507137034"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:55 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 4/8] KVM: x86: Refactor KVM VMX module init/exit functions
Date:   Sat, 19 Feb 2022 10:49:49 -0800
Message-Id: <61808689e9bbb0bffbddc3f2e7dadc628cf4f863.1645266955.git.isaku.yamahata@intel.com>
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

Currently, KVM VMX module initialization/exit functions are a single
function each.  Refactor KVM VMX module initialization functions into KVM
common part and VMX part so that TDX specific part can be added cleanly.
Opportunistically refactor module exit function as well.

The current module initialization flow is, 1.) calculate the sizes of VMX
kvm structure and VMX vcpu structure, 2.) report those sizes to the KVM
common layer and KVM common initialization, and 3.) VMX specific
system-wide initialization.

Refactor the KVM VMX module initialization function into functions with a
wrapper function to separate VMX logic in vmx.c from a file, main.c, common
among VMX and TDX.  We have a wrapper function,
"vt_init() {vmx_pre_kvm_init(); kvm_init(); vmx_init(); }" in main.c, and
vmx_pre_kvm_init() and vmx_init() in vmx.c.  vmx_pre_kvm_init() calculates
the sizes of VMX kvm structure and KVM vcpu structure, kvm_init() does
system-wide initialization of the KVM common layer, and vmx_init() does
system-wide VMX initialization.

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
 arch/x86/kvm/vmx/main.c    | 33 +++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 97 +++++++++++++++++++-------------------
 arch/x86/kvm/vmx/x86_ops.h |  5 +-
 3 files changed, 86 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index b79fcc8d81dd..8ff13c7881f2 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -165,3 +165,36 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 
 	.runtime_ops = &vt_x86_ops,
 };
+
+static int __init vt_init(void)
+{
+	unsigned int vcpu_size = 0, vcpu_align = 0;
+	int r;
+
+	vmx_pre_kvm_init(&vcpu_size, &vcpu_align);
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
+	vmx_post_kvm_exit();
+	return r;
+}
+module_init(vt_init);
+
+static void vt_exit(void)
+{
+	vmx_exit();
+	kvm_exit();
+	vmx_post_kvm_exit();
+}
+module_exit(vt_exit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbbb398231c1..7ae1f259c103 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7928,47 +7928,12 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void vmx_exit(void)
+void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align)
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
+	if (sizeof(struct vcpu_vmx) > *vcpu_size)
+		*vcpu_size = sizeof(struct vcpu_vmx);
+	if (__alignof__(struct vcpu_vmx) > *vcpu_align)
+		*vcpu_align = __alignof__(struct vcpu_vmx);
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	/*
@@ -8003,11 +7968,38 @@ static int __init vmx_init(void)
 		enlightened_vmcs = false;
 	}
 #endif
+}
 
-	r = kvm_init(&vt_init_ops, sizeof(struct vcpu_vmx),
-		__alignof__(struct vcpu_vmx), THIS_MODULE);
-	if (r)
-		return r;
+void vmx_post_kvm_exit(void)
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
@@ -8017,10 +8009,8 @@ static int __init vmx_init(void)
 	 * mitigation mode.
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
-	if (r) {
-		vmx_exit();
+	if (r)
 		return r;
-	}
 
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
@@ -8044,4 +8034,15 @@ static int __init vmx_init(void)
 
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
index ccf98e79d8c3..7da541e1c468 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -8,7 +8,10 @@
 
 #include "x86.h"
 
-extern struct kvm_x86_init_ops vt_init_ops __initdata;
+void __init vmx_pre_kvm_init(unsigned int *vcpu_size, unsigned int *vcpu_align);
+int __init vmx_init(void);
+void vmx_exit(void);
+void vmx_post_kvm_exit(void);
 
 __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
-- 
2.25.1

