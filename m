Return-Path: <kvm+bounces-57126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EECCB50557
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:33:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A924A16EEAE
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBBF36209C;
	Tue,  9 Sep 2025 18:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="AgQtQoNs"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9408315D36;
	Tue,  9 Sep 2025 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442672; cv=none; b=owJURECSWCsDWRE0klyyK6necAMqQf4gzAK58hhzvoQku2mAML7jUfSAMBeNwh/pSLANfQgBbk3sqpIJKMuxhETeolSleK80EBsbQ9Gr4oUhHKsdqPbUh2IKocDZxHcCCcOi24EXQinb4baYzeS9AIL16t5odQDROzajvHy5RyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442672; c=relaxed/simple;
	bh=HEvgvIs0kv3+YnLHTQm+OjDhCZE9wzcQuOd/LrNUFOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAghoBdfTP7MaNFlxd8mtBRVceB+1bdhShG6brG8Xv37g8yyhHITqA3hZD+ua9gUIwM6hNQfsaqJumywuHTTcUWpC/sQUsGTDolyTkzhxiMTHRPqh0lR8h9YBgYwDbe1TzgBtct2UzbfPVwPVl6FGD67sur4srIe8YCNRc/gZgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=AgQtQoNs; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589ISSD11542432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 11:28:34 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589ISSD11542432
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757442515;
	bh=SZ8zwIvAVHeG6H+RqdqYuMY80Tz/rqBpKv4EQG1K4EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgQtQoNsI/4gLVufq8ZwtMdH3xKl4x3Ws1GKVuXcBOumt5xbsBy19eAmJsF83LSDj
	 6heQXnKtBUtPxzm+eNX46wqgHH5Gt4sPjLWe82hD9oCp/61GO8mq0hXdJKQXGh32nm
	 L6oFUREuuTxmMaT1BNPA2nj8QdRzyiqOKdWAiViKHdC5BfP5Ys/xGvBO4NKCYyVINq
	 mdsPngeebB63buqLF2pI5qEigMKzbXphRbRb5F4MVQ3ANOmuts/VjOD3ppdeH2Tuu9
	 Ul4mVRzoc551uljkC64DPn+9SGQPCvLmKodsgKsfsXx6tG9BSTZAl+OR4IsDz4VW3K
	 4vEOueSmE6DPg==
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
Subject: [RFC PATCH v1 2/5] x86/boot: Move VMXOFF from KVM teardown to CPU shutdown phase
Date: Tue,  9 Sep 2025 11:28:22 -0700
Message-ID: <20250909182828.1542362-3-xin@zytor.com>
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

Relocate VMXOFF from the KVM module unload path to the CPU shutdown phase.
This simplifies proper virtualization cleanup during system shutdown, CPU
hotplug (online/offline cycles), and suspend-to-disk (S4) transitions.

Since INIT interrupts are blocked during VMX operation, VMXOFF must run
just before a CPU shuts down to allow it to be brought back online later.

As a result, VMX instructions are no longer expected to fault.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/processor.h |  1 +
 arch/x86/kernel/cpu/common.c     | 37 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/crash.c          |  4 ++++
 arch/x86/kernel/process.c        |  3 +++
 arch/x86/kernel/reboot.c         | 11 ++++++----
 arch/x86/kernel/smp.c            |  5 +++++
 arch/x86/kernel/smpboot.c        |  6 ++++++
 arch/x86/kvm/vmx/vmx.c           | 30 --------------------------
 arch/x86/power/cpu.c             |  3 +++
 9 files changed, 66 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 59660428f46d..0bfd4eb1e9e2 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -231,6 +231,7 @@ void get_cpu_vendor(struct cpuinfo_x86 *c);
 extern void early_cpu_init(void);
 extern void identify_secondary_cpu(unsigned int cpu);
 extern void cpu_enable_virtualization(void);
+extern void cpu_disable_virtualization(void);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 void print_cpu_msr(struct cpuinfo_x86 *);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e36877b5a240..39b9be9a2fb1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2002,6 +2002,43 @@ void cpu_enable_virtualization(void)
 	intel_pt_handle_vmx(0);
 }
 
