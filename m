Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1041E7625EE
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjGYWQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjGYWQI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:08 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39DC2685;
        Tue, 25 Jul 2023 15:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323345; x=1721859345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m9QLwYt1HBfAN8/8K2Uxblrc7k83cU402kZebHWmJuo=;
  b=AVxxmKeiBZwk93ikrbCaCLkwWM2PLrTd0UqJW9GderaqsMRTZWJi2Ioj
   4/XIwKyz4kTm9Xheps8VIK7L/aRBfPVil6Tk4ujoayWK3MeVkR6HAw8kj
   1qol3vfEvjL8uPbx4iafxpui94gHT3G/1a0kNxL8thTAHsnUUYPRLE3F3
   5VY97Dv4HF3juodIfRnvJjtBjfZfMg9d8pfmeySF6W0nXuJwrkIpKgzUp
   8LL6MPR0TADBPJoTbZOR0qWN1h6CXFSJLy8jp8XESWfjhTokpjm9M0DAM
   VSajHoBOKBQ99IF2srKzBYUNBygIV2egAPL4C9pw/HUDSNG6dzY0Y8hkh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863141"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863141"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938834"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938834"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:23 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v15 021/115] KVM: TDX: initialize VM with TDX specific parameters
Date:   Tue, 25 Jul 2023 15:13:32 -0700
Message-Id: <4819838d73f33f4f9d4028df408bf23aab57e064.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
v14 -> v15:
- add check if the reserved area of init_vm is zero

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h            |   3 +
 arch/x86/include/uapi/asm/kvm.h       |  27 +++
 arch/x86/kvm/cpuid.c                  |   7 +
 arch/x86/kvm/cpuid.h                  |   2 +
 arch/x86/kvm/vmx/tdx.c                | 271 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx/tdx.h                |  18 ++
 tools/arch/x86/include/uapi/asm/kvm.h |  33 ++++
 7 files changed, 351 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 86517add595f..97b23325ba5e 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -85,6 +85,9 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
 
 #ifdef CONFIG_INTEL_TDX_HOST
+
+/* -1 indicates CPUID leaf with no sub-leaves. */
+#define TDX_CPUID_NO_SUBLEAF	((u32)-1)
 struct tdx_cpuid_config {
 	__struct_group(tdx_cpuid_config_leaf, leaf_sub_leaf, __packed,
 		u32 leaf;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3fbd43d5177b..7112546bd1d0 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -570,6 +570,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -617,4 +618,30 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[];
 };
 
+struct kvm_tdx_init_vm {
+	__u64 attributes;
+	__u64 mrconfigid[6];	/* sha384 digest */
+	__u64 mrowner[6];	/* sha384 digest */
+	__u64 mrownerconfig[6];	/* sha348 digest */
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
index 7f4d13383cf2..09b83f7c228d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1385,6 +1385,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
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
index b1658c0de847..6d94d852af9d 100644
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
index af8c92f24f0f..eb94572631aa 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,7 +7,6 @@
 #include "x86_ops.h"
 #include "mmu.h"
 #include "tdx.h"
-#include "tdx_ops.h"
 #include "x86.h"
 
 #undef pr_fmt
@@ -298,18 +297,21 @@ static int tdx_do_tdh_mng_key_config(void *param)
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
@@ -372,9 +374,171 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
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
+static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
+				  struct kvm_cpuid2 *cpuid,
+				  struct td_params *td_params)
+{
+	int i;
+
+	/*
+	 * td_params.cpuid_values: The number and the order of cpuid_value must
+	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
+	 * It's assumed that td_params was zeroed.
+	 */
+	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
+		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
+		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
+		u32 index = config->sub_leaf == TDX_CPUID_NO_SUBLEAF ? 0 : config->sub_leaf;
+		const struct kvm_cpuid_entry2 *entry =
+			kvm_find_cpuid_entry2(cpuid->entries, cpuid->nent,
+					      config->leaf, index);
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
+		value->eax = entry->eax & config->eax;
+		value->ebx = entry->ebx & config->ebx;
+		value->ecx = entry->ecx & config->ecx;
+		value->edx = entry->edx & config->edx;
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
+	/* PT can be exposed to TD guest regardless of KVM's XSS support */
+	guest_supported_xss &= (kvm_caps.supported_xss | XFEATURE_MASK_PT);
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
+	if (td_params->xfam & XFEATURE_MASK_XTILE) {
+		/*
+		 * TODO: once KVM supports AMX(save/restore AMX related
+		 * registers around TDENTER), remove this guard.
+		 */
+#define MSG_AMX	"TD doesn't support AMX yet. KVM needs to save/restore IA32_XFD, IA32_XFD_ERR properly.\n"
+		pr_warn(MSG_AMX);
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
+	const struct tdsysinfo_struct *tdsysinfo;
+	int ret;
+
+	tdsysinfo = tdx_get_sysinfo();
+	if (!tdsysinfo)
+		return -EOPNOTSUPP;
+	if (kvm->created_vcpus)
+		return -EBUSY;
+
+	if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
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
+	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
+
+	ret = setup_tdparams_eptp_controls(cpuid, td_params);
+	if (ret)
+		return ret;
+	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
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
+	struct tdx_module_output out;
 	cpumask_var_t packages;
 	unsigned long *tdcs_pa = NULL;
 	unsigned long tdr_pa = 0;
@@ -382,6 +546,7 @@ static int __tdx_td_init(struct kvm *kvm)
 	int ret, i;
 	u64 err;
 
+	*seamcall_err = 0;
 	ret = tdx_guest_keyid_alloc();
 	if (ret < 0)
 		return ret;
@@ -487,10 +652,23 @@ static int __tdx_td_init(struct kvm *kvm)
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
@@ -533,6 +711,76 @@ static int __tdx_td_init(struct kvm *kvm)
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
+			   sizeof(init_vm->cpuid.entries[0]) * init_vm->cpuid.nent)) {
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
@@ -549,6 +797,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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
index ae117f864cfb..646989eac5e3 100644
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
+	struct tdx_module_output out;
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
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 7a08723e99e2..61ce7d174fcf 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -565,6 +565,7 @@ struct kvm_pmu_event_filter {
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
 	KVM_TDX_CAPABILITIES = 0,
+	KVM_TDX_INIT_VM,
 
 	KVM_TDX_CMD_NR_MAX,
 };
@@ -614,4 +615,36 @@ struct kvm_tdx_capabilities {
 	struct kvm_tdx_cpuid_config cpuid_configs[];
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

