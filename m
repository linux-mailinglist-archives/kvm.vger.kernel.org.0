Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E36A105F
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 20:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbjBWTNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 14:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbjBWTNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 14:13:12 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E525BBB9
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:23 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id o4-20020a05600c4fc400b003e1f5f2a29cso257026wmq.4
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 11:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wL4H6dkwiqQh7dcmIrLqt3HZrti5VJpIfMc44frmzHc=;
        b=Z+5BzDDrPRuwK1aoLnVaWnL5dhdfm1qA4XC8szYEgLwxcNNkKR7N1jrdZUW8KEWp0r
         ooYGJUtsbba00Y/hcT4cdNn2uc+6w59DOT51XHq8wkNlj1qgwWVTvjDjUiFC3ZFQToAM
         Ms/4rjIXTj2kdOLZklcn7MemtWoO5VOYBGMjSb5QcoQKZg2bNnOZRgeY3otdukJX0KNl
         BffMhFJReoM18BJOkeYVYcZVKuaGFxn5NJNeSccfuIgvSMAAOL6Gq4tvOWjQeorYSe8d
         JHZI4Woj5seaPOAbsH+RKe4gXlSOJ5xsX4e0EjXjAxBad9J0hkle5NxDW9QiNVwK7Dd4
         3Jng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wL4H6dkwiqQh7dcmIrLqt3HZrti5VJpIfMc44frmzHc=;
        b=PeHAwsnHM1yBQEC8ILLAxVtwllA82AqoHzNc39lfWKzTBGrUCv3J/6XqDDsGX5F+VC
         0UYh2D3L9nAiGHleAz8munv5asiahfbKOH30r3ZwJ8NtxIsVZ6LY0Ug0wWDncDCaXA4V
         7EsYAEb4iq+Q3vhMjD1hDcDG4VosE/vnuf/LNDqGhuqzRtY6QB+BpUZTms2nMg8BNMs8
         rCusV2BV/ppW8v+f6Be10Nc9Ey+2vJHco2TL89rPB2jV50qQei9Nab71MRnEFR1BvNVG
         iucPC9xllD9E2x0c4kZzZ7MoEHN/JKfyxRrTx8pXbuihp6zOSPKREuh9McvC5rD5tRp0
         W+xA==
X-Gm-Message-State: AO0yUKVsbAqUAKpZJc4H3x2Krut9nPA4s+r4b8bJh0MaBFuu4QSFMlQ2
        PCMvnmJcly6gGTKav9xKyHt6lQ==
X-Google-Smtp-Source: AK7set/i/tUmeSAqCjCLwUvGyPjzOdFNkTGXwh64luEnmTYt0vhptfrKuJRFKMaio2gKHRJgbXUy3w==
X-Received: by 2002:a05:600c:3b9f:b0:3e9:9fc5:2c6d with SMTP id n31-20020a05600c3b9f00b003e99fc52c6dmr4257178wms.14.1677179511475;
        Thu, 23 Feb 2023 11:11:51 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:5ee0:5af0:64bd:6198])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b002c561805a4csm12957286wrt.45.2023.02.23.11.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 11:11:51 -0800 (PST)
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
Subject: [PATCH v11 09/12] x86/smpboot: Remove initial_stack on 64-bit
Date:   Thu, 23 Feb 2023 19:11:37 +0000
Message-Id: <20230223191140.4155012-10-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230223191140.4155012-1-usama.arif@bytedance.com>
References: <20230223191140.4155012-1-usama.arif@bytedance.com>
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

Load RSP from current_task->thread.sp instead.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/include/asm/processor.h |  6 +++++-
 arch/x86/kernel/acpi/sleep.c     |  2 +-
 arch/x86/kernel/head_64.S        | 35 ++++++++++++++++++--------------
 arch/x86/xen/xen-head.S          |  2 +-
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4e35c66edeb7..9c4a5c4d46c1 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -648,7 +648,11 @@ static inline void spin_lock_prefetch(const void *x)
 #define KSTK_ESP(task)		(task_pt_regs(task)->sp)
 
 #else
-#define INIT_THREAD { }
+extern unsigned long __end_init_task[];
+
+#define INIT_THREAD {							\
+	.sp	= (unsigned long)&__end_init_task - PTREGS_SIZE,	\
+}
 
 extern unsigned long KSTK_ESP(struct task_struct *task);
 
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 47e75c056cb5..008fda8b1982 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -113,7 +113,7 @@ int x86_acpi_suspend_lowlevel(void)
 	saved_magic = 0x12345678;
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
-	initial_stack = (unsigned long)temp_stack + sizeof(temp_stack);
+	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index c32e5b06a9ce..f7905ba4b992 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -62,8 +62,8 @@ SYM_CODE_START_NOALIGN(startup_64)
 	 * tables and then reload them.
 	 */
 
-	/* Set up the stack for verify_cpu(), similar to initial_stack below */
-	leaq	(__end_init_task - FRAME_SIZE)(%rip), %rsp
+	/* Set up the stack for verify_cpu() */
+	leaq	(__end_init_task - PTREGS_SIZE)(%rip), %rsp
 
 	leaq	_text(%rip), %rdi
 
@@ -245,11 +245,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 #ifdef CONFIG_SMP
 	/*
 	 * Is this the boot CPU coming up? If so everything is available
-	 * in initial_gs, initial_stack and early_gdt_descr.
+	 * in initial_gs and early_gdt_descr.
 	 */
 	movl	smpboot_control(%rip), %edx
 	testl	$STARTUP_SECONDARY, %edx
-	jz	.Lsetup_cpu
+	jz	.Linit_cpu0_data
 
 	/*
 	 * For parallel boot, the APIC ID is retrieved from CPUID, and then
@@ -302,6 +302,10 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	hlt
 	jmp	1b
 
+.Linit_cpu0_data:
+	movq	__per_cpu_offset(%rip), %rdx
+	jmp	.Lsetup_cpu
+
 .Linit_cpu_data:
 	/* Get the per cpu offset for the given CPU# which is in ECX */
 	leaq	__per_cpu_offset(%rip), %rbx
@@ -314,13 +318,21 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	addq	%rbx, %rcx
 	movq	%rcx, early_gdt_descr_base(%rip)
 
-	/* Find the idle task stack */
-	movq	pcpu_hot + X86_current_task(%rbx), %rcx
-	movq	TASK_threadsp(%rcx), %rcx
-	movq	%rcx, initial_stack(%rip)
+	movq	%rbx, %rdx
+#else
+	xorl	%edx, %edx
 #endif /* CONFIG_SMP */
 
 .Lsetup_cpu:
+	/*
+	 * Setup a boot time stack - Any secondary CPU will have lost its stack
+	 * by now because the cr3-switch above unmaps the real-mode stack
+	 *
+	 * RDX contains the per-cpu offset
+	 */
+	movq	pcpu_hot + X86_current_task(%rdx), %rax
+	movq	TASK_threadsp(%rax), %rsp
+
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -355,12 +367,6 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	movl	initial_gs+4(%rip),%edx
 	wrmsr
 
-	/*
-	 * Setup a boot time stack - Any secondary CPU will have lost its stack
-	 * by now because the cr3-switch above unmaps the real-mode stack
-	 */
-	movq initial_stack(%rip), %rsp
-
 	/* Drop the realmode protection. For the boot CPU the pointer is NULL! */
 	movq	trampoline_lock(%rip), %rax
 	testq	%rax, %rax
@@ -517,7 +523,6 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
  * The FRAME_SIZE gap is a convention which helps the in-kernel unwinder
  * reliably detect the end of the stack.
  */
-SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
 SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
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

