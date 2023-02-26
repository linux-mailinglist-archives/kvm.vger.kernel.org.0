Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C006A2F3F
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjBZLJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjBZLJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:09:04 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF59FEC42
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:14 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id m14-20020a7bce0e000000b003e00c739ce4so2178343wmc.5
        for <kvm@vger.kernel.org>; Sun, 26 Feb 2023 03:08:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzUmekMPbLzrMKB3V99ST4NAy6FfmnENiw7vwNG3Fb4=;
        b=e74Yes+0HrptrLTzwkJ6jTGca5uoSq76CrcvghUUav6N/L2Y9visMrtDU/00NdZS2v
         FO0eLxDZe825rcTdNmv7cC3szy3EV7GrjeKD91ddUdTqRs88Hi7rNFiAXSGZI/0zzxx3
         hsstg9zejJsqVixP6nAU05ghYncRUXPDRKlhnaZgYU/gStyOrfpVn7aTlH1En83/QZfy
         bd/6d5DJcgNGSqJiXfsgvYcHeb282UtwX3inCYwwwaXU7m2gktZeK2a6Dbjd5iESkj9/
         LOotGkm56Ta1Ynv9XfXK2PWdEefN3oEyk5VpUG3+5JJi6yD8JJXSbACmDWiQ9iUHCZx5
         jmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzUmekMPbLzrMKB3V99ST4NAy6FfmnENiw7vwNG3Fb4=;
        b=uRvmrcD4ea9VzEg52auKbPkR0VFCsJFJ0JTQe2d3Sfr6lUGbxFTCSqub6a1IpVDZNK
         eJ0VqKTG+pAok50S0bNaDdoJv8eQVc/9y+vQafTIzpnyWT2RDFcjS4I1Pu/L1KHUC4/F
         TuuhPSg9PoS4YJRNfRC/4aMEXUzLTAJt5JlF7szbuHZIla3n1LR8VbTNVIUPN6dXiVnT
         JJ3iRQWOOwNxx4RxFSPMzXpv0QNHFuTbVqQL+Fx6PZE/ZTno91SVkvCjpYIpuJKQ1Y3K
         eJdhHLiktFOu3vVp2K0IrDLvFC0KPrC97YmD4Sg3AsF/5KNN5Ce7805srdpfcMHOXRBy
         SmZA==
X-Gm-Message-State: AO0yUKVL3lQbsEd9TH7rL60fSdIUu/9CtbK7UflDZd3oMggrsCXDgwz8
        eUAEIT2CZuBZTkSxIDLT0akMEw==
X-Google-Smtp-Source: AK7set9ueFEGqxM2UxJ26I/jI2casRahLerNr6XG7V5ZtbgXtHdwISNXWVc4zafF8XZVA07/eZIK+w==
X-Received: by 2002:a05:600c:331b:b0:3eb:2da4:f32d with SMTP id q27-20020a05600c331b00b003eb2da4f32dmr5175389wmp.26.1677409692746;
        Sun, 26 Feb 2023 03:08:12 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:df7b:4668:3e23:d0c9])
        by smtp.gmail.com with ESMTPSA id v22-20020a1cf716000000b003e1fee8baacsm9157318wmh.25.2023.02.26.03.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 03:08:12 -0800 (PST)
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
Subject: [PATCH v12 09/11] x86/smpboot: Support parallel startup of secondary CPUs
Date:   Sun, 26 Feb 2023 11:08:00 +0000
Message-Id: <20230226110802.103134-10-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230226110802.103134-1-usama.arif@bytedance.com>
References: <20230226110802.103134-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: David Woodhouse <dwmw@amazon.co.uk>

Rework the real-mode startup code to allow for APs to be brought up in
parallel. This is in two parts:

1. Introduce a bit-spinlock to prevent them from all using the real
   mode stack at the same time.

2. Avoid needing to use the global smpboot_control variable to pass
   each AP its CPU#.

To achieve the latter, export the cpuid_to_apicid[] array so that each
AP can find its own CPU# by searching therein based on its APIC ID.

Introduce flags in the top bits of smpboot_control which indicate methods
by which an AP should find its CPU#. For a serialized bringup, the CPU#
is explicitly passed in the low bits of smpboot_control as before. For
parallel mode there are flags directing the AP to find its APIC ID in
CPUID leaf 0x0b (for X2APIC mode) or CPUID leaf 0x01 where 8 bits are
sufficient, then perform the cpuid_to_apicid[] lookup with that.

