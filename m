Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB92587FCB
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237498AbiHBQJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237637AbiHBQIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:08:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8BDD02E6B1
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzzy8mULszr0InhpSy8ftGTnGqcZlckTxxjdBwf2gec=;
        b=LVtWoM/WjzfK9BuRptj9t4X87JyJeXVy4luPzbx6UZMOWvTNeZ2h075YlBVboKRlU6aClP
        10cQW2LunWnpi/Ab080ALJLyr4B4M2A0vk8QwOcROmftmyD/YNxLmqtKY5+pINseDoT4/X
        WjEIOQ/OrgCUFxIZjBssp4tPmidHOMQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-IxjcScRnPAimvUUhVH1p1Q-1; Tue, 02 Aug 2022 12:08:27 -0400
X-MC-Unique: IxjcScRnPAimvUUhVH1p1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73DC33804538;
        Tue,  2 Aug 2022 16:08:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F36CB2166B26;
        Tue,  2 Aug 2022 16:08:23 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 09/26] KVM: VMX: nVMX: Support TSC scaling and PERF_GLOBAL_CTRL with enlightened VMCS
Date:   Tue,  2 Aug 2022 18:07:39 +0200
Message-Id: <20220802160756.339464-10-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 got updated and now includes the required fields
for TSC scaling and loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT
features. For Hyper-V on KVM enablement, KVM can just observe VMX control
MSRs and use the features (with or without eVMCS) when
possible. Hyper-V on KVM case is trickier because of live migration:
the new features require explicit enablement from VMM to not break
it. Luckily, the updated eVMCS revision comes with a feature bit in
CPUID.0x4000000A.EBX.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c     |  2 +-
 arch/x86/kvm/vmx/evmcs.c  | 88 +++++++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/evmcs.h  | 17 ++------
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 5 files changed, 78 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1098915360ae..8a2b24f9bbf6 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2552,7 +2552,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
 			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
-
+			ent->ebx |= HV_X64_NESTED_EVMCS1_2022_UPDATE;
 			break;
 
 		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 8bea5dea0341..e8497f9854a1 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -368,7 +368,60 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
+enum evmcs_revision {
+	EVMCSv1_2016,
+	EVMCSv1_2022,
+	EVMCS_REVISION_MAX,
+};
+
+enum evmcs_unsupported_ctrl_type {
+	EVMCS_EXIT_CTLS,
+	EVMCS_ENTRY_CTLS,
+	EVMCS_2NDEXEC,
+	EVMCS_PINCTRL,
+	EVMCS_VMFUNC,
+	EVMCS_CTRL_MAX,
+};
+
+static u32 evmcs_unsupported_ctls[EVMCS_CTRL_MAX][EVMCS_REVISION_MAX] = {
+	[EVMCS_EXIT_CTLS] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL | VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
+	},
+	[EVMCS_ENTRY_CTLS] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL | VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,
+		[EVMCSv1_2022] =  EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
+	},
+	[EVMCS_2NDEXEC] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_2NDEXEC,
+	},
+	[EVMCS_PINCTRL] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_PINCTRL,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_PINCTRL,
+	},
+	[EVMCS_VMFUNC] = {
+		[EVMCSv1_2016] = EVMCS1_UNSUPPORTED_VMFUNC,
+		[EVMCSv1_2022] = EVMCS1_UNSUPPORTED_VMFUNC,
+	},
+};
+
+static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
+				      enum evmcs_unsupported_ctrl_type ctrl_type)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+	enum evmcs_revision evmcs_rev = EVMCSv1_2016;
+
+	if (!hv_vcpu)
+		return 0;
+
+	if (hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_2022_UPDATE)
+		evmcs_rev = EVMCSv1_2022;
+
+	return evmcs_unsupported_ctls[ctrl_type][evmcs_rev];
+}
+
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	u32 ctl_low = (u32)*pdata;
 	u32 ctl_high = (u32)(*pdata >> 32);
@@ -380,72 +433,73 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_EXIT_CTLS);
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_ENTRY_CTLS);
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
+		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_2NDEXEC);
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
-		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
+		ctl_high &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_PINCTRL);
 		break;
 	case MSR_IA32_VMX_VMFUNC:
