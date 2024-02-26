Return-Path: <kvm+bounces-9662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C5D866C8F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C71801F21958
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE335DF10;
	Mon, 26 Feb 2024 08:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fo3Q2BMr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EB45B68B;
	Mon, 26 Feb 2024 08:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936087; cv=none; b=mTl2Rt9fnN8R95H++g1hQvlkpjCnIOSdQuWF40cBekol8GUFIFA+qCtNIzIoJDpm+I9v/qWs/HLocHmSwV2rkb3iimoWNd/t5RiRnvGFuEu8LVidVqYpSpZQgrIedN1B2kfv/ggFZt4h6gfIQnbL24kyjdyAuSfepGerDTvPzN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936087; c=relaxed/simple;
	bh=OJUmd0bYn1D5xie7Hcmu/a5DYtUvD3qiMfpVf7+fzsg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MvJTeGzNhBZoV3DsgXs01QTOtF2g26obc2KABTgOoJlA7t5xIH9MsLkIiXPXeJyF8af+tZcUrgeY8q3l9VRJl4Vv1HmF0ckxNIZ9z4aZ84lDgEPjxWfNhZ/UyCSdlohGcbDQeW4XME25p9TeSwqtuQYKiLS+A7XedIkCZnXxw/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fo3Q2BMr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936085; x=1740472085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OJUmd0bYn1D5xie7Hcmu/a5DYtUvD3qiMfpVf7+fzsg=;
  b=Fo3Q2BMrOTHT78peuEfIQN5HYtx+gc2Zu1+Ky2b/NUmJlxbomAvLDv18
   yDKek9hGBgLVcqpXp2rJEkaeyRTxsoBZfQ8o1CTgxI7S1oVYVolQFmDAj
   DKggBW+jo8E+Suio2fG9sSZrC8sDNoBoq6koRf6I2/Z9BLKx+T2dr1j2H
   5nQDtNwE4nZXeqVf2ZaBJ3WUjy2Jrp3r2Xj3F3QOKAJtlj3fxXmNongoj
   fu6XUzAG9iSeVBM/rj93avX5+Qd53MMyRjUBJVs+43hziZPgHKcbDh3bI
   ZXBgy3J8NiSlhAomMQV3/e+ql5zXThz89GCjL8S7WhUGyAEGnO+ILNx+L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155322"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155322"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615685"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:03 -0800
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
	tina.zhang@intel.com,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific parameters
Date: Mon, 26 Feb 2024 00:25:41 -0800
Message-Id: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
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

