Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60D755CEB9
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbiF0Vzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241359AbiF0Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:58 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B8E63A6;
        Mon, 27 Jun 2022 14:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366895; x=1687902895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=baUUEcA/TrSqs26NPCyclSR6y7urv0CPdA18UChdAaw=;
  b=bNZIsDSxz96rWk1DAkZSn7tmhioGFYQlDbs0ogicBHgMv/bXjt5VY12A
   nNAlHKdmRpfwyB6v7ArtqHELpO6Bma6xl5ppIkjYXkiEjUZrD7ROuT6Rt
   n9aMHBIA6sreTP6802fyrHkkRMeV+GugaxZ4EQ5njp8gNYSXE/lb6x89z
   RIYR3QiVThrXCfI8ewsXfvZZWAwCIl+3GRC45Q4yoStmOKK9blP8JSesd
   Axere8ixI5PkwpBlQfd7/sFZIg4W9PDSMikSByZNc8Io+klWYwcYoDPtE
   Z71XREiHixe1BV7riowvsEzeJ3MIjo68qZM0oicwmuJ2ivknBOyGiLJxt
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609522"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609522"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863513"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v7 025/102] KVM: TDX: initialize VM with TDX specific parameters
Date:   Mon, 27 Jun 2022 14:53:17 -0700
Message-Id: <cb901b3a0eb475d7a33507318c1ba95120fc425e.1656366338.git.isaku.yamahata@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

