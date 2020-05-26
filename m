Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9801B1A0955
	for <lists+kvm@lfdr.de>; Tue,  7 Apr 2020 10:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgDGI2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 04:28:50 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50373 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbgDGI2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 04:28:49 -0400
Received: by mail-pj1-f66.google.com with SMTP id v13so435997pjb.0;
        Tue, 07 Apr 2020 01:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QwWmobyOdR5r+7JJZxSrwfB56TjLUl825BwGgH9NRNQ=;
        b=N2Rgae8zms+3LBxcOrnLBU6jO9Vokq7alwIwdkajm2FUP1feOjiHVPKSETTl9o9lJe
         e7OTGKpv440s5Lfcetiy6u8IiLz7+Y65DDE1Du0iTM9Jc128kZeLDcwZDP2wvDVveaIc
         7RE1k4T2JIo9iPgOk01c9xZ9YKhpy340rKlsPtWfXLmi3Rl4PlnuJxanwfKZO6hF/8M1
         F74iN54bpM1rgEA+G2heoGYtF9uMSouwpX+N28YAE6gIllNTnzbD3G8DzQ6dtk3f1XX+
         Ov0kmUIwGI1h6dIrIBQQX/RiKzAEJqbvWRGeU4xATH0LIQGyIeubVEtJ+ioJT0f5KCDv
         ZI7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QwWmobyOdR5r+7JJZxSrwfB56TjLUl825BwGgH9NRNQ=;
        b=bcMP05UarBvvw2ZLczV8sX8k1eoW4D+8Co1Jm3BDnZbseGIaG2D0bF2UU32Itc1Yv+
         NcGeXswQhpm/vzWU2E0xv/qYhUAthPgU4FHQhjvwsua81DXCJElScTbvcGEixYkRNMcH
         /8+r9eR7K6ekeiWwGefsxOWR0KvhCyI7M0H268YamJvWC6jzjhVgNxUpmFT7qfNAF8ZL
         D/cucOGbHjp1miUo8f0zFvVFU/ymByDwDAaz+2hGocZp+uq/DnnpffBTkst2ZEEnZWMr
         QX+5yi+JJzaO8twUkUHuSZpg/k4oLP5avbUDvYEm+NO9v+hKUHDW/Pi3zwv/F0YmDQe0
         SDgA==
X-Gm-Message-State: AGi0PuYiNAA8xo0camTArksjQVK+BSZMumlpUc+bOCzE1lqlpJpUWQIz
        bkBRGCfCoBraFEyAzAj6byOsIZbq01Y=
X-Google-Smtp-Source: APiQypJ4MXFHCvLmE8SCVaL1WlvfgUE4X19jgukoo7Kk6ggpuOGHWgDPmWpJtOQeHusGT0nP3uKCxA==
X-Received: by 2002:a17:902:8ec1:: with SMTP id x1mr1381741plo.325.1586248128475;
        Tue, 07 Apr 2020 01:28:48 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id h2sm13520526pfr.220.2020.04.07.01.28.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Apr 2020 01:28:48 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: [PATCH] KVM: X86: Ultra fast single target IPI fastpath
Date:   Tue,  7 Apr 2020 16:28:38 +0800
Message-Id: <1586248118-19607-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

IPI and Timer cause the main MSRs write vmexits in cloud environment 
observation, let's optimize virtual IPI latency more aggressively to 
inject target IPI as soon as possible.

Running kvm-unit-tests/vmexit.flat IPI testing on SKX server, disable 
adaptive advance lapic timer and adaptive halt-polling to avoid the 
interference, this patch can give another 7% improvement.

w/o fastpath -> fastpath            4238 -> 3543  16.4%
fastpath     -> ultra fastpath      3543 -> 3293     7%
w/o fastpath -> ultra fastpath      4338 -> 3293    24%

This also revises the performance data in commit 1e9e2622a1 (KVM: VMX: 
FIXED+PHYSICAL mode single target IPI fastpath), that testing exposes
mwait to kvm-unit-tests guest which is unnecessary.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/svm.c              | 21 ++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++------
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 42a2d0d..932162f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1114,7 +1114,8 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
 
-	void (*run)(struct kvm_vcpu *vcpu);
+	void (*run)(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion *exit_fastpath);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -1164,8 +1165,7 @@ struct kvm_x86_ops {
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage,
 			       struct x86_exception *exception);
-	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
-		enum exit_fastpath_completion *exit_fastpath);
+	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 851e9cc..683474b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5755,7 +5755,18 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
-static void svm_vcpu_run(struct kvm_vcpu *vcpu)
+static enum exit_fastpath_completion svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu) &&
+	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
+	    to_svm(vcpu)->vmcb->control.exit_info_1)
+		return handle_fastpath_set_msr_irqoff(vcpu);
+
+	return EXIT_FASTPATH_NONE;
+}
+
+static void svm_vcpu_run(struct kvm_vcpu *vcpu,
+	enum exit_fastpath_completion *exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -5946,6 +5957,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
+	*exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 	/* Any pending NMI will happen here */
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
@@ -6277,13 +6289,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion *exit_fastpath)
+static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
-	if (!is_guest_mode(vcpu) &&
-	    to_svm(vcpu)->vmcb->control.exit_code == SVM_EXIT_MSR &&
-	    to_svm(vcpu)->vmcb->control.exit_info_1)
-		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91749f1..14d7a74 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6279,8 +6279,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 }
 STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion *exit_fastpath)
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6288,9 +6287,6 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
-	else if (!is_guest_mode(vcpu) &&
-		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
 static bool vmx_has_emulated_msr(int index)
@@ -6495,9 +6491,19 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
+{
+	if (!is_guest_mode(vcpu) &&
+		to_vmx(vcpu)->exit_reason == EXIT_REASON_MSR_WRITE)
+		return handle_fastpath_set_msr_irqoff(vcpu);
+
+	return EXIT_FASTPATH_NONE;
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
-static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_run(struct kvm_vcpu *vcpu,
+	enum exit_fastpath_completion *exit_fastpath)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
@@ -6662,6 +6668,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	*exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
 	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
 		kvm_machine_check();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8124b56..99f9a1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8392,7 +8392,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	kvm_x86_ops.run(vcpu);
+	kvm_x86_ops.run(vcpu, &exit_fastpath);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -8424,7 +8424,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops.handle_exit_irqoff(vcpu, &exit_fastpath);
+	kvm_x86_ops.handle_exit_irqoff(vcpu);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of
-- 
2.7.4

