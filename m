Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001F11FD6A1
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 23:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgFQVER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 17:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgFQVEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 17:04:15 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEE8C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 14:04:15 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f18so3523496qkh.1
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 14:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bMJDR0op9yYxk4Q3uQ7Lh3faQWxq/2pZw+Fv/nrXz+A=;
        b=RQ63kTM3AKz8TNyE0qqe3WkxI4DWPU9SoW1W8pf9NzcSXpE0kY0LeFIbtftZnxkj4x
         xZuG7uhNcOEJpQEDpXhvC4mN6Up5589I6u4feY9dRApjrGtw0jzbP/VS3RgTMf+3aBMs
         KTTbCR481jg527+8nsl8LO+Vk/i0cl2OV8eCwCMyefErmZD3bZ1vHgf1mAxZ2ABZZCPj
         fT0xXvOy6UqjOHQopPv8256ETNp9vw1p7oH/cVAr7hjf0NIgnlygj/9hIa6OTvoYpio8
         yEHxkxu+nZ+YVDtvv47ypap+qoRvdvBgWhM6O73KoW/1Uk32RfTR5O74JLUdSLiGrb3n
         Zk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bMJDR0op9yYxk4Q3uQ7Lh3faQWxq/2pZw+Fv/nrXz+A=;
        b=MbpZ9C3rIG29G9BCczuiM8Myb5fqNmfVUpyAFSgYAPyWhnGccz7M/CJUuy8sONRtoD
         p9GmX3XpCbcnzOa/AkYMSu0LD4HBhb+dp4ZddsVbJ+VgIMnh3Im3hUqL6sIUB6jmaVIG
         2GYFpN93FMT1nAyeF5RlpOLBMYS2XXP9fTlToJlFEbUO2lKvpkHKwnMP0LQZQ0RS+5+F
         BaUtZKOFDlWdoHTq4GoCBIV3UTw9EVFuZHSPwCRRD1/CATfxhC2W/WKbbYoTYhkB8x49
         hg3XyFvIubX/gFRx1asWMnFt+YY8V9L0kMCM4/8SaQFhplh/o6OKv4W85LDIPnnMNCiI
         yLHA==
X-Gm-Message-State: AOAM533CK0xTOukTq6FURh5TK7mQhVy3G8fCw+YOwhK0gFVN2hXMjKyv
        BEimXGlp80yOChRXq+b9qbgCOQ==
X-Google-Smtp-Source: ABdhPJznqaLvi+9naqRjgbuk4+KNhEW9buBCGiCCF3iJ7TMvCWyNwsADfAY+cpYywUMGIYMeZlcjcA==
X-Received: by 2002:a37:5e07:: with SMTP id s7mr625733qkb.20.1592427854372;
        Wed, 17 Jun 2020 14:04:14 -0700 (PDT)
Received: from Rfoley-MA01.hsd1.ma.comcast.net ([2601:199:4480:60c0:fc79:714c:9711:2e9c])
        by smtp.gmail.com with ESMTPSA id w13sm997245qkb.91.2020.06.17.14.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 14:04:13 -0700 (PDT)
From:   Robert Foley <robert.foley@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     alex.bennee@linaro.org, cota@braap.org, peter.puhov@linaro.org,
        robert.foley@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm@vger.kernel.org (open list:X86 KVM CPUs)
Subject: [PATCH v10 40/73] i386/kvm: convert to cpu_interrupt_request
Date:   Wed, 17 Jun 2020 17:01:58 -0400
Message-Id: <20200617210231.4393-41-robert.foley@linaro.org>
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

