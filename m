Return-Path: <kvm+bounces-13549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CDBC8986EA
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A04E1F283A4
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0560B1292DE;
	Thu,  4 Apr 2024 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ca/gYGqa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A6486244
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232817; cv=none; b=WEj/YwEtvN2BRm/mVxNyMiQemey2Upa4oChwr5E3K6/a4CfZSeCFHtt+m5igIEFvaKt+SunfZkYE3PVQ/dmdR8MaqRm67z3K1R4dVSjM4FpTRRZvqBTtoM3yinIX7vr0oL8AcHakGJmg6FyA9rGbkO3TOfTfmx4N7gHwpSqdXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232817; c=relaxed/simple;
	bh=25FddFyxEEhrFUML6yT+6DIO7mi5Cb5zPlQlZBkxRoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i6WeM8AbtKKaOp+ZlYxAZx3kDY9PIa4XJY68R7SeoSTOPaP6v8vAGWHHgCNtswKHp5pSm0pr5xAhu2tBYytq6hfmkMXQXI4xcnKq/p1F7b8mUXUMX+blJEYzFsZlacQjry9S9IDA/5Ym4VK7betR1vU4V2quYYHsRySYX9AtisI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ca/gYGqa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cgne/8GVLuVuVI9ZiWSMjRiVGToo9YPaCbg/cTZ/3FY=;
	b=ca/gYGqa/4rTOEIhBmFjeqII/sj30TQ5lS7oJmV8u93IUmyi3mh3pEFySxY/E21ZqqACgL
	vGsBjfvcsS+e51+p+9/4PLX23p8BbXYl9bkVqspc34fqlkrLj7NH5rKZ0AnDcq1QYxoM7s
	txIF7vsWExhODAxQqpMQ2L91Nqj8k48=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-XcwvrXk-NGS_zz7fycwTtw-1; Thu, 04 Apr 2024 08:13:29 -0400
X-MC-Unique: XcwvrXk-NGS_zz7fycwTtw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD4B8185A78F;
	Thu,  4 Apr 2024 12:13:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A76572024517;
	Thu,  4 Apr 2024 12:13:28 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH v5 02/17] KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
Date: Thu,  4 Apr 2024 08:13:12 -0400
Message-ID: <20240404121327.3107131-3-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Stop compiling sev.c when CONFIG_KVM_AMD_SEV=n, as the number of #ifdefs
in sev.c is getting ridiculous, and having #ifdefs inside of SEV helpers
is quite confusing.

To minimize #ifdefs in code flows, #ifdef away only the kvm_x86_ops hooks
and the #VMGEXIT handler. Stubs are also restricted to functions that
check sev_enabled and to the destruction functions sev_free_cpu() and
sev_vm_destroy(), where the style of their callers is to leave checks
to the callers.  Most call sites instead rely on dead code elimination
to take care of functions that are guarded with sev_guest() or
sev_es_guest().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Makefile  |  7 ++++---
 arch/x86/kvm/svm/sev.c | 24 ++--------------------
 arch/x86/kvm/svm/svm.c |  5 ++++-
 arch/x86/kvm/svm/svm.h | 45 ++++++++++++++++++++++++++----------------
 4 files changed, 38 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a88bb14266b6..a358bf5e3a65 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -26,9 +26,10 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
 kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
 
-kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
-			   svm/sev.o
-kvm-amd-$(CONFIG_KVM_HYPERV) += svm/hyperv.o
+kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o
+
+kvm-amd-$(CONFIG_KVM_AMD_SEV)	+= svm/sev.o
+kvm-amd-$(CONFIG_KVM_HYPERV)	+= svm/hyperv.o
 
 ifdef CONFIG_HYPERV
 kvm-y			+= kvm_onhyperv.o
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 382c745b8ba9..5d41f27a8af5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -32,22 +32,9 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#ifndef CONFIG_KVM_AMD_SEV
-/*
- * When this config is not defined, SEV feature is not supported and APIs in
- * this file are not used but this file still gets compiled into the KVM AMD
- * module.
- *
- * We will not have MISC_CG_RES_SEV and MISC_CG_RES_SEV_ES entries in the enum
- * misc_res_type {} defined in linux/misc_cgroup.h.
- *
- * Below macros allow compilation to succeed.
- */
-#define MISC_CG_RES_SEV MISC_CG_RES_TYPES
-#define MISC_CG_RES_SEV_ES MISC_CG_RES_TYPES
-#endif
+#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MIN	1ULL
 
-#ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -59,11 +46,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
 /* enable/disable SEV-ES DebugSwap support */
 static bool sev_es_debug_swap_enabled = false;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
-#else
-#define sev_enabled false
-#define sev_es_enabled false
-#define sev_es_debug_swap_enabled false
-#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -2194,7 +2176,6 @@ void __init sev_set_cpu_caps(void)
 
 void __init sev_hardware_setup(void)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -2294,7 +2275,6 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
-#endif
 }
 
 void sev_hardware_unsetup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1a9f9951635..e7f47a1f3eb1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3303,7 +3303,9 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+#ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
+#endif
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -5023,6 +5025,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_smi_window = svm_enable_smi_window,
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
 	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
@@ -5030,7 +5033,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
-
+#endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7f1fbd874c45..ec8ca7d92cf1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -664,13 +664,16 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
-#define GHCB_VERSION_MIN	1ULL
+void pre_sev_run(struct vcpu_svm *svm, int cpu);
+void sev_init_vmcb(struct vcpu_svm *svm);
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
+int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
+void sev_es_vcpu_reset(struct vcpu_svm *svm);
+void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
+void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
+void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
-
-extern unsigned int max_sev_asid;
-
-void sev_vm_destroy(struct kvm *kvm);
+#ifdef CONFIG_KVM_AMD_SEV
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range);
@@ -679,22 +682,30 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
 int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void sev_guest_memory_reclaimed(struct kvm *kvm);
+int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 
-void pre_sev_run(struct vcpu_svm *svm, int cpu);
+/* These symbols are used in common code and are stubbed below.  */
+struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_free_vcpu(struct kvm_vcpu *vcpu);
+void sev_vm_destroy(struct kvm *kvm);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
-void sev_init_vmcb(struct vcpu_svm *svm);
-void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
-void sev_free_vcpu(struct kvm_vcpu *vcpu);
-int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
-int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_vcpu_reset(struct vcpu_svm *svm);
-void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
-void sev_es_unmap_ghcb(struct vcpu_svm *svm);
-struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+extern unsigned int max_sev_asid;
+#else
+static inline struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu) {
+	return alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+}
+
+static inline void sev_free_vcpu(struct kvm_vcpu *vcpu) {}
+static inline void sev_vm_destroy(struct kvm *kvm) {}
+static inline void __init sev_set_cpu_caps(void) {}
+static inline void __init sev_hardware_setup(void) {}
+static inline void sev_hardware_unsetup(void) {}
+static inline int sev_cpu_init(struct svm_cpu_data *sd) { return 0; }
+#define max_sev_asid 0
+#endif
 
 /* vmenter.S */
 
-- 
2.43.0



