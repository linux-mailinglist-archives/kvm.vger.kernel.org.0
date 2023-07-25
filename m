Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F857625F8
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbjGYWQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjGYWQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:09 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DD726B3;
        Tue, 25 Jul 2023 15:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323347; x=1721859347;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r109XFmiz2M3uwwwWEqxuGrtTBMgiFtxdMzYHmYMvu0=;
  b=j8qmrK6QcQaeD2XqPHozCIhx3Ver/+lG5CAa/25+O3zrOyfPnNPtHu0A
   ZUMcV+lY7FwK0bBEW5LSV2dFyzjUktWrxlg4fhbTbl1ogEfDWbVO1d0UT
   zeI40yNarS5uhL26koPmbeGQ2fmYLaHrQ2u5alHKv7F5YgUtBlAsoZ7y9
   fRSLc/vFACRTIyJP0rL4mWxz7BKIkVChfwiPU8EUPtQeA7b56i0A9HCtA
   J2g1q7qu/+E5OtQm8Ejd555q2UYVMvD7sPpQV/J4KMS0mnf/aNZJeWk1r
   t/NlUWFQw5GyJISmpR00DzdNv2WWp0EOj56OSF5Up6gXztCGNuoObuNaz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863168"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863168"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938851"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938851"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:25 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v15 026/115] KVM: TDX: Do TDX specific vcpu initialization
Date:   Tue, 25 Jul 2023 15:13:37 -0700
Message-Id: <32406a6ab6208eb33ed24f67696a71e1e80938ae.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TD guest vcpu needs TDX specific initialization before running.  Repurpose
KVM_MEMORY_ENCRYPT_OP to vcpu-scope, add a new sub-command
KVM_TDX_INIT_VCPU, and implement the callback for it.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h    |   1 +
 arch/x86/include/asm/kvm_host.h       |   1 +
 arch/x86/include/uapi/asm/kvm.h       |   1 +
 arch/x86/kvm/vmx/main.c               |   9 ++
 arch/x86/kvm/vmx/tdx.c                | 180 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                |   7 +
 arch/x86/kvm/vmx/x86_ops.h            |   4 +
 arch/x86/kvm/x86.c                    |   6 +
 tools/arch/x86/include/uapi/asm/kvm.h |   1 +
 9 files changed, 208 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index d711829fb26a..bcf04a75b506 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,6 +125,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5deb39828820..b265e4507a1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1716,6 +1716,7 @@ struct kvm_x86_ops {
 #endif
 
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7112546bd1d0..311a7894b712 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -571,6 +571,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 6ed9116f1b5c..8bb38db4323d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -142,6 +142,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -298,6 +306,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5f5e451b201a..488fefad1833 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -49,6 +49,7 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 
 struct tdx_info {
 	u8 nr_tdcs_pages;
+	u8 nr_tdvpx_pages;
 };
 
 /* Info about the TDX module. */
@@ -71,6 +72,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
+static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
+{
+	return tdx->tdvpr_pa;
+}
+
 static inline bool is_td_created(struct kvm_tdx *kvm_tdx)
 {
 	return kvm_tdx->tdr_pa;
@@ -87,6 +93,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->hkid > 0;
 }
 
+static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->finalized;
+}
+
 static void tdx_clear_page(unsigned long page_pa)
 {
 	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
@@ -347,7 +358,32 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	/* This is stub for now.  More logic will come. */
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/*
+	 * This methods can be called when vcpu allocation/initialization
+	 * failed. So it's possible that hkid, tdvpx and tdvpr are not assigned
+	 * yet.
+	 */
+	if (is_hkid_assigned(to_kvm_tdx(vcpu->kvm))) {
+		WARN_ON_ONCE(tdx->tdvpx_pa);
+		WARN_ON_ONCE(tdx->tdvpr_pa);
+		return;
+	}
+
+	if (tdx->tdvpx_pa) {
+		for (i = 0; i < tdx_info.nr_tdvpx_pages; i++) {
+			if (tdx->tdvpx_pa[i])
+				tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
+		}
+		kfree(tdx->tdvpx_pa);
+		tdx->tdvpx_pa = NULL;
+	}
+	if (tdx->tdvpr_pa) {
+		tdx_reclaim_td_page(tdx->tdvpr_pa);
+		tdx->tdvpr_pa = 0;
+	}
 }
 
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -356,8 +392,13 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/* Ignore INIT silently because TDX doesn't support INIT event. */
 	if (init_event)
 		return;
+	if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
+		return;
 
