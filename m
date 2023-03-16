Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEB46BDB8C
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 23:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCPWWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 18:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCPWWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 18:22:10 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C138AB691A
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:22 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so2170523wmb.3
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 15:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679005280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0n30u7JAEzq/8YxEy0E6GMO580Q3zBlmdKg/T/xx0Y=;
        b=ejbUgJ+ZdWl9323hvtrT6oe36zrypriL4x3Xs3haidUgUYHXrccoaR3G8seQuYjS0a
         eQCNFh5UNTAYV8U3FSQI0f7s6gXJLrq6CVdtS+m7iwZEBAfqgwmEOmNxTeQSjrU0xIh0
         S2OK3BPSSXUMclbNQDLqwuUU1E+RqNrkwV0c0DsO51ypV0VcOTNTAwvxiGASnLvYnVR5
         xOTF4WbRsXBexOfK6yL7Qenj5/W25lYrzc3DUEewxqURRARcieKUXtj5uuG65uVOpEoC
         FuIZShXlP8pRA9zgyQLy5RSepCYHwyYvP/DPtBS865YOlRNZZGo48l4FwquiWDHQpLjo
         glyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679005280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0n30u7JAEzq/8YxEy0E6GMO580Q3zBlmdKg/T/xx0Y=;
        b=i/DnoOI2w9AvYOSI9JZmUH+XwcCNeL0bZePG6wq+wpKRundXFdgB4Bw2vILDSHI6ii
         HMSqE7+TdoNl7IQeU0CiNSSIUdobahmxM7Ijr/sqXmqn4OL7geKpm7h5NE53iKzWFTtL
         or9R6NPswcZeWabday9FEMPp9VBQbdnMAYBl+f9ssfN/0e3fcdDBkUszkA6PjDID39Bp
         pHlZjEn2Cb8bBDFcKiAvkPVKyOAc3mglnXqOpLaV0gF/maidh/K/yR7jRmRWknkNbWJb
         VE4Syu1mPsUZK3ucbh+IsWO9Zp8HYlLwAbZ3s0ZOOUJiKu3aDOV8ojOcC+ldler0QeRB
         SPOQ==
X-Gm-Message-State: AO0yUKUIhH+PFtbbaBiP4/2uRajFSHqbFCp+EnnEMd24dCotyKgd5MWk
        9hmS1U/iMCGy7kH8zH2SiGkppQ==
X-Google-Smtp-Source: AK7set//GhPEuXoNprBrTZ2pBJjTZ1O/FOIZpdtNR9m3I42XDWnC4Padrbk7Tn0KW8+wZsboZsC6LA==
X-Received: by 2002:a05:600c:3b07:b0:3ed:301d:9f86 with SMTP id m7-20020a05600c3b0700b003ed301d9f86mr8382105wms.9.1679005280180;
        Thu, 16 Mar 2023 15:21:20 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:4b87:78c3:3abe:7b0d])
        by smtp.gmail.com with ESMTPSA id f9-20020adff989000000b002cea392f000sm439256wrr.69.2023.03.16.15.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 15:21:19 -0700 (PDT)
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
Subject: [PATCH v15 09/12] x86/smpboot: Support parallel startup of secondary CPUs
Date:   Thu, 16 Mar 2023 22:21:06 +0000
Message-Id: <20230316222109.1940300-10-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230316222109.1940300-1-usama.arif@bytedance.com>
References: <20230316222109.1940300-1-usama.arif@bytedance.com>
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
 • X2APIC is enabled, but CPUID leaf 0xb is not present and correct.
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
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 .../admin-guide/kernel-parameters.txt         |  3 +
 arch/x86/include/asm/cpu.h                    |  1 +
 arch/x86/include/asm/realmode.h               |  3 +
 arch/x86/include/asm/smp.h                    |  6 ++
 arch/x86/kernel/acpi/sleep.c                  |  9 ++-
 arch/x86/kernel/apic/apic.c                   |  2 +-
 arch/x86/kernel/cpu/topology.c                |  3 +-
 arch/x86/kernel/head_64.S                     | 65 +++++++++++++++++++
 arch/x86/kernel/smpboot.c                     | 50 +++++++++++++-
 arch/x86/realmode/init.c                      |  3 +
 arch/x86/realmode/rm/trampoline_64.S          | 27 ++++++--
 11 files changed, 163 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3996cf..7bb7020f97e2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3819,6 +3819,9 @@
 
 	nomodule	Disable module load
 