TDX requires additional parameters for TDX VM for confidential execution to
protect the confidentiality of its memory contents and CPU state from any
other software, including VMM.  When creating a guest TD VM before creating
vcpu, the number of vcpu, TSC frequency (the values are the same among
vcpus, and it can't change.)  CPUIDs which the TDX module emulates.  Guest
TDs can trust those CPUIDs and sha384 values for measurement.

Add a new subcommand, KVM_TDX_INIT_VM, to pass parameters for the TDX
guest.  It assigns an encryption key to the TDX guest for memory
encryption.  TDX encrypts memory per guest basis.  The device model, say
qemu, passes per-VM parameters for the TDX guest.  The maximum number of
vcpus, TSC frequency (TDX guest has fixed VM-wide TSC frequency, not per
vcpu.  The TDX guest can not change it.), attributes (production or debug),
available extended features (which configure guest XCR0, IA32_XSS MSR),
CPUIDs, sha384 measurements, etc.

Call this subcommand before creating vcpu and KVM_SET_CPUID2, i.e.  CPUID
configurations aren't available yet.  So CPUIDs configuration values need
to be passed in struct kvm_tdx_init_vm.  The device model's responsibility
to make this CPUID config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v19:
- Check NO_RBP_MOD of feature0 and set it
- Update the comment for PT and CET

v18:
- remove the change of tools/arch/x86/include/uapi/asm/kvm.h
- typo in comment. sha348 => sha384
- updated comment in setup_tdparams_xfam()
- fix setup_tdparams_xfam() to use init_vm instead of td_params

v15 -> v16:
- Removed AMX check as the KVM upstream supports AMX.
- Added CET flag to guest supported xss

v14 -> v15:
- add check if the reserved area of init_vm is zero

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h |  27 ++++
 arch/x86/kvm/cpuid.c            |   7 +
 arch/x86/kvm/cpuid.h            |   2 +
 arch/x86/kvm/vmx/tdx.c          | 273 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h          |  18 +++
 arch/x86/kvm/vmx/tdx_arch.h     |   6 +
 6 files changed, 323 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index e28189c81691..9ac0246bd974 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -570,6 +570,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -621,4 +622,30 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha384 digest */
+	/*
+	 * For future extensibility to make sizeof(struct kvm_tdx_init_vm) = 8KB.
+	 * This should be enough given sizeof(TD_PARAMS) = 1024.
+	 * 8KB was chosen given because
+	 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(=256) = 8KB.
+	 */
+	__u64 reserved[1004];
+
+	/*
+	 * Call KVM_TDX_INIT_VM before vcpu creation, thus before
+	 * KVM_SET_CPUID2.
+	 * This configuration supersedes KVM_SET_CPUID2s for VCPUs because the
+	 * TDX module directly virtualizes those CPUIDs without VMM.  The user
+	 * space VMM, e.g. qemu, should make KVM_SET_CPUID2 consistent with
+	 * those values.  If it doesn't, KVM may have wrong idea of vCPUIDs of
+	 * the guest, and KVM may wrongly emulate CPUIDs or MSRs that the TDX
+	 * module doesn't virtualize.
+	 */
+	struct kvm_cpuid2 cpuid;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index adba49afb5fe..8cdcd6f406aa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1443,6 +1443,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
+{
+	return cpuid_entry2_find(entries, nent, function, index);
+}
+EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry2);
+
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index)
 {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 856e3037e74f..215d1c68c6d1 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
+struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
+					       int nent, u32 function, u64 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
 						    u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1cf2b15da257..b11f105db3cd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -8,7 +8,6 @@
 #include "mmu.h"
 #include "tdx_arch.h"
 #include "tdx.h"
-#include "tdx_ops.h"
 #include "x86.h"
 
 #undef pr_fmt
@@ -350,18 +349,21 @@ static int tdx_do_tdh_mng_key_config(void *param)
 	return 0;
 }
 
-static int __tdx_td_init(struct kvm *kvm);
-
 int tdx_vm_init(struct kvm *kvm)
 {
+	/*
+	 * This function initializes only KVM software construct.  It doesn't
+	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
+	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
+	 */
+
 	/*
 	 * TDX has its own limit of the number of vcpus in addition to
 	 * KVM_MAX_VCPUS.
 	 */
 	kvm->max_vcpus = min(kvm->max_vcpus, TDX_MAX_VCPUS);
 
-	/* Place holder for TDX specific logic. */
-	return __tdx_td_init(kvm);
+	return 0;
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -416,9 +418,162 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	return ret;
 }
 
