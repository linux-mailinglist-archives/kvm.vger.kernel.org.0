Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB6F1008F
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 22:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfD3UHv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 16:07:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34716 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfD3UHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 16:07:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id v16so20031970wrp.1;
        Tue, 30 Apr 2019 13:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=Z/HFjTOh/3CdZ3UVE0ErCrPNNxCXH36/qLcmZTzyrJA=;
        b=L1NFbfGAsbxtbEt7RARRI3NiyPhWAtmPbb79nFNnp+P2sgKTRICx5gAjw+QD66i26H
         zRm2sSaYiqyaA/L/PF1ynt++JWw3SNOa9nrNsRgN3xrPDUnBe6Jdgn2YzKfo+vGcbwH4
         aaQleggLkIMcvrwgygbjGi35w3QlOzW3y4g5xzU5Khgi/fbd2poFUwaL7+WU//g09sY4
         v5XeSOZ0qIJGU1oJFhieBLdWSj1/jTOKyKVECQ7eDs7H/ar4/LcIRwsffwydpkqRusIO
         Kz0ZHfgRQ6H8+sAeUKkC932AgwMh0bmiqR4Nrc/wenILFiqkvMP1pipv6L2pB0FOf47a
         VfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=Z/HFjTOh/3CdZ3UVE0ErCrPNNxCXH36/qLcmZTzyrJA=;
        b=Al4koBcfdMedb/w0XnuBSoh1U2fy1AXuoFvLfyVSKzeFQezrSiM8eZ4T3FV4Sjpmno
         cQ6DXmPbmcaBKBi3xsF3EOdPv4VZVADdfttjpBwZQF0aCJImVk1ivBX/H1HMT0JILcQQ
         vDFeYuMOqW2wUOPcctGLPqn007gK7vSF9I6Q+KlCNr2iTQ7VnyJz833eI2P+mS0X2TDC
         pqDoLk6Q5ZMReQPUDfu+VlURIMgz8chRhixXwQG1na+pCcCGeqoaA3faxpTF6FvtLwbG
         NUBNe3tJNm4ArZFCTSvcsvb/mBq8SXJq9hGOAAdMMN99Jr1vinbfceAiRx06bVffO3Ab
         aHAQ==
X-Gm-Message-State: APjAAAW9n7z0TPpVMYKCsjTJ+AwAWEXHwsGHsiY6W4IsYIRcrN2qL31l
        7jIRsb3EpFZ9ae+uFnGZwyf0iYcd
X-Google-Smtp-Source: APXvYqzOGh6taErAAXoHR5RqMXHMedfz3ZqyEZ3yqe3YPV2yASfdOffPeWCKPJYM4HZSYppBnnGLcQ==
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr7021478wrs.142.1556654868383;
        Tue, 30 Apr 2019 13:07:48 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id y133sm5022955wmd.2.2019.04.30.13.07.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 13:07:47 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM: x86: use direct accessors for RIP and RSP
Date:   Tue, 30 Apr 2019 22:07:45 +0200
Message-Id: <1556654865-45045-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use specific inline functions for RIP and RSP instead of
going through kvm_register_read and kvm_register_write,
which are quite a mouthful.  kvm_rsp_read and kvm_rsp_write
did not exist, so add them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 10 ++++++++++
 arch/x86/kvm/svm.c            |  8 ++++----
 arch/x86/kvm/vmx/nested.c     | 12 ++++++------
 arch/x86/kvm/x86.c            |  4 ++--
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index d179b7d7860d..1cc6c47dc77e 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -65,6 +65,16 @@ static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
 	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
 }
 
+static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
+{
+	return kvm_register_read(vcpu, VCPU_REGS_RSP);
+}
+
+static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	kvm_register_write(vcpu, VCPU_REGS_RSP, val);
+}
+
 static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
 {
 	might_sleep();  /* on svm */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 38aef3439799..893686cb0044 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3389,8 +3389,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 		(void)kvm_set_cr3(&svm->vcpu, hsave->save.cr3);
 	}
 	kvm_rax_write(&svm->vcpu, hsave->save.rax);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, hsave->save.rsp);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, hsave->save.rip);
+	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
+	kvm_rip_write(&svm->vcpu, hsave->save.rip);
 	svm->vmcb->save.dr7 = 0;
 	svm->vmcb->save.cpl = 0;
 	svm->vmcb->control.exit_int_info = 0;
@@ -3497,8 +3497,8 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RSP, nested_vmcb->save.rsp);
-	kvm_register_write(&svm->vcpu, VCPU_REGS_RIP, nested_vmcb->save.rip);
+	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
+	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
 	svm->vmcb->save.rax = nested_vmcb->save.rax;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d97dbea150ba..04b40a98f60b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2372,8 +2372,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (!enable_ept)
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
-	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->guest_rsp);
-	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->guest_rip);
+	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
+	kvm_rip_write(vcpu, vmcs12->guest_rip);
 	return 0;
 }
 
@@ -3401,8 +3401,8 @@ static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
 	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
 
-	vmcs12->guest_rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
-	vmcs12->guest_rip = kvm_register_read(vcpu, VCPU_REGS_RIP);
+	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
+	vmcs12->guest_rip = kvm_rip_read(vcpu);
 	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
 
 	vmcs12->guest_es_selector = vmcs_read16(GUEST_ES_SELECTOR);
@@ -3585,8 +3585,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vcpu->arch.efer &= ~(EFER_LMA | EFER_LME);
 	vmx_set_efer(vcpu, vcpu->arch.efer);
 
-	kvm_register_write(vcpu, VCPU_REGS_RSP, vmcs12->host_rsp);
-	kvm_register_write(vcpu, VCPU_REGS_RIP, vmcs12->host_rip);
+	kvm_rsp_write(vcpu, vmcs12->host_rsp);
+	kvm_rip_write(vcpu, vmcs12->host_rip);
 	vmx_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	vmx_set_interrupt_shadow(vcpu, 0);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b352a7c137cd..dc621f73e96b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8290,7 +8290,7 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	regs->rdx = kvm_rdx_read(vcpu);
 	regs->rsi = kvm_rsi_read(vcpu);
 	regs->rdi = kvm_rdi_read(vcpu);
-	regs->rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
+	regs->rsp = kvm_rsp_read(vcpu);
 	regs->rbp = kvm_rbp_read(vcpu);
 #ifdef CONFIG_X86_64
 	regs->r8 = kvm_r8_read(vcpu);
@@ -8326,7 +8326,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	kvm_rdx_write(vcpu, regs->rdx);
 	kvm_rsi_write(vcpu, regs->rsi);
 	kvm_rdi_write(vcpu, regs->rdi);
-	kvm_register_write(vcpu, VCPU_REGS_RSP, regs->rsp);
+	kvm_rsp_write(vcpu, regs->rsp);
 	kvm_rbp_write(vcpu, regs->rbp);
 #ifdef CONFIG_X86_64
 	kvm_r8_write(vcpu, regs->r8);
-- 
1.8.3.1

