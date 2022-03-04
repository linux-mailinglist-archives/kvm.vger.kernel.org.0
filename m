Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2984CDDD3
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiCDUHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiCDUHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:33 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53482D14C9;
        Fri,  4 Mar 2022 12:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424110; x=1677960110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YTvnaeDkFjwl6F9Cnst4RruHw8Tvaa0q9fXMYXtRZCQ=;
  b=ljp17sWElaVWcsoUxLlGIgRn5rUkJCFlN81+xliNh1Lvbz3weGqE0cty
   DPl5qBfI5ZbpZV1ADXeIa8o9PfaktN0cvaB2GuqoBp5tD+zKZ26ZZJt/J
   L/WbFXJRnh5Akpf1k1VpYe0pWt7PXMHmw249Pu7+GzLOT5EBLz9lsUu+w
   PCLg8AAtIUD4Y9cn9npiaNDrilG42wMURliIdJSDtCNZhVpgGspa5TXza
   5YssV2Vx4ECPnQCR5rHhITvFGD5ZrB5imXhnnRURsu9PEE1nhksxwgt3B
   ZkEmiUIiOiLxv7JlZY1srj7/+lbFaETN5TeUrR4FYtxGI4jS2gA5EZ3gc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983416"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983416"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:15 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344269"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:15 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific parameters
Date:   Fri,  4 Mar 2022 11:48:43 -0800
Message-Id: <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
encrypts memory per-guest bases.  It assigns Device model passes per-VM
parameters for the TDX guest.  The maximum number of vcpus, tsc frequency
(TDX guest has fised VM-wide TSC frequency. not per-vcpu.  The TDX guest
can not change it.), attributes (production or debug), available extended
features (which is reflected into guest XCR0, IA32_XSS MSR), cpuids, sha384
measurements, and etc.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h       |   2 +
 arch/x86/include/uapi/asm/kvm.h       |  12 ++
 arch/x86/kvm/vmx/tdx.c                | 200 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h                |  26 ++++
 arch/x86/kvm/x86.c                    |   3 +-
 arch/x86/kvm/x86.h                    |   2 +
 tools/arch/x86/include/uapi/asm/kvm.h |  12 ++
 7 files changed, 256 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ff7a0fba311..290e200f012c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1234,6 +1234,8 @@ struct kvm_arch {
 	hpa_t	hv_root_tdp;
 	spinlock_t hv_root_tdp_lock;
 #endif
+
+	gfn_t gfn_shared_mask;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 70f9be4ea575..6e26dde0dce6 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -561,4 +562,15 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[0];
 };
 
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 tsc_khz;
+	__u64 attributes;
+	__u64 cpuid;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha348 digest */
+	__u64 reserved[43];	/* must be zero for future extensibility */
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 20b45bb0b032..236faaca68a0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -387,6 +387,203 @@ static int tdx_capabilities(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	return 0;
 }
 
