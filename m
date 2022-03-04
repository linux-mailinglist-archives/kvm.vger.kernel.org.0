Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E3E4CDEA2
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiCDUJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiCDUHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8C92A2E29;
        Fri,  4 Mar 2022 12:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424102; x=1677960102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LWUmzn6AWC5WMpBWBQ3lJbhgFkdCMEMw7dpXlimA02I=;
  b=feB/TNBtT0+o39AsjsPxGbWDYFeGBBw+nMkCi5bAGf54D+/7VAPFqAgJ
   zo9xYZLz73aahf/JribaMuoNDeyiKzK5Ei2TgM38O63pT5CDiKQa1n2fX
   evT6GY91FshXtpZYtsFgkRjOeCucgkybDciXsRTnwWa9QuOrHtgdGghED
   /qwaJDM7Ap0GMPe81x9oMdaxRzU56cRTWZl5gSMD0qCz/Uj/uovA69hOE
   aUeAi6OpNN8Bs/U0RoIFEOD7LWTwYGJ4iS8k+f92Sl9OlDemkTN6RtSA9
   4S4IMY6a9ChZu6/aVEJkztP1crr1L2rNjUQSgVYPiKwGtQlDaJU43bhEU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983404"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983404"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:15 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344262"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:14 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 025/104] KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
Date:   Fri,  4 Mar 2022 11:48:41 -0800
Message-Id: <156ab9c6979c4b70e3d0d76e55e3aba370f58cea.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
TDX specific sub-commands will be added to retrieve/pass TDX specific
parameters.

KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
guest state-protected VM.  It defined subcommands for technology-specific
operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
are not limited to memory encryption, but various technology-specific
operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
for TDX specific operations and define subcommands.

TDX requires VM-scoped, and VCPU-scoped TDX-specific operations for device
model, for example, qemu.  Getting system-wide parameters, TDX-specific VM
initialization, and TDX-specific vCPU initialization.  Which requires KVM
vCPU-scoped operations in addition to the existing VM-scoped operations.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h       | 11 +++++++++++
 arch/x86/kvm/vmx/main.c               | 10 ++++++++++
 arch/x86/kvm/vmx/tdx.c                | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h            |  4 ++++
 tools/arch/x86/include/uapi/asm/kvm.h | 11 +++++++++++
 5 files changed, 60 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 71a5851475e7..2ad61caf4e0b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -528,4 +528,15 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_TDX_VM		1
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	__u32 id;
+	__u32 metadata;
+	__u64 data;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5c3a904a30e8..fc497f50e0e1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -57,6 +57,14 @@ static void vt_vm_free(struct kvm *kvm)
 		return tdx_vm_free(kvm);
 }
 
+static int vt_mem_enc_op(struct kvm *kvm, void __user *argp)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_ioctl(kvm, argp);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -195,6 +203,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.mem_enc_op = vt_mem_enc_op,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 702953fd365f..8c67444d052a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -349,6 +349,30 @@ int tdx_vm_init(struct kvm *kvm)
 	return ret;
 }
 
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_tdx_cmd tdx_cmd;
+	int r;
+
+	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
+		return -EFAULT;
+
+	mutex_lock(&kvm->lock);
+
+	switch (tdx_cmd.id) {
+	default:
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
+		r = -EFAULT;
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 static int __tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 2b2738c768d6..9d88ba9b093b 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -136,6 +136,8 @@ void tdx_hardware_unsetup(void);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_prezap(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
+
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline void tdx_pre_kvm_init(
 	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
@@ -146,6 +148,8 @@ static inline void tdx_hardware_unsetup(void) {}
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_prezap(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
+
+static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 71a5851475e7..2ad61caf4e0b 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -528,4 +528,15 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_TDX_VM		1
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	__u32 id;
+	__u32 metadata;
+	__u64 data;
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

