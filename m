Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7C455D9C3
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbiF0V4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241372AbiF0Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9C15F7F;
        Mon, 27 Jun 2022 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366896; x=1687902896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rRViGQgs7D1QPzQCIJ4ILBjw0Q8JYRXQZv7P/fuSvnE=;
  b=LunUR/1TG76Yoq6oq1/+DtWNoaYebo3vutq7g/tBHohTlmCFIm0OadYi
   WAOx76rhBDpnsnSWJvKxsaPfRBKIqF5k8aFBCIS8OoxcnfZr5RvRhdfGG
   ogEEes4aUwOXEA8xNfPvx+bi+gkl2PFRUc2VJcSPMLG8siUuiA5n/GwcZ
   khS/NNHEtMW5rabEYLcXrQrpkKe4oic92WpzadaP2SJ/IrsqlaoyKNWy8
   7LPMaL/Qu/xNk5NV8V3qnUoOqhdU4sYBrA3MyYEDoQqjwIAsJWPj23KTQ
   yeyb4kpejCRaaK6kkQI/+gRifHSUC+srjWVgTdxMAuc1P6rsi/QXOUaeJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609530"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609530"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863531"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 030/102] KVM: TDX: Do TDX specific vcpu initialization
Date:   Mon, 27 Jun 2022 14:53:22 -0700
Message-Id: <e05ce01e400f80437803146564d4c351bf1df047.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TD guest vcpu need to be configured before ready to run which requests
addtional information from Device model (e.g. qemu), one 64bit value is
passed to vcpu's RCX as an initial value.  Repurpose KVM_MEMORY_ENCRYPT_OP
to vcpu-scope and add new sub-commands KVM_TDX_INIT_VCPU under it for such
additional vcpu configuration.

Add callback for kvm vCPU-scoped operations of KVM_MEMORY_ENCRYPT_OP and
add a new subcommand, KVM_TDX_INIT_VCPU, for further vcpu initialization.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h    |  1 +
 arch/x86/include/asm/kvm_host.h       |  1 +
 arch/x86/include/uapi/asm/kvm.h       |  1 +
 arch/x86/kvm/vmx/main.c               |  9 +++++++
 arch/x86/kvm/vmx/tdx.c                | 36 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  4 +++
 arch/x86/kvm/vmx/x86_ops.h            |  2 ++
 arch/x86/kvm/x86.c                    |  6 +++++
 tools/arch/x86/include/uapi/asm/kvm.h |  1 +
 9 files changed, 61 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3677a5015a4f..32a6df784ea6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -119,6 +119,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81638987cdb9..e5d4e5b60fdc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1595,6 +1595,7 @@ struct kvm_x86_ops {
 
 	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index f89774ccd4ae..399c28b2f4f5 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 4f4ed4ad65a7..ce12cc8276ef 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -113,6 +113,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 	return tdx_vm_ioctl(kvm, argp);
 }
 
+static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	if (!is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return tdx_vcpu_ioctl(vcpu, argp);
+}
+
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -255,6 +263,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d9fe3f6463c3..2772775457b0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -83,6 +83,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->hkid > 0;
 }
 
+static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->finalized;
+}
+
 static void tdx_clear_page(unsigned long page)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -805,6 +810,37 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	u64 err;
+
+	if (tdx->initialized)
+		return -EINVAL;
+
+	if (!is_td_initialized(vcpu->kvm) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.error || cmd.unused)
+		return -EINVAL;
+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	err = tdh_vp_init(tdx->tdvpr.pa, cmd.data);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_VP_INIT, err, NULL);
+		return -EIO;
+	}
+
+	tdx->initialized = true;
+	return 0;
+}
+
 int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 892e7dc96e99..337c3adb4fcf 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -25,6 +25,8 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	bool finalized;
+
 	u64 tsc_offset;
 	unsigned long tsc_khz;
 };
@@ -35,6 +37,8 @@ struct vcpu_tdx {
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
 
+	bool initialized;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 42b634971544..7e38c7b756d4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -143,6 +143,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
@@ -159,6 +160,7 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6037ce93bcb7..4309ef0ade21 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5778,6 +5778,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_SET_DEVICE_ATTR:
 		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
 		break;
+	case KVM_MEMORY_ENCRYPT_OP:
+		r = -ENOTTY;
+		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
+			goto out;
+		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);
+		break;
 	default:
 		r = -EINVAL;
 	}
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 779dfd683d66..60a79f9ef174 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -532,6 +532,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

