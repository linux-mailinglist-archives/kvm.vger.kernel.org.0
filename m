Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322A5714353
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjE2EeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjE2E3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C5019AD;
        Sun, 28 May 2023 21:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334337; x=1716870337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KeDHMRY40WNvNa6jkJtZMquR7u79CgsLN9fPYFjeqKg=;
  b=eCft6UjAt3ts33DURswDDstgWGRrbSlpDcNsaMmTx3ZDmk51oXCy4cYF
   lbEwUjOCWpYPwL0Sq8HxIm/yRv+kix4DLWRLy6XhiromkI6C4vqM3o5OO
   VjldzIdddOozg9aKp5TxpQ3AI7XeQUVCZhfg08DOz9oQ6krgscrveUd7O
   SKC50W5joV7VUpOqQyUPR8v7m0iZmWoG1+BEYxAgvRmOQBU43n02T21fb
   n/M/QSW45HFys9cShtAK1FuhBHeF3R7LwtISQIf/w3k/Zoq5RiZ3fPXsP
   DbYHKvbeb57rSoTcpRloRS6/aVol3n/x8QmD5UZxiLaLwxl4EE6ZB9ZOS
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="356993563"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="356993563"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="830223636"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="830223636"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 111/113] RFC: KVM: x86, TDX: Add check for setting CPUID
Date:   Sun, 28 May 2023 21:20:33 -0700
Message-Id: <00f3770050fb0751273a48eb17804a7a1a697e75.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a hook to setting CPUID for additional consistency check of
KVM_SET_CPUID2.

Because intel TDX or AMD SNP has restriction on the value of cpuid.  Some
value can't be changed after boot.  Some can be only set at the VM
creation time and can't be changed later.  Check if the new values are
consistent with the old values.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/cpuid.c               | 10 ++++++
 arch/x86/kvm/cpuid.h               |  2 ++
 arch/x86/kvm/vmx/main.c            | 10 ++++++
 arch/x86/kvm/vmx/tdx.c             | 57 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h             |  7 ++++
 arch/x86/kvm/vmx/x86_ops.h         |  4 +++
 8 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c1a4d29cf4fa..5faa13a31f59 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
 KVM_X86_OP(has_emulated_msr)
+KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP_OPTIONAL(max_vcpus);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 68ddb0da31e0..4efd9770963c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1588,6 +1588,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
+	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0142a73034c4..ef7c361883d7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -414,6 +414,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	}
 
 	r = kvm_check_cpuid(vcpu, e2, nent);
+	if (r)
+		return r;
+	r = static_call(kvm_x86_vcpu_check_cpuid)(vcpu, e2, nent);
 	if (r)
 		return r;
 
@@ -1364,6 +1367,13 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
 	return r;
 }
 
+struct kvm_cpuid_entry2 *__kvm_find_cpuid_entry2(
+	struct kvm_cpuid_entry2 *entries, int nent, u32 function, u64 index)
+{
+	return cpuid_entry2_find(entries, nent, function, index);
+}
+EXPORT_SYMBOL_GPL(__kvm_find_cpuid_entry2);
+
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2( struct kvm_cpuid2 *cpuid,
 						u32 function, u32 index)
 {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index a0e799297629..579675dcbbae 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,6 +13,8 @@ void kvm_set_cpu_caps(void);
 
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu);
+struct kvm_cpuid_entry2 *__kvm_find_cpuid_entry2(struct kvm_cpuid_entry2 *entries,
+						 int nent, u32 function, u64 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry2(struct kvm_cpuid2 *cpuid,
 					       u32 function, u32 index);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry_index(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index de8d8c70605b..cfc7fa87a8fe 100644
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
@@ -1087,6 +1096,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.get_exit_info = vt_get_exit_info,
 
+	.vcpu_check_cpuid = vt_vcpu_check_cpuid,
 	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ede3b9f98243..12d6c9cacf6a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -491,6 +491,9 @@ void tdx_vm_free(struct kvm *kvm)
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
+
+	kfree(kvm_tdx->cpuid);
+	kvm_tdx->cpuid = NULL;
 }
 
 static int tdx_do_tdh_mng_key_config(void *param)
@@ -608,6 +611,44 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
+		return -ENOTSUPP;
+
+	/*
+	 * Simple check that new cpuid is consistent with created one.
+	 * For simplicity, only trivial check.  Don't try comprehensive checks
+	 * with the cpuid virtualization table in the TDX module spec.
+	 */
+	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
+		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
+		u32 index = config->sub_leaf == TDX_CPUID_NO_SUBLEAF ? 0: config->sub_leaf;
+		const struct kvm_cpuid_entry2 *old =
+			__kvm_find_cpuid_entry2(kvm_tdx->cpuid, kvm_tdx->cpuid_nent,
+						config->leaf, index);
+		const struct kvm_cpuid_entry2 *new =
+			__kvm_find_cpuid_entry2(e2, nent, config->leaf, index);
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
@@ -2003,10 +2044,12 @@ static void setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid, struct td_par
 	}
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
@@ -2014,6 +2057,7 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
 	 * It's assumed that td_params was zeroed.
 	 */
+	kvm_tdx->cpuid_nent = 0;
 	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
 		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
 		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
@@ -2035,6 +2079,10 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 		value->ebx = entry->ebx & config->ebx;
 		value->ecx = entry->ecx & config->ecx;
 		value->edx = entry->edx & config->edx;
+
+		/* Remember the setting to check for KVM_SET_CPUID2. */
+		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
+		kvm_tdx->cpuid_nent++;
 	}
 }
 
@@ -2130,7 +2178,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	td_params->tsc_frequency = TDX_TSC_KHZ_TO_25MHZ(kvm->arch.default_tsc_khz);
 
 	setup_tdparams_eptp_controls(cpuid, td_params);
-	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
+	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
 	ret = setup_tdparams_xfam(cpuid, td_params);
 	if (ret)
 		return ret;
@@ -2332,6 +2380,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	if (cmd->flags)
 		return -EINVAL;
 
+	kvm_tdx->cpuid = kzalloc(sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
+				 GFP_KERNEL);
+	if (!kvm_tdx->cpuid)
+		return -ENOMEM;
+
 	init_vm = kzalloc(sizeof(*init_vm) +
 			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
 			  GFP_KERNEL);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ff35cd8409d9..846700a9c698 100644
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
index b339be6b5300..e2f44f754609 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -163,6 +163,8 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
+int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+			 int nent);
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
@@ -211,6 +213,8 @@ static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				       int nent) { return -EOPNOTSUPP; }
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
-- 
2.25.1

