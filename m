Return-Path: <kvm+bounces-1069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA76C7E49AB
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0B4C281367
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 20:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F0937152;
	Tue,  7 Nov 2023 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OoFYkDOC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663F037143
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 20:20:17 +0000 (UTC)
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CE810C2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:20:16 -0800 (PST)
Received: by mail-oi1-x24a.google.com with SMTP id 5614622812f47-3b2f43c4853so9882152b6e.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 12:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699388416; x=1699993216; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fqF5UxPGCIsPTXDpdFGLw6JNCjnN+IkawCMrr9G3hrg=;
        b=OoFYkDOCyByTEE1kC0f/K9oKeA8ATHx77oteSXrRgrxNwp9r1dNxo6Ux+HEiYo22+A
         Gq6bXq9vp1MwH1Ext4y8nGyisAq38OufTVHKPd+M5I5XlWTKmQNbS5uTAfhqkqrVDGV+
         v+GG3TZXZr2FVwpWFR3afAMI7bwyKYFHW1ZPTYrNAFwmeSmHI/V8PQ59K2rmS7glBO+H
         SlGsY38t+8x6ommBVwcdYZuAvkzH0L+Wh1aXiwewGUKVOKlkgn04bcX1hG/Z2N6yHCJu
         s5dhm5rGAbUZ9f2GHduEoMQSVtR5ggak/obsAZ56hjkxgM05KdemZaUm/SppBW2xaZEB
         k3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699388416; x=1699993216;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fqF5UxPGCIsPTXDpdFGLw6JNCjnN+IkawCMrr9G3hrg=;
        b=NS6Atxl0LG2ag4uNs1P90iodnmnFGjRdlEOvjpPDWiHDD139HCR3qwiHw7Sz7yZsCl
         QcPC6g9BVJmUq3ohqybB8BYGcYHq1ogKaoAkKf/PaVzPoxQmGE9VR67rEEkJ1e3PTD+1
         tTQEROuSWz1BCLKY5Xu73V8Ky1TSspgZXExlwB8TBJvzS7+gbK/fMpRSqYPI9mgnWNnZ
         Q18iVKAOqzZg9jzZhj3LRpdapsU09jGj2ear/6Oh8IG5G2piDCiTqhmzq4I0uryYnA4Y
         pA3F61ocwA0xn96A0PypEO0j+dtGCi2pPR8nVYzcTYiTkM4SV94FdwKUvcinKpuGTHSr
         My7A==
X-Gm-Message-State: AOJu0YzemirNCLxqtYeCAsQTTfOXV8IDOnecPuvBiRMIGfIstI4c82I3
	iHE8Iy4tgkw3990e0snrPlbhpCF/EWebKdxfOYGQPMCg/BiTS7vzJxHZPmGLRPtAUWzKtu1XqV9
	oarM9R2j3IhZC5f+1+ouXovu7TJJc7AmPj6bPgw1eIypBg4KePD7A6SgR5L7LF0k=
X-Google-Smtp-Source: AGHT+IGsmR+VjZnkSZCKtWQJ+da17ch83Le87Fy2FR4U1VEptfEHSPOgQeqPU5o+NZ5XevZ/Xc4/PABf4Hyxow==
X-Received: from aghulati-dev.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:18bb])
 (user=aghulati job=sendgmr) by 2002:a05:6808:1913:b0:3b2:f40e:9493 with SMTP
 id bf19-20020a056808191300b003b2f40e9493mr12724oib.6.1699388416025; Tue, 07
 Nov 2023 12:20:16 -0800 (PST)
Date: Tue,  7 Nov 2023 20:19:50 +0000
In-Reply-To: <20231107202002.667900-1-aghulati@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231107202002.667900-1-aghulati@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231107202002.667900-3-aghulati@google.com>
Subject: [RFC PATCH 02/14] KVM: x86: Fold x86 vendor modules into the main KVM modules
From: Anish Ghulati <aghulati@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, hpa@zytor.com, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, peterz@infradead.org, paulmck@kernel.org, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="UTF-8"

Collapse x86 vendor modules, i.e. kvm_intel and kvm_amd into kvm.ko.

Add a new vendor_exit function to kvm_x86_ops so that KVM knows which
exit function to call when exiting. Since the vendor modules no longer
exist the vendor_exit function call does not have to go through a static
call.

Expose vendor init/exit/supported functions so that they can be called
from vendor neutral KVM locations.

Signed-off-by: Anish Ghulati <aghulati@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +
 arch/x86/kernel/nmi.c              |  2 +-
 arch/x86/kvm/Kconfig               | 12 ++----
 arch/x86/kvm/Makefile              | 10 ++---
 arch/x86/kvm/svm/svm.c             | 38 +++++++----------
 arch/x86/kvm/vmx/vmx.c             | 66 +++++++++++++-----------------
 arch/x86/kvm/x86.c                 | 18 +++++---
 arch/x86/kvm/x86.h                 | 15 +++++++
 9 files changed, 82 insertions(+), 82 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e3054e3e46d5..764be4a26a0c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -14,6 +14,7 @@ BUILD_BUG_ON(1)
  * to make a definition optional, but in this case the default will
  * be __static_call_return0.
  */
