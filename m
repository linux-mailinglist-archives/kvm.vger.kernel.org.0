Return-Path: <kvm+bounces-71089-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uL5KB3zQj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71089-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B391313AB1E
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A267A3049272
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C9562C11D9;
	Sat, 14 Feb 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TsohMgjg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE5529BDA2
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032445; cv=none; b=SKUmVu0uK23RFTpWulBlI870fyoAci43DRm0csb6KHNAH7BmpR+bZCZY/fv06bZVDxwAqfGAzZAdajOjJzKkuuYErYbtK4INVfDxvnHvWxydxQKD6N+fkiAPA1yS33R0mPNve9Nn+TbIdyFGiY+lmaj6OnwZMFxUsM8T0dDiJvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032445; c=relaxed/simple;
	bh=SFe9wm1PDAKjnrht0sUarAMichPsYfPk0uBQoi5Ozw8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PqBaXiASD9TNplD4tsBY22mX1Yh3Cyw1unn3/mwcniO/jbrMbrCJ2xE3Rzc6y44yRRe8RL93eicdLMRVkuyAHM3pvD90/sLikR3vKrL5vAhYXJkLqMnndL4ONyHLSQmauV2Ae29s0xYjcWk44Zv9T+Blztsb7T2Vun96WQ+8s3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TsohMgjg; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6187bdadcdso857259a12.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032440; x=1771637240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=fTHOLr69ZvJgSZJU6aztcC4yMSqOUAaHLuJiMpybd6M=;
        b=TsohMgjg/irXT9teRZy5VoNBF85tgLXek+PiI0IYA/gtky3LWIBOoJs7qSZnM5xXVF
         +EzqZaNwbnQkgktOgSqttSCGomMVPmnEjl/QUc0TcVdgKTk0QnbYsnwEr5wMyB5GiPOu
         6f9KMSzp2pUUJapyb8hB9LQKfD9zZEMCIjwEfpsLbCyKOMuSouS2EP+e93NK6QK1SqUS
         58f+kofO3ThNJqH6ProNKMdCw8PyWxyRHmdeqHrYOFQfVAA4rQwqSWsrWHcxU4fxGSA+
         5WzmjuHUZ4WmCLYijc6V4xBEKKy8O5qAI/cp85n/Hss/ir+A0y9u3OmKu9NE8ZSLJimA
         rQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032440; x=1771637240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTHOLr69ZvJgSZJU6aztcC4yMSqOUAaHLuJiMpybd6M=;
        b=i8B2fcqiISYztX68Htj1akY9SGkuWpn//RBEa+iAStvyPzUyytBcbva2hQyLtOZqLi
         VwToWEPJBKGU+/R8WdB/ieIgQG5kxGwYgYNX+gjeYB8jsH1A8svBPbPGqnIInJJRLyZW
         PtJNSR1EcuRBoyp0z7apc8yLx2TizyQ1xxt5oLyoZT0tNyde6kvw32On/OYNiv+1g4Ct
         JeCh4gTY7NSjMIJWKdY9ehGFbj7J3JpSjSy6mCMq8CYr7HZN0TvFg5eCz0SQtcYm7P+w
         EN5B7S5jvn5S6OSArAxkqgQ6Shv3QrUax76GZrVOmkl7qeIPyVqga9ddZA+OdLEo3DVf
         8dxQ==
X-Forwarded-Encrypted: i=1; AJvYcCV187CsMap7nk4PHNVYgtPz07Lh0o6B86KWPlddhg75js3TAGkyHUuxNmwUV81zOm0OVMo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6AoaLjWd1rEAw9zEmyb2Id/26TulJ19sTFvym7bzJiCOzhjXO
	OVpKsGIYLvEtOrG8tnu2MpUd7IuCe/7+2NtnMqT6dA76geXsBUeHBjmZ7zEAE6w9F3MaETpTZVA
	HRNlEIw==
