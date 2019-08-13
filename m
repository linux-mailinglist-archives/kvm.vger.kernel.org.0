Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEBC8BADA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfHMNyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 09:54:03 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34369 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbfHMNxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 09:53:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id 31so107879587wrm.1
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 06:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nvxS4qmSvD/bAOI0A3gCRZ4/snx5GdjWoBeh7enAi+M=;
        b=A8xD3eMhjD1FptN+pktii9EvQrCx8inyQDPpv1yMz7Z9TCvujlJnkAeirlvg0IJRs8
         /Yl3cwYUoiFwkSGFt0DPgap/8JLDS4o01aDYfxP7XsFJ2Lujeo802OMmK2RLZi6fp1zz
         7ctkJZ1AIEAVIcpvSc3z9+PQ0RI0T/ho5UKs3Yb5XmohgqFprWVZ2ntDPwJtPTcV1Oox
         L1rJP8R5nYe8zcuoKzb9u/YNP7ypFS5shEgjbehNhDpPMgZ9gLKPfO8HHHktpTuLAP7p
         mnsmuOfX8NdJZ7h8aG8s9Jz4kwSRoMVNFi58NnCF3Raeg6HPlIHYEPvdO44O2taMjvyI
         HvzQ==
X-Gm-Message-State: APjAAAXF55NxafuQTcgIdQQNC87H04l1TSEuyr5foBP2TZ3fDVoyQ+5z
        LiFr87bj35f4hlC4fMbQXfcApmkdAWI=
X-Google-Smtp-Source: APXvYqyEm7H0Qx4uO/rvkSZ6Es+0Br01V6GgUjOl/ZMwo0beGSQBVz0tk05FmcZBPh6nnHQLseC2GA==
X-Received: by 2002:a5d:4c87:: with SMTP id z7mr13542108wrs.10.1565704421915;
        Tue, 13 Aug 2019 06:53:41 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k1sm15205820wru.49.2019.08.13.06.53.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 06:53:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v4 2/7] x86: kvm: svm: propagate errors from skip_emulated_instruction()
Date:   Tue, 13 Aug 2019 15:53:30 +0200
Message-Id: <20190813135335.25197-3-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813135335.25197-1-vkuznets@redhat.com>
References: <20190813135335.25197-1-vkuznets@redhat.com>
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
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++++++---
 arch/x86/kvm/x86.c              |  6 ++++--
 4 files changed, 38 insertions(+), 22 deletions(-)

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
index 074385c86c09..358827b5bc44 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1472,8 +1472,11 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
 	return 0;
 }
 
-
-static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
+/*
+ * Returns an int to be compatible with SVM implementation (which can fail).
+ * Do not use directly, use skip_emulated_instruction() instead.
+ */
+static int __skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	unsigned long rip;
 
@@ -1483,6 +1486,13 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 
 	/* skipping an emulated instruction also counts */
 	vmx_set_interrupt_shadow(vcpu, 0);
+
+	return EMULATE_DONE;
+}
+
+static inline void skip_emulated_instruction(struct kvm_vcpu *vcpu)
+{
+	(void)__skip_emulated_instruction(vcpu);
 }
 
 static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
@@ -7700,7 +7710,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	.skip_emulated_instruction = __skip_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6d951cbd76c..e8f797fe9d9e 100644
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
+	if (unlikely(r != EMULATE_DONE))
+		return 0;
 
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
-- 
2.20.1