+KVM_X86_OP(vendor_exit)
 KVM_X86_OP(check_processor_compatibility)
 KVM_X86_OP(hardware_enable)
 KVM_X86_OP(hardware_disable)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eda45a937666..e01d1aa3628c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1546,6 +1546,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	const char *name;
 
+	void (*vendor_exit)(void);
+
 	int (*check_processor_compatibility)(void);
 
 	int (*hardware_enable)(void);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a0c551846b35..8f2ac7598912 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -565,7 +565,7 @@ DEFINE_IDTENTRY_RAW(exc_nmi_kvm_vmx)
 {
 	exc_nmi(regs);
 }
-#if IS_MODULE(CONFIG_KVM_INTEL)
+#if IS_MODULE(CONFIG_KVM) && IS_ENABLED(CONFIG_KVM_INTEL)
 EXPORT_SYMBOL_GPL(asm_exc_nmi_kvm_vmx);
 #endif
 #endif
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 8c5fb7f57b4c..adfa57d59643 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -75,15 +75,12 @@ config KVM_WERROR
 	  If in doubt, say "N".
 
 config KVM_INTEL
-	tristate "KVM for Intel (and compatible) processors support"
+	bool "KVM for Intel (and compatible) processors support"
 	depends on KVM && IA32_FEAT_CTL
 	help
 	  Provides support for KVM on processors equipped with Intel's VT
 	  extensions, a.k.a. Virtual Machine Extensions (VMX).
 
-	  To compile this as a module, choose M here: the module
-	  will be called kvm-intel.
-
 config X86_SGX_KVM
 	bool "Software Guard eXtensions (SGX) Virtualization"
 	depends on X86_SGX && KVM_INTEL
@@ -97,20 +94,17 @@ config X86_SGX_KVM
 	  If unsure, say N.
 
 config KVM_AMD
-	tristate "KVM for AMD processors support"
+	bool "KVM for AMD processors support"
 	depends on KVM && (CPU_SUP_AMD || CPU_SUP_HYGON)
 	help
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
-	  To compile this as a module, choose M here: the module
-	  will be called kvm-amd.
-
 config KVM_AMD_SEV
 	def_bool y
 	bool "AMD Secure Encrypted Virtualization (SEV) support"
 	depends on KVM_AMD && X86_64
-	depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
+	depends on CRYPTO_DEV_SP_PSP && !(KVM=y && CRYPTO_DEV_CCP_DD=m)
 	help
 	  Provides support for launching Encrypted VMs (SEV) and Encrypted VMs
 	  with Encrypted State (SEV-ES) on AMD processors.
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index d13f1a7b7b3d..3e965c90e065 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -21,20 +21,18 @@ kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 kvm-$(CONFIG_KVM_XEN)	+= xen.o
 kvm-$(CONFIG_KVM_SMM)	+= smm.o
 
-kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
+kvm-$(CONFIG_KVM_INTEL)	+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o
-kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 
-kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
+kvm-$(CONFIG_KVM_AMD)	+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o svm/hyperv.o
 
 ifdef CONFIG_HYPERV
-kvm-amd-y		+= svm/svm_onhyperv.o
+kvm-$(CONFIG_KVM_AMD)	+= svm/svm_onhyperv.o
 endif
 
 obj-$(CONFIG_KVM)	+= kvm.o
-obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
-obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
 
 AFLAGS_svm/vmenter.o    := -iquote $(obj)
 $(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3d44e42f4f22..7fe9d11db8a6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -52,9 +52,6 @@
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
-MODULE_AUTHOR("Qumranet");
-MODULE_LICENSE("GPL");
-
 #ifdef MODULE
 static const struct x86_cpu_id svm_cpu_id[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_SVM, NULL),
@@ -551,7 +548,7 @@ static bool __kvm_is_svm_supported(void)
 	return true;
 }
 
-static bool kvm_is_svm_supported(void)
+bool kvm_is_svm_supported(void)
 {
 	bool supported;
 
@@ -4873,9 +4870,21 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static void __svm_exit(void)
+{
+	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
+}
+
+void svm_module_exit(void)
+{
+	__svm_exit();
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
+	.vendor_exit = svm_module_exit,
+
 	.check_processor_compatibility = svm_check_processor_compat,
 
 	.hardware_unsetup = svm_hardware_unsetup,
@@ -5298,22 +5307,12 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.pmu_ops = &amd_pmu_ops,
 };
 
-static void __svm_exit(void)
-{
-	kvm_x86_vendor_exit();
-
-	cpu_emergency_unregister_virt_callback(svm_emergency_disable);
-}
-
-static int __init svm_init(void)
+int __init svm_init(void)
 {
 	int r;
 
 	__unused_size_checks();
 
-	if (!kvm_is_svm_supported())
-		return -EOPNOTSUPP;
-
 	r = kvm_x86_vendor_init(&svm_init_ops);
 	if (r)
 		return r;
@@ -5335,12 +5334,3 @@ static int __init svm_init(void)
 	__svm_exit();
 	return r;
 }
-
-static void __exit svm_exit(void)
-{
-	kvm_exit();
-	__svm_exit();
-}
-
-module_init(svm_init)
-module_exit(svm_exit)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65d59de3cc63..629e662b131e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -66,9 +66,6 @@
 #include "x86.h"
 #include "smm.h"
 
-MODULE_AUTHOR("Qumranet");
-MODULE_LICENSE("GPL");
-
 #ifdef MODULE
 static const struct x86_cpu_id vmx_cpu_id[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_VMX, NULL),
@@ -2738,7 +2735,7 @@ static bool __kvm_is_vmx_supported(void)
 	return true;
 }
 
