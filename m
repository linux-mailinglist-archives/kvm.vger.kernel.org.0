Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABF47A2C47
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238686AbjIPAdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbjIPAcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AF01713
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:35 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d818fb959f4so2979471276.1
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824294; x=1695429094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XQRlLqUbNuYp1+FU2drQZXL0G0BiKv3N4ijMXeK3kKU=;
        b=pj+m+tw+Vr/7p8Y5xI2nRJIZqZ/Aw+drvFtF210Mgaro8VDbTprQ03KYl+1DG+Mvl2
         /bdOATaYzWI/O45mTeZvtWzhWrTvGZXveG3TkQVLbNXmY4oarqZBSdBXu6mi0Bpij+Jn
         x0qNy9xNJ6AddCeezhpXBS6bbXEd5lyUgNoG5RF280zx+bPVBT836B0ZYrGoS3Ers/v3
         o5F/EuxdVMrweazOTgz2lLagFBmcXPX/gbRLmEk6NNvwPTLcWPU6oWBEHq9LcBTp9Zct
         1+LXloWwjp6h8rjp+cKpuJfk7yPEH9ApKIJIquVdMZ5HEtoO9NFyc9oZ4Gfl9RpP4sfP
         Hz0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824294; x=1695429094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQRlLqUbNuYp1+FU2drQZXL0G0BiKv3N4ijMXeK3kKU=;
        b=fmYHyNYGmYaWq+FLSf/bO5a3QXCGGpzvXDi5IaKuRXFDkFFq+y8P52kQN9YPH7m+vJ
         6ON1JfBWd12CJ+5/gR0WqSHWyxfLxvb7uQ2kpl2YVjXwf9YptxFNw0XyhmzcL3hEh7BC
         DmAv5qVeE7L92SVPQIRIeSAzriybcSPTl6Jg1Ja7zlJGLEDIgZ6GYcWlSageLdY0z0GR
         bfHjKNEiG0doHfAO0E6/lrkK/hV7keesy8l5PiZfmC4b/I3xm6a2fnN/jgtvliUsTkzf
         rd6T8YHttiyq/qMOmg3TvRQiY8ltVuhBTfxwUcGreHq2osF4FWgwEdbqePQAytCDRq0u
         hh3A==
X-Gm-Message-State: AOJu0YzK+6+LVtrcX4d6FkzFI4Uf3+F+/7sKS4dqUUsE0W7qlWdyMUfB
        g6H7wkAmgdgWbor01tYs3xJGOBjQsKQ=
X-Google-Smtp-Source: AGHT+IHBAJpKVTk5K4TnqnuCpKfAMfti0UcZajyltDkU/ESq4jqN2J77nrZn8mACY7DFJ5DSU6KVipQ1KO4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aa6c:0:b0:d7e:a025:2672 with SMTP id
 s99-20020a25aa6c000000b00d7ea0252672mr72126ybi.9.1694824294437; Fri, 15 Sep
 2023 17:31:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:30:59 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-8-seanjc@google.com>
Subject: [PATCH 07/26] x86/idt: Wrap KVM logic with CONFIG_KVM instead of CONFIG_HAVE_KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap all of the IDT-related code that deals with KVM in CONFIG_KVM instead
of CONFIG_HAVE_KVM.  x86 always "has" KVM, i.e. checking CONFIG_HAVE_KVM
is pointless.

