Return-Path: <kvm+bounces-23908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A3B94F9EC
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20B97B22716
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7931B19FA93;
	Mon, 12 Aug 2024 22:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKAGlP5d"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D40F19E811;
	Mon, 12 Aug 2024 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502923; cv=none; b=aoA+y6HMY/Kote1l3ogeI9l3r4xElL+SctFHMG2fTaYMNQvXecncY7zg9aoGHjm1q55yhrNahOH8Nj4uQPkziRvGvFmDqiIf9SVHqAijDA1I2LgOSjkYME2tEKTmlMxEpr+d0WRoiMSO2LLaKIyDOdW6asEs/INeZLNwA63ux+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502923; c=relaxed/simple;
	bh=ODvXJRuT8dd+sZxLAOTQBkCIn9z8TdIvs/2HprMYjag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G6IIMWDqQOWhiKxCV9AAKb7jhUSkj1lup2dHBs+hl/D+mC4X+9+/BFOqchxl7lnvbgAYseCpHwoJnBs7BFZlIkUhHaNn4+ocpzSZvoQE8EO4zR4+qgjqB+Q1x8xIqsMh7bLVH1MDbWdIXuVglKbXiV/GGJFUPBmIJU72Lu0POMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKAGlP5d; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502921; x=1755038921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ODvXJRuT8dd+sZxLAOTQBkCIn9z8TdIvs/2HprMYjag=;
  b=BKAGlP5dhASKbgV+PKxVJ+k2AQfhUcOV2d0UeESvS6YpkFqRE/73yqur
   XKdaxcd5b4idMkRIdl7AMPIleAB181Y4TD2gHXeOTFDoSuI8hMGLz8Q9b
   2HkLieiyNqKOb8D/xtsYD51VARi+AfYcDWXAD8KlcXFqfnlMhDWkuyyPd
   eFJTe7IH+TU9RwTtZ/H3IC250lmD7YrBHSelCa+/ofnn683LvuBAxT2Cf
   of7rY/LSzeFabF45ik7NoCezuKSA3aFg+JLL7uIqw/WQnvsUxEO7vFeFr
   AoSAu9papu6v1pYtWCIVegYeDuBo/r5aG3ZaI5MGLMm1Ui+KXO+B1JdpH
   Q==;
X-CSE-ConnectionGUID: IrSEYkzbQlmX7N7ea1MfXg==
X-CSE-MsgGUID: 65O6QiU0QdmJEcmbDaNLVg==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041418"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041418"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:34 -0700
X-CSE-ConnectionGUID: PrcaDnW/SQOO2WQXCbFnMw==
X-CSE-MsgGUID: oHQE6b+ZT6q5CR8fEDvgxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008419"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:34 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific parameters
Date: Mon, 12 Aug 2024 15:48:09 -0700
Message-Id: <20240812224820.34826-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

After the crypto-protection key has been configured, TDX requires a
VM-scope initialization as a step of creating the TDX guest.  This
"per-VM" TDX initialization does the global configurations/features that
the TDX guest can support, such as guest's CPUIDs (emulated by the TDX
module), the maximum number of vcpus etc.

This "per-VM" TDX initialization must be done before any "vcpu-scope" TDX
initialization.  To match this better, require the KVM_TDX_INIT_VM IOCTL()
to be done before KVM creates any vcpus.

Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - Drop TDX_TD_XFAM_CET and use XFEATURE_MASK_CET_{USER, KERNEL}.
 - Update for the wrapper functions for SEAMCALLs. (Sean)
 - Move gfn_shared_mask settings into this patch due to MMU section move
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)
 - Allow userspace configure xfam directly
 - Check if user sets non-configurable bits in CPUIDs
 - Rename error->hw_error
 - Move code change to tdx_module_setup() to __tdx_bringup() due to
   initializing is done in post hardware_setup() now and
   tdx_module_setup() is removed.  Remove the code to use API to read
   global metadata but use exported 'struct tdx_sysinfo' pointer.
 - Replace 'tdx_info->nr_tdcs_pages' with a wrapper
   tdx_sysinfo_nr_tdcs_pages() because the 'struct tdx_sysinfo' doesn't
   have nr_tdcs_pages directly.
 - Replace tdx_info->max_vcpus_per_td with the new exported pointer in
   tdx_vm_init().
 - Decrease the reserved space for struct kvm_tdx_init_vm (Kai)
 - Use sizeof_field() for struct kvm_tdx_init_vm cpuids (Tony)
 - No need to init init_vm, it gets copied over in tdx_td_init() (Chao)
 - Use kmalloc() instead of () kzalloc for init_vm in tdx_td_init() (Chao)
 - Add more line breaks to tdx_td_init() to make code easier to read (Tony)
 - Clarify patch description (Kai)

