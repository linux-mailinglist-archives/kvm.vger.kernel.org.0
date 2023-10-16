Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383D87CAF41
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjJPQbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbjJPQa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:30:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD4376B1;
        Mon, 16 Oct 2023 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473376; x=1729009376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cs8t2/WrcGvjs6jH+SPkYFxT9mwmLBNumaa8xIUqz9A=;
  b=fEnXs0YjjS7GPeWO3ix591uY3HvRMUUS0NTcSs9ngrMKGwGpDpUc+tOR
   4ohGndhERm1v2OSDqnUSB03oTdsKUK07rSFjm9Bpf5FzK4QegT6QnyJng
   1SOUqLEpwUiSjLfxal/JHEtukoZ3X9Hl+cWeHjgccbm8sV+lfW2JNXIUl
   sEZR6mikHydCLpMJOM663BHeXWojX0Gcpe8G9FswFb4/UoEpULiPVwahB
   icML0xU6UUwDaCIX9GB57/GUtbVcuzy9SpqoMZ1CA40sOCNBISeFqk0cr
   MNcEsTw7B0F7Ib4na558vHksuvmKmW2RLRmLmujeLkhWWU4/8NAjTJv9l
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922179"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922179"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006499"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006499"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:14 -0700
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
Subject: [PATCH v16 115/116] RFC: KVM: x86, TDX: Add check for KVM_SET_CPUID2
Date:   Mon, 16 Oct 2023 09:15:07 -0700
Message-Id: <12c1e71d60bb59aea64d1a50f81cc8e7df2615b6.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c     | 72 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.h     |  7 ++++
 arch/x86/kvm/vmx/x86_ops.h |  4 +++
 4 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5d61f5306ae3..c5b01053e402 100644
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
index 3287701199dd..70eba1b984e1 100644
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
@@ -2211,10 +2252,12 @@ static int setup_tdparams_eptp_controls(struct kvm_cpuid2 *cpuid,
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
@@ -2222,6 +2265,7 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 	 * be same to the one of struct tdsysinfo.{num_cpuid_config, cpuid_configs}
 	 * It's assumed that td_params was zeroed.
 	 */
+	kvm_tdx->cpuid_nent = 0;
 	for (i = 0; i < tdsysinfo->num_cpuid_config; i++) {
 		const struct tdx_cpuid_config *config = &tdsysinfo->cpuid_configs[i];
 		/* TDX_CPUID_NO_SUBLEAF in TDX CPUID_CONFIG means index = 0. */
@@ -2244,6 +2288,10 @@ static void setup_tdparams_cpuids(const struct tdsysinfo_struct *tdsysinfo,
 		value->ebx = entry->ebx & config->ebx;
 		value->ecx = entry->ecx & config->ecx;
 		value->edx = entry->edx & config->edx;
+
+		/* Remember the setting to check for KVM_SET_CPUID2. */
+		kvm_tdx->cpuid[kvm_tdx->cpuid_nent] = *entry;
+		kvm_tdx->cpuid_nent++;
 	}
 }
 
@@ -2331,7 +2379,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	ret = setup_tdparams_eptp_controls(cpuid, td_params);
 	if (ret)
 		return ret;
-	setup_tdparams_cpuids(tdsysinfo, cpuid, td_params);
+	setup_tdparams_cpuids(kvm, tdsysinfo, cpuid, td_params);
 	ret = setup_tdparams_xfam(cpuid, td_params);
 	if (ret)
 		return ret;
@@ -2546,11 +2594,18 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
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
@@ -2600,6 +2655,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
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
index 7c377b7d76b9..ae2e04a3ab27 100644
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

