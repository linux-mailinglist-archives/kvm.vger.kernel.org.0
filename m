Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB277CAFB0
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbjJPQgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjJPQfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:35:46 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F27644A0;
        Mon, 16 Oct 2023 09:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473197; x=1729009197;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZT0rWw9wfF5GuIj8zOyP9lk3DAHayUecH8rpS7ia4pk=;
  b=GNacoVmQ1q1gtjX/71ZM4chWJvRP+sdxMF0IhIppDbtIFwxPkAzDT1ZT
   IZ1h8aqmC/8N0gYJgY5YWrxXW1gKIKcDjCZUqMHLpo8Mfs6MU0+9Fe5nM
   226iZeBi6VFA7pi+IAE25zTIJvXwXGTOScz0GuQ19DiUBAoKk4CL2fro3
   ApuafDHtwVY3RP6My/nlp1Jrxxp/Z+P9ewen+ogcgZij/Et4/tLXX0VLq
   DSes5KczMvzDjxOPp3cROD4CfnJpSENPn8Ho1t9V4TJsuTH+lByTIAPSS
   MdENzIOxn/MptZlNWJmRUgrdY3cVfpQkwCR0VYFwg2PVUHUzkxAYLhrac
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825890"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825890"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087125980"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087125980"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:23 -0700
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
Subject: [PATCH v16 007/116] KVM: TDX: Make TDX VM type supported
Date:   Mon, 16 Oct 2023 09:13:19 -0700
Message-Id: <8db62f1321f6894b0f8132843199bfe5671f7b3a.1697471314.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/vmx.c     |  6 ------
 arch/x86/kvm/vmx/x86_ops.h |  3 ++-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 1d423abd124b..8ca23adfcfb8 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,12 @@
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
+static bool vt_is_vm_type_supported(unsigned long type)
+{
+	return __kvm_is_vm_type_supported(type) ||
+		(enable_tdx && tdx_is_vm_type_supported(type));
+}
+
 static int vt_hardware_enable(void)
 {
 	int ret;
@@ -37,6 +43,14 @@ static __init int vt_hardware_setup(void)
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
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -57,9 +71,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 1c9884164566..9d3f593eacb8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -24,6 +24,12 @@ static int __init tdx_module_setup(void)
 	return 0;
 }
 
+bool tdx_is_vm_type_supported(unsigned long type)
+{
+	/* enable_tdx check is done by the caller. */
+	return type == KVM_X86_TDX_VM;
+}
+
 struct vmx_tdx_enabled {
 	cpumask_var_t vmx_enabled;
 	atomic_t err;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d9f2f00af427..0b8bf04e283d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7532,12 +7532,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-bool vmx_is_vm_type_supported(unsigned long type)
-{
-	/* TODO: Check if TDX is supported. */
-	return __kvm_is_vm_type_supported(type);
-}
-
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2c4fe3aff285..99fb6c9c0282 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -28,7 +28,6 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compat(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
@@ -137,8 +136,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+bool tdx_is_vm_type_supported(unsigned long type);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
+static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

