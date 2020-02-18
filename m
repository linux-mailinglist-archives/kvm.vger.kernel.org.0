Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6684B163595
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgBRV6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:58:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:52969 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728027AbgBRV6g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:58:36 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:58:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436004652"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 13:58:35 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        liran.alon@oracle.com, luto@kernel.org, joro@8bytes.org,
        rick.p.edgecombe@intel.com, kristen@linux.intel.com,
        arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, John Andersen <john.s.andersen@intel.com>
Subject: [RFC v2 4/4] X86: Use KVM CR pin MSRs
Date:   Tue, 18 Feb 2020 13:59:02 -0800
Message-Id: <20200218215902.5655-5-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200218215902.5655-1-john.s.andersen@intel.com>
References: <20200218215902.5655-1-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Strengthen existing control register pinning when running
paravirtualized under KVM. Check which bits KVM supports pinning for
each control register and only pin supported bits which are already
pinned via the existing native protection. Write to KVM CR0/4 pinned
MSRs to enable pinning.

Initiate KVM assisted pinning directly following the setup of native
pinning on boot CPU. For non-boot CPUs initiate paravirtualized pinning
on CPU identification.

Identification of non-boot CPUs takes place after the boot CPU has setup
native CR pinning. Therefore, non-boot CPUs access pinned bits setup by
the boot CPU and request that those be pinned. All CPUs request
paravirtualized pinning of the same bits which are already pinned
natively.

Guests using the kexec system call currently do not support
paravirtualized control register pinning. This is due to early boot
code writing known good values to control registers, these values do
not contain the protected bits. This is due to CPU feature
identification being done at a later time, when the kernel properly
checks if it can enable protections. As such, the pv_cr_pin command line
option has been added which instructs the kernel to disable kexec in
favor of enabling paravirtualized control register pinning. crashkernel
is also disabled when the pv_cr_pin parameter is specified due to its
reliance on kexec.

When we fix kexec, we will still need a way for a kernel with support to
know if the kernel it is attempting to load has support. If a kernel
with this enabled attempts to kexec a kernel where this is not
supported, it would trigger a fault almost immediately.

Liran suggested adding a section to the built image acting as a flag to
signify support for being kexec'd by a kernel with pinning enabled.
Should that approach be implemented, it is likely that the command line
flag (pv_cr_pin) would still be desired for some deprecation period. We
wouldn't want the default behavior to change from being able to kexec
older kernels to not being able to, as this might break some users
workflows.

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 .../admin-guide/kernel-parameters.txt         | 11 ++++++
 arch/x86/Kconfig                              | 10 +++++
 arch/x86/include/asm/kvm_para.h               | 17 ++++++++
 arch/x86/kernel/cpu/common.c                  |  5 +++
 arch/x86/kernel/kvm.c                         | 39 +++++++++++++++++++
 arch/x86/kernel/setup.c                       |  8 ++++
 6 files changed, 90 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dbc22d684627..8552501a1579 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3836,6 +3836,17 @@
 			[KNL] Number of legacy pty's. Overwrites compiled-in
 			default number.
 
+	pv_cr_pin	[SECURITY,X86]
+			Enable paravirtualized control register pinning. When
+			running paravirutalized under KVM, request that KVM not
+			allow the guest to disable kernel protection features
+			set in CPU control registers. Specifying this option
+			will disable kexec (and crashkernel). If kexec support
+			has not been compiled into the kernel and host KVM
+			supports paravirtualized control register pinning, it
+			will be active by default without the need to specify
+			this parameter.
+
 	quiet		[KNL] Disable most log messages
 
 	r128=		[HW,DRM]
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beea77046f9b..d47b09ae23bd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -800,6 +800,7 @@ config KVM_GUEST
 	bool "KVM Guest support (including kvmclock)"
 	depends on PARAVIRT
 	select PARAVIRT_CLOCK
+	select PARAVIRT_CR_PIN
 	select ARCH_CPUIDLE_HALTPOLL
 	default y
 	---help---
@@ -843,6 +844,15 @@ config PARAVIRT_TIME_ACCOUNTING
 config PARAVIRT_CLOCK
 	bool
 