X-Received: from pgcb65.prod.google.com ([2002:a63:6744:0:b0:c6e:260e:bff2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6009:b0:366:581e:19f6
 with SMTP id adf61e73a8af0-3946c812d7emr3447834637.23.1771032439905; Fri, 13
 Feb 2026 17:27:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:54 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-9-seanjc@google.com>
Subject: [PATCH v3 08/16] KVM: x86: Move bulk of emergency virtualizaton logic
 to virt subsystem
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71089-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: B391313AB1E
X-Rspamd-Action: no action

Move the majority of the code related to disabling hardware virtualization
in emergency from KVM into the virt subsystem so that virt can take full
ownership of the state of SVM/VMX.  This will allow refcounting usage of
SVM/VMX so that KVM and the TDX subsystem can enable VMX without stomping
on each other.

To route the emergency callback to the "right" vendor code, add to avoid
mixing vendor and generic code, implement a x86_virt_ops structure to
track the emergency callback, along with the SVM vs. VMX (vs. "none")
feature that is active.

To avoid having to choose between SVM and VMX, simply refuse to enable
either if both are somehow supported.  No known CPU supports both SVM and
VMX, and it's comically unlikely such a CPU will ever exist.

Leave KVM's clearing of loaded VMCSes and MSR_VM_HSAVE_PA in KVM, via a
callback explicitly scoped to KVM.  Loading VMCSes and saving/restoring
host state are firmly tied to running VMs, and thus are (a) KVM's
responsibility and (b) operations that are still exclusively reserved for
KVM (as far as in-tree code is concerned).  I.e. the contract being
established is that non-KVM subsystems can utilize virtualization, but for
all intents and purposes cannot act as full-blown hypervisors.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |   3 +-
 arch/x86/include/asm/reboot.h   |  11 ---
 arch/x86/include/asm/virt.h     |   9 ++-
 arch/x86/kernel/crash.c         |   3 +-
 arch/x86/kernel/reboot.c        |  63 ++--------------
 arch/x86/kernel/smp.c           |   5 +-
 arch/x86/kvm/vmx/vmx.c          |  11 ---
 arch/x86/kvm/x86.c              |   4 +-
 arch/x86/virt/hw.c              | 123 +++++++++++++++++++++++++++++---
 9 files changed, 138 insertions(+), 94 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff07c45e3c73..0bda52fbcae5 100644
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
index 9a0753eaa20c..2c35534437e0 100644
--- a/arch/x86/include/asm/virt.h
+++ b/arch/x86/include/asm/virt.h
@@ -4,6 +4,8 @@
 
 #include <asm/reboot.h>
 
+typedef void (cpu_emergency_virt_cb)(void);
+
 #if IS_ENABLED(CONFIG_KVM_X86)
 extern bool virt_rebooting;
 
@@ -12,17 +14,20 @@ void __init x86_virt_init(void);
 #if IS_ENABLED(CONFIG_KVM_INTEL)
 int x86_vmx_enable_virtualization_cpu(void);
 int x86_vmx_disable_virtualization_cpu(void);
-void x86_vmx_emergency_disable_virtualization_cpu(void);
 #endif
 
 #if IS_ENABLED(CONFIG_KVM_AMD)
 int x86_svm_enable_virtualization_cpu(void);
 int x86_svm_disable_virtualization_cpu(void);
-void x86_svm_emergency_disable_virtualization_cpu(void);
 #endif
 
+int x86_virt_emergency_disable_virtualization_cpu(void);
+
+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback);
+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback);
 #else
 static __always_inline void x86_virt_init(void) {}
+static inline int x86_virt_emergency_disable_virtualization_cpu(void) { return -ENOENT; }
 #endif
 
 #endif /* _ASM_X86_VIRT_H */
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
index 6032fa9ec753..0bab8863375a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -27,6 +27,7 @@
 #include <asm/cpu.h>
 #include <asm/nmi.h>
 #include <asm/smp.h>
