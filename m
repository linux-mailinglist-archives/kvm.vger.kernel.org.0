Return-Path: <kvm+bounces-9754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C5E3C866DC1
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:11:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AFFC28383B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B856131E46;
	Mon, 26 Feb 2024 08:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vhr1Tt0d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB90130E4A;
	Mon, 26 Feb 2024 08:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936165; cv=none; b=lOMCA6EGVImwHFvxfOkObkyU28f2m2Ke1Fy8beUXCVpjRV2D9KghCNjMU3TXU5dAwFel64ptfkbxCIzBMd9QdYAbNViiwX+XOETD6J1LRqCkTxk738TeA47PADC/3iGNndHXB+6ryQ3w3ry/wCmwADES+8HPQZOudgpH/T2LwUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936165; c=relaxed/simple;
	bh=zdJVqbTu3xcs4a9uKIZqxUpxrTdKz6FK+bu86cLPFRI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t2J/co7IsMucmSiTyc0xEFw/VH8gtYHTUVyZeT0gI5Xzy5o52ZPrkzJ32SmPfmLPXIE20GReLpntNj5N3dqbl3+xgoLgJ4IifZPpXg2i0tLpbjB3SaV1pKj7/PA80U700WFoOn5vkUnEQSWLf8cli0MSo/PonHaQmRYSMvcK/z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vhr1Tt0d; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936163; x=1740472163;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdJVqbTu3xcs4a9uKIZqxUpxrTdKz6FK+bu86cLPFRI=;
  b=Vhr1Tt0deJGEMHzpY5nm1ngfZ5yf9NT6GwCDwkhWzHwVBCygOEOqv3dT
   VbFKKrMJqL2D9+iyk9ErL2+6immqHnKRDGJRP18YZ0FhWfA7qMSlftFOz
   RDgt4hQHcveYeneP+RMW2sxJ+BMPFVurZ/mIHN0IZcYCoHdfErqHZXf3J
   Mi5eB5nIE8aKw0sqnYhbDkzUIGbsH8P8zg4+H9McCMcvTkNt4vqUdseQT
   Nji1lqKcllBjHH3tzjWUORfGtRmOrdSDepegDpGqz064/qknc04PwMm1c
   DYGARHSQ5yzOu5lATFAvhzK+dOEVBud5exfgr/XE0R0c1SCTsgM7R25f2
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751431"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751431"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735168"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:13 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for KVM_SET_CPUID2
Date: Mon, 26 Feb 2024 00:27:12 -0800
Message-Id: <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement a hook of KVM_SET_CPUID2 for additional consistency check.

Intel TDX or AMD SEV has a restriction on the value of cpuid.  For example,
some values must be the same between all vcpus.  Check if the new values
are consistent with the old values.  The check is light because the cpuid
consistency is very model specific and complicated.  The user space VMM
should set cpuid and MSRs consistently.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- Use TDH.SYS.RD() instead of struct tdsysinfo_struct
---
 arch/x86/kvm/vmx/main.c    | 10 ++++++
 arch/x86/kvm/vmx/tdx.c     | 66 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h     |  7 ++++
 arch/x86/kvm/vmx/x86_ops.h |  4 +++
 4 files changed, 81 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 2cd404fd7176..1a979ec644d0 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -432,6 +432,15 @@ static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
 	kvm_vcpu_deliver_init(vcpu);
 }
 
+static int vt_vcpu_check_cpuid(struct kvm_vcpu *vcpu,
+			       struct kvm_cpuid_entry2 *e2, int nent)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_check_cpuid(vcpu, e2, nent);
+
+	return 0;
+}
+
 static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -1125,6 +1134,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.get_exit_info = vt_get_exit_info,
 
+	.vcpu_check_cpuid = vt_vcpu_check_cpuid,
 	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7be1be161dc2..a71093f7c3e3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -547,6 +547,9 @@ void tdx_vm_free(struct kvm *kvm)
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
+
+	kfree(kvm_tdx->cpuid);
+	kvm_tdx->cpuid = NULL;
 }
 
 static int tdx_do_tdh_mng_key_config(void *param)
