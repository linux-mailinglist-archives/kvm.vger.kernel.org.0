Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D7389543
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 20:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhESS1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 14:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhESS1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 14:27:31 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D49C06175F;
        Wed, 19 May 2021 11:26:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id k14so17886137eji.2;
        Wed, 19 May 2021 11:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYCxITyk+mk4AUTz8nuEyzSBN6pUkGqdMoN9h/d6AUE=;
        b=uDU95HCW5Qxy8VJOwJvwjdYXBniziRNUCJwn9ULD+mtVcf7wYeECcFP9kEW6lMYiqK
         JI8jbZV1zNr/DhC43/txPUaZDBOlhFtOcc3ih8nBnkf5I1NWFFFCdUmMgQjss5ECubCC
         spmLgq6bDWGQIfYHPJV37x5v+NAvRNpr95XJf8LHj7mkxMz5w0T+gNwHFmzh24k6s2Iy
         qpZYOeHKi485gABYWsnlotZHGwiHlQAeQ4TFWOJYC3zOIeEwKFxmFqvmjyr7i/6xWZp+
         ZPR6nfRqoHVTS8bsiFX8YV3cmNnhDeLvcm8beX2/c0rrPsDxOeppzmlA4OJTi9hWEJMy
         U9Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eYCxITyk+mk4AUTz8nuEyzSBN6pUkGqdMoN9h/d6AUE=;
        b=tB18/2j/jew2lUQDOHVwBkwatolMCV4vA1/yJyms94yIW5xBcU7FKfwJ5Wkk+eZv/M
         8i7gh/nOGoL00/h9wOy4MncgIyi7O7fn+uRGdJ+TZk9dbRVKhgx9UtQPvF0GK6+goVM8
         637LUik1VG5s+08JolILGrKn7PWRWNLEzT+0WEHIEwabdCzidafQkl/BG0R+pwqzu/eR
         q23SLKdOPliYemi4+4odvbXISIF/fLdTA5fVqK0WqTUDL/e3XjI49R+AiE9azymWt6B6
         Q6JFxKIbzlV4XAua4ALiv5Lp5LwMQb9gm15SEMUmov5xrtXvY/THHhjOJy8FRNgdE4Pp
         GTqQ==
X-Gm-Message-State: AOAM533PaNaNw9fvisNfrhigwfvlv7krEeQsW3bws4zBZ2PKcCZW22MS
        VD/MQUn8LZLcy6c2ChgpReurUlzj/S8=
X-Google-Smtp-Source: ABdhPJxgUEjPkhULuMBxFAsG87dtJb8Gw0PbOWW/r4V4fZKj8KjnoPLTaB02KXnScf0EAoAAeLEBRg==
X-Received: by 2002:a17:906:2a08:: with SMTP id j8mr433226eje.483.1621448769291;
        Wed, 19 May 2021 11:26:09 -0700 (PDT)
Received: from localhost.localdomain.Home ([151.32.52.155])
        by smtp.gmail.com with ESMTPSA id c3sm299843edn.16.2021.05.19.11.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 11:26:08 -0700 (PDT)
From:   Stefano De Venuto <stefano.devenuto99@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, rostedt@goodmis.org,
        y.karadz@gmail.com,
        Stefano De Venuto <stefano.devenuto99@gmail.com>,
        Dario Faggioli <dfaggioli@suse.com>
Subject: [PATCH] Move VMEnter and VMExit tracepoints closer to the actual event
Date:   Wed, 19 May 2021 20:23:03 +0200
Message-Id: <20210519182303.2790-1-stefano.devenuto99@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_entry and kvm_exit tracepoints are still quite far from the
actual VMEnters/VMExits. This means that in a trace we can find host
events after a kvm_entry event and before a kvm_exit one, as in this
example:

           trace.dat:  CPU 0/KVM-4594  [001]  2.167191: kvm_entry:
           trace.dat:  CPU 0/KVM-4594  [001]  2.167192: write_msr: 48, value 0
           trace.dat:  CPU 0/KVM-4594  [001]  2.167192: rcu_utilization: Start context switch
           trace.dat:  CPU 0/KVM-4594  [001]  2.167192: rcu_utilization: End context switch
