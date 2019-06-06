Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBCC37506
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 15:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfFFNUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 09:20:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39274 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFNUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 09:20:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so2409779wma.4
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 06:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5l1ifIPMxkPDie8+8po0NGLOV7yVm256HAQz1ikU6d4=;
        b=VAEUKbPxT3ZWDB8yZlOq/iF2lvrHIujBmxdcdSY90/4vM7z8y4wCMnj83U8kKZq+0B
         SvS27hczrjpsjH+G4vCSNKCohcUfTzZd7Y85Xq10r73ZruDzB3wyBLxp/oWHOYD0MsyC
         aiGqQG6Hsu1cwwZKYwHf+vVsBD/7pLqq/fobUzORPXmDWHST/Q+wmJHmwcPiV1PD59GS
         LN4CPu4RNqN8Qm9tCiaJZOLXZIX3gDoEek8y+qcPzHnzdV/oevxCu7NL9XZIlSF4N+ZZ
         Ffn+VSRVxTW0H8If7BlalvmpF9wauxkScdjkvqAb97zWp98BP2IzqXKeJXHSKbycxHJP
         +0jQ==
X-Gm-Message-State: APjAAAWYYfSHPG4jaQ5GGd3/7FVboEV9Wh6rmF4ejSjnGB/1AFFEma8g
        aHHXuIksuznqfnBHcyHJQR2u2g==
X-Google-Smtp-Source: APXvYqwH2HWYOsOppOhNch2UDRALdXntC04r0PGjiPgnxAGZO8BjMwdzUNwDGow2DQkDCmLc+hkSDQ==
X-Received: by 2002:a1c:9c03:: with SMTP id f3mr24635238wme.87.1559827250902;
        Thu, 06 Jun 2019 06:20:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id t6sm2418627wrp.14.2019.06.06.06.20.50
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 06:20:50 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: VMX: Handle NMIs, #MCs and async #PFs in common
 irqs-disabled fn
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20190420055059.16816-1-sean.j.christopherson@intel.com>
 <20190420055059.16816-6-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <746c7e2c-176f-d772-e37d-41bb9f524dd6@redhat.com>
Date:   Thu, 6 Jun 2019 15:20:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190420055059.16816-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/19 07:50, Sean Christopherson wrote:
> Per commit 1b6269db3f833 ("KVM: VMX: Handle NMIs before enabling
> interrupts and preemption"), NMIs are handled directly in vmx_vcpu_run()
> to "make sure we handle NMI on the current cpu, and that we don't
> service maskable interrupts before non-maskable ones".  The other
> exceptions handled by complete_atomic_exit(), e.g. async #PF and #MC,
> have similar requirements, and are located there to avoid extra VMREADs
> since VMX bins hardware exceptions and NMIs into a single exit reason.
> 
> Clean up the code and eliminate the vaguely named complete_atomic_exit()
> by moving the interrupts-disabled exception and NMI handling into the
> existing handle_external_intrs() callback, and rename the callback to
> a more appropriate name.
> 
> In addition to improving code readability, this also ensures the NMI
> handler is run with the host's debug registers loaded in the unlikely
> event that the user is debugging NMIs.  Accuracy of the last_guest_tsc
> field is also improved when handling NMIs (and #MCs) as the handler
> will run after updating said field.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Very nice, just some changes I'd like to propose. "atomic" is Linux 
lingo for "irqs disabled", so I'd like to rename the handler to 
handle_exit_atomic so it has a correspondance with handle_exit.  
Likewise we could have handle_exception_nmi_atomic and 
handle_external_interrupt_atomic.

Putting everything together we get:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 35e7937cc9ac..b7d5935c1637 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1117,7 +1117,7 @@ struct kvm_x86_ops {
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage);
-	void (*handle_external_intr)(struct kvm_vcpu *vcpu);
+	void (*handle_exit_atomic)(struct kvm_vcpu *vcpu);
 	bool (*mpx_supported)(void);
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index acc09e9fc173..9c6458e60558 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6172,7 +6172,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
-static void svm_handle_external_intr(struct kvm_vcpu *vcpu)
+static void svm_handle_exit_atomic(struct kvm_vcpu *vcpu)
 {
 	kvm_before_interrupt(vcpu);
 	local_irq_enable();
@@ -7268,7 +7268,7 @@ static bool svm_need_emulation_on_page_fault(struct kvm_vcpu *vcpu)
 	.set_tdp_cr3 = set_tdp_cr3,
 
 	.check_intercept = svm_check_intercept,
-	.handle_external_intr = svm_handle_external_intr,
+	.handle_exit_atomic = svm_handle_exit_atomic,
 
 	.request_immediate_exit = __kvm_request_immediate_exit,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 963c8c409223..dfaa770b9bb3 100644
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
+		return 1; /* handled by handle_exception_nmi_atomic() */
 
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
+static void handle_exception_nmi_atomic(struct vcpu_vmx *vmx)
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
+static void handle_external_interrupt_atomic(struct kvm_vcpu *vcpu)
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
+STACK_FRAME_NON_STANDARD(handle_external_interrupt_atomic);
+
+static void vmx_handle_exit_atomic(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		handle_external_interrupt_atomic(vcpu);
+	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
+		handle_exception_nmi_atomic(vmx);
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
+	.handle_exit_atomic = vmx_handle_exit_atomic,
 	.mpx_supported = vmx_mpx_supported,
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e2f53cd8ea8..88489af13e96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7999,7 +7999,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_x86_ops->handle_external_intr(vcpu);
+	kvm_x86_ops->handle_exit_atomic(vcpu);
 
 	++vcpu->stat.exits;
 

