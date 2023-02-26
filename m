Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630FC6A2F3A
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBZLI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjBZLIl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:08:41 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075E0D326
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:12 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso618854wmq.1
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/vcGB3tRiPqgIjGstr77HWq6H41b6Xz6eyjpGifXDM=;
        b=C3SqKIThhTfaMRirw+2QelUYjbwo9roa+7rXabxBaMR7RmAMK7OOh+HPfPvyuKktfP
         AXVauvuRgbNfibMHLPZ8BiuNnE6APMiMWUhZuHMya4ztY4vR63hnsF+twu6QZYw1lwfV
         MTJgF6KXtwKl0fg1OvZGtvZQcIeNaFAegMzZp/f2TolsAxwx2UnX5BPTWN3ZNQebZfnh
         7zln4a5UXunWlVs10HjwK0MfYcQ4e5ma6wF/cYmtj+PaWV9UsHcT75T9M4jY7jgib94x
         m0qnVaAmqHb1Oyep/vcRptVrzUinPU92cGHsH8zaZR2L16lgcoaq9BgTE+3P4+j4e0Dk
         N/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/vcGB3tRiPqgIjGstr77HWq6H41b6Xz6eyjpGifXDM=;
        b=CASC3BT3II+ViSgPJU+riu5F6mdbKi65VoIj3ZptOKbA1IAiRqUb8PPx+dYs84lsbm
         kURp7EUePBsxL7cimeEfjdpL9jv7bDi54BERz8sUqHueK0gyW9nfBvnUD5Gn3TPL8F/7
         kFjT5gYFcHWzy6nepAn758temGpG9qbWhxBiUe9n4/JOkqHjCmcc6xSidsWlqZkDSfnY
         eaC7pdiriJ21ZW9k+ePSnlt9eLR85+AcoM8CPsOHY4eCkYSA7ob9nIH4U0VVI+YceQIB
         zggmC6E2TDWIDYTM39LLVFeBbe4x5ofNfooS4H9S1yJFSAx9cV2cTTHWqUbs6J31zshI
         1dkg==
X-Gm-Message-State: AO0yUKVDU5LNgQ5ISiGda9S8sV1SWyCQPtqrz+OpxXcZA7twW3ovriXQ
        8AagDDI58FOmHvEQvPZVeU9aQQ==
X-Google-Smtp-Source: AK7set9mL8Niyd0GcyAD80gTw0dOANgXeCK88Szy7Y9FMs2NS9e/IcJVyYZXlOxdJM8d3LUJSSX40A==
X-Received: by 2002:a05:600c:3c91:b0:3eb:36fa:b78d with SMTP id bg17-20020a05600c3c9100b003eb36fab78dmr2533431wmb.23.1677409690383;
        Sun, 26 Feb 2023 03:08:10 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:10 -0800 (PST)
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
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v12 06/11] x86/smpboot: Remove initial_stack on 64-bit
Date:   Sun, 26 Feb 2023 11:07:57 +0000
Message-Id: <20230226110802.103134-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
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

Eliminating global variables from the CPU startup path in order to simplify
it and facilitate parallel startup.

Remove initial_stack, and load RSP from current_task->thread.sp instead.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/include/asm/processor.h |  6 ++++-
 arch/x86/include/asm/smp.h       |  5 +++-
 arch/x86/kernel/acpi/sleep.c     |  5 ++--
 arch/x86/kernel/asm-offsets.c    |  1 +
 arch/x86/kernel/head_64.S        | 43 +++++++++++++++++++++-----------
 arch/x86/kernel/smpboot.c        |  7 +++++-
 arch/x86/xen/xen-head.S          |  2 +-
 7 files changed, 48 insertions(+), 21 deletions(-)

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
index 3b7f4cdbf2e0..ab6e29b32c04 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -111,13 +111,14 @@ int x86_acpi_suspend_lowlevel(void)
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
-	initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
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
index 222efd4a09bc..5a2417d788d1 100644
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
+	xorl	%edx, %edx
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
index b18c1385e181..62e3bf37f0b8 100644
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

