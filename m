Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387E72B4F56
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388354AbgKPS2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:48454 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388334AbgKPS2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:23 -0500
IronPort-SDR: tQaWWjdg+iibMpXQ/3mw0MCZjFLjhfLhtlnh8Ku1uqH8AEcr94+l7sRgrIngxCEu63STll88mK
 TCb5Ic7rmaVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819211"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819211"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:22 -0800
IronPort-SDR: fUllWTxfGS6xw1Qk7QFGZ+35j+NBk0e18JZ7/O/HxgDyKyrQZJU9vOJ/ILaHc6a6qa9jhGBIeH
 XcH6xKnmEOnw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528377"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:21 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH 62/67] KVM: TDX: Load and init TDX-SEAM module during boot
Date:   Mon, 16 Nov 2020 10:26:47 -0800
Message-Id: <542b02522475c69143e3ac8bcf6014b7db03bd55.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a hook into the early boot flow to load TDX-SEAM and do BSP-only
init of TDX-SEAM.

Perform TDSYSINIT, TDSYSINITLP sequence to initialize TDX during kernel
boot.  Call TDSYSINIT on BSP for platform level initialization, and call
TDSYSINITLP for all cpus for per-cpu initialization.

On BSP, also call TDSYSINFO to get TDX info right after TDSYSINITLP.
While TDX initialization on AP is done in identify_cpu() when AP is
brought up, on BSP it is done right after SEAM module is loaded, but
not in identify_cpu(). The reason is constructing TDMRs needs to be
done before kernel normal page allocator is up, since it requires to
reserve large memory for PAMT (>4MB), which kernel page allocator cannot
allocate. And reserving how much memory for PAMT requires TDX info
reteurned by TDSYSINFO, so it also needs to be done in BSP right after
TDSYSINITLP.

Check kernel parameters and other variables that prevent/indicate that
not all logical CPUs can be onlined.  TDSYSINITLP must be called on all
logical CPUs as part of TDX-SEAM configuration, e.g. TDSYSCONFIG is
guaranteed to fail if not all CPUs are onlined.

Query the 'nr_cpus', 'possible_cpus' and 'maxcpus' kernel parameters, as
well as the 'disabled_cpus' counter that can be incremented during ACPI
parsing (CPUs marked as disabled cannot be brought up later).

Note, the kernel ignores the "Online Capable" bit defined in the ACPI
specification v6.3, section 5.2.12.2 Processor Local APIC Structure:

  CPUs marked as disabled ("Enabled" bit cleared) but it can be
  brought up later by OS if "Online Capable" bit is set.

and simply treats ACPI hot-added CPUs as enabled, i.e. with ACPI CPU
hotplug, the aforementioned variables can change dynamically post-boot.
But, CPU hotplug is unsupported on TDX enabled systems, therefore the
variables are effectively constant post-boot TDX.

In the post-SMP boot phase (tdx_init()), verify that all present CPUs
were succesfully booted.  Note that this also covers the SMT=off case,
i.e. verifies that to-be-disabled sibling threads are booted and run
through TDSYSINITLP.

Detect the TDX private keyID range by reading MSR_IA32_MKTME_KEYID_PART,
which is configured by BIOS and partitions the MKTME KeyID space into
regular KeyIDs and TDX-only KeyIDs.  Disable TDX if the partitioning is
not consistent across all CPUs, i.e. if BIOS screwed up.

Construct Trust Domain Memory Regions (TDMRs) based on info reported by
TDSYSINFO.  For simplicity, all system memory is configured as TDMRs,
otherwise page allocator needs to be modified to distinguish normal and
TD memory allocation.  The overhead of marking all memory as TDMRs
consists of the memory needed for TDX-SEAM's Physical Address Metadata
Tables (PAMTs) used to track TDMRs.

TDMRs are constructed (and PAMTs associated with TDMRs are reserved)
on basis of NUMA node for better performance -- when accessing TD
memory in TDMR, CPU doesn't have to access PAMT in remote node.

Sanity check that the CMRs reported by TDSYSINFO have covered all memory
reported in e820, and disable TDX if there is a discrepancy.  If there
is memory available to the kernel (reported in e820) that is not covered
by a TDMR then it's possible the page allocator will allocate a page
that's not usable for a TD's memory, i.e. would break KVM.

Once all enumeration and sanity checking is done, call TDSYSCONFIG,
TDSYSCONFIGKEY and TDSYSINITTDMR to configure and initialize TDMRs.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/Kbuild                     |    1 +
 arch/x86/include/asm/kvm_boot.h     |   43 +
 arch/x86/kernel/cpu/intel.c         |    4 +
 arch/x86/kernel/setup.c             |    3 +
 arch/x86/kvm/Kconfig                |    8 +
 arch/x86/kvm/boot/Makefile          |    5 +
 arch/x86/kvm/boot/seam/seamldr.S    |  188 +++++
 arch/x86/kvm/boot/seam/seamloader.c |  162 ++++
 arch/x86/kvm/boot/seam/tdx.c        | 1131 +++++++++++++++++++++++++++
 9 files changed, 1545 insertions(+)
 create mode 100644 arch/x86/include/asm/kvm_boot.h
 create mode 100644 arch/x86/kvm/boot/Makefile
 create mode 100644 arch/x86/kvm/boot/seam/seamldr.S
 create mode 100644 arch/x86/kvm/boot/seam/seamloader.c
 create mode 100644 arch/x86/kvm/boot/seam/tdx.c

diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
index 30dec019756b..4f35eaad7468 100644
--- a/arch/x86/Kbuild
+++ b/arch/x86/Kbuild
@@ -4,6 +4,7 @@ obj-y += entry/
 obj-$(CONFIG_PERF_EVENTS) += events/
 
 obj-$(CONFIG_KVM) += kvm/
+obj-$(subst m,y,$(CONFIG_KVM)) += kvm/boot/
 
 # Xen paravirtualization support
 obj-$(CONFIG_XEN) += xen/
diff --git a/arch/x86/include/asm/kvm_boot.h b/arch/x86/include/asm/kvm_boot.h
new file mode 100644
index 000000000000..5054fb324283
--- /dev/null
+++ b/arch/x86/include/asm/kvm_boot.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_KVM_BOOT_H
+#define _ASM_X86_KVM_BOOT_H
+
+#include <linux/cpumask.h>
+#include <linux/mutex.h>
+#include <linux/smp.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_KVM_INTEL_TDX
+int __init seam_load_module(void *module, unsigned long module_size,
+			    void *sigstruct, unsigned long sigstruct_size,
+			    void *seamldr, unsigned long seamldr_size);
+
+void __init tdx_seam_init(void);
+void tdx_init_cpu(struct cpuinfo_x86 *c);
+
+void tdx_seamcall_on_other_pkgs(smp_call_func_t fn, void *param,
+				struct mutex *lock);
+#define tdx_seamcall_on_each_pkg(fn, param, lock)		\
+do {								\
+	fn(param);						\
+	if (topology_max_packages() > 1)			\
+		tdx_seamcall_on_other_pkgs(fn, param, lock);	\
+} while (0)
+
+/*
+ * Return pointer to TDX system info (TDSYSINFO_STRUCT) if TDX has been
+ * successfully initialized, or NULL.
+ */
+struct tdsysinfo_struct;
+struct tdsysinfo_struct *tdx_get_sysinfo(void);
+
+/* TDX keyID allocation functions */
+extern int tdx_keyid_alloc(void);
+extern void tdx_keyid_free(int keyid);
+#else
+static inline void __init tdx_seam_init(void) {}
+static inline void tdx_init_cpu(struct cpuinfo_x86 *c) {}
+#endif
+
+#endif /* _ASM_X86_KVM_BOOT_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 59a1e3ce3f14..bd6338433873 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -15,6 +15,7 @@
 #include <asm/msr.h>
 #include <asm/bugs.h>
 #include <asm/cpu.h>