Parallel startup may be disabled by a command line option, and also if:
 • AMD SEV-ES is in use, since the AP may not use CPUID that early.
 • X2APIC is enabled, but CPUID leaf 0xb is not present and correect.
 • X2APIC is not enabled but not even CPUID leaf 0x01 exists.

Aside from the fact that APs will now look up their CPU# via the
newly-exported cpuid_to_apicid[] table, there is no behavioural change
intended yet, since new parallel CPUHP states have not — yet — been
added.

[ tglx: Initial proof of concept patch with bitlock and APIC ID lookup ]
[ dwmw2: Rework and testing, commit message, CPUID 0x1 and CPU0 support ]
[ seanc: Fix stray override of initial_gs in common_cpu_up() ]
[ Oleksandr Natalenko: reported suspend/resume issue fixed in
  x86_acpi_suspend_lowlevel ]
Co-developed-by: Thomas Gleixner <tglx@linutronix.de>
Co-developed-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 .../admin-guide/kernel-parameters.txt         |  3 +
 arch/x86/include/asm/realmode.h               |  3 +
 arch/x86/include/asm/smp.h                    |  6 ++
 arch/x86/kernel/acpi/sleep.c                  |  9 ++-
 arch/x86/kernel/apic/apic.c                   |  2 +-
 arch/x86/kernel/head_64.S                     | 63 ++++++++++++++++++-
 arch/x86/kernel/smpboot.c                     | 53 +++++++++++++++-
 arch/x86/realmode/init.c                      |  3 +
 arch/x86/realmode/rm/trampoline_64.S          | 27 ++++++--
 9 files changed, 159 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3996cf..ee099b8aac6d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3819,6 +3819,9 @@
 
 	nomodule	Disable module load
 
+	no_parallel_bringup
+			[X86,SMP] Disable parallel brinugp of secondary cores.
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index f6a1737c77be..87e5482acd0d 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -52,6 +52,7 @@ struct trampoline_header {
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
index bf2c51df9e0b..1cf4f1e57570 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -203,4 +203,10 @@ extern unsigned int smpboot_control;
 
 #endif /* !__ASSEMBLY__ */
 
+/* Control bits for startup_64 */
+#define STARTUP_APICID_CPUID_0B	0x80000000
+#define STARTUP_APICID_CPUID_01	0x40000000
+
+#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_CPUID_0B)
+
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 9d2d88424c77..5dcf5ca15383 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -16,6 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 #include <asm/hypervisor.h>
+#include <asm/smp.h>
 
 #include <linux/ftrace.h>
 #include "../../realmode/rm/wakeup.h"
@@ -112,7 +113,13 @@ int x86_acpi_suspend_lowlevel(void)
 #else /* CONFIG_64BIT */
 #ifdef CONFIG_SMP
 	current->thread.sp = (unsigned long)temp_stack + sizeof(temp_stack);
-	smpboot_control = smp_processor_id();
+	/*
+	 * Ensure the CPU knows which one it is when it comes back, if
+	 * it isn't in parallel mode and expected to work that out for
+	 * itself.
+	 */
+	if (!(smpboot_control & STARTUP_PARALLEL_MASK))
+		smpboot_control = smp_processor_id();
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
index 069191e33490..17bdd6122dca 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -234,8 +235,57 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR // above
 
 #ifdef CONFIG_SMP
+	/*
+	 * For parallel boot, the APIC ID is retrieved from CPUID, and then
+	 * used to look up the CPU number.  For booting a single CPU, the
+	 * CPU number is encoded in smpboot_control.
+	 *
+	 * Bit 31	STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
+	 * Bit 30	STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
+	 * Bit 0-24	CPU# if STARTUP_APICID_CPUID_xx flags are not set
+	 */
 	movl	smpboot_control(%rip), %ecx
+	testl	$STARTUP_APICID_CPUID_0B, %ecx
+	jnz	.Luse_cpuid_0b
+	testl	$STARTUP_APICID_CPUID_01, %ecx
+	jnz	.Luse_cpuid_01
+	andl	$0x0FFFFFFF, %ecx
+	jmp	.Lsetup_cpu
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
+	/* EDX contains the APIC ID of the current CPU */
+	xorq	%rcx, %rcx
+	leaq	cpuid_to_apicid(%rip), %rbx
 
+.Lfind_cpunr:
+	cmpl	(%rbx,%rcx,4), %edx
+	jz	.Lsetup_cpu
+	inc	%ecx
+	cmpl	nr_cpu_ids(%rip), %ecx
+	jb	.Lfind_cpunr
+
+	/*  APIC ID not found in the table. Drop the trampoline lock and bail. */
+	movq	trampoline_lock(%rip), %rax
+	lock
+	btrl	$0, (%rax)
+
+1:	cli
+	hlt
+	jmp	1b
+
+.Lsetup_cpu:
 	/* Get the per cpu offset for the given CPU# which is in ECX */
 	movq	__per_cpu_offset(,%rcx,8), %rdx
 #else
@@ -244,7 +294,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 
 	/*
 	 * Setup a boot time stack - Any secondary CPU will have lost its stack
-	 * by now because the cr3-switch above unmaps the real-mode stack.
+	 * by now because the cr3-switch above unmaps the real-mode stack
 	 *
 	 * RDX contains the per-cpu offset
 	 */
@@ -293,6 +343,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	shrq	$32, %rdx
 	wrmsr
 
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
@@ -435,6 +493,8 @@ SYM_DATA(initial_code,	.quad x86_64_start_kernel)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
 #endif
+
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
 	__INIT
@@ -665,7 +725,6 @@ SYM_DATA_END(level1_fixmap_pgt)
 
 	.data
 	.align 16
-
 SYM_DATA(smpboot_control,		.long 0)
 
 	.align 16
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index b04520085582..19b9b89b7458 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -797,6 +797,16 @@ static int __init cpu_init_udelay(char *str)
 }
 early_param("cpu_init_udelay", cpu_init_udelay);
 
