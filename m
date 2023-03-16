Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8491D6BDB91
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPWWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjCPWWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:22:07 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E256B3282
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:19 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso4087262wmb.0
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCd04cCjdDd9yY9uOauqDe6tLaGHwa1xS5Ta04nWC9w=;
        b=YDJJw+pSikaVs3fCOY91ao1Vu7r06p5XLVjpiPhJLZbcY3qDH/HQVuOf3vyW1Lj/R/
         Oxci52Cw+uWEx+VOeZ0Q9UZqvaJr8nyxF5AAlpLzyt3JNB5p9AfDs4Gsz4kXa7bBdl4K
         mGzeSojARtKfwMnehoj/ZNB9EBhGsqavxNOiFSO34L3bmzjR1BYye4+IcahI42zPONo0
         HTJA1YZiqDJYcJgR2TLQ285JR+FTqbZgXXnpyqrm8c7IfDrXFt6XzQJzbsXcAj+k6WGU
         fb8BhOprzTate3FGN8awPwD3EWsAyb9Lf3YY10fuMwrAmvfq0gEDV2G0C6LFDG6Cc5ku
         ECNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WCd04cCjdDd9yY9uOauqDe6tLaGHwa1xS5Ta04nWC9w=;
        b=M2s19BBUjZ+5r9uCBdSecIUoh3W069dHsy83eILAB9ZHW7M1G5ze4EnDCIEmoKTAC1
         zV9zmR5TxJHYs2duyqFytX2qh71YCKERfFN4Jb9Q4YLIUo+895WX6I67Q6gPZpj30bjT
         TJ/rclrU76k8QNncaxWxjLyzcIrSFofyerlUqDC5nnogs00rf7ECJFStlGRBAmgcs9fO
         CgJQuQH+/5inbAfiwDQobxXFlSKcAA495euZ2R4yNGvkjm7hXRe+Ydez3lRWlunKWpwZ
         DzQIDYsqeZw3c/4DfmLJMsuhSZBt0DY8sg3112vNtIOMLL4aaqTjMtbVmx6llAq+dPGZ
         ufxA==
X-Gm-Message-State: AO0yUKV/Ta0cpukgUoXuy8ZNfv5uiGVT7TAdXLJWyGAppA8M/FAJ3LNT
        TU+7SWxymb2moigOlYU64U3/lQ==
X-Google-Smtp-Source: AK7set+YIOeMbMfOBrw6ewTEHf3ItgJxXx58TbsfmlHmdapKGhU72yH3VWnFpLGk1gn86Dta2s6xYA==
X-Received: by 2002:a7b:c4da:0:b0:3ed:70df:37 with SMTP id g26-20020a7bc4da000000b003ed70df0037mr1475010wmk.21.1679005277390;
        Thu, 16 Mar 2023 15:21:17 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:17 -0700 (PDT)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v15 06/12] x86/smpboot: Remove initial_stack on 64-bit
Date:   Thu, 16 Mar 2023 22:21:03 +0000
Message-Id: <20230316222109.1940300-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316222109.1940300-1-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

In order to facilitate parallel startup, start to eliminate some of the
global variables passing information to CPUs in the startup path.

However, start by introducing one more: smpboot_control. For now this
merely holds the CPU# of the CPU which is coming up. Each CPU can then
find its own per-cpu data, and everything else it needs can be found
from there, allowing the other global variables to be removed.

First to be removed is initial_stack. Each CPU can load %rsp from its
current_task->thread.sp instead. That is already set up with the correct
idle thread for APs. Set up the .sp field in INIT_THREAD on x86 so that
the BSP also finds a suitable stack pointer in the static per-cpu data
when coming up on first boot.

On resume from S3, the CPU needs a temporary stack because its idle task
is already active. Instead of setting initial_stack, the sleep code can
simply set its own current->thread.sp to point to the temporary stack.
Nobody else cares about ->thread.sp for a thread which is currently on
a CPU, because the true value is actually in the %rsp register. Which
is restored with the rest of the CPU context in do_suspend_lowlevel().

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/include/asm/processor.h |  6 ++++-
 arch/x86/include/asm/smp.h       |  5 +++-
 arch/x86/kernel/acpi/sleep.c     | 20 +++++++++++++--
 arch/x86/kernel/asm-offsets.c    |  1 +
 arch/x86/kernel/head_64.S        | 43 +++++++++++++++++++++-----------
 arch/x86/kernel/smpboot.c        |  7 +++++-
 arch/x86/xen/xen-head.S          |  2 +-
 7 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4e35c66edeb7..bdde7316e75b 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -648,7 +648,11 @@ static inline void spin_lock_prefetch(const void *x)
 #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
 
 #else
-#define INIT_THREAD { }
+extern unsigned long __end_init_task[];
+
+#define INIT_THREAD {							    \
+	.sp	= (unsigned long)&__end_init_task - sizeof(struct pt_regs), \
+}
 
 extern unsigned long KSTK_ESP(struct task_struct *task);
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index b4dbb20dab1a..bf2c51df9e0b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -199,5 +199,8 @@ extern void nmi_selftest(void);
 #define nmi_selftest() do { } while (0)
 #endif
 
