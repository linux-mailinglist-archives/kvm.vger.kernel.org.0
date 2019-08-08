Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0C98680F
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 19:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404388AbfHHRbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 13:31:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45026 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404364AbfHHRbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 13:31:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id p17so95699850wrf.11
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 10:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y//4rB2wtH2r+DHu+gdcgf9yPOsivJZSDgyXfNjoBv4=;
        b=L6dxNFnF1jFQlGg7wMUP3g4uBR9lX3rqsXpEemIiKg1Fsi0umpAZe96HlQXdpOAF1v
         NQlXnKqV42cOHpCwvGfpKayOshviOgwY5Xqixjt0+XErQ4jzb0KmWqLpOTg/JYBoRcjl
         hpaRTkI4bIEMbTDOhB1FGHMF7/Yns7F/nt6Em9O53jwQz5yczImOOLda/novaeAiaxAP
         7bilVl7wxYoIEy30/I8d6R1/EjvUi9YNHtZ9PekKd/GZiPmc2DDFHQIh3TDDcba3iEqd
         Gd3qJfe4aczZzrTc0uKb0EB7CXdIZedoCIy05ys44YcwR5Vp52v+dSOHCZOdr+WIEE7H
         QGIA==
X-Gm-Message-State: APjAAAU0bl7jirhcF8ZjnDa/uEExXpbdFfdg0w0B54nV6Ixn4tL8pSt+
        6FpZvGTDF37SYc9/tE5NRHUwjK5KcGg=
X-Google-Smtp-Source: APXvYqz+vpexVa+8nqHfUQ3sGOq25u6fIEK/8LsIT3eQaXAR1avY+v3g7QViFfV7loCf3SH+gWzRxQ==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr13341250wrw.73.1565285458172;
        Thu, 08 Aug 2019 10:30:58 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id g25sm2136859wmk.39.2019.08.08.10.30.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 10:30:57 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v3 2/7] x86: kvm: svm: propagate errors from skip_emulated_instruction()
Date:   Thu,  8 Aug 2019 19:30:46 +0200
Message-Id: <20190808173051.6359-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190808173051.6359-1-vkuznets@redhat.com>
References: <20190808173051.6359-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On AMD, kvm_x86_ops->skip_emulated_instruction(vcpu) can, in theory,
fail: in !nrips case we call kvm_emulate_instruction(EMULTYPE_SKIP).
Currently, we only do printk(KERN_DEBUG) when this happens and this
is not ideal. Propagate the error up the stack.

On VMX, skip_emulated_instruction() doesn't fail, we have two call
sites calling it explicitly: handle_exception_nmi() and
handle_task_switch(), we can just ignore the result.

On SVM, we also have two explicit call sites:
svm_queue_exception() and it seems we don't need to do anything there as
we check if RIP was advanced or not. In task_switch_interception(),
however, we are better off not proceeding to kvm_task_switch() in case
skip_emulated_instruction() failed.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm.c              | 36 ++++++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.c          |  8 +++++---
 arch/x86/kvm/x86.c              |  6 ++++--
 4 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b0a4ee77313..f9e6d0b0f581 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1068,7 +1068,7 @@ struct kvm_x86_ops {
 
 	void (*run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu);
-	void (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
+	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
 	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7e843b340490..8299b0de06e2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -770,7 +770,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -779,18 +779,17 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 		svm->next_rip = svm->vmcb->control.next_rip;
 	}
 
-	if (!svm->next_rip) {
-		if (kvm_emulate_instruction(vcpu, EMULTYPE_SKIP) !=
-				EMULATE_DONE)
-			printk(KERN_DEBUG "%s: NOP\n", __func__);
-		return;
-	}
+	if (!svm->next_rip)
+		return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
+
 	if (svm->next_rip - kvm_rip_read(vcpu) > MAX_INST_SIZE)
 		printk(KERN_ERR "%s: ip 0x%lx next 0x%llx\n",
 		       __func__, kvm_rip_read(vcpu), svm->next_rip);
 
 	kvm_rip_write(vcpu, svm->next_rip);
 	svm_set_interrupt_shadow(vcpu, 0);
+
+	return EMULATE_DONE;
 }
 
 static void svm_queue_exception(struct kvm_vcpu *vcpu)
@@ -821,7 +820,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 * raises a fault that is not intercepted. Still better than
 		 * failing in all cases.
 		 */
-		skip_emulated_instruction(&svm->vcpu);
+		(void)skip_emulated_instruction(&svm->vcpu);
 		rip = kvm_rip_read(&svm->vcpu);
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
@@ -3899,20 +3898,25 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	if (reason != TASK_SWITCH_GATE ||
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
-	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR)))
-		skip_emulated_instruction(&svm->vcpu);
+	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
+		if (skip_emulated_instruction(&svm->vcpu) != EMULATE_DONE)
+			goto fail;
+	}
 
 	if (int_type != SVM_EXITINTINFO_TYPE_SOFT)
 		int_vec = -1;
 
 	if (kvm_task_switch(&svm->vcpu, tss_selector, int_vec, reason,
-				has_error_code, error_code) == EMULATE_FAIL) {
-		svm->vcpu.run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		svm->vcpu.run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		svm->vcpu.run->internal.ndata = 0;
-		return 0;
-	}
+				has_error_code, error_code) == EMULATE_FAIL)
+		goto fail;
+
 	return 1;
+
+fail:
+	svm->vcpu.run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	svm->vcpu.run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	svm->vcpu.run->internal.ndata = 0;
+	return 0;
 }
 
 static int cpuid_interception(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 074385c86c09..2579e7a6d59d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1473,7 +1473,7 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 }
 
 
-static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rip;
 
@@ -1483,6 +1483,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 
 	/* skipping an emulated instruction also counts */
 	vmx_set_interrupt_shadow(vcpu, 0);
+
+	return EMULATE_DONE;
 }
 
 static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
@@ -4547,7 +4549,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			vcpu->arch.dr6 &= ~DR_TRAP_BITS;
 			vcpu->arch.dr6 |= dr6 | DR6_RTM;
 			if (is_icebp(intr_info))
-				skip_emulated_instruction(vcpu);
+				(void)skip_emulated_instruction(vcpu);
 
 			kvm_queue_exception(vcpu, DB_VECTOR);
 			return 1;
@@ -5057,7 +5059,7 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 	if (!idt_v || (type != INTR_TYPE_HARD_EXCEPTION &&
 		       type != INTR_TYPE_EXT_INTR &&
 		       type != INTR_TYPE_NMI_INTR))
-		skip_emulated_instruction(vcpu);
+		(void)skip_emulated_instruction(vcpu);
 
 	if (kvm_task_switch(vcpu, tss_selector,
 			    type == INTR_TYPE_SOFT_INTR ? idt_index : -1, reason,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6d951cbd76c..a97818b1111d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6383,9 +6383,11 @@ static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
-	int r = EMULATE_DONE;
+	int r;
 
-	kvm_x86_ops->skip_emulated_instruction(vcpu);
+	r = kvm_x86_ops->skip_emulated_instruction(vcpu);
+	if (r != EMULATE_DONE)
+		return 0;
 
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
-- 
2.20.1

