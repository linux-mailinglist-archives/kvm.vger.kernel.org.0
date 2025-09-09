Return-Path: <kvm+bounces-57129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0192CB5055F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0AB31798DC
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA4836CC83;
	Tue,  9 Sep 2025 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Aco6tO1/"
X-Original-To: kvm@vger.kernel.org
Received: from terminus.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDF3369335;
	Tue,  9 Sep 2025 18:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442678; cv=none; b=ukUUMxihSRUoSR4UOb13k/60cG4hMAbzAB6U6BsSjVD4A/8D5MEH4WJLqsZFFtnVyV37rlUlM7j1py4sEGLp4sbPjJwJOrft93nGTEfb24wf7brWvCp+j2rNR+HKj4RPP9/5ZkSEBYsfULgZ4qgfmxaLti3bcohQbYqucCBZemo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442678; c=relaxed/simple;
	bh=YvG9wzsxF8aLwI3x38k4boAr/eQEGEwnfUnhh9m/Lko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgwgmt2NZ21C452LQnj0HNAuIJXqILdJfKfRTyil+pNbi5iK9NLdOVuH8pdlF5DuIocceiwQ4ldegvhpq6fTnLOHhemsDfJ5fArkVaoIjSHWNPLMwV7S/D9VswscQKcGhOWWMvhfZAIdSBoccKJTmND0vILUvVYo7fG7qeHb2oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Aco6tO1/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 589ISSD01542432
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 9 Sep 2025 11:28:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 589ISSD01542432
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1757442514;
	bh=HVybEPweDFMJeKmIOe5kBRf/0VPeqdUx2A3Io4WOENA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aco6tO1/1poE6VoJz66GPXFg63X91avFlzlWYlAgCfyQmVydRcNgvSCIb8iexZwIr
	 BtMz4NLxebvx7H2XvyYfDqz5zySBdZ9KTeSVlINzG3Nc9JYsBUCCrbyEJHtBQREnHw
	 9fQu9ny2mmSaUuLTf1EFTq7ObuIktd1IjiYwitBYdgXGxf85QhMf7gEqvsoIoaev1B
	 KhWLGgdEyknVuk/WS8SqPF+KPsKXl7Mr0HSt9dylZbwPr1RDyMk1Bz3gXYMertqvmG
	 BGWXpWFpH7nS0D36WLEYRwgJtmh/TgIgQiMXVwkMOSKmFv1QWFgY2hAtdnk+WyRrwh
	 x+iIG8j8eom1A==
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
Subject: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU startup phase
Date: Tue,  9 Sep 2025 11:28:21 -0700
Message-ID: <20250909182828.1542362-2-xin@zytor.com>
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

Move the VMXON setup from the KVM initialization path to the CPU startup
phase to guarantee that hardware virtualization is enabled early and
without interruption.

As a result, KVM, often loaded as a kernel module, no longer needs to worry
about whether or not VMXON has been executed on a CPU (e.g., CPU offline
events or system reboots while KVM is loading).

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/processor.h |   1 +
 arch/x86/include/asm/vmx.h       |   5 ++
 arch/x86/kernel/cpu/common.c     |  91 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs.h          |   5 --
 arch/x86/kvm/vmx/vmx.c           | 117 ++-----------------------------
 arch/x86/power/cpu.c             |   7 +-
 6 files changed, 107 insertions(+), 119 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bde58f6510ac..59660428f46d 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -230,6 +230,7 @@ void init_cpu_devs(void);
 void get_cpu_vendor(struct cpuinfo_x86 *c);
 extern void early_cpu_init(void);
 extern void identify_secondary_cpu(unsigned int cpu);
+extern void cpu_enable_virtualization(void);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 void print_cpu_msr(struct cpuinfo_x86 *);
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index cca7d6641287..736d04c1b2fc 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,11 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+struct vmcs_hdr {
+	u32 revision_id:31;
+	u32 shadow_vmcs:1;
+};
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 34a054181c4d..e36877b5a240 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -72,6 +72,7 @@
 #include <asm/tdx.h>
 #include <asm/posted_intr.h>
 #include <asm/runtime-const.h>
