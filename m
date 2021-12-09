Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDB5B46E7DB
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhLIL70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:59:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29942 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237031AbhLIL7Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zk9QjFxoV1xlk7jSl5mwCNk751nlBMfOOeWulJf6EwA=;
        b=IPcQIT246Z/hPmqhiBG00irXAfhV3DEeHt6vajTrNHjbU9qouB6CayXnT9C21ifZj2Z/SV
        UTNVC1edc2AFNvtFN7hBVK8JeDHum5GMr1pANGIGAyjy3E9mfIrlPv55ts2qjKv3az8r/B
        DhI4cz8EZQHbQjO2FWmGbktW0K1Fxi8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-q8f7dd-YPNObiGugj3jP5g-1; Thu, 09 Dec 2021 06:55:45 -0500
X-MC-Unique: q8f7dd-YPNObiGugj3jP5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EAFD760C0;
        Thu,  9 Dec 2021 11:55:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0170567840;
        Thu,  9 Dec 2021 11:55:39 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 6/6] KVM: SVM: allow AVIC to co-exist with a nested guest running
Date:   Thu,  9 Dec 2021 13:54:40 +0200
Message-Id: <20211209115440.394441-7-mlevitsk@redhat.com>
In-Reply-To: <20211209115440.394441-1-mlevitsk@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inhibit the AVIC of the vCPU that is running nested for the
duration of the nested run, so that all interrupts arriving
from both its vCPU siblings and from KVM are delivered using
normal IPIs and cause that vCPU to vmexit.

Note that in the theory when a nested guest doesn't intercept
physical interrupts, we could continue using AVIC to deliver them
to it but don't bother doing so for now.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 ++++++-
 arch/x86/kvm/svm/avic.c            |  6 +++++-
 arch/x86/kvm/svm/nested.c          | 13 +++++++------
 arch/x86/kvm/svm/svm.c             | 26 ++++++++++++++------------
 arch/x86/kvm/svm/svm.h             |  1 +
 arch/x86/kvm/x86.c                 | 14 +++++++++++++-
 7 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cefe1d81e2e8..c531dc0fca11 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -121,6 +121,7 @@ KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP_NULL(apicv_check_inhibit);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d5fede05eb5f..a0f17d5284e6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1036,7 +1036,6 @@ struct kvm_x86_msr_filter {
 
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
-#define APICV_INHIBIT_REASON_NESTED     2
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
 #define APICV_INHIBIT_REASON_X2APIC	5
@@ -1498,6 +1497,12 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+
+	/*
+	 * Returns false if for some reason APICv (e.g guest mode)
+	 * must be inhibited on this vCPU
+	 */
+	bool (*apicv_check_inhibit)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index bdfc37caa64a..c0550f505c7e 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -734,6 +734,11 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 	return 0;
 }
 
+bool avic_is_vcpu_inhibited(struct kvm_vcpu *vcpu)
+{
+	return is_guest_mode(vcpu);
+}
+
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	return false;
@@ -950,7 +955,6 @@ bool svm_check_apicv_inhibit_reasons(ulong bit)
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cf206855ebf0..cd07049670c9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -551,12 +551,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
 	 */
 
-	/*
-	 * Also covers avic_vapic_bar, avic_backing_page, avic_logical_id,
-	 * avic_physical_id.
-	 */
-	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
-
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
 	svm->vmcb->control.iopm_base_pa = svm->vmcb01.ptr->control.iopm_base_pa;
@@ -659,6 +653,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	svm_set_gif(svm, true);
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	return 0;
 }
 
@@ -697,6 +694,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 
 	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
+
 	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
 
 	if (!nested_vmcb_check_save(vcpu) ||
@@ -923,6 +921,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (unlikely(svm->vmcb->save.rflags & X86_EFLAGS_TF))
 		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
 
+	if (kvm_apicv_activated(vcpu->kvm))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6fbce42b9776..ab70ee8e1b8c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1620,7 +1620,8 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 	/*
 	 * The following fields are ignored when AVIC is enabled
 	 */
-	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
+	if (!is_guest_mode(&svm->vcpu))
+		WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
 
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
@@ -3090,11 +3091,16 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	svm_clear_vintr(to_svm(vcpu));
 
 	/*
-	 * For AVIC, the only reason to end up here is ExtINTs.
+	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
 	 * In this case AVIC was temporarily disabled for
 	 * requesting the IRQ window and we have to re-enable it.
+	 *
+	 * If running nested, this vCPU has avic inhibited during the
+	 * nested run, and can use the IRQ window
 	 */
-	kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_IRQWIN);
+
+	if (!is_guest_mode(vcpu))
+		kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_IRQWIN);
 
 	++vcpu->stat.irq_window_exits;
 	return 1;
@@ -3644,7 +3650,10 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 		 * via AVIC. In such case, we need to temporarily disable AVIC,
 		 * and fallback to injecting IRQ via V_IRQ.
 		 */
-		kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_IRQWIN);
+
+		if (!is_guest_mode(vcpu))
+			kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_IRQWIN);
+
 		svm_set_vintr(svm);
 	}
 }
@@ -4114,14 +4123,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
 			kvm_request_apicv_update(vcpu->kvm, false,
 						 APICV_INHIBIT_REASON_X2APIC);
-
-		/*
-		 * Currently, AVIC does not work with nested virtualization.
-		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
-		 */
-		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			kvm_request_apicv_update(vcpu->kvm, false,
-						 APICV_INHIBIT_REASON_NESTED);
 	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
@@ -4719,6 +4720,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+	.apicv_check_inhibit = avic_is_vcpu_inhibited,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 83ced47fa9b9..2b628e9bc5c9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -590,6 +590,7 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
+bool avic_is_vcpu_inhibited(struct kvm_vcpu *vcpu);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ca037ac2ea08..00ec878c5872 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9161,6 +9161,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 		r = kvm_check_nested_events(vcpu);
 		if (r < 0)
 			goto out;
+
+		/* Nested VM exit might need to update APICv status */
+		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
+			kvm_vcpu_update_apicv(vcpu);
 	}
 
 	/* try to inject new event if pending */
@@ -9538,6 +9542,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
 	activate = kvm_apicv_activated(vcpu->kvm);
+
+	if (kvm_x86_ops.apicv_check_inhibit)
+		activate = activate && !kvm_x86_ops.apicv_check_inhibit(vcpu);
+
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
 
@@ -9578,6 +9586,7 @@ void __kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 
 	if (!!old != !!new) {
 		trace_kvm_apicv_update_request(activate, bit);
+
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
 		 * false positives in the sanity check WARN in svm_vcpu_run().
@@ -9932,7 +9941,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 * per-VM state, and responsing vCPUs must wait for the update
 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
 		 */
-		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
+		if (!is_guest_mode(vcpu))
+			WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
+		else
+			WARN_ON(kvm_vcpu_apicv_active(vcpu));
 
 		exit_fastpath = static_call(kvm_x86_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
-- 
2.26.3