+#include <asm/virt.h>
 
 #include <linux/ctype.h>
 #include <linux/mc146818rtc.h>
@@ -532,51 +533,6 @@ static inline void kb_wait(void)
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
-EXPORT_SYMBOL_FOR_KVM(cpu_emergency_register_virt_callback);
-
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_FOR_KVM(cpu_emergency_unregister_virt_callback);
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
@@ -588,16 +544,11 @@ static void emergency_reboot_disable_virtualization(void)
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
@@ -875,10 +826,10 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
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
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 36238cc694fd..c02fd7e91809 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -791,23 +791,12 @@ void vmx_emergency_disable_virtualization_cpu(void)
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
-	/*
-	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
-	 * set in task context.  If this races with _another_ emergency call
-	 * from NMI context, VMCLEAR may #UD, but KVM will eat those faults due
-	 * to virt_rebooting being set by the interrupting NMI callback.
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
-	x86_vmx_emergency_disable_virtualization_cpu();
 }
 
 static void __loaded_vmcs_clear(void *arg)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69937d14f5e1..4f30acd639f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13076,12 +13076,12 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_deliver_sipi_vector);
 
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
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index 014e9dfab805..73c8309ba3fb 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -11,9 +11,45 @@
 #include <asm/virt.h>
 #include <asm/vmx.h>
 
+struct x86_virt_ops {
+	int feature;
+	void (*emergency_disable_virtualization_cpu)(void);
+};
+static struct x86_virt_ops virt_ops __ro_after_init;
+
 __visible bool virt_rebooting;
 EXPORT_SYMBOL_FOR_KVM(virt_rebooting);
 
+static cpu_emergency_virt_cb __rcu *kvm_emergency_callback;
+
+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(kvm_emergency_callback)))
+		return;
+
+	rcu_assign_pointer(kvm_emergency_callback, callback);
+}
+EXPORT_SYMBOL_FOR_KVM(x86_virt_register_emergency_callback);
+
+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(kvm_emergency_callback) != callback))
+		return;
+
+	rcu_assign_pointer(kvm_emergency_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_FOR_KVM(x86_virt_unregister_emergency_callback);
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
 #if IS_ENABLED(CONFIG_KVM_INTEL)
 static DEFINE_PER_CPU(struct vmcs *, root_vmcs);
 
@@ -42,6 +78,9 @@ int x86_vmx_enable_virtualization_cpu(void)
 {
 	int r;
 
+	if (virt_ops.feature != X86_FEATURE_VMX)
+		return -EOPNOTSUPP;
+
 	if (cr4_read_shadow() & X86_CR4_VMXE)
 		return -EBUSY;
 
@@ -82,22 +121,24 @@ int x86_vmx_disable_virtualization_cpu(void)
 }
 EXPORT_SYMBOL_FOR_KVM(x86_vmx_disable_virtualization_cpu);
 
-void x86_vmx_emergency_disable_virtualization_cpu(void)
+static void x86_vmx_emergency_disable_virtualization_cpu(void)
 {
 	virt_rebooting = true;
 
 	/*
 	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
 	 * set in task context.  If this races with _another_ emergency call
-	 * from NMI context, VMXOFF may #UD, but kernel will eat those faults
-	 * due to virt_rebooting being set by the interrupting NMI callback.
+	 * from NMI context, VMCLEAR (in KVM) and VMXOFF may #UD, but KVM and
+	 * the kernel will eat those faults due to virt_rebooting being set by
+	 * the interrupting NMI callback.
 	 */
 	if (!(__read_cr4() & X86_CR4_VMXE))
 		return;
 
+	x86_virt_invoke_kvm_emergency_callback();
+
 	x86_vmx_disable_virtualization_cpu();
 }