+config PARAVIRT_CR_PIN
+       bool "Paravirtual bit pinning for CR0 and CR4"
+       depends on KVM_GUEST
+       help
+         Select this option to have the virtualised guest request that the
+         hypervisor disallow it from disabling protections set in control
+         registers. The hypervisor will prevent exploits from disabling
+         features such as SMEP, SMAP, UMIP, and WP.
+
 config JAILHOUSE_GUEST
 	bool "Jailhouse non-root cell support"
 	depends on X86_64 && PCI
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..342b475e7adf 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -102,6 +102,23 @@ static inline void kvm_spinlock_init(void)
 }
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
+#ifdef CONFIG_PARAVIRT_CR_PIN
+void __init kvm_paravirt_cr_pinning_init(void);
+void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
+				   unsigned long cr4_pinned_bits);
+#else
+static inline void kvm_paravirt_cr_pinning_init(void)
+{
+	return;
+}
+
+static inline void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
+						 unsigned long cr4_pinned_bits)
+{
+	return;
+}
+#endif /* CONFIG_PARAVIRT_CR_PIN */
+
 #else /* CONFIG_KVM_GUEST */
 #define kvm_async_pf_task_wait(T, I) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 08682757e547..bbf1de0cb253 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
+#include <linux/kvm_para.h>
 
 #include <asm/stackprotector.h>
 #include <asm/perf_event.h>
@@ -416,6 +417,8 @@ static void __init setup_cr_pinning(void)
 	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
 	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
 	static_key_enable(&cr_pinning.key);
+
+	kvm_setup_paravirt_cr_pinning(X86_CR0_WP, cr4_pinned_bits);
 }
 
 /*
@@ -1589,6 +1592,8 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 	mtrr_ap_init();
 	validate_apic_and_package_id(c);
 	x86_spec_ctrl_setup_ap();
+
+	kvm_setup_paravirt_cr_pinning(X86_CR0_WP, cr4_pinned_bits);
 }
 
 static __init int setup_noclflush(char *arg)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d817f255aed8..f6c159229e35 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -24,6 +24,8 @@
 #include <linux/debugfs.h>
 #include <linux/nmi.h>
 #include <linux/swait.h>
+#include <linux/init.h>
+#include <linux/kexec.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -34,6 +36,7 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/cmdline.h>
 
 static int kvmapf = 1;
 
@@ -708,6 +711,7 @@ static void __init kvm_apic_init(void)
 static void __init kvm_init_platform(void)
 {
 	kvmclock_init();
+	kvm_paravirt_cr_pinning_init();
 	x86_platform.apic_post_init = kvm_apic_init;
 }
 
@@ -857,6 +861,41 @@ void __init kvm_spinlock_init(void)
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
+#ifdef CONFIG_PARAVIRT_CR_PIN
+static int kvm_paravirt_cr_pinning_enabled __ro_after_init = 0;
+
+void __init kvm_paravirt_cr_pinning_init()
+{
+#ifdef CONFIG_KEXEC_CORE
+	if (!cmdline_find_option_bool(boot_command_line, "pv_cr_pin"))
+		return;
+
+	/* Paravirtualized CR pinning is currently incompatible with kexec */
+	kexec_load_disabled = 1;
+#endif
+
+	kvm_paravirt_cr_pinning_enabled = 1;
+}
+
+void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
+				   unsigned long cr4_pinned_bits)
+{
+	u64 mask;
+
+	if (!kvm_paravirt_cr_pinning_enabled)
+		return;
+
+	if (!kvm_para_has_feature(KVM_FEATURE_CR_PIN))
+		return;
+
+	rdmsrl(MSR_KVM_CR0_PIN_ALLOWED, mask);
+	wrmsrl(MSR_KVM_CR0_PINNED, cr0_pinned_bits & mask);
+
+	rdmsrl(MSR_KVM_CR4_PIN_ALLOWED, mask);
+	wrmsrl(MSR_KVM_CR4_PINNED, cr4_pinned_bits & mask);
+}
+#endif
+
 #ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
 
 static void kvm_disable_host_haltpoll(void *i)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9e71d6f6e564..a75f9e730cc3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -26,6 +26,9 @@
 #include <asm/apic.h>
 #include <asm/bios_ebda.h>
 #include <asm/bugs.h>
+#include <asm/kasan.h>
+#include <asm/cmdline.h>
+
 #include <asm/cpu.h>
 #include <asm/efi.h>
 #include <asm/gart.h>
@@ -496,6 +499,11 @@ static void __init reserve_crashkernel(void)
 		return;
 	}
 
+	if (cmdline_find_option_bool(boot_command_line, "pv_cr_pin")) {
+		pr_info("Ignoring crashkernel since pv_cr_pin present in cmdline\n");
+		return;
+	}
+
 	/* 0 means: find the address automatically */
 	if (!crash_base) {
 		/*
-- 
2.21.0