trace-tumbleweed.dat:     <idle>-0     [000]  2.167196: hrtimer_cancel:
trace-tumbleweed.dat:     <idle>-0     [000]  2.167197: hrtimer_expire_entry:
trace-tumbleweed.dat:     <idle>-0     [000]  2.167201: hrtimer_expire_exit:
trace-tumbleweed.dat:     <idle>-0     [000]  2.167201: hrtimer_start:
           trace.dat:  CPU 0/KVM-4594  [001]  2.167203: read_msr: 48, value 0
           trace.dat:  CPU 0/KVM-4594  [001]  2.167203: write_msr: 48, value 4
           trace.dat:  CPU 0/KVM-4594  [001]  2.167204: kvm_exit: 

This patch moves the tracepoints closer to the events, for both Intel
and AMD, so that a combined host-guest trace will offer a more
realistic representation of what is really happening, as shown here:

           trace.dat:  CPU 0/KVM-2553  [000]  2.190290: write_msr: 48, value 0
           trace.dat:  CPU 0/KVM-2553  [000]  2.190290: rcu_utilization: Start context switch
           trace.dat:  CPU 0/KVM-2553  [000]  2.190290: rcu_utilization: End context switch
           trace.dat:  CPU 0/KVM-2553  [000]  2.190290: kvm_entry:
trace-tumbleweed.dat:     <idle>-0     [000]  2.190290: write_msr:
trace-tumbleweed.dat:     <idle>-0     [000]  2.190290: cpu_idle:
           trace.dat:  CPU 0/KVM-2553  [000]  2.190291: kvm_exit:
           trace.dat:  CPU 0/KVM-2553  [000]  2.190291: read_msr: 48, value 0
           trace.dat:  CPU 0/KVM-2553  [000]  2.190291: write_msr: 48, value 4 

Signed-off-by: Stefano De Venuto <stefano.devenuto99@gmail.com>
Signed-off-by: Dario Faggioli <dfaggioli@suse.com>
---
 arch/x86/kvm/svm/svm.c |  8 ++++----
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 05eca131eaf2..c77d4866e239 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3275,8 +3275,6 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 exit_code = svm->vmcb->control.exit_code;
 
-	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
-
 	/* SEV-ES guests must use the CR write traps to track CR registers. */
 	if (!sev_es_guest(vcpu->kvm)) {
 		if (!svm_is_intercept(svm, INTERCEPT_CR0_WRITE))
@@ -3707,6 +3705,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 
 	kvm_guest_enter_irqoff();
 
+	trace_kvm_entry(vcpu);
+
 	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(vmcb_pa);
 	} else {
@@ -3725,6 +3725,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
+	trace_kvm_exit(svm->vmcb->control.exit_code, vcpu, KVM_ISA_SVM);
+
 	kvm_guest_exit_irqoff();
 }
 
@@ -3732,8 +3734,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	trace_kvm_entry(vcpu);
-
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
 	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4bceb5ca3a89..33c732101b83 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6661,6 +6661,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 {
 	kvm_guest_enter_irqoff();
 
+	trace_kvm_entry(vcpu);
+
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
@@ -6675,6 +6677,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	vcpu->arch.cr2 = native_read_cr2();
 
+	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
+	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
+
 	kvm_guest_exit_irqoff();
 }
 
@@ -6693,8 +6698,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vmx->emulation_required)
 		return EXIT_FASTPATH_NONE;
 
-	trace_kvm_entry(vcpu);
-
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
 		vmcs_write32(PLE_WINDOW, vmx->ple_window);
@@ -6814,15 +6817,12 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 	}
 
-	vmx->exit_reason.full = vmcs_read32(VM_EXIT_REASON);
 	if (unlikely((u16)vmx->exit_reason.basic == EXIT_REASON_MCE_DURING_VMENTRY))
 		kvm_machine_check();
 
 	if (likely(!vmx->exit_reason.failed_vmentry))
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
-
 	if (unlikely(vmx->exit_reason.failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
-- 
2.31.1

