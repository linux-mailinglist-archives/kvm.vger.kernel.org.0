Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A261FD6A0
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 23:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgFQVEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 17:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgFQVEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 17:04:09 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4EC5C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 14:04:07 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id cv17so1737389qvb.13
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 14:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D0B+23tpZukrgbMI7+fpAiYqU7WS51LFOzw8uiXiuuo=;
        b=NySidOpPj08qTC/OUAD4iCGfmMMUMdI8V27RWpNzsQj/0giNTvkASqGBb9i50IicKE
         3u7ZNhhTJRjT8cAg/o4VPHVeT8cBkFu/VowQ3bXxZf5noPAGA3c4pZr2H0Y5VQtgLsNX
         oOge0ZsglI9P6rUDyI3I8tYa30WQdhU3FXok+pmewaPLYsY1Ku1xRpFyfsNCRIJDP17t
         Almw3DTLOPZLdd7k4hOxKCFm6BBLDZBrKLnDm+4dQ8WJd3fNwFYrmkoYLxNi+5KTrQ+n
         wyud3HedV46rnAqgXhfqVWRBxDunpln+eVi5ADy2DsZyUPQhbcKIoKJF0yt9gD7WtDWP
         Bv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D0B+23tpZukrgbMI7+fpAiYqU7WS51LFOzw8uiXiuuo=;
        b=JkAnrSjgGuwV9LDrOhh4TAsjOha60JsNqTJ2e9glp3j3dI2nnV1BbyB0SUacf2EUjB
         R7wRO+5gnEKqFxobwa/3x37AF6y8T9Y+LwNJZ1mp4RUqiM2Sp+wwcRTm4GS3lq1qeuIi
         6Y3ZJToLaJXTtqZWLYwPBDKCMiOVDN1R7luGkowZnlI3n3odXz5ko5BHLf1kQjqxK2lk
         QU2eihHuAvToGihcupXhljFv0kwiQUDIgWHFlNCLepWoUA9dCs8fOUAprHwJ7RsV/XKZ
         IBDRG+lWARdnakPkK93/VE3yGLVmLJSg+4wO2Jh2SKQ+U26Z7tmvlydVQ51tmQct8RJN
         OJHQ==
X-Gm-Message-State: AOAM532goXV7RWQBpN/2cUa2tKaJSnkLhFwfcZ7y6+xAXF9NXrgnxEWS
        IQsV9nKzb9T4yiyY0mJ3OjOOsg==
X-Google-Smtp-Source: ABdhPJwmTac+YV6mlbff6cEKmbKEtUOTbUH+fkvhUa9tQ4NH0/IRI8OLYSp1kNlKqL6EK9pRjA+GzA==
X-Received: by 2002:a05:6214:1432:: with SMTP id o18mr549317qvx.57.1592427847060;
        Wed, 17 Jun 2020 14:04:07 -0700 (PDT)
Received: from Rfoley-MA01.hsd1.ma.comcast.net ([2601:199:4480:60c0:fc79:714c:9711:2e9c])
        by smtp.gmail.com with ESMTPSA id w13sm997245qkb.91.2020.06.17.14.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 14:04:06 -0700 (PDT)
From:   Robert Foley <robert.foley@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     alex.bennee@linaro.org, cota@braap.org, peter.puhov@linaro.org,
        robert.foley@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        haxm-team@intel.com (open list:X86 HAXM CPUs),
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH v10 35/73] i386: use cpu_reset_interrupt
Date:   Wed, 17 Jun 2020 17:01:53 -0400
Message-Id: <20200617210231.4393-36-robert.foley@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200617210231.4393-1-robert.foley@linaro.org>
References: <20200617210231.4393-1-robert.foley@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Emilio G. Cota <cota@braap.org>
Signed-off-by: Robert Foley <robert.foley@linaro.org>
---
 target/i386/hax-all.c    |  4 ++--
 target/i386/hvf/x86hvf.c |  8 ++++----
 target/i386/kvm.c        | 14 +++++++-------
 target/i386/seg_helper.c | 13 ++++++-------
 target/i386/svm_helper.c |  2 +-
 target/i386/whpx-all.c   | 10 +++++-----
 6 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/target/i386/hax-all.c b/target/i386/hax-all.c
