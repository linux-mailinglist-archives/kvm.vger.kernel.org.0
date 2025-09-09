Return-Path: <kvm+bounces-57128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DF4B5055C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 454A21C67768
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4237B369977;
	Tue,  9 Sep 2025 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="LeD1FJs0"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3826D35CED7;
	Tue,  9 Sep 2025 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442676; cv=none; b=fHCg3rISJ4YFhyV/K1JUEPHb2j2My9IPhtOAjKScYQmY1k1d8ENvNuogZoSEdiuXroaJu0JCg7TLqPvjk0a1kZbORVp6Gj+Kw6jj0KIFxqVZvQQCCsuUpCwB/Pc6TxdvAbNVnmDGcZtHGRxWzEHHSGjl7hZMQCeYDee0e6I/14U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442676; c=relaxed/simple;
	bh=eG2woZ+kFwRQ0XwCkPjEmZrtbRPZheKNNf6fBdX4ihU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVYBS3+GWMK0wQyY89pI6bbDg6sJQuOGhVwROWLS1OSOsZoBIuQqOYhB28HFZWg58Thqng4nj9VjwC52c9NDiB6MZ6VA6l8Lqg4743JIMY1crpFNDKegDbHD64wlJ9UsAVPjGCfi3lERuPpokBEoIDAg3InIHzSkvBcpbc+dpyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=LeD1FJs0; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589ISSD31542432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 11:28:37 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589ISSD31542432
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757442518;
	bh=/0xrBFM9KuTP0Yc5xMbS29+JMSoGkR58rrbqJHNfId0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeD1FJs0lSm2tkwyEFw+xjRSeHHFvuTxIAiydqm7a/vI1JPPn+apsJHqtwyQhzRtx
	 ahoAUb1I+msNYPymCZk3UDyW2fT0ZdxN6qO7JM4cfl2FgPQtbCQH5Y9lIPoMMlGfAK
	 PHRTsZks9I/HC0NIdKCNGdSQhc8fdXIbyjuLbHK8v2SPoOH9iMh8nRkM5ffuoQ/GPP
	 GIMHZWwap9ubhWZ2kHHQPmpXcHt+5C8dCQtCQZ6R5hfljBJ/oJ+yQLbSz904dpWx9Z
	 8qglf9FyRAitIKg5FdI5IYGZwnA24sRQCrNEF7sN8kAJdsrAurLNDJKClB+61fbYwe
	 2kSTQeUMe+ppA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, rafael@kernel.org, pavel@kernel.org,
        brgerst@gmail.com, xin@zytor.com, david.kaplan@amd.com,
        peterz@infradead.org, andrew.cooper3@citrix.com,
        kprateek.nayak@amd.com, arjan@linux.intel.com, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, dan.j.williams@intel.com
Subject: [RFC PATCH v1 4/5] x86/reboot: Remove emergency_reboot_disable_virtualization()
Date: Tue,  9 Sep 2025 11:28:24 -0700
Message-ID: <20250909182828.1542362-5-xin@zytor.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909182828.1542362-1-xin@zytor.com>
References: <20250909182828.1542362-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove emergency_reboot_disable_virtualization() now that virtualization
is disabled after the CPU shuts down its local APIC and just before it
powers off.

Also remove kvm_arch_{enable,disable}_virtualization() as they are no
longer needed.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/include/asm/reboot.h   | 11 -----
 arch/x86/kernel/reboot.c        | 72 ---------------------------------
 arch/x86/kvm/svm/svm.c          |  8 ----
 arch/x86/kvm/vmx/main.c         |  1 -
 arch/x86/kvm/vmx/vmx.c          |  4 --
 arch/x86/kvm/x86.c              | 10 -----
 include/linux/kvm_host.h        |  8 ----
 virt/kvm/kvm_main.c             | 14 -------
 9 files changed, 129 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..131cd3dfae35 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1697,7 +1697,6 @@ struct kvm_x86_ops {
 
 	int (*enable_virtualization_cpu)(void);
 	void (*disable_virtualization_cpu)(void);
-	cpu_emergency_virt_cb *emergency_disable_virtualization_cpu;
 
 	void (*hardware_unsetup)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
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
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d8c3e2d8481f..0916dd0ca86f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -530,78 +530,6 @@ static inline void kb_wait(void)
 
 static inline void nmi_shootdown_cpus_on_restart(void);
 
-#if IS_ENABLED(CONFIG_KVM_X86)
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
-static void emergency_reboot_disable_virtualization(void)
-{
-	local_irq_disable();
-
-	/*
-	 * Disable virtualization on all CPUs before rebooting to avoid hanging
-	 * the system, as VMX and SVM block INIT when running in the host.
-	 *
-	 * We can't take any locks and we may be on an inconsistent state, so
-	 * use NMIs as IPIs to tell the other CPUs to disable VMX/SVM and halt.
-	 *
-	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
-	 * other CPUs may have virtualization enabled.
-	 */
-	if (rcu_access_pointer(cpu_emergency_virt_callback)) {
-		/* Safely force _this_ CPU out of VMX/SVM operation. */
-		cpu_emergency_disable_virtualization();
-
-		/* Disable VMX/SVM and halt on other CPUs. */
-		nmi_shootdown_cpus_on_restart();
-	}
-}
-#else
-static void emergency_reboot_disable_virtualization(void) { }
-#endif /* CONFIG_KVM_X86 */
-
 void __attribute__((weak)) mach_reboot_fixups(void)
 {
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d9931c6c4bc6..795e5961c1d9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -497,13 +497,6 @@ static inline void kvm_cpu_svm_disable(void)
 	}
 }
 
