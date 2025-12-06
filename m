Return-Path: <kvm+bounces-65450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F0CCA9D09
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 44070303519C
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8677E25A2DD;
	Sat,  6 Dec 2025 01:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wi29wvsd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A36A1EE7DC
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983474; cv=none; b=WULovv4JQYw25hTK5ZG0Q42RWuj81/03y2ZWgLtdkZPvnpchgiLYKlb3SaBTX0rZsNEN84xalgEeyKRA2BmmhHOyNpcUyXWSGJCQxF/fhXW5Jmo8KTh7xb0h4tUPeGV6cQXijTu2r6CQcafc77zhxtK1y6x3CCBttxbRZX7zWME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983474; c=relaxed/simple;
	bh=201CsGCKz4W0+urVUOwLVm4MClguf+5ukCDnh75zDfM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oGUBcdeTIr+j9l35QtIdCUrlC9K5UXt94HmGruZhI0yKF14HLeSrgyosvtpbrDRl6h2jvC15ZFMXAt4GgA8LRckQ5pHeoky0MfpCKsksxlMQWilsQnUH3UVH/m3g5cATfTJ77VdROy/ML+dOiXCNXItmiNh4I1vizDXwXT/agSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wi29wvsd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34740cc80d5so5081169a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983470; x=1765588270; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=njfJRAYPK82NhbJUu19myDsBJhYLqhss6OzhV1U4+RA=;
        b=wi29wvsdmh326T6obLcFFPtP8lI+XtA0EMywOSo3nWmSreOpEdoS9ZZ/F0z+pXmrdV
         Z+78A4OlKx1nw6X8mq8bIlSqE0BMLo3dloU9GlrcnTBNGPZiiX70GiRUDebXz1nfDTpR
         s3aP2ybLFBi8g/Q1IKkp0XNzLJq1OSW3xHapZcdpQciV9O8x6LOCgG7YjUpcWiC06qfc
         SjcyOWENAVWONgFG7rOfLWsiB/vUKlrizBeG5n9nAcl6fmS5W5rd37QeWrMgPp6J0o9D
         24PJ7bKue9BLFIN4ebfJVKOAqHlIkf8AzX+MOP2B9yqkqp8FgSWZwaRa1ZlruFIp9VVA
         txZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983470; x=1765588270;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njfJRAYPK82NhbJUu19myDsBJhYLqhss6OzhV1U4+RA=;
        b=QuP14P+Lj9KR8W3l5bPuEPIKeb0mSBx8LKyYq0wnu8T6U9zef/X5OOJeMPbJI0dNko
         DqHsNwuoD1KGSuIqva98B0qHuSvOAC5W0nOt0YlOAsqXC3hniKQjG0zSAZcCzM68edfw
         aU1akGq3LuEEFjhu6kJJk1xMPhJilBWLOjGNgU0rpQdLzkIdI5d4zOaqnJZvQkMqGMs+
         JSP7ljliNt4Qw797pOsG73Ad5HlVJAinDXSFxExqbWxNt6wQVQspeNZnkOlsQknBFJoZ
         /RTYcqQafmVokoMNcbvHG3hQKygCCJjbV9/2tRkGj8773QRXJrwFr7GrnMpI7jcIYbMG
         cPng==
X-Forwarded-Encrypted: i=1; AJvYcCXsyuPovalz6xw7P+AKm9xiVhG+S+ONIYuoYtW2e/8klX9oZQ3vuzLTfnZmqj4oF7Hk+Zg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6NX9CGLdhoiPR8DXm7BKWM8zRq487jajYD1R9zKalxvNqLH9N
	94jSEju1lDrnovTpN922GHRFEqYIIvr5qr0YM8Iv7wuJheMhev31eahIASxQYhFOQzSuUVFAnRF
	ecQ0g7w==