-EXPORT_SYMBOL_FOR_KVM(x86_vmx_emergency_disable_virtualization_cpu);
 
 static __init void x86_vmx_exit(void)
 {
@@ -111,6 +152,11 @@ static __init void x86_vmx_exit(void)
 
 static __init int __x86_vmx_init(void)
 {
+	const struct x86_virt_ops vmx_ops = {
+		.feature = X86_FEATURE_VMX,
+		.emergency_disable_virtualization_cpu = x86_vmx_emergency_disable_virtualization_cpu,
+	};
+
 	u64 basic_msr;
 	u32 rev_id;
 	int cpu;
@@ -147,6 +193,7 @@ static __init int __x86_vmx_init(void)
 		per_cpu(root_vmcs, cpu) = vmcs;
 	}
 
+	memcpy(&virt_ops, &vmx_ops, sizeof(virt_ops));
 	return 0;
 }
 
@@ -161,6 +208,7 @@ static __init int x86_vmx_init(void)
 }
 #else
 static __init int x86_vmx_init(void) { return -EOPNOTSUPP; }
+static __init void x86_vmx_exit(void) { }
 #endif
 
 #if IS_ENABLED(CONFIG_KVM_AMD)
@@ -168,7 +216,7 @@ int x86_svm_enable_virtualization_cpu(void)
 {
 	u64 efer;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SVM))
+	if (virt_ops.feature != X86_FEATURE_SVM)
 		return -EOPNOTSUPP;
 
 	rdmsrq(MSR_EFER, efer);
@@ -201,7 +249,7 @@ int x86_svm_disable_virtualization_cpu(void)
 }
 EXPORT_SYMBOL_FOR_KVM(x86_svm_disable_virtualization_cpu);
 
-void x86_svm_emergency_disable_virtualization_cpu(void)
+static void x86_svm_emergency_disable_virtualization_cpu(void)
 {
 	u64 efer;
 
@@ -211,12 +259,71 @@ void x86_svm_emergency_disable_virtualization_cpu(void)
 	if (!(efer & EFER_SVME))
 		return;
 
+	x86_virt_invoke_kvm_emergency_callback();
+
 	x86_svm_disable_virtualization_cpu();
 }
-EXPORT_SYMBOL_FOR_KVM(x86_svm_emergency_disable_virtualization_cpu);
+
+static __init int x86_svm_init(void)
+{
+	const struct x86_virt_ops svm_ops = {
+		.feature = X86_FEATURE_SVM,
+		.emergency_disable_virtualization_cpu = x86_svm_emergency_disable_virtualization_cpu,
+	};
+
+	if (!cpu_feature_enabled(X86_FEATURE_SVM))
+		return -EOPNOTSUPP;
+
+	memcpy(&virt_ops, &svm_ops, sizeof(virt_ops));
+	return 0;
+}
+#else
+static __init int x86_svm_init(void) { return -EOPNOTSUPP; }
 #endif
 
+/*
+ * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
+ * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
+ * GIF=0, i.e. if the crash occurred between CLGI and STGI.
+ */
+int x86_virt_emergency_disable_virtualization_cpu(void)
+{
+	/* Ensure the !feature check can't get false positives. */
+	BUILD_BUG_ON(!X86_FEATURE_SVM || !X86_FEATURE_VMX);
+
+	if (!virt_ops.feature)
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
+	virt_ops.emergency_disable_virtualization_cpu();
+	return 0;
+}
+
 void __init x86_virt_init(void)
 {
-	x86_vmx_init();
+	/*
+	 * Attempt to initialize both SVM and VMX, and simply use whichever one
+	 * is present.  Rsefuse to enable/use SVM or VMX if both are somehow
+	 * supported.  No known CPU supports both SVM and VMX.
+	 */
+	bool has_vmx = !x86_vmx_init();
+	bool has_svm = !x86_svm_init();
+
+	if (WARN_ON_ONCE(has_vmx && has_svm)) {
+		x86_vmx_exit();
+		memset(&virt_ops, 0, sizeof(virt_ops));
+	}
 }
-- 
2.53.0.310.g728cabbaf7-goog