-	/* This is stub for now. More logic will come here. */
+	/*
+	 * Don't update mp_state to runnable because more initialization
+	 * is needed by TDX_VCPU_INIT.
+	 */
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -861,6 +902,136 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	unsigned long *tdvpx_pa = NULL;
+	unsigned long tdvpr_pa;
+	unsigned long va;
+	int ret, i;
+	u64 err;
+
+	if (is_td_vcpu_created(tdx))
+		return -EINVAL;
+
+	/*
+	 * vcpu_free method frees allocated pages.  Avoid partial setup so
+	 * that the method can't handle it.
+	 */
+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!va)
+		return -ENOMEM;
+	tdvpr_pa = __pa(va);
+
+	tdvpx_pa = kcalloc(tdx_info.nr_tdvpx_pages, sizeof(*tdx->tdvpx_pa),
+			   GFP_KERNEL_ACCOUNT);
+	if (!tdvpx_pa) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+	for (i = 0; i < tdx_info.nr_tdvpx_pages; i++) {
+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
+		if (!va) {
+			ret = -ENOMEM;
+			goto free_tdvpx;
+		}
+		tdvpx_pa[i] = __pa(va);
+	}
+
+	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
+	if (KVM_BUG_ON(err, vcpu->kvm)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
+		goto free_tdvpx;
+	}
+	tdx->tdvpr_pa = tdvpr_pa;
+
+	tdx->tdvpx_pa = tdvpx_pa;
+	for (i = 0; i < tdx_info.nr_tdvpx_pages; i++) {
+		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
+		if (KVM_BUG_ON(err, vcpu->kvm)) {
+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);
+			for (; i < tdx_info.nr_tdvpx_pages; i++) {
+				free_page((unsigned long)__va(tdvpx_pa[i]));
+				tdvpx_pa[i] = 0;
+			}
+			/* vcpu_free method frees TDVPX and TDR donated to TDX */
+			return -EIO;
+		}
+	}
+
+	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
+	if (KVM_BUG_ON(err, vcpu->kvm)) {
+		pr_tdx_error(TDH_VP_INIT, err, NULL);
+		return -EIO;
+	}
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	return 0;
+
+free_tdvpx:
+	for (i = 0; i < tdx_info.nr_tdvpx_pages; i++) {
+		if (tdvpx_pa[i])
+			free_page((unsigned long)__va(tdvpx_pa[i]));
+		tdvpx_pa[i] = 0;
+	}
+	kfree(tdvpx_pa);
+	tdx->tdvpx_pa = NULL;
+free_tdvpr:
+	if (tdvpr_pa)
+		free_page((unsigned long)__va(tdvpr_pa));
+	tdx->tdvpr_pa = 0;
+
+	return ret;
+}
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct msr_data apic_base_msr;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct kvm_tdx_cmd cmd;
+	int ret;
+
+	if (tdx->initialized)
+		return -EINVAL;
+
+	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.error)
+		return -EINVAL;
+
+	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
+		return -EINVAL;
+
+	/*
+	 * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
+	 * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
+	 * KVM_SET_CPUID2.  Otherwise kvm_set_apic_base() will fail.
+	 */
+	apic_base_msr = (struct msr_data) {
+		.host_initiated = true,
+		.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
+		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0),
+	};
+	if (kvm_set_apic_base(vcpu, &apic_base_msr))
+		return -EINVAL;
+
+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
+	if (ret)
+		return ret;
+
+	tdx->initialized = true;
+	return 0;
+}
+
 static int __init tdx_module_setup(void)
 {
 	const struct tdsysinfo_struct *tdsysinfo;
@@ -879,6 +1050,11 @@ static int __init tdx_module_setup(void)
 	WARN_ON(tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS);
 	tdx_info = (struct tdx_info) {
 		.nr_tdcs_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
+		/*
+		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
+		 * -1 for TDVPR.
+		 */
+		.nr_tdvpx_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
 	};
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index af7fdc1516d5..c39d866e0653 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,12 +17,19 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	bool finalized;
+
 	u64 tsc_offset;
 };
 
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
+	unsigned long tdvpr_pa;
+	unsigned long *tdvpx_pa;
+
+	bool initialized;
+
 	/*
 	 * Dummy to make pmu_intel not corrupt memory.
 	 * TODO: Support PMU for TDX.  Future work.
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index aaa419363276..8a7e256b44ac 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -151,6 +151,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -170,6 +172,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4afe24f50dcb..2922c4a69a6e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6073,6 +6073,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index 61ce7d174fcf..83bd9e3118d1 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -566,6 +566,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
-- 
2.25.1

