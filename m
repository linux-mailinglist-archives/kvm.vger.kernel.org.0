Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E740459F1B1
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234478AbiHXDDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiHXDDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8580280B54
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m22-20020a6562d6000000b0042a7471b984so4199455pgv.4
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=btQZB34L0PWUKxquscXgy+fzwFwBO3iktn22RFvE/L4=;
        b=KKkrMzppFNqE2w4OSiq9AIj3R0Q98gaaoUmCPM/+g9s5pmt3D5eVeU5xuzddwwCjhz
         PQzQPCVl5Ad08AjXqqg1nPZQtKeUDuCLi2QJZhF2+zBN14lPKIVlZpwjiploHjD5XgMI
         0KJhVYUVeYPT+XLLRC8iIvgkMMQm5VASlVs0USA7mBoRmuH0GJDl8QcD9z22/x2D6hO6
         +6yBFO7ArTMCcXXohwj7SovOjCUC+0eSXvx3NeyNW/zfEzRxmw+xaV6Pcu1oXMH+qGr9
         gS8pr2cHB35o2QEr9GmIrcfL0HjKDOBEHzzwCSZMIrrN+uOwWA8f1+jyNcRoDEsWZ5n2
         I2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=btQZB34L0PWUKxquscXgy+fzwFwBO3iktn22RFvE/L4=;
        b=ULWD4BYWBbhGn+7ChLz7qN3nHwP4WWwCKjohCGHv+WstzJ8ItRXLxHW1lAdyiL/6rg
         h87TCCoxPkKE3UenyYBP4ecrbPS+2m/XIBrxsNztNSfDEG6JNj6hNKVEZF5B9TAO9JKW
         zFpw3MKhtJ+2dlEOb1/gsKOlPdUP+owfzzkBfscQrpdZAc6oqyWJ01Z4rTPEgy9UdtDz
         qPKjY9NjL2lIySF9AHDhTDMkj75eII5OXGvTD6Aqb3DxlHW6Qa3+iGW9JXp+zSLvEghB
         FCxAhJlu2Y9b+r5SCzKHcDbk9NE2N/WiCqdmezT5A3pPZ63vH4ZHz9ORZy6Z9T5/PAdN
         ZsIA==
X-Gm-Message-State: ACgBeo3eXRDMkihx+OpM9ki5+jSIWkjPteQRQ8xvc6Grl1Id0YSQBw+0
        kyRQchJgwbi+2QGSqFuMqxuos2P9l9g=
X-Google-Smtp-Source: AA6agR4EOz5368VqiJYas/w4wwle1CvOGtUOoTvOR7pzvtlKgZAOY9J767lxW3K1q5vC/LXcCMMHZpZueN0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:a14:b0:1fa:bc6e:e5e8 with SMTP id
 gg20-20020a17090b0a1400b001fabc6ee5e8mr151174pjb.1.1661310116578; Tue, 23 Aug
 2022 20:01:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:11 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 09/36] KVM: nVMX: Enforce unsupported eVMCS in VMX MSRs
 for host accesses
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +-
 arch/x86/kvm/vmx/evmcs.c        | 91 ++++++++++++++++++++-------------
 arch/x86/kvm/vmx/evmcs.h        | 19 +++++--
 arch/x86/kvm/vmx/nested.c       | 15 ++++--
 arch/x86/kvm/vmx/vmx.c          | 12 ++---
 arch/x86/kvm/vmx/vmx.h          |  2 +
 arch/x86/kvm/x86.c              |  8 ++-
 include/uapi/linux/kvm.h        |  1 +
 8 files changed, 99 insertions(+), 53 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..2209724b765e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1647,8 +1647,8 @@ struct kvm_x86_nested_ops {
 	bool (*get_nested_state_pages)(struct kvm_vcpu *vcpu);
 	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
-	int (*enable_evmcs)(struct kvm_vcpu *vcpu,
-			    uint16_t *vmcs_version);
+	int (*enable_evmcs)(struct kvm_vcpu *vcpu, uint16_t *vmcs_version,
+			    bool enforce_evmcs);
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
 };
 
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 3bf8681e5239..c0cb68ce7b1b 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -349,6 +349,7 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 
 enum evmcs_revision {
 	EVMCSv1_LEGACY,
+	EVMCSv1_ENFORCED,
 	NR_EVMCS_REVISIONS,
 };
 
