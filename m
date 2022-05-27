Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C043536656
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 19:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354163AbiE0RHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 13:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346544AbiE0RHE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 13:07:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4515A6D849
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 10:07:03 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l14-20020a170902f68e00b001633979d821so3163373plg.9
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 10:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XII5Q10d7IHsakcWieNQERcqnrzaW3r3Psj82Eh20aM=;
        b=aoLBo78gEFsnTeaEtyl/yOVL8Nlif46gSYrgLxN+AxYSm6eLmAHzRamQ52sLcjj4gP
         7+Busc3BGlBQjxG2BxGhT/bt5YyxaX25hVC1F1PEe37LR/wTZllnnlkaU8ET66WXGciz
         t+UfNNWyiZGvQawZCzNfpaNeInXdzdZS96Uu5FjDPGgJrlmS9q+z8leELQzFhyLY2aES
         OPVe4QU6oaq1wXBKgI5+ckIW9pP5BAoIPJ0EdUztR9MYwUXAjyzGtKlgu+P2S/iLBPPn
         VcrHzkcyLm4wLyH3598hDlUDcU4pOUqnYwkDSQRt0SAiDA5RuFyceNt9Bp8v0M5B8gFl
         be8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XII5Q10d7IHsakcWieNQERcqnrzaW3r3Psj82Eh20aM=;
        b=1K9fc9Dh/4LOQYPwxqx7SZjyHXf3NWVgWAhxxXDKxni36FEzlhosa1ti3cktS80VsD
         hop3Jv+ydilEcYlXdsjze5yRdRrupqSFAdoIrqx/cks7xdaaG06ENYlP5rpjJFYgSbJe
         wRT9pa23OTgSOt3tDf/s4GDXuiCFNcHTot8qlOteuAy/Q13WXu4OZGi21CoRHtB6Ln5v
         a3tqa7VWOF5hIEAU1Yu6/TUxz+W0A0MRXBnTC8w4ICu4AFJUvz6SE623p5eISs+Fn8V9
         MB4Yfpm/EX6Kbm/WEpVXIGPXGidYJ+xWuHSj76LdgMPGI3uH7I+dxKDpt9D2CSVbaBCX
         3JTA==
X-Gm-Message-State: AOAM5339EkhOR0W3CgvpaCbKfddDlgTVW8YIFefbQtTWMquzIjbQA9jG
        FI27njy5/Sjiz44/ZHNIw2w7ed0Ajlk=
X-Google-Smtp-Source: ABdhPJxqoqZZBsn67a+/tmIpuPg4SlJS7NvBnjiLn5lus3F6VCY441LbmBbN2C6gA0x5Q95LyQVEGob22Nw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8608:b0:158:c532:d8b2 with SMTP id
 f8-20020a170902860800b00158c532d8b2mr43964184plo.46.1653671222592; Fri, 27
 May 2022 10:07:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 27 May 2022 17:06:57 +0000
In-Reply-To: <20220527170658.3571367-1-seanjc@google.com>
Message-Id: <20220527170658.3571367-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220527170658.3571367-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
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
 arch/x86/kvm/vmx/capabilities.h | 13 ++++---------
 arch/x86/kvm/vmx/vmx.c          | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 9 deletions(-)

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
index 6927f6e8ec31..a592b424fbbc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2473,6 +2473,24 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
+	} const vmcs_entry_exit_pairs[] = {
+		{ VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,	VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL },
+		{ VM_ENTRY_LOAD_IA32_PAT,		VM_EXIT_LOAD_IA32_PAT },
+		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
+		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
+		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_IA32_LBR_CTL,		VM_EXIT_CLEAR_IA32_LBR_CTL },
+	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
 	min = CPU_BASED_HLT_EXITING |
@@ -2614,6 +2632,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
2.36.1.255.ge46751e96f-goog