X-Google-Smtp-Source: AGHT+IFkOLtDvnmfFYHTTYDL9BHtdHKeC87WdwOUtI3zottIjGVbfKKCRYXtpOMrfk4Zl4Y9+LJbAonsrEw=
X-Received: from pjbfy7.prod.google.com ([2002:a17:90b:207:b0:340:9a17:4b10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3d8b:b0:339:cece:a99
 with SMTP id 98e67ed59e1d1-349a25104d4mr604889a91.13.1764983470345; Fri, 05
 Dec 2025 17:11:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:49 -0800
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-3-seanjc@google.com>
Subject: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement to kernel
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Move the innermost VMXON and EFER.SVME management logic out of KVM and
into to core x86 so that TDX can force VMXON without having to rely on
KVM being loaded, e.g. to do SEAMCALLs during initialization.

Implement a per-CPU refcounting scheme so that "users", e.g. KVM and the
future TDX code, can co-exist without pulling the rug out from under each
other.

To avoid having to choose between SVM and VMX, simply refuse to enable
either if both are somehow supported.  No known CPU supports both SVM and
VMX, and it's comically unlikely such a CPU will ever exist.

For lack of a better name, call the new file "hw.c", to yield "virt
hardware" when combined with its parent directory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/pt.c      |   1 -
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/include/asm/reboot.h   |  11 --
 arch/x86/include/asm/virt.h     |  26 +++
 arch/x86/include/asm/vmx.h      |  11 ++
 arch/x86/kernel/cpu/common.c    |   2 +
 arch/x86/kernel/crash.c         |   3 +-
 arch/x86/kernel/reboot.c        |  63 +-----
 arch/x86/kernel/smp.c           |   5 +-
 arch/x86/kvm/svm/svm.c          |  34 +---
 arch/x86/kvm/svm/vmenter.S      |  10 +-
 arch/x86/kvm/vmx/tdx.c          |   3 +-
 arch/x86/kvm/vmx/vmcs.h         |  11 --
 arch/x86/kvm/vmx/vmenter.S      |   2 +-
 arch/x86/kvm/vmx/vmx.c          | 127 +-----------
 arch/x86/kvm/x86.c              |  17 +-
 arch/x86/kvm/x86.h              |   1 -
 arch/x86/virt/Makefile          |   2 +
 arch/x86/virt/hw.c              | 340 ++++++++++++++++++++++++++++++++
 19 files changed, 422 insertions(+), 250 deletions(-)
 create mode 100644 arch/x86/include/asm/virt.h
 create mode 100644 arch/x86/virt/hw.c

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e8cf29d2b10c..9092f0f9de72 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1590,7 +1590,6 @@ void intel_pt_handle_vmx(int on)
 
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(intel_pt_handle_vmx);
 
 /*
  * PMU callbacks
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..47b535c1c3bd 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -40,7 +40,8 @@
 #include <asm/irq_remapping.h>
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
-#include <asm/reboot.h>
+#include <asm/virt.h>
+
 #include <hyperv/hvhdk.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index ecd58ea9a837..a671a1145906 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,17 +25,6 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
-typedef void (cpu_emergency_virt_cb)(void);
-#if IS_ENABLED(CONFIG_KVM_X86)
-void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
-void cpu_emergency_disable_virtualization(void);
-#else
-static inline void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback) {}
-static inline void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback) {}
-static inline void cpu_emergency_disable_virtualization(void) {}
-#endif /* CONFIG_KVM_X86 */
-
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
 void run_crash_ipi_callback(struct pt_regs *regs);
diff --git a/arch/x86/include/asm/virt.h b/arch/x86/include/asm/virt.h
new file mode 100644
index 000000000000..77a366afd9f7
--- /dev/null
+++ b/arch/x86/include/asm/virt.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_VIRT_H
+#define _ASM_X86_VIRT_H
+
+#include <asm/reboot.h>
+
+typedef void (cpu_emergency_virt_cb)(void);
+
+#if IS_ENABLED(CONFIG_KVM_X86)
+extern bool virt_rebooting;
+
+void __init x86_virt_init(void);
+
+int x86_virt_get_cpu(int feat);
+void x86_virt_put_cpu(int feat);
+
+int x86_virt_emergency_disable_virtualization_cpu(void);
+
+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback);
+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback);
+#else
+static __always_inline void x86_virt_init(void) {}
+static inline int x86_virt_emergency_disable_virtualization_cpu(void) { return -ENOENT; }
+#endif
+
+#endif /* _ASM_X86_VIRT_H */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..d2c7eb1c5f12 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,17 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+struct vmcs_hdr {
+	u32 revision_id:31;
+	u32 shadow_vmcs:1;
+};
+
+struct vmcs {
+	struct vmcs_hdr hdr;
+	u32 abort;
+	char data[];
+};
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 02d97834a1d4..a55cb572d2b4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -70,6 +70,7 @@
 #include <asm/traps.h>
 #include <asm/sev.h>
 #include <asm/tdx.h>