@@ -363,99 +364,119 @@ enum evmcs_ctrl_type {
 
 static const u32 evmcs_unsupported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
 	[EVMCS_EXIT_CTRLS] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+		[EVMCSv1_LEGACY]   = EVMCS1_UNSUPPORTED_VMEXIT_CTRL_LEGACY,
+		[EVMCSv1_ENFORCED] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
 	},
 	[EVMCS_ENTRY_CTRLS] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+		[EVMCSv1_LEGACY]   = EVMCS1_UNSUPPORTED_VMENTRY_CTRL_LEGACY,
+		[EVMCSv1_ENFORCED] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
 	},
 	[EVMCS_2NDEXEC] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
+		[EVMCSv1_LEGACY]   = EVMCS1_UNSUPPORTED_2NDEXEC_LEGACY,
+		[EVMCSv1_ENFORCED] = EVMCS1_UNSUPPORTED_2NDEXEC,
 	},
 	[EVMCS_PINCTRL] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_PINCTRL,
+		[EVMCSv1_LEGACY]   = EVMCS1_UNSUPPORTED_PINCTRL_LEGACY,
+		[EVMCSv1_ENFORCED] = EVMCS1_UNSUPPORTED_PINCTRL,
 	},
 	[EVMCS_VMFUNC] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMFUNC,
+		[EVMCSv1_LEGACY]   = EVMCS1_UNSUPPORTED_VMFUNC_LEGACY,
+		[EVMCSv1_ENFORCED] = EVMCS1_UNSUPPORTED_VMFUNC,
 	},
 };
 
-static u32 evmcs_get_unsupported_ctls(enum evmcs_ctrl_type ctrl_type)
+static u32 evmcs_get_unsupported_ctls(struct vcpu_vmx *vmx,
+				      enum evmcs_ctrl_type ctrl_type)
 {
 	enum evmcs_revision evmcs_rev = EVMCSv1_LEGACY;
 
+	if (vmx->nested.enforce_evmcs)
+		evmcs_rev = EVMCSv1_ENFORCED;
+
 	return evmcs_unsupported_ctrls[ctrl_type][evmcs_rev];
 }
 
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
+u64 nested_evmcs_get_unsupported_ctrls(struct vcpu_vmx *vmx, u32 msr_index)
 {
-	u32 ctl_low = (u32)*pdata;
-	u32 ctl_high = (u32)(*pdata >> 32);
-
-	/*
-	 * Hyper-V 2016 and 2019 try using these features even when eVMCS
-	 * is enabled but there are no corresponding fields.
-	 */
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
-		break;
+		return evmcs_get_unsupported_ctls(vmx, EVMCS_EXIT_CTRLS);
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
-		break;
+		return evmcs_get_unsupported_ctls(vmx, EVMCS_ENTRY_CTRLS);
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
-		break;
+		return evmcs_get_unsupported_ctls(vmx, EVMCS_2NDEXEC);
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
-		break;
+		return evmcs_get_unsupported_ctls(vmx, EVMCS_PINCTRL);
 	case MSR_IA32_VMX_VMFUNC:
-		ctl_low &= ~evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
-		break;
+		return evmcs_get_unsupported_ctls(vmx, EVMCS_VMFUNC);
 	}
+	return 0;
+}
+
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 unsupported_ctrls;
+
+	if (!msr_info->host_initiated && !guest_cpuid_has_evmcs(vcpu))
+		return;
+
+	if (msr_info->host_initiated && !vmx->nested.enforce_evmcs)
+		return;
 
-	*pdata = ctl_low | ((u64)ctl_high << 32);
+	unsupported_ctrls = nested_evmcs_get_unsupported_ctrls(vmx, msr_info->index);
+	if (msr_info->index == MSR_IA32_VMX_VMFUNC)
+		msr_info->data &= ~unsupported_ctrls;
+	else
+		msr_info->data &= ~(unsupported_ctrls << 32);
 }
 
