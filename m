Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9849F01F
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236419AbiA1AyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345071AbiA1Axy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:54 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C26C0613F7
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:49 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id p17-20020a170903249100b0014af06caa65so2314916plw.6
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TE3DAQCjfF5bgZh0A92f+DGaQa5/4c2uMoQr42NNpYc=;
        b=ATljjYZvZYn32Np3QtiPH5TMWbe0bLoM+3PtuoC8d4BTCbRLK+69hch+U8NxzQY7Ye
         6UukonUBCmUBsHFEuA0j4/6SsG/s1bN6IsV07pCxYyZ971BzgrsLQEkkHfbxbr/OdtvR
         oAiL8iOGxK4qxu6Z4v7qvZoBGzxvzq2ERqs72iEKZm6o+aYZc05Vxx+4uO8XjQ8krvUb
         DcATEhWvD+eeCIhabGiC4yx5AMAxzQ37ws/got7lxNH7DlL6oPLFWqo38OGpZC6/KOev
         QJr04ASzimCABDdsiVNwjINY0BwQJ/lpiFN2Evh7ZhEaVP0hVrp7BsjS44iHe74WxrPR
         Tx+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TE3DAQCjfF5bgZh0A92f+DGaQa5/4c2uMoQr42NNpYc=;
        b=23HnGS23vLewLRAvx7w1DKxEVxg5rMLW0Sw/RDM+25OsS0Rv+MYk9CO1InwFc22Vk/
         VCqftsDDForPxSvFaZIM8ZEO2CxNkyqKl5ONyrCUEw1bhvcXn5TG7dvAxnndaEtgxvt3
         BgLFCRpeEXGBqBctIdKsFRdm34jgNn+K+5kDQpO7DVdXbSPIHiy4SLdcmvRgroIN1ri/
         o1Rs3tX0VWCtxIOrVSGSGjsSdhu9FUQhUaZvLxmKtNNepZ6HWzsyr30Snnv8sNj0K2gB
         Pz0FkvCN2QBUkbFfqeQ3KImkV3JuPAkBLcbOdKzBakpBdIGDTRbDTOChQx06dmBsKENt
         7a/Q==
X-Gm-Message-State: AOAM532YmTm/dQCc3Eb6/qizFLOfqcFksqYGewCOHSyX7i+Gg+ghY2CQ
        qIicC+9EmZQB0jil0O8i8GOayRT5SPk=
X-Google-Smtp-Source: ABdhPJzxJLKJXxL8dGBPM2EBhuloc0p9kUAzPbJW+osbLeZcyeLmeW6furTp4Fo8QEdbeezv2nHK/gl91TM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:7c42:: with SMTP id x63mr5442452pfc.31.1643331228888;
 Thu, 27 Jan 2022 16:53:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:52:07 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 21/22] KVM: SVM: Rename hook implementations to conform to
 kvm_x86_ops' names
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Massage SVM's implementation names that still diverge from kvm_x86_ops to
allow for wiring up all SVM-defined functions via kvm-x86-ops.h.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  4 ++--
 arch/x86/kvm/svm/svm.c | 40 ++++++++++++++++++++--------------------
 arch/x86/kvm/svm/svm.h |  6 +++---
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4662e5fd7559..f4d88292f337 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2173,7 +2173,7 @@ void __init sev_hardware_setup(void)
 #endif
 }
 
-void sev_hardware_teardown(void)
+void sev_hardware_unsetup(void)
 {
 	if (!sev_enabled)
 		return;
@@ -2907,7 +2907,7 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
 					    sev_enc_bit));
 }
 
-void sev_es_prepare_guest_switch(struct vmcb_save_area *hostsa)
+void sev_es_prepare_switch_to_guest(struct vmcb_save_area *hostsa)
 {
 	/*
 	 * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a075c6458a27..7f70f456a5a5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -353,7 +353,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 
 }
 
-static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
+static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -401,7 +401,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 * raises a fault that is not intercepted. Still better than
 		 * failing in all cases.
 		 */
-		(void)skip_emulated_instruction(vcpu);
+		(void)svm_skip_emulated_instruction(vcpu);
 		rip = kvm_rip_read(vcpu);
 		svm->int3_rip = rip + svm->vmcb->save.cs.base;
 		svm->int3_injected = rip - old_rip;
@@ -873,11 +873,11 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void svm_hardware_teardown(void)
+static void svm_hardware_unsetup(void)
 {
 	int cpu;
 
-	sev_hardware_teardown();
+	sev_hardware_unsetup();
 
 	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
@@ -1175,7 +1175,7 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 	svm->vmcb = target_vmcb->ptr;
 }
 
-static int svm_create_vcpu(struct kvm_vcpu *vcpu)
+static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
 	struct page *vmcb01_page;
@@ -1246,7 +1246,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
 }
 