+#include <asm/virt.h>
 #include <asm/posted_intr.h>
 #include <asm/runtime-const.h>
 
@@ -2124,6 +2125,7 @@ static __init void identify_boot_cpu(void)
 	cpu_detect_tlb(&boot_cpu_data);
 	setup_cr_pinning();
 
+	x86_virt_init();
 	tsx_init();
 	tdx_init();
 	lkgs_init();
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 335fd2ee9766..cd796818d94d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -42,6 +42,7 @@
 #include <asm/crash.h>
 #include <asm/cmdline.h>
 #include <asm/sev.h>
+#include <asm/virt.h>
 
 /* Used while preparing memory map entries for second kernel */
 struct crash_memmap_data {
@@ -111,7 +112,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	crash_smp_send_stop();
 
-	cpu_emergency_disable_virtualization();
+	x86_virt_emergency_disable_virtualization_cpu();
 
 	/*
 	 * Disable Intel PT to stop its logging
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 964f6b0a3d68..0f1d14ed955b 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -26,6 +26,7 @@
 #include <asm/cpu.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
+#include <asm/virt.h>
 
 #include <linux/ctype.h>
 #include <linux/mc146818rtc.h>
@@ -531,51 +532,6 @@ static inline void kb_wait(void)
 static inline void nmi_shootdown_cpus_on_restart(void);
 
 #if IS_ENABLED(CONFIG_KVM_X86)
-/* RCU-protected callback to disable virtualization prior to reboot. */
-static cpu_emergency_virt_cb __rcu *cpu_emergency_virt_callback;
-
-void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback)))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
-
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
-
-/*
- * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
- * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
- * GIF=0, i.e. if the crash occurred between CLGI and STGI.
- */
-void cpu_emergency_disable_virtualization(void)
-{
-	cpu_emergency_virt_cb *callback;
-
-	/*
-	 * IRQs must be disabled as KVM enables virtualization in hardware via
-	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
-	 * virtualization stays disabled.
-	 */
-	lockdep_assert_irqs_disabled();
-
-	rcu_read_lock();
-	callback = rcu_dereference(cpu_emergency_virt_callback);
-	if (callback)
-		callback();
-	rcu_read_unlock();
-}
-
 static void emergency_reboot_disable_virtualization(void)
 {
 	local_irq_disable();
@@ -587,16 +543,11 @@ static void emergency_reboot_disable_virtualization(void)
 	 * We can't take any locks and we may be on an inconsistent state, so
 	 * use NMIs as IPIs to tell the other CPUs to disable VMX/SVM and halt.
 	 *
-	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
-	 * other CPUs may have virtualization enabled.
+	 * Safely force _this_ CPU out of VMX/SVM operation, and if necessary,
+	 * blast NMIs to force other CPUs out of VMX/SVM as well.k
 	 */
-	if (rcu_access_pointer(cpu_emergency_virt_callback)) {
-		/* Safely force _this_ CPU out of VMX/SVM operation. */
-		cpu_emergency_disable_virtualization();
-
-		/* Disable VMX/SVM and halt on other CPUs. */
+	if (!x86_virt_emergency_disable_virtualization_cpu())
 		nmi_shootdown_cpus_on_restart();
-	}
 }
 #else
 static void emergency_reboot_disable_virtualization(void) { }
@@ -874,10 +825,10 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 		shootdown_callback(cpu, regs);
 
 	/*
-	 * Prepare the CPU for reboot _after_ invoking the callback so that the
-	 * callback can safely use virtualization instructions, e.g. VMCLEAR.
+	 * Disable virtualization, as both VMX and SVM can block INIT and thus
+	 * prevent AP bringup, e.g. in a kdump kernel or in firmware.
 	 */
-	cpu_emergency_disable_virtualization();
+	x86_virt_emergency_disable_virtualization_cpu();
 
 	atomic_dec(&waiting_for_crash_ipi);
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b014e6d229f9..cbf95fe2b207 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -35,6 +35,7 @@
 #include <asm/trace/irq_vectors.h>
 #include <asm/kexec.h>
 #include <asm/reboot.h>