index acfb7a6e10..6a4152730f 100644
--- a/target/i386/hax-all.c
+++ b/target/i386/hax-all.c
@@ -438,7 +438,7 @@ static int hax_vcpu_interrupt(CPUArchState *env)
         irq = cpu_get_pic_interrupt(env);
         if (irq >= 0) {
             hax_inject_interrupt(env, irq);
-            cpu->interrupt_request &= ~CPU_INTERRUPT_HARD;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_HARD);
         }
     }
 
@@ -486,7 +486,7 @@ static int hax_vcpu_hax_exec(CPUArchState *env)
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_POLL) {
-        cpu->interrupt_request &= ~CPU_INTERRUPT_POLL;
+        cpu_reset_interrupt(cpu, CPU_INTERRUPT_POLL);
         apic_poll_irq(x86_cpu->apic_state);
     }
 
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index c09cf160ef..8e9b60d0a7 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -402,7 +402,7 @@ bool hvf_inject_interrupts(CPUState *cpu_state)
 
     if (cpu_state->interrupt_request & CPU_INTERRUPT_NMI) {
         if (!(env->hflags2 & HF2_NMI_MASK) && !(info & VMCS_INTR_VALID)) {
-            cpu_state->interrupt_request &= ~CPU_INTERRUPT_NMI;
+            cpu_reset_interrupt(cpu_state, CPU_INTERRUPT_NMI);
             info = VMCS_INTR_VALID | VMCS_INTR_T_NMI | EXCP02_NMI;
             wvmcs(cpu_state->hvf_fd, VMCS_ENTRY_INTR_INFO, info);
         } else {
@@ -414,7 +414,7 @@ bool hvf_inject_interrupts(CPUState *cpu_state)
         (cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
         (env->eflags & IF_MASK) && !(info & VMCS_INTR_VALID)) {
         int line = cpu_get_pic_interrupt(&x86cpu->env);
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_HARD;
+        cpu_reset_interrupt(cpu_state, CPU_INTERRUPT_HARD);
         if (line >= 0) {
             wvmcs(cpu_state->hvf_fd, VMCS_ENTRY_INTR_INFO, line |
                   VMCS_INTR_VALID | VMCS_INTR_T_HWINTR);
@@ -440,7 +440,7 @@ int hvf_process_events(CPUState *cpu_state)
     }
 
     if (cpu_state->interrupt_request & CPU_INTERRUPT_POLL) {
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_POLL;
+        cpu_reset_interrupt(cpu_state, CPU_INTERRUPT_POLL);
         apic_poll_irq(cpu->apic_state);
     }
     if (((cpu_state->interrupt_request & CPU_INTERRUPT_HARD) &&
@@ -453,7 +453,7 @@ int hvf_process_events(CPUState *cpu_state)
         do_cpu_sipi(cpu);
     }
     if (cpu_state->interrupt_request & CPU_INTERRUPT_TPR) {
-        cpu_state->interrupt_request &= ~CPU_INTERRUPT_TPR;
+        cpu_reset_interrupt(cpu_state, CPU_INTERRUPT_TPR);
         hvf_cpu_synchronize_state(cpu_state);
         apic_handle_tpr_access_report(cpu->apic_state, env->eip,
                                       env->tpr_access_type);
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index eda51904dd..8628fa9111 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -3658,7 +3658,7 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
              */
             events.smi.pending = cs->interrupt_request & CPU_INTERRUPT_SMI;
             events.smi.latched_init = cs->interrupt_request & CPU_INTERRUPT_INIT;
-            cs->interrupt_request &= ~(CPU_INTERRUPT_INIT | CPU_INTERRUPT_SMI);
+            cpu_reset_interrupt(cs, CPU_INTERRUPT_INIT | CPU_INTERRUPT_SMI);
         } else {
             /* Keep these in cs->interrupt_request.  */
             events.smi.pending = 0;
@@ -4021,7 +4021,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
     if (cpu->interrupt_request & (CPU_INTERRUPT_NMI | CPU_INTERRUPT_SMI)) {
         if (cpu->interrupt_request & CPU_INTERRUPT_NMI) {
             qemu_mutex_lock_iothread();
-            cpu->interrupt_request &= ~CPU_INTERRUPT_NMI;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_NMI);
             qemu_mutex_unlock_iothread();
             DPRINTF("injected NMI\n");
             ret = kvm_vcpu_ioctl(cpu, KVM_NMI);
@@ -4032,7 +4032,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
         }
         if (cpu->interrupt_request & CPU_INTERRUPT_SMI) {
             qemu_mutex_lock_iothread();
-            cpu->interrupt_request &= ~CPU_INTERRUPT_SMI;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_SMI);
             qemu_mutex_unlock_iothread();
             DPRINTF("injected SMI\n");
             ret = kvm_vcpu_ioctl(cpu, KVM_SMI);
@@ -4068,7 +4068,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
             (env->eflags & IF_MASK)) {
             int irq;
 
-            cpu->interrupt_request &= ~CPU_INTERRUPT_HARD;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_HARD);
             irq = cpu_get_pic_interrupt(env);
             if (irq >= 0) {
                 struct kvm_interrupt intr;
@@ -4139,7 +4139,7 @@ int kvm_arch_process_async_events(CPUState *cs)
         /* We must not raise CPU_INTERRUPT_MCE if it's not supported. */
         assert(env->mcg_cap);
 
-        cs->interrupt_request &= ~CPU_INTERRUPT_MCE;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_MCE);
 
         kvm_cpu_synchronize_state(cs);
 
@@ -4169,7 +4169,7 @@ int kvm_arch_process_async_events(CPUState *cs)
     }
 
     if (cs->interrupt_request & CPU_INTERRUPT_POLL) {
-        cs->interrupt_request &= ~CPU_INTERRUPT_POLL;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_POLL);
         apic_poll_irq(cpu->apic_state);
     }
     if (((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
@@ -4182,7 +4182,7 @@ int kvm_arch_process_async_events(CPUState *cs)
         do_cpu_sipi(cpu);
     }
     if (cs->interrupt_request & CPU_INTERRUPT_TPR) {
-        cs->interrupt_request &= ~CPU_INTERRUPT_TPR;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_TPR);
         kvm_cpu_synchronize_state(cs);
         apic_handle_tpr_access_report(cpu->apic_state, env->eip,
                                       env->tpr_access_type);
diff --git a/target/i386/seg_helper.c b/target/i386/seg_helper.c
index b96de068ca..818f65f35f 100644
--- a/target/i386/seg_helper.c
+++ b/target/i386/seg_helper.c
@@ -1332,7 +1332,7 @@ bool x86_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
     switch (interrupt_request) {
 #if !defined(CONFIG_USER_ONLY)
     case CPU_INTERRUPT_POLL:
-        cs->interrupt_request &= ~CPU_INTERRUPT_POLL;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_POLL);
         apic_poll_irq(cpu->apic_state);
         break;
 #endif
@@ -1341,23 +1341,22 @@ bool x86_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
         break;
     case CPU_INTERRUPT_SMI:
         cpu_svm_check_intercept_param(env, SVM_EXIT_SMI, 0, 0);
-        cs->interrupt_request &= ~CPU_INTERRUPT_SMI;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_SMI);
         do_smm_enter(cpu);
         break;
     case CPU_INTERRUPT_NMI:
         cpu_svm_check_intercept_param(env, SVM_EXIT_NMI, 0, 0);
-        cs->interrupt_request &= ~CPU_INTERRUPT_NMI;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_NMI);
         env->hflags2 |= HF2_NMI_MASK;
         do_interrupt_x86_hardirq(env, EXCP02_NMI, 1);
         break;
     case CPU_INTERRUPT_MCE:
-        cs->interrupt_request &= ~CPU_INTERRUPT_MCE;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_MCE);
         do_interrupt_x86_hardirq(env, EXCP12_MCHK, 0);
         break;
     case CPU_INTERRUPT_HARD:
         cpu_svm_check_intercept_param(env, SVM_EXIT_INTR, 0, 0);
-        cs->interrupt_request &= ~(CPU_INTERRUPT_HARD |
-                                   CPU_INTERRUPT_VIRQ);
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD | CPU_INTERRUPT_VIRQ);
         intno = cpu_get_pic_interrupt(env);
         qemu_log_mask(CPU_LOG_TB_IN_ASM,
                       "Servicing hardware INT=0x%02x\n", intno);