@@ -661,6 +664,39 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	int i;
+
+	/*
+	 * Simple check that new cpuid is consistent with created one.
+	 * For simplicity, only trivial check.  Don't try comprehensive checks
+	 * with the cpuid virtualization table in the TDX module spec.
+	 */
+	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
+		const struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
+		u32 index = c->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF ? 0 : c->sub_leaf;
+		const struct kvm_cpuid_entry2 *old =
+			kvm_find_cpuid_entry2(kvm_tdx->cpuid, kvm_tdx->cpuid_nent,
+					      c->leaf, index);
+		const struct kvm_cpuid_entry2 *new = kvm_find_cpuid_entry2(e2, nent,
+									   c->leaf, index);
+
+		if (!!old != !!new)
+			return -EINVAL;
+		if (!old && !new)
+			continue;
+
+		if ((old->eax ^ new->eax) & c->eax ||
+		    (old->ebx ^ new->ebx) & c->ebx ||
+		    (old->ecx ^ new->ecx) & c->ecx ||
+		    (old->edx ^ new->edx) & c->edx)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -2205,9 +2241,10 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
 	return 0;
 }
 
-static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
+static void setup_tdparams_cpuids(struct kvm *kvm, struct kvm_cpuid2 *cpuid,
 				  struct td_params *td_params)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	int i;
 
 	/*
@@ -2215,6 +2252,7 @@ static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
 	 * It's assumed that td_params was zeroed.
 	 */
+	kvm_tdx->cpuid_nent = 0;
 	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
 		const struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
 		/* KVM_TDX_CPUID_NO_SUBLEAF means index = 0. */
@@ -2237,6 +2275,10 @@ static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
 		value->ebx = entry->ebx & c->ebx;
 		value->ecx = entry->ecx & c->ecx;
 		value->edx = entry->edx & c->edx;
+
+		/* Remember the setting to check for KVM_SET_CPUID2. */
+		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
+		kvm_tdx->cpuid_nent++;
 	}
 }
 
@@ -2324,7 +2366,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	ret = setup_tdparams_eptp_controls(cpuid, td_params);
 	if (ret)
 		return ret;
-	setup_tdparams_cpuids(cpuid, td_params);
+	setup_tdparams_cpuids(kvm, cpuid, td_params);
 	ret = setup_tdparams_xfam(cpuid, td_params);
 	if (ret)
 		return ret;
@@ -2548,11 +2590,18 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	if (cmd->flags)
 		return -EINVAL;
 
-	init_vm = kzalloc(sizeof(*init_vm) +
-			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
-			  GFP_KERNEL);
-	if (!init_vm)
+	WARN_ON_ONCE(kvm_tdx->cpuid);
+	kvm_tdx->cpuid = kzalloc(flex_array_size(init_vm, cpuid.entries, KVM_MAX_CPUID_ENTRIES),
+				 GFP_KERNEL);
+	if (!kvm_tdx->cpuid)
 		return -ENOMEM;
+
+	init_vm = kzalloc(struct_size(init_vm, cpuid.entries, KVM_MAX_CPUID_ENTRIES),
+			  GFP_KERNEL);
+	if (!init_vm) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
 		ret = -EFAULT;
 		goto out;
@@ -2602,6 +2651,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
 out:
 	/* kfree() accepts NULL. */
+	if (ret) {
+		kfree(kvm_tdx->cpuid);
+		kvm_tdx->cpuid = NULL;
+		kvm_tdx->cpuid_nent = 0;
+	}
 	kfree(init_vm);
 	kfree(td_params);
 	return ret;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 11c74c34555f..af3a2b8afee8 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -31,6 +31,13 @@ struct kvm_tdx {
 
 	u64 tsc_offset;
 
+	/*
+	 * For KVM_SET_CPUID to check consistency. Remember the one passed to
+	 * TDH.MNG_INIT
+	 */
+	int cpuid_nent;
+	struct kvm_cpuid_entry2 *cpuid;
+
 	/* For KVM_MEMORY_MAPPING */
 	struct mutex source_lock;
 	struct page *source_page;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c507f1513dac..6b067842a67f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -162,6 +162,8 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+			 int nent);
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
@@ -221,6 +223,8 @@ static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				       int nent) { return -EOPNOTSUPP; }
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
-- 
2.25.1


