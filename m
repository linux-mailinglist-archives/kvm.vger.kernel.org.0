Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7361E6127D7
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiJ3GZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiJ3GYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76E7F5;
        Sat, 29 Oct 2022 23:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111045; x=1698647045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5N14W9d4UZ3Tne7waI4pJoVpGQT1k/qC2lTFBmHV9zg=;
  b=PKjyhL/uR/KYxQDKSyVAZz/NETn+xR5Yw2RbkaJnAOQZdYPQfteNXao8
   LrR1b4FWTDPk0Wt0FZRg6Ulyn9S+nXtQ/UrUlu1Vskvg1e1C+5NPndJb5
   lf/xieHIB7NeEhReduqudLyfFSF3eqHwAX/ev2rBoFB2ZlqVOfVDAyokP
   HJ2zDFhDVLZcsLwUS9j/utWpylQzgI38gBJ1y5z05yp0v+GGjdeYuF9np
   G+F7VALdAjraaUBUiFAITBZzW+o27nMOc4PtB1QY50cVSIisD9V/Adpgx
   Bh9+DNDOFTgC7sMkGwSKDiCcJY/QwIyxvt3ytI9JmzOUgOHtMV7WJB88N
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037137"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037137"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392914"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392914"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v10 025/108] KVM: TDX: Do TDX specific vcpu initialization
Date:   Sat, 29 Oct 2022 23:22:26 -0700
Message-Id: <d4f583adecb42914b4ec68cdc851955c1af23b53.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/kvm-x86-ops.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |   1 +
 arch/x86/include/uapi/asm/kvm.h       |   1 +
 arch/x86/kvm/vmx/main.c               |   9 ++
 arch/x86/kvm/vmx/tdx.c                | 166 ++++++++++++++++++--------
 arch/x86/kvm/vmx/tdx.h                |   4 +
 arch/x86/kvm/vmx/x86_ops.h            |   2 +
 arch/x86/kvm/x86.c                    |   6 +
 tools/arch/x86/include/uapi/asm/kvm.h |   1 +
 9 files changed, 139 insertions(+), 52 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 4425564647cb..f28c9fd72ac4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -120,6 +120,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_OPTIONAL(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fced310ec63..829a07d23909 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1628,6 +1628,7 @@ struct kvm_x86_ops {
 
 	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 26661879c031..80db152430e4 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -539,6 +539,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c125b2e3e8b4..0d5ca65e9997 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -103,6 +103,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
 
@@ -246,6 +254,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0625c354b341..fd9210cb4f36 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -70,6 +70,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
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
@@ -303,31 +308,12 @@ int tdx_vm_init(struct kvm *kvm)
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	int ret, i;
-
 	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
 	if (!vcpu->arch.apic)
 		return -EINVAL;
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 
-	ret = tdx_alloc_td_page(&tdx->tdvpr);
-	if (ret)
-		return ret;
-
-	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
-			GFP_KERNEL_ACCOUNT);
-	if (!tdx->tdvpx) {
-		ret = -ENOMEM;
-		goto free_tdvpr;
-	}
-	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
-		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
-		if (ret)
-			goto free_tdvpx;
-	}
-
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
 	vcpu->arch.cr0_guest_owned_bits = -1ul;
@@ -339,17 +325,6 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);
 
 	return 0;
-
-free_tdvpx:
-	/* @i points at the TDVPX page that failed allocation. */
-	for (--i; i >= 0; i--)
-		free_page(tdx->tdvpx[i].va);
-	kfree(tdx->tdvpx);
-	tdx->tdvpx = NULL;
-free_tdvpr:
-	free_page(tdx->tdvpr.va);
-
-	return ret;
 }
 
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
@@ -372,34 +347,14 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	struct msr_data apic_base_msr;
-	u64 err;
-	int i;
 
 	/* TDX doesn't support INIT event. */
 	if (WARN_ON_ONCE(init_event))
 		goto td_bugged;
