Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCA651C741
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383983AbiEESXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383194AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56711387BF;
        Thu,  5 May 2022 11:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774552; x=1683310552;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sMmfx1EyVq4pvElmqg1VAc6KGZfGRhiNY1BOEukxkwA=;
  b=R4f6DHN90i9Zm4NJHAP7XZGjdPwPWnRzOJuv60jHIwtKWbLbn5ZH+imk
   MQu6gQZsiZDHfkg/M6XJRxbBX6FaXYEaVxV+Elu7hADxwvpgnoY78/OSE
   M3m+Razf44+1aja5i/J2YxDULDmctkE14AvCw2uDtZqqBHwTjZgj/s7nH
   p5Jp9ZodC2e1sRCDOo+SrQJrC69kUuAoOEp493IlOqe1UpNwmZxJ88xRu
   gmygu+hGHyWNQEv/LKJYk5Hw8lyf6LFlfqsf6Vfwv5F1II9GLTAXsyPQ5
   9yZ083c8DqKqhjxdRxMvagGPQAMz9olOPXrjj1lSTVir+ZPm8k6Ojv0kG
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746258"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746258"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:43 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083210"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:43 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 025/104] KVM: TDX: initialize VM with TDX specific parameters
Date:   Thu,  5 May 2022 11:14:19 -0700
Message-Id: <fbc23565f7556e7b33227bcad95441195bb4758d.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 arch/x86/include/uapi/asm/kvm.h       |  33 +++++
 arch/x86/kvm/vmx/tdx.c                | 205 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  23 +++
 tools/arch/x86/include/uapi/asm/kvm.h |  33 +++++
 5 files changed, 296 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e6f6f8c8619f..bc2038157f11 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1250,6 +1250,8 @@ struct kvm_arch {
 	 * the global KVM_MAX_VCPU_IDS may lead to significant memory waste.
 	 */
 	u32 max_vcpu_ids;
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ca85a070ac19..0f067fe7c186 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -532,6 +532,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -577,4 +578,36 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[0];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u32 max_vcpus;
+	__u32 tsc_khz;
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
index a4be3ef313b2..095ca7952114 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -438,6 +438,208 @@ int tdx_dev_ioctl(void __user *argp)
 	return 0;
 }
 
+#define TDX_CPUID_NO_INDEX	((u32)-1)
+static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(
+	const struct kvm_tdx_init_vm *init_vm, u32 function, u32 index)
+{
+	int i;
+
+	for (i = 0; i < init_vm->cpuid.nent; i++) {
+		const struct kvm_cpuid_entry2 *e = &init_vm->entries[i];
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
+	const struct kvm_cpuid_entry2 *entry;
+	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	u32 guest_tsc_khz;
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
+			tdx_find_cpuid_entry(init_vm, config->leaf, config->sub_leaf);
+		struct tdx_cpuid_value *value = &td_params->cpuid_values[i];
+
+		value->eax = entry->eax & config->eax;
+		value->ebx = entry->ebx & config->ebx;
+		value->ecx = entry->ecx & config->ecx;
+		value->edx = entry->edx & config->edx;
+	}
+
+	max_pa = 36;
+	entry = tdx_find_cpuid_entry(init_vm, 0x80000008, TDX_CPUID_NO_INDEX);
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
+	entry = tdx_find_cpuid_entry(init_vm, 0xd, 0);
+	if (entry)
+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
+	else
+		guest_supported_xcr0 = 0;
+	guest_supported_xcr0 &= supported_xcr0;
+
+	entry = tdx_find_cpuid_entry(init_vm, 0xd, 1);
+	if (entry)
+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
+	else
+		guest_supported_xss = 0;
+	/* PT can be exposed to TD guest regardless of KVM's XSS support */
+	guest_supported_xss &= (supported_xss | XFEATURE_MASK_PT);
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
+	if (init_vm->tsc_khz) {
+		guest_tsc_khz = init_vm->tsc_khz;
+		kvm->arch.default_tsc_khz = guest_tsc_khz;
+	} else
+		guest_tsc_khz = kvm->arch.default_tsc_khz;
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(guest_tsc_khz);
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
+	if (tdx_caps.nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
+		/* tdx_caps.nr_cpuis_configs should be smaller. */
+		pr_warn("too large nr_cpuid_configs\n");
+		ret = -E2BIG;
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
@@ -451,6 +653,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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

