Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC83F56043D
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 17:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiF2PIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 11:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234154AbiF2PHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 11:07:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 626EC3057B
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 08:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656515258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBbw1UKmccXfEbr/MTrAVgfGbgpa91NSLP1Z6HU0AuY=;
        b=eLEO534d2djD+NVSaTyUYhgTl6KeUH8o5Hvp/jnItwunJ/qKXQl6tJ7DtQsevdxezwT2t+
        P8xblqtQ8mVN4Sa2z6OAR/2+plzTSTrBBru28uR7LwWzFHyi3dqSzssQ/41jcx1xztbCZe
        M81pxxJxfnXJtnt4UeqiWgtEF/6jjRc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-C8MiYaDLOxSeiAElkqd0-g-1; Wed, 29 Jun 2022 11:07:32 -0400
X-MC-Unique: C8MiYaDLOxSeiAElkqd0-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37E41811E84;
        Wed, 29 Jun 2022 15:07:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 655E540EC002;
        Wed, 29 Jun 2022 15:07:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 25/28] KVM: VMX: Store required-1 VMX controls in vmcs_config
Date:   Wed, 29 Jun 2022 17:06:22 +0200
Message-Id: <20220629150625.238286-26-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-1-vkuznets@redhat.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While constructing nested VMX MSRs values, nested_vmx_setup_ctls_msrs()
has to re-read host VMX control MSRs to get required-1 bits which are not
stored anywhre. Add this missing information to vmcs_config.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 28 +++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 069d8d298e1d..2e223440e7ed 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -60,11 +60,16 @@ struct vmcs_config {
 	u32 basic_cap;
 	u32 revision_id;
 	u32 pin_based_exec_ctrl;
+	u32 pin_based_exec_ctrl_req1;
 	u32 cpu_based_exec_ctrl;
+	u32 cpu_based_exec_ctrl_req1;
 	u32 cpu_based_2nd_exec_ctrl;
+	u32 cpu_based_2nd_exec_ctrl_req1;
 	u64 cpu_based_3rd_exec_ctrl;
 	u32 vmexit_ctrl;
+	u32 vmexit_ctrl_req1;
 	u32 vmentry_ctrl;
+	u32 vmentry_ctrl_req1;
 	struct nested_vmx_msrs nested;
 };
 extern struct vmcs_config vmcs_config;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d4158b7421c..c195c159738d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2442,7 +2442,7 @@ static bool cpu_has_perf_global_ctrl_bug(void)
 
 
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32 *result)
+				      u32 msr, u32 *result_high, u32 *result_low)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -2456,7 +2456,8 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	if (ctl_min & ~ctl)
 		return -EIO;
 
-	*result = ctl;
+	*result_high = ctl;
+	*result_low = vmx_msr_low;
 	return 0;
 }
 
@@ -2479,6 +2480,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u32 _pin_based_exec_control_low = 0;
+	u32 _cpu_based_exec_control_low = 0;
+	u32 _cpu_based_2nd_exec_control_low = 0;
+	u32 _vmexit_control_low = 0;
+	u32 _vmentry_control_low = 0;
 	int i;
 
 	/*
@@ -2502,13 +2508,15 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (adjust_vmx_controls(KVM_REQ_VMX_CPU_BASED_VM_EXEC_CONTROL,
 				KVM_OPT_VMX_CPU_BASED_VM_EXEC_CONTROL,
 				MSR_IA32_VMX_PROCBASED_CTLS,
-				&_cpu_based_exec_control) < 0)
+				&_cpu_based_exec_control,
+				&_cpu_based_exec_control_low) < 0)
 		return -EIO;
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		if (adjust_vmx_controls(KVM_REQ_VMX_SECONDARY_VM_EXEC_CONTROL,
 					KVM_OPT_VMX_SECONDARY_VM_EXEC_CONTROL,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
-					&_cpu_based_2nd_exec_control) < 0)
+					&_cpu_based_2nd_exec_control,
+					&_cpu_based_2nd_exec_control_low) < 0)
 			return -EIO;
 	}
 #ifndef CONFIG_X86_64
@@ -2559,13 +2567,14 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (adjust_vmx_controls(KVM_REQ_VMX_VM_EXIT_CONTROLS,
 				KVM_OPT_VMX_VM_EXIT_CONTROLS,
 				MSR_IA32_VMX_EXIT_CTLS,
-				&_vmexit_control) < 0)
+				&_vmexit_control, &_vmexit_control_low) < 0)
 		return -EIO;
 
 	if (adjust_vmx_controls(KVM_REQ_VMX_PIN_BASED_VM_EXEC_CONTROL,
 				KVM_OPT_VMX_PIN_BASED_VM_EXEC_CONTROL,
 				MSR_IA32_VMX_PINBASED_CTLS,
-				&_pin_based_exec_control) < 0)
+				&_pin_based_exec_control,
+				&_pin_based_exec_control_low) < 0)
 		return -EIO;
 
 	if (cpu_has_broken_vmx_preemption_timer())
@@ -2577,7 +2586,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (adjust_vmx_controls(KVM_REQ_VMX_VM_ENTRY_CONTROLS,
 				KVM_OPT_VMX_VM_ENTRY_CONTROLS,
 				MSR_IA32_VMX_ENTRY_CTLS,
-				&_vmentry_control) < 0)
+				&_vmentry_control, &_vmentry_control_low) < 0)
 		return -EIO;
 
 	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
@@ -2619,11 +2628,16 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	vmcs_conf->revision_id = vmx_msr_low;
 
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
+	vmcs_conf->pin_based_exec_ctrl_req1 = _pin_based_exec_control_low;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;
+	vmcs_conf->cpu_based_exec_ctrl_req1 = _cpu_based_exec_control_low;
 	vmcs_conf->cpu_based_2nd_exec_ctrl = _cpu_based_2nd_exec_control;
+	vmcs_conf->cpu_based_2nd_exec_ctrl_req1 = _cpu_based_2nd_exec_control_low;
 	vmcs_conf->cpu_based_3rd_exec_ctrl = _cpu_based_3rd_exec_control;
 	vmcs_conf->vmexit_ctrl         = _vmexit_control;
+	vmcs_conf->vmexit_ctrl_req1         = _vmexit_control_low;
 	vmcs_conf->vmentry_ctrl        = _vmentry_control;
+	vmcs_conf->vmentry_ctrl_req1        = _vmentry_control_low;
 
 	return 0;
 }
-- 
2.35.3