+#include <asm/vmx.h>
 
 #include "cpu.h"
 
@@ -1923,6 +1924,84 @@ static void generic_identify(struct cpuinfo_x86 *c)
 #endif
 }
 
+static bool is_vmx_supported(void)
+{
+	int cpu = raw_smp_processor_id();
+
+	if (!(cpuid_ecx(1) & (1 << (X86_FEATURE_VMX & 31)))) {
+		/* May not be an Intel CPU */
+		pr_info("VMX not supported by CPU%d\n", cpu);
+		return false;
+	}
+
+	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
+	    !this_cpu_has(X86_FEATURE_VMX)) {
+		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL on CPU%d\n", cpu);
+		return false;
+	}
+
+	return true;
+}
+
+/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
+union vmxon_vmcs {
+	struct vmcs_hdr hdr;
+	char data[PAGE_SIZE];
+};
+
+static DEFINE_PER_CPU_PAGE_ALIGNED(union vmxon_vmcs, vmxon_vmcs);
+
+/*
+ * Executed during the CPU startup phase to execute VMXON to enable VMX. This
+ * ensures that KVM, often loaded as a kernel module, no longer needs to worry
+ * about whether or not VMXON has been executed on a CPU (e.g., CPU offline
+ * events or system reboots while KVM is loading).
+ *
+ * VMXON is not expected to fault, but fault handling is kept as a precaution
+ * against any unexpected code paths that might trigger it and can be removed
+ * later if unnecessary.
+ */
+void cpu_enable_virtualization(void)
+{
+	u64 vmxon_pointer = __pa(this_cpu_ptr(&vmxon_vmcs));
+	int cpu = raw_smp_processor_id();
+	u64 basic_msr;
+
+	if (!is_vmx_supported())
+		return;
+
+	if (cr4_read_shadow() & X86_CR4_VMXE) {
+		pr_err("VMX already enabled on CPU%d\n", cpu);
+		return;
+	}
+
+	memset(this_cpu_ptr(&vmxon_vmcs), 0, PAGE_SIZE);
+
+	/*
+	 * Even though not explicitly documented by TLFS, VMXArea passed as
+	 * VMXON argument should still be marked with revision_id reported by
+	 * physical CPU.
+	 */
+	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+	this_cpu_ptr(&vmxon_vmcs)->hdr.revision_id = vmx_basic_vmcs_revision_id(basic_msr);
+
+	intel_pt_handle_vmx(1);
+
+	cr4_set_bits(X86_CR4_VMXE);
+
+	asm goto("1: vmxon %[vmxon_pointer]\n\t"
+		 _ASM_EXTABLE(1b, %l[fault])
+		 : : [vmxon_pointer] "m"(vmxon_pointer)
+		 : : fault);
+
+	return;
+
+fault:
+	pr_err("VMXON faulted on CPU%d\n", cpu);
+	cr4_clear_bits(X86_CR4_VMXE);
+	intel_pt_handle_vmx(0);
+}
+
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
@@ -2120,6 +2199,12 @@ void identify_secondary_cpu(unsigned int cpu)
 
 	tsx_ap_init();
 	c->initialized = true;
+
+	/*
+	 * Enable AP virtualization immediately after initializing the per-CPU
+	 * cpuinfo_x86 structure, ensuring that this_cpu_has() operates correctly.
+	 */
+	cpu_enable_virtualization();
 }
 
 void print_cpu_info(struct cpuinfo_x86 *c)
@@ -2551,6 +2636,12 @@ void __init arch_cpu_finalize_init(void)
 	*c = boot_cpu_data;
 	c->initialized = true;
 
+	/*
+	 * Enable BSP virtualization right after the BSP cpuinfo_x86 structure
+	 * is initialized to ensure this_cpu_has() works as expected.
+	 */
+	cpu_enable_virtualization();
+
 	alternative_instructions();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..da5631924432 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -13,11 +13,6 @@
 
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
 