-#endif /* __ASSEMBLY__ */
+extern unsigned int smpboot_control;
+
+#endif /* !__ASSEMBLY__ */
+
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 3b7f4cdbf2e0..1b4c43d0819a 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -111,13 +111,29 @@ int x86_acpi_suspend_lowlevel(void)
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
-	initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
+	/*
+	 * As each CPU starts up, it will find its own stack pointer
+	 * from its current_task->thread.sp. Typically that will be
+	 * the idle thread for a newly-started AP, or even the boot
+	 * CPU which will find it set to &init_task in the static
+	 * per-cpu data.
+	 *
+	 * Make the resuming CPU use the temporary stack at startup
+	 * by setting current->thread.sp to point to that. The true
+	 * %rsp will be restored with the rest of the CPU context,
+	 * by do_suspend_lowlevel(). And unwinders don't care about
+	 * the abuse of ->thread.sp because it's a dead variable
+	 * while the thread is running on the CPU anyway; the true
+	 * value is in the actual %rsp register.
+	 */
+	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
+	smpboot_control = smp_processor_id();
 #endif
 	initial_code = (unsigned long)wakeup_long64;
-       saved_magic = 0x123456789abcdef0L;
+	saved_magic = 0x123456789abcdef0L;
 #endif /* CONFIG_64BIT */
 
 	/*
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 82c783da16a8..797ae1a15c91 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -108,6 +108,7 @@ static void __used common(void)
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
 	OFFSET(X86_top_of_stack, pcpu_hot, top_of_stack);
+	OFFSET(X86_current_task, pcpu_hot, current_task);
 #ifdef CONFIG_CALL_DEPTH_TRACKING
 	OFFSET(X86_call_depth, pcpu_hot, call_depth);
 #endif
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 222efd4a09bc..cc1b145055ac 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -61,8 +61,8 @@ SYM_CODE_START_NOALIGN(startup_64)
 	 * tables and then reload them.
 	 */
 
-	/* Set up the stack for verify_cpu(), similar to initial_stack below */
-	leaq	(__end_init_task - FRAME_SIZE)(%rip), %rsp
+	/* Set up the stack for verify_cpu() */
+	leaq	(__end_init_task - PTREGS_SIZE)(%rip), %rsp
 
 	leaq	_text(%rip), %rdi
 
@@ -241,6 +241,24 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	UNWIND_HINT_EMPTY
 	ANNOTATE_NOENDBR // above
 
+#ifdef CONFIG_SMP
+	movl	smpboot_control(%rip), %ecx
+
+	/* Get the per cpu offset for the given CPU# which is in ECX */
+	movq	__per_cpu_offset(,%rcx,8), %rdx
+#else
+	xorl	%edx, %edx /* zero-extended to clear all of RDX */
+#endif /* CONFIG_SMP */
+
+	/*
+	 * Setup a boot time stack - Any secondary CPU will have lost its stack
+	 * by now because the cr3-switch above unmaps the real-mode stack.
+	 *
+	 * RDX contains the per-cpu offset
+	 */
+	movq	pcpu_hot + X86_current_task(%rdx), %rax
+	movq	TASK_threadsp(%rax), %rsp
+
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -275,12 +293,6 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	movl	initial_gs+4(%rip),%edx
 	wrmsr
 
-	/*
-	 * Setup a boot time stack - Any secondary CPU will have lost its stack
-	 * by now because the cr3-switch above unmaps the real-mode stack
-	 */
-	movq initial_stack(%rip), %rsp
-
 	/* Setup and Load IDT */
 	pushq	%rsi
 	call	early_setup_idt
@@ -372,7 +384,11 @@ SYM_CODE_END(secondary_startup_64)
 SYM_CODE_START(start_cpu0)
 	ANNOTATE_NOENDBR
 	UNWIND_HINT_EMPTY
-	movq	initial_stack(%rip), %rsp
+
+	/* Find the idle task stack */
+	movq	PER_CPU_VAR(pcpu_hot) + X86_current_task, %rcx
+	movq	TASK_threadsp(%rcx), %rsp
+
 	jmp	.Ljump_to_C_code
 SYM_CODE_END(start_cpu0)
 #endif
@@ -420,12 +436,6 @@ SYM_DATA(initial_gs,	.quad INIT_PER_CPU_VAR(fixed_percpu_data))
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
 #endif
-
-/*
- * The FRAME_SIZE gap is a convention which helps the in-kernel unwinder
- * reliably detect the end of the stack.
- */
-SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
 	__FINITDATA
 
 	__INIT
@@ -660,6 +670,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+	.align 16
+SYM_DATA(smpboot_control,		.long 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fa1e35b0747c..ab8decac6294 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1112,7 +1112,12 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	idle->thread.sp = (unsigned long)task_pt_regs(idle);
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 	initial_code = (unsigned long)start_secondary;
-	initial_stack  = idle->thread.sp;
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
+		initial_stack  = idle->thread.sp;
+	} else {
+		smpboot_control = cpu;
+	}
 
 	/* Enable the espfix hack for this CPU */
 	init_espfix_ap(cpu);
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index ffaa62167f6e..6bd391476656 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -49,7 +49,7 @@ SYM_CODE_START(startup_xen)
 	ANNOTATE_NOENDBR
 	cld
 
-	mov initial_stack(%rip), %rsp
+	leaq	(__end_init_task - PTREGS_SIZE)(%rip), %rsp
 
 	/* Set up %gs.
 	 *
-- 
2.25.1