+#include <asm/virt.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -124,7 +125,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	cpu_emergency_disable_virtualization();
+	x86_virt_emergency_disable_virtualization_cpu();
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -136,7 +137,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 {
 	apic_eoi();
-	cpu_emergency_disable_virtualization();
+	x86_virt_emergency_disable_virtualization_cpu();
 	stop_this_cpu(NULL);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24d59ccfa40d..c09648cc3bd2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -44,6 +44,7 @@
 #include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/fpu/api.h>
+#include <asm/virt.h>
 
 #include <trace/events/ipi.h>
 
@@ -476,27 +477,9 @@ static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm
 	return &sd->save_area->host_sev_es_save;
 }
 
-static inline void kvm_cpu_svm_disable(void)
-{
-	uint64_t efer;
-
-	wrmsrq(MSR_VM_HSAVE_PA, 0);
-	rdmsrq(MSR_EFER, efer);
-	if (efer & EFER_SVME) {
-		/*
-		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
-		 * NMI aren't blocked.
-		 */
-		stgi();
-		wrmsrq(MSR_EFER, efer & ~EFER_SVME);
-	}
-}
-
 static void svm_emergency_disable_virtualization_cpu(void)
 {
-	kvm_rebooting = true;
-
-	kvm_cpu_svm_disable();
+	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
 static void svm_disable_virtualization_cpu(void)
@@ -505,7 +488,7 @@ static void svm_disable_virtualization_cpu(void)
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 
-	kvm_cpu_svm_disable();
+	x86_virt_put_cpu(X86_FEATURE_SVM);
 
 	amd_pmu_disable_virt();
 }
@@ -514,12 +497,12 @@ static int svm_enable_virtualization_cpu(void)
 {
 
 	struct svm_cpu_data *sd;
-	uint64_t efer;
 	int me = raw_smp_processor_id();
+	int r;
 
-	rdmsrq(MSR_EFER, efer);
-	if (efer & EFER_SVME)
-		return -EBUSY;
+	r = x86_virt_get_cpu(X86_FEATURE_SVM);
+	if (r)
+		return r;
 
 	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
@@ -527,8 +510,6 @@ static int svm_enable_virtualization_cpu(void)
 	sd->next_asid = sd->max_asid + 1;
 	sd->min_asid = max_sev_asid + 1;
 
-	wrmsrq(MSR_EFER, efer | EFER_SVME);
-
 	wrmsrq(MSR_VM_HSAVE_PA, sd->save_area_pa);
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
@@ -539,7 +520,6 @@ static int svm_enable_virtualization_cpu(void)
 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 	}
 