v19:
 - Check NO_RBP_MOD of feature0 and set it
 - Update the comment for PT and CET

v18:
 - remove the change of tools/arch/x86/include/uapi/asm/kvm.h
 - typo in comment. sha348 => sha384
 - updated comment in setup_tdparams_xfam()
 - fix setup_tdparams_xfam() to use init_vm instead of td_params

v16:
 - Removed AMX check as the KVM upstream supports AMX.
 - Added CET flag to guest supported xss
---
 arch/x86/include/uapi/asm/kvm.h |  24 ++++
 arch/x86/kvm/cpuid.c            |   7 +
 arch/x86/kvm/cpuid.h            |   2 +
 arch/x86/kvm/vmx/tdx.c          | 237 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h          |   4 +
 arch/x86/kvm/vmx/tdx_ops.h      |  12 ++
 6 files changed, 276 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 2e3caa5a58fd..95ae2d4a4697 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -929,6 +929,7 @@ struct kvm_hyperv_eventfd {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -970,4 +971,27 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 xfam;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha384 digest */
+
+	/* The total space for TD_PARAMS before the CPUIDs is 256 bytes */
+	__u64 reserved[12];
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
index 2617be544480..7310d8a8a503 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1487,6 +1487,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
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
index 41697cca354e..00570227e2ae 100644
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
index a0954c3928e2..a6c711715a4a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,6 +7,7 @@
 #include "tdx.h"
 #include "tdx_ops.h"
 
+
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
@@ -356,12 +357,16 @@ static int tdx_do_tdh_mng_key_config(void *param)
 	return 0;
 }
 
-static int __tdx_td_init(struct kvm *kvm);
-
 int tdx_vm_init(struct kvm *kvm)
 {
 	kvm->arch.has_private_mem = true;
 
+	/*
+	 * This function initializes only KVM software construct.  It doesn't
+	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
+	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
+	 */
+
 	/*
 	 * TDX has its own limit of the number of vcpus in addition to
 	 * KVM_MAX_VCPUS.
@@ -369,8 +374,7 @@ int tdx_vm_init(struct kvm *kvm)
 	kvm->max_vcpus = min(kvm->max_vcpus,
 			tdx_sysinfo->td_conf.max_vcpus_per_td);
 
-	/* Place holder for TDX specific logic. */
-	return __tdx_td_init(kvm);
+	return 0;
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -419,7 +423,123 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
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
+static int setup_tdparams_cpuids(struct kvm_cpuid2 *cpuid,
+				 struct td_params *td_params)
+{
+	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	const struct kvm_tdx_cpuid_config *c;
+	const struct kvm_cpuid_entry2 *entry;
+	struct tdx_cpuid_value *value;
+	int i;
+
+	/*
+	 * td_params.cpuid_values: The number and the order of cpuid_value must
+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
+	 * It's assumed that td_params was zeroed.
+	 */
+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
+		c = &kvm_tdx_caps->cpuid_configs[i];
+		entry = kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
+					      c->leaf, c->sub_leaf);
+		if (!entry)
+			continue;
+
+		/*
+		 * Check the user input value doesn't set any non-configurable
+		 * bits reported by kvm_tdx_caps.
+		 */
+		if ((entry->eax & c->eax) != entry->eax ||
+		    (entry->ebx & c->ebx) != entry->ebx ||
+		    (entry->ecx & c->ecx) != entry->ecx ||
+		    (entry->edx & c->edx) != entry->edx)
+			return -EINVAL;
+
+		value = &td_params->cpuid_values[i];
+		value->eax = entry->eax;
+		value->ebx = entry->ebx;
+		value->ecx = entry->ecx;
+		value->edx = entry->edx;
+	}
+
+	return 0;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			struct kvm_tdx_init_vm *init_vm)
+{
+	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
+	int ret;
+
+	if (kvm->created_vcpus)
+		return -EBUSY;
+
+	if (init_vm->attributes & ~kvm_tdx_caps->supported_attrs)
+		return -EINVAL;
+
+	if (init_vm->xfam & ~kvm_tdx_caps->supported_xfam)
+		return -EINVAL;
+
+	td_params->max_vcpus = kvm->max_vcpus;
+	td_params->attributes = init_vm->attributes | td_conf->attributes_fixed1;
+	td_params->xfam = init_vm->xfam | td_conf->xfam_fixed1;
+
+	/* td_params->exec_controls = TDX_CONTROL_FLAG_NO_RBP_MOD; */
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
+
+	ret = setup_tdparams_eptp_controls(cpuid, td_params);
+	if (ret)
+		return ret;
+
+	ret = setup_tdparams_cpuids(cpuid, td_params);
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
 	cpumask_var_t packages;
@@ -427,8 +547,9 @@ static int __tdx_td_init(struct kvm *kvm)
 	unsigned long tdr_pa = 0;
 	unsigned long va;
 	int ret, i;
-	u64 err;
+	u64 err, rcx;
 
+	*seamcall_err = 0;
 	ret = tdx_guest_keyid_alloc();
 	if (ret < 0)
 		return ret;
@@ -543,10 +664,23 @@ static int __tdx_td_init(struct kvm *kvm)
 		}
 	}
 