-static void svm_emergency_disable_virtualization_cpu(void)
-{
-	kvm_rebooting = true;
-
-	kvm_cpu_svm_disable();
-}
-
 static void svm_disable_virtualization_cpu(void)
 {
 	/* Make sure we clean up behind us */
@@ -5050,7 +5043,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.hardware_unsetup = svm_hardware_unsetup,
 	.enable_virtualization_cpu = svm_enable_virtualization_cpu,
 	.disable_virtualization_cpu = svm_disable_virtualization_cpu,
-	.emergency_disable_virtualization_cpu = svm_emergency_disable_virtualization_cpu,
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.vcpu_create = svm_vcpu_create,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..ce46b80368c9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -864,7 +864,6 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
 	.disable_virtualization_cpu = vt_op(disable_virtualization_cpu),
-	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
 
 	.has_emulated_msr = vt_op(has_emulated_msr),
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b033288e645a..fdb9bc19f037 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -669,10 +669,6 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-void vmx_emergency_disable_virtualization_cpu(void)
-{
-}
-
 static void __loaded_vmcs_clear(void *arg)
 {
 	struct loaded_vmcs *loaded_vmcs = arg;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 604490b1cb19..8b9f64770684 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12543,16 +12543,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-void kvm_arch_enable_virtualization(void)
-{
-	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
-}
-
-void kvm_arch_disable_virtualization(void)
-{
-	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
-}
-
 int kvm_arch_enable_virtualization_cpu(void)
 {
 	struct kvm *kvm;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..151305b33bce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1603,14 +1603,6 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-/*
- * kvm_arch_{enable,disable}_virtualization() are called on one CPU, under
- * kvm_usage_lock, immediately after/before 0=>1 and 1=>0 transitions of
- * kvm_usage_count, i.e. at the beginning of the generic hardware enabling
- * sequence, and at the end of the generic hardware disabling sequence.
- */
-void kvm_arch_enable_virtualization(void);
-void kvm_arch_disable_virtualization(void);
 /*
  * kvm_arch_{enable,disable}_virtualization_cpu() are called on "every" CPU to
  * do the actual twiddling of hardware bits.  The hooks are called on all
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..6e86c6a45a71 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5566,16 +5566,6 @@ static DEFINE_PER_CPU(bool, virtualization_enabled);
 static DEFINE_MUTEX(kvm_usage_lock);
 static int kvm_usage_count;
 
-__weak void kvm_arch_enable_virtualization(void)
-{
-
-}
-
-__weak void kvm_arch_disable_virtualization(void)
-{
-
-}
-
 static int kvm_enable_virtualization_cpu(void)
 {
 	if (__this_cpu_read(virtualization_enabled))
@@ -5675,8 +5665,6 @@ int kvm_enable_virtualization(void)
 	if (kvm_usage_count++)
 		return 0;
 
-	kvm_arch_enable_virtualization();
-
 	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
 			      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
@@ -5707,7 +5695,6 @@ int kvm_enable_virtualization(void)
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 err_cpuhp:
-	kvm_arch_disable_virtualization();
 	--kvm_usage_count;
 	return r;
 }
@@ -5722,7 +5709,6 @@ void kvm_disable_virtualization(void)
 
 	unregister_syscore_ops(&kvm_syscore_ops);
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
-	kvm_arch_disable_virtualization();
 }
 EXPORT_SYMBOL_GPL(kvm_disable_virtualization);
 
-- 
2.51.0


