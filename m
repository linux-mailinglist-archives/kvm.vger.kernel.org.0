Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD1D4742A5
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 13:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhLNMd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 07:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhLNMdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 07:33:19 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C296AC061756;
        Tue, 14 Dec 2021 04:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JRJ9oSUgWPDlmSMC+D0In2tFCVfBKxWqYwFaYUGh2hw=; b=cGRb5fq++k8rPaB9KAgl4n/r/5
        /RbcyR1IzixJHLoYfu4oEStgvSAjozfMQu12J+0f8ZK5R8HfOdCfFODCwtBRyauYxnUbesEb63hch
        8xZmv9YVMsezM/+61tFeYIBimj7lN50duKAEsuL/34ZakZ+fIabOIqB/C9yj1m+V2I8neLiTJ4v9v
        R5iCHqvdrG6OW+nqwF8kpr9mVO7+MvhBKfM4xmhqqdAoehyej8PnPJBjBxhMrJkjcTbfqE8dQd8Wk
        rkYqw5R4DOXoJ9VqlNiKa9eYtKhAAY0VKsvhvHxeYnCZ8Fd+TmUkJ11gwRWZ6u3+YuzTtgKQufj9d
        tlUiRdLQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx6zF-001JJO-7N; Tue, 14 Dec 2021 12:32:53 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx6zE-000N6j-Re; Tue, 14 Dec 2021 12:32:52 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH v2 6/7] x86/smpboot: Support parallel startup of secondary CPUs
Date:   Tue, 14 Dec 2021 12:32:49 +0000
Message-Id: <20211214123250.88230-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214123250.88230-1-dwmw2@infradead.org>
References: <20211214123250.88230-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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

[ dwmw2: Minor tweaks, write a commit message ]
Not-signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 arch/x86/include/asm/realmode.h      |  3 ++
 arch/x86/include/asm/smp.h           |  9 +++-
 arch/x86/kernel/acpi/sleep.c         |  1 +
 arch/x86/kernel/apic/apic.c          |  2 +-
 arch/x86/kernel/head_64.S            | 71 ++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c            | 14 +++++-
 arch/x86/realmode/init.c             |  3 ++
 arch/x86/realmode/rm/trampoline_64.S | 14 ++++++
 kernel/smpboot.c                     |  2 +-
 9 files changed, 114 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index 5db5d083c873..e1cc4bc746bc 100644
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
index 81a0211a372d..ca807c29dc34 100644
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
+#define	STARTUP_USE_APICID	0x10000
+#define	STARTUP_USE_CPUID_0B	0x20000
+
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 3f85fcae450c..9598ebf4f9d6 100644
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
index d8b3ebd2bb85..0249212e23d2 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -176,6 +177,64 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
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
+	 * Bit 0-15	APICID if STARTUP_USE_CPUID_0B is not set
+	 * Bit 16 	Secondary boot flag
+	 * Bit 17	Parallel boot flag
+	 */
+	testl	$STARTUP_USE_CPUID_0B, %eax
+	jz	.Lsetup_AP
+
+	mov	$0x0B, %eax
+	xorl	%ecx, %ecx
+	cpuid
+	mov	%edx, %eax
+
+.Lsetup_AP:
+	/* EAX contains the APICID of the current CPU */
+	andl	$0xFFFF, %eax
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
@@ -216,6 +275,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
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
@@ -347,6 +414,7 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
  * reliably detect the end of the stack.
  */
 SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
 	__INIT
@@ -572,6 +640,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+	.align 16
+SYM_DATA(smpboot_control,		.long 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7a763b84b6e5..1e38d44c3603 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1104,9 +1104,19 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	unsigned long boot_error = 0;
 
 	idle->thread.sp = (unsigned long)task_pt_regs(idle);
-	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 	initial_code = (unsigned long)start_secondary;
-	initial_stack  = idle->thread.sp;
+
+	if (IS_ENABLED(CONFIG_X86_32)) {
+		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
+		initial_stack  = idle->thread.sp;
+	} else if (boot_cpu_data.cpuid_level < 0x0B) {
+		/* Anything with X2APIC should have CPUID leaf 0x0B */
+		if (WARN_ON_ONCE(x2apic_mode) && apicid > 0xffff)
+			return -EIO;
+		smpboot_control = apicid | STARTUP_USE_APICID;
+	} else {
+		smpboot_control = STARTUP_USE_CPUID_0B;
+	}
 
 	/* Enable the espfix hack for this CPU */
 	init_espfix_ap(cpu);
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 4a3da7592b99..7dc2e817bd02 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -127,6 +127,9 @@ static void __init setup_real_mode(void)
 
 	trampoline_header->flags = 0;
 
+	trampoline_lock = &trampoline_header->lock;
+	*trampoline_lock = 0;
+
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
 	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
 	trampoline_pgd[511] = init_top_pgt[511].pgd;
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
2.31.1

