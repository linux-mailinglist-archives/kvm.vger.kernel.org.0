Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF9C51C706
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346990AbiEESUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383180AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA3714081;
        Thu,  5 May 2022 11:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774550; x=1683310550;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AEtYNjpEBkvZ7J/qWgVfVOw8rhuGAkNWQTcLQNB3yK8=;
  b=E1InvdU2B3oF8H8D1BdYV9RdTl0cMIn29FQnO7RtKWwUGmuvutwEiLPl
   SomfntS/vOVEYRPfJDy7itbN4POoD+SHiQ8i4xhGnkrCXL0XFMF2Zk3ez
   SxxLYfxo2UIgqlebFaZpLbOXJr98hT/EXtp0od9nKI034UbVuRO6guZ5z
   1pEDJsLgMCCu5X9YpXBB7JqczjAFgZ4s6dKTkDTZ1cykAq9/YSrDZTrVR
   tiSb3Vv5wXKhl9ahSlis0bC8th84nS21N4/j6kvJf3I7RkkJZHqCy0Nk1
   DTQpow4o27rd4ntww+FsSLTS9+Yf/AXVCfiaO+DRPz87Riu78qtfoBy17
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746255"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746255"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083204"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 023/104] KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
Date:   Thu,  5 May 2022 11:14:17 -0700
Message-Id: <f23861c45001c1b746a0195dcc4706c7d11a1fc2.1651774250.git.isaku.yamahata@intel.com>
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
index fbb2c6746066..3677a5015a4f 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -117,6 +117,7 @@ KVM_X86_OP(smi_allowed)
 KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
+KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6a5518ce0ca..e6f6f8c8619f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1495,6 +1495,7 @@ struct kvm_x86_ops {
 	int (*leave_smm)(struct kvm_vcpu *vcpu, const char *smstate);
 	void (*enable_smi_window)(struct kvm_vcpu *vcpu);
 
+	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 1c3b97f403f4..ca85a070ac19 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -529,4 +529,52 @@ struct kvm_pmu_event_filter {
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
index 6a93b19a8b06..7b497ed1f21c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -212,6 +212,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ba0671cbf0a7..07b69ffbe55b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -392,6 +392,52 @@ int tdx_vm_init(struct kvm *kvm)
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
 int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 468f00d0633e..75e6cdcb06f5 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -132,6 +132,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
 void tdx_hardware_unsetup(void);
+int tdx_dev_ioctl(void __user *argp);
 
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
@@ -140,6 +141,7 @@ void tdx_vm_free(struct kvm *kvm);
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_unsetup(void) {}
+static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
 
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index af280db31777..77e83e20180a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4546,6 +4546,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			break;
 		r = kvm_x86_dev_has_attr(&attr);
 		break;
+		case KVM_MEMORY_ENCRYPT_OP:
+			r = -EINVAL;
+			if (!kvm_x86_ops.dev_mem_enc_ioctl)
+				goto out;
+			r = static_call(kvm_x86_dev_mem_enc_ioctl)(argp);
+			break;
 	}
 	default:
 		r = -EINVAL;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 71a5851475e7..a9ea3573be1b 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -528,4 +528,52 @@ struct kvm_pmu_event_filter {
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

