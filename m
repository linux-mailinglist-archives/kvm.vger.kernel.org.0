Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCB56B6942
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjCLSAq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjCLR7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:59:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF7D279BF;
        Sun, 12 Mar 2023 10:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643904; x=1710179904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pnaHCPSPHB27kSHLuWHfsxJZ6AaSeEjpOSQFqKGjZpQ=;
  b=EyCUndwZwiTpa7PIjUYxNx34KX1Md4C91ckhomrx0OYfUcFwf6CRX9VT
   9vX8AilTPvs15eDCOnC1zE/mbjos7z1hkC2df6QnFPKb4nukRPbNqyZN1
   ou+rFRTF1Su5G2CMY19mXCmkZ7NXLdtXW0mdHE3qFGvLwIeKtUd1/Zola
   FlLTzVhZt5Ju47r1EJzM3Hgqp6f8W7f4RUk9/MfbdDFMJVXnDmnFsa32f
   2uo95s1iLCypOg/6BFBF1BUoZRa2VEtUHuxzrYJ6YCx57nGGyEjtm4udj
   ulyobZKRiPEg13JSrGFGfIXtJAz8Jj9hgWbD0H5nQ2olM4hk7//6kAuXq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863641"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863641"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396998"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396998"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v13 025/113] KVM: TDX: Do TDX specific vcpu initialization
Date:   Sun, 12 Mar 2023 10:55:49 -0700
Message-Id: <b04768479ebbfa7ed4773403212c89c6f04c7ae5.1678643052.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/tdx.c                | 171 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                |   7 ++
 arch/x86/kvm/vmx/x86_ops.h            |   4 +
 arch/x86/kvm/x86.c                    |   6 +
 tools/arch/x86/include/uapi/asm/kvm.h |   1 +
 9 files changed, 200 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f763981b7dbc..d29e16098c30 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -124,6 +124,7 @@ KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP(dev_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f30543caddbf..42fa696a04ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1726,6 +1726,7 @@ struct kvm_x86_ops {
 
 	int (*dev_mem_enc_ioctl)(void __user *argp);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 68e8d544afe5..da7078cd7d7d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -566,6 +566,7 @@ struct kvm_pmu_event_filter {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index e9fd4e80b67d..57240d6ab97a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -141,6 +141,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
 #define VMX_REQUIRED_APICV_INHIBITS		       \
 (						       \
        BIT(APICV_INHIBIT_REASON_DISABLE)|	       \
@@ -300,6 +308,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.dev_mem_enc_ioctl = tdx_dev_ioctl,
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4fec35f4f5b2..1415ab60ce2c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -48,6 +48,7 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 
 struct tdx_info {
 	u8 nr_tdcs_pages;
+	u8 nr_tdvpx_pages;
 };
 
 /* Info about the TDX module. */
@@ -70,6 +71,11 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
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
@@ -86,6 +92,11 @@ static inline bool is_hkid_assigned(struct kvm_tdx *kvm_tdx)
 	return kvm_tdx->hkid > 0;
 }
 
+static inline bool is_td_finalized(struct kvm_tdx *kvm_tdx)
+{
+	return kvm_tdx->finalized;
+}
+
 int tdx_hardware_enable(void)
 {
 	return tdx_cpu_enable();
@@ -352,7 +363,28 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
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
+		for (i = 0; i < tdx_info.nr_tdvpx_pages; i++)
+			tdx_reclaim_td_page(tdx->tdvpx_pa[i]);
+		kfree(tdx->tdvpx_pa);
+		tdx->tdvpx_pa = NULL;
+	}
+	tdx_reclaim_td_page(tdx->tdvpr_pa);
+	tdx->tdvpr_pa = 0;
 }
 
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -361,6 +393,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/* Ignore INIT silently because TDX doesn't support INIT event. */
 	if (init_event)
 		return;
+	if (KVM_BUG_ON(is_td_vcpu_created(to_tdx(vcpu)), vcpu->kvm))
+		return;
 
 	/* This is stub for now. More logic will come here. */
 
@@ -828,6 +862,136 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
+	if (cmd.error || cmd.unused)
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
@@ -846,6 +1010,11 @@ static int __init tdx_module_setup(void)
 	WARN_ON(tdsysinfo->num_cpuid_config > TDX_MAX_NR_CPUID_CONFIGS);
 	tdx_info = (struct tdx_info) {
 		.nr_tdcs_pages = tdsysinfo->tdcs_base_size / PAGE_SIZE,
+		/*
+		 * TDVPS = TDVPR(4K page) + TDVPX(multiple 4K pages).
+		 * -1 for TDVPR.
+		 */
+		.nr_tdvpx_pages = tdsysinfo->tdvps_base_size / PAGE_SIZE - 1,
 	};
 
 	pr_info("TDX is supported.\n");
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 5728820fed5e..5fa4d3198873 100644
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
index 1669c95d8249..92af5d2d5db7 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -155,6 +155,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
 static inline void tdx_hardware_unsetup(void) {}
@@ -174,6 +176,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ba15a9e126f..a0960b468c74 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6002,6 +6002,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
index c0f011384934..0f88e32d02a8 100644
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

