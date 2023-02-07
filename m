Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56A68E42D
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 00:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjBGXFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 18:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBGXF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 18:05:26 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8703FF34
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 15:04:46 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso196863wms.4
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 15:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3DRX0gFO8Y8Ir/xbOPnEtgu7l9ehHqV085Y1j0CPCQ=;
        b=n4vBM9tIf3osRdbZieCcDBcztSBtz7jQzLvrJSOVzwuTTKB8ZcjI9aklMTiTyfW5no
         FvAatTbG6LQ/1n+/0IZmzZ5PRaUtpC8SSeBgEHMNa1h9zfYZ+163K00g671k7RPyvZxS
         lv1fFB0o0/OyfzmX9S/4Bpo6lkIUvWH3dtskdbP93bZi77SgF9aKevs0BpAFppeFWxtG
         8nyO5ejdPLfTdg24NKwUP/LhwSOMxJ8sn19JsFLJm6FBIdHAIF0cX3SRecf9lR4UosYK
         9gUFWBM+TXV+dt42+TenTErQBgTm+HreRtgoTdpMczFRCT7ey9pScsUZtuEi+V4r5Mu/
         SClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l3DRX0gFO8Y8Ir/xbOPnEtgu7l9ehHqV085Y1j0CPCQ=;
        b=c4FcgQ/DP2E+72SvoUisAoTCVZuceBNY3BdmGM0oFTRydDySQ2Se2MUDEtlI/CJiAe
         2VpOjLKSCh1b5GrFP7QYbaWmWXKDs9dzASzcPZGtUnJbZVy0O8pqF4m7+KauemYLbB+z
         A5hcbZhJdwSjlaB7OSGHospiyfzZCbbVeC5THeGnXmI8UwS2muK8S34P3d9HbpYXDis1
         siq+LaJGGx9z2CjsUL765/jh9ibuCsrEY8c5tNqQY5vlaE+/z+HPnL3FkA3/78wEUv46
         kvTWi+LXfPABeECF3L+it3yer1qcxI2e9IBwAIRaQYkpR53mvnZv6WyRdLkkTk94GWxt
         ZNKQ==
X-Gm-Message-State: AO0yUKVG2LKYfRYcCk3/cXLwzciEzXN8dBIukz/+A0MMPL/395D7Z4ya
        ro6JuJHwJDy+xihWq6xELgSfkg==
X-Google-Smtp-Source: AK7set8+uEc+S4g20i4FWiHA99vSogVlWwc/AO81GabN/JySnYqMW/wjcanCca2OgqN/L/rYW11GJQ==
X-Received: by 2002:a05:600c:1c85:b0:3e0:fad:739a with SMTP id k5-20020a05600c1c8500b003e00fad739amr356458wms.31.1675811086104;
        Tue, 07 Feb 2023 15:04:46 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:c04f:2463:c151:8b87])
        by smtp.gmail.com with ESMTPSA id j14-20020a05600c190e00b003dcc82ce53fsm146485wmq.38.2023.02.07.15.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 15:04:45 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v7 6/9] x86/smpboot: Support parallel startup of secondary CPUs
Date:   Tue,  7 Feb 2023 23:04:33 +0000
Message-Id: <20230207230436.2690891-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230207230436.2690891-1-usama.arif@bytedance.com>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Rework the real-mode startup code to allow for APs to be brought up in
parallel. This is in two parts:

1. Introduce a bit-spinlock to prevent them from all using the real
   mode stack at the same time.

2. Avoid the use of global variables for passing per-CPU information to
   the APs.

To achieve the latter, export the cpuid_to_apicid[] array so that each
AP can find its own per_cpu data (and thus initial_gs, initial_stack and
early_gdt_descr) by searching therein based on its APIC ID.