-static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type ctrl_type,
+static bool nested_evmcs_is_valid_controls(struct kvm_vcpu *vcpu,
+					   enum evmcs_ctrl_type ctrl_type,
 					   u32 val)
 {
-	return !(val & evmcs_get_unsupported_ctls(ctrl_type));
+	return !(val & evmcs_get_unsupported_ctls(to_vmx(vcpu), ctrl_type));
 }
 
-int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
+int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
-	if (CC(!nested_evmcs_is_valid_controls(EVMCS_PINCTRL,
+	if (CC(!nested_evmcs_is_valid_controls(vcpu, EVMCS_PINCTRL,
 					       vmcs12->pin_based_vm_exec_control)))
 		return -EINVAL;
 
-	if (CC(!nested_evmcs_is_valid_controls(EVMCS_2NDEXEC,
+	if (CC(!nested_evmcs_is_valid_controls(vcpu, EVMCS_2NDEXEC,
 					       vmcs12->secondary_vm_exec_control)))
 		return -EINVAL;
 
-	if (CC(!nested_evmcs_is_valid_controls(EVMCS_EXIT_CTRLS,
+	if (CC(!nested_evmcs_is_valid_controls(vcpu, EVMCS_EXIT_CTRLS,
 					       vmcs12->vm_exit_controls)))
 		return -EINVAL;
 
-	if (CC(!nested_evmcs_is_valid_controls(EVMCS_ENTRY_CTRLS,
+	if (CC(!nested_evmcs_is_valid_controls(vcpu, EVMCS_ENTRY_CTRLS,
 					       vmcs12->vm_entry_controls)))
 		return -EINVAL;
 
-	if (CC(!nested_evmcs_is_valid_controls(EVMCS_VMFUNC,
+	if (CC(!nested_evmcs_is_valid_controls(vcpu, EVMCS_VMFUNC,
 					       vmcs12->vm_function_control)))
 		return -EINVAL;
 
 	return 0;
 }
 
-int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-			uint16_t *vmcs_version)
+int nested_enable_evmcs(struct kvm_vcpu *vcpu, uint16_t *vmcs_version,
+			bool enforce_evmcs)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (vmx->nested.enlightened_vmcs_enabled && enforce_evmcs)
+		return -EINVAL;
+
 	vmx->nested.enlightened_vmcs_enabled = true;
+	vmx->nested.enforce_evmcs = enforce_evmcs;
 
 	if (vmcs_version)
 		*vmcs_version = nested_get_evmcs_version(vcpu);
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index f886a8ff0342..e2b3aeee57ac 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -13,6 +13,7 @@
 #include "vmcs12.h"
 
 struct vmcs_config;
+struct vcpu_vmx;
 
 DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 
@@ -66,6 +67,14 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
+/* TODO: explicitly define these */
+#define EVMCS1_UNSUPPORTED_PINCTRL_LEGACY	EVMCS1_UNSUPPORTED_PINCTRL
+#define EVMCS1_UNSUPPORTED_EXEC_CTRL_LEGACY	EVMCS1_UNSUPPORTED_EXEC_CTRL
+#define EVMCS1_UNSUPPORTED_2NDEXEC_LEGACY	EVMCS1_UNSUPPORTED_2NDEXEC
+#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL_LEGACY	EVMCS1_UNSUPPORTED_VMEXIT_CTRL
+#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL_LEGACY	EVMCS1_UNSUPPORTED_VMENTRY_CTRL
+#define EVMCS1_UNSUPPORTED_VMFUNC_LEGACY	EVMCS1_UNSUPPORTED_VMFUNC
+
 struct evmcs_field {
 	u16 offset;
 	u16 clean_field;
@@ -241,9 +250,11 @@ enum nested_evmptrld_status {
 
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
-int nested_enable_evmcs(struct kvm_vcpu *vcpu,
-			uint16_t *vmcs_version);
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
-int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+int nested_enable_evmcs(struct kvm_vcpu *vcpu, uint16_t *vmcs_version,
+			bool enforce_evmcs);
+u64 nested_evmcs_get_unsupported_ctrls(struct vcpu_vmx *vmx, u32 msr_index);
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu,
+				     struct msr_data *msr_info);
+int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 28f9d64851b3..52d299b9263b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1279,12 +1279,17 @@ static void vmx_get_control_msr(struct nested_vmx_msrs *msrs, u32 msr_index,
 static int
 vmx_restore_control_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
 {
-	u32 *lowp, *highp;
+	u32 *lowp, *highp, high;
 	u64 supported;
 
 	vmx_get_control_msr(&vmcs_config.nested, msr_index, &lowp, &highp);
 
-	supported = vmx_control_msr(*lowp, *highp);
+	/* Do not overwrite the global vmcs_config.nested! */
+	high = *highp;
+	if (vmx->nested.enforce_evmcs)
+		high &= ~nested_evmcs_get_unsupported_ctrls(vmx, msr_index);
+
+	supported = vmx_control_msr(*lowp, high);
 
 	/* Check must-be-1 bits are still 1. */
 	if (!is_bitwise_subset(data, supported, GENMASK_ULL(31, 0)))
@@ -1435,6 +1440,10 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 	case MSR_IA32_VMX_VMFUNC:
 		if (data & ~vmcs_config.nested.vmfunc_controls)
 			return -EINVAL;
+		if (vmx->nested.enforce_evmcs &&
+		    (data & nested_evmcs_get_unsupported_ctrls(vmx, MSR_IA32_VMX_VMFUNC)))
+			return -EINVAL;
+
 		vmx->nested.msrs.vmfunc_controls = data;
 		return 0;
 	default:
@@ -2864,7 +2873,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (guest_cpuid_has_evmcs(vcpu))
-		return nested_evmcs_check_controls(vmcs12);
+		return nested_evmcs_check_controls(vcpu, vmcs12);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4ed802947d7..73f9074efc61 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1924,15 +1924,11 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				    &msr_info->data))
 			return 1;
 		/*
-		 * Enlightened VMCS v1 doesn't have certain VMCS fields but
-		 * instead of just ignoring the features, different Hyper-V
-		 * versions are either trying to use them and fail or do some
-		 * sanity checking and refuse to boot. Filter all unsupported
-		 * features out.
+		 * New Enlightened VMCS fields always lag behind their hardware
+		 * counterparts, filter out fields that are not yet defined.
 		 */
-		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
-			nested_evmcs_filter_control_msr(msr_info->index,
-							&msr_info->data);
+		if (vmx->nested.enlightened_vmcs_enabled)
+			nested_evmcs_filter_control_msr(vcpu, msr_info);
 		break;
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest())
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 35c7e6aef301..a7a05b5e41d2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -197,6 +197,8 @@ struct nested_vmx {
 	 */
 	bool enlightened_vmcs_enabled;
 
+	bool enforce_evmcs;
+
 	/* L2 must run next, and mustn't decide to exit to L1. */
 	bool nested_run_pending;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..fb5cecb19cf5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4452,6 +4452,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
 		break;
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
+	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS2:
 		r = kvm_x86_ops.nested_ops->enable_evmcs != NULL;
 		break;
 	case KVM_CAP_SMALLER_MAXPHYADDR:
@@ -5429,9 +5430,13 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		return kvm_hv_activate_synic(vcpu, cap->cap ==
 					     KVM_CAP_HYPERV_SYNIC2);
 	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
+	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS2: {
+		bool enforce_evmcs = cap->cap == KVM_CAP_HYPERV_ENLIGHTENED_VMCS2;
+
 		if (!kvm_x86_ops.nested_ops->enable_evmcs)
 			return -ENOTTY;
-		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version);
+		r = kvm_x86_ops.nested_ops->enable_evmcs(vcpu, &vmcs_version,
+							 enforce_evmcs);
 		if (!r) {
 			user_ptr = (void __user *)(uintptr_t)cap->args[0];
 			if (copy_to_user(user_ptr, &vmcs_version,
@@ -5439,6 +5444,7 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				r = -EFAULT;
 		}
 		return r;
+	}
 	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
 		if (!kvm_x86_ops.enable_direct_tlbflush)
 			return -ENOTTY;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..ba08d6f74267 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_HYPERV_ENLIGHTENED_VMCS2 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.37.1.595.g718a3a8f04-goog