TDX requires additional parameters for TDX VM for confidential execution to
protect its confidentiality of its memory contents and its CPU state from
any other software, including VMM. When creating guest TD VM before
creating vcpu, the number of vcpu, TSC frequency (that is same among
vcpus. and it can't be changed.)  CPUIDs which is emulated by the TDX
module. It means guest can trust those CPUIDs. and sha384 values for
measurement.

Add new subcommand, KVM_TDX_INIT_VM, to pass parameters for TDX guest.  It
assigns encryption key to the TDX guest for memory encryption.  TDX
encrypts memory per-guest bases.  It assigns device model passes per-VM
parameters for the TDX guest.  The maximum number of vcpus, tsc frequency
(TDX guest has fised VM-wide TSC frequency. not per-vcpu.  The TDX guest
can not change it.), attributes (production or debug), available extended
features (which is reflected into guest XCR0, IA32_XSS MSR), cpuids, sha384
measurements, and etc.

This subcommand is called before creating vcpu and KVM_SET_CPUID2, i.e.
cpuids configurations aren't available yet.  So CPUIDs configuration values
needs to be passed in struct kvm_init_vm.  It's device model responsibility
to make this cpuid config for KVM_TDX_INIT_VM and KVM_SET_CPUID2.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h       |   2 +
 arch/x86/include/asm/tdx.h            |   3 +
 arch/x86/include/uapi/asm/kvm.h       |  33 +++++
 arch/x86/kvm/vmx/tdx.c                | 206 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  23 +++
 tools/arch/x86/include/uapi/asm/kvm.h |  33 +++++
 6 files changed, 300 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 342decc69649..81638987cdb9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1338,6 +1338,8 @@ struct kvm_arch {
 	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
 	 */
 	u32 max_vcpu_ids;
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6c0925e73a27..26e3e2da685a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -89,6 +89,9 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
 
 #ifdef CONFIG_INTEL_TDX_HOST
+
+/* -1 indicates CPUID leaf with no sub-leaves. */
+#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
 struct tdx_cpuid_config {
 	u32	leaf;
 	u32	sub_leaf;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 273c8d82b9c8..f89774ccd4ae 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -537,6 +537,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -582,4 +583,36 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[0];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u32 max_vcpus;
+	__u32 padding;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha348 digest */
+	union {
+		/*
+		 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
+		 * KVM_SET_CPUID2.  CPUID configurations needs to be passed.
+		 *
+		 * This configuration supersedes KVM_SET_CPUID{,2}.
+		 * The user space VMM, e.g. qemu, should make them consistent
+		 * with this values.
+		 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(256)
+		 * = 8KB.
+		 */
+		struct {
+			struct kvm_cpuid2 cpuid;
+			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
+			struct kvm_cpuid_entry2 entries[];
+		};
+		/*
+		 * For future extensibility.
+		 * The size(struct kvm_tdx_init_vm) = 16KB.
+		 * This should be enough given sizeof(TD_PARAMS) = 1024
+		 */
+		__u64 reserved[2028];
+	};
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2a9dfd54189f..1273b60a1a00 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -438,6 +438,209 @@ int tdx_dev_ioctl(void __user *argp)
 	return 0;
 }
 
+/*
+ * cpuid entry lookup in TDX cpuid config way.
+ * The difference is how to specify index(subleaves).
+ * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with no-subleaves.
+ */
+static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
+	const struct kvm_cpuid2 *cpuid, u32 function, u32 index)
+{
+	int i;
+
+
+	/* In TDX CPU CONFIG, TDX_CPUID_NO_SUBLEAF means index = 0. */
+	if (index == TDX_CPUID_NO_SUBLEAF)
+		index = 0;
+
+	for (i = 0; i < cpuid->nent; i++) {
+		const struct kvm_cpuid_entry2 *e = &cpuid->entries[i];
+
+		if (e->function == function &&
+		    (e->index == index ||
+		     !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+			return e;
+	}
+	return NULL;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			struct kvm_tdx_init_vm *init_vm)
+{
+	const struct kvm_cpuid2 *cpuid = &init_vm->cpuid;
+	const struct kvm_cpuid_entry2 *entry;
+	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	int max_pa;
+	int i;
+
+	td_params->max_vcpus = init_vm->max_vcpus;
+
+	td_params->attributes = init_vm->attributes;
+	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
+		/*
+		 * TODO: save/restore PMU related registers around TDENTER.
+		 * Once it's done, remove this guard.
+		 */
+		pr_warn("TD doesn't support perfmon yet. KVM needs to save/restore "
+			"host perf registers properly.\n");
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
+		const struct tdx_cpuid_config *config = &tdx_caps.cpuid_configs[i];
+		const struct kvm_cpuid_entry2 *entry =
+			tdx_find_cpuid_entry(cpuid, config->leaf, config->sub_leaf);
+		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
+
+		if (!entry)
+			continue;
+
+		value->eax = entry->eax & config->eax;
+		value->ebx = entry->ebx & config->ebx;
+		value->ecx = entry->ecx & config->ecx;
+		value->edx = entry->edx & config->edx;
+	}
+
+	max_pa = 36;
+	entry = tdx_find_cpuid_entry(cpuid, 0x80000008, 0);
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
+	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+
+	/* Setup td_params.xfam */
+	entry = tdx_find_cpuid_entry(cpuid, 0xd, 0);
+	if (entry)
+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
+	else
+		guest_supported_xcr0 = 0;
+	guest_supported_xcr0 &= kvm_caps.supported_xcr0;
+
+	entry = tdx_find_cpuid_entry(cpuid, 0xd, 1);
+	if (entry)
+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
+	else
+		guest_supported_xss = 0;
+	/* PT can be exposed to TD guest regardless of KVM's XSS support */
+	guest_supported_xss &= (kvm_caps.supported_xss | XFEATURE_MASK_PT);
+
+	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
+	if (td_params->xfam & XFEATURE_MASK_LBR) {
+		/*
+		 * TODO: once KVM supports LBR(save/restore LBR related
+		 * registers around TDENTER), remove this guard.
+		 */
+		pr_warn("TD doesn't support LBR yet. KVM needs to save/restore "
+			"IA32_LBR_DEPTH properly.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (td_params->xfam & XFEATURE_MASK_XTILE) {
+		/*
+		 * TODO: once KVM supports AMX(save/restore AMX related
+		 * registers around TDENTER), remove this guard.
+		 */
+		pr_warn("TD doesn't support AMX yet. KVM needs to save/restore "
+			"IA32_XFD, IA32_XFD_ERR properly.\n");
+		return -EOPNOTSUPP;
+	}
+
+	td_params->tsc_frequency =
+		TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
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
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm *init_vm = NULL;
+	struct td_params *td_params = NULL;
+	struct tdx_module_output out;
+	int ret;
+	u64 err;
+
+	BUILD_BUG_ON(sizeof(*init_vm) != 16 * 1024);
+	BUILD_BUG_ON((sizeof(*init_vm) - offsetof(typeof(*init_vm), entries)) /
+		     sizeof(init_vm->entries[0]) < KVM_MAX_CPUID_ENTRIES);
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	if (is_td_initialized(kvm))
+		return -EINVAL;
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	init_vm = kzalloc(sizeof(*init_vm), GFP_KERNEL);
+	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (init_vm->max_vcpus > KVM_MAX_VCPUS) {
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
+	err = tdh_mng_init(kvm_tdx->tdr.pa, __pa(td_params), &out);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_INIT, err, &out);
+		ret = -EIO;
+		goto out;
+	}
+
+	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->attributes = td_params->attributes;
+	kvm_tdx->xfam = td_params->xfam;
+	kvm_tdx->tsc_khz = TDX_TSC_25MHZ_TO_KHZ(td_params->tsc_frequency);
+	kvm->max_vcpus = td_params->max_vcpus;
+
+	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
+	else
+		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
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
@@ -451,6 +654,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8058b6b153f8..8a0793fcc3ab 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -20,7 +20,12 @@ struct kvm_tdx {
 	struct tdx_td_page tdr;
 	struct tdx_td_page *tdcs;
 
+	u64 attributes;
+	u64 xfam;
 	int hkid;
+
+	u64 tsc_offset;
+	unsigned long tsc_khz;
 };
 
 struct vcpu_tdx {
@@ -50,6 +55,11 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+static inline bool is_td_initialized(struct kvm *kvm)
+{
+	return !!kvm->max_vcpus;
+}
+
 static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && (field) & 0x1,
@@ -135,6 +145,19 @@ TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
 TDX_BUILD_TDVPS_ACCESSORS(64, STATE_NON_ARCH, state_non_arch);
 TDX_BUILD_TDVPS_ACCESSORS(8, MANAGEMENT, management);
 
+static __always_inline u64 td_tdcs_exec_read64(struct kvm_tdx *kvm_tdx, u32 field)
+{
+	struct tdx_module_output out;
+	u64 err;
+
+	err = tdh_mng_rd(kvm_tdx->tdr.pa, TDCS_EXEC(field), &out);
+	if (unlikely(err)) {
+		pr_err("TDH_MNG_RD[EXEC.0x%x] failed: 0x%llx\n", field, err);
+		return 0;
+	}
+	return out.r8;
+}
+
 #else
 static inline int tdx_module_setup(void) { return -ENODEV; };
 
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index a9ea3573be1b..779dfd683d66 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -576,4 +577,36 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[0];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u32 max_vcpus;
+	__u32 tsc_khz;
+	__u64 mrconfigid[6];    /* sha384 digest */
+	__u64 mrowner[6];       /* sha384 digest */
+	__u64 mrownerconfig[6]; /* sha348 digest */
+	union {
+		/*
+		 * KVM_TDX_INIT_VM is called before vcpu creation, thus before
+		 * KVM_SET_CPUID2.  CPUID configurations needs to be passed.
+		 *
+		 * This configuration supersedes KVM_SET_CPUID{,2}.
+		 * The user space VMM, e.g. qemu, should make them consistent
+		 * with this values.
+		 * sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES(256)
+		 * = 8KB.
+		 */
+		struct {
+			struct kvm_cpuid2 cpuid;
+			/* 8KB with KVM_MAX_CPUID_ENTRIES. */
+			struct kvm_cpuid_entry2 entries[];
+		};
+		/*
+		 * For future extensibility.
+		 * The size(struct kvm_tdx_init_vm) = 16KB.
+		 * This should be enough given sizeof(TD_PARAMS) = 1024
+		 */
+		__u64 reserved[2028];
+	};
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

