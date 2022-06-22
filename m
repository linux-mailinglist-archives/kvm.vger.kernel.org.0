Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEC3455518F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 18:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376690AbiFVQpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376604AbiFVQpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 12:45:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B15D39168
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 09:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655916297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8vrDYrcPrwgVhtqMnVmFlg3M56KevQMzRCP3HTMVToQ=;
        b=fasHDuxUaaV+85TSQ/cfNuXXfIM3TxExlAm1oXqAZ6LuH7MWywevcHxYgm3Gz31IpHZzrX
        W/X22melVKjrkHMTxYNFKDmOpjGKMSNIrTNCv6lsIPVClnN4J3bBnpx1QNUGZVPXq/txHT
        3pWtkXy5dixAjJA1tr8cCVdeEzcbiLs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647-AjmGu4D1OviUmzmqzELfEA-1; Wed, 22 Jun 2022 12:44:52 -0400
X-MC-Unique: AjmGu4D1OviUmzmqzELfEA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CF241C068C0;
        Wed, 22 Jun 2022 16:44:51 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9611B40CFD0A;
        Wed, 22 Jun 2022 16:44:49 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 07/10] KVM: VMX: Store required-1 VMX controls in vmcs_config
Date:   Wed, 22 Jun 2022 18:44:29 +0200
Message-Id: <20220622164432.194640-8-vkuznets@redhat.com>
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
index 37d5c5bc4cd2..05a9919a2fec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2411,7 +2411,7 @@ static bool cpu_has_sgx(void)
 }
 
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32 *result)
+				      u32 msr, u32 *result_high, u32 *result_low)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -2425,7 +2425,8 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	if (ctl_min & ~ctl)
 		return -EIO;
 
-	*result = ctl;
+	*result_high = ctl;
+	*result_low = vmx_msr_low;
 	return 0;
 }
 
@@ -2449,6 +2450,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
@@ -2494,7 +2500,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
 	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
-				&_cpu_based_exec_control) < 0)
+				&_cpu_based_exec_control,
+				&_cpu_based_exec_control_low) < 0)
 		return -EIO;
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
 		min2 = 0;
@@ -2526,7 +2533,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
 		if (adjust_vmx_controls(min2, opt2,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
-					&_cpu_based_2nd_exec_control) < 0)
+					&_cpu_based_2nd_exec_control,
+					&_cpu_based_2nd_exec_control_low) < 0)
 			return -EIO;
 	}
 #ifndef CONFIG_X86_64
@@ -2591,14 +2599,15 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_EXIT_PT_CONCEAL_PIP |
 	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
-				&_vmexit_control) < 0)
+				&_vmexit_control, &_vmexit_control_low) < 0)
 		return -EIO;
 
 	min = PIN_BASED_EXT_INTR_MASK | PIN_BASED_NMI_EXITING;
 	opt = PIN_BASED_VIRTUAL_NMIS | PIN_BASED_POSTED_INTR |
 		 PIN_BASED_VMX_PREEMPTION_TIMER;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PINBASED_CTLS,
-				&_pin_based_exec_control) < 0)
+				&_pin_based_exec_control,
+				&_pin_based_exec_control_low) < 0)
 		return -EIO;
 
 	if (cpu_has_broken_vmx_preemption_timer())
@@ -2618,7 +2627,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	      VM_ENTRY_PT_CONCEAL_PIP |
 	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
 	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
-				&_vmentry_control) < 0)
+				&_vmentry_control, &_vmentry_control_low) < 0)
 		return -EIO;
 
 	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
@@ -2684,11 +2693,16 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	if (enlightened_vmcs)
-- 
2.35.3

