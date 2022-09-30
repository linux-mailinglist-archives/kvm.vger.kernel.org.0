Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5EA5F0869
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiI3KTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiI3KS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D20115348B;
        Fri, 30 Sep 2022 03:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533137; x=1696069137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6y6xOgs7TCl0jfpxcnUHUePcgygxURjfP3rOvBTb/p8=;
  b=Y3pkty9E/fI/wtUu3TXRab/zmc1hlCR1joEDZA9BrTFJ7XFyCsFDR15h
   dZyAh+WMUSNorrh9cev2vXtRV7uremkBQFOSelB8yj45zNoPqTAsmypc/
   OryKN7fExEuWfqM9S2ci1YjFeDDaZYAZBbiohPftMxsoYxtR19ZNnrCqn
   LFx8A6wNH09fUkRlzYI8Xap2kLC+ewrP/wsGhjqHostGUyyn8C2gZeD3+
   YdPvYRQ+qc/bnLeSTNflwYwmXyuIOe8Srju+vDyEqMqd4k8zFCtu/ZHFZ
   Z3amr3UW/49qOWFjloXDoKEF3hXl1wx7GRvLi0BS3pls3fkmiI6LWPw2V
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870072"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870072"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807568"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807568"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 020/105] KVM: TDX: initialize VM with TDX specific parameters
Date:   Fri, 30 Sep 2022 03:17:14 -0700
Message-Id: <cbbf0df3758b41c82eb3fe638b0bf0d5124834f6.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/include/asm/tdx.h            |   3 +
 arch/x86/include/uapi/asm/kvm.h       |  33 +++
 arch/x86/kvm/vmx/tdx.c                | 303 ++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h                |  22 ++
 tools/arch/x86/include/uapi/asm/kvm.h |  33 +++
 5 files changed, 353 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a32e8881e758..8a1905ae3ad6 100644
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
index 2ad9666e02a5..e231ba752788 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -583,4 +584,36 @@ struct kvm_tdx_capabilities {
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
index 76e00e9bfe91..3c16f2d535b1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -272,12 +272,209 @@ static int tdx_do_tdh_mng_key_config(void *param)
 int tdx_vm_init(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	cpumask_var_t packages;
-	int ret, i;
-	u64 err;
 
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
+	kvm_tdx->hkid = -1;
+
+	/*
+	 * This function initializes only KVM software construct.  It doesn't
+	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.
+	 * It is handled by KVM_TDX_INIT_VM, __tdx_td_init().
+	 */
+
+	return 0;
+}
+
+int tdx_dev_ioctl(void __user *argp)
+{
+	struct kvm_tdx_capabilities __user *user_caps;
+	struct kvm_tdx_capabilities caps;
+	struct kvm_tdx_cmd cmd;
+
+	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
+		     sizeof(struct tdx_cpuid_config));
+
+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
+		return -EFAULT;
+	if (cmd.flags || cmd.error || cmd.unused)
+		return -EINVAL;
+	/*
+	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
+	 * mem_enc_ioctl().
+	 */
+	if (cmd.id != KVM_TDX_CAPABILITIES)
+		return -EINVAL;
+
+	user_caps = (void __user *)cmd.data;
+	if (copy_from_user(&caps, user_caps, sizeof(caps)))
+		return -EFAULT;
+
+	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
+		return -E2BIG;
+
+	caps = (struct kvm_tdx_capabilities) {
+		.attrs_fixed0 = tdx_caps.attrs_fixed0,
+		.attrs_fixed1 = tdx_caps.attrs_fixed1,
+		.xfam_fixed0 = tdx_caps.xfam_fixed0,
+		.xfam_fixed1 = tdx_caps.xfam_fixed1,
+		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
+		.padding = 0,
+	};
+
+	if (copy_to_user(user_caps, &caps, sizeof(caps)))
+		return -EFAULT;
+	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
+			 tdx_caps.nr_cpuid_configs *
+			 sizeof(struct tdx_cpuid_config)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/*
+ * cpuid entry lookup in TDX cpuid config way.
+ * The difference is how to specify index(subleaves).
+ * Specify index to TDX_CPUID_NO_SUBLEAF for CPUID leaf with no-subleaves.
+ */
+static const struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(const struct kvm_cpuid2 *cpuid,
+							   u32 function, u32 index)
+{
+	int i;
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
+static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_module_output out;
+	cpumask_var_t packages;
+	int ret, i;
+	u64 err;
 
 	kvm_tdx->hkid = tdx_keyid_alloc();
 	if (kvm_tdx->hkid < 0)
@@ -381,10 +578,13 @@ int tdx_vm_init(struct kvm *kvm)
 		tdx_mark_td_page_added(&kvm_tdx->tdcs[i]);
 	}
 
-	/*
-	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
-	 * ioctl() to define the configure CPUID values for the TD.
-	 */
+	err = tdh_mng_init(kvm_tdx->tdr.pa, __pa(td_params), &out);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_INIT, err, &out);
+		ret = -EIO;
+		goto teardown;
+	}
+
 	return 0;
 
 	/*
@@ -429,50 +629,68 @@ int tdx_vm_init(struct kvm *kvm)
 	return ret;
 }
 
-int tdx_dev_ioctl(void __user *argp)
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 {
-	struct kvm_tdx_capabilities __user *user_caps;
-	struct kvm_tdx_capabilities caps;
-	struct kvm_tdx_cmd cmd;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_tdx_init_vm *init_vm = NULL;
+	struct td_params *td_params = NULL;
+	void *entries_end;
+	int ret;
 
-	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
-		     sizeof(struct tdx_cpuid_config));
+	BUILD_BUG_ON(sizeof(*init_vm) != 16 * 1024);
+	BUILD_BUG_ON((sizeof(*init_vm) - offsetof(typeof(*init_vm), entries)) /
+		     sizeof(init_vm->entries[0]) < KVM_MAX_CPUID_ENTRIES);
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
 
-	if (copy_from_user(&cmd, argp, sizeof(cmd)))
-		return -EFAULT;
-	if (cmd.flags || cmd.error || cmd.unused)
+	if (is_td_initialized(kvm))
 		return -EINVAL;
-	/*
-	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
-	 * mem_enc_ioctl().
-	 */
-	if (cmd.id != KVM_TDX_CAPABILITIES)
+
+	if (cmd->flags)
 		return -EINVAL;
 
