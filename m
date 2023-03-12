Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666DA6B6925
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbjCLR7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjCLR6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:58:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BDE126DD;
        Sun, 12 Mar 2023 10:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643881; x=1710179881;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lIgPP52JRbG5GEd5CF1THBCS/yVJ9RlY48AZnl5iOzY=;
  b=j6/aXTmq8VU62xmL91TzwyysaOsgC7F5oi+AP6Kc3TZ7m0/S+UixrZDv
   8IHuZbKu4/t7S7PvW3K97GvZp+UJKtGLUdCyr43Ts8mL5nFmJYRFJKisu
   CdOKyuI1eqFnXglhUl8tfVK8I17KMlKcuMzT0Dyq7HA4jVfUZOmqowU6S
   87ZPhsl/FGTAS3Msy2piEFwM/BQtlT+qi2bohN0qSRCI4tIp6bH2aK7p4
   4WwL6ohQjCBP7ste7zbq0tgLOKqT4DUI4Cg3CRnzOjJssHXx/o4tPDaSt
   fNyYukETFWnbxxx3WC/Q1TdllKq/Uue8dDZ0r7vPX2Mfr0zyzH1p/1Xz9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863606"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863606"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396961"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396961"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 017/113] KVM: TDX: Add place holder for TDX VM specific mem_enc_op ioctl
Date:   Sun, 12 Mar 2023 10:55:41 -0700
Message-Id: <7cdfc307ea8717849e71063ceebf1e328448e773.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
TDX specific sub-commands will be added to retrieve/pass TDX specific
parameters.  Make mem_enc_ioctl non-optional as it's not optional now.

KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
guest state-protected VM.  It defined subcommands for technology-specific
operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
are not limited to memory encryption, but various technology-specific
operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
for TDX specific operations and define subcommands.

TDX requires VM-scoped TDX-specific operations for device model, for
example, qemu.  Getting system-wide parameters, TDX-specific VM
initialization.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/kvm/vmx/main.c            |  9 +++++++++
 arch/x86/kvm/vmx/tdx.c             | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  4 ++++
 arch/x86/kvm/x86.c                 |  4 ----
 5 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index b46dcac078b2..58fbaa05fc8c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -117,7 +117,7 @@ KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
-KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
+KVM_X86_OP(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6a5d0c7a2950..8ddd263eeabc 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -50,6 +50,14 @@ static int vt_vm_init(struct kvm *kvm)
 	return vmx_vm_init(kvm);
 }
 
+static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
+{
+	if (!is_td(kvm))
+		return -ENOTTY;
+
+	return tdx_vm_ioctl(kvm, argp);
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS		       \
 (						       \
        BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
@@ -203,6 +211,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
+	.mem_enc_ioctl = vt_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b59d3081d061..d759028a698e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -72,6 +72,32 @@ int tdx_dev_ioctl(void __user *argp)
 	return 0;
 }
 
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
+{
+	struct kvm_tdx_cmd tdx_cmd;
+	int r;
+
+	if (copy_from_user(&tdx_cmd, argp, sizeof(struct kvm_tdx_cmd)))
+		return -EFAULT;
+	if (tdx_cmd.error || tdx_cmd.unused)
+		return -EINVAL;
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
 static int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 78c5537e23a1..c70749114e9e 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -142,11 +142,15 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 int tdx_hardware_enable(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 int tdx_dev_ioctl(void __user *argp);
+
+int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
 static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
+
+static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a3dc32e33aca..8687623929c3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6978,10 +6978,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		goto out;
 	}
 	case KVM_MEMORY_ENCRYPT_OP: {
-		r = -ENOTTY;
-		if (!kvm_x86_ops.mem_enc_ioctl)
-			goto out;
-
 		r = static_call(kvm_x86_mem_enc_ioctl)(kvm, argp);
 		break;
 	}
-- 
2.25.1