-	/*
-	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
-	 * ioctl() to define the configure CPUID values for the TD.
-	 */
+	err = tdh_mng_init(kvm_tdx, __pa(td_params), &rcx);
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
+		pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
+		ret = -EIO;
+		goto teardown;
+	}
+
 	return 0;
 
 	/*
@@ -592,6 +726,86 @@ static int __tdx_td_init(struct kvm *kvm)
 	return ret;
 }
 
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm *init_vm;
+	struct td_params *td_params = NULL;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	if (is_hkid_assigned(kvm_tdx))
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	init_vm = kmalloc(sizeof(*init_vm) +
+			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
+			  GFP_KERNEL);
+	if (!init_vm)
+		return -ENOMEM;
+
+	if (copy_from_user(init_vm, u64_to_user_ptr(cmd->data), sizeof(*init_vm))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (init_vm->cpuid.nent > KVM_MAX_CPUID_ENTRIES) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	if (copy_from_user(init_vm->cpuid.entries,
+			   u64_to_user_ptr(cmd->data) + sizeof(*init_vm),
+			   flex_array_size(init_vm, cpuid.entries, init_vm->cpuid.nent))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (memchr_inv(init_vm->reserved, 0, sizeof(init_vm->reserved))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
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
+	ret = __tdx_td_init(kvm, td_params, &cmd->hw_error);
+	if (ret)
+		goto out;
+
+	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->attributes = td_params->attributes;
+	kvm_tdx->xfam = td_params->xfam;
+
+	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
+	else
+		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
+
+out:
+	/* kfree() accepts NULL. */
+	kfree(init_vm);
+	kfree(td_params);
+
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -613,6 +827,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_CAPABILITIES:
 		r = tdx_get_capabilities(&tdx_cmd);
 		break;
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 268959d0f74f..8912cb6d5bc2 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -16,7 +16,11 @@ struct kvm_tdx {
 	unsigned long tdr_pa;
 	unsigned long *tdcs_pa;
 
+	u64 attributes;
+	u64 xfam;
 	int hkid;
+
+	u64 tsc_offset;
 };
 
 struct vcpu_tdx {
diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index 3f64c871a3f2..0363d8544f42 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -399,4 +399,16 @@ static inline u64 tdh_vp_wr(struct vcpu_tdx *tdx, u64 field, u64 val, u64 mask)
 	return seamcall(TDH_VP_WR, &in);
 }
 
+static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
+{
+	u64 err, data;
+
+	err = tdh_mng_rd(kvm_tdx, TDCS_EXEC(field), &data);
+	if (unlikely(err)) {
+		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
+		return 0;
+	}
+	return data;
+}
+
 #endif /* __KVM_X86_TDX_OPS_H */
-- 
2.34.1