-static void svm_free_vcpu(struct kvm_vcpu *vcpu)
+static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -1265,7 +1265,7 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_pages(virt_to_page(svm->msrpm), get_order(MSRPM_SIZE));
 }
 
-static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
+static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
@@ -1285,7 +1285,7 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
 		struct vmcb_save_area *hostsa;
 		hostsa = (struct vmcb_save_area *)(page_address(sd->save_area) + 0x400);
 
-		sev_es_prepare_guest_switch(hostsa);
+		sev_es_prepare_switch_to_guest(hostsa);
 	}
 
 	if (tsc_scaling) {
@@ -2272,7 +2272,7 @@ static int task_switch_interception(struct kvm_vcpu *vcpu)
 	    int_type == SVM_EXITINTINFO_TYPE_SOFT ||
 	    (int_type == SVM_EXITINTINFO_TYPE_EXEPT &&
 	     (int_vec == OF_VECTOR || int_vec == BP_VECTOR))) {
-		if (!skip_emulated_instruction(vcpu))
+		if (!svm_skip_emulated_instruction(vcpu))
 			return 0;
 	}
 
@@ -3192,7 +3192,7 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		*error_code = 0;
 }
 
-static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
@@ -3289,7 +3289,7 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
-static void svm_set_irq(struct kvm_vcpu *vcpu)
+static void svm_inject_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -4199,7 +4199,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	 * by 0x400 (matches the offset of 'struct vmcb_save_area'
 	 * within 'struct vmcb'). Note: HSAVE area may also be used by
 	 * L1 hypervisor to save additional host context (e.g. KVM does
-	 * that, see svm_prepare_guest_switch()) which must be
+	 * that, see svm_prepare_switch_to_guest()) which must be
 	 * preserved.
 	 */
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
@@ -4467,21 +4467,21 @@ static int svm_vm_init(struct kvm *kvm)
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
-	.hardware_unsetup = svm_hardware_teardown,
+	.hardware_unsetup = svm_hardware_unsetup,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.cpu_has_accelerated_tpr = svm_cpu_has_accelerated_tpr,
 	.has_emulated_msr = svm_has_emulated_msr,
 
-	.vcpu_create = svm_create_vcpu,
-	.vcpu_free = svm_free_vcpu,
+	.vcpu_create = svm_vcpu_create,
+	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
 
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
 
-	.prepare_switch_to_guest = svm_prepare_guest_switch,
+	.prepare_switch_to_guest = svm_prepare_switch_to_guest,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
 	.vcpu_blocking = avic_vcpu_blocking,
@@ -4519,13 +4519,13 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
 	.vcpu_run = svm_vcpu_run,
-	.handle_exit = handle_exit,
-	.skip_emulated_instruction = skip_emulated_instruction,
+	.handle_exit = svm_handle_exit,
+	.skip_emulated_instruction = svm_skip_emulated_instruction,
 	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
-	.inject_irq = svm_set_irq,
+	.inject_irq = svm_inject_irq,
 	.inject_nmi = svm_inject_nmi,
 	.queue_exception = svm_queue_exception,
 	.cancel_injection = svm_cancel_injection,
@@ -4830,7 +4830,7 @@ static __init int svm_hardware_setup(void)
 	return 0;
 
 err:
-	svm_hardware_teardown();
+	svm_hardware_unsetup();
 	return r;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 67c17509c4c0..852b12aee03d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -321,7 +321,7 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 
 /*
  * Only the PDPTRs are loaded on demand into the shadow MMU.  All other
- * fields are synchronized in handle_exit, because accessing the VMCB is cheap.
+ * fields are synchronized on VM-Exit, because accessing the VMCB is cheap.
  *
  * CR3 might be out of date in the VMCB but it is not marked dirty; instead,
  * KVM_REQ_LOAD_MMU_PGD is always requested when the cached vcpu->arch.cr3
@@ -608,7 +608,7 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd);
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
-void sev_hardware_teardown(void);
+void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
@@ -616,7 +616,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
 void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
-void sev_es_prepare_guest_switch(struct vmcb_save_area *hostsa);
+void sev_es_prepare_switch_to_guest(struct vmcb_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
-- 
2.35.0.rc0.227.g00780c9af4-goog

