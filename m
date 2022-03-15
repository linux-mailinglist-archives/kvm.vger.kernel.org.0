Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF6D4DA5B3
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 23:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352391AbiCOWva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 18:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243678AbiCOWv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 18:51:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E2C5D1A2;
        Tue, 15 Mar 2022 15:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647384616; x=1678920616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DcYwzhG3BAwKMmOKfVqm6mROgZ/YXgBVRreQCgMf4e4=;
  b=mcxReMi3TBrKxXGKeREvHU7go2IIqu3VKcNO2ibLy4VuByIS2ZjHUcAa
   2GTOWMcX1YNaaHoQNSD+mOExO/UrT8s40WFuOUDQt4J026a9il93og8li
   Ij7NPHEeW/i0zYZV+5pw9XXY268CSSGWvZhTgbbrg83e8+OlJT8LYsZ1M
   zQuxilBvCmCXlUgZvElHtUpkz9SWcWe4GchfbIZjv+1iQgxfCJUjFCuUN
   yOggmVau9MTGFUfrIQqAy0IraXrvqPhsqazY8rHQuVQ+ionc4LhDi65ab
   vhgYxRrj2GuUkxfqhYFWWGSaJuyEs9jY9xmoABjyUDH7zTzvqneWyfRb/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256390617"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="256390617"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:50:12 -0700
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="690368461"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 15:50:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 3/6] KVM: x86: Refactor KVM VMX module init/exit functions
Date:   Tue, 15 Mar 2022 15:50:07 -0700
Message-Id: <cc018c435253c8855fe49aa8228918cb0f620095.1647384147.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647384147.git.isaku.yamahata@intel.com>
References: <cover.1647384147.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
TDX specific kvm and vcpu structures.

The current module exit function is also a single function, a combination
of VMX specific logic and common KVM logic.  Refactor it into VMX specific
logic and KVM common logic.  This is just refactoring to keep the VMX
specific logic in vmx.c from main.c.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 37 +++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 94 ++++++++++++++++++--------------------
 arch/x86/kvm/vmx/x86_ops.h |  5 +-
 3 files changed, 86 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index b08ea9c42a11..8b50427f404b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -152,3 +152,40 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 
 	.runtime_ops = &vt_x86_ops,
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
index f1c44ad712f7..538b91380c06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7935,48 +7935,8 @@ static void vmx_cleanup_l1d_flush(void)
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
@@ -8010,11 +7970,38 @@ static int __init vmx_init(void)
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
@@ -8024,10 +8011,8 @@ static int __init vmx_init(void)
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
@@ -8051,4 +8036,15 @@ static int __init vmx_init(void)
 
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
index 40c64fb1f505..74465c3d3c5f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -8,7 +8,10 @@
 
 #include "x86.h"
 
-extern struct kvm_x86_init_ops vt_init_ops __initdata;
+void __init hv_vp_assist_page_init(void);
+void hv_vp_assist_page_exit(void);
+int __init vmx_init(void);
+void vmx_exit(void);
 
 __init int vmx_cpu_has_kvm_support(void);
 __init int vmx_disabled_by_bios(void);
-- 
2.25.1

