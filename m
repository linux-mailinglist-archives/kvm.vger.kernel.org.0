Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B96074A666E
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbiBAUyD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiBAUx5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:53:57 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2167C06173D;
        Tue,  1 Feb 2022 12:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=T/y9+ZKjjOzetEeGkpnHsxgK6BbJdBIFXiCOjzvuDDY=; b=EJD6nD3zIblNVE1KIZZF6xTn4R
        qzM00OzDcYBA88b5wpfI2j8aSMiKsFaUuvcC+P0OAI2eeXC6q1TlV1W4Vg358Wb6+WsagAdOVSVgR
        qphgwjbqK31Q+CYmb7ob/sQttn3LVSXd7joBy0mXz3OZ/ie4h59/93yW4SRTfqtUY78K8+Yb3crg3
        pcOWXo4pnfbKLiQcSGZNv7d/VvBUg83uojVbfAUcP04FO3BmpjJHcFSgMzv2bXvKaOZTjJXMDeaLl
        ECoACcy4M4vxBNq72EvM5EPW13FWXq7rMUzxBUlamsA6VNKrkfH2qBkvQMi9VMui/wCDG7oFo0El7
        taj60+eQ==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09b-00D5CP-8m; Tue, 01 Feb 2022 20:53:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09a-001Edr-3k; Tue, 01 Feb 2022 20:53:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH v4 6/9] x86/smpboot: Support parallel startup of secondary CPUs
Date:   Tue,  1 Feb 2022 20:53:25 +0000
Message-Id: <20220201205328.123066-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220201205328.123066-1-dwmw2@infradead.org>
References: <20220201205328.123066-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
---
 arch/x86/include/asm/realmode.h      |  3 ++
 arch/x86/include/asm/smp.h           |  9 +++-
 arch/x86/kernel/acpi/sleep.c         |  1 +
 arch/x86/kernel/apic/apic.c          |  2 +-
 arch/x86/kernel/head_64.S            | 73 ++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c            | 32 ++++++++++--
 arch/x86/realmode/init.c             |  3 ++
 arch/x86/realmode/rm/trampoline_64.S | 14 ++++++
 kernel/smpboot.c                     |  2 +-
 9 files changed, 132 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 331474b150f1..1693bc834163 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -51,6 +51,7 @@ struct trampoline_header {
 	u64 efer;
 	u32 cr4;
 	u32 flags;
+	u32 lock;
 #endif
 };
 
@@ -64,6 +65,8 @@ extern unsigned long initial_stack;
 extern unsigned long initial_vc_handler;
 #endif
 
+extern u32 *trampoline_lock;
+
 extern unsigned char real_mode_blob[];
 extern unsigned char real_mode_relocs[];
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 81a0211a372d..4fe1320c2e8d 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -196,5 +196,12 @@ extern void nmi_selftest(void);
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
index 1e97f944b47d..4f26cc9346ac 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -114,6 +114,7 @@ int x86_acpi_suspend_lowlevel(void)
 	early_gdt_descr.address =
 			(unsigned long)get_cpu_gdt_rw(smp_processor_id());
 	initial_gs = per_cpu_offset(smp_processor_id());
+	smpboot_control = 0;
 #endif
 	initial_code = (unsigned long)wakeup_long64;
        saved_magic = 0x123456789abcdef0L;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b70344bf6600..5b20e051d84c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2335,7 +2335,7 @@ static int nr_logical_cpuids = 1;
 /*
  * Used to store mapping between logical CPU IDs and APIC IDs.
  */
-static int cpuid_to_apicid[] = {
+int cpuid_to_apicid[] = {
 	[0 ... NR_CPUS - 1] = -1,
 };
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 9c63fc5988cd..b0d8c9fffc73 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -193,6 +194,66 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 1:
 	UNWIND_HINT_EMPTY
 
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
+
+.Lsetup_cpu:
 	/*
 	 * We must switch to a new descriptor in kernel space for the GDT
 	 * because soon the kernel won't have access anymore to the userspace
@@ -233,6 +294,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
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
@@ -364,6 +433,7 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
  * reliably detect the end of the stack.
  */
 SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
 	__INIT
@@ -589,6 +659,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+	.align 16
+SYM_DATA(smpboot_control,		.long 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 38c5d65a568d..e060bbd79cc2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -808,6 +808,16 @@ static int __init cpu_init_udelay(char *str)
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
@@ -1095,8 +1105,6 @@ int common_cpu_up(unsigned int cpu, struct task_struct *idle)
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	per_cpu(cpu_current_top_of_stack, cpu) = task_top_of_stack(idle);
-#else
-	initial_gs = per_cpu_offset(cpu);
 #endif
 	return 0;
 }
@@ -1115,9 +1123,16 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	unsigned long boot_error = 0;
 
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
@@ -1516,6 +1531,15 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	smp_quirk_init_udelay();
 
 	speculative_store_bypass_ht_init();
+
+	/*
+	 * We can do 64-bit AP bringup in parallel if the CPU reports its
+	 * APIC ID in CPUID leaf 0x0B. Otherwise it's too hard. And not
+	 * for SEV-ES guests because they can't use CPUID that early.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 0x0B ||
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		do_parallel_bringup = false;
 }
 
 void arch_thaw_secondary_cpus_begin(void)
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index c5e29db02a46..21b9e8b55618 100644
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
index cc8391f86cdb..12a540904e80 100644
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
 
@@ -192,6 +205,7 @@ SYM_DATA_START(trampoline_header)
 	SYM_DATA(tr_efer,		.space 8)
 	SYM_DATA(tr_cr4,		.space 4)
 	SYM_DATA(tr_flags,		.space 4)
+	SYM_DATA(tr_lock,		.space 4)
 SYM_DATA_END(trampoline_header)
 
 #include "trampoline_common.S"
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index f6bc0bc8a2aa..934e64ff4eed 100644
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
2.33.1

