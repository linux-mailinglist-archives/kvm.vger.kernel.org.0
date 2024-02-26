Return-Path: <kvm+bounces-9974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D80868074
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DD60B2957A
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B761313173B;
	Mon, 26 Feb 2024 19:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XaucoQOV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BBB12FF7D
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974235; cv=none; b=i4sIfhh05/Xj/7c3vr9PeDoGX+0Zzo8x+axQNxMC6llud12ZFHeT+QkKMKGx8lsw+QiY9rZeOpcdbk0HoGidXnmDVt2Iwdm7PbOXk3JfeGMf/a9wQ34uJQhYZEqGZvkz2jNgVz5EtYybuo6GdymeX0Fkhw90gbjy2jfQu/a7JcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974235; c=relaxed/simple;
	bh=gdcuCGA23ijK8IedHH9Alc+WM019+Vw2uPYLqEMtzNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3nPqX1jbgbBZ5Sh86rHIlAExNWbqnQIoH3IPSHii77rduqGwMZ2yFtB/MjVdgnxy+n7353xXOLplcE7PcuclXo+y/rt8r3wZvhhxXwbr+VWXojuHBYOrhUwDUdupy3gB9ISDQvBEFIFWWsyGF9GAvLbY2mBGb30HtIG2/xrg3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XaucoQOV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708974231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sapQ1rQXht7UPPsixNWb0F8gvh8dQi4pPg5S6Lu5Ts=;
	b=XaucoQOVPkvtQTlnGwwQgZL+p42BLzMVcQbPX4nvFLWbNkd8Ku9/p79zgIyr2ys5xwyasv
	10H2acTuy+z9jk1BKxYZqgwO8ClsxWCw0f817VVUj12QqA7/NAYQmDeAIsOvM+4TfRkk6l
	/etKgWAsWKulf3WL6TMBRiGlNu7fpjA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-bNUJM6SPNcGJ400V6qvQmA-1; Mon,
 26 Feb 2024 14:03:47 -0500
X-MC-Unique: bNUJM6SPNcGJ400V6qvQmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 768DA3C1494E;
	Mon, 26 Feb 2024 19:03:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4E2AF492BC6;
	Mon, 26 Feb 2024 19:03:46 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v3 04/15] KVM: SVM: Compile sev.c if and only if CONFIG_KVM_AMD_SEV=y
Date: Mon, 26 Feb 2024 14:03:33 -0500
Message-Id: <20240226190344.787149-5-pbonzini@redhat.com>
In-Reply-To: <20240226190344.787149-1-pbonzini@redhat.com>
References: <20240226190344.787149-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

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
 arch/x86/kvm/svm/svm.h | 26 +++++++++++++++++---------
 4 files changed, 25 insertions(+), 36 deletions(-)

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
index aec3453fd73c..2f4f54ab8e1b 100644
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
 static bool sev_es_debug_swap_enabled = true;
 module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
-#else
-#define sev_enabled false
-#define sev_es_enabled false
-#define sev_es_debug_swap_enabled false
-#endif /* CONFIG_KVM_AMD_SEV */
 
 static u8 sev_enc_bit;
 static DECLARE_RWSEM(sev_deactivate_lock);
@@ -2186,7 +2165,6 @@ void __init sev_set_cpu_caps(void)
 
 void __init sev_hardware_setup(void)
 {
-#ifdef CONFIG_KVM_AMD_SEV
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -2286,7 +2264,6 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled || !cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP) ||
 	    !cpu_feature_enabled(X86_FEATURE_NO_NESTED_DATA_BP))
 		sev_es_debug_swap_enabled = false;
-#endif
 }
 
 void sev_hardware_unsetup(void)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e90b429c84f1..eaa973dbe543 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3306,7 +3306,9 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+#ifdef CONFIG_KVM_AMD_SEV
 	[SVM_EXIT_VMGEXIT]			= sev_handle_vmgexit,
+#endif
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
@@ -5014,6 +5016,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_smi_window = svm_enable_smi_window,
 #endif
 
+#ifdef CONFIG_KVM_AMD_SEV
 	.mem_enc_ioctl = sev_mem_enc_ioctl,
 	.mem_enc_register_region = sev_mem_enc_register_region,
 	.mem_enc_unregister_region = sev_mem_enc_unregister_region,
@@ -5021,7 +5024,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vm_copy_enc_context_from = sev_vm_copy_enc_context_from,
 	.vm_move_enc_context_from = sev_vm_move_enc_context_from,
-
+#endif
 	.check_emulate_instruction = svm_check_emulate_instruction,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8ef95139cd24..52bc955ed06f 100644
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
@@ -681,19 +678,30 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
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
+void sev_free_vcpu(struct kvm_vcpu *vcpu);
+void sev_vm_destroy(struct kvm *kvm);
+void __init sev_set_cpu_caps(void);
+void __init sev_hardware_setup(void);
+void sev_hardware_unsetup(void);
+int sev_cpu_init(struct svm_cpu_data *sd);
+extern unsigned int max_sev_asid;
+#else
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
2.39.1



