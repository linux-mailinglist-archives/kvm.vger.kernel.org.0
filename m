Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15750555184
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376306AbiFVQpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376260AbiFVQoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:44:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2656D369D4
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 09:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655916293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vmcKRKhFN9648itaEmK7Pyh7ynz/iKVO54dtfVAWN7o=;
        b=ibJ48XqW5rq+grX/liewg54zQkRCDHyylWj/ABiqaQZRhD5wXCB/1pF88rjj7vLG98LKn1
        SvCxYwUZHVAIzDvcm2fZNl45LxC3hDjeTXXr1wLsCWSZ79h614JyiWPtNaBlGQTIgyVlYc
        urLzNoPTu2Y8nmyiYf32BwhfT8usal8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-KlhwBMv5MAixrQeESYeU8Q-1; Wed, 22 Jun 2022 12:44:49 -0400
X-MC-Unique: KlhwBMv5MAixrQeESYeU8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35CF1811E80;
        Wed, 22 Jun 2022 16:44:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D4CC40CFD0A;
        Wed, 22 Jun 2022 16:44:46 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 06/10] KVM: nVMX: Use sanitized allowed-1 bits for VMX control MSRs
Date:   Wed, 22 Jun 2022 18:44:28 +0200
Message-Id: <20220622164432.194640-7-vkuznets@redhat.com>
In-Reply-To: <20220622164432.194640-1-vkuznets@redhat.com>
References: <20220622164432.194640-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 34 ++++++++++++++++------------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  5 ++---
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7d8cd0ebcc75..8cc2187b5556 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6549,8 +6549,13 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
  * bit in the high half is on if the corresponding bit in the control field
  * may be on. See also vmx_control_verify().
  */
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
+void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 {
+	struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
+
+	/* Take the allowed-1 bits from KVM's sanitized VMCS configuration. */
+	u32 ignore_high;
+
 	/*
 	 * Note that as a general rule, the high half of the MSRs (bits in
 	 * the control fields which may be 1) should be initialized by the
@@ -6567,11 +6572,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	 */
 
 	/* pin-based controls */
-	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
-		msrs->pinbased_ctls_low,
-		msrs->pinbased_ctls_high);
+	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, msrs->pinbased_ctls_low, ignore_high);
 	msrs->pinbased_ctls_low |=
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
@@ -6582,12 +6587,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		PIN_BASED_VMX_PREEMPTION_TIMER;
 
 	/* exit controls */
-	rdmsr(MSR_IA32_VMX_EXIT_CTLS,
-		msrs->exit_ctls_low,
-		msrs->exit_ctls_high);
 	msrs->exit_ctls_low =
 		VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR;
 
+	msrs->exit_ctls_high = vmcs_conf->vmexit_ctrl;
 	msrs->exit_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_EXIT_HOST_ADDR_SPACE_SIZE |
@@ -6603,11 +6606,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->exit_ctls_low &= ~VM_EXIT_SAVE_DEBUG_CONTROLS;
 
 	/* entry controls */
-	rdmsr(MSR_IA32_VMX_ENTRY_CTLS,
-		msrs->entry_ctls_low,
-		msrs->entry_ctls_high);
 	msrs->entry_ctls_low =
 		VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->entry_ctls_high = vmcs_conf->vmentry_ctrl;
 	msrs->entry_ctls_high &=
 #ifdef CONFIG_X86_64
 		VM_ENTRY_IA32E_MODE |
@@ -6621,11 +6623,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	msrs->entry_ctls_low &= ~VM_ENTRY_LOAD_DEBUG_CONTROLS;
 
 	/* cpu-based controls */
-	rdmsr(MSR_IA32_VMX_PROCBASED_CTLS,
-		msrs->procbased_ctls_low,
-		msrs->procbased_ctls_high);
 	msrs->procbased_ctls_low =
 		CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->procbased_ctls_high = vmcs_conf->cpu_based_exec_ctrl;
 	msrs->procbased_ctls_high &=
 		CPU_BASED_INTR_WINDOW_EXITING |
 		CPU_BASED_NMI_WINDOW_EXITING | CPU_BASED_USE_TSC_OFFSETTING |
@@ -6659,12 +6660,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	 * depend on CPUID bits, they are added later by
 	 * vmx_vcpu_after_set_cpuid.
 	 */
-	if (msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
-		rdmsr(MSR_IA32_VMX_PROCBASED_CTLS2,
-		      msrs->secondary_ctls_low,
-		      msrs->secondary_ctls_high);
-
 	msrs->secondary_ctls_low = 0;
+
+	msrs->secondary_ctls_high = vmcs_conf->cpu_based_2nd_exec_ctrl;
 	msrs->secondary_ctls_high &=
 		SECONDARY_EXEC_DESC |
 		SECONDARY_EXEC_ENABLE_RDTSCP |
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index c92cea0b8ccc..fae047c6204b 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -17,7 +17,7 @@ enum nvmx_vmentry_status {
 };
 
 void vmx_leave_nested(struct kvm_vcpu *vcpu);
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps);
+void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps);
 void nested_vmx_hardware_unsetup(void);
 __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *));
 void nested_vmx_set_vmcs_shadowing_bitmap(void);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7aab9225c4c3..37d5c5bc4cd2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7368,7 +7368,7 @@ static int __init vmx_check_processor_compat(void)
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
 		return -EIO;
 	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
+		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
 		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
 				smp_processor_id());
@@ -8330,8 +8330,7 @@ static __init int hardware_setup(void)
 	setup_default_sgx_lepubkeyhash();
 
 	if (nested) {
-		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
-					   vmx_capability.ept);
+		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
 
 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)
-- 
2.35.3