-
 	/*
 	 * Get OSVW bits.
 	 *
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 3392bcadfb89..d47c5c93c991 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -298,16 +298,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY (%_ASM_SP)
 
-10:	cmpb $0, _ASM_RIP(kvm_rebooting)
+10:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 2b
 	ud2
-30:	cmpb $0, _ASM_RIP(kvm_rebooting)
+30:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 4b
 	ud2
-50:	cmpb $0, _ASM_RIP(kvm_rebooting)
+50:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 6b
 	ud2
-70:	cmpb $0, _ASM_RIP(kvm_rebooting)
+70:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 8b
 	ud2
 
@@ -394,7 +394,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY %sil
 
-3:	cmpb $0, kvm_rebooting(%rip)
+3:	cmpb $0, virt_rebooting(%rip)
 	jne 2b
 	ud2
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..21e67a47ad4e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/mmu_context.h>
 #include <asm/tdx.h>
+#include <asm/virt.h>
 #include "capabilities.h"
 #include "mmu.h"
 #include "x86_ops.h"
@@ -1994,7 +1995,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
 	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
-		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
+		KVM_BUG_ON(!virt_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..2ab6ade006c7 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -13,17 +13,6 @@
 
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
 
-struct vmcs_hdr {
-	u32 revision_id:31;
-	u32 shadow_vmcs:1;
-};
-
-struct vmcs {
-	struct vmcs_hdr hdr;
-	u32 abort;
-	char data[];
-};
-
 DECLARE_PER_CPU(struct vmcs *, current_vmcs);
 
 /*
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 4426d34811fc..8a481dae9cae 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -310,7 +310,7 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 	RET
 
 .Lfixup:
-	cmpb $0, _ASM_RIP(kvm_rebooting)
+	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne .Lvmfail
 	ud2
 .Lvmfail:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..dd13bae22a1e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -48,6 +48,7 @@
 #include <asm/msr.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/virt.h>
 #include <asm/vmx.h>
 
 #include <trace/events/ipi.h>
@@ -577,7 +578,6 @@ noinline void invept_error(unsigned long ext, u64 eptp)
 	vmx_insn_failed("invept failed: ext=0x%lx eptp=%llx\n", ext, eptp);
 }
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
@@ -784,53 +784,17 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-/*
- * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
- *
- * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
- * atomically track post-VMXON state, e.g. this may be called in NMI context.
- * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
- * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
- * magically in RM, VM86, compat mode, or at CPL>0.
- */
-static int kvm_cpu_vmxoff(void)
-{
-	asm goto("1: vmxoff\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  ::: "cc", "memory" : fault);
-
-	cr4_clear_bits(X86_CR4_VMXE);
-	return 0;
-
-fault:
-	cr4_clear_bits(X86_CR4_VMXE);
-	return -EIO;
-}
-
 void vmx_emergency_disable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
-	kvm_rebooting = true;
-
-	/*
-	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
-	 * set in task context.  If this races with VMX is disabled by an NMI,
-	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
-	 * kvm_rebooting set.
-	 */
-	if (!(__read_cr4() & X86_CR4_VMXE))
-		return;
-
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link) {
 		vmcs_clear(v->vmcs);
 		if (v->shadow_vmcs)
 			vmcs_clear(v->shadow_vmcs);
 	}
-
-	kvm_cpu_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -2928,34 +2892,9 @@ int vmx_check_processor_compat(void)
 	return 0;
 }
 
-static int kvm_cpu_vmxon(u64 vmxon_pointer)
-{
-	u64 msr;
-
-	cr4_set_bits(X86_CR4_VMXE);
-
-	asm goto("1: vmxon %[vmxon_pointer]\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  : : [vmxon_pointer] "m"(vmxon_pointer)
-			  : : fault);
-	return 0;
-
-fault:
-	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
-		  rdmsrq_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
-	cr4_clear_bits(X86_CR4_VMXE);
-
-	return -EFAULT;
-}
-
 int vmx_enable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
-	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	int r;
-
-	if (cr4_read_shadow() & X86_CR4_VMXE)
-		return -EBUSY;
 
 	/*
 	 * This can happen if we hot-added a CPU but failed to allocate
@@ -2964,15 +2903,7 @@ int vmx_enable_virtualization_cpu(void)
 	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
-	intel_pt_handle_vmx(1);
-
-	r = kvm_cpu_vmxon(phys_addr);
-	if (r) {
-		intel_pt_handle_vmx(0);
-		return r;
-	}
-
-	return 0;
+	return x86_virt_get_cpu(X86_FEATURE_VMX);
 }
 
 static void vmclear_local_loaded_vmcss(void)
@@ -2989,12 +2920,9 @@ void vmx_disable_virtualization_cpu(void)
 {
 	vmclear_local_loaded_vmcss();
 
-	if (kvm_cpu_vmxoff())
-		kvm_spurious_fault();
+	x86_virt_put_cpu(X86_FEATURE_VMX);
 
 	hv_reset_evmcs();
-
-	intel_pt_handle_vmx(0);
 }
 
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
@@ -3072,47 +3000,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	return -ENOMEM;
 }
 
-static void free_kvm_area(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		free_vmcs(per_cpu(vmxarea, cpu));
-		per_cpu(vmxarea, cpu) = NULL;
-	}
-}
-
-static __init int alloc_kvm_area(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct vmcs *vmcs;
-
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
-		if (!vmcs) {
-			free_kvm_area();
-			return -ENOMEM;
-		}
-
-		/*
-		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
-		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
-		 * revision_id reported by MSR_IA32_VMX_BASIC.
-		 *
-		 * However, even though not explicitly documented by
-		 * TLFS, VMXArea passed as VMXON argument should
-		 * still be marked with revision_id reported by
-		 * physical CPU.
-		 */
-		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
-
-		per_cpu(vmxarea, cpu) = vmcs;
-	}
-	return 0;
-}
-
 static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		struct kvm_segment *save)
 {
@@ -8380,8 +8267,6 @@ void vmx_hardware_unsetup(void)
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
-
-	free_kvm_area();
 }
 
 void vmx_vm_destroy(struct kvm *kvm)