-	user_caps = (void __user *)cmd.data;
-	if (copy_from_user(&caps, user_caps, sizeof(caps)))
-		return -EFAULT;
+	init_vm = kzalloc(sizeof(*init_vm), GFP_KERNEL);
+	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
+		ret = -EFAULT;
+		goto out;
+	}
 
-	if (caps.nr_cpuid_configs < tdx_caps.nr_cpuid_configs)
-		return -E2BIG;
+	ret = -EINVAL;
+	if (init_vm->cpuid.padding)
+		goto out;
+	/* init_vm->entries shouldn't overrun. */
+	entries_end = init_vm->entries + init_vm->cpuid.nent;
+	if (entries_end > (void *)(init_vm + 1))
+		goto out;
+	/* Unused part must be zero. */
+	if (memchr_inv(entries_end, 0, (void *)(init_vm + 1) - entries_end))
+		goto out;
+	if (init_vm->max_vcpus > KVM_MAX_VCPUS)
+		goto out;
 
-	caps = (struct kvm_tdx_capabilities) {
-		.attrs_fixed0 = tdx_caps.attrs_fixed0,
-		.attrs_fixed1 = tdx_caps.attrs_fixed1,
-		.xfam_fixed0 = tdx_caps.xfam_fixed0,
-		.xfam_fixed1 = tdx_caps.xfam_fixed1,
-		.nr_cpuid_configs = tdx_caps.nr_cpuid_configs,
-		.padding = 0,
-	};
+	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL);
+	if (!td_params) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
-	if (copy_to_user(user_caps, &caps, sizeof(caps)))
-		return -EFAULT;
-	if (copy_to_user(user_caps->cpuid_configs, &tdx_caps.cpuid_configs,
-			 tdx_caps.nr_cpuid_configs *
-			 sizeof(struct tdx_cpuid_config)))
-		return -EFAULT;
+	ret = setup_tdparams(kvm, td_params, init_vm);
+	if (ret)
+		goto out;
 
-	return 0;
+	ret = __tdx_td_init(kvm, td_params);
+	if (ret)
+		goto out;
+
+	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
+	kvm_tdx->attributes = td_params->attributes;
+	kvm_tdx->xfam = td_params->xfam;
+	kvm->max_vcpus = td_params->max_vcpus;
+
+out:
+	/* kfree() accepts NULL. */
+	kfree(init_vm);
+	kfree(td_params);
+	return ret;
 }
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
@@ -488,6 +706,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 938314635b47..b87b62ba2575 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -18,7 +18,11 @@ struct kvm_tdx {
 	struct tdx_td_page tdr;
 	struct tdx_td_page *tdcs;
 
+	u64 attributes;
+	u64 xfam;
 	int hkid;
+
+	u64 tsc_offset;
 };
 
 struct vcpu_tdx {
@@ -48,6 +52,11 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_tdx, vcpu);
 }
 
+static inline bool is_td_initialized(struct kvm *kvm)
+{
+	return !!kvm->max_vcpus;
+}
+
 static __always_inline void tdvps_vmcs_check(u32 field, u8 bits)
 {
 #define VMCS_ENC_ACCESS_TYPE_MASK	0x1UL
@@ -148,6 +157,19 @@ TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
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
 struct kvm_tdx {
 	struct kvm kvm;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 2ad9666e02a5..531a0033e530 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -538,6 +538,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -583,4 +584,36 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[0];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u32 max_vcpus;
+	__u32 padding;
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