+/*
+ * Because INIT interrupts are blocked during VMX operation, this function
+ * must be called just before a CPU shuts down to ensure it can be brought
+ * back online later.
+ *
+ * Consequently, VMX instructions are no longer expected to fault.
+ *
+ * Although VMXOFF should not fault, fault handling is retained as a
+ * precaution against any unexpected code paths that might trigger it and
+ * can be removed later if unnecessary.
+ */
+void cpu_disable_virtualization(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (!is_vmx_supported())
+		return;
+
+	if (!(cr4_read_shadow() & X86_CR4_VMXE)) {
+		pr_err("VMX not enabled or already disabled on CPU%d\n", cpu);
+		return;
+	}
+
+	asm goto("1: vmxoff\n\t"
+		 _ASM_EXTABLE(1b, %l[fault])
+		 ::: "cc", "memory" : fault);
+
+exit:
+	cr4_clear_bits(X86_CR4_VMXE);
+	intel_pt_handle_vmx(0);
+	return;
+
+fault:
+	pr_err("VMXOFF faulted on CPU%d\n", cpu);
+	goto exit;
+}
+
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index c6b12bed173d..772c6d350b50 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -111,6 +111,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 
 	crash_smp_send_stop();
 
+	/* Kept to VMCLEAR loaded VMCSs */
 	cpu_emergency_disable_virtualization();
 
 	/*
@@ -141,6 +142,9 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	x86_platform.guest.enc_kexec_finish();
 
 	crash_save_cpu(regs, smp_processor_id());
+
+	/* Disable virtualization on the last running CPU, usually the BSP */
+	cpu_disable_virtualization();
 }
 
 #if defined(CONFIG_KEXEC_FILE) || defined(CONFIG_CRASH_HOTPLUG)
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1b7960cf6eb0..a0f6397b81ab 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -827,6 +827,9 @@ void __noreturn stop_this_cpu(void *dummy)
 	disable_local_APIC();
 	mcheck_cpu_clear(c);
 
+	/* Disable virtualization, usually this is an AP */
+	cpu_disable_virtualization();
+
 	/*
 	 * Use wbinvd on processors that support SME. This provides support
 	 * for performing a successful kexec when going from SME inactive
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 964f6b0a3d68..7433e634018f 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -764,6 +764,9 @@ void native_machine_shutdown(void)
 
 	if (kexec_in_progress)
 		x86_platform.guest.enc_kexec_finish();
+
+	/* Disable virtualization on the last running CPU, usually the BSP */
+	cpu_disable_virtualization();
 }
 
 static void __machine_emergency_restart(int emergency)
@@ -873,14 +876,14 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (shootdown_callback)
 		shootdown_callback(cpu, regs);
 
-	/*
-	 * Prepare the CPU for reboot _after_ invoking the callback so that the
-	 * callback can safely use virtualization instructions, e.g. VMCLEAR.
-	 */
+	/* Kept to VMCLEAR loaded VMCSs */
 	cpu_emergency_disable_virtualization();
 
 	atomic_dec(&waiting_for_crash_ipi);
 
+	/* Disable virtualization, usually this is an AP */
+	cpu_disable_virtualization();
+
 	if (smp_ops.stop_this_cpu) {
 		smp_ops.stop_this_cpu();
 		BUG();
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b014e6d229f9..eb6a389ba1a9 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -124,7 +124,9 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
+	/* Kept to VMCLEAR loaded VMCSs */
 	cpu_emergency_disable_virtualization();
+
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -136,7 +138,10 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 {
 	apic_eoi();
+
+	/* Kept to VMCLEAR loaded VMCSs */
 	cpu_emergency_disable_virtualization();
+
 	stop_this_cpu(NULL);
 }
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 33e166f6ab12..fe3b04f33b3f 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1229,6 +1229,12 @@ int native_cpu_disable(void)
          */
 	apic_soft_disable();
 
+	/*
+	 * IPIs have been disabled as mentioned above, so virtualization
+	 * can now be safely shut down.
+	 */
+	cpu_disable_virtualization();
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f6742df0c4ff..26af0a8ae08f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -674,29 +674,6 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
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
@@ -719,8 +696,6 @@ void vmx_emergency_disable_virtualization_cpu(void)
 		if (v->shadow_vmcs)
 			vmcs_clear(v->shadow_vmcs);
 	}
-
-	kvm_cpu_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -2788,12 +2763,7 @@ void vmx_disable_virtualization_cpu(void)
 {
 	vmclear_local_loaded_vmcss();
 
-	if (kvm_cpu_vmxoff())
-		kvm_spurious_fault();
-
 	hv_reset_evmcs();
-
-	intel_pt_handle_vmx(0);
 }
 
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 0eec314b79c2..d2c865fdb069 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -129,6 +129,9 @@ static void __save_processor_state(struct saved_context *ctxt)
 	ctxt->misc_enable_saved = !rdmsrq_safe(MSR_IA32_MISC_ENABLE,
 					       &ctxt->misc_enable);
 	msr_save_context(ctxt);
+
+	/* Now CR4 is saved, disable VMX and clear CR4.VMXE */
+	cpu_disable_virtualization();
 }
 
 /* Needed by apm.c */
-- 
2.51.0