@@ -8686,10 +8571,6 @@ __init int vmx_hardware_setup(void)
 			return r;
 	}
 
-	r = alloc_kvm_area();
-	if (r && nested)
-		nested_vmx_hardware_unsetup();
-
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	/*
@@ -8715,7 +8596,7 @@ __init int vmx_hardware_setup(void)
 
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
-	return r;
+	return 0;
 }
 
 void vmx_exit(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80cb882f19e2..f650f79d3d5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -83,6 +83,8 @@
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
+#include <asm/virt.h>
+
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -694,9 +696,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
-
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
@@ -707,7 +706,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
 noinstr void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
-	BUG_ON(!kvm_rebooting);
+	BUG_ON(!virt_rebooting);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_spurious_fault);
 
@@ -12999,12 +12998,12 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_deliver_sipi_vector);
 
 void kvm_arch_enable_virtualization(void)
 {
-	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+	x86_virt_register_emergency_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
 }
 
 void kvm_arch_disable_virtualization(void)
 {
-	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+	x86_virt_unregister_emergency_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
 }
 
 int kvm_arch_enable_virtualization_cpu(void)
@@ -13106,11 +13105,11 @@ int kvm_arch_enable_virtualization_cpu(void)
 void kvm_arch_shutdown(void)
 {
 	/*
-	 * Set kvm_rebooting to indicate that KVM has asynchronously disabled
+	 * Set virt_rebooting to indicate that KVM has asynchronously disabled
 	 * hardware virtualization, i.e. that relevant errors and exceptions
 	 * aren't entirely unexpected.
 	 */
-	kvm_rebooting = true;
+	virt_rebooting = true;
 }
 
 void kvm_arch_disable_virtualization_cpu(void)
@@ -13127,7 +13126,7 @@ void kvm_arch_disable_virtualization_cpu(void)
 	 * disable virtualization arrives.  Handle the extreme edge case here
 	 * instead of trying to account for it in the normal flows.
 	 */
-	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
+	if (in_task() || WARN_ON_ONCE(!virt_rebooting))
 		drop_user_return_notifiers();
 	else
 		__module_get(THIS_MODULE);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 40993348a967..fdab0ad49098 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -54,7 +54,6 @@ struct kvm_host_values {
 	u64 arch_capabilities;
 };
 
-extern bool kvm_rebooting;
 void kvm_spurious_fault(void);
 
 #define SIZE_OF_MEMSLOTS_HASHTABLE \
diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
index ea343fc392dc..6e485751650c 100644
--- a/arch/x86/virt/Makefile
+++ b/arch/x86/virt/Makefile
@@ -1,2 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y	+= svm/ vmx/
+
+obj-$(subst m,y,$(CONFIG_KVM_X86)) += hw.o
\ No newline at end of file
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
new file mode 100644
index 000000000000..986e780cf438
--- /dev/null
+++ b/arch/x86/virt/hw.c
@@ -0,0 +1,340 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
+#include <linux/kvm_types.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+
+#include <asm/perf_event.h>
+#include <asm/processor.h>
+#include <asm/virt.h>
+#include <asm/vmx.h>
+
+static int x86_virt_feature __ro_after_init;
+
+__visible bool virt_rebooting;
+EXPORT_SYMBOL_GPL(virt_rebooting);
+
+static DEFINE_PER_CPU(int, virtualization_nr_users);
+
+static cpu_emergency_virt_cb __rcu *kvm_emergency_callback;
+
+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(kvm_emergency_callback)))
+		return;
+
+	rcu_assign_pointer(kvm_emergency_callback, callback);
+}
+EXPORT_SYMBOL_FOR_MODULES(x86_virt_register_emergency_callback, "kvm");
+
+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(kvm_emergency_callback) != callback))
+		return;
+
+	rcu_assign_pointer(kvm_emergency_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_FOR_MODULES(x86_virt_unregister_emergency_callback, "kvm");
+
+static void x86_virt_invoke_kvm_emergency_callback(void)
+{
+	cpu_emergency_virt_cb *kvm_callback;
+
+	kvm_callback = rcu_dereference(kvm_emergency_callback);
+	if (kvm_callback)
+		kvm_callback();
+}
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+static DEFINE_PER_CPU(struct vmcs *, root_vmcs);
+
+static int x86_virt_cpu_vmxon(void)
+{
+	u64 vmxon_pointer = __pa(per_cpu(root_vmcs, raw_smp_processor_id()));
+	u64 msr;
+
+	cr4_set_bits(X86_CR4_VMXE);
+
+	asm goto("1: vmxon %[vmxon_pointer]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : [vmxon_pointer] "m"(vmxon_pointer)
+			  : : fault);
+	return 0;
+
+fault:
+	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
+		  rdmsrq_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
+	cr4_clear_bits(X86_CR4_VMXE);
+
+	return -EFAULT;
+}
+
+static int x86_vmx_get_cpu(void)
+{
+	int r;
+
+	if (cr4_read_shadow() & X86_CR4_VMXE)
+		return -EBUSY;
+
+	intel_pt_handle_vmx(1);
+
+	r = x86_virt_cpu_vmxon();
+	if (r) {
+		intel_pt_handle_vmx(0);
+		return r;
+	}
+
+	return 0;
+}
+
+/*
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
+ */
+static int x86_vmx_put_cpu(void)
+{
+	int r = -EIO;
+
+	asm goto("1: vmxoff\n\t"
+		 _ASM_EXTABLE(1b, %l[fault])
+		 ::: "cc", "memory" : fault);
+	r = 0;
+
+fault:
+	cr4_clear_bits(X86_CR4_VMXE);
+	intel_pt_handle_vmx(0);
+	return r;
+}
+
+static int x86_vmx_emergency_disable_virtualization_cpu(void)
+{
+	virt_rebooting = true;
+
+	/*
+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
+	 * set in task context.  If this races with VMX being disabled via NMI,
+	 * VMCLEAR and VMXOFF may #UD, but the kernel will eat those faults due
+	 * to virt_rebooting being set.
+	 */
+	if (!(__read_cr4() & X86_CR4_VMXE))
+		return -ENOENT;
+
+	x86_virt_invoke_kvm_emergency_callback();
+
+	x86_vmx_put_cpu();
+	return 0;
+}
+
+static __init void x86_vmx_exit(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		free_page((unsigned long)per_cpu(root_vmcs, cpu));
+		per_cpu(root_vmcs, cpu) = NULL;
+	}
+}
+
+static __init int x86_vmx_init(void)
+{
+	u64 basic_msr;
+	u32 rev_id;
+	int cpu;
+
+	if (!cpu_feature_enabled(X86_FEATURE_VMX))
+		return -EOPNOTSUPP;
+
+	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+
+	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
+	if (WARN_ON_ONCE(vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE))
+		return -EIO;
+
+	/*
+	 * Even if eVMCS is enabled (or will be enabled?), and even though not
+	 * explicitly documented by TLFS, the root VMCS  passed to VMXON should
+	 * still be marked with the revision_id reported by the physical CPU.
+	 */
+	rev_id = vmx_basic_vmcs_revision_id(basic_msr);
+
+	for_each_possible_cpu(cpu) {
+		int node = cpu_to_node(cpu);
+		struct page *page;
+		struct vmcs *vmcs;
+
+		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO , 0);
+		if (!page) {
+			x86_vmx_exit();
+			return -ENOMEM;
+		}
+
+		vmcs = page_address(page);
+		vmcs->hdr.revision_id = rev_id;
+		per_cpu(root_vmcs, cpu) = vmcs;
+	}
+
+	return 0;
+}
+#else
+static int x86_vmx_get_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static int x86_vmx_put_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static int x86_vmx_emergency_disable_virtualization_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static __init int x86_vmx_init(void) { return -EOPNOTSUPP; }
+#endif
+
+#if IS_ENABLED(CONFIG_KVM_AMD)
+static int x86_svm_get_cpu(void)
+{
+	u64 efer;
+
+	rdmsrq(MSR_EFER, efer);
+	if (efer & EFER_SVME)
+		return -EBUSY;
+
+	wrmsrq(MSR_EFER, efer | EFER_SVME);
+	return 0;
+}
+
+static int x86_svm_put_cpu(void)
+{
+	int r = -EIO;
+	u64 efer;
+
+	/*
+	 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
+	 * NMI aren't blocked.
+	 */
+	asm goto("1: stgi\n\t"
+		 _ASM_EXTABLE(1b, %l[fault])
+		 ::: "memory" : fault);
+	r = 0;
+
+fault:
+	rdmsrq(MSR_EFER, efer);
+	wrmsrq(MSR_EFER, efer & ~EFER_SVME);
+	return r;
+}
+
+static int x86_svm_emergency_disable_virtualization_cpu(void)
+{
+	u64 efer;
+
+	virt_rebooting = true;
+
+	rdmsrq(MSR_EFER, efer);
+	if (!(efer & EFER_SVME))
+		return -ENOENT;
+
+	x86_virt_invoke_kvm_emergency_callback();
+
+	return x86_svm_put_cpu();
+}
+
+static __init int x86_svm_init(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_SVM))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+#else
+static int x86_svm_get_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static int x86_svm_put_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static int x86_svm_emergency_disable_virtualization_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static __init int x86_svm_init(void) { return -EOPNOTSUPP; }
+#endif
+
+#define x86_virt_call(fn)				\
+({							\
+	int __r;					\
+							\
+	if (IS_ENABLED(CONFIG_KVM_INTEL) &&		\
+	    cpu_feature_enabled(X86_FEATURE_VMX))	\
+		__r = x86_vmx_##fn();			\
+	else if (IS_ENABLED(CONFIG_KVM_AMD) &&		\
+		 cpu_feature_enabled(X86_FEATURE_SVM))	\
+		__r = x86_svm_##fn();			\
+	else						\
+		__r = -EOPNOTSUPP;			\
+							\
+	__r;						\
+})
+
+int x86_virt_get_cpu(int feat)
+{
+	int r;
+
+	if (!x86_virt_feature || x86_virt_feature != feat)
+		return -EOPNOTSUPP;
+
+	if (this_cpu_inc_return(virtualization_nr_users) > 1)
+		return 0;
+
+	r = x86_virt_call(get_cpu);
+	if (r)
+		WARN_ON_ONCE(this_cpu_dec_return(virtualization_nr_users));
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(x86_virt_get_cpu);
+
+void x86_virt_put_cpu(int feat)
+{
+	if (WARN_ON_ONCE(!this_cpu_read(virtualization_nr_users)) ||
+	    this_cpu_dec_return(virtualization_nr_users))
+		return;
+
+	BUG_ON(x86_virt_call(put_cpu) && !virt_rebooting);
+}
+EXPORT_SYMBOL_GPL(x86_virt_put_cpu);
+
+/*
+ * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
+ * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
+ * GIF=0, i.e. if the crash occurred between CLGI and STGI.
+ */
+int x86_virt_emergency_disable_virtualization_cpu(void)
+{
+	if (!x86_virt_feature)
+		return -EOPNOTSUPP;
+
+	/*
+	 * IRQs must be disabled as virtualization is enabled in hardware via
+	 * function call IPIs, i.e. IRQs need to be disabled to guarantee
+	 * virtualization stays disabled.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
+	 * other CPUs may have virtualization enabled.
+	 *
+	 * TODO: Track whether or not virtualization might be enabled on other
+	 *	 CPUs?  May not be worth avoiding the NMI shootdown...
+	 */
+	(void)x86_virt_call(emergency_disable_virtualization_cpu);
+	return 0;
+}
+
+void __init x86_virt_init(void)
+{
+	bool is_vmx = !x86_vmx_init();
+	bool is_svm = !x86_svm_init();
+
+	if (!is_vmx && !is_svm)
+		return;
+
+	if (WARN_ON_ONCE(is_vmx && is_svm))
+		return;
+
+	x86_virt_feature = is_vmx ? X86_FEATURE_VMX : X86_FEATURE_SVM;
+}
-- 
2.52.0.223.gf5cc29aaa4-goog