+	no_parallel_bringup
+			[X86,SMP] Disable parallel bring-up of secondary cores.
+
 	nopat		[X86] Disable PAT (page attribute table extension of
 			pagetables) support.
 
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 78796b98a544..ef8ba318dca1 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -97,5 +97,6 @@ static inline bool intel_cpu_signatures_match(unsigned int s1, unsigned int p1,
 extern u64 x86_read_arch_cap_msr(void);
 int intel_find_matching_signature(void *mc, unsigned int csig, int cpf);
 int intel_microcode_sanity_check(void *mc, bool print_err, int hdr_type);
+int check_extended_topology_leaf(int leaf);
 
 #endif /* _ASM_X86_CPU_H */
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
index 1328c221af30..6dfecb27b846 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -16,6 +16,7 @@
 #include <asm/cacheflush.h>
 #include <asm/realmode.h>
 #include <asm/hypervisor.h>
+#include <asm/smp.h>
 
 #include <linux/ftrace.h>
 #include "../../realmode/rm/wakeup.h"
@@ -127,7 +128,13 @@ int x86_acpi_suspend_lowlevel(void)
 	 * value is in the actual %rsp register.
 	 */
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
 
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 5e868b62a7c4..4373442e500a 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -9,6 +9,7 @@
 #include <asm/apic.h>
 #include <asm/memtype.h>
 #include <asm/processor.h>
+#include <asm/cpu.h>
 
 #include "cpu.h"
 
@@ -32,7 +33,7 @@ EXPORT_SYMBOL(__max_die_per_package);
 /*
  * Check if given CPUID extended topology "leaf" is implemented
  */
-static int check_extended_topology_leaf(int leaf)
+int check_extended_topology_leaf(int leaf)
 {
 	unsigned int eax, ebx, ecx, edx;
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 6a8238702eab..65bca47d84a1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -25,6 +25,7 @@
 #include <asm/export.h>
 #include <asm/nospec-branch.h>
 #include <asm/fixmap.h>
+#include <asm/smp.h>
 
 /*
  * We are not able to switch in one step to the final KERNEL ADDRESS SPACE
@@ -234,8 +235,61 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
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
 
+.Luse_cpuid_0b:
+	mov	$0x0B, %eax
+	xorl	%ecx, %ecx
+	cpuid
+
+.Lsetup_AP:
+	/* EDX contains the APIC ID of the current CPU */
+	xorq	%rcx, %rcx
+	leaq	cpuid_to_apicid(%rip), %rbx
+
+.Lfind_cpunr:
+	cmpl	(%rbx,%rcx,4), %edx
+	jz	.Lsetup_cpu
+	inc	%ecx
+#ifdef CONFIG_FORCE_NR_CPUS
+	cmpl	$NR_CPUS, %ecx
+#else
+	cmpl	nr_cpu_ids(%rip), %ecx
+#endif
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
@@ -264,6 +318,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	lgdt	(%rsp)
 	addq	$16, %rsp
 
+	/* Drop the realmode protection. For the boot CPU the pointer is NULL! */
+	movq	trampoline_lock(%rip), %rax
+	testq	%rax, %rax
+	jz	.Lsetup_data_segments
+	lock
+	btrl	$0, (%rax)
+
+.Lsetup_data_segments:
 	/* set up data segments */
 	xorl %eax,%eax
 	movl %eax,%ds
@@ -293,6 +355,7 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	shrq	$32, %rdx
 	wrmsr
 
+.Lsetup_idt:
 	/* Setup and Load IDT */
 	pushq	%rsi
 	call	early_setup_idt
@@ -435,6 +498,8 @@ SYM_DATA(initial_code,	.quad x86_64_start_kernel)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 SYM_DATA(initial_vc_handler,	.quad handle_vc_boot_ghcb)
 #endif
+
+SYM_DATA(trampoline_lock, .quad 0);
 	__FINITDATA
 
 	__INIT
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 28d1643eee99..a9e48946fc89 100644
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
 
@@ -1473,6 +1483,41 @@ void __init smp_prepare_cpus_common(void)
 	set_cpu_sibling_map(0);
 }
 
+/*
+ * We can do 64-bit AP bringup in parallel if the CPU reports its APIC
+ * ID in CPUID (either leaf 0x0B if we need the full APIC ID in X2APIC
+ * mode, or leaf 0x01 if 8 bits are sufficient). Otherwise it's too
+ * hard. And not for SEV-ES guests because they can't use CPUID that
+ * early.
+ */
+static bool prepare_parallel_bringup(void)
+{
+	if (IS_ENABLED(CONFIG_X86_32) || cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
+		return false;
+
+	if (x2apic_mode) {
+		if (boot_cpu_data.cpuid_level < 0x0b)
+			return false;
+
+		if (check_extended_topology_leaf(0x0b) != 0) {
+			pr_info("Disabling parallel bringup because CPUID 0xb looks untrustworthy\n");
+			return false;
+		}
+
+		pr_debug("Using CPUID 0xb for parallel CPU startup\n");
+		smpboot_control = STARTUP_APICID_CPUID_0B;
+	} else {
+		/* Without X2APIC, what's in CPUID 0x01 should suffice. */
+		if (boot_cpu_data.cpuid_level < 0x01)
+			return false;
+
+		pr_debug("Using CPUID 0x1 for parallel CPU startup\n");
+		smpboot_control = STARTUP_APICID_CPUID_01;
+	}
+
+	return true;
+}
+
 /*
  * Prepare for SMP bootup.
  * @max_cpus: configured maximum number of CPUs, It is a legacy parameter
@@ -1513,6 +1558,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 
 	speculative_store_bypass_ht_init();
 
+	if (do_parallel_bringup)
+		do_parallel_bringup = prepare_parallel_bringup();
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

