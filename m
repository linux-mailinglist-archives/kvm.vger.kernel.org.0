Return-Path: <kvm+bounces-921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E03B7E426E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:00:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FB0D1C208FF
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D66B37147;
	Tue,  7 Nov 2023 14:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TFXvnu3l"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC50358B0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 14:58:02 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8A8D7E;
	Tue,  7 Nov 2023 06:58:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369080; x=1730905080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q/cqGXUt9Zl95ffn9ru9tjlb7+fdPm7vOggIYHkjqwI=;
  b=TFXvnu3lQMFSmNG11Mz7taNIZEubFwfTHZQTC2yxcOkMZX6TarzQUEcs
   7D4liBLVHgOhvpjesklCn/bqJ2R7n/vLG4xC7Iw+/zx5J5rJtF7kJe3YP
   m1rlRx6vdVap7Xkrj0YneeakWM3bnWRxIMQhg5g7z5QZfIVY17eYj85L4
   KuKJuwaDwOICVQ35Zp2Xia08h4tM2xsheQGLqiFcvevoTzAjdV1fYLDaT
   nf3izpJ83o32HxsfaQFyu3Nt8sVu6kxisjNglHSC2zqPiDLhW2EkD4LWE
   pmVaH7dta3h2kp0ZvoHxcU+1h7K6qYPRLdkO6/Xt8YoTZjtnrQZ1hsBhI
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="374555865"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="374555865"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10444168"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:57:59 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v17 026/116] KVM: TDX: Do TDX specific vcpu initialization
Date: Tue,  7 Nov 2023 06:55:52 -0800
Message-Id: <e11b1d34ca819e133ae32b88f06762a602456c8c.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 0fbafb287839..cb8c1affce09 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -127,6 +127,7 @@ KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 56d0ba5793cf..78aa844f4dba 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1746,6 +1746,7 @@ struct kvm_x86_ops {
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
index f60de0232f7f..e5a918d81200 100644
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
@@ -299,6 +307,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b7f8ac4b9f95..c1a8560981a3 100644
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
@@ -88,6 +94,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
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
@@ -371,7 +382,32 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
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
@@ -380,8 +416,13 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -876,6 +917,136 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
@@ -894,6 +1065,11 @@ static int __init tdx_module_setup(void)
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
index 173ed19207fb..961a7da2452a 100644
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
index ebb963848316..4ac2adb59ebb 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -150,6 +150,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -169,6 +171,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0414822e7a03..cb695aa8fe20 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6206,6 +6206,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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