-static bool kvm_is_vmx_supported(void)
+bool kvm_is_vmx_supported(void)
 {
 	bool supported;
 
@@ -8199,9 +8196,35 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
 }
 
+static void vmx_cleanup_l1d_flush(void)
+{
+	if (vmx_l1d_flush_pages) {
+		free_pages((unsigned long)vmx_l1d_flush_pages, L1D_CACHE_ORDER);
+		vmx_l1d_flush_pages = NULL;
+	}
+	/* Restore state so sysfs ignores VMX */
+	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
+}
+
+static void __vmx_exit(void)
+{
+	allow_smaller_maxphyaddr = false;
+
+	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
+
+	vmx_cleanup_l1d_flush();
+}
+
+void vmx_module_exit(void)
+{
+	__vmx_exit();
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
 
+	.vendor_exit = vmx_module_exit,
+
 	.check_processor_compatibility = vmx_check_processor_compat,
 
 	.hardware_unsetup = vmx_hardware_unsetup,
@@ -8608,41 +8631,10 @@ static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.pmu_ops = &intel_pmu_ops,
 };
 
-static void vmx_cleanup_l1d_flush(void)
-{
-	if (vmx_l1d_flush_pages) {
-		free_pages((unsigned long)vmx_l1d_flush_pages, L1D_CACHE_ORDER);
-		vmx_l1d_flush_pages = NULL;
-	}
-	/* Restore state so sysfs ignores VMX */
-	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
-}
-
-static void __vmx_exit(void)
-{
-	allow_smaller_maxphyaddr = false;
-
-	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
-
-	vmx_cleanup_l1d_flush();
-}
-
-static void vmx_exit(void)
-{
-	kvm_exit();
-	kvm_x86_vendor_exit();
-
-	__vmx_exit();
-}
-module_exit(vmx_exit);
-
-static int __init vmx_init(void)
+int __init vmx_init(void)
 {
 	int r, cpu;
 
-	if (!kvm_is_vmx_supported())
-		return -EOPNOTSUPP;
-
 	/*
 	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
 	 * to unwind if a later step fails.
@@ -8691,6 +8683,7 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_kvm_init;
 
+
 	return 0;
 
 err_kvm_init:
@@ -8699,4 +8692,3 @@ static int __init vmx_init(void)
 	kvm_x86_vendor_exit();
 	return r;
 }
-module_init(vmx_init);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b7f89fd2d47..e62daa2c3017 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -15,6 +15,7 @@
  *   Amit Shah    <amit.shah@qumranet.com>
  *   Ben-Ami Yassour <benami@il.ibm.com>
  */
+#include <asm-generic/errno.h>
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
@@ -13678,15 +13679,22 @@ static int __init kvm_x86_init(void)
 {
 	kvm_mmu_x86_module_init();
 	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) && cpu_smt_possible();
-	return 0;
+
+	if (kvm_is_svm_supported())
+		return svm_init();
+	else if (kvm_is_vmx_supported())
+		return vmx_init();
+
+	pr_err_ratelimited("kvm: no hardware support for SVM or VMX\n");
+	return -EOPNOTSUPP;
 }
 module_init(kvm_x86_init);
 
 static void __exit kvm_x86_exit(void)
 {
-	/*
-	 * If module_init() is implemented, module_exit() must also be
-	 * implemented to allow module unload.
-	 */
+	kvm_exit();
+	kvm_x86_vendor_exit();
+	kvm_x86_ops.vendor_exit();
+
 }
 module_exit(kvm_x86_exit);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6b5490319d1b..322be05e6c5b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -9,6 +9,21 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+#ifdef CONFIG_KVM_AMD
+bool kvm_is_svm_supported(void);
+int __init svm_init(void);
+void svm_module_exit(void);
+#else
+bool kvm_is_svm_supported(void) { return false; }
+#endif
+#ifdef CONFIG_KVM_INTEL
+bool kvm_is_vmx_supported(void);
+int __init vmx_init(void);
+void vmx_module_exit(void);
+#else
+bool kvm_is_vmx_supported(void) { return false; }
+#endif
+
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
 	bool has_tsc_control;
-- 
2.42.0.869.gea05f2083d-goog