-static int __tdx_td_init(struct kvm *kvm)
+static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
+					struct td_params *td_params)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	int max_pa = 36;
+
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0x80000008, 0);
+	if (entry)
+		max_pa = entry->eax & 0xff;
+
+	td_params->eptp_controls = VMX_EPTP_MT_WB;
+	/*
+	 * No CPU supports 4-level && max_pa > 48.
+	 * "5-level paging and 5-level EPT" section 4.1 4-level EPT
+	 * "4-level EPT is limited to translating 48-bit guest-physical
+	 *  addresses."
+	 * cpu_has_vmx_ept_5levels() check is just in case.
+	 */
+	if (!cpu_has_vmx_ept_5levels() && max_pa > 48)
+		return -EINVAL;
+	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+
+	return 0;
+}
+
+static void setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
+				  struct td_params *td_params)
+{
+	int i;
+
+	/*
+	 * td_params.cpuid_values: The number and the order of cpuid_value must
+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
+	 * It's assumed that td_params was zeroed.
+	 */
+	for (i = 0; i < tdx_info->num_cpuid_config; i++) {
+		const struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
+		/* KVM_TDX_CPUID_NO_SUBLEAF means index = 0. */
+		u32 index = c->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF ? 0 : c->sub_leaf;
+		const struct kvm_cpuid_entry2 *entry =
+			kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
+					      c->leaf, index);
+		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
+
+		if (!entry)
+			continue;
+
+		/*
+		 * tdsysinfo.cpuid_configs[].{eax, ebx, ecx, edx}
+		 * bit 1 means it can be configured to zero or one.
+		 * bit 0 means it must be zero.
+		 * Mask out non-configurable bits.
+		 */
+		value->eax = entry->eax & c->eax;
+		value->ebx = entry->ebx & c->ebx;
+		value->ecx = entry->ecx & c->ecx;
+		value->edx = entry->edx & c->edx;
+	}
+}
+
+static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_params)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+
+	/* Setup td_params.xfam */
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 0);
+	if (entry)
+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
+	else
+		guest_supported_xcr0 = 0;
+	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
+
+	entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent, 0xd, 1);
+	if (entry)
+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
+	else
+		guest_supported_xss = 0;
+
+	/*
+	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
+	 * and, CET support.
+	 */
+	guest_supported_xss &=
+		(kvm_caps.supported_xss | XFEATURE_MASK_PT | TDX_TD_XFAM_CET);
+
+	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
+	if (td_params->xfam & XFEATURE_MASK_LBR) {
+		/*
+		 * TODO: once KVM supports LBR(save/restore LBR related
+		 * registers around TDENTER), remove this guard.
+		 */
+#define MSG_LBR	"TD doesn't support LBR yet. KVM needs to save/restore IA32_LBR_DEPTH properly.\n"
+		pr_warn(MSG_LBR);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			struct kvm_tdx_init_vm *init_vm)
+{
+	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
+	int ret;
+
+	if (kvm->created_vcpus)
+		return -EBUSY;
+
+	if (init_vm->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
+		/*
+		 * TODO: save/restore PMU related registers around TDENTER.
+		 * Once it's done, remove this guard.
+		 */
+#define MSG_PERFMON	"TD doesn't support perfmon yet. KVM needs to save/restore host perf registers properly.\n"
+		pr_warn(MSG_PERFMON);
+		return -EOPNOTSUPP;
+	}
+
+	td_params->max_vcpus = kvm->max_vcpus;
+	td_params->attributes = init_vm->attributes;
+	td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD;
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
+
+	ret = setup_tdparams_eptp_controls(cpuid, td_params);
+	if (ret)
+		return ret;
+	setup_tdparams_cpuids(cpuid, td_params);
+	ret = setup_tdparams_xfam(cpuid, td_params);
+	if (ret)
+		return ret;
+
+#define MEMCPY_SAME_SIZE(dst, src)				\
+	do {							\
+		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
+		memcpy((dst), (src), sizeof(dst));		\
+	} while (0)
+
+	MEMCPY_SAME_SIZE(td_params->mrconfigid, init_vm->mrconfigid);
+	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
+	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
+
+	return 0;
+}
+
+static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
+			 u64 *seamcall_err)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_args out;
 	cpumask_var_t packages;
 	unsigned long *tdcs_pa = NULL;
 	unsigned long tdr_pa = 0;
@@ -426,6 +581,7 @@ static int __tdx_td_init(struct kvm *kvm)
 	int ret, i;
 	u64 err;
 
+	*seamcall_err = 0;
 	ret = tdx_guest_keyid_alloc();
 	if (ret < 0)
 		return ret;
@@ -540,10 +696,23 @@ static int __tdx_td_init(struct kvm *kvm)
 		}
 	}
 
