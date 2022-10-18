Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15AB7602913
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 12:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJRKK0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 06:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJRKKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 06:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C2E71BF7
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 03:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666087810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9iBxq2gJpJajMu6ZWxmh9zVD8NKKUvQWON6GiXii3ns=;
        b=cVC6C4jWMX2UsoDH63L89w2TGWFBL2zfK9lKYvM+NqpPXH9YCp513776wVfhVu52amLFsc
        0sipb/fCkBirY95/gBBx50+bD6ct44y+NUx2pCkALvXB7SMxtusS3geNNVhaAnORqWn6Fr
        kgOMAvNeC49fsXBM5LKcoYBBwdjAmKU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-eeHcbVzgNkm46ANY5aMzTg-1; Tue, 18 Oct 2022 06:10:07 -0400
X-MC-Unique: eeHcbVzgNkm46ANY5aMzTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11BEA803D48;
        Tue, 18 Oct 2022 10:10:07 +0000 (UTC)
Received: from ovpn-193-156.brq.redhat.com (ovpn-193-156.brq.redhat.com [10.40.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6504040C94AA;
        Tue, 18 Oct 2022 10:10:05 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: nVMX: Invert 'unsupported by eVMCSv1' check
Date:   Tue, 18 Oct 2022 12:09:58 +0200
Message-Id: <20221018101000.934413-3-vkuznets@redhat.com>
In-Reply-To: <20221018101000.934413-1-vkuznets@redhat.com>
References: <20221018101000.934413-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a new feature gets implemented in KVM, EVMCS1_UNSUPPORTED_* defines
need to be adjusted to avoid the situation when the feature is exposed
to the guest but there's no corresponding eVMCS field[s] for it. This
is not obvious and fragile. Invert 'unsupported by eVMCSv1' check and
make it 'supported by eVMCSv1' instead, this way it's much harder to
make a mistake. New features will get added to EVMCS1_SUPPORTED_*
defines when the corresponding fields are added to eVMCS definition.

No functional change intended. EVMCS1_SUPPORTED_* defines are composed
by taking KVM_{REQUIRED,OPTIONAL}_VMX_ defines and filtering out what
was previously known as EVMCS1_UNSUPPORTED_*.

From all the controls, SECONDARY_EXEC_TSC_SCALING requires special
handling as it's actually present in eVMCSv1 definition but is not
currently supported for Hyper-V-on-KVM, just for KVM-on-Hyper-V. As
evmcs_supported_ctrls will be used for both scenarios, just add it
there instead of EVMCS1_SUPPORTED_2NDEXEC.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/evmcs.c | 42 +++++++++----------
 arch/x86/kvm/vmx/evmcs.h | 90 +++++++++++++++++++++++++++++++++-------
 2 files changed, 96 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 337783675731..0f031d27741a 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -375,32 +375,32 @@ enum evmcs_ctrl_type {
 	NR_EVMCS_CTRLS,
 };
 
-static const u32 evmcs_unsupported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
+static const u32 evmcs_supported_ctrls[NR_EVMCS_CTRLS][NR_EVMCS_REVISIONS] = {
 	[EVMCS_EXIT_CTRLS] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMEXIT_CTRL,
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_VMEXIT_CTRL,
 	},
 	[EVMCS_ENTRY_CTRLS] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMENTRY_CTRL,
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_VMENTRY_CTRL,
 	},
 	[EVMCS_EXEC_CTRL] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_EXEC_CTRL,
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_EXEC_CTRL,
 	},
 	[EVMCS_2NDEXEC] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_2NDEXEC,
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_2NDEXEC & ~SECONDARY_EXEC_TSC_SCALING,
 	},
 	[EVMCS_PINCTRL] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_PINCTRL,
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_PINCTRL,
 	},
 	[EVMCS_VMFUNC] = {
-		[EVMCSv1_LEGACY] = EVMCS1_UNSUPPORTED_VMFUNC,
+		[EVMCSv1_LEGACY] = EVMCS1_SUPPORTED_VMFUNC,
 	},
 };
 
