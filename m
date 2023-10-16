Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88007CAFCE
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjJPQiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbjJPQhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A98420C;
        Mon, 16 Oct 2023 09:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473182; x=1729009182;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hW7bw7dIeJIk/4r+qouw8fVNFncXJvBVCsiISnCSMgw=;
  b=F6PqRwkesYpjqbq0DnHbz8Ho4vL3ZZ8Nunu5Ie9nGkhriYokJt5LLv/+
   L0cNnS63X1ZAF8xCknWGG9Snzqa9Mqy/hDfs9kfZobtt3tzj+J3qxEcAL
   Mf8MzvP5RMQ7+T1ms0BSvDld5Kw48hEwcbNfnlJkFVSljs9Wdm+aeG2vu
   bGh1unQ9Ywmd1iybVUO3ki6L6fqu/jWxjBsZcnFWTw4dyhK4DC+O910AY
   U9JWLHknrDVNDCCfI3aS2e1jZ2NA8XIfA7/eBfEYZKQ5cJziInqmjPdoj
   k0oxvK6tFra56Xx4dqybU7dr9zBEvNLxIN3HD37kWpIOMWthiMH0Lcbpl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825866"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825866"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087125959"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087125959"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:21 -0700
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
Subject: [PATCH v16 003/116] KVM: x86/vmx: Refactor KVM VMX module init/exit functions
Date:   Mon, 16 Oct 2023 09:13:15 -0700
Message-Id: <e8fd545edad73cd5b161ff41a697f44b2bcebe22.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
index 3b89cb721fe8..4059364fc5e0 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -165,3 +165,53 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
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
index 3627b704ff37..d9f2f00af427 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -544,7 +544,7 @@ static int hv_enable_l2_tlb_flush(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static __init void hv_init_evmcs(void)
+__init void hv_init_evmcs(void)
 {
 	int cpu;
 
@@ -580,7 +580,7 @@ static __init void hv_init_evmcs(void)
 	}
 }
 
-static void hv_reset_evmcs(void)
+void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
 
@@ -604,10 +604,6 @@ static void hv_reset_evmcs(void)
 	vp_ap->current_nested_vmcs = 0;
 	vp_ap->enlighten_vmentry = 0;
 }
-
-#else /* IS_ENABLED(CONFIG_HYPERV) */
-static void hv_init_evmcs(void) {}
-static void hv_reset_evmcs(void) {}
 #endif /* IS_ENABLED(CONFIG_HYPERV) */
 
 /*
@@ -2748,7 +2744,7 @@ static bool __kvm_is_vmx_supported(void)
 	return true;
 }
 
-static bool kvm_is_vmx_supported(void)
+bool kvm_is_vmx_supported(void)
 {
 	bool supported;
 
@@ -8468,7 +8464,7 @@ static void vmx_cleanup_l1d_flush(void)
 	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
 }
 
-static void __vmx_exit(void)
+void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
 
@@ -8477,32 +8473,10 @@ static void __vmx_exit(void)
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
@@ -8512,7 +8486,7 @@ static int __init vmx_init(void)
 	 */
 	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
 	if (r)
-		goto err_l1d_flush;
+		return r;
 
 	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
@@ -8529,21 +8503,5 @@ static int __init vmx_init(void)
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
index 0c8fbd29b969..c6bb2fe9ddb9 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -6,11 +6,22 @@
 
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