-		ctl_low &= ~EVMCS1_UNSUPPORTED_VMFUNC;
+		ctl_low &= ~evmcs_get_unsupported_ctls(vcpu, EVMCS_VMFUNC);
 		break;
 	}
 
 	*pdata = ctl_low | ((u64)ctl_high << 32);
 }
 
-int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
+int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 {
 	int ret = 0;
 	u32 unsupp_ctl;
 
 	unsupp_ctl = vmcs12->pin_based_vm_exec_control &
-		EVMCS1_UNSUPPORTED_PINCTRL;
+		evmcs_get_unsupported_ctls(vcpu, EVMCS_PINCTRL);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported pin-based VM-execution controls",
+			"eVMCS: unsupported pin-based VM-execution controls: ",
 			unsupp_ctl);
 		ret = -EINVAL;
 	}
 
 	unsupp_ctl = vmcs12->secondary_vm_exec_control &
-		EVMCS1_UNSUPPORTED_2NDEXEC;
+		evmcs_get_unsupported_ctls(vcpu, EVMCS_2NDEXEC);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported secondary VM-execution controls",
+			"eVMCS: unsupported secondary VM-execution controls: ",
 			unsupp_ctl);
 		ret = -EINVAL;
 	}
 
 	unsupp_ctl = vmcs12->vm_exit_controls &
-		EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+		evmcs_get_unsupported_ctls(vcpu, EVMCS_EXIT_CTLS);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-exit controls",
+			"eVMCS: unsupported VM-exit controls: ",
 			unsupp_ctl);
 		ret = -EINVAL;
 	}
 
 	unsupp_ctl = vmcs12->vm_entry_controls &
-		EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+		evmcs_get_unsupported_ctls(vcpu, EVMCS_ENTRY_CTLS);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-entry controls",
+			"eVMCS: unsupported VM-entry controls: ",
 			unsupp_ctl);
 		ret = -EINVAL;
 	}
 
-	unsupp_ctl = vmcs12->vm_function_control & EVMCS1_UNSUPPORTED_VMFUNC;
+	unsupp_ctl = vmcs12->vm_function_control &
+		evmcs_get_unsupported_ctls(vcpu, EVMCS_VMFUNC);
 	if (unsupp_ctl) {
 		trace_kvm_nested_vmenter_failed(
-			"eVMCS: unsupported VM-function controls",
+			"eVMCS: unsupported VM-function controls: ",
 			unsupp_ctl);
 		ret = -EINVAL;
 	}
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index f886a8ff0342..4b809c79ae63 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -37,16 +37,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  *	EPTP_LIST_ADDRESS               = 0x00002024,
  *	VMREAD_BITMAP                   = 0x00002026,
  *	VMWRITE_BITMAP                  = 0x00002028,
- *
- *	TSC_MULTIPLIER                  = 0x00002032,
  *	PLE_GAP                         = 0x00004020,
  *	PLE_WINDOW                      = 0x00004022,
  *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
- *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
- *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
- *
- * Currently unsupported in KVM:
- *	GUEST_IA32_RTIT_CTL		= 0x00002814,
  */
 #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
 				    PIN_BASED_VMX_PREEMPTION_TIMER)
@@ -58,12 +51,10 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_ENABLE_PML |					\
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
-	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
 #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
-	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
-	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+	(VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
 struct evmcs_field {
@@ -243,7 +234,7 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
-int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
+int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 270a1d8e4a6e..edb2f9c74d71 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2895,7 +2895,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (to_vmx(vcpu)->nested.enlightened_vmcs_enabled)
-		return nested_evmcs_check_controls(vmcs12);
+		return nested_evmcs_check_controls(vcpu, vmcs12);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..bd6f8552102a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1933,7 +1933,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (!msr_info->host_initiated &&
 		    vmx->nested.enlightened_vmcs_enabled)
-			nested_evmcs_filter_control_msr(msr_info->index,
+			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
 							&msr_info->data);
 		break;
 	case MSR_IA32_RTIT_CTL:
-- 
2.35.3