-	if (WARN_ON_ONCE(is_td_vcpu_created(tdx)))
+	if (WARN_ON_ONCE(is_td_vcpu_created(to_tdx(vcpu))))
 		goto td_bugged;
 
-	err = tdh_vp_create(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
-	if (WARN_ON_ONCE(err)) {
-		pr_tdx_error(TDH_VP_CREATE, err, NULL);
-		goto td_bugged;
-	}
-	tdx_mark_td_page_added(&tdx->tdvpr);
-
-	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
-		err = tdh_vp_addcx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
-		if (WARN_ON_ONCE(err)) {
-			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
-			goto td_bugged;
-		}
-		tdx_mark_td_page_added(&tdx->tdvpx[i]);
-	}
-
 	if (!vcpu->arch.cpuid_entries) {
 		/*
 		 * On cpu creation, cpuid entry is blank.  Forcibly enable
@@ -419,6 +374,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		vcpu->arch.cpuid_entries = e;
 		vcpu->arch.cpuid_nent = 1;
 	}
+
+	/* TDX rquires X2APIC. */
 	apic_base_msr.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC;
 	if (kvm_vcpu_is_reset_bsp(vcpu))
 		apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
@@ -426,7 +383,10 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (WARN_ON_ONCE(kvm_set_apic_base(vcpu, &apic_base_msr)))
 		goto td_bugged;
 
-	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	/*
+	 * Don't update mp_state to runnable because more initialization
+	 * is needed by TDX_VCPU_INIT.
+	 */
 
 	return;
 
@@ -861,6 +821,108 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int ret, i;
+	u64 err;
+
+	if (is_td_vcpu_created(tdx))
+		return -EINVAL;
+
+	ret = tdx_alloc_td_page(&tdx->tdvpr);
+	if (ret)
+		return ret;
+
+	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
+			     GFP_KERNEL_ACCOUNT);
+	if (!tdx->tdvpx) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
+		if (ret)
+			goto free_tdvpx;
+	}
+
+	err = tdh_vp_create(kvm_tdx->tdr.pa, tdx->tdvpr.pa);
+	if (WARN_ON_ONCE(err)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
+		goto td_bugged;
+	}
+	tdx_mark_td_page_added(&tdx->tdvpr);
+
+	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
+		err = tdh_vp_addcx(tdx->tdvpr.pa, tdx->tdvpx[i].pa);
+		if (WARN_ON_ONCE(err)) {
+			ret = -EIO;
+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
+			goto td_bugged;
+		}
+		tdx_mark_td_page_added(&tdx->tdvpx[i]);
+	}
+
+	err = tdh_vp_init(tdx->tdvpr.pa, vcpu_rcx);
+	if (WARN_ON_ONCE(err)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_INIT, err, NULL);
+		goto td_bugged;
+	}
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return 0;
+
+td_bugged:
+	vcpu->kvm->vm_bugged = true;
+	return ret;
+
+free_tdvpx:
+	/* @i points at the TDVPX page that failed allocation. */
+	for (--i; i >= 0; i--)
+		free_page(tdx->tdvpx[i].va);
+	kfree(tdx->tdvpx);
+	tdx->tdvpx = NULL;
+free_tdvpr:
+	free_page(tdx->tdvpr.va);
+
+	return ret;
+}
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	int ret;
+
+	if (tdx->vcpu_initialized)
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
+
+	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
+	if (ret)
+		return ret;
+
+	tdx->vcpu_initialized = true;
+	return 0;
+}
+
 static int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 5aea69716278..a95f25845f24 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -23,6 +23,8 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	bool finalized;
+
 	u64 tsc_offset;
 };
 
@@ -32,6 +34,8 @@ struct vcpu_tdx {
 	struct tdx_td_page tdvpr;
 	struct tdx_td_page *tdvpx;
 
+	bool vcpu_initialized;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f6841c3dd12d..fda1b2eaebc6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -146,6 +146,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
@@ -163,6 +164,7 @@ static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddcbbcf13a55..a811d643f71c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5963,6 +5963,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index 531a0033e530..35e3b4aa2e96 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -539,6 +539,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

