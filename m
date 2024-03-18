Return-Path: <kvm+bounces-12048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3974B87F409
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5940F1C21B74
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:34:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EB15FDA8;
	Mon, 18 Mar 2024 23:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S7N9mndF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CED5F871
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804841; cv=none; b=sTvfs5dOB5W7TBcFvzAOpSDNt+KZlFtLLpqdn5gxZ2KvaQFTx0YhFNFkmlyWxRCHBQXkj9L6BhSj9EswSdfgMc6YS3RD1t8wNYXxNoig2Gvps9FeeI3D+Ei2cx4R5BlTQlXjXSg0pqkY2XqCxBaAZcgSDOTC2LAP9KN2Eor/eI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804841; c=relaxed/simple;
	bh=QPgvoV7iopJS54EnsQjUFHbWxwEmkTKDAIsnhx7LtEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ESPLoRdhAg7vbwWNAOAUvFC27w7aghcV/oc9iY88OYdRL4gR6qTv7lSYD4oTWNtopCK/5Pwtp5FpQFGcVcX35sQAzYCrWkZb9P5ACzp0uf7DxhZxAQ198MMh27teDbnp2yy1EIWI0CIo+CeunPiv9GYj8h0wsURTIB8zXOud/bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S7N9mndF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ac+SqeWqdZtDP3M7cjCTFGvNjpoWZzXAvMxsav5DEBY=;
	b=S7N9mndFV83cSEkUL7nuoJtfm9qup0XebQIpOfBtV70hX5Be6mMa+pRRTKMee+TGEjr+Ir
	T+EmisZw28/NOhOwQLzLLD5Pt2eYVRZDEdHJpbvFJUyMvlCnUpU4QGs5a10BvVM0zXBeFd
	TmXxPmmRGRADKzL7NQfh6NhyrME+6Gs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-9HHMMxyZOtOwuBaLP-wLSw-1; Mon, 18 Mar 2024 19:33:54 -0400
X-MC-Unique: 9HHMMxyZOtOwuBaLP-wLSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FDDE185A781;
	Mon, 18 Mar 2024 23:33:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D7A391121312;
	Mon, 18 Mar 2024 23:33:53 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 02/15] KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
Date: Mon, 18 Mar 2024 19:33:39 -0400
Message-ID: <20240318233352.2728327-3-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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
 arch/x86/kvm/svm/sev.c | 23 -----------------------
 arch/x86/kvm/svm/svm.c |  5 ++++-
 arch/x86/kvm/svm/svm.h | 32 +++++++++++++++++++++++---------
 4 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 475b5fa917a6..744a1ea3ee5c 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,9 +25,10 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
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
index 382c745b8ba9..73fee5f08391 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -32,22 +32,6 @@
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
-
-#ifdef CONFIG_KVM_AMD_SEV
 /* enable/disable SEV support */
 static bool sev_enabled = true;
 module_param_named(sev, sev_enabled, bool, 0444);
@@ -59,11 +43,6 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
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
@@ -2194,7 +2173,6 @@ void __init sev_set_cpu_caps(void)
 
 void __init sev_hardware_setup(void)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -2294,7 +2272,6 @@ void __init sev_hardware_setup(void)
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
index 7f1fbd874c45..d20e48c31210 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -664,13 +664,10 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
+#ifdef CONFIG_KVM_AMD_SEV
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
-
-extern unsigned int max_sev_asid;
-
-void sev_vm_destroy(struct kvm *kvm);
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
 				struct kvm_enc_region *range);
@@ -681,20 +678,37 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void sev_guest_memory_reclaimed(struct kvm *kvm);
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
-void __init sev_set_cpu_caps(void);
-void __init sev_hardware_setup(void);
-void sev_hardware_unsetup(void);
-int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
-void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
+
+/* These symbols are used in common code and are stubbed below.  */
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
+void sev_free_vcpu(struct kvm_vcpu *vcpu);
+void sev_vm_destroy(struct kvm *kvm);
+void __init sev_set_cpu_caps(void);
+void __init sev_hardware_setup(void);
+void sev_hardware_unsetup(void);
+int sev_cpu_init(struct svm_cpu_data *sd);
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