+static bool do_parallel_bringup __ro_after_init = true;
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
@@ -1113,7 +1123,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 	if (IS_ENABLED(CONFIG_X86_32)) {
 		early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
 		initial_stack  = idle->thread.sp;
-	} else {
+	} else if (!do_parallel_bringup) {
 		smpboot_control = cpu;
 	}
 
@@ -1515,6 +1525,47 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
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
+			pr_debug("Using CPUID 0xb for parallel CPU startup\n");
+			smpboot_control = STARTUP_APICID_CPUID_0B;
+		} else {
+			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
+			do_parallel_bringup = false;
+		}
+	} else if (do_parallel_bringup) {
+		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
+		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
+		smpboot_control = STARTUP_APICID_CPUID_01;
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
index e38d61d6562e..2dfb1c400167 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -37,6 +37,24 @@
 	.text
 	.code16
 
+.macro LOAD_REALMODE_ESP
+	/*
+	 * Make sure only one CPU fiddles with the realmode stack
+	 */
+.Llock_rm\@:
+	btl	$0, tr_lock
+	jnc	2f
+	pause
+	jmp	.Llock_rm\@
+2:
+	lock
+	btsl	$0, tr_lock
+	jc	.Llock_rm\@
+
+	# Setup stack
+	movl	$rm_stack_end, %esp
+.endm
+
 	.balign	PAGE_SIZE
 SYM_CODE_START(trampoline_start)
 	cli			# We should be safe anyway
@@ -49,8 +67,7 @@ SYM_CODE_START(trampoline_start)
 	mov	%ax, %es
 	mov	%ax, %ss
 
-	# Setup stack
-	movl	$rm_stack_end, %esp
+	LOAD_REALMODE_ESP
 
 	call	verify_cpu		# Verify the cpu supports long mode
 	testl   %eax, %eax		# Check for return code
@@ -93,8 +110,7 @@ SYM_CODE_START(sev_es_trampoline_start)
 	mov	%ax, %es
 	mov	%ax, %ss
 
-	# Setup stack
-	movl	$rm_stack_end, %esp
+	LOAD_REALMODE_ESP
 
 	jmp	.Lswitch_to_protected
 SYM_CODE_END(sev_es_trampoline_start)
@@ -177,7 +193,7 @@ SYM_CODE_START(pa_trampoline_compat)
 	 * In compatibility mode.  Prep ESP and DX for startup_32, then disable
 	 * paging and complete the switch to legacy 32-bit mode.
 	 */
-	movl	$rm_stack_end, %esp
+	LOAD_REALMODE_ESP
 	movw	$__KERNEL_DS, %dx
 
 	movl	$(CR0_STATE & ~X86_CR0_PG), %eax
@@ -241,6 +257,7 @@ SYM_DATA_START(trampoline_header)
 	SYM_DATA(tr_efer,		.space 8)
 	SYM_DATA(tr_cr4,		.space 4)
 	SYM_DATA(tr_flags,		.space 4)
+	SYM_DATA(tr_lock,		.space 4)
 SYM_DATA_END(trampoline_header)
 
 #include "trampoline_common.S"
-- 
2.25.1

