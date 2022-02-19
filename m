Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B904BCA43
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 19:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243074AbiBSSvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Feb 2022 13:51:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243003AbiBSSuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Feb 2022 13:50:18 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618686E783;
        Sat, 19 Feb 2022 10:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645296599; x=1676832599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vo052RNnwTW+Z9uXQmT1fo4mwVWzLSHdNev74Gshm+Q=;
  b=D1oVx5MWGWUg84Mv6TAnpitCE1rS6Wapenqc2cXJgDxu9zUjjbn1SyJd
   74gxIzC34FOCwYgq6gm/ayMgqqPMfse7tbkTWRyFfv6WPDoSmuPmRZJ/W
   jn9vsb3fFL7SoY/G8Yea7fF4ZG7rPnwodKKAckn/5yW3/cn4T6e1WQ3D+
   0iZGUa7N5qZzTNOitp7xjxEqMw6qb3fJzUneQvwdsK/m2m7fxJrNZXNtg
   dNJdXtPYuCsTDhbgERmwVzbqo9GuHtSSgP3HgzCU0YAzK7NWCiGwUzxtE
   AfW74xHqg8Up015QxoYqufLfOU8WAoXFDrGsGZByOCzVX9eZjqZdQvSxz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10263"; a="312059005"
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="312059005"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:57 -0800
X-IronPort-AV: E=Sophos;i="5.88,381,1635231600"; 
   d="scan'208";a="507137051"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 10:49:57 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH v4 8/8] KVM: TDX: Make TDX VM type supported
Date:   Sat, 19 Feb 2022 10:49:53 -0800
Message-Id: <c9a61eea85cfc5f32cf6c6ce1580b8b466fbd066.1645266955.git.isaku.yamahata@intel.com>
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

As first step TDX VM support, return that TDX VM type supported to device
model, e.g. qemu.  The callback to create guest TD is vm_init callback for
KVM_CREATE_VM.  Add a place holder function and call a function to
initialize TDX module on demand because in that callback VMX is enabled by
hardware_enable callback (vmx_hardware_enable).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 24 ++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/vmx.c     |  5 -----
 arch/x86/kvm/vmx/x86_ops.h |  3 ++-
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 77da926ee505..8103d1c32cc9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,12 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
+
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_DEFAULT_VM || tdx_is_vm_type_supported(type);
+}
 
 static __init int vt_hardware_setup(void)
 {
@@ -19,6 +25,20 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_vm_init(struct kvm *kvm)
+{
+	int ret;
+
+	if (is_td(kvm)) {
+		ret = tdx_module_setup();
+		if (ret)
+			return ret;
+		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
+	}
+
+	return vmx_vm_init(kvm);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -29,9 +49,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
-	.is_vm_type_supported = vmx_is_vm_type_supported,
+	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
+	.vm_init = vt_vm_init,
 
 	.vcpu_create = vmx_vcpu_create,
 	.vcpu_free = vmx_vcpu_free,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e20c21ca9b0f..5275918c860a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -165,6 +165,11 @@ int tdx_module_setup(void)
 	return ret;
 }
 
+bool tdx_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_TDX_VM && READ_ONCE(enable_tdx);
+}
+
 static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
 	u32 max_pa;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ad9e3bae1a6c..7ae1f259c103 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7079,11 +7079,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-bool vmx_is_vm_type_supported(unsigned long type)
-{
-	return type == KVM_X86_DEFAULT_VM;
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f7327bc73be0..78331dbc29f7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -25,7 +25,6 @@ void vmx_hardware_unsetup(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
 bool report_flexpriority(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 int vmx_vcpu_create(struct kvm_vcpu *vcpu);
 int vmx_vcpu_pre_run(struct kvm_vcpu *vcpu);
@@ -130,10 +129,12 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_INTEL_TDX_HOST
 void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
 			unsigned int *vcpu_align, unsigned int *vm_size);
+bool tdx_is_vm_type_supported(unsigned long type);
 void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 #else
 static inline void tdx_pre_kvm_init(
 	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
+static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
 #endif
 
-- 
2.25.1

