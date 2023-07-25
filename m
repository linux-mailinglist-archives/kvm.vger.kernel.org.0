Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD437626A7
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjGYWZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbjGYWXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A342707;
        Tue, 25 Jul 2023 15:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323570; x=1721859570;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6xxNYR8lmUaKCKOtRckHc9gTmBpZfe4Z0/GM6xw9K5A=;
  b=gxG0rh1Wvoeo56W7+ElPqxGwi+/qrtU6RCN9LSvu7QWgVjYgLzEPXRdo
   P9dL2koQatP760h8jLW4mRNIkLa4Ia+bsBKfv0jkIMjRn80Oulv9Vo9qb
   PK9cI9kg71VLm3JEqFPMuMLcf9fl0HIiJ7WtGVB+W8UDmNeg0ozm/QG8c
   sUjedD9u8xuAXAIc6lmCb3kh5MxvIm3jYXEJX6+8+vHkF8IaAW+a/oyT0
   GiYDZf8ZhYTqMMS53W9JGgUgDztpvy+/fODBD7/UVWAQSHO09YJQex2cp
   psIHgVgMzWd+jHYMBGyRWDoA3fLPvjzzbwlta/Ys1H9GvmcsqVV+IR91G
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882806"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882806"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001981"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001981"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 114/115] RFC: KVM: x86, TDX: Add check for KVM_SET_CPUID2
Date:   Tue, 25 Jul 2023 15:15:05 -0700
Message-Id: <f2db027fe4be9c5953d26e99a8520ceeee8454ea.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 arch/x86/kvm/vmx/tdx.c     | 69 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.h     |  7 ++++
 arch/x86/kvm/vmx/x86_ops.h |  4 +++
 4 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index e148d871b0a6..96823f018e60 100644
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
@@ -1085,6 +1094,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.get_exit_info = vt_get_exit_info,
 
+	.vcpu_check_cpuid = vt_vcpu_check_cpuid,
 	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 7eeddc15d14f..1a8a3fa92303 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -479,6 +479,9 @@ void tdx_vm_free(struct kvm *kvm)
 
 	free_page((unsigned long)__va(kvm_tdx->tdr_pa));
 	kvm_tdx->tdr_pa = 0;
+
+	kfree(kvm_tdx->cpuid);
+	kvm_tdx->cpuid = NULL;
 }
 
 static int tdx_do_tdh_mng_key_config(void *param)
@@ -596,6 +599,44 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
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
@@ -2068,10 +2109,12 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
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
@@ -2079,6 +2122,7 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
 	 * It's assumed that td_params was zeroed.
 	 */
+	kvm_tdx->cpuid_nent = 0;
 	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
 		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
 		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
@@ -2101,6 +2145,10 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 		value->ebx = entry->ebx & config->ebx;
 		value->ecx = entry->ecx & config->ecx;
 		value->edx = entry->edx & config->edx;
+
+		/* Remember the setting to check for KVM_SET_CPUID2. */
+		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
+		kvm_tdx->cpuid_nent++;
 	}
 }
 
@@ -2196,7 +2244,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	ret = setup_tdparams_eptp_controls(cpuid, td_params);
 	if (ret)
 		return ret;
-	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
+	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
 	ret = setup_tdparams_xfam(cpuid, td_params);
 	if (ret)
 		return ret;
@@ -2410,11 +2458,19 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	if (cmd->flags)
 		return -EINVAL;
 
+	WARN_ON_ONCE(kvm_tdx->cpuid);
+	kvm_tdx->cpuid = kzalloc(sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
+				 GFP_KERNEL);
+	if (!kvm_tdx->cpuid)
+		return -ENOMEM;
+
 	init_vm = kzalloc(sizeof(*init_vm) +
 			  sizeof(init_vm->cpuid.entries[0]) * KVM_MAX_CPUID_ENTRIES,
 			  GFP_KERNEL);
-	if (!init_vm)
-		return -ENOMEM;
+	if (!init_vm) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
 		ret = -EFAULT;
 		goto out;
@@ -2464,6 +2520,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
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
index c0cc09cb77ba..aff740a775bd 100644
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
index 07eb0e7a5696..89660dd6cc5b 100644
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
@@ -215,6 +217,8 @@ static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
+static inline int tdx_vcpu_check_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
+				       int nent) { return -EOPNOTSUPP; }
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
-- 
2.25.1

