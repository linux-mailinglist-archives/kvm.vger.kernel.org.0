Return-Path: <kvm+bounces-30102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4E39B6CBA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D467282237
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5022296CC;
	Wed, 30 Oct 2024 19:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SIu7pD0r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE0B2281CE;
	Wed, 30 Oct 2024 19:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314882; cv=none; b=VtX9OrgGP0Q2EF474q5BHz2x078uaoFiwDHCUwJCSSifgWU4bLor59C+LFKWCCU22VVd4d6rqqQNxREROsl8m4ClW3er1m0agCesF0E7KXykVqIl1SuiY1GXEP/xBmuFx/uVpgvxsgVluAqRjbTDD1j3LXCUMr7IdDbwk+tmhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314882; c=relaxed/simple;
	bh=F2bJ2/m6qJuvCutjYJe3t4NmQ/BD46xmLmcXSFwO62o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UH1gp7oLJSi/lB6YtT3jmx7ggh0NBBjekJ2QYikv3AeVQ5kLsv5BhiKQdCus4C37Lg+smvCqZJ2C2BKkZxOobqGGpLsCrVzbIIz8DdR6Xo4b3WK6b1IFq7QlweZPYuWz6Wk8MEhHhgsowAOqjJyPaRojlG0rqJzs/RefNRK1eNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SIu7pD0r; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314879; x=1761850879;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2bJ2/m6qJuvCutjYJe3t4NmQ/BD46xmLmcXSFwO62o=;
  b=SIu7pD0rabIPTEZztFufirDAnnzCfvw3lfkfooEHKlqkQetlrueByYlm
   ffzQlEWg42KfUb4jKlo5OyHrG/ZJY526BeCL7/ZkhdhUmCvQNtE1bD3XI
   lFsPISd1rM4EQU949SbMemz1Nay/+lXBBMNOb7eVnGq8+yZ+wZ5+b5OIB
   7WCMjByGqqbLU5bwF4uqWzvZ6pA+y7XMkR+E7HOBwYAYHoKnQyY9kP0v5
   NtwVQ4KARIHRpQPhYhGk+2qj3JgLTqgoOxtcJd4F2NdeD3yaqKFJENi77
   b3UHh9rEP+2Cpfhwdd6wIk6iSviEmYmybwGwMjyaNL9uI+sQVLvR4TVvO
   w==;
X-CSE-ConnectionGUID: wp+vvAnnSaaFyBMyneXXXg==
X-CSE-MsgGUID: r9qv2iAETeef0sL+nxzVAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678849"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678849"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:08 -0700
X-CSE-ConnectionGUID: QXu4dlQeSoSWBS27JUAWMQ==
X-CSE-MsgGUID: CeygPoN7TEiW6Oo9fbL0AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499460"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:07 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 23/25] KVM: TDX: Do TDX specific vcpu initialization
Date: Wed, 30 Oct 2024 12:00:36 -0700
Message-ID: <20241030190039.77971-24-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
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
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Drop dummy tdx_vcpu_reset() (Binbin)
 - Calculate nr_vcpu_tcds_pages on init (Nikolay)
 - Use vcpu_tdcx naming instead of just tdcx (Yuan)
 - No need for is_td_vcpu_created() (Rick)
 - No need for is_td_finalized() (Rick)
 - Export functions used (Binbin)
 - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
   wrappers (Kai)
 - Add TD state handling (Tony)
 - Clarify comment wrt is_hkid_assigned() in tdx_vcpu_free() (Yuan)
 - Fix error paths in tdx_td_vcpu_init() (Yuan)
 - Do not unnecessarily leak tdx->tdvpr_pa in tdx_vcpu_free() (Yuan)

uAPI breakout v1:
 - Support FEATURES0_TOPOLOGY_ENUM
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Remove WARN_ON_ONCE() in tdx_vcpu_free().
   WARN_ON_ONCE(vcpu->cpu != -1), WARN_ON_ONCE(tdx->tdvpx_pa),
   WARN_ON_ONCE(tdx->tdvpr_pa)
 - Remove KVM_BUG_ON() in tdx_vcpu_reset().
 - Remove duplicate "tdx->tdvpr_pa=" lines
 - Rename tdvpx to tdcx as it is confusing, follow spec change for same
   reason (Isaku)
 - Updates from seamcall overhaul (Kai)
 - Rename error->hw_error
 - Change using tdx_info to using exported 'tdx_sysinfo' pointer in
   tdx_td_vcpu_init().
 - Remove code to the old (non-existing) tdx_module_setup().
 - Use a new wrapper tdx_sysinfo_nr_tdcx_pages() to replace
   tdx_info->nr_tdcx_pages.
 - Combine the two for loops in tdx_td_vcpu_init() (Chao)
 - Add more line breaks into tdx_td_vcpu_init() for readability (Tony)
 - Drop Drop local tdcx_pa in tdx_td_vcpu_init() (Rick)
 - Drop Drop local tdvpr_pa in tdx_td_vcpu_init() (Rick)

