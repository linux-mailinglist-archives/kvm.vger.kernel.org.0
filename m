Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE96688960
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 22:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjBBV5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 16:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbjBBV5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 16:57:17 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820E67266F
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 13:56:37 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m14so2960390wrg.13
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 13:56:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uq4IIFgjFjjgLZ+/cLmi0nocsO1Q7ZxNrpkj/NM56gw=;
        b=omal6vPRAFRonalxLv24xaEfbKC/ulBQ4UjQAurWupkCFaMIwhsG6z88M0drVXQuim
         dSiM341KsSm0Thqujea1m9ci1noUAJv0+wTviAIkog8TUPCYKOWCiqFzMV+WmQ68v1rg
         nbDvkDFMN1CQx9o4oYWcyntuUp9ufmo+xqRagAG/vDECcFk7We4/ototM2rXrUqvdwGY
         urTOniol4f1QV0DQirwhlYTNG3LTdLjVCB9me1iGCp2McgTqJM4lcSHhnLhNzxNvMzcc
         r+4x1YLOSF7/Eao8DrYosokkzKneRWY8hzO8Rl2gun/bnTVWS2gtGJz1hUGEA4zJ9yTw
         lVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uq4IIFgjFjjgLZ+/cLmi0nocsO1Q7ZxNrpkj/NM56gw=;
        b=eCK0eT2IlxCMGOEzLmIJyhYzKFuMZfQNFY+vQtIv40GvdSVUlwb0t6d/PU3H3hSN9+
         ahj3s5GFvAKPoricMiAJYDm6dMOMt0xkkK15zdwU31UGUNHp73roKGRP6cKbyF8Y0MrR
         btWWOPvy2InLjy3lGaPjXZCfv7u5BvxQTS38l5TTgiCEJ5Y+LOQk3am049vQOTWoNY93
         Qs4D099E319hPd+BakxQ16mLwjI+fbpDIrrAGlkOz2OJfvd/d9BK7Q0OsNVULW87I10l
         sRN2ed0AQ8VzmqjvyyGKKa292S+JkNJYd5vDp4CiXCmuPPFOtwu86l0hJxKd146rb7tW
         +hLg==
X-Gm-Message-State: AO0yUKXO9i1T/oBOEcMO277SNpQoqALM5nL3kX4qTLTJnKfRf8afDvGJ
        ktIdsFtlG5imWJO5J01C1xHlGw==
X-Google-Smtp-Source: AK7set8po8chdbyBnFqBby/cvdYIQfFZm8tqPTXbeu488YoOwmvbXmb7N8xrf8iZOI3rZovBysc0mg==
X-Received: by 2002:adf:b612:0:b0:2c3:cf13:c46 with SMTP id f18-20020adfb612000000b002c3cf130c46mr231369wre.53.1675374995961;
        Thu, 02 Feb 2023 13:56:35 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:98fe:e4ee:fc7e:cd71])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d6d08000000b00297dcfdc90fsm506078wrq.24.2023.02.02.13.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 13:56:35 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v6 06/11] x86/smpboot: Support parallel startup of secondary CPUs
Date:   Thu,  2 Feb 2023 21:56:20 +0000
Message-Id: <20230202215625.3248306-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202215625.3248306-1-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

To allow for parallel AP bringup, we need to avoid the use of global
variables for passing information to the APs, as well as preventing them
from all trying to use the same real-mode stack simultaneously.

So, introduce a 'lock' field in struct trampoline_header to use as a
simple bit-spinlock for the real-mode stack. That lock also protects
the global variables initial_gs, initial_stack and early_gdt_descr,
which can now be calculated...

So how do we calculate those addresses? Well, they they can all be found
from the per_cpu data for this CPU. Simples! Except... how does it know
what its CPU# is? OK, we export the cpuid_to_apicid[] array and it can
search it to find its APIC ID in there.

But now you whine at me that it doesn't even know its APIC ID? Well, if
it's a relatively modern CPU then the APIC ID is in CPUID leaf 0x0B so
we can use that. Otherwise... erm... OK, otherwise it can't have parallel
CPU bringup for now. We'll still use a global variable for those CPUs and
bring them up one at a time.

So add a global 'smpboot_control' field which either contains the APIC
ID, or a flag indicating that it can be found in CPUID.

This adds the 'do_parallel_bringup' flag in preparation but doesn't
actually enable parallel bringup yet.

