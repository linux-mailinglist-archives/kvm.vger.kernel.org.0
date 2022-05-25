Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703D6534597
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 23:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343905AbiEYVEz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 17:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344027AbiEYVEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 17:04:54 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373E3BA573
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:04:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id o21-20020aa79795000000b0051841039a63so8057454pfp.19
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rTk+kQv/DhUHKGEj1i4pX5+LtvnOz973xS0Whw/Q98g=;
        b=RFtPtJn9KDxsUbYxBjoB3gJDcTmRaiAfkqkiwg+RwPIwB6CJ4e7iZh7yUn8BTUiW/n
         sV+k9a0mUcslhj/xWFHXpdycRBH4k5GJmfbk95lyRyexQwuqDHuQrjlC5M9AWTjIx6fS
         kUr+9Qu1+XCKOWAIlpRwgA8AgXNKj2CdUWOQD72mclcXL5Yrarf9WWWY2mhSWcNS6JEi
         yz0VhohFOBovWUcwmMexirtUzLx18ont4vb+rhPl/kRhl3NkZ1E5c9fFyfisHkRtz1cp
         a64wVfYirqM/bY9RHf3EImPbCJfkwjKGt/8zH6yhXKCnYnwGipQNZAy3GVT4skpcASES
         Wnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rTk+kQv/DhUHKGEj1i4pX5+LtvnOz973xS0Whw/Q98g=;
        b=pL6eSuodbSt+IWahGWaNW7w/8PLqoJr1O4s4CpvsaEns3HTwd0RP8z/QB317EHocfQ
         pK4PUqTbID8W6Kz+PD1INMUknZvfa5G4XP1uN8Py33xehdmV4sG/6lv90gEHz5ilTbZQ
         ahkfZUf7MF3lSbAgL8bQ8YXXhKgOkTKhe3zD49kJXPXWt2rKwGxef1Ha+jgBzSR8uRUk
         HzsM0/xaiXWiJI1f6Gy+4hvhDIuvUGhtKQ+ntiOy11w/1gk01OLqIYocLZFe9wTo0rOE
         OhA58gpjIwmYKI/3fQrM8j4sQh8XcxLjwxyrMcW9At1lo7KaatgVTm+oFOZZT/FFb5PX
         us2w==
X-Gm-Message-State: AOAM533ETIqimT/XZ0DE+I2MoNOznM92hFEWVSA1i/2UymkeXkjXJImC
        dglhuSUMDpOc/MxYXraLIrWY8pCYCpg=
X-Google-Smtp-Source: ABdhPJyjHo0RNZ+CWfGHH+uOuTDcz2WuFcVLTXIUiG3R7JG7ghn5fEyPuW9gCYA0Zho5BOlksmCXUfYqfBk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr26303pje.0.1653512692196; Wed, 25 May
 2022 14:04:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 25 May 2022 21:04:46 +0000
In-Reply-To: <20220525210447.2758436-1-seanjc@google.com>
Message-Id: <20220525210447.2758436-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220525210447.2758436-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
 kvm_intel load time
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
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

Sanitize the VM-Entry/VM-Exit control pairs (load+load or load+clear)
during setup instead of checking both controls in a pair at runtime.  If
only one control is supported, KVM will report the associated feature as
not available, but will leave the supported control bit set in the VMCS
config, which could lead to corruption of host state.  E.g. if only the
VM-Entry control is supported and the feature is not dynamically toggled,
KVM will set the control in all VMCSes and load zeros without restoring
host state.

Note, while this is technically a bug fix, practically speaking no sane
CPU or VMM would support only one control.  KVM's behavior of checking
both controls is mostly pedantry.

Cc: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Lei Wang <lei4.wang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h | 13 ++++--------
 arch/x86/kvm/vmx/vmx.c          | 35 +++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index dc2cb8a16e76..464bf39e4835 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -97,20 +97,17 @@ static inline bool cpu_has_vmx_posted_intr(void)
 
 static inline bool cpu_has_load_ia32_efer(void)
 {
-	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_EFER) &&
-	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_EFER);
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_EFER;
 }
 
 static inline bool cpu_has_load_perf_global_ctrl(void)
 {
-	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
-	       (vmcs_config.vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
 static inline bool cpu_has_vmx_mpx(void)
 {
-	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_BNDCFGS) &&
-		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS);
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
 }
 
 static inline bool cpu_has_vmx_tpr_shadow(void)
@@ -377,7 +374,6 @@ static inline bool cpu_has_vmx_intel_pt(void)
 	rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
 	return (vmx_msr & MSR_IA32_VMX_MISC_INTEL_PT) &&
 		(vmcs_config.cpu_based_2nd_exec_ctrl & SECONDARY_EXEC_PT_USE_GPA) &&
-		(vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_RTIT_CTL) &&
 		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_RTIT_CTL);
 }
 
@@ -406,8 +402,7 @@ static inline bool vmx_pebs_supported(void)
 
 static inline bool cpu_has_vmx_arch_lbr(void)
 {
-	return (vmcs_config.vmexit_ctrl & VM_EXIT_CLEAR_IA32_LBR_CTL) &&
-		(vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL);
+	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_LBR_CTL;
 }
 
 static inline u64 vmx_get_perf_capabilities(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6927f6e8ec31..2ea256de9aba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2462,6 +2462,9 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
+#define VMCS_ENTRY_EXIT_PAIR(name, entry_action, exit_action) \
+	{ VM_ENTRY_##entry_action##_##name, VM_EXIT_##exit_action##_##name }
+
 static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
@@ -2473,6 +2476,24 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	int i;
+
+	/*
+	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
+	 * SAVE_IA32_PAT and SAVE_IA32_EFER are absent because KVM always
+	 * intercepts writes to PAT and EFER, i.e. never enables those controls.
+	 */
+	struct {
+		u32 entry_control;
+		u32 exit_control;
+	} vmcs_entry_exit_pairs[] = {
+		VMCS_ENTRY_EXIT_PAIR(IA32_PERF_GLOBAL_CTRL, LOAD, LOAD),
+		VMCS_ENTRY_EXIT_PAIR(IA32_PAT, LOAD, LOAD),
+		VMCS_ENTRY_EXIT_PAIR(IA32_EFER, LOAD, LOAD),
+		VMCS_ENTRY_EXIT_PAIR(BNDCFGS, LOAD, CLEAR),
+		VMCS_ENTRY_EXIT_PAIR(IA32_RTIT_CTL, LOAD, CLEAR),
+		VMCS_ENTRY_EXIT_PAIR(IA32_LBR_CTL, LOAD, CLEAR),
+	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
 	min = CPU_BASED_HLT_EXITING |
@@ -2614,6 +2635,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				&_vmentry_control) < 0)
 		return -EIO;
 
+	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
+		u32 n_ctrl = vmcs_entry_exit_pairs[i].entry_control;
+		u32 x_ctrl = vmcs_entry_exit_pairs[i].exit_control;
+
+		if (!(_vmentry_control & n_ctrl) == !(_vmexit_control & x_ctrl))
+			continue;
+
+		pr_warn_once("Inconsistent VM-Entry/VM-Exit pair, entry = %x, exit = %x\n",
+			     _vmentry_control & n_ctrl, _vmexit_control & x_ctrl);
+
+		_vmentry_control &= ~n_ctrl;
+		_vmexit_control &= ~x_ctrl;
+	}
+
 	/*
 	 * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
 	 * can't be used due to an errata where VM Exit may incorrectly clear
-- 
2.36.1.124.g0e6072fb45-goog

