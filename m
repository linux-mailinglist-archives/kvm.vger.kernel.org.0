Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62BC667B35
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240553AbjALQk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbjALQha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:30 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4D2DF26;
        Thu, 12 Jan 2023 08:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541230; x=1705077230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ur0iVrVgekV+GtSIMp49n//zlwM3sDwgsV/JD39cVbY=;
  b=XZhGKF8Ki6WSPtIGwvH1ammU2ioET3nFS0mFZsj5bffY0m7IdLzw5lHF
   WpHJB4FAL3ooO1xi0lgR/03O+HtQi6h6zcY8DBqSrtQiv3kOWSeILKwxo
   YcboTEjszpTsbnemX+Swh7QG/lqLEnNDZ7ZE1hEuo3VutIrmN2PZu3Czb
   lBERv4kr4mH1EbmNT7+gKk3QKBv6NqP0bZ8hmPTV7rrzp2111PJGIbq9/
   mnvkXfXN1csxbP8I8xcgl23o6/P2Ov+3YTsv+40svpqJifKevpqi+p1uz
   fvYhH77glvUiPWlgWvFqAOpWDvmD/zOBw62g+xUH6x40gUk+ZzZ/Kyfax
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811669"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811669"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151641"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151641"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:20 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 006/113] KVM: TDX: Make TDX VM type supported
Date:   Thu, 12 Jan 2023 08:31:14 -0800
Message-Id: <6def82bac5d52bd729cd06f39e9e59f0409e32f8.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

NOTE: This patch is in position of the patch series for developers to be
able to test codes during the middle of the patch series although this
patch series doesn't provide functional features until the all the patches
of this patch series.  When merging this patch series, this patch can be
moved to the end.

As first step TDX VM support, return that TDX VM type supported to device
model, e.g. qemu.  The callback to create guest TD is vm_init callback for
KVM_CREATE_VM.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     |  6 ++++++
 arch/x86/kvm/vmx/vmx.c     |  5 -----
 arch/x86/kvm/vmx/x86_ops.h |  3 ++-
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 3b24e32077d6..e3c5e9250990 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,12 @@
 static bool enable_tdx __ro_after_init = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
 module_param_named(tdx, enable_tdx, bool, 0444);
 
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return type == KVM_X86_DEFAULT_VM ||
+		(enable_tdx && tdx_is_vm_type_supported(type));
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -23,6 +29,14 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static int vt_vm_init(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
+
+	return vmx_vm_init(kvm);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
@@ -34,9 +48,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
-	.is_vm_type_supported = vmx_is_vm_type_supported,
+	.is_vm_type_supported = vt_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
-	.vm_init = vmx_vm_init,
+	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
 
 	.vcpu_precreate = vmx_vcpu_precreate,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d7a276118940..6c7d9ec53046 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -25,6 +25,12 @@ static int __init tdx_module_setup(void)
 	return 0;
 }
 
+bool tdx_is_vm_type_supported(unsigned long type)
+{
+	/* enable_tdx check is done by the caller. */
+	return type == KVM_X86_TDX_VM;
+}
+
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
 	int r;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f1dea386d6c2..5dc7687dcf16 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7501,11 +7501,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
index 6980126bc32a..8fd34842a06b 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -32,7 +32,6 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
@@ -140,8 +139,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+bool tdx_is_vm_type_supported(unsigned long type);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
+static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