[ dwmw2: Minor tweaks, write a commit message ]
[ seanc: Fix stray override of initial_gs in common_cpu_up() ]
Not-signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
---
 arch/x86/include/asm/realmode.h      |  3 ++
 arch/x86/include/asm/smp.h           |  9 +++-
 arch/x86/kernel/acpi/sleep.c         |  1 +
 arch/x86/kernel/apic/apic.c          |  2 +-
 arch/x86/kernel/head_64.S            | 75 ++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c            | 34 +++++++++++--
 arch/x86/realmode/init.c             |  3 ++
 arch/x86/realmode/rm/trampoline_64.S | 14 ++++++
 kernel/smpboot.c                     |  2 +-
 9 files changed, 136 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index a336feef0af1..f0357cfe2fb0 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -52,6 +52,7 @@ struct trampoline_header {
 	u64 efer;
 	u32 cr4;
 	u32 flags;
+	u32 lock;
 #endif
 };
 
@@ -65,6 +66,8 @@ extern unsigned long initial_stack;
 extern unsigned long initial_vc_handler;
 #endif
 
+extern u32 *trampoline_lock;
+
 extern unsigned char real_mode_blob[];
 extern unsigned char real_mode_relocs[];
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index b4dbb20dab1a..9b3c0cd35f5f 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -199,5 +199,12 @@ extern void nmi_selftest(void);
 #define nmi_selftest() do { } while (0)
 #endif
 
-#endif /* __ASSEMBLY__ */
+extern unsigned int smpboot_control;
+
+#endif /* !__ASSEMBLY__ */
+
+/* Control bits for startup_64 */
+#define	STARTUP_PARALLEL	0x80000000
+#define	STARTUP_SECONDARY	0x40000000
+
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 3b7f4cdbf2e0..06adf340a0f1 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -115,6 +115,7 @@ int x86_acpi_suspend_lowlevel(void)
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
+	smpboot_control = 0;
 #endif
 	initial_code = (unsigned long)wakeup_long64;
        saved_magic = 0x123456789abcdef0L;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 20d9a604da7c..ac1d7e5da1f2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2377,7 +2377,7 @@ static int nr_logical_cpuids = 1;
 /*
  * Used to store mapping between logical CPU IDs and APIC IDs.
  */
-static int cpuid_to_apicid[] = {
+int cpuid_to_apicid[] = {
 	[0 ... NR_CPUS - 1] = -1,
 };
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 222efd4a09bc..d07f694691d2 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -241,6 +242,68 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	UNWIND_HINT_EMPTY
 	ANNOTATE_NOENDBR // above
 
+#ifdef CONFIG_SMP
+	/*
+	 * Is this the boot CPU coming up? If so everything is available
+	 * in initial_gs, initial_stack and early_gdt_descr.
+	 */
+	movl	smpboot_control(%rip), %eax
+	testl	%eax, %eax
+	jz	.Lsetup_cpu
+
+	/*
+	 * Secondary CPUs find out the offsets via the APIC ID. For parallel
+	 * boot the APIC ID is retrieved from CPUID, otherwise it's encoded
+	 * in smpboot_control:
+	 * Bit 0-29	APIC ID if STARTUP_PARALLEL flag is not set
+	 * Bit 30	STARTUP_SECONDARY flag
+	 * Bit 31	STARTUP_PARALLEL flag (use CPUID 0x0b for APIC ID)
+	 */
+	testl	$STARTUP_PARALLEL, %eax
+	jnz	.Luse_cpuid_0b
+	andl	$0x0FFFFFFF, %eax
+	jmp	.Lsetup_AP
+
+.Luse_cpuid_0b:
+	mov	$0x0B, %eax
+	xorl	%ecx, %ecx
+	cpuid
+	mov	%edx, %eax
+
+.Lsetup_AP:
+	/* EAX contains the APICID of the current CPU */
+	xorl	%ecx, %ecx
+	leaq	cpuid_to_apicid(%rip), %rbx
+
+.Lfind_cpunr:
+	cmpl	(%rbx), %eax
+	jz	.Linit_cpu_data
+	addq	$4, %rbx
+	addq	$8, %rcx
+	jmp	.Lfind_cpunr
+
+.Linit_cpu_data:
+	/* Get the per cpu offset */
+	leaq	__per_cpu_offset(%rip), %rbx
+	addq	%rcx, %rbx
+	movq	(%rbx), %rbx
+	/* Save it for GS BASE setup */
+	movq	%rbx, initial_gs(%rip)
+
+	/* Calculate the GDT address */
+	movq	$gdt_page, %rcx
+	addq	%rbx, %rcx
+	movq	%rcx, early_gdt_descr_base(%rip)
+
+	/* Find the idle task stack */
+	movq	$idle_threads, %rcx
+	addq	%rbx, %rcx
+	movq	(%rcx), %rcx
+	movq	TASK_threadsp(%rcx), %rcx
+	movq	%rcx, initial_stack(%rip)
+#endif /* CONFIG_SMP */
+
+.Lsetup_cpu:
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -281,6 +344,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	 */
 	movq initial_stack(%rip), %rsp
 
+	/* Drop the realmode protection. For the boot CPU the pointer is NULL! */
+	movq	trampoline_lock(%rip), %rax
+	testq	%rax, %rax
+	jz	.Lsetup_idt
+	lock
+	btrl	$0, (%rax)
+
+.Lsetup_idt:
 	/* Setup and Load IDT */
 	pushq	%rsi
 	call	early_setup_idt
@@ -426,6 +497,7 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
  * reliably detect the end of the stack.
  */
 SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
 	__INIT
@@ -660,6 +732,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+	.align 16
+SYM_DATA(smpboot_control,		.long 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index fdcf7c08945f..741da8d306a4 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -800,6 +800,16 @@ static int __init cpu_init_udelay(char *str)
 }
 early_param("cpu_init_udelay", cpu_init_udelay);
 
+static bool do_parallel_bringup = true;
+
+static int __init no_parallel_bringup(char *str)
+{
+	do_parallel_bringup = false;
+
+	return 0;
+}
+early_param("no_parallel_bringup", no_parallel_bringup);
+
 static void __init smp_quirk_init_udelay(void)
 {
 	/* if cmdline changed it from default, leave it alone */
@@ -1087,8 +1097,6 @@ int common_cpu_up(unsigned int cpu, struct task_struct *idle)
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	per_cpu(pcpu_hot.top_of_stack, cpu) = task_top_of_stack(idle);
-#else
-	initial_gs = per_cpu_offset(cpu);
 #endif
 	return 0;
 }
@@ -1113,9 +1121,16 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 		start_ip = real_mode_header->trampoline_start64;
 #endif
 	idle->thread.sp = (unsigned long)task_pt_regs(idle);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 	initial_code = (unsigned long)start_secondary;
-	initial_stack  = idle->thread.sp;
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
+		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
+		initial_stack  = idle->thread.sp;
+	} else if (do_parallel_bringup) {
+		smpboot_control = STARTUP_SECONDARY | STARTUP_PARALLEL;
+	} else {
+		smpboot_control = STARTUP_SECONDARY | apicid;
+	}
 
 	/* Enable the espfix hack for this CPU */
 	init_espfix_ap(cpu);
