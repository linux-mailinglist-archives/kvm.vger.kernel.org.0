Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1FBA44868
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbfFMRDl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:03:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35785 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393251AbfFMRDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id m3so2606118wrv.2;
        Thu, 13 Jun 2019 10:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ojA3W8k9I8vPPSeH5GZ2jyAxZEAAT9q5YsRhEh4hlCE=;
        b=tzJB29eXcJD2437uRGFxVoe5Xx8moIydk4eRNNc15lKIcWorEZLiJizy3J+/O0t5NK
         y1M4b+NvIAYcntxvA1eLWqMJHddWjfX0zrCRR9GStRqLLJHME7xQKDovEuaki9t/K74a
         3wgska6sHciwLMFncaN0jE3NkaM3PCKqnjqWQQJjLGy13YkxPSveP+42iYcdzfehqe8u
         lhi0M6THW7YnMc6VWJ6y2Z+Xex6BWbfT+mMpGPYGeKwdC/OA0UVrL0YayJBB/KPFd5Iq
         E9b9MlD8CE05lqA6bGiM+0h4Xkr7/GOVwQRXwrkZ7VQnnBxiRGT5EA/ZB1gBqZV5eJ7T
         H9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=ojA3W8k9I8vPPSeH5GZ2jyAxZEAAT9q5YsRhEh4hlCE=;
        b=EflMfBpY30HPpstVLzgi5dqPWzkFOs+n4Il+9Dt0+dVY8qwtkupgaVbwKjs/HbA/Zg
         XIJ/MQtZdaFk1tsWt7oEyl5bCWWTsS4+SChSjpptGIxe0Pc/yPJPC7VsByshcUh6X74p
         qouZ4S4XgsudlCQxGzPipOrjypgc6Z+RcvFhY6oRCWYNBcZOPjHpx/7NPMu/0oTElnUZ
         RjG6LQBQcB8kgq0UFWl+2+OPa4D6y/Mui9lhsyXFh5KPbpEQTU/PRcGiE0EjLJkBXhlZ
         Y11HXbYvQOtUZFPMx7sdxIhRpV9MraXdboD5xE9FtLJMXCGpz+MVKChOdOYh1dqOCaCg
         7jTA==
X-Gm-Message-State: APjAAAXJ17NQP8Jxs2JcmbgVoRgRFam5FuVLDvRYAIXdR9N7l0InSyp4
        ncoy1Y7LgNvqltCtXC9yFFlZz+Ii
X-Google-Smtp-Source: APXvYqyyoZvayotTBlrJ7qedzzhyjTSL+UiIrGyt926RivzA8E/LmnmDX6p2/BxZY6qE500YegQ/Iw==
X-Received: by 2002:adf:a749:: with SMTP id e9mr61664578wrd.64.1560445416545;
        Thu, 13 Jun 2019 10:03:36 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:36 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 06/43] KVM: VMX: Handle NMIs, #MCs and async #PFs in common irqs-disabled fn
