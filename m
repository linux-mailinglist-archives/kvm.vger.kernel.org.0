Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D8E7625BB
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjGYWPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjGYWPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C75DE47;
        Tue, 25 Jul 2023 15:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323337; x=1721859337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vZuTkNlhPpnMmzblXGgyBFUYFK4InJ2dPONAtP9F+Ko=;
  b=RWfIms+rr28yP/KXf3TdP9dmPAl6bSjSUC2pDeD8TaV1J/Y0tKcJJAad
   9MqxnVJrE8S+03uE/SrgOYkUx/+ElMd8U8Eu3cGbD3JkL5t+LKivGM57A
   HZsY12AJreAID8QVS7al0MeaHQBl8v2N7FrZrE5PozglPlkHfv0oMwd+O
   C38zoed1+VoZ/OAeI2RkrusgKZBH9ib28SJoWIMqERjNLOlFFnDPwKTSJ
   yVH9YUAUJNxcCuIXOUcLi/bTIkyVUkfkN/5SFgX6yanDGoClgnTMvsgPD
   Kvl6eM5t9+L373wTLN1O564wmZ1X+3TDu2pZBhcUJnNaXdrVkjpowDd6d
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863026"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863026"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938772"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938772"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:15 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 003/115] KVM: x86/vmx: Refactor KVM VMX module init/exit functions
Date:   Tue, 25 Jul 2023 15:13:14 -0700
Message-Id: <9f7e788b0c7f90d0250ee168f0bc90fffd681415.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

The current module initialization flow is,
0.) Check if VMX is supported,
1.) hyper-v specific initialization,
2.) system-wide x86 specific and vendor specific initialization,
3.) Final VMX specific system-wide initialization,
4.) calculate the sizes of VMX kvm structure and VMX vcpu structure,
5.) report those sizes to the KVM common layer and KVM common
    initialization

Refactor the KVM VMX module initialization function into functions with a
wrapper function to separate VMX logic in vmx.c from a file, main.c, common
among VMX and TDX.  Introduce a wrapper function for vmx_init().

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
 arch/x86/kvm/vmx/main.c    | 50 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c     | 54 +++++---------------------------------
 arch/x86/kvm/vmx/x86_ops.h | 13 ++++++++-
 3 files changed, 68 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a738ae96ca24..27bfd3fcea09 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -164,3 +164,53 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
 	.runtime_ops = &vt_x86_ops,
 	.pmu_ops = &intel_pmu_ops,
 };
+
+static int __init vt_init(void)
+{
+	unsigned int vcpu_size, vcpu_align;
+	int r;
+
+	if (!kvm_is_vmx_supported())
+		return -EOPNOTSUPP;
+
+	/*
+	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
+	 * to unwind if a later step fails.
+	 */
+	hv_init_evmcs();
+
+	r = kvm_x86_vendor_init(&vt_init_ops);
+	if (r)
+		return r;
+
+	r = vmx_init();
+	if (r)
+		goto err_vmx_init;
+
+	/*
+	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
+	 * exposed to userspace!
+	 */
+	vcpu_size = sizeof(struct vcpu_vmx);
+	vcpu_align = __alignof__(struct vcpu_vmx);
+	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
+	if (r)
+		goto err_kvm_init;
+
+	return 0;
+
+err_kvm_init:
+	vmx_exit();
+err_vmx_init:
+	kvm_x86_vendor_exit();
+	return r;
+}
+module_init(vt_init);
+
+static void vt_exit(void)
+{
+	kvm_exit();
+	kvm_x86_vendor_exit();
+	vmx_exit();
+}
+module_exit(vt_exit);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b035d5571fe..8ff2323181fd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -554,7 +554,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static __init void hv_init_evmcs(void)
+__init void hv_init_evmcs(void)
 {
 	int cpu;
 
@@ -590,7 +590,7 @@ static __init void hv_init_evmcs(void)
 	}
 }
 
-static void hv_reset_evmcs(void)
+void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
 
@@ -614,10 +614,6 @@ static void hv_reset_evmcs(void)
 	vp_ap->current_nested_vmcs = 0;
 	vp_ap->enlighten_vmentry = 0;
 }
-
-#else /* IS_ENABLED(CONFIG_HYPERV) */
-static void hv_init_evmcs(void) {}
-static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -2712,7 +2708,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-static bool kvm_is_vmx_supported(void)
+bool kvm_is_vmx_supported(void)
 {
 	int cpu = raw_smp_processor_id();
 
@@ -8429,7 +8425,7 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
@@ -8440,32 +8436,10 @@ static void __vmx_exit(void)
 	vmx_cleanup_l1d_flush();
 }
 
-static void vmx_exit(void)
-{
-	kvm_exit();
-	kvm_x86_vendor_exit();
-
-	__vmx_exit();
-}
-module_exit(vmx_exit);
-
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
-	if (!kvm_is_vmx_supported())
-		return -EOPNOTSUPP;
-
-	/*
-	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
-	 * to unwind if a later step fails.
-	 */
-	hv_init_evmcs();
-
-	r = kvm_x86_vendor_init(&vt_init_ops);
-	if (r)
-		return r;
-
 	/*
 	 * Must be called after common x86 init so enable_ept is properly set
 	 * up. Hand the parameter mitigation value in which was stored in
@@ -8475,7 +8449,7 @@ static int __init vmx_init(void)
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
 	if (r)
-		goto err_l1d_flush;
+		return r;
 
 	vmx_setup_fb_clear_ctrl();
 
@@ -8496,21 +8470,5 @@ static int __init vmx_init(void)
 	if (!enable_ept)
 		allow_smaller_maxphyaddr = true;
 
-	/*
-	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
-	 * exposed to userspace!
-	 */
-	r = kvm_init(sizeof(struct vcpu_vmx), __alignof__(struct vcpu_vmx),
-		     THIS_MODULE);
-	if (r)
-		goto err_kvm_init;
-
 	return 0;
-
-err_kvm_init:
-	__vmx_exit();
-err_l1d_flush:
-	kvm_x86_vendor_exit();
-	return r;
 }
-module_init(vmx_init);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c15c64e99de3..41ae943c62cb 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -8,11 +8,22 @@
 
 #include "x86.h"
 
-__init int vmx_hardware_setup(void);
+#if IS_ENABLED(CONFIG_HYPERV)
+__init void hv_init_evmcs(void);
+void hv_reset_evmcs(void);
+#else /* IS_ENABLED(CONFIG_HYPERV) */
+static inline void hv_init_evmcs(void) {}
+static inline void hv_reset_evmcs(void) {}
+#endif /* IS_ENABLED(CONFIG_HYPERV) */
+
+bool kvm_is_vmx_supported(void);
+int __init vmx_init(void);
+void vmx_exit(void);
 
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
+__init int vmx_hardware_setup(void);
 void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
-- 
2.25.1

