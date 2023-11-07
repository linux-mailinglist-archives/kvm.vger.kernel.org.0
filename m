Return-Path: <kvm+bounces-974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 035627E42B0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25B7C1C210BD
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9993037166;
	Tue,  7 Nov 2023 15:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dnIti12u"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66E034CEC
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:04:51 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D0F61AB;
	Tue,  7 Nov 2023 07:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369323; x=1730905323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oYjyB0PKHYSQZ7RBGG3pOVL3nknQrbhawyzzlQAAUwo=;
  b=dnIti12upLw89vMfuSvQoHHittb4CtRzerfhEAcvmaxqbhkgoHbTwnEv
   y9uJ5v8jPa7SubCatn5njG8LHf8pMYGy4s+80xbus12IbBAQggLF5xLw9
   dDEkCprPIVfHpaWoJ+ANomOo4YtvLtSa509lLyh7ftu/VT9ZtO0qsoUkY
   tW9TgIt+tVjYb3gd5Wy8XdfxVJeitUwlgYYojj9uuReIlrP7fZtlvrNnN
   xot0XaAXt5LcshvSrJJo62MMAovib3zgeS1JdozczikV5VQW0+QoN7qNV
   2bol/20kd9YmoUIjC0PQP8mD0mqUgHp9WlU6b4ytEoTYzlWdUAnYEHR40
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462697"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462697"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851675"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:30 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 115/116] RFC: KVM: x86, TDX: Add check for KVM_SET_CPUID2
Date: Tue,  7 Nov 2023 06:57:21 -0800
Message-Id: <b7c4f923d3de75c324330ec75d0c46d56946ccb9.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/main.c    | 10 ++++++
 arch/x86/kvm/vmx/tdx.c     | 72 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h     |  7 ++++
 arch/x86/kvm/vmx/x86_ops.h |  4 +++
 4 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ba7557b6dc57..4abfb0c74d5b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -443,6 +443,15 @@ static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
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
@@ -1103,6 +1112,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.get_exit_info = vt_get_exit_info,
 
+	.vcpu_check_cpuid = vt_vcpu_check_cpuid,
 	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8c0291535a78..8b58d91bda4e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -514,6 +514,9 @@ void tdx_vm_free(struct kvm *kvm)
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
+
+	kfree(kvm_tdx->cpuid);
+	kvm_tdx->cpuid = NULL;
 }
 
 static int tdx_do_tdh_mng_key_config(void *param)
@@ -635,6 +638,44 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	const struct tdsysinfo_struct *tdsysinfo;
+	int i;
+
+	tdsysinfo = tdx_get_sysinfo();
+	if (!tdsysinfo)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Simple check that new cpuid is consistent with created one.
+	 * For simplicity, only trivial check.  Don't try comprehensive checks
+	 * with the cpuid virtualization table in the TDX module spec.
+	 */
+	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
+		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
+		u32 index = config->sub_leaf == TDX_CPUID_NO_SUBLEAF ? 0 : config->sub_leaf;
+		const struct kvm_cpuid_entry2 *old =
+			kvm_find_cpuid_entry2(kvm_tdx->cpuid, kvm_tdx->cpuid_nent,
+					      config->leaf, index);
+		const struct kvm_cpuid_entry2 *new = kvm_find_cpuid_entry2(e2, nent,
+									   config->leaf, index);
+
+		if (!!old != !!new)
+			return -EINVAL;
+		if (!old && !new)
+			continue;
+
+		if ((old->eax ^ new->eax) & config->eax ||
+		    (old->ebx ^ new->ebx) & config->ebx ||
+		    (old->ecx ^ new->ecx) & config->ecx ||
+		    (old->edx ^ new->edx) & config->edx)
+			return -EINVAL;
+	}
+	return 0;
+}
+
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -2196,10 +2237,12 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
 	return 0;
 }
 
-static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
+static void setup_tdparams_cpuids(struct kvm *kvm,
+				  const struct tdsysinfo_struct *tdsysinfo,
 				  struct kvm_cpuid2 *cpuid,
 				  struct td_params *td_params)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	int i;
 
 	/*
@@ -2207,6 +2250,7 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
 	 * It's assumed that td_params was zeroed.
 	 */
+	kvm_tdx->cpuid_nent = 0;
 	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
 		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
 		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
@@ -2229,6 +2273,10 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 		value->ebx = entry->ebx & config->ebx;
 		value->ecx = entry->ecx & config->ecx;
 		value->edx = entry->edx & config->edx;
+
+		/* Remember the setting to check for KVM_SET_CPUID2. */
+		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
+		kvm_tdx->cpuid_nent++;
 	}
 }
 
@@ -2316,7 +2364,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	ret = setup_tdparams_eptp_controls(cpuid, td_params);
 	if (ret)
 		return ret;
-	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
+	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
 	ret = setup_tdparams_xfam(cpuid, td_params);
 	if (ret)
 		return ret;
@@ -2531,11 +2579,18 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -2585,6 +2640,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
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
index 4ddcf804c0a4..54c3f6b83571 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -32,6 +32,13 @@ struct kvm_tdx {
 	atomic_t tdh_mem_track;
 
 	u64 tsc_offset;
+
+	/*
+	 * For KVM_SET_CPUID to check consistency. Remember the one passed to
+	 * TDH.MNG_INIT
+	 */
+	int cpuid_nent;
+	struct kvm_cpuid_entry2 *cpuid;
 };
 
 union tdx_exit_reason {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b063424c916d..ae94bde4736d 100644
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
@@ -214,6 +216,8 @@ static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				       int nent) { return -EOPNOTSUPP; }
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
-- 
2.25.1