Date:   Thu, 13 Jun 2019 19:02:52 +0200
Message-Id: <1560445409-17363-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Per commit 1b6269db3f833 ("KVM: VMX: Handle NMIs before enabling
interrupts and preemption"), NMIs are handled directly in vmx_vcpu_run()
to "make sure we handle NMI on the current cpu, and that we don't
service maskable interrupts before non-maskable ones".  The other
exceptions handled by complete_atomic_exit(), e.g. async #PF and #MC,
have similar requirements, and are located there to avoid extra VMREADs
since VMX bins hardware exceptions and NMIs into a single exit reason.

Clean up the code and eliminate the vaguely named complete_atomic_exit()
by moving the interrupts-disabled exception and NMI handling into the
existing handle_external_intrs() callback, and rename the callback to
a more appropriate name.  Rename VMexit handlers throughout so that the
atomic and non-atomic counterparts have similar names.

In addition to improving code readability, this also ensures the NMI
handler is run with the host's debug registers loaded in the unlikely
event that the user is debugging NMIs.  Accuracy of the last_guest_tsc
field is also improved when handling NMIs (and #MCs) as the handler
will run after updating said field.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
[Naming cleanups. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              |  4 ++--
 arch/x86/kvm/vmx/vmx.c          | 33 ++++++++++++++++++---------------
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35e7937cc9ac..f46a12a5cf2e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1117,7 +1117,7 @@ struct kvm_x86_ops {
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
-	void (*handle_external_intr)(struct kvm_vcpu *vcpu);
+	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
 	bool (*mpx_supported)(void);
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index acc09e9fc173..bbc31f7213ed 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6172,7 +6172,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void svm_handle_external_intr(struct kvm_vcpu *vcpu)
+static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	kvm_before_interrupt(vcpu);
 	local_irq_enable();
@@ -7268,7 +7268,7 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	.set_tdp_cr3 = set_tdp_cr3,
 
 	.check_intercept = svm_check_intercept,
-	.handle_external_intr = svm_handle_external_intr,
+	.handle_exit_irqoff = svm_handle_exit_irqoff,
 
 	.request_immediate_exit = __kvm_request_immediate_exit,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 963c8c409223..2b182f58c126 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4437,11 +4437,11 @@ static void kvm_machine_check(void)
 
 static int handle_machine_check(struct kvm_vcpu *vcpu)
 {
-	/* already handled by vcpu_run */
+	/* handled by vmx_vcpu_run() */
 	return 1;
 }
 
-static int handle_exception(struct kvm_vcpu *vcpu)
+static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -4454,7 +4454,7 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 	intr_info = vmx->exit_intr_info;
 
 	if (is_machine_check(intr_info) || is_nmi(intr_info))
-		return 1;  /* already handled by vmx_complete_atomic_exit */
+		return 1; /* handled by handle_exception_nmi_irqoff() */
 
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
@@ -5462,7 +5462,7 @@ static int handle_encls(struct kvm_vcpu *vcpu)
  * to be done to userspace and return 0.
  */
 static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
-	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception,
+	[EXIT_REASON_EXCEPTION_NMI]           = handle_exception_nmi,
 	[EXIT_REASON_EXTERNAL_INTERRUPT]      = handle_external_interrupt,
 	[EXIT_REASON_TRIPLE_FAULT]            = handle_triple_fault,
 	[EXIT_REASON_NMI_WINDOW]	      = handle_nmi_window,
@@ -6100,11 +6100,8 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	memset(vmx->pi_desc.pir, 0, sizeof(vmx->pi_desc.pir));
 }
 
-static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
+static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
-	if (vmx->exit_reason != EXIT_REASON_EXCEPTION_NMI)
-		return;
-
 	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* if exit due to PF check for async PF */
@@ -6123,7 +6120,7 @@ static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
 	}
 }
 
-static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
+static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	unsigned int vector;
 	unsigned long entry;
@@ -6133,9 +6130,6 @@ static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 	gate_desc *desc;
 	u32 intr_info;
 
-	if (to_vmx(vcpu)->exit_reason != EXIT_REASON_EXTERNAL_INTERRUPT)
-		return;
-
 	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if (WARN_ONCE(!is_external_intr(intr_info),
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
@@ -6170,7 +6164,17 @@ static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 
 	kvm_after_interrupt(vcpu);
 }
-STACK_FRAME_NON_STANDARD(vmx_handle_external_intr);
+STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
+
+static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		handle_external_interrupt_irqoff(vcpu);
+	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
+		handle_exception_nmi_irqoff(vmx);
+}
 
 static bool vmx_has_emulated_msr(int index)
 {
@@ -6540,7 +6544,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->loaded_vmcs->launched = 1;
 	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	vmx_complete_atomic_exit(vmx);
 	vmx_recover_nmi_blocking(vmx);
 	vmx_complete_interrupts(vmx);
 }
@@ -7694,7 +7697,7 @@ static __exit void hardware_unsetup(void)
 	.set_tdp_cr3 = vmx_set_cr3,
 
 	.check_intercept = vmx_check_intercept,
-	.handle_external_intr = vmx_handle_external_intr,
+	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 	.mpx_supported = vmx_mpx_supported,
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e2f53cd8ea8..432f9f8c3d42 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7999,7 +7999,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops->handle_external_intr(vcpu);
+	kvm_x86_ops->handle_exit_irqoff(vcpu);
 
 	++vcpu->stat.exits;
 
-- 
1.8.3.1