+static struct kvm_cpuid_entry2 *tdx_find_cpuid_entry(struct kvm_tdx *kvm_tdx,
+						u32 function, u32 index)
+{
+	struct kvm_cpuid_entry2 *e;
+	int i;
+
+	for (i = 0; i < kvm_tdx->cpuid_nent; i++) {
+		e = &kvm_tdx->cpuid_entries[i];
+
+		if (e->function == function && (e->index == index ||
+		    !(e->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX)))
+			return e;
+	}
+	return NULL;
+}
+
+static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
+			struct kvm_tdx_init_vm *init_vm)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_cpuid_config *config;
+	struct kvm_cpuid_entry2 *entry;
+	struct tdx_cpuid_value *value;
+	u64 guest_supported_xcr0;
+	u64 guest_supported_xss;
+	u32 guest_tsc_khz;
+	int max_pa;
+	int i;
+
+	/* init_vm->reserved must be zero */
+	if (find_first_bit((unsigned long *)init_vm->reserved,
+			   sizeof(init_vm->reserved) * 8) !=
+	    sizeof(init_vm->reserved) * 8)
+		return -EINVAL;
+
+	td_params->max_vcpus = init_vm->max_vcpus;
+
+	td_params->attributes = init_vm->attributes;
+	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
+		pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
+			"host perf registers properly.\n");
+		return -EOPNOTSUPP;
+	}
+
+	/* TODO: Enforce consistent CPUID features for all vCPUs. */
+	for (i = 0; i < tdx_caps.nr_cpuid_configs; i++) {
+		config = &tdx_caps.cpuid_configs[i];
+
+		entry = tdx_find_cpuid_entry(kvm_tdx, config->leaf,
+					     config->sub_leaf);
+		if (!entry)
+			continue;
+
+		/*
+		 * Non-configurable bits must be '0', even if they are fixed to
+		 * '1' by the TDX module, i.e. mask off non-configurable bits.
+		 */
+		value = &td_params->cpuid_values[i];
+		value->eax = entry->eax & config->eax;
+		value->ebx = entry->ebx & config->ebx;
+		value->ecx = entry->ecx & config->ecx;
+		value->edx = entry->edx & config->edx;
+	}
+
+	max_pa = 36;
+	entry = tdx_find_cpuid_entry(kvm_tdx, 0x80000008, 0);
+	if (entry)
+		max_pa = entry->eax & 0xff;
+
+	td_params->eptp_controls = VMX_EPTP_MT_WB;
+	if (cpu_has_vmx_ept_5levels() && max_pa > 48) {
+		td_params->eptp_controls |= VMX_EPTP_PWL_5;
+		td_params->exec_controls |= TDX_EXEC_CONTROL_MAX_GPAW;
+	} else {
+		td_params->eptp_controls |= VMX_EPTP_PWL_4;
+	}
+
+	/* Setup td_params.xfam */
+	entry = tdx_find_cpuid_entry(kvm_tdx, 0xd, 0);
+	if (entry)
+		guest_supported_xcr0 = (entry->eax | ((u64)entry->edx << 32));
+	else
+		guest_supported_xcr0 = 0;
+	guest_supported_xcr0 &= supported_xcr0;
+
+	entry = tdx_find_cpuid_entry(kvm_tdx, 0xd, 1);
+	if (entry)
+		guest_supported_xss = (entry->ecx | ((u64)entry->edx << 32));
+	else
+		guest_supported_xss = 0;
+	/* PT can be exposed to TD guest regardless of KVM's XSS support */
+	guest_supported_xss &= (supported_xss | XFEATURE_MASK_PT);
+
+	td_params->xfam = guest_supported_xcr0 | guest_supported_xss;
+	if (td_params->xfam & TDX_TD_XFAM_LBR) {
+		pr_warn("TD doesn't support LBR. KVM needs to save/restore "
+			"IA32_LBR_DEPTH properly.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (td_params->xfam & TDX_TD_XFAM_AMX) {
+		pr_warn("TD doesn't support AMX. KVM needs to save/restore "
+			"IA32_XFD, IA32_XFD_ERR properly.\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (init_vm->tsc_khz)
+		guest_tsc_khz = init_vm->tsc_khz;
+	else
+		guest_tsc_khz = max_tsc_khz;
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(guest_tsc_khz);
+
+#define BUILD_BUG_ON_MEMCPY(dst, src)				\
+	do {							\
+		BUILD_BUG_ON(sizeof(dst) != sizeof(src));	\
+		memcpy((dst), (src), sizeof(dst));		\
+	} while (0)
+
+	BUILD_BUG_ON_MEMCPY(td_params->mrconfigid, init_vm->mrconfigid);
+	BUILD_BUG_ON_MEMCPY(td_params->mrowner, init_vm->mrowner);
+	BUILD_BUG_ON_MEMCPY(td_params->mrownerconfig, init_vm->mrownerconfig);
+
+	return 0;
+}
+
+static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct kvm_cpuid2 __user *user_cpuid;
+	struct kvm_tdx_init_vm init_vm;
+	struct td_params *td_params;
+	struct tdx_module_output out;
+	struct kvm_cpuid2 cpuid;
+	int ret;
+	u64 err;
+
+	BUILD_BUG_ON(sizeof(init_vm) != 512);
+	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
+
+	if (is_td_initialized(kvm))
+		return -EINVAL;
+
+	if (cmd->metadata)
+		return -EINVAL;
+
+	if (copy_from_user(&init_vm, (void __user *)cmd->data, sizeof(init_vm)))
+		return -EFAULT;
+
+	if (init_vm.max_vcpus > KVM_MAX_VCPUS)
+		return -EINVAL;
+
+	user_cpuid = (void *)init_vm.cpuid;
+	if (copy_from_user(&cpuid, user_cpuid, sizeof(cpuid)))
+		return -EFAULT;
+
+	if (cpuid.nent > KVM_MAX_CPUID_ENTRIES)
+		return -E2BIG;
+
+	if (copy_from_user(&kvm_tdx->cpuid_entries, user_cpuid->entries,
+			   cpuid.nent * sizeof(struct kvm_cpuid_entry2)))
+		return -EFAULT;
+
+	td_params = kzalloc(sizeof(struct td_params), GFP_KERNEL_ACCOUNT);
+	if (!td_params)
+		return -ENOMEM;
+
+	kvm_tdx->cpuid_nent = cpuid.nent;
+
+	ret = setup_tdparams(kvm, td_params, &init_vm);
+	if (ret)
+		goto free_tdparams;
+
+	err = tdh_mng_init(kvm_tdx->tdr.pa, __pa(td_params), &out);
+	if (WARN_ON_ONCE(err)) {
+		pr_tdx_error(TDH_MNG_INIT, err, &out);
+		ret = -EIO;
+		goto free_tdparams;
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
+free_tdparams:
+	kfree(td_params);
+	if (ret)
+		kvm_tdx->cpuid_nent = 0;
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -401,6 +598,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	case KVM_TDX_CAPABILITIES:
 		r = tdx_capabilities(kvm, &tdx_cmd);
 		break;
+	case KVM_TDX_INIT_VM:
+		r = tdx_td_init(kvm, &tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 860136ed70f5..f116c40ac319 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -20,7 +20,15 @@ struct kvm_tdx {
 	struct tdx_td_page tdr;
 	struct tdx_td_page *tdcs;
 
+	u64 attributes;
+	u64 xfam;
 	int hkid;
+
+	int cpuid_nent;
+	struct kvm_cpuid_entry2 cpuid_entries[KVM_MAX_CPUID_ENTRIES];
+
+	u64 tsc_offset;
+	unsigned long tsc_khz;
 };
 
 struct vcpu_tdx {
@@ -50,6 +58,11 @@ static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
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
@@ -135,6 +148,19 @@ TDX_BUILD_TDVPS_ACCESSORS(64, VMCS, vmcs);
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
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a48f5c69fadb..734699bd940f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2274,7 +2274,8 @@ static atomic_t kvm_guest_has_master_clock = ATOMIC_INIT(0);
 #endif
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
-static unsigned long max_tsc_khz;
+unsigned long max_tsc_khz;
+EXPORT_SYMBOL_GPL(max_tsc_khz);
 
 static u32 adjust_tsc_khz(u32 khz, s32 ppm)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f11d945ac41f..5ff3badc3f2b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -302,6 +302,8 @@ extern int pi_inject_timer;
 
 extern bool report_ignored_msrs;
 
+extern unsigned long max_tsc_khz;
+
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
 	return pvclock_scale_delta(nsec, vcpu->arch.virtual_tsc_mult,
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 70f9be4ea575..6e26dde0dce6 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -531,6 +531,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -561,4 +562,15 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[0];
 };
 
+struct kvm_tdx_init_vm {
+	__u32 max_vcpus;
+	__u32 tsc_khz;
+	__u64 attributes;
+	__u64 cpuid;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha348 digest */
+	__u64 reserved[43];	/* must be zero for future extensibility */
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