-struct vmcs_hdr {
-	u32 revision_id:31;
-	u32 shadow_vmcs:1;
-};
-
 struct vmcs {
 	struct vmcs_hdr hdr;
 	u32 abort;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..f6742df0c4ff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -468,7 +468,6 @@ noinline void invept_error(unsigned long ext, u64 eptp)
 	vmx_insn_failed("invept failed: ext=0x%lx eptp=%llx\n", ext, eptp);
 }
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
@@ -2736,43 +2735,14 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	return 0;
 }
 
-static bool __kvm_is_vmx_supported(void)
-{
-	int cpu = smp_processor_id();
-
-	if (!(cpuid_ecx(1) & feature_bit(VMX))) {
-		pr_err("VMX not supported by CPU %d\n", cpu);
-		return false;
-	}
-
-	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
-	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("VMX not enabled (by BIOS) in MSR_IA32_FEAT_CTL on CPU %d\n", cpu);
-		return false;
-	}
-
-	return true;
-}
-
-static bool kvm_is_vmx_supported(void)
-{
-	bool supported;
-
-	migrate_disable();
-	supported = __kvm_is_vmx_supported();
-	migrate_enable();
-
-	return supported;
-}
-
 int vmx_check_processor_compat(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
 
-	if (!__kvm_is_vmx_supported())
-		return -EIO;
+	if (!(cr4_read_shadow() & X86_CR4_VMXE))
+		return -EOPNOTSUPP;
 
 	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
 		pr_err("Failed to setup VMCS config on CPU %d\n", cpu);
@@ -2787,34 +2757,12 @@ int vmx_check_processor_compat(void)
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
 
-	if (cr4_read_shadow() & X86_CR4_VMXE)
-		return -EBUSY;
+	if (!(cr4_read_shadow() & X86_CR4_VMXE))
+		return -EOPNOTSUPP;
 
 	/*
 	 * This can happen if we hot-added a CPU but failed to allocate
@@ -2823,14 +2771,6 @@ int vmx_enable_virtualization_cpu(void)
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
 	return 0;
 }
 
@@ -2931,47 +2871,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
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
@@ -8204,8 +8103,6 @@ void vmx_hardware_unsetup(void)
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
-
-	free_kvm_area();
 }
 
 void vmx_vm_destroy(struct kvm *kvm)
@@ -8499,10 +8396,6 @@ __init int vmx_hardware_setup(void)
 
 	vmx_set_cpu_caps();
 
-	r = alloc_kvm_area();
-	if (r && nested)
-		nested_vmx_hardware_unsetup();
-
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	/*
@@ -8554,7 +8447,7 @@ int __init vmx_init(void)
 
 	KVM_SANITY_CHECK_VM_STRUCT_SIZE(kvm_vmx);
 
-	if (!kvm_is_vmx_supported())
+	if (!(cr4_read_shadow() & X86_CR4_VMXE))
 		return -EOPNOTSUPP;
 
 	/*
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 916441f5e85c..0eec314b79c2 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -206,11 +206,11 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	/* cr4 was introduced in the Pentium CPU */
 #ifdef CONFIG_X86_32
 	if (ctxt->cr4)
-		__write_cr4(ctxt->cr4);
+		__write_cr4(ctxt->cr4 & ~X86_CR4_VMXE);
 #else
 /* CONFIG X86_64 */
 	wrmsrq(MSR_EFER, ctxt->efer);
-	__write_cr4(ctxt->cr4);
+	__write_cr4(ctxt->cr4 & ~X86_CR4_VMXE);
 #endif
 	write_cr3(ctxt->cr3);
 	write_cr2(ctxt->cr2);
@@ -291,6 +291,9 @@ static void notrace __restore_processor_state(struct saved_context *ctxt)
 	 * because some of the MSRs are "emulated" in microcode.
 	 */
 	msr_restore_context(ctxt);
+
+	if (ctxt->cr4 & X86_CR4_VMXE)
+		cpu_enable_virtualization();
 }
 
 /* Needed by apm.c */
-- 
2.51.0