-	/*
-	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
-	 * ioctl() to define the configure CPUID values for the TD.
-	 */
+	err = tdh_mng_init(kvm_tdx->tdr_pa, __pa(td_params), &out);
+	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
+		/*
+		 * Because a user gives operands, don't warn.
+		 * Return a hint to the user because it's sometimes hard for the
+		 * user to figure out which operand is invalid.  SEAMCALL status
+		 * code includes which operand caused invalid operand error.
+		 */
+		*seamcall_err = err;
+		ret = -EINVAL;
+		goto teardown;
+	} else if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_INIT, err, &out);
+		ret = -EIO;
+		goto teardown;
+	}
+
 	return 0;
 
 	/*
@@ -586,6 +755,76 @@ static int __tdx_td_init(struct kvm *kvm)
 	return ret;
 }
 
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm *init_vm = NULL;
+	struct td_params *td_params = NULL;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*init_vm) != 8 * 1024);
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	if (is_hkid_assigned(kvm_tdx))
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	init_vm = kzalloc(sizeof(*init_vm) +
+			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
+			  GFP_KERNEL);
+	if (!init_vm)
+		return -ENOMEM;
+	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
+		ret = -E2BIG;
+		goto out;
+	}
+	if (copy_from_user(init_vm->cpuid.entries,
+			   (void __user *)cmd->data + sizeof(*init_vm),
+			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
+		ret = -EINVAL;
+		goto out;
+	}
+	if (init_vm->cpuid.padding) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
+	if (!td_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = setup_tdparams(kvm, td_params, init_vm);
+	if (ret)
+		goto out;
+
+	ret = __tdx_td_init(kvm, td_params, &cmd->error);
+	if (ret)
+		goto out;
+
+	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->attributes = td_params->attributes;
+	kvm_tdx->xfam = td_params->xfam;
+
+out:
+	/* kfree() accepts NULL. */
+	kfree(init_vm);
+	kfree(td_params);
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -602,6 +841,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_CAPABILITIES:
 		r = tdx_get_capabilities(&tdx_cmd);
 		break;
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -725,6 +967,17 @@ static int __init tdx_module_setup(void)
 
 	tdx_info->nr_tdcs_pages = tdcs_base_size / PAGE_SIZE;
 
+	/*
+	 * Make TDH.VP.ENTER preserve RBP so that the stack unwinder
+	 * always work around it.  Query the feature.
+	 */
+	if (!(tdx_info->features0 & MD_FIELD_ID_FEATURES0_NO_RBP_MOD) &&
+	    !IS_ENABLED(CONFIG_FRAME_POINTER)) {
+		pr_err("Too old version of TDX module. Consider upgrade.\n");
+		ret = -EOPNOTSUPP;
+		goto error_out;
+	}
+
 	return 0;
 
 error_out:
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ae117f864cfb..184fe394da86 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -12,7 +12,11 @@ struct kvm_tdx {
 	unsigned long tdr_pa;
 	unsigned long *tdcs_pa;
 
+	u64 attributes;
+	u64 xfam;
 	int hkid;
+
+	u64 tsc_offset;
 };
 
 struct vcpu_tdx {
@@ -39,6 +43,20 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
+
+static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
+{
+	struct tdx_module_args out;
+	u64 err;
+
+	err = tdh_mng_rd(kvm_tdx->tdr_pa, TDCS_EXEC(field), &out);
+	if (unlikely(err)) {
+		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
+		return 0;
+	}
+	return out.r8;
+}
+
 #else
 struct kvm_tdx {
 	struct kvm kvm;
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index e2c1a6f429d7..efc3c61c14ab 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -117,6 +117,12 @@ struct tdx_cpuid_value {
 #define TDX_TD_ATTRIBUTE_KL		BIT_ULL(31)
 #define TDX_TD_ATTRIBUTE_PERFMON	BIT_ULL(63)
 
+/*
+ * TODO: Once XFEATURE_CET_{U, S} in arch/x86/include/asm/fpu/types.h is
+ * defined, Replace these with define ones.
+ */
+#define TDX_TD_XFAM_CET	(BIT(11) | BIT(12))
+
 /*
  * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
  */
-- 
2.25.1


