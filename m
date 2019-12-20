Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0191282B9
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 20:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfLTT1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 14:27:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:28192 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727394AbfLTT1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 14:27:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 11:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,336,1571727600"; 
   d="scan'208";a="222547143"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2019 11:27:39 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        John Andersen <john.s.andersen@intel.com>
Subject: [RESEND RFC 2/2] X86: Use KVM CR pin MSRs
Date:   Fri, 20 Dec 2019 11:27:01 -0800
Message-Id: <20191220192701.23415-3-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191220192701.23415-1-john.s.andersen@intel.com>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Strengthen existing control register pinning when running
paravirtualized under KVM. Check which bits KVM supports pinning for
each control register and only pin supported bits which are already
pinned via the existing native protection. Write to KVM CR0 and CR4
pinned MSRs to enable pinning.

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
checks if it can enable protections.

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 arch/x86/Kconfig                |  9 +++++++++
 arch/x86/include/asm/kvm_para.h | 10 ++++++++++
 arch/x86/kernel/cpu/common.c    |  5 +++++
 arch/x86/kernel/kvm.c           | 17 +++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ef85139553f..f5c61e3bd0c9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -839,6 +839,15 @@ config PARAVIRT_TIME_ACCOUNTING
 config PARAVIRT_CLOCK
 	bool
 
+config PARAVIRT_CR_PIN
+       bool "Paravirtual bit pinning for CR0 and CR4"
+       depends on KVM_GUEST && !KEXEC
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
index 9b4df6eaa11a..a7b48e43d2dc 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -102,6 +102,16 @@ static inline void kvm_spinlock_init(void)
 }
 #endif /* CONFIG_PARAVIRT_SPINLOCKS */
 
+#ifdef CONFIG_PARAVIRT_CR_PIN
+void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
+				   unsigned long cr4_pinned_bits);
+#else
+static inline void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
+						 unsigned long cr4_pinned_bits)
+{
+}
+#endif /* CONFIG_PARAVIRT_CR_PIN */
+
 #else /* CONFIG_KVM_GUEST */
 #define kvm_async_pf_task_wait(T, I) do {} while(0)
 #define kvm_async_pf_task_wake(T) do {} while(0)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index fffe21945374..e6112abb7115 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -20,6 +20,7 @@
 #include <linux/smp.h>
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
+#include <linux/kvm_para.h>
 
 #include <asm/stackprotector.h>
 #include <asm/perf_event.h>
@@ -435,6 +436,8 @@ static void __init setup_cr_pinning(void)
 	mask = (X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_UMIP);
 	cr4_pinned_bits = this_cpu_read(cpu_tlbstate.cr4) & mask;
 	static_key_enable(&cr_pinning.key);
+
+	kvm_setup_paravirt_cr_pinning(X86_CR0_WP, cr4_pinned_bits);
 }
 
 /*
@@ -1597,6 +1600,8 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 	mtrr_ap_init();
 	validate_apic_and_package_id(c);
 	x86_spec_ctrl_setup_ap();
+
+	kvm_setup_paravirt_cr_pinning(X86_CR0_WP, cr4_pinned_bits);
 }
 
 static __init int setup_noclflush(char *arg)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 32ef1ee733b7..b8404cd9f318 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -858,6 +858,23 @@ void __init kvm_spinlock_init(void)
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
+#ifdef CONFIG_PARAVIRT_CR_PIN
+void kvm_setup_paravirt_cr_pinning(unsigned long cr0_pinned_bits,
+				   unsigned long cr4_pinned_bits)
+{
+	u64 mask;
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
-- 
2.21.0