v18:
 - Use tdh_sys_rd() instead of struct tdsysinfo_struct.
 - Rename tdx_reclaim_td_page() => tdx_reclaim_control_page()
 - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
---
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   1 +
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/vmx/main.c            |   9 ++
 arch/x86/kvm/vmx/tdx.c             | 182 ++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h             |  13 ++-
 arch/x86/kvm/vmx/tdx_arch.h        |   2 +
 arch/x86/kvm/vmx/x86_ops.h         |   4 +
 arch/x86/kvm/x86.c                 |   8 ++
 9 files changed, 219 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e7bd7867cb94..ec1b1b39c6b3 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,6 +125,7 @@ KVM_X86_OP(enable_smi_window)
 #endif
 KVM_X86_OP_OPTIONAL(dev_get_attr)
 KVM_X86_OP(mem_enc_ioctl)
+KVM_X86_OP_OPTIONAL(vcpu_mem_enc_ioctl)
 KVM_X86_OP_OPTIONAL(mem_enc_register_region)
 KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d8478e103f07..dfa89a5d15ef 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1827,6 +1827,7 @@ struct kvm_x86_ops {
 
 	int (*dev_get_attr)(u32 group, u64 attr, u64 *val);
 	int (*mem_enc_ioctl)(struct kvm *kvm, void __user *argp);
+	int (*vcpu_mem_enc_ioctl)(struct kvm_vcpu *vcpu, void __user *argp);
 	int (*mem_enc_register_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unregister_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 892e16bd7430..2cfec4b42b9d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -930,6 +930,7 @@ struct kvm_hyperv_eventfd {
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
 	KVM_TDX_INIT_VM,
+	KVM_TDX_INIT_VCPU,
 
 	KVM_TDX_CMD_NR_MAX,
 };
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0548d54eb055..d28ffddd766f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -106,6 +106,14 @@ static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -260,6 +268,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_untagged_addr = vmx_get_untagged_addr,
 
 	.mem_enc_ioctl = vt_mem_enc_ioctl,
+	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 479ffb8f41c8..9008db6cf3b4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -419,6 +419,7 @@ int tdx_vm_init(struct kvm *kvm)
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	if (kvm_tdx->state != TD_STATE_INITIALIZED)
 		return -EIO;
@@ -442,12 +443,42 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
 		vcpu->arch.xfd_no_write_intercept = true;
 
+	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
+
 	return 0;
 }
 
 void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
-	/* This is stub for now.  More logic will come. */
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int i;
+
+	/*
+	 * It is not possible to reclaim pages while hkid is assigned. It might
+	 * be assigned if:
+	 * 1. the TD VM is being destroyed but freeing hkid failed, in which
+	 * case the pages are leaked
+	 * 2. TD VCPU creation failed and this on the error path, in which case
+	 * there is nothing to do anyway
+	 */
+	if (is_hkid_assigned(kvm_tdx))
+		return;
+
+	if (tdx->tdcx_pa) {
+		for (i = 0; i < kvm_tdx->nr_vcpu_tdcx_pages; i++) {
+			if (tdx->tdcx_pa[i])
+				tdx_reclaim_control_page(tdx->tdcx_pa[i]);
+		}
+		kfree(tdx->tdcx_pa);
+		tdx->tdcx_pa = NULL;
+	}
+	if (tdx->tdvpr_pa) {
+		tdx_reclaim_control_page(tdx->tdvpr_pa);
+		tdx->tdvpr_pa = 0;
+	}
+
+	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -657,6 +688,9 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 	tdr_pa = __pa(va);
 
 	kvm_tdx->nr_tdcs_pages = tdx_sysinfo->td_ctrl.tdcs_base_size / PAGE_SIZE;
+	/* TDVPS = TDVPR(4K page) + TDCX(multiple 4K pages), -1 for TDVPR. */
+	kvm_tdx->nr_vcpu_tdcx_pages = tdx_sysinfo->td_ctrl.tdvps_base_size / PAGE_SIZE - 1;
+
 	tdcs_pa = kcalloc(kvm_tdx->nr_tdcs_pages, sizeof(*kvm_tdx->tdcs_pa),
 			  GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!tdcs_pa)
@@ -936,6 +970,152 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
+{
+	const struct tdx_sys_info_features *modinfo = &tdx_sysinfo->features;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	unsigned long va;
+	int ret, i;
+	u64 err;
+
+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
+	if (!va)
+		return -ENOMEM;
+	tdx->tdvpr_pa = __pa(va);
+
+	tdx->tdcx_pa = kcalloc(kvm_tdx->nr_vcpu_tdcx_pages, sizeof(*tdx->tdcx_pa),
+			       GFP_KERNEL_ACCOUNT);
+	if (!tdx->tdcx_pa) {
+		ret = -ENOMEM;
+		goto free_tdvpr;
+	}
+
+	for (i = 0; i < kvm_tdx->nr_vcpu_tdcx_pages; i++) {
+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
+		if (!va) {
+			ret = -ENOMEM;
+			goto free_tdcx;
+		}
+		tdx->tdcx_pa[i] = __pa(va);
+	}
+
+	err = tdh_vp_create(kvm_tdx->tdr_pa, tdx->tdvpr_pa);
+	if (KVM_BUG_ON(err, vcpu->kvm)) {
+		ret = -EIO;
+		pr_tdx_error(TDH_VP_CREATE, err);
+		goto free_tdcx;
+	}
+
+	for (i = 0; i < kvm_tdx->nr_vcpu_tdcx_pages; i++) {
+		err = tdh_vp_addcx(tdx->tdvpr_pa, tdx->tdcx_pa[i]);
+		if (KVM_BUG_ON(err, vcpu->kvm)) {
+			pr_tdx_error(TDH_VP_ADDCX, err);
+			/*
+			 * Pages already added are reclaimed by the vcpu_free
+			 * method, but the rest are freed here.
+			 */
+			for (; i < kvm_tdx->nr_vcpu_tdcx_pages; i++) {
+				free_page((unsigned long)__va(tdx->tdcx_pa[i]));
+				tdx->tdcx_pa[i] = 0;
+			}
+			return -EIO;
+		}
+	}
+
+	if (modinfo->tdx_features0 & MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM)
+		err = tdh_vp_init_apicid(tdx->tdvpr_pa, vcpu_rcx, vcpu->vcpu_id);
+	else
+		err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
+
+	if (KVM_BUG_ON(err, vcpu->kvm)) {
+		pr_tdx_error(TDH_VP_INIT, err);
+		return -EIO;
+	}
+
+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+
+	return 0;
+
+free_tdcx:
+	for (i = 0; i < kvm_tdx->nr_vcpu_tdcx_pages; i++) {
+		if (tdx->tdcx_pa[i])
+			free_page((unsigned long)__va(tdx->tdcx_pa[i]));
+		tdx->tdcx_pa[i] = 0;
+	}
+	kfree(tdx->tdcx_pa);
+	tdx->tdcx_pa = NULL;
+
+free_tdvpr:
+	if (tdx->tdvpr_pa)
+		free_page((unsigned long)__va(tdx->tdvpr_pa));
+	tdx->tdvpr_pa = 0;
+
+	return ret;
+}
+
+static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
+{
+	struct msr_data apic_base_msr;
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	int ret;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	if (tdx->state != VCPU_TD_STATE_UNINITIALIZED)
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
+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd->data);
+	if (ret)
+		return ret;
+
+	tdx->state = VCPU_TD_STATE_INITIALIZED;
+
+	return 0;
+}
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct kvm_tdx_cmd cmd;
+	int ret;
+
+	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
+		return -EINVAL;
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.hw_error)
+		return -EINVAL;
+
+	switch (cmd.id) {
+	case KVM_TDX_INIT_VCPU:
+		ret = tdx_vcpu_init(vcpu, &cmd);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 1fcb7c1b078d..1b78a7ea988e 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -27,15 +27,26 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 	u8 nr_tdcs_pages;
+	u8 nr_vcpu_tdcx_pages;
 
 	u64 tsc_offset;
 
 	enum kvm_tdx_state state;
 };
 
+/* TDX module vCPU states */
+enum vcpu_tdx_state {
+	VCPU_TD_STATE_UNINITIALIZED = 0,
+	VCPU_TD_STATE_INITIALIZED,
+};
+
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
-	/* TDX specific members follow. */
+
+	unsigned long tdvpr_pa;
+	unsigned long *tdcx_pa;
+
+	enum vcpu_tdx_state state;
 };
 
 static inline bool is_td(struct kvm *kvm)
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index 84af7666e958..9d41699e66a2 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -155,4 +155,6 @@ struct td_params {
 #define TDX_MIN_TSC_FREQUENCY_KHZ		(100 * 1000)
 #define TDX_MAX_TSC_FREQUENCY_KHZ		(10 * 1000 * 1000)
 
+#define MD_FIELD_ID_FEATURES0_TOPOLOGY_ENUM	BIT_ULL(20)
+
 #endif /* __KVM_X86_TDX_ARCH_H */
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 107c60ac94f4..4739891858ea 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -127,6 +127,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+
+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 #else
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
@@ -136,6 +138,8 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+
+static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 95a10c7bc507..92de7ebf2cee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -698,6 +698,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
@@ -6308,6 +6309,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
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
@@ -12663,6 +12670,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.47.0