From: "Emilio G. Cota" <cota@braap.org>

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Signed-off-by: Emilio G. Cota <cota@braap.org>
Signed-off-by: Robert Foley <robert.foley@linaro.org>
---
 target/i386/kvm.c | 58 ++++++++++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 8628fa9111..415a6d8114 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -3653,11 +3653,14 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
         events.smi.smm = !!(env->hflags & HF_SMM_MASK);
         events.smi.smm_inside_nmi = !!(env->hflags2 & HF2_SMM_INSIDE_NMI_MASK);
         if (kvm_irqchip_in_kernel()) {
+            uint32_t interrupt_request;
+
             /* As soon as these are moved to the kernel, remove them
              * from cs->interrupt_request.
              */
-            events.smi.pending = cs->interrupt_request & CPU_INTERRUPT_SMI;
-            events.smi.latched_init = cs->interrupt_request & CPU_INTERRUPT_INIT;
+            interrupt_request = cpu_interrupt_request(cs);
+            events.smi.pending = interrupt_request & CPU_INTERRUPT_SMI;
+            events.smi.latched_init = interrupt_request & CPU_INTERRUPT_INIT;
             cpu_reset_interrupt(cs, CPU_INTERRUPT_INIT | CPU_INTERRUPT_SMI);
         } else {
             /* Keep these in cs->interrupt_request.  */
@@ -4015,14 +4018,14 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
     CPUX86State *env = &x86_cpu->env;
+    uint32_t interrupt_request;
     int ret;
 
+    interrupt_request = cpu_interrupt_request(cpu);
     /* Inject NMI */
-    if (cpu->interrupt_request & (CPU_INTERRUPT_NMI | CPU_INTERRUPT_SMI)) {
-        if (cpu->interrupt_request & CPU_INTERRUPT_NMI) {
-            qemu_mutex_lock_iothread();
+    if (interrupt_request & (CPU_INTERRUPT_NMI | CPU_INTERRUPT_SMI)) {
+        if (interrupt_request & CPU_INTERRUPT_NMI) {
             cpu_reset_interrupt(cpu, CPU_INTERRUPT_NMI);
-            qemu_mutex_unlock_iothread();
             DPRINTF("injected NMI\n");
             ret = kvm_vcpu_ioctl(cpu, KVM_NMI);
             if (ret < 0) {
@@ -4030,10 +4033,8 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
                         strerror(-ret));
             }
         }
-        if (cpu->interrupt_request & CPU_INTERRUPT_SMI) {
-            qemu_mutex_lock_iothread();
+        if (interrupt_request & CPU_INTERRUPT_SMI) {
             cpu_reset_interrupt(cpu, CPU_INTERRUPT_SMI);
-            qemu_mutex_unlock_iothread();
             DPRINTF("injected SMI\n");
             ret = kvm_vcpu_ioctl(cpu, KVM_SMI);
             if (ret < 0) {
@@ -4047,16 +4048,22 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
         qemu_mutex_lock_iothread();
     }
 
+    /*
+     * We might have cleared some bits in cpu->interrupt_request since reading
+     * it; read it again.
+     */
+    interrupt_request = cpu_interrupt_request(cpu);
+
     /* Force the VCPU out of its inner loop to process any INIT requests
      * or (for userspace APIC, but it is cheap to combine the checks here)
      * pending TPR access reports.
      */
-    if (cpu->interrupt_request & (CPU_INTERRUPT_INIT | CPU_INTERRUPT_TPR)) {
-        if ((cpu->interrupt_request & CPU_INTERRUPT_INIT) &&
+    if (interrupt_request & (CPU_INTERRUPT_INIT | CPU_INTERRUPT_TPR)) {
+        if ((interrupt_request & CPU_INTERRUPT_INIT) &&
             !(env->hflags & HF_SMM_MASK)) {
             cpu->exit_request = 1;
         }
-        if (cpu->interrupt_request & CPU_INTERRUPT_TPR) {
+        if (interrupt_request & CPU_INTERRUPT_TPR) {
             cpu->exit_request = 1;
         }
     }
@@ -4064,7 +4071,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
     if (!kvm_pic_in_kernel()) {
         /* Try to inject an interrupt if the guest can accept it */
         if (run->ready_for_interrupt_injection &&
-            (cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
+            (interrupt_request & CPU_INTERRUPT_HARD) &&
             (env->eflags & IF_MASK)) {
             int irq;
 
@@ -4088,7 +4095,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
          * interrupt, request an interrupt window exit.  This will
          * cause a return to userspace as soon as the guest is ready to
          * receive interrupts. */
-        if ((cpu->interrupt_request & CPU_INTERRUPT_HARD)) {
+        if ((cpu_interrupt_request(cpu) & CPU_INTERRUPT_HARD)) {
             run->request_interrupt_window = 1;
         } else {
             run->request_interrupt_window = 0;
@@ -4134,8 +4141,9 @@ int kvm_arch_process_async_events(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
+    uint32_t interrupt_request;
 
-    if (cs->interrupt_request & CPU_INTERRUPT_MCE) {
+    if (cpu_interrupt_request(cs) & CPU_INTERRUPT_MCE) {
         /* We must not raise CPU_INTERRUPT_MCE if it's not supported. */
         assert(env->mcg_cap);
 
@@ -4158,7 +4166,7 @@ int kvm_arch_process_async_events(CPUState *cs)
         }
     }
 
-    if ((cs->interrupt_request & CPU_INTERRUPT_INIT) &&
+    if ((cpu_interrupt_request(cs) & CPU_INTERRUPT_INIT) &&
         !(env->hflags & HF_SMM_MASK)) {
         kvm_cpu_synchronize_state(cs);
         do_cpu_init(cpu);
@@ -4168,20 +4176,21 @@ int kvm_arch_process_async_events(CPUState *cs)
         return 0;
     }
 
-    if (cs->interrupt_request & CPU_INTERRUPT_POLL) {
+    if (cpu_interrupt_request(cs) & CPU_INTERRUPT_POLL) {
         cpu_reset_interrupt(cs, CPU_INTERRUPT_POLL);
         apic_poll_irq(cpu->apic_state);
     }
-    if (((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
+    interrupt_request = cpu_interrupt_request(cs);
+    if (((interrupt_request & CPU_INTERRUPT_HARD) &&
          (env->eflags & IF_MASK)) ||
-        (cs->interrupt_request & CPU_INTERRUPT_NMI)) {
+        (interrupt_request & CPU_INTERRUPT_NMI)) {
         cpu_halted_set(cs, 0);
     }
-    if (cs->interrupt_request & CPU_INTERRUPT_SIPI) {
+    if (interrupt_request & CPU_INTERRUPT_SIPI) {
         kvm_cpu_synchronize_state(cs);
         do_cpu_sipi(cpu);
     }
-    if (cs->interrupt_request & CPU_INTERRUPT_TPR) {
+    if (cpu_interrupt_request(cs) & CPU_INTERRUPT_TPR) {
         cpu_reset_interrupt(cs, CPU_INTERRUPT_TPR);
         kvm_cpu_synchronize_state(cs);
         apic_handle_tpr_access_report(cpu->apic_state, env->eip,
@@ -4195,10 +4204,13 @@ static int kvm_handle_halt(X86CPU *cpu)
 {
     CPUState *cs = CPU(cpu);
     CPUX86State *env = &cpu->env;
+    uint32_t interrupt_request;
+
+    interrupt_request = cpu_interrupt_request(cs);
 
-    if (!((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
+    if (!((interrupt_request & CPU_INTERRUPT_HARD) &&
           (env->eflags & IF_MASK)) &&
-        !(cs->interrupt_request & CPU_INTERRUPT_NMI)) {
+        !(interrupt_request & CPU_INTERRUPT_NMI)) {
         cpu_halted_set(cs, 1);
         return EXCP_HLT;
     }
-- 
2.17.1