@@ -1515,6 +1530,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	speculative_store_bypass_ht_init();
 
+	/*
+	 * We can do 64-bit AP bringup in parallel if the CPU reports its
+	 * APIC ID in CPUID leaf 0x0B. Otherwise it's too hard. And not
+	 * for SEV-ES guests because they can't use CPUID that early.
+	 * Also, some AMD CPUs crash when doing parallel cpu bringup, disable
+	 * it for all AMD CPUs to be on the safe side.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 0x0B ||
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		do_parallel_bringup = false;
+
 	snp_set_wakeup_secondary_cpu();
 }
 
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index af565816d2ba..788e5559549f 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -154,6 +154,9 @@ static void __init setup_real_mode(void)
 
 	trampoline_header->flags = 0;
 
+	trampoline_lock = &trampoline_header->lock;
+	*trampoline_lock = 0;
+
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
 
 	/* Map the real mode stub as virtual == physical */
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index e38d61d6562e..49ebc1636ffd 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -49,6 +49,19 @@ SYM_CODE_START(trampoline_start)
 	mov	%ax, %es
 	mov	%ax, %ss
 
+	/*
+	 * Make sure only one CPU fiddles with the realmode stack
+	 */
+.Llock_rm:
+	btl	$0, tr_lock
+	jnc	2f
+	pause
+	jmp	.Llock_rm
+2:
+	lock
+	btsl	$0, tr_lock
+	jc	.Llock_rm
+
 	# Setup stack
 	movl	$rm_stack_end, %esp
 
@@ -241,6 +254,7 @@ SYM_DATA_START(trampoline_header)
 	SYM_DATA(tr_efer,		.space 8)
 	SYM_DATA(tr_cr4,		.space 4)
 	SYM_DATA(tr_flags,		.space 4)
+	SYM_DATA(tr_lock,		.space 4)
 SYM_DATA_END(trampoline_header)
 
 #include "trampoline_common.S"
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 2c7396da470c..a18a21dff9bc 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -25,7 +25,7 @@
  * For the hotplug case we keep the task structs around and reuse
  * them.
  */
-static DEFINE_PER_CPU(struct task_struct *, idle_threads);
+DEFINE_PER_CPU(struct task_struct *, idle_threads);
 
 struct task_struct *idle_thread_get(unsigned int cpu)
 {
-- 
2.25.1

