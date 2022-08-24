Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C39B59F1CC
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiHXDFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbiHXDEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:04:02 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0C082F82
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:38 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so10261583plg.23
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=rMoXSolEWYlHp+v96mZKFJynexqlvv3SUwP5I+VQ+V8=;
        b=Zf9Gyj0WqMWDgneHaEGBOobSZLNmStZUGaGfQlySxDCOt+n9hnQ6SQ+oqYsKh/16yB
         RHt2hOe6YsOvNHdgfYQf0ljJXNAXOtAdgErDG47/YS8OYN2FLXKp/9qpehsjH86oWwNX
         ggDZiYj+EM07qCEueO6VeKLmsWElA1F7VlhDkrkTnK0BGmXpuNL6YaCszDBxPKgeo51i
         9+zIq+xfzDTCcWnO5Y7HifhluuCWz/42ze6Wsfsyd1BKG5VjqndmGIzPes8R6F1T0nU4
         ULcy0nf088br3J/8F+yEil2PDF9T18/zhMAivNhJeaibyPAfJHubVLFyWrQbZ6fr26lK
         8DbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=rMoXSolEWYlHp+v96mZKFJynexqlvv3SUwP5I+VQ+V8=;
        b=fztMl1v7X5L8AI+PoHMfz9mNsgnf1+cZGTO2SlSPonPGQynAtVDE042dbLcj3hutwF
         +T18W9JrlZcREYbhKv9MYHMe+T6G8bn4hibciDFBCybNYcp/DI3TzR7id93EVldsgvM1
         DMTg50bXzDRZ5WOR9FqAeOL1zWHPr6TIQeJ/uSjRa+JERa55+jcdmLscanbymmhssYnc
         CR4wtqyXrvZhJPNxI9FWrqyzQ59+5NvZaCrFUhE9J1XFQ3dl61YkeBu0z9oNzoFsHaJY
         tQ+BamDhNiayk0MqbrxebTIZb31Li+sf1BjjQYlr7EP5O5i95HkvFz1DUdGkRszwalgl
         aOZA==
X-Gm-Message-State: ACgBeo1sCYxiS7sVacUdZJHCULhd+Rd2k+WpV0vSo8+vnZzUqLq4jxX2
        HsQYeE7au3X2p5UkZ5AePB05iTTpinc=
X-Google-Smtp-Source: AA6agR7n2gfoNE5bMBnpks0tULIJIfgJSTuV47gUOo3fJdzkNuU8jhzkFT3BjaeBiN1OCT9C124i+kryphQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e849:b0:16e:81c6:2cb7 with SMTP id
 t9-20020a170902e84900b0016e81c62cb7mr28170220plg.110.1661310157592; Tue, 23
 Aug 2022 20:02:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:36 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-35-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 34/36] KVM: nVMX: Use sanitized allowed-1 bits for VMX
 control MSRs
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

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Using raw host MSR values for setting up nested VMX control MSRs is
incorrect as some features need to disabled, e.g. when KVM runs as
a nested hypervisor on Hyper-V and uses Enlightened VMCS or when a
workaround for IA32_PERF_GLOBAL_CTRL is applied. For non-nested VMX, this
is done in setup_vmcs_config() and the result is stored in vmcs_config.
Use it for setting up allowed-1 bits in nested VMX MSRs too.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++------------------
 arch/x86/kvm/vmx/nested.h |  2 +-
 arch/x86/kvm/vmx/vmx.c    |  5 ++---
 3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4b8301137d75..6208cdebd173 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6567,8 +6567,10 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
  * bit in the high half is on if the corresponding bit in the control field
  * may be on. See also vmx_control_verify().
  */
-void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
+void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 {
+	struct nested_vmx_msrs *msrs = &vmcs_conf->nested;
+
 	/*
 	 * Note that as a general rule, the high half of the MSRs (bits in
 	 * the control fields which may be 1) should be initialized by the
@@ -6585,11 +6587,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	 */
 
 	/* pin-based controls */
-	rdmsr(MSR_IA32_VMX_PINBASED_CTLS,
-		msrs->pinbased_ctls_low,
-		msrs->pinbased_ctls_high);
 	msrs->pinbased_ctls_low =
 		PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR;
+
+	msrs->pinbased_ctls_high = vmcs_conf->pin_based_exec_ctrl;
 	msrs->pinbased_ctls_high &=
 		PIN_BASED_EXT_INTR_MASK |
 		PIN_BASED_NMI_EXITING |
@@ -6600,12 +6601,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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
@@ -6622,11 +6621,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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
@@ -6640,11 +6638,10 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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
@@ -6678,12 +6675,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
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
index 88b00a7359e4..6312c9541c3c 100644
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
index 6d346edf546b..c42b6646afa4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7396,7 +7396,7 @@ static int __init vmx_check_processor_compat(void)
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
 		return -EIO;
 	if (nested)
-		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
+		nested_vmx_setup_ctls_msrs(&vmcs_conf, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
 		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
 				smp_processor_id());
@@ -8351,8 +8351,7 @@ static __init int hardware_setup(void)
 	setup_default_sgx_lepubkeyhash();
 
 	if (nested) {
-		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
-					   vmx_capability.ept);
+		nested_vmx_setup_ctls_msrs(&vmcs_config, vmx_capability.ept);
 
 		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
 		if (r)
-- 
2.37.1.595.g718a3a8f04-goog

