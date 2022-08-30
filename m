Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AF75A6515
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiH3Njx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiH3NjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:39:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EF0132854
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RrbqZ8b1MU/RgTHKuuE/Rlvqh7DaQSXPBuzp2K956cs=;
        b=NL/00I1Q+7MqlelWoqyPwwcWMSd+fVgGmIHPeCthISFb5x6DrgqaKc+c0siv/ET2RDM8bT
        tmpE2kcqrusDyuhKezUyFltfz+Czvvpp8cuvV6doxeX0GO+0aojjS+E/4ysRmUrVM4Laxl
        ttlNyZcTclxBe9+uXjNoVtCwAo+gpa8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-0eR3qc3fPdqiUZYs09NtDg-1; Tue, 30 Aug 2022 09:38:20 -0400
X-MC-Unique: 0eR3qc3fPdqiUZYs09NtDg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9BB43C0D850;
        Tue, 30 Aug 2022 13:38:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8ED702166B26;
        Tue, 30 Aug 2022 13:38:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 15/33] KVM: nVMX: Support PERF_GLOBAL_CTRL with enlightened VMCS
Date:   Tue, 30 Aug 2022 15:37:19 +0200
Message-Id: <20220830133737.1539624-16-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 got updated and now includes the required fields
for loading PERF_GLOBAL_CTRL upon VMENTER/VMEXIT features. For KVM on
Hyper-V enablement, KVM can just observe VMX control MSRs and use the
features (with or without eVMCS) when possible.

Hyper-V on KVM is messier as Windows 11 guests fail to boot if the
controls are advertised and a new PV feature flag, CPUID.0x4000000A.EBX
BIT(0), is not set.  Honor the Hyper-V CPUID feature flag to play nice
with Windows guests.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/hyperv.c    |  2 +-
 arch/x86/kvm/vmx/evmcs.c | 30 +++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/evmcs.h |  9 +++------
 arch/x86/kvm/vmx/vmx.c   |  2 +-
 4 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index a7478b61088b..0adf4a437e85 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -2546,7 +2546,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_NESTED_FEATURES:
 			ent->eax = evmcs_ver;
 			ent->eax |= HV_X64_NESTED_MSR_BITMAP;
-
+			ent->ebx |= HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
 			break;
 
 		case HYPERV_CPUID_SYNDBG_VENDOR_AND_MAX_FUNCTIONS:
diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index b64e29f1359f..5fc4834be1f6 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -412,10 +412,28 @@ static u32 evmcs_get_unsupported_ctls(enum evmcs_ctrl_type ctrl_type)
 	return evmcs_unsupported_ctrls[ctrl_type][evmcs_rev];
 }
 
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
+static bool evmcs_has_perf_global_ctrl(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	/*
+	 * PERF_GLOBAL_CTRL has a quirk where some Windows guests may fail to
+	 * boot if a PV CPUID feature flag is not also set.  Treat the fields
+	 * as unsupported if the flag is not set in guest CPUID.  This should
+	 * be called only for guest accesses, and all guest accesses should be
+	 * gated on Hyper-V being enabled and initialized.
+	 */
+	if (WARN_ON_ONCE(!hv_vcpu))
+		return false;
+
+	return hv_vcpu->cpuid_cache.nested_ebx & HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL;
+}
+
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata)
 {
 	u32 ctl_low = (u32)*pdata;
 	u32 ctl_high = (u32)(*pdata >> 32);
+	u32 unsupported_ctrls;
 
 	/*
 	 * Hyper-V 2016 and 2019 try using these features even when eVMCS
@@ -424,11 +442,17 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
+		unsupported_ctrls = evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
+		if (!evmcs_has_perf_global_ctrl(vcpu))
+			unsupported_ctrls |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~unsupported_ctrls;
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
+		unsupported_ctrls = evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
+		if (!evmcs_has_perf_global_ctrl(vcpu))
+			unsupported_ctrls |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= ~unsupported_ctrls;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index f886a8ff0342..d0b2861325a0 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -42,8 +42,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  *	PLE_GAP                         = 0x00004020,
  *	PLE_WINDOW                      = 0x00004022,
  *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
- *      GUEST_IA32_PERF_GLOBAL_CTRL     = 0x00002808,
- *      HOST_IA32_PERF_GLOBAL_CTRL      = 0x00002c04,
  *
  * Currently unsupported in KVM:
  *	GUEST_IA32_RTIT_CTL		= 0x00002814,
@@ -61,9 +59,8 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
 #define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
-	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
-	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
+	(VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
+#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
 struct evmcs_field {
@@ -243,7 +240,7 @@ bool nested_enlightened_vmentry(struct kvm_vcpu *vcpu, u64 *evmcs_gpa);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 			uint16_t *vmcs_version);
-void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata);
+void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata);
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 
 #endif /* __KVM_X86_VMX_EVMCS_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4ed802947d7..f91f09db6e65 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1931,7 +1931,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * features out.
 		 */
 		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
-			nested_evmcs_filter_control_msr(msr_info->index,
+			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
 							&msr_info->data);
 		break;
 	case MSR_IA32_RTIT_CTL:
-- 
2.37.2