Introduce a global variable 'smpboot_control' indicating to the AP how
it should find its APIC ID. For a serialized bringup, the APIC ID is
explicitly passed in the low bits of smpboot_control, while for parallel
mode there are flags directing the AP to find its APIC ID in CPUID leaf
0x0b (for X2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.

Parallel startup may be disabled by a command line option, and also if:
 • AMD SEV-ES is in use, since the AP may not use CPUID that early.
 • X2APIC is enabled, but CPUID leaf 0xb is not present and correect.
 • X2APIC is not enabled but not even CPUID leaf 0x01 exists.

Aside from the fact that APs will now look up their per-cpu data via the
newly-exported cpuid_to_apicid[] table, there is no behavioural change
intended yet, since new parallel CPUHP states have not — yet — been added.

[ dwmw2: Minor tweaks, write a commit message, add CPUID 0x01 support ]
[ seanc: Fix stray override of initial_gs in common_cpu_up() ]
Not-signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/include/asm/realmode.h      |  3 +
 arch/x86/include/asm/smp.h           | 10 +++-
 arch/x86/kernel/acpi/sleep.c         |  1 +
 arch/x86/kernel/apic/apic.c          |  2 +-
 arch/x86/kernel/head_64.S            | 84 ++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot.c            | 60 ++++++++++++++++++--
 arch/x86/realmode/init.c             |  3 +
 arch/x86/realmode/rm/trampoline_64.S | 14 +++++
 kernel/smpboot.c                     |  2 +-
 9 files changed, 172 insertions(+), 7 deletions(-)

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
index b4dbb20dab1a..33c0d5fd8af6 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -199,5 +199,13 @@ extern void nmi_selftest(void);
 #define nmi_selftest() do { } while (0)
 #endif
 
-#endif /* __ASSEMBLY__ */
+extern unsigned int smpboot_control;
+
+#endif /* !__ASSEMBLY__ */
+
+/* Control bits for startup_64 */
+#define STARTUP_SECONDARY	0x80000000
+#define STARTUP_APICID_CPUID_0B	0x40000000
+#define STARTUP_APICID_CPUID_01	0x20000000
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
index 222efd4a09bc..656e6018b9d4 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -241,6 +242,77 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	UNWIND_HINT_EMPTY
 	ANNOTATE_NOENDBR // above
 
+#ifdef CONFIG_SMP
+	/*
+	 * Is this the boot CPU coming up? If so everything is available
+	 * in initial_gs, initial_stack and early_gdt_descr.
+	 */
+	movl	smpboot_control(%rip), %edx
+	testl	$STARTUP_SECONDARY, %edx
+	jz	.Lsetup_cpu
+
+	/*
+	 * Secondary CPUs find out the offsets via the APIC ID. For parallel
+	 * boot the APIC ID is retrieved from CPUID, otherwise it's encoded
+	 * in smpboot_control:
+	 * Bit 31	STARTUP_SECONDARY flag (checked above)
+	 * Bit 30	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
+	 * Bit 29	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
+	 * Bit 0-24	APIC ID if STARTUP_APICID_CPUID_xx flags are not set
+	 */
+	testl	$STARTUP_APICID_CPUID_0B, %edx
+	jnz	.Luse_cpuid_0b
+	testl	$STARTUP_APICID_CPUID_01, %edx
+	jnz	.Luse_cpuid_01
+	andl	$0x0FFFFFFF, %edx
+	jmp	.Lsetup_AP
+
+.Luse_cpuid_01:
+	mov	$0x01, %eax
+	cpuid
+	mov	%ebx, %edx
+	shr	$24, %edx
+	jmp	.Lsetup_AP
+
+.Luse_cpuid_0b:
+	mov	$0x0B, %eax
+	xorl	%ecx, %ecx
+	cpuid
+
+.Lsetup_AP:
+	/* EDX contains the APICID of the current CPU */
+	xorl	%ecx, %ecx
+	leaq	cpuid_to_apicid(%rip), %rbx
+
+.Lfind_cpunr:
+	cmpl	(%rbx), %edx
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
@@ -281,6 +353,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
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
@@ -426,6 +506,7 @@ SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
  * reliably detect the end of the stack.
  */
 SYM_DATA(initial_stack, .quad init_thread_union + THREAD_SIZE - FRAME_SIZE)
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
 	__INIT
@@ -660,6 +741,9 @@ SYM_DATA_END(level1_fixmap_pgt)
 SYM_DATA(early_gdt_descr,		.word GDT_ENTRIES*8-1)
 SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 
+	.align 16
+SYM_DATA(smpboot_control,		.long 0)
+
 	.align 16
 /* This must match the first entry in level2_kernel_pgt */
 SYM_DATA(phys_base, .quad 0x0)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index eee717086ab7..7abdf347493f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -798,6 +798,16 @@ static int __init cpu_init_udelay(char *str)
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
@@ -1085,8 +1095,6 @@ int common_cpu_up(unsigned int cpu, struct task_struct *idle)
 #ifdef CONFIG_X86_32
 	/* Stack for startup_32 can be just as for start_secondary onwards */
 	per_cpu(pcpu_hot.top_of_stack, cpu) = task_top_of_stack(idle);
-#else
-	initial_gs = per_cpu_offset(cpu);
 #endif
 	return 0;
 }
@@ -1111,9 +1119,14 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
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
+	} else if (!do_parallel_bringup) {
+		smpboot_control = STARTUP_SECONDARY | apicid;
+	}
 
 	/* Enable the espfix hack for this CPU */
 	init_espfix_ap(cpu);
@@ -1513,6 +1526,45 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	speculative_store_bypass_ht_init();
 
+	/*
+	 * We can do 64-bit AP bringup in parallel if the CPU reports
+	 * its APIC ID in CPUID (either leaf 0x0B if we need the full
+	 * APIC ID in X2APIC mode, or leaf 0x01 if 8 bits are
+	 * sufficient). Otherwise it's too hard. And not for SEV-ES
+	 * guests because they can't use CPUID that early.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 1 ||
+	    (x2apic_mode && boot_cpu_data.cpuid_level < 0xb) ||
+	    cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		do_parallel_bringup = false;
+
+	if (do_parallel_bringup && x2apic_mode) {
+		unsigned int eax, ebx, ecx, edx;
+
+		/*
+		 * To support parallel bringup in x2apic mode, the AP will need
+		 * to obtain its APIC ID from CPUID 0x0B, since CPUID 0x01 has
+		 * only 8 bits. Check that it is present and seems correct.
+		 */
+		cpuid_count(0xb, 0, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * AMD says that if executed with an umimplemented level in
+		 * ECX, then it will return all zeroes in EAX. Intel says it
+		 * will return zeroes in both EAX and EBX. Checking only EAX
+		 * should be sufficient.
+		 */
+		if (eax) {
+			smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_0B;
+		} else {
+			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
+			do_parallel_bringup = false;
+		}
+	} else if (do_parallel_bringup) {
+		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
+		smpboot_control = STARTUP_SECONDARY | STARTUP_APICID_CPUID_01;
+	}
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

