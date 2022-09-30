Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C965F0870
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiI3KUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiI3KS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDCF166F06;
        Fri, 30 Sep 2022 03:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533136; x=1696069136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=57DcaYgo0nhRwmLiLZXU5ejuBcBiTJGfkiv/7V5oP+8=;
  b=C/qeXD0SgyjAOjsP/6JgPmC6QHDAgUcNDiTd/tLFBJbHPr0jpaYOVfTj
   WrRsxNEeOJKRFPuG3YDC2txIO19G0PKhYqwBpcsVVAtCMmJvPoV2tIh1v
   GDoSCdVwI4ejQocd0x3fCjs0c43WqJd3Ndko1SNXXAD5Cza9RKYqq+s5D
   srJImCVXA6Od+0BUNFCDAj9Zj5Q/uBM6GLh+UWipRsMPYo4m+l08f3I6j
   n3jXS3FCT/cezGt6aW5W21hemiYaUB7bYZTqNp1Pav+LreJJD77VTkdCt
   rsogMlzIaHCmdqhKCyvTFZUOBukkrP6mSjPQyXtFc+qn/17f0c2S3Cawx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870068"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870068"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807562"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807562"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v9 018/105] KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
Date:   Fri, 30 Sep 2022 03:17:12 -0700
Message-Id: <0309a74cf9a6d00099e4d920ae9c56d1c0195e91.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index cc7df6fccbb2..78b6b2c4d596 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -118,6 +118,7 @@ KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
+KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd5e5917bab..aa43733746c6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1620,6 +1620,7 @@ struct kvm_x86_ops {
 	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
+	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 54b08789c402..2ad9666e02a5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -535,4 +535,52 @@ struct kvm_pmu_event_filter {
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
index 43cc3af7d0ec..071e7d148cb7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -203,6 +203,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6b07451d6661..60c5c08593c3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -429,6 +429,52 @@ int tdx_vm_init(struct kvm *kvm)
 	return ret;
 }
 
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
index 5ab78e044895..a831dd9ee1a3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -135,6 +135,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
 void tdx_hardware_unsetup(void);
 int tdx_offline_cpu(void);
+int tdx_dev_ioctl(void __user *argp);
 
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
@@ -144,6 +145,7 @@ static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_unsetup(void) {}
 static inline int tdx_offline_cpu(void) { return 0; }
+static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
 
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 351803fdc944..e2cbeeec9d6a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4660,6 +4660,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
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
index 54b08789c402..2ad9666e02a5 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -535,4 +535,52 @@ struct kvm_pmu_event_filter {
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