@@ -1372,7 +1371,7 @@ bool x86_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
         qemu_log_mask(CPU_LOG_TB_IN_ASM,
                       "Servicing virtual hardware INT=0x%02x\n", intno);
         do_interrupt_x86_hardirq(env, intno, 1);
-        cs->interrupt_request &= ~CPU_INTERRUPT_VIRQ;
+        cpu_reset_interrupt(cs, CPU_INTERRUPT_VIRQ);
         break;
 #endif
     }
diff --git a/target/i386/svm_helper.c b/target/i386/svm_helper.c
index 7b8105a1c3..63eb136743 100644
--- a/target/i386/svm_helper.c
+++ b/target/i386/svm_helper.c
@@ -700,7 +700,7 @@ void do_vmexit(CPUX86State *env, uint32_t exit_code, uint64_t exit_info_1)
     env->hflags &= ~HF_GUEST_MASK;
     env->intercept = 0;
     env->intercept_exceptions = 0;
-    cs->interrupt_request &= ~CPU_INTERRUPT_VIRQ;
+    cpu_reset_interrupt(cs, CPU_INTERRUPT_VIRQ);
     env->tsc_offset = 0;
 
     env->gdt.base  = x86_ldq_phys(cs, env->vm_hsave + offsetof(struct vmcb,
diff --git a/target/i386/whpx-all.c b/target/i386/whpx-all.c
index efc2d88810..d5beb4a5e2 100644
--- a/target/i386/whpx-all.c
+++ b/target/i386/whpx-all.c
@@ -790,14 +790,14 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
     if (!vcpu->interruption_pending &&
         cpu->interrupt_request & (CPU_INTERRUPT_NMI | CPU_INTERRUPT_SMI)) {
         if (cpu->interrupt_request & CPU_INTERRUPT_NMI) {
-            cpu->interrupt_request &= ~CPU_INTERRUPT_NMI;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_NMI);
             vcpu->interruptable = false;
             new_int.InterruptionType = WHvX64PendingNmi;
             new_int.InterruptionPending = 1;
             new_int.InterruptionVector = 2;
         }
         if (cpu->interrupt_request & CPU_INTERRUPT_SMI) {
-            cpu->interrupt_request &= ~CPU_INTERRUPT_SMI;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_SMI);
         }
     }
 