+#include <asm/kvm_boot.h>
 #include <asm/intel-family.h>
 #include <asm/microcode_intel.h>
 #include <asm/hwcap2.h>
@@ -711,6 +712,9 @@ static void init_intel(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_TME))
 		detect_tme(c);
 
+	if (cpu_has(c, X86_FEATURE_TDX))
+		tdx_init_cpu(c);
+
 	init_intel_misc_features(c);
 
 	if (tsx_ctrl_state == TSX_CTRL_ENABLE)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 84f581c91db4..3bf04246efd1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -38,6 +38,7 @@
 #include <asm/io_apic.h>
 #include <asm/kasan.h>
 #include <asm/kaslr.h>
+#include <asm/kvm_boot.h>
 #include <asm/mce.h>
 #include <asm/mtrr.h>
 #include <asm/realmode.h>
@@ -1200,6 +1201,8 @@ void __init setup_arch(char **cmdline_p)
 
 	prefill_possible_map();
 
+	tdx_seam_init();
+
 	init_cpu_to_node();
 	init_gi_nodes();
 
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index f92dfd8ef10d..6f41966c69a7 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -84,6 +84,14 @@ config KVM_INTEL
 	  To compile this as a module, choose M here: the module
 	  will be called kvm-intel.
 
+config KVM_INTEL_TDX
+	bool "Trusted Domain Extensions"
+	depends on KVM_INTEL && X86_64
+	select FW_LOADER
+
+	help
+	  Extends KVM on Intel processors to support Trusted Domain Extensions.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM
diff --git a/arch/x86/kvm/boot/Makefile b/arch/x86/kvm/boot/Makefile
new file mode 100644
index 000000000000..8356cbe979b9
--- /dev/null
+++ b/arch/x86/kvm/boot/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+ccflags-y += -I$(srctree)/arch/x86/kvm
+
+obj-$(CONFIG_KVM_INTEL_TDX) += seam/seamldr.o seam/seamloader.o seam/tdx.o
diff --git a/arch/x86/kvm/boot/seam/seamldr.S b/arch/x86/kvm/boot/seam/seamldr.S
new file mode 100644
index 000000000000..c7d93df62ce3
--- /dev/null
+++ b/arch/x86/kvm/boot/seam/seamldr.S
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ASM helper to load Intel SEAM module.
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * Authors:
+ *	Kai Huang <kai.huang>@intel.com
+ */
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <uapi/asm/processor-flags.h>
+#include <asm/asm.h>
+#include <asm/errno.h>
+#include <asm/msr-index.h>
+#include <asm/segment.h>
+
+.macro save_msr _msr
+	movl	$(\_msr), %ecx
+	rdmsr
+	pushq	%rax
+	pushq	%rdx
+.endm
+
+.macro restore_msr _msr
+	popq	%rdx
+	popq	%rax
+	movl	$(\_msr), %ecx
+	wrmsr
+.endm
+
+	.text
+	__INIT
+	.code64
+SYM_FUNC_START(launch_seamldr)
+
+	pushq	%rbp
+	movq	%rsp, %rbp
+	pushq	%r15
+	pushq	%r14
+	pushq	%r13
+	pushq	%r12
+	pushq	%rbx
+
+	/* Save DR7, SEAMLDR sets it to 0x400. */
+	movq	%dr7, %rax
+	pushq	%rax
+
+	/*
+	 * SEAMLDR restores GDTR and CS before ExitAC, DS/ES/SS don't need to
+	 * be manually preserved as this is 64-bit mode, and FS/GS and IDTR are
+	 * not modified by EnterACCS or SEAMLDR.
+	 */
+
+	/* EnterACCS and SEAMLDR modify CR0 and CR4. */
+	movq	%cr0, %rax
+	pushq	%rax
+	movq	%cr4, %rax
+	pushq	%rax
+
+	/* Enable CR4.SMXE for GETSEC */
+	orq	$X86_CR4_SMXE, %rax
+	movq	%rax, %cr4
+
+	/*
+	 * Load R8-R11 immediately, they won't be clobbered, unlike RDX.
+	 *
+	 *  - R8: SEAMLDR_PARAMS physical address
+	 *  - R9: GDT base to be setup by SEMALDR when returning to kernel
+	 *  - R10: RIP of resume point
+	 *  - R11: CR3 when returning to kernel
+	 */
+	movq	%rdx, %r8
+	sgdt	kernel_gdt64(%rip)
+	movq	kernel_gdt64_base(%rip), %r9
+	leaq	.Lseamldr_resume(%rip), %r10
+	movq	%cr3, %r11
+
+	/* Save MSRs that are modified by EnterACCS and/or SEAMLDR */
+	save_msr MSR_EFER
+	save_msr MSR_IA32_CR_PAT
+	save_msr MSR_IA32_MISC_ENABLE
+
+	/*
+	 * MSRs that are clobbered by SEAMLDR but are not enabled during early
+	 * boot and so don't need to be saved/restored.
+	 *
+	 * save_msr MSR_IA32_DEBUGCTLMSR
+	 * save_msr MSR_CORE_PERF_GLOBAL_CTRL
+	 * save_msr MSR_IA32_PEBS_ENABLE
+	 * save_msr MSR_IA32_RTIT_CTL
+	 * save_msr MSR_IA32_LBR_CTRL
+	 */
+
+	/* Now as last step, save RSP before invoking GETSEC[ENTERACCS] */
+	movq	%rsp, saved_rsp(%rip)
+
+	/*
+	 * Load the Remaining params for EnterACCS.
+	 *
+	 *  - EBX: SEAMLDR ACM physical address
+	 *  - ECX: SEAMLDR ACM size
+	 *  - EAX: 2
+	 */
+	movl	%edi, %ebx
+	movl	%esi, %ecx
+
+	/* Invoke GETSEC[ENTERACCS] */
+	movl	$2, %eax
+.Lseamldr_enteraccs:
+	getsec
+
+.Lseamldr_resume:
+	/*
+	 * SEAMLDR restores CRs and GDT.  Segment registers are flat, but
+	 * don't hold kernel selectors.  Reload the data segs now.
+	 */
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %ss
+
+	/*
+	 * Restore stack from RIP relative storage, and then restore everything
+	 * else from the stack.
+	 */
+	movq	saved_rsp(%rip), %rsp
+
+	/*
+	 * Restore CPU status, in reverse order of saving. Firstly, restore
+	 * MSRs.
+	 */
+	restore_msr  MSR_IA32_MISC_ENABLE
+	restore_msr  MSR_IA32_CR_PAT
+	restore_msr  MSR_EFER
+
+	popq	%rax
+	movq	%rax, %cr4
+	popq	%rax
+	movq	%rax, %cr0
+
+	popq	%rax
+	movq	%rax, %dr7
+
+	popq	%rbx
+	popq	%r12
+	popq	%r13
+	popq	%r14
+	popq	%r15
+	popq	%rbp
+
+	/* Far return to load the kernel's CS. */
+	popq	%rax
+	pushq	$__KERNEL_CS
+	pushq	%rax
+
+	movq	%r9, %rax
+	lretq
+
+.pushsection .fixup, "ax"
+	/*
+	 * ENTERACCS faulted, return -EFAULT.  Restore CR4 (to clear SMXE) and
+	 * GPRs (to make objtool happy, only RBP/RSP are actually modified).
+	 */
+1:	movq	8 * 6(%rsp), %rax
+	movq	%rax, %cr4
+	addq	$(8 *9), %rsp
+	popq	%rbx
+	popq	%r12
+	popq	%r13
+	popq	%r14
+	popq	%r15
+	popq	%rbp
+	movq	$-EFAULT, %rax
+	ret
+.popsection
+	_ASM_EXTABLE(.Lseamldr_enteraccs, 1b)
+
+SYM_FUNC_END(launch_seamldr)
+
+	__INITDATA
+	.balign	8
+kernel_gdt64:
+	.word	0
+kernel_gdt64_base:
+	.quad	0
+saved_rsp:
+	.quad	0
diff --git a/arch/x86/kvm/boot/seam/seamloader.c b/arch/x86/kvm/boot/seam/seamloader.c
new file mode 100644
index 000000000000..00202daeac74
--- /dev/null
+++ b/arch/x86/kvm/boot/seam/seamloader.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) "seam: " fmt
+
+#include <linux/types.h>
+#include <linux/bits.h>
+#include <linux/memblock.h>
+#include <asm/apic.h>
+#include <asm/cpu.h>
+#include <asm/delay.h>
+#include <asm/kvm_boot.h>
+#include <asm/msr-index.h>
+#include <asm/msr.h>
+#include <asm/page_types.h>
+
+#define MTRRCAP_SEAMRR	BIT(15)
+
+#define SEAMLDR_MAX_NR_MODULE_PAGES	496
+
+struct seamldr_params {
+	u32 version;
+	u32 scenario;
+	u64 sigstruct_pa;
+	u8 reserved[104];
+	u64 module_pages;
+	u64 module_pa_list[SEAMLDR_MAX_NR_MODULE_PAGES];
+} __packed __aligned(PAGE_SIZE);
+
+/* The ACM and input params need to be below 4G. */
+static phys_addr_t __init seam_alloc_lowmem(phys_addr_t size)
+{
+	return memblock_phys_alloc_range(size, PAGE_SIZE, 0, BIT_ULL(32));
+}
+
+static bool __init is_seamrr_enabled(void)
+{
+	u64 mtrrcap, seamrr_base, seamrr_mask;
+
+	if (!boot_cpu_has(X86_FEATURE_MTRR) ||
+	    rdmsrl_safe(MSR_MTRRcap, &mtrrcap) || !(mtrrcap & MTRRCAP_SEAMRR))
+		return 0;
+
+	if (rdmsrl_safe(MSR_IA32_SEAMRR_PHYS_BASE, &seamrr_base) ||
+	    !(seamrr_base & MSR_IA32_SEAMRR_PHYS_BASE_CONFIGURED)) {
+		pr_info("SEAMRR base is not configured by BIOS\n");
+		return 0;
+	}
+
+	if (rdmsrl_safe(MSR_IA32_SEAMRR_PHYS_MASK, &seamrr_mask) ||
+	    !(seamrr_mask & MSR_IA32_SEAMRR_PHYS_MASK_ENABLED)) {
+		pr_info("SEAMRR is not enabled by BIOS\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+extern int __init launch_seamldr(unsigned long seamldr_pa,
+				 unsigned long seamldr_size,
+				 unsigned long params_pa);
+
+int __init seam_load_module(void *module, unsigned long module_size,
+			    void *sigstruct, unsigned long sigstruct_size,
+			    void *seamldr, unsigned long seamldr_size)
+{
+	phys_addr_t module_pa, seamldr_pa, params_pa;
+	struct seamldr_params *params;
+	int enteraccs_attempts = 10;
+	u32 icr_busy;
+	int ret;
+	u64 i;
+
+	if (!is_seamrr_enabled())
+		return -ENOTSUPP;
+
+	/* SEAM module must be 4K aligned, and less than 496 pages. */
+	if (!module_size || !IS_ALIGNED(module_size, PAGE_SIZE) ||
+	    module_size > SEAMLDR_MAX_NR_MODULE_PAGES * PAGE_SIZE) {
+		pr_err("Invalid SEAM module size 0x%lx\n", module_size);
+		return -EINVAL;
+	}
+	/* SEAM signature structure must be 0x200 DWORDS, which is 2048 bytes */
+	if (sigstruct_size != 2048) {
+		pr_err("Invalid SEAM signature structure size 0x%lx\n",
+		       sigstruct_size);
+		return -EINVAL;
+	}
+	if (!seamldr_size) {
+		pr_err("Invalid SEAMLDR ACM size\n");
+		return -EINVAL;
+	}
+
+	ret = -ENOMEM;
+	/* SEAMLDR requires the SEAM module to be 4k aligned. */
+	module_pa = __pa(module);
+	if (!IS_ALIGNED(module_pa, 4096)) {
+		module_pa = memblock_phys_alloc(module_size, PAGE_SIZE);
+		if (!module_pa) {
+			pr_err("Unable to allocate memory to copy SEAM module\n");
+			goto out;
+		}
+		memcpy(__va(module_pa), module, module_size);
+	}
+
+	/* GETSEC[EnterACCS] requires the ACM to be 4k aligned and below 4G. */
+	seamldr_pa = __pa(seamldr);
+	if (seamldr_pa >= BIT_ULL(32) || !IS_ALIGNED(seamldr_pa, 4096)) {
+		seamldr_pa = seam_alloc_lowmem(seamldr_size);
+		if (!seamldr_pa)
+			goto free_seam_module;
+		memcpy(__va(seamldr_pa), seamldr, seamldr_size);
+	}
+
+	/*
+	 * Allocate and initialize the SEAMLDR params.  Pages are passed in as
+	 * a list of physical addresses.
+	 */
+	params_pa = seam_alloc_lowmem(PAGE_SIZE);
+	if (!params_pa) {
+		pr_err("Unable to allocate memory for SEAMLDR_PARAMS\n");
+		goto free_seamldr;
+	}
+
+	ret = -EIO;
+	/* Ensure APs are in WFS. */
+	apic_icr_write(APIC_DEST_ALLBUT | APIC_INT_LEVELTRIG | APIC_INT_ASSERT |
+		       APIC_DM_INIT, 0);
+	icr_busy = safe_apic_wait_icr_idle();
+	if (WARN_ON(icr_busy))
+		goto free_seamldr;
+
+	apic_icr_write(APIC_DEST_ALLBUT | APIC_INT_LEVELTRIG | APIC_DM_INIT, 0);
+	icr_busy = safe_apic_wait_icr_idle();
+	if (WARN_ON(icr_busy))
+		goto free_seamldr;
+	mb();
+
+	params = __va(params_pa);
+	memset(params, 0, PAGE_SIZE);
+	params->sigstruct_pa = __pa(sigstruct);
+	params->module_pages = PFN_UP(module_size);
+	for (i = 0; i < params->module_pages; i++)
+		params->module_pa_list[i] = module_pa + i * PAGE_SIZE;
+
+retry_enteraccs:
+	ret = launch_seamldr(seamldr_pa, seamldr_size, params_pa);
+	if (ret == -EFAULT && !WARN_ON(!enteraccs_attempts--)) {
+		udelay(1 * USEC_PER_MSEC);
+		goto retry_enteraccs;
+	}
+	pr_info("Launch SEAMLDR returned %d\n", ret);
+
+	memblock_free_early(params_pa, PAGE_SIZE);
+free_seamldr:
+	if (seamldr_pa != __pa(seamldr))
+		memblock_free_early(seamldr_pa, seamldr_size);
+free_seam_module:
+	if (module_pa != __pa(module))
+		memblock_free_early(module_pa, module_size);
+out:
+	return ret;
+}
diff --git a/arch/x86/kvm/boot/seam/tdx.c b/arch/x86/kvm/boot/seam/tdx.c
new file mode 100644
index 000000000000..98a9e52cc5a6
--- /dev/null
+++ b/arch/x86/kvm/boot/seam/tdx.c
@@ -0,0 +1,1131 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/earlycpio.h>
+#include <linux/fs.h>
+#include <linux/initrd.h>
+#include <linux/percpu.h>
+#include <linux/memblock.h>
+#include <linux/idr.h>
+#include <linux/sort.h>
+
+#include <asm/cpu.h>
+#include <asm/kvm_boot.h>
+#include <asm/virtext.h>
+#include <asm/tlbflush.h>
+#include <asm/e820/api.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt) "tdx: " fmt
+
+/* Instruct tdx_ops.h to do boot-time friendly SEAMCALL exception handling. */
+#define INTEL_TDX_BOOT_TIME_SEAMCALL 1
+
+#include "vmx/tdx_arch.h"
+#include "vmx/tdx_ops.h"
+#include "vmx/tdx_errno.h"
+
+#include "vmx/vmcs.h"
+
+static DEFINE_PER_CPU(unsigned long, tdx_vmxon_vmcs);
+static atomic_t tdx_init_cpu_errors;
+
+/*
+ * TODO: better to have kernel boot parameter to let admin control whether to
+ * enable TDX with sysprof or not.
+ *
+ * Or how to decide tdx_sysprof??
+ */
+static bool tdx_sysprof;
+
+/* KeyID range reserved to TDX by BIOS */
+static u32 tdx_keyids_start;
+static u32 tdx_nr_keyids;
+
+/* TDX keyID pool */
+static DEFINE_IDA(tdx_keyid_pool);
+
+static int *tdx_package_masters __ro_after_init;
+
+/*
+ * TDX system information returned by TDSYSINFO.
+ */
+static struct tdsysinfo_struct tdx_tdsysinfo;
+
+/*
+ * CMR info array returned by TDSYSINFO.
+ *
+ * TDSYSINFO doesn't return specific error code indicating whether we didn't
+ * pass long-enough CMR info array to it, so just reserve enough space for
+ * the maximum number of CMRs.
+ */
+static struct cmr_info tdx_cmrs[TDX1_MAX_NR_CMRS] __aligned(512);
+static int tdx_nr_cmrs;
+
+/*
+ * TDMR info array used as input for TDSYSCONFIG.
+ */
+static struct tdmr_info tdx_tdmrs[TDX1_MAX_NR_TDMRS] __initdata;
+static int tdx_nr_tdmrs __initdata;
+static atomic_t tdx_next_tdmr_index;
+static atomic_t tdx_nr_initialized_tdmrs;
+
+/* TDMRs must be 1gb aligned */
+#define TDMR_ALIGNMENT		BIT_ULL(30)
+#define TDMR_PFN_ALIGNMENT	(TDMR_ALIGNMENT >> PAGE_SHIFT)
+
+/*
+ * TDSYSCONFIG takes a array of pointers to TDMR infos.  Its just big enough
+ * that allocating it on the stack is undesirable.
+ */
+static u64 tdx_tdmr_addrs[TDX1_MAX_NR_TDMRS] __aligned(512) __initdata;
+
+struct pamt_info {
+	u64 pamt_base;
+	u64 pamt_size;
+};
+
+/*
+ * PAMT info for each TDMR, used to free PAMT when TDX is disabled due to
+ * whatever reason.
+ */
+static struct pamt_info tdx_pamts[TDX1_MAX_NR_TDMRS] __initdata;
+
+static int __init set_tdmr_reserved_area(struct tdmr_info *tdmr, int *p_idx,
+					 u64 offset, u64 size)
+{
+	int idx = *p_idx;
+
+	if (idx >= tdx_tdsysinfo.max_reserved_per_tdmr)
+		return -EINVAL;
+
+	/* offset & size must be 4K aligned */
+	if (offset & ~PAGE_MASK || size & ~PAGE_MASK)
+		return -EINVAL;
+
+	tdmr->reserved_areas[idx].offset = offset;
+	tdmr->reserved_areas[idx].size = size;
+
+	*p_idx = idx + 1;
+	return 0;
+}
+
+/*
+ * Construct TDMR reserved areas.
+ *
+ * Two types of address range will be put into reserved areas: 1) PAMT range,
+ * since PAMT cannot overlap with TDMR non-reserved range; 2) any CMR hole
+ * within TDMR range, since TDMR non-reserved range must be in CMR.
+ *
+ * Note: we are not putting any memory hole made by kernel (which is not CMR
+ * hole -- i.e. some memory range is reserved by kernel and won't be freed to
+ * page allocator, and it is memory hole from page allocator's view) into
+ * reserved area for the sake of simplicity of implementation. The other
+ * reason is for TDX1 one TDMR can only have upto 16 reserved areas so if
+ * there are lots of holes we won't be have enough reserved areas to hold
+ * them. This is OK, since kernel page allocator will never allocate pages
+ * from those areas (as they are invalid). PAMT may internally mark them as
+ * 'normal' pages but it is OK.
+ *
+ * Returns -EINVAL if number of reserved areas exceeds TDX1 limitation.
+ *
+ */
+static int __init __construct_tdmr_reserved_areas(struct tdmr_info *tdmr,
+						  u64 pamt_base, u64 pamt_size)
+{
+	u64 tdmr_start, tdmr_end, offset, size;
+	struct cmr_info *cmr, *next_cmr;
+	bool pamt_done = false;
+	int i, idx, ret;
+
+	memset(tdmr->reserved_areas, 0, sizeof(tdmr->reserved_areas));
+
+	/* Save some typing later */
+	tdmr_start = tdmr->base;
+	tdmr_end = tdmr->base + tdmr->size;
+
+	if (WARN_ON(!tdx_nr_cmrs))
+		return -EINVAL;
+	/*
+	 * Find the first CMR whose end is greater than tdmr_start_pfn.
+	 */
+	cmr = &tdx_cmrs[0];
+	for (i = 0; i < tdx_nr_cmrs; i++) {
+		cmr = &tdx_cmrs[i];
+		if ((cmr->base + cmr->size) > tdmr_start)
+			break;
+	}
+
+	/* Unable to find ?? Something is wrong here */
+	if (i == tdx_nr_cmrs)
+		return -EINVAL;
+
+	/*
+	 * If CMR base is within TDMR range, [tdmr_start, cmr->base) needs to be
+	 * in reserved area.
+	 */
+	idx = 0;
+	if (cmr->base > tdmr_start) {
+		offset = 0;
+		size = cmr->base - tdmr_start;
+
+		ret = set_tdmr_reserved_area(tdmr, &idx, offset, size);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Check whether there's any hole between CMRs within TDMR range.
+	 * If there is any, it needs to be in reserved area.
+	 */
+	for (++i; i < tdx_nr_cmrs; i++) {
+		next_cmr = &tdx_cmrs[i];
+
+		/*
+		 * If next CMR is beyond TDMR range, there's no CMR hole within
+		 * TDMR range, and we only need to insert PAMT into reserved
+		 * area, thus  we are done here.
+		 */
+		if (next_cmr->base >= tdmr_end)
+			break;
+
+		/* Otherwise need to have CMR hole in reserved area */
+		if (cmr->base + cmr->size < next_cmr->base) {
+			offset = cmr->base + cmr->size - tdmr_start;
+			size = next_cmr->base - (cmr->base + cmr->size);
+
+			/*
+			 * Reserved areas needs to be in physical address
+			 * ascending order, therefore we need to check PAMT
+			 * range before filling any CMR hole into reserved
+			 * area.
+			 */
+			if (pamt_base < tdmr_start + offset) {
+				/*
+				 * PAMT won't overlap with any CMR hole
+				 * otherwise there's bug -- see comments below.
+				 */
+				if (WARN_ON((pamt_base + pamt_size) >
+					    (tdmr_start + offset)))
+					return -EINVAL;
+
+				ret = set_tdmr_reserved_area(tdmr, &idx,
+							     pamt_base - tdmr_start,
+							     pamt_size);
+				if (ret)
+					return ret;
+
+				pamt_done = true;
+			}
+
+			/* Insert CMR hole into reserved area */
+			ret = set_tdmr_reserved_area(tdmr, &idx, offset, size);
+			if (ret)
+				return ret;
+		}
+
+		cmr = next_cmr;
+	}
+
+	if (!pamt_done) {
+		/*
+		 * PAMT won't overlap with CMR range, otherwise there's bug
+		 * -- we have guaranteed this by checking all CMRs have
+		 * covered all memory in e820.
+		 */
+		if (WARN_ON((pamt_base + pamt_size) > (cmr->base + cmr->size)))
+			return -EINVAL;
+
+		ret = set_tdmr_reserved_area(tdmr, &idx,
+					     pamt_base - tdmr_start, pamt_size);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * If CMR end is in TDMR range, [cmr->end, tdmr_end) needs to be in
+	 * reserved area.
+	 */
+	if (cmr->base + cmr->size < tdmr_end) {
+		offset = cmr->base + cmr->size - tdmr_start;
+		size = tdmr_end - (cmr->base + cmr->size);
+
+		ret = set_tdmr_reserved_area(tdmr, &idx, offset, size);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int __init __construct_tdmr_node(int tdmr_idx,
+					unsigned long tdmr_start_pfn,
+					unsigned long tdmr_end_pfn)
+{
+	u64 tdmr_size, pamt_1g_size, pamt_2m_size, pamt_4k_size, pamt_size;
+	struct pamt_info *pamt = &tdx_pamts[tdmr_idx];
+	struct tdmr_info *tdmr = &tdx_tdmrs[tdmr_idx];
+	u64 pamt_phys;
+	int ret;
+
+	tdmr_size = (tdmr_end_pfn - tdmr_start_pfn) << PAGE_SHIFT;
+
+	/* sanity check */
+	if (!tdmr_size || !IS_ALIGNED(tdmr_size, TDMR_ALIGNMENT))
+		return -EINVAL;
+
+	/* 1 entry to cover 1G */
+	pamt_1g_size = (tdmr_size >> 30) * tdx_tdsysinfo.pamt_entry_size;
+	/* 1 entry to cover 2M */
+	pamt_2m_size = (tdmr_size >> 21) * tdx_tdsysinfo.pamt_entry_size;
+	/* 1 entry to cover 4K */
+	pamt_4k_size = (tdmr_size >> 12) * tdx_tdsysinfo.pamt_entry_size;
+
+	pamt_size = ALIGN(pamt_1g_size, PAGE_SIZE) +
+		    ALIGN(pamt_2m_size, PAGE_SIZE) +
+		    ALIGN(pamt_4k_size, PAGE_SIZE);
+
+	pamt_phys = memblock_phys_alloc_range(pamt_size, PAGE_SIZE,
+					      tdmr_start_pfn << PAGE_SHIFT,
+					      tdmr_end_pfn << PAGE_SHIFT);
+	if (!pamt_phys)
+		return -ENOMEM;
+
+	tdmr->base = tdmr_start_pfn << PAGE_SHIFT;
+	tdmr->size = tdmr_size;
+
+	/* PAMT for 1G at first */
+	tdmr->pamt_1g_base = pamt_phys;
+	tdmr->pamt_1g_size = ALIGN(pamt_1g_size, PAGE_SIZE);
+	/* PAMT for 2M right after PAMT for 1G */
+	tdmr->pamt_2m_base = tdmr->pamt_1g_base + tdmr->pamt_1g_size;
+	tdmr->pamt_2m_size = ALIGN(pamt_2m_size, PAGE_SIZE);
+	/* PAMT for 4K comes after PAMT for 2M */
+	tdmr->pamt_4k_base = tdmr->pamt_2m_base + tdmr->pamt_2m_size;
+	tdmr->pamt_4k_size = ALIGN(pamt_4k_size, PAGE_SIZE);
+
+	/* Construct TDMR's reserved areas */
+	ret = __construct_tdmr_reserved_areas(tdmr, tdmr->pamt_1g_base,
+					      pamt_size);
+	if (ret) {
+		memblock_free(pamt_phys, pamt_size);
+		return ret;
+	}
+
+	/* Record PAMT info for this TDMR */
+	pamt->pamt_base = pamt_phys;
+	pamt->pamt_size = pamt_size;
+
+	return 0;
+}
+
+/*
+ * Convert node's memory into TDMRs as less as possible.
+ *
+ * @node_start_pfn and @node_end_pfn are not node's real memory region, but
+ * already 1G aligned passed from caller.
+ */
+static int __init construct_tdmr_node(int *p_tdmr_idx,
+				      unsigned long tdmr_start_pfn,
+				      unsigned long tdmr_end_pfn)
+{
+	u64 start_pfn, end_pfn, mid_pfn;
+	int ret = 0, idx = *p_tdmr_idx;
+
+	start_pfn = tdmr_start_pfn;
+	end_pfn = tdmr_end_pfn;
+
+	while (start_pfn < tdmr_end_pfn) {
+		/* Cast to u32, else compiler will sign extend and complain. */
+		if (idx >= (u32)tdx_tdsysinfo.max_tdmrs) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = __construct_tdmr_node(idx, start_pfn, end_pfn);
+
+		/*
+		 * Try again with smaller TDMR if the failure was due to unable
+		 * to allocate PAMT.
+		 */
+		if (ret == -ENOMEM) {
+			mid_pfn = start_pfn + (end_pfn - start_pfn) / 2;
+			mid_pfn = ALIGN_DOWN(mid_pfn, TDMR_PFN_ALIGNMENT);
+			mid_pfn = max(mid_pfn, start_pfn + TDMR_PFN_ALIGNMENT);
+			if (mid_pfn == end_pfn)
+				break;
+			end_pfn = mid_pfn;
+			continue;
+		} else if (ret) {
+			break;
+		}
+
+		/* Successfully done with one TDMR, and continue if there's remaining */
+		start_pfn = end_pfn;
+		end_pfn = tdmr_end_pfn;
+		idx++;
+	}
+
+	/* Setup next TDMR entry to work on */
+	*p_tdmr_idx = idx;
+	return ret;
+}
+
+/*
+ * Construct TDMR based on system memory info and CMR info. To avoid modifying
+ * kernel core-mm page allocator to have TDMR specific logic for memory
+ * allocation in TDMR, we choose to simply convert all memory to TDMR, with the
+ * disadvantage of wasting some memory for PAMT, but since TDX is mainly a
+ * virtualization feature so it is expected majority of memory will be used as
+ * TD guest memory so wasting some memory for PAMT won't be big issue.
+ *
+ * There are some restrictions of TDMR/PAMT/CMR:
+ *
+ *  - TDMR's base and size need to be 1G aligned.
+ *  - TDMR's size need to be multiple of 1G.
+ *  - TDMRs cannot overlap with each other.
+ *  - PAMTs cannot overlap with each other.
+ *  - Each TDMR can have reserved areas (TDX1 upto 16).
+ *  - TDMR reserved areas must be in physical address ascending order.
+ *  - TDMR non-reserved area must be in CMR.
+ *  - TDMR reserved area doesn't have to be in CMR.
+ *  - TDMR non-reserved area cannot overlap with PAMT.
+ *  - PAMT may reside within TDMR reserved area.
+ *  - PAMT must be in CMR.
+ *
+ */
+static int __init __construct_tdmrs(void)
+{
+	u64 tdmr_start_pfn, tdmr_end_pfn, tdmr_start_pfn_next, inc_pfn;
+	unsigned long start_pfn, end_pfn;
+	int last_nid, nid, i, idx, ret;
+
+	/* Sanity check on tdx_tdsysinfo... */
+	if (!tdx_tdsysinfo.max_tdmrs || !tdx_tdsysinfo.max_reserved_per_tdmr ||
+	    !tdx_tdsysinfo.pamt_entry_size) {
+		pr_err("Invalid TDSYSINFO_STRUCT reported by TDSYSINFO.\n");
+		return -ENOTSUPP;
+	}
+
+	idx = 0;
+	tdmr_start_pfn = 0;
+	tdmr_end_pfn = 0;
+	last_nid = MAX_NUMNODES;
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		if (last_nid == MAX_NUMNODES) {
+			/* First memory range */
+			last_nid = nid;
+			tdmr_start_pfn = ALIGN_DOWN(start_pfn, TDMR_PFN_ALIGNMENT);
+			WARN_ON(tdmr_start_pfn != 0);
+		} else if (nid == last_nid) {
+			/*
+			 * This memory range is in the same node as previous
+			 * one, update tdmr_end_pfn.
+			 */
+			tdmr_end_pfn = ALIGN(end_pfn, TDMR_PFN_ALIGNMENT);
+		} else if (ALIGN_DOWN(start_pfn, TDMR_PFN_ALIGNMENT) >= tdmr_end_pfn) {
+			/* This memory range is in next node */
+			/*
+			 * If new TDMR start pfn is greater than previous TDMR
+			 * end pfn, then it's ready to convert previous node's
+			 * memory to TDMR.
+			 */
+			ret = construct_tdmr_node(&idx, tdmr_start_pfn,
+						  tdmr_end_pfn);
+			if (ret)
+				return ret;
+			tdmr_start_pfn = ALIGN(start_pfn, TDMR_PFN_ALIGNMENT);
+			tdmr_end_pfn = ALIGN(end_pfn, TDMR_PFN_ALIGNMENT);
+			last_nid = nid;
+		} else {
+			/*
+			 * This memory range is in the next node, and the
+			 * boundary between nodes falls into 1G range. In this
+			 * case, put beginning of second node into the TDMR
+			 * which covers previous node. This is not ideal but
+			 * this case is very unlikely as well so should be OK
+			 * for now.
+			 */
+			tdmr_end_pfn = ALIGN(start_pfn, TDMR_PFN_ALIGNMENT);
+
+			ret = construct_tdmr_node(&idx, tdmr_start_pfn,
+						  tdmr_end_pfn);
+			if (ret)
+				return ret;
+
+			tdmr_start_pfn = tdmr_end_pfn;
+			last_nid = nid;
+		}
+	}
+
+	/* Spread out the remaining memory across multiple TDMRs. */
+	inc_pfn = (tdmr_end_pfn - tdmr_start_pfn) /
+		  (tdx_tdsysinfo.max_tdmrs - idx);
+	inc_pfn = ALIGN(inc_pfn, TDMR_PFN_ALIGNMENT);
+
+	tdmr_start_pfn_next = tdmr_end_pfn;
+	while (tdmr_start_pfn < tdmr_start_pfn_next) {
+		if (idx == tdx_tdsysinfo.max_tdmrs - 1)
+			tdmr_end_pfn = tdmr_start_pfn_next;
+		else
+			tdmr_end_pfn = tdmr_start_pfn + inc_pfn;
+retry:
+		tdmr_end_pfn = min(tdmr_end_pfn, tdmr_start_pfn_next);
+
+		ret = construct_tdmr_node(&idx, tdmr_start_pfn, tdmr_end_pfn);
+		if (ret == -ENOMEM) {
+			if (tdmr_end_pfn == tdmr_start_pfn_next)
+				return -ENOMEM;
+			tdmr_end_pfn += inc_pfn;
+			goto retry;
+		}
+		if (ret)
+			return ret;
+		tdmr_start_pfn = tdmr_end_pfn;
+	}
+
+	tdx_nr_tdmrs = idx;
+
+	return 0;
+}
+
+static int __init e820_type_cmr_ram(enum e820_type type)
+{
+	/*
+	 * CMR needs to at least cover e820 memory regions which will be later
+	 * freed to kernel memory allocator, otherwise kernel may allocate
+	 * non-TDMR pages, i.e. when KVM allocates memory.
+	 *
+	 * Note memblock also treats E820_TYPE_RESERVED_KERN as memory so also
+	 * need to cover it.
+	 *
+	 * FIXME:
+	 *
+	 * Need to cover other types which are actually RAM, i.e:
+	 *
+	 *   E820_TYPE_ACPI,
+	 *   E820_TYPE_NVS
+	 */
+	return (type == E820_TYPE_RAM || type == E820_TYPE_RESERVED_KERN);
+}
+
+static int __init in_cmr_range(u64 addr, u64 size)
+{
+	struct cmr_info *cmr;
+	u64 cmr_end, end;
+	int i;
+
+	end = addr + size;
+
+	/* Ignore bad area */
+	if (end < addr)
+		return 1;
+
+	for (i = 0; i < tdx_nr_cmrs; i++) {
+		cmr = &tdx_cmrs[i];
+		cmr_end = cmr->base + cmr->size;
+
+		/* Found one CMR which covers the range [addr, addr + size) */
+		if (cmr->base <= addr && cmr_end >= end)
+			return 1;
+	}
+
+	return 0;
+}
+
+static int __init sanitize_cmrs(void)
+{
+	struct e820_entry *entry;
+	bool observed_empty;
+	int i, j;
+
+	if (!tdx_nr_cmrs)
+		return -EIO;
+
+	for (i = 0, j = -1, observed_empty = false; i < tdx_nr_cmrs; i++) {
+		if (!tdx_cmrs[i].size) {
+			observed_empty = true;
+			continue;
+		}
+		/* Valid entry after empty entry isn't allowed, per SEAM. */
+		if (observed_empty)
+			return -EIO;
+
+		/* The previous CMR must reside fully below this CMR. */
+		if (j >= 0 &&
+		    (tdx_cmrs[j].base + tdx_cmrs[j].size) > tdx_cmrs[i].base)
+			return -EIO;
+
+		if (j < 0 ||
+		    (tdx_cmrs[j].base + tdx_cmrs[j].size) != tdx_cmrs[i].base) {
+			j++;
+			if (i != j) {
+				tdx_cmrs[j].base = tdx_cmrs[i].base;
+				tdx_cmrs[j].size = tdx_cmrs[i].size;
+			}
+		} else {
+			 tdx_cmrs[j].size += tdx_cmrs[i].size;
+		}
+	}
+	tdx_nr_cmrs = j + 1;
+	if (!tdx_nr_cmrs)
+		return -EINVAL;
+
+	/*
+	 * Sanity check whether CMR has covered all memory in E820. We need
+	 * to make sure that CMR covers all memory that will be freed to page
+	 * allocator, otherwise alloc_pages() may return non-TDMR pages, i.e.
+	 * when KVM allocates memory for VM. Cannot allow that to happen, so
+	 * disable TDX if we found CMR doesn't cover all.
+	 *
+	 * FIXME:
+	 *
+	 * Alternatively we could just check against memblocks? Only memblocks
+	 * are freed to page allocator so it appears to be OK as long as CMR
+	 * covers all memblocks. But CMR should be generated by BIOS thus should
+	 * be cover e820..
+	 */
+	for (i = 0; i < e820_table->nr_entries; i++) {
+		entry = &e820_table->entries[i];
+
+		if (!e820_type_cmr_ram(entry->type))
+			continue;
+
+		if (!in_cmr_range(entry->addr, entry->size))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __init construct_tdmrs(void)
+{
+	struct pamt_info *pamt;
+	int ret, i;
+
+	ret = sanitize_cmrs();
+	if (ret)
+		return ret;
+
+	ret = __construct_tdmrs();
+	if (ret)
+		goto free_pamts;
+	return 0;
+
+free_pamts:
+	for (i = 0; i < ARRAY_SIZE(tdx_pamts); i++) {
+		pamt = &tdx_pamts[i];
+		if (pamt->pamt_base && pamt->pamt_size) {
+			if (WARN_ON(!IS_ALIGNED(pamt->pamt_base, PAGE_SIZE) ||
+				    !IS_ALIGNED(pamt->pamt_size, PAGE_SIZE)))
+				continue;
+
+			memblock_free(pamt->pamt_base, pamt->pamt_size);
+		}
+	}
+
+	memset(tdx_pamts, 0, sizeof(tdx_pamts));
+	memset(tdx_tdmrs, 0, sizeof(tdx_tdmrs));
+	tdx_nr_tdmrs = 0;
+	return ret;
+}
+
+
+/*
+ * Well.. I guess a better way is to put cpu_vmxon() into asm/virtext.h,
+ * and split kvm_cpu_vmxon() into cpu_vmxon(), and intel_pt_handle_vmx(),
+ * so we just only have one cpu_vmxon() in asm/virtext.h..
+ */
+static inline void cpu_vmxon(u64 vmxon_region)
+{
+	cr4_set_bits(X86_CR4_VMXE);
+	asm volatile ("vmxon %0" : : "m"(vmxon_region));
+}
+
+static inline int tdx_init_vmxon_vmcs(struct vmcs *vmcs)
+{
+	u64 msr;
+
+	/*
+	 * Can't enable TDX if VMX is unsupported or disabled by BIOS.
+	 * cpu_has(X86_FEATURE_VMX) can't be relied on as the BSP calls this
+	 * before the kernel has configured feat_ctl().
+	 */
+	if (!cpu_has_vmx())
+		return -ENOTSUPP;
+
+	if (rdmsrl_safe(MSR_IA32_FEAT_CTL, &msr) ||
+	    !(msr & FEAT_CTL_LOCKED) ||
+	    !(msr & FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX))
+		return -ENOTSUPP;
+
+	if (rdmsrl_safe(MSR_IA32_VMX_BASIC, &msr))
+		return -ENOTSUPP;
+
+	memset(vmcs, 0, PAGE_SIZE);
+	vmcs->hdr.revision_id = (u32)msr;
+
+	return 0;
+}
+
+#define MSR_IA32_TME_ACTIVATE		0x982
+
+static inline void tdx_get_keyids(u32 *keyids_start, u32 *nr_keyids)
+{
+	u32 nr_mktme_ids;
+
+	rdmsr(MSR_IA32_MKTME_KEYID_PART, nr_mktme_ids, *nr_keyids);
+
+	/* KeyID 0 is reserved, i.e. KeyIDs are 1-based. */
+	*keyids_start = nr_mktme_ids + 1;
+}
+
+static int tdx_init_ap(unsigned long vmcs)
+{
+	u32 keyids_start, nr_keyids;
+	struct tdx_ex_ret ex_ret;
+	u64 err;
+
+	/*
+	 * MSR_IA32_MKTME_KEYID_PART is core-scoped, disable TDX if this CPU's
+	 * partitioning doesn't match the BSP's partitioning.
+	 */
+	tdx_get_keyids(&keyids_start, &nr_keyids);
+	if (keyids_start != tdx_keyids_start || nr_keyids != tdx_nr_keyids) {
+		pr_err("MKTME KeyID partioning inconsistent on CPU %u\n",
+		       smp_processor_id());
+		return -ENOTSUPP;
+	}
+
+	cpu_vmxon(__pa(vmcs));
+	err = tdsysinitlp(&ex_ret);
+	cpu_vmxoff();
+
+	if (TDX_ERR(err, TDSYSINITLP))
+		return -EIO;
+
+	return 0;
+}
+
+void tdx_init_cpu(struct cpuinfo_x86 *c)
+{
+	unsigned long vmcs;
+
+	/* Allocate VMCS for VMXON. */
+	vmcs = __get_free_page(GFP_KERNEL);
+	if (!vmcs)
+		goto err;
+
+	/* VMCS configuration shouldn't fail at this point. */
+	if (WARN_ON_ONCE(tdx_init_vmxon_vmcs((void *)vmcs)))
+		goto err_vmcs;
+
+	/* BSP does TDSYSINITLP as part of tdx_seam_init(). */
+	if (c != &boot_cpu_data && tdx_init_ap(vmcs))
+		goto err_vmcs;
+
+	this_cpu_write(tdx_vmxon_vmcs, vmcs);
+	return;
+
+err_vmcs:
+	free_page(vmcs);
+err:
+	clear_cpu_cap(c, X86_FEATURE_TDX);
+	atomic_inc(&tdx_init_cpu_errors);
+}
+
+static __init int tdx_init_bsp(void)
+{
+	struct tdx_ex_ret ex_ret;
+	void *vmcs;
+	u64 err;
+	int ret;
+
+	/*
+	 * Detect HKID for TDX if initialization was successful.
+	 *
+	 * TDX provides core-scoped MSR for us to simply read out TDX start
+	 * keyID and number of keyIDs.
+	 */
+	tdx_get_keyids(&tdx_keyids_start, &tdx_nr_keyids);
+	if (!tdx_nr_keyids)
+		return -ENOTSUPP;
+
+	/*
+	 * Allocate a temporary VMCS for early BSP init, the VMCS for late(ish)
+	 * init will be allocated after the page allocator is up and running.
+	 */
+	vmcs = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
+	if (!vmcs)
+		return -ENOMEM;
+
+	ret = tdx_init_vmxon_vmcs(vmcs);
+	if (ret)
+		goto out;
+
+	cpu_vmxon(__pa(vmcs));
+
+	err = tdsysinit(tdx_sysprof ? BIT(0) : 0, &ex_ret);
+	if (TDX_ERR(err, TDSYSINIT)) {
+		ret = -EIO;
+		goto out_vmxoff;
+	}
+
+	err = tdsysinitlp(&ex_ret);
+	if (TDX_ERR(err, TDSYSINITLP)) {
+		ret = -EIO;
+		goto out_vmxoff;
+	}
+
+	/*
+	 * Do TDSYSINFO to collect the information needed to construct TDMRs,
+	 * which needs to be done before kernel page allocator is up as the
+	 * page allocator can't provide the large chunk (>4MB) of memory needed
+	 * for the PAMTs.
+	 */
+	err = tdsysinfo(__pa(&tdx_tdsysinfo), sizeof(tdx_tdsysinfo),
+			__pa(tdx_cmrs), TDX1_MAX_NR_CMRS, &ex_ret);
+	if (TDX_ERR(err, TDSYSINFO)) {
+		ret = -EIO;
+		goto out_vmxoff;
+	}
+
+	tdx_nr_cmrs = ex_ret.nr_cmr_entries;
+	ret = 0;
+
+out_vmxoff:
+	cpu_vmxoff();
+out:
+	memblock_free(__pa(vmcs), PAGE_SIZE);
+	return ret;
+}
+
+static bool __init tdx_all_cpus_available(void)
+{
+	/*
+	 * CPUs detected in ACPI can be marked as disabled due to:
+	 *   1) disabled in ACPI MADT table
+	 *   2) disabled by 'disable_cpu_apicid' kernel parameter, which
+	 *     disables CPU with particular APIC id.
+	 *   3) limited by 'nr_cpus' kernel parameter.
+	 */
+	if (disabled_cpus) {
+		pr_info("Disabled CPUs detected");
+		goto err;
+	}
+
+	if (num_possible_cpus() < num_processors) {
+		pr_info("Number of CPUs limited by 'possible_cpus' kernel param");
+		goto err;
+	}
+
+	if (setup_max_cpus < num_processors) {
+		pr_info("Boot-time CPUs limited by 'maxcpus' kernel param");
+		goto err;
+	}
+
+	return true;
+
+err:
+	pr_cont(", skipping TDX-SEAM load/config.\n");
+	return false;
+}
+
+static bool __init tdx_get_firmware(struct cpio_data *blob, const char *name)
+{
+	char path[64];
+
+	if (get_builtin_firmware(blob, name))
+		return true;
+
+	if (!IS_ENABLED(CONFIG_BLK_DEV_INITRD) || !initrd_start)
+		return false;
+
+	snprintf(path, sizeof(path), "lib/firmware/%s", name);
+	*blob = find_cpio_data(path, (void *)initrd_start,
+			       initrd_end - initrd_start, NULL);
+
+	return !!blob->data;
+}
+
+void __init tdx_seam_init(void)
+{
+	const char *sigstruct_name = "intel-seam/libtdx.so.sigstruct";
+	const char *seamldr_name = "intel-seam/seamldr.acm";
+	const char *module_name = "intel-seam/libtdx.so";
+	struct cpio_data module, sigstruct, seamldr;
+
+	/*
+	 * Don't load/configure SEAM if not all CPUs can be brought up during
+	 * smp_init(), TDX must execute TDSYSINITLP on all logical processors.
+	 */
+	if (!tdx_all_cpus_available())
+		return;
+
+	if (!tdx_get_firmware(&module, module_name))
+		return;
+
+	if (!tdx_get_firmware(&sigstruct, sigstruct_name))
+		return;
+
+	if (!tdx_get_firmware(&seamldr, seamldr_name))
+		return;
+
+	if (seam_load_module(module.data, module.size, sigstruct.data,
+			     sigstruct.size, seamldr.data, seamldr.size))
+		return;
+
+	if (tdx_init_bsp() || construct_tdmrs())
+		return;
+
+	setup_force_cpu_cap(X86_FEATURE_TDX);
+}
+
+/*
+ * Setup one-cpu-per-pkg array to do package-scoped SEAMCALLs.  The array is
+ * only necessary if there are multiple packages.
+ */
+static int __init init_package_masters(void)
+{
+	int cpu, pkg, nr_filled, nr_pkgs;
+
+	nr_pkgs = topology_max_packages();
+	if (nr_pkgs == 1)
+		return 0;
+
+	tdx_package_masters = kcalloc(nr_pkgs, sizeof(int), GFP_KERNEL);
+	if (!tdx_package_masters)
+		return -ENOMEM;
+
+	memset(tdx_package_masters, -1, nr_pkgs * sizeof(int));
+
+	nr_filled = 0;
+	for_each_online_cpu(cpu) {
+		pkg = topology_physical_package_id(cpu);
+		if (tdx_package_masters[pkg] >= 0)
+			continue;
+
+		tdx_package_masters[pkg] = cpu;
+		if (++nr_filled == topology_max_packages())
+			break;
+	}
+
+	if (WARN_ON(nr_filled != topology_max_packages())) {
+		kfree(tdx_package_masters);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void __tdx_seamcall_on_other_pkgs(smp_call_func_t fn, void *param)
+{
+	int i, cpu, cur_package;
+
+	cpu = raw_smp_processor_id();
+	cur_package = topology_physical_package_id(cpu);
+
+	for (i = 0; i < topology_max_packages(); i++) {
+		if (i == cur_package)
+			continue;
+
+		smp_call_function_single(tdx_package_masters[i], fn, param, 1);
+	}
+}
+
+void tdx_seamcall_on_other_pkgs(smp_call_func_t fn, void *param,
+				struct mutex *lock)
+{
+	if (WARN_ON_ONCE(!tdx_package_masters))
+		return;
+
+	mutex_lock(lock);
+	preempt_disable();
+
+	__tdx_seamcall_on_other_pkgs(fn, param);
+
+	preempt_enable();
+	mutex_unlock(lock);
+}
+EXPORT_SYMBOL_GPL(tdx_seamcall_on_other_pkgs);
+
+static void __init tdx_vmxon(void *ret)
+{
+	cpu_vmxon(__pa(this_cpu_read(tdx_vmxon_vmcs)));
+}
+
+static void __init tdx_vmxoff(void *ign)
+{
+	cpu_vmxoff();
+}
+
+static void __init tdx_free_vmxon_vmcs(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		free_page(per_cpu(tdx_vmxon_vmcs, cpu));
+		per_cpu(tdx_vmxon_vmcs, cpu) = 0;
+	}
+}
+
+static void __init do_tdsysconfigkey(void *failed)
+{
+	u64 err;
+
+	if (*(int *)failed)
+		return;
+
+	do {
+		err = tdsysconfigkey();
+	} while (err == TDX_KEY_GENERATION_FAILED);
+	TDX_ERR(err, TDSYSCONFIGKEY);
+
+	if (err)
+		*(int *)failed = -EIO;
+}
+
+static void __init __tdx_init_tdmrs(void *failed)
+{
+	struct tdx_ex_ret ex_ret;
+	u64 base, size;
+	u64 err;
+	int i;
+
+	for (i = atomic_fetch_add(1, &tdx_next_tdmr_index);
+	     i < tdx_nr_tdmrs;
+	     i = atomic_fetch_add(1, &tdx_next_tdmr_index)) {
+		base = tdx_tdmrs[i].base;
+		size = tdx_tdmrs[i].size;
+
+		do {
+			/* Abort if a different CPU failed. */
+			if (atomic_read(failed))
+				return;
+
+			err = tdsysinittdmr(base, &ex_ret);
+			if (TDX_ERR(err, TDSYSINITTDMR)) {
+				atomic_inc(failed);
+				return;
+			}
+		/*
+		 * Note, "next" is simply an indicator, base is passed to
+		 * TDSYSINTTDMR on every iteration.
+		 */
+		} while (ex_ret.next < (base + size));
+
+		atomic_inc(&tdx_nr_initialized_tdmrs);
+	}
+}
+
+static int __init tdx_init_tdmrs(void)
+{
+	atomic_t failed = ATOMIC_INIT(0);
+
+	/*
+	 * Flush the cache to guarantee there no MODIFIED cache lines exist for
+	 * PAMTs before TDSYSINITTDMR, which will initialize PAMT memory using
+	 * TDX-SEAM's reserved/system HKID.
+	 */
+	wbinvd_on_all_cpus();
+
+	on_each_cpu(__tdx_init_tdmrs, &failed, 0);
+
+	while (atomic_read(&tdx_nr_initialized_tdmrs) < tdx_nr_tdmrs) {
+		if (atomic_read(&failed))
+			return -EIO;
+	}
+
+	return 0;
+}
+
+static int __init tdx_init(void)
+{
+	int ret, i;
+	u64 err;
+
+	if (!boot_cpu_has(X86_FEATURE_TDX))
+		return -ENOTSUPP;
+
+	/* Disable TDX if any CPU(s) failed to boot. */
+	if (!cpumask_equal(cpu_present_mask, &cpus_booted_once_mask)) {
+		ret = -EIO;
+		goto err;
+	}
+
+	if (atomic_read(&tdx_init_cpu_errors)) {
+		ret = -EIO;
+		goto err;
+	}
+
+	ret = init_package_masters();
+	if (ret)
+		goto err;
+
+	on_each_cpu(tdx_vmxon, NULL, 1);
+
+	for (i = 0; i < tdx_nr_tdmrs; i++)
+		tdx_tdmr_addrs[i] = __pa(&tdx_tdmrs[i]);
+
+	/* Use the first keyID as TDX-SEAM's global key. */
+	err = tdsysconfig(__pa(tdx_tdmr_addrs), tdx_nr_tdmrs, tdx_keyids_start);
+	if (TDX_ERR(err, TDSYSCONFIG)) {
+		ret = -EIO;
+		goto err_vmxoff;
+	}
+
+	do_tdsysconfigkey(&ret);
+	if (!ret && topology_max_packages() > 1)
+		__tdx_seamcall_on_other_pkgs(do_tdsysconfigkey, &ret);
+	if (ret)
+		goto err_vmxoff;
+
+	ret = tdx_init_tdmrs();
+	if (ret)
+		goto err_vmxoff;
+
+	on_each_cpu(tdx_vmxoff, NULL, 1);
+	tdx_free_vmxon_vmcs();
+
+	pr_info("TDX initialized.\n");
+	return 0;
+
+err_vmxoff:
+	on_each_cpu(tdx_vmxoff, NULL, 1);
+err:
+	tdx_free_vmxon_vmcs();
+	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_TDX);
+	return ret;
+}
+arch_initcall(tdx_init);
+
+struct tdsysinfo_struct *tdx_get_sysinfo(void)
+{
+	if (boot_cpu_has(X86_FEATURE_TDX))
+		return &tdx_tdsysinfo;
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
+int tdx_keyid_alloc(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_TDX))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(!tdx_keyids_start || !tdx_nr_keyids))
+		return -EINVAL;
+
+	/* The first keyID is reserved for the global key. */
+	return ida_alloc_range(&tdx_keyid_pool, tdx_keyids_start + 1,
+			       tdx_keyids_start + tdx_nr_keyids - 2,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
+
+void tdx_keyid_free(int keyid)
+{
+	if (!keyid || keyid < 0)
+		return;
+
+	ida_free(&tdx_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_keyid_free);
-- 
2.17.1