-static u32 evmcs_get_unsupported_ctls(enum evmcs_ctrl_type ctrl_type)
+static u32 evmcs_get_supported_ctls(enum evmcs_ctrl_type ctrl_type)
 {
 	enum evmcs_revision evmcs_rev = EVMCSv1_LEGACY;
 
-	return evmcs_unsupported_ctrls[ctrl_type][evmcs_rev];
+	return evmcs_supported_ctrls[ctrl_type][evmcs_rev];
 }
 
 static bool evmcs_has_perf_global_ctrl(struct kvm_vcpu *vcpu)
@@ -424,7 +424,7 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 {
 	u32 ctl_low = (u32)*pdata;
 	u32 ctl_high = (u32)(*pdata >> 32);
-	u32 unsupported_ctrls;
+	u32 supported_ctrls;
 
 	/*
 	 * Hyper-V 2016 and 2019 try using these features even when eVMCS
@@ -433,31 +433,31 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 	switch (msr_index) {
 	case MSR_IA32_VMX_EXIT_CTLS:
 	case MSR_IA32_VMX_TRUE_EXIT_CTLS:
-		unsupported_ctrls = evmcs_get_unsupported_ctls(EVMCS_EXIT_CTRLS);
+		supported_ctrls = evmcs_get_supported_ctls(EVMCS_EXIT_CTRLS);
 		if (!evmcs_has_perf_global_ctrl(vcpu))
-			unsupported_ctrls |= VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
-		ctl_high &= ~unsupported_ctrls;
+			supported_ctrls &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= supported_ctrls;
 		break;
 	case MSR_IA32_VMX_ENTRY_CTLS:
 	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
-		unsupported_ctrls = evmcs_get_unsupported_ctls(EVMCS_ENTRY_CTRLS);
+		supported_ctrls = evmcs_get_supported_ctls(EVMCS_ENTRY_CTRLS);
 		if (!evmcs_has_perf_global_ctrl(vcpu))
-			unsupported_ctrls |= VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
-		ctl_high &= ~unsupported_ctrls;
+			supported_ctrls &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		ctl_high &= supported_ctrls;
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS:
 	case MSR_IA32_VMX_TRUE_PROCBASED_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_EXEC_CTRL);
+		ctl_high &= evmcs_get_supported_ctls(EVMCS_EXEC_CTRL);
 		break;
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_2NDEXEC);
+		ctl_high &= evmcs_get_supported_ctls(EVMCS_2NDEXEC);
 		break;
 	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
-		ctl_high &= ~evmcs_get_unsupported_ctls(EVMCS_PINCTRL);
+		ctl_high &= evmcs_get_supported_ctls(EVMCS_PINCTRL);
 		break;
 	case MSR_IA32_VMX_VMFUNC:
-		ctl_low &= ~evmcs_get_unsupported_ctls(EVMCS_VMFUNC);
+		ctl_low &= evmcs_get_supported_ctls(EVMCS_VMFUNC);
 		break;
 	}
 
@@ -467,7 +467,7 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 static bool nested_evmcs_is_valid_controls(enum evmcs_ctrl_type ctrl_type,
 					   u32 val)
 {
-	return !(val & evmcs_get_unsupported_ctls(ctrl_type));
+	return !(val & ~evmcs_get_supported_ctls(ctrl_type));
 }
 
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 6f746ef3c038..4c351f334446 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -46,22 +46,82 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
  * Currently unsupported in KVM:
  *	GUEST_IA32_RTIT_CTL		= 0x00002814,
  */
-#define EVMCS1_UNSUPPORTED_PINCTRL (PIN_BASED_POSTED_INTR | \
-				    PIN_BASED_VMX_PREEMPTION_TIMER)
-#define EVMCS1_UNSUPPORTED_EXEC_CTRL (CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
-#define EVMCS1_UNSUPPORTED_2NDEXEC					\
-	(SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |				\
-	 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |			\
-	 SECONDARY_EXEC_APIC_REGISTER_VIRT |				\
-	 SECONDARY_EXEC_ENABLE_PML |					\
-	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
-	 SECONDARY_EXEC_SHADOW_VMCS |					\
+#define EVMCS1_SUPPORTED_PINCTRL					\
+	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 PIN_BASED_EXT_INTR_MASK |					\
+	 PIN_BASED_NMI_EXITING |					\
+	 PIN_BASED_VIRTUAL_NMIS)
+
+#define EVMCS1_SUPPORTED_EXEC_CTRL					\
+	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 CPU_BASED_HLT_EXITING |					\
+	 CPU_BASED_CR3_LOAD_EXITING |					\
+	 CPU_BASED_CR3_STORE_EXITING |					\
+	 CPU_BASED_UNCOND_IO_EXITING |					\
+	 CPU_BASED_MOV_DR_EXITING |					\
+	 CPU_BASED_USE_TSC_OFFSETTING |					\
+	 CPU_BASED_MWAIT_EXITING |					\
+	 CPU_BASED_MONITOR_EXITING |					\
+	 CPU_BASED_INVLPG_EXITING |					\
+	 CPU_BASED_RDPMC_EXITING |					\
+	 CPU_BASED_INTR_WINDOW_EXITING |				\
+	 CPU_BASED_CR8_LOAD_EXITING |					\
+	 CPU_BASED_CR8_STORE_EXITING |					\
+	 CPU_BASED_RDTSC_EXITING |					\
+	 CPU_BASED_TPR_SHADOW |						\
+	 CPU_BASED_USE_IO_BITMAPS |					\
+	 CPU_BASED_MONITOR_TRAP_FLAG |					\
+	 CPU_BASED_USE_MSR_BITMAPS |					\
+	 CPU_BASED_NMI_WINDOW_EXITING |					\
+	 CPU_BASED_PAUSE_EXITING |					\
+	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
+
+#define EVMCS1_SUPPORTED_2NDEXEC					\
+	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
+	 SECONDARY_EXEC_WBINVD_EXITING |				\
+	 SECONDARY_EXEC_ENABLE_VPID |					\
+	 SECONDARY_EXEC_ENABLE_EPT |					\
+	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
+	 SECONDARY_EXEC_DESC |						\
+	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
+	 SECONDARY_EXEC_ENABLE_INVPCID |				\
+	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_RDSEED_EXITING |				\
+	 SECONDARY_EXEC_RDRAND_EXITING |				\
 	 SECONDARY_EXEC_TSC_SCALING |					\
-	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
-#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
-	(VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
-#define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (0)
-#define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
+	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
+	 SECONDARY_EXEC_PT_USE_GPA |					\
+	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
+	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
+	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_ENCLS_EXITING)
+
+#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
+	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
+	 VM_EXIT_ACK_INTR_ON_EXIT |					\
+	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
+	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_EXIT_SAVE_IA32_PAT |					\
+	 VM_EXIT_LOAD_IA32_PAT |					\
+	 VM_EXIT_SAVE_IA32_EFER |					\
+	 VM_EXIT_LOAD_IA32_EFER |					\
+	 VM_EXIT_CLEAR_BNDCFGS |					\
+	 VM_EXIT_PT_CONCEAL_PIP |					\
+	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
+
+#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
+	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
+	 VM_ENTRY_IA32E_MODE |						\
+	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_ENTRY_LOAD_IA32_PAT |					\
+	 VM_ENTRY_LOAD_IA32_EFER |					\
+	 VM_ENTRY_LOAD_BNDCFGS |					\
+	 VM_ENTRY_PT_CONCEAL_PIP |					\
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+
+#define EVMCS1_SUPPORTED_VMFUNC (0)
 
 struct evmcs_field {
 	u16 offset;
-- 
2.37.3

