Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1434F51C6EA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383127AbiEESUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383106AbiEEST3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:29 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86C915837;
        Thu,  5 May 2022 11:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774545; x=1683310545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wc7k9mBOhm2yjTFK7ZxMkJGA1JBjjIRE6jOaW+UZtN4=;
  b=LVp5lEU8dxCQDmu73smJUEWuvFRNjL6hcyuQJJU5mUiEjbb7anyatK42
   7JWhlIxNXNGed1lb3YSFueWbxgFIJal6YCtPMIftbSV032Y6bsL6Xgn9D
   OoFkJ1QPFfHNV8RUgh4JXUYe3e4pDDxtSuZbDaTentQL+27etxK7QLceA
   rtVmiR+xrDcGxxxSuysrVdoplIpaHqqqUj5YLtY/CCHwX8B4ozg6j+Cyx
   /AdTW/Hiu4/Un5LRI98Ap3X6yIBB/eabbCH9rkM9oXzP68W3a/q2Xwf6Q
   uvKH8/Wbp79ABnI35xCPruRn9/Df3d6R/1Pxg0vywAMaTXW+UzCNWdL5Z
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746235"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746235"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083170"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:41 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 013/104] KVM: TDX: Make TDX VM type supported
Date:   Thu,  5 May 2022 11:14:07 -0700
Message-Id: <f371c6545dc9040ce1aa3b4fcd5f84a6ef47c4e7.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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
KVM_CREATE_VM.  Add a place holder function and call a function to
initialize TDX module on demand because in that callback VMX is enabled by
hardware_enable callback (vmx_hardware_enable).

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 18 ++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c     |  6 ++++++
 arch/x86/kvm/vmx/vmx.c     |  5 -----
 arch/x86/kvm/vmx/x86_ops.h |  3 ++-
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7be4941e4c4d..47bfa94e538e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,6 +10,12 @@
 static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
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
@@ -33,6 +39,14 @@ static int __init vt_post_hardware_enable_setup(void)
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
 	.name = "kvm_intel",
 
@@ -43,9 +57,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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
index 34aac9b5d43e..99bda653ef35 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -79,6 +79,12 @@ int __init tdx_module_setup(void)
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
 	u32 max_pa;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5312aa6339b3..b5846e0fc78f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7173,11 +7173,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
index 544ae23998f7..9d8e8abac6d7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -25,7 +25,6 @@ void vmx_hardware_unsetup(void);
 int vmx_check_processor_compatibility(void);
 int vmx_hardware_enable(void);
 void vmx_hardware_disable(void);
-bool vmx_is_vm_type_supported(unsigned long type);
 int vmx_vm_init(struct kvm *kvm);
 void vmx_vm_destroy(struct kvm *kvm);
 int vmx_vcpu_precreate(struct kvm *kvm);
@@ -131,8 +130,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
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

