Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4C358BD3E
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiHGWDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiHGWCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:35 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B87864C1;
        Sun,  7 Aug 2022 15:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909754; x=1691445754;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vGI4KWR8wP3tsBoNn3gjoKohW/+mJ+WoSSv9W7J2BoM=;
  b=LnUGf4hy0FRopLXRpPJebyb2TjwTutaxm977BtGV3pMWDokPez+FasXb
   I1kF1Ak7toqkOcaNJKeD5jLbUB8JMayf57EQ5Uqkdva4JjRVYGhIavcIZ
   qVThbiolgkZgYW4YhNWXq012ZrN3r2l7bHQabsdchdKWPjtqQYZAWscbB
   RSEqVKs8dFpuettsIzOLDnQd6cKwF81Gsco5hdAwT6HwYG5xZgLrFASsI
   i2wdqqwGVc0EoPIvGL9f+X8ppesZO+aOaopzsJ8XXbFk5hejFJrfJGbBJ
   TGHo/n5fRiJPxdRlC3p3/Y6TiPHFTAvHQGauSE/Cv423qNjtGLwXPqH3g
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224061"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224061"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682469"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:30 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 011/103] KVM: TDX: Make TDX VM type supported
Date:   Sun,  7 Aug 2022 15:00:56 -0700
Message-Id: <5f0170eea6ffe8665ceadc63b0946439fb92942c.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
KVM_CREATE_VM.

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
index e9a17f3666de..386bb2e86b77 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -70,6 +70,12 @@ int __init tdx_module_setup(void)
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
 	if (!enable_ept) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1ab94864eefd..466d9eab6d2e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7351,11 +7351,6 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
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
index 33a0afb56ccb..3f194ed53f07 100644
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