Alternatively, the #ifdefs could simply be deleted, but the only potential
value is in printing the number of posted interrupts that end up being
handled by the host, everything else is completely dead code when KVM is
disabled.  And if KVM is disabled, there should not be any posted
interrupts, i.e. NOT wiring up the "dummy" handlers and treating IRQs on
those vectors as spurious is the right thing to do.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/hardirq.h           | 2 +-
 arch/x86/include/asm/idtentry.h          | 2 +-
 arch/x86/include/asm/irq.h               | 2 +-
 arch/x86/include/asm/irq_vectors.h       | 2 +-
 arch/x86/kernel/idt.c                    | 2 +-
 arch/x86/kernel/irq.c                    | 4 ++--
 scripts/gdb/linux/constants.py.in        | 2 +-
 scripts/gdb/linux/interrupts.py          | 2 +-
 tools/arch/x86/include/asm/irq_vectors.h | 2 +-
 9 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 66837b8c67f1..fbc7722b87d1 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -15,7 +15,7 @@ typedef struct {
 	unsigned int irq_spurious_count;
 	unsigned int icr_read_retry_count;
 #endif
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 	unsigned int kvm_posted_intr_ipis;
 	unsigned int kvm_posted_intr_wakeup_ipis;
 	unsigned int kvm_posted_intr_nested_ipis;
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 05fd175cec7d..8eef16d0d72b 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -671,7 +671,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
 # endif
 #endif
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
diff --git a/arch/x86/include/asm/irq.h b/arch/x86/include/asm/irq.h
index 836c170d3087..194dfff84cb1 100644
--- a/arch/x86/include/asm/irq.h
+++ b/arch/x86/include/asm/irq.h
@@ -29,7 +29,7 @@ struct irq_desc;
 
 extern void fixup_irqs(void);
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 extern void kvm_set_posted_intr_wakeup_handler(void (*handler)(void));
 #endif
 
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 3a19904c2db6..3f73ac3ed3a0 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -84,7 +84,7 @@
 #define HYPERVISOR_CALLBACK_VECTOR	0xf3
 
 /* Vector for KVM to deliver posted interrupt IPI */
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 #define POSTED_INTR_VECTOR		0xf2
 #define POSTED_INTR_WAKEUP_VECTOR	0xf1
 #define POSTED_INTR_NESTED_VECTOR	0xf0
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index b786d48f5a0f..a9e6363d88c2 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -149,7 +149,7 @@ static const __initconst struct idt_data apic_idts[] = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	INTG(LOCAL_TIMER_VECTOR,		asm_sysvec_apic_timer_interrupt),
 	INTG(X86_PLATFORM_IPI_VECTOR,		asm_sysvec_x86_platform_ipi),
-# ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 	INTG(POSTED_INTR_VECTOR,		asm_sysvec_kvm_posted_intr_ipi),
 	INTG(POSTED_INTR_WAKEUP_VECTOR,		asm_sysvec_kvm_posted_intr_wakeup_ipi),
 	INTG(POSTED_INTR_NESTED_VECTOR,		asm_sysvec_kvm_posted_intr_nested_ipi),
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 11761c124545..35fde0107901 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -164,7 +164,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));
 #endif
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 	seq_printf(p, "%*s: ", prec, "PIN");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->kvm_posted_intr_ipis);
@@ -290,7 +290,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_x86_platform_ipi)
 }
 #endif
 
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 static void dummy_handler(void) {}
 static void (*kvm_posted_intr_wakeup_handler)(void) = dummy_handler;
 
diff --git a/scripts/gdb/linux/constants.py.in b/scripts/gdb/linux/constants.py.in
index e3517d4ab8ec..054630f511e0 100644
--- a/scripts/gdb/linux/constants.py.in
+++ b/scripts/gdb/linux/constants.py.in
@@ -129,7 +129,7 @@ LX_CONFIG(CONFIG_X86_MCE_THRESHOLD)
 LX_CONFIG(CONFIG_X86_MCE_AMD)
 LX_CONFIG(CONFIG_X86_MCE)
 LX_CONFIG(CONFIG_X86_IO_APIC)
-LX_CONFIG(CONFIG_HAVE_KVM)
+LX_CONFIG(CONFIG_KVM)
 LX_CONFIG(CONFIG_NUMA)
 LX_CONFIG(CONFIG_ARM64)
 LX_CONFIG(CONFIG_ARM64_4K_PAGES)
diff --git a/scripts/gdb/linux/interrupts.py b/scripts/gdb/linux/interrupts.py
index ef478e273791..66ae5c7690cf 100644
--- a/scripts/gdb/linux/interrupts.py
+++ b/scripts/gdb/linux/interrupts.py
@@ -151,7 +151,7 @@ def x86_show_interupts(prec):
         if cnt is not None:
             text += "%*s: %10u\n" % (prec, "MIS", cnt['counter'])
 
-    if constants.LX_CONFIG_HAVE_KVM:
+    if constants.LX_CONFIG_KVM:
         text += x86_show_irqstat(prec, "PIN", 'kvm_posted_intr_ipis', 'Posted-interrupt notification event')
         text += x86_show_irqstat(prec, "NPI", 'kvm_posted_intr_nested_ipis', 'Nested posted-interrupt event')
         text += x86_show_irqstat(prec, "PIW", 'kvm_posted_intr_wakeup_ipis', 'Posted-interrupt wakeup event')
diff --git a/tools/arch/x86/include/asm/irq_vectors.h b/tools/arch/x86/include/asm/irq_vectors.h
index 3a19904c2db6..3f73ac3ed3a0 100644
--- a/tools/arch/x86/include/asm/irq_vectors.h
+++ b/tools/arch/x86/include/asm/irq_vectors.h
@@ -84,7 +84,7 @@
 #define HYPERVISOR_CALLBACK_VECTOR	0xf3
 
 /* Vector for KVM to deliver posted interrupt IPI */
-#ifdef CONFIG_HAVE_KVM
+#if IS_ENABLED(CONFIG_KVM)
 #define POSTED_INTR_VECTOR		0xf2
 #define POSTED_INTR_WAKEUP_VECTOR	0xf1
 #define POSTED_INTR_NESTED_VECTOR	0xf0
-- 
2.42.0.459.ge4e396fd5e-goog

