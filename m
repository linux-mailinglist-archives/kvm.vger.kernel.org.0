Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF61B560407
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbiF2PHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiF2PGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0799E2CCA2
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0yOEeFeajicv/Rn1qUlQBsFT9/NGkH9O3cGIm0nstGY=;
        b=Jw9qanGVF5CyI98fXTTqNcY2rG3w6jGTYzA46QKHL1nySLBnktjbn8U/W5U/WOxY6u5djU
        jqIqWPIt8Q1Fdyyn6xeNus6QSqPSLkXaKoLlexPR87OobMTHKvKx8ecDEO5FWVIpomBAp4
        wwSiuRxsmLCS6C4jaYLoGfCglg/2DV0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-m4wrtCSRN3iHjm1ZngUpVw-1; Wed, 29 Jun 2022 11:06:47 -0400
X-MC-Unique: m4wrtCSRN3iHjm1ZngUpVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28ED91C08972;
        Wed, 29 Jun 2022 15:06:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C191040EC002;
        Wed, 29 Jun 2022 15:06:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/28] KVM: VMX: Support TSC scaling with enlightened VMCS
Date:   Wed, 29 Jun 2022 17:06:05 +0200
Message-Id: <20220629150625.238286-9-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 now includes the required field for TSC scaling
feature so SECONDARY_EXEC_TSC_SCALING doesn't need to be filtered out,
both for KVM on Hyper-V and Hyper-V on KVM cases.

Note: Hyper-V on KVM case requires bumping KVM_EVMCS_REVISION revision
so VMMs can specify if SECONDARY_EXEC_TSC_SCALING needs to be filtered
out or not, this is required to support live migration.

While on it, update the comment why VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL/
VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL are kept filtered out and add
missing spaces in trace_kvm_nested_vmenter_failed() strings making the
output ugly.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c  | 70 +++++++++++++++++++++++++++++----------
 arch/x86/kvm/vmx/evmcs.h  | 17 ++++------
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 4 files changed, 62 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 21d9f0ed4bd2..4fe65b6a9a92 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -368,7 +368,42 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
+enum evmcs_unsupported_ctrl_type {
+	EVMCS_EXIT_CTLS,
+	EVMCS_ENTRY_CTLS,
+	EVMCS_2NDEXEC,
+	EVMCS_PINCTRL,
+	EVMCS_VMFUNC,
+};
+
+static u32 evmcs_get_unsupported_ctls(struct kvm_vcpu *vcpu,
+				      enum evmcs_unsupported_ctrl_type ctrl_type)
+{
+	u32 evmcs_rev = to_vmx(vcpu)->nested.active_evmcs_revision;
+
+	if (!evmcs_rev)
+		return 0;
+
+	switch (ctrl_type) {
+	case EVMCS_EXIT_CTLS:
+		return EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
+	case EVMCS_ENTRY_CTLS:
+		return EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
+	case EVMCS_2NDEXEC:
+		if (evmcs_rev == 1)
+			return EVMCS1_UNSUPPORTED_2NDEXEC | SECONDARY_EXEC_TSC_SCALING;
+		else
+			return EVMCS1_UNSUPPORTED_2NDEXEC;
+	case EVMCS_PINCTRL:
+		return EVMCS1_UNSUPPORTED_PINCTRL;
+	case EVMCS_VMFUNC:
+		return EVMCS1_UNSUPPORTED_VMFUNC;
+	}
+
+	return 0;
+}
+
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	u32 ctl_low = (u32)*pdata;
 	u32 ctl_high = (u32)(*pdata >> 32);
@@ -380,72 +415,73 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
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
index 022a51ae81e4..2992e29b81b7 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -28,7 +28,7 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  * Internal KVM eVMCS revision number, gets bumped when eVMCS needs to be
  * updated but its version remain intact.
  */
-#define KVM_EVMCS_REVISION 1
+#define KVM_EVMCS_REVISION 2
 
 /*
  * Enlightened VMCSv1 doesn't support these:
@@ -47,16 +47,14 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
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
  *
- * Currently unsupported in KVM:
- *	GUEST_IA32_RTIT_CTL		= 0x00002814,
+ *	While GUEST_IA32_PERF_GLOBAL_CTRL and HOST_IA32_PERF_GLOBAL_CTRL
+ *	are present in eVMCSv1, Windows 11 still has issues booting when
+ *	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL/VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL
+ *	are exposed to it, keep them filtered out.
  */
 #define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
 				    PIN_BASED_VMX_PREEMPTION_TIMER)
@@ -68,7 +66,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_ENABLE_PML |					\
 	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
-	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
 #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
 	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
@@ -252,7 +249,7 @@ enum nested_evmptrld_status {
 bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu, u32 evmcs_revision, uint16_t *vmcs_version);
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
-int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
+int nested_evmcs_check_controls(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2ff361a0285f..88625965f7b7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2891,7 +2891,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (to_vmx(vcpu)->nested.active_evmcs_revision)
-		return nested_evmcs_check_controls(vmcs12);
+		return nested_evmcs_check_controls(vcpu, vmcs12);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 76f83af7d901..99cd017cd3fe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1858,7 +1858,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 */
 		if (!msr_info->host_initiated &&
 		    vmx->nested.active_evmcs_revision)
-			nested_evmcs_filter_control_msr(msr_info->index,
+			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
 							&msr_info->data);
 		break;
 	case MSR_IA32_RTIT_CTL:
-- 
2.35.3

