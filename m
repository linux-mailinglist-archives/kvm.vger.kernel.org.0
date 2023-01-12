Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBFC667B60
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbjALQmE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbjALQhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:41 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CE915FFC;
        Thu, 12 Jan 2023 08:33:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541235; x=1705077235;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7N+UH368EIH24LGZISjBiZWkdSYztmMZM0oWzKNqzg8=;
  b=eo8GmiaeXuldW6Hk5WkRmwuIzgJyRfnK/zgiYTn7PsaUGtsgv6CPqVEn
   bICEv9ZPZQnrcetjF5lUC4I4QM9mrtifdNo55+8SjJQlt8T5a3016q4HN
   MImPCMdRnFIDBbvZNICJr0O+8TAp9+Jx9e17tDSsv1OsFEYXMXTDu63NO
   Icxt02W6tzLxbFRt1IIi9T0Qy6nb1bHODRcboNQnMkaoCEjfGAEW+1l2c
   GEGxnr8RdHJ3u4DwQUNL1ZGsJ5YQIdeA12gcKkD+oNIjrUyQ84O8nLz6t
   vAusjY8O2PzksqXKfyqul2/kAASoRJOWe2xmIkgEspkO1iD3wyfUscgJ+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811712"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811712"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151674"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151674"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 015/113] KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
Date:   Thu, 12 Jan 2023 08:31:23 -0800
Message-Id: <688bbccbfbd37657f8e19d71dde9bf3d49c59c3b.1673539699.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Implement a system-scoped ioctl to get system-wide parameters for TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  1 +
 arch/x86/include/uapi/asm/kvm.h       | 48 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/main.c               |  2 ++
 arch/x86/kvm/vmx/tdx.c                | 46 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h            |  2 ++
 arch/x86/kvm/x86.c                    |  6 ++++
 tools/arch/x86/include/uapi/asm/kvm.h | 48 +++++++++++++++++++++++++++
 8 files changed, 154 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 59181b12ad70..e6708bb3f4f6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -118,6 +118,7 @@ KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
+KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c6ccfce7dc9e..234c28c8e6ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1693,6 +1693,7 @@ struct kvm_x86_ops {
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 #endif
 
+	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index a4cca6bc6b06..610b1de9eb2b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -532,4 +532,52 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_TDX_VM		1
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 * Defined for consistency with struct kvm_sev_cmd.
+	 */
+	__u64 error;
+	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
+	__u64 unused;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+
+	__u32 nr_cpuid_configs;
+	__u32 padding;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index e3c5e9250990..16053ec3e0ae 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -177,6 +177,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2adf5551ab26..f46579102a44 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -32,6 +32,52 @@ struct tdx_capabilities {
 /* Capabilities of KVM + the TDX module. */
 static struct tdx_capabilities tdx_caps;
 
+int tdx_dev_ioctl(void __user *argp)
+{
+	struct kvm_tdx_capabilities __user *user_caps;
+	struct kvm_tdx_capabilities caps;
+	struct kvm_tdx_cmd cmd;
+
+	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
+		     sizeof(struct tdx_cpuid_config));
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+	if (cmd.flags || cmd.error || cmd.unused)
+		return -EINVAL;
+	/*
+	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
+	 * mem_enc_ioctl().
+	 */
+	if (cmd.id != KVM_TDX_CAPABILITIES)
+		return -EINVAL;
+
+	user_caps = (void __user *)cmd.data;
+	if (copy_from_user(&caps, user_caps, sizeof(caps)))
+		return -EFAULT;
+
+	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
+		return -E2BIG;
+
+	caps = (struct kvm_tdx_capabilities) {
+		.attrs_fixed0 = tdx_caps.attrs_fixed0,
+		.attrs_fixed1 = tdx_caps.attrs_fixed1,
+		.xfam_fixed0 = tdx_caps.xfam_fixed0,
+		.xfam_fixed1 = tdx_caps.xfam_fixed1,
+		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
+		.padding = 0,
+	};
+
+	if (copy_to_user(user_caps, &caps, sizeof(caps)))
+		return -EFAULT;
+	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
+			 tdx_caps.nr_cpuid_configs *
+			 sizeof(struct tdx_cpuid_config)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 8fd34842a06b..f0803cc15151 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -140,9 +140,11 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
+int tdx_dev_ioctl(void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
+static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 68bff699096a..1152a9dc6d84 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4693,6 +4693,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
 		r = kvm_x86_dev_has_attr(&attr);
 		break;
 	}
+	case KVM_MEMORY_ENCRYPT_OP:
+		r = -EINVAL;
+		if (!kvm_x86_ops.dev_mem_enc_ioctl)
+			goto out;
+		r = static_call(kvm_x86_dev_mem_enc_ioctl)(argp);
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index b67d2d59eb6c..04562740691b 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -527,4 +527,52 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_TDX_VM		1
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 * Defined for consistency with struct kvm_sev_cmd.
+	 */
+	__u64 error;
+	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
+	__u64 unused;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+
+	__u32 nr_cpuid_configs;
+	__u32 padding;
+	struct kvm_tdx_cpuid_config cpuid_configs[0];
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