@@ -820,7 +820,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
         vcpu->interruptable && (env->eflags & IF_MASK)) {
         assert(!new_int.InterruptionPending);
         if (cpu->interrupt_request & CPU_INTERRUPT_HARD) {
-            cpu->interrupt_request &= ~CPU_INTERRUPT_HARD;
+            cpu_reset_interrupt(cpu, CPU_INTERRUPT_HARD);
             irq = cpu_get_pic_interrupt(env);
             if (irq >= 0) {
                 new_int.InterruptionType = WHvX64PendingInterrupt;
@@ -911,7 +911,7 @@ static void whpx_vcpu_process_async_events(CPUState *cpu)
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_POLL) {
-        cpu->interrupt_request &= ~CPU_INTERRUPT_POLL;
+        cpu_reset_interrupt(cpu, CPU_INTERRUPT_POLL);
         apic_poll_irq(x86_cpu->apic_state);
     }
 
@@ -927,7 +927,7 @@ static void whpx_vcpu_process_async_events(CPUState *cpu)
     }
 
     if (cpu->interrupt_request & CPU_INTERRUPT_TPR) {
-        cpu->interrupt_request &= ~CPU_INTERRUPT_TPR;
+        cpu_reset_interrupt(cpu, CPU_INTERRUPT_TPR);
         whpx_cpu_synchronize_state(cpu);
         apic_handle_tpr_access_report(x86_cpu->apic_state, env->eip,
                                       env->tpr_access_type);
-- 
2.17.1

