Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D08B1A3D97
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 03:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgDJBDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 21:03:46 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50892 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgDJBDq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 21:03:46 -0400
Received: by mail-pj1-f67.google.com with SMTP id b7so214809pju.0;
        Thu, 09 Apr 2020 18:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EeQYxbvTeKI2BVQRT2aOOtI1jSNcFNNz19lVdiuGtjo=;
        b=NR3LliSb0NmRvkwkX6K7wUezSIjOzKfP7gJGADD/PBV/nI5KDnJYcAIAn2XL1yimeg
         DJaM77X2BS0toCZ8slmx4/orYPp4iS0+CIIRJnYw6FA/ZtkoV1GSPKYTJCximgbVfhTf
         y8Uf1kpG5VfxMTWRIm/tnHlP7y4wGmapdGxA+WhlksBEaDQ6Db2NBG7pAXkiOPi/zP3q
         vp2tHa3wBKrWwdFNN+24kJfUsjEMdweQSzH29Ran940zdyuWlGzOzfoSDQPm3i2RFPp6
         H0kVBCb6acocj11RZuyWNvRzZMoLvYo3vh7QatbSEFV98mha1e3TKMQnUtnSPwtQxYx1
         xDWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EeQYxbvTeKI2BVQRT2aOOtI1jSNcFNNz19lVdiuGtjo=;
        b=GEp2Sma4LqiGuDUNz3FqzE8CtpT+18SHbrUdO1xi82CCQ3QVFHiwBjyD8yMlVXsH4t
         bvF1n9agkBQ+9uisCFVXnt1oWt0yaKsABDNguqUDjfeq3/ZXeTOiWo9DoUvmsFafOQhq
         LTnOeAoIoLiBYsILnllwxNs5aAev2uMOpo1YPdP0VCIkKXMlbweXb+DlcXfi4JvQr3AA
         pRyXbo5jYkHJcybZC4Pql0KNQKZKHp0dz68i6al+0XM6CwpcZQchOnIoHTp4NzWGTrJc
         B2H7Ps/cBMrs/Cc8sv5qEXtxepw6tvFizoJJG3j4dPDZMW8AX7C2iVQ4Y4rnNxK+r6OB
         Tg4A==
X-Gm-Message-State: AGi0PuZ5yptaxeMu67/8yIqe0C4JmLrDPdktrGwAJ9YhIIQaYA+i270X
        QYlD2athGdEaS3MIiGAYW/y8rW+7
X-Google-Smtp-Source: APiQypKyQITZWkM0GCWB3H4MhFYc7wViYWzg3JhzUfyPnV03ktUpOCaa3XqWUdNpP9cVbSVU9INOaw==
X-Received: by 2002:a17:902:968a:: with SMTP id n10mr2292044plp.74.1586480623007;
        Thu, 09 Apr 2020 18:03:43 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id y3sm311180pfy.6.2020.04.09.18.03.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2020 18:03:42 -0700 (PDT)
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
Subject: [PATCH v2] KVM: X86: Ultra fast single target IPI fastpath
Date:   Fri, 10 Apr 2020 09:03:27 +0800
Message-Id: <1586480607-5408-1-git-send-email-wanpengli@tencent.com>
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
w/o fastpath -> ultra fastpath      4238 -> 3293  22.3% 

This also revises the performance data in commit 1e9e2622a1 (KVM: VMX: 
FIXED+PHYSICAL mode single target IPI fastpath), that testing adds
--overcommit cpu-pm=on to kvm-unit-tests guest which is unnecessary.

Tested-by: Haiwei Li <lihaiwei@tencent.com>
Cc: Haiwei Li <lihaiwei@tencent.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
v1 -> v2:
 * rebase on latest kvm/queue
 * update patch description

 arch/x86/include/asm/kvm_host.h |  6 +++---
 arch/x86/kvm/svm/svm.c          | 21 ++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c          | 19 +++++++++++++------
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c7da23a..e667cf3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1124,7 +1124,8 @@ struct kvm_x86_ops {
 	 */
 	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
 
-	void (*run)(struct kvm_vcpu *vcpu);
+	void (*run)(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion *exit_fastpath);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -1174,8 +1175,7 @@ struct kvm_x86_ops {
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage,
 			       struct x86_exception *exception);
-	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
-		enum exit_fastpath_completion *exit_fastpath);
+	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 27f4684..c019332 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3283,9 +3283,20 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	svm_complete_interrupts(svm);
 }
 
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
 bool __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
-static void svm_vcpu_run(struct kvm_vcpu *vcpu)
+static void svm_vcpu_run(struct kvm_vcpu *vcpu,
+	enum exit_fastpath_completion *exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -3388,6 +3399,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
+	*exit_fastpath = svm_exit_handlers_fastpath(vcpu);
 	/* Any pending NMI will happen here */
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
@@ -3719,13 +3731,8 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
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
index 1d2bb57..61a1725 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6354,8 +6354,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 }
 STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
 
-static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
-	enum exit_fastpath_completion *exit_fastpath)
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6363,9 +6362,6 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
 		handle_external_interrupt_irqoff(vcpu);
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		handle_exception_nmi_irqoff(vmx);
-	else if (!is_guest_mode(vcpu) &&
-		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
-		*exit_fastpath = handle_fastpath_set_msr_irqoff(vcpu);
 }
 
 static bool vmx_has_emulated_msr(int index)
@@ -6570,9 +6566,19 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
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
@@ -6737,6 +6743,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	*exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
 	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
 		kvm_machine_check();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3089aa4..eed31e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8409,7 +8409,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	kvm_x86_ops.run(vcpu);
+	kvm_x86_ops.run(vcpu, &exit_fastpath);
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
@@ -8441,7 +8441,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops.handle_exit_irqoff(vcpu, &exit_fastpath);
+	kvm_x86_ops.handle_exit_irqoff(vcpu);
 
 	/*
 	 * Consume any pending interrupts, including the possible source of
-- 
2.7.4

