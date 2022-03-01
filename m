Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D494C9311
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 19:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236911AbiCAS2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 13:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbiCAS2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 13:28:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B01422BE5
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 10:27:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646159250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xe7mzF67C8/j22oigWqxz9CvwN7UQJwMtwuK4nLwaug=;
        b=TbZpx6Cv5CJ5V5oCHGAZhb002XP5pVTbijmjJeVpqtL+fviNRRW5rfAIbC+LdS+QbnvJnr
        T87T0b0FnFfXHy9X9TEBVA88kUxKYbfIfo9ZvsqZVInanCYr6DGd7j5iM7BuLEvitsxIJ0
        1Gu9f1EahECjfcpFVDBrvJVqkZ+gVgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-GczLqR77NlqRgfArR0taIQ-1; Tue, 01 Mar 2022 13:27:27 -0500
X-MC-Unique: GczLqR77NlqRgfArR0taIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66BD81854E21;
        Tue,  1 Mar 2022 18:27:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBC3C86C49;
        Tue,  1 Mar 2022 18:27:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        x86@kernel.org, intel-gvt-dev@lists.freedesktop.org,
        Joerg Roedel <joro@8bytes.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        dri-devel@lists.freedesktop.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 02/11] KVM: x86: SVM: allow AVIC to co-exist with a nested guest running
Date:   Tue,  1 Mar 2022 20:26:30 +0200
Message-Id: <20220301182639.559568-3-mlevitsk@redhat.com>
In-Reply-To: <20220301182639.559568-1-mlevitsk@redhat.com>
References: <20220301182639.559568-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inhibit the AVIC of the vCPU that is running nested for the duration of the
nested run, so that all interrupts arriving from both its vCPU siblings
and from KVM are delivered using normal IPIs and cause that vCPU to vmexit.

Note that unlike normal AVIC inhibition, there is no need to
update the AVIC mmio memslot, because the nested guest uses its
own set of paging tables.
That also means that AVIC doesn't need to be inhibited VM wide.

Note that in the theory when a nested guest doesn't intercept
physical interrupts, we could continue using AVIC to deliver them
to it but don't bother doing so for now. Plus when nested AVIC
is implemented, the nested guest will likely use it, which will
not allow this optimization to be used

(can't use real AVIC to support both L1 and L2 at the same time)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  7 ++++++-
 arch/x86/kvm/svm/avic.c            |  6 +++++-
 arch/x86/kvm/svm/nested.c          | 15 ++++++++++-----
 arch/x86/kvm/svm/svm.c             | 31 +++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h             |  1 +
 arch/x86/kvm/x86.c                 | 15 +++++++++++++--
 7 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 29affccb353cd..eb16e32117610 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -126,6 +126,7 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
+KVM_X86_OP_OPTIONAL_RET0(vcpu_has_apicv_inhibit_condition);
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ccec837e520d8..efe7414361de8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1039,7 +1039,6 @@ struct kvm_x86_msr_filter {
 
 #define APICV_INHIBIT_REASON_DISABLE    0
 #define APICV_INHIBIT_REASON_HYPERV     1
-#define APICV_INHIBIT_REASON_NESTED     2
 #define APICV_INHIBIT_REASON_IRQWIN     3
 #define APICV_INHIBIT_REASON_PIT_REINJ  4
 #define APICV_INHIBIT_REASON_X2APIC	5
@@ -1490,6 +1489,12 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+
+	/*
+	 * Returns true if for some reason APICv (e.g guest mode)
+	 * must be inhibited on this vCPU
+	 */
+	bool (*vcpu_has_apicv_inhibit_condition)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index aea0b13773fd3..d5ce0868c5a74 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -357,6 +357,11 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+bool avic_has_vcpu_inhibit_condition(struct kvm_vcpu *vcpu)
+{
+	return is_guest_mode(vcpu);
+}
+
 static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
@@ -859,7 +864,6 @@ bool avic_check_apicv_inhibit_reasons(ulong bit)
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_NESTED) |
 			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 62cda8ae71bbc..6dffa6c661493 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -575,11 +575,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
 	 */
 
-	/*
-	 * Also covers avic_vapic_bar, avic_backing_page, avic_logical_id,
-	 * avic_physical_id.
-	 */
-	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
 
 	/* Copied from vmcb01.  msrpm_base can be overwritten later.  */
 	svm->vmcb->control.nested_ctl = svm->vmcb01.ptr->control.nested_ctl;
@@ -683,6 +678,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	svm_set_gif(svm, true);
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	return 0;
 }
 
@@ -947,6 +945,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (unlikely(svm->vmcb->save.rflags & X86_EFLAGS_TF))
 		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
 
+	/*
+	 * Un-inhibit the AVIC right away, so that other vCPUs can start
+	 * to benefit from VM-exit less IPI right away
+	 */
+	if (kvm_apicv_activated(vcpu->kvm))
+		kvm_vcpu_update_apicv(vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa8410..08ccf0db91f72 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1393,7 +1393,8 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 	/*
 	 * The following fields are ignored when AVIC is enabled
 	 */
-	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
+	if (!is_guest_mode(&svm->vcpu))
+		WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
 
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
@@ -2899,10 +2900,16 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	svm_clear_vintr(to_svm(vcpu));
 
 	/*
-	 * For AVIC, the only reason to end up here is ExtINTs.
+	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
 	 * In this case AVIC was temporarily disabled for
 	 * requesting the IRQ window and we have to re-enable it.
+	 *
+	 * If running nested, still uninhibit the AVIC in case irq window
+	 * was requested when it was not running nested.
+	 * All vCPUs which run nested will have their AVIC still
+	 * inhibited due to AVIC inhibition override for that.
 	 */
+
 	kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_IRQWIN);
 
 	++vcpu->stat.irq_window_exits;
@@ -3500,8 +3507,16 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 		 * unless we have pending ExtINT since it cannot be injected
 		 * via AVIC. In such case, we need to temporarily disable AVIC,
 		 * and fallback to injecting IRQ via V_IRQ.
+		 *
+		 * If running nested, this vCPU will use separate page tables
+		 * which don't have L1's AVIC mapped, and the AVIC is
+		 * already inhibited thus there is no need for global
+		 * AVIC inhibition.
 		 */
-		kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_IRQWIN);
+
+		if (!is_guest_mode(vcpu))
+			kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_IRQWIN);
+
 		svm_set_vintr(svm);
 	}
 }
@@ -3956,14 +3971,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
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
@@ -4625,6 +4632,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+	.vcpu_has_apicv_inhibit_condition = avic_has_vcpu_inhibit_condition,
 };
 
 /*
@@ -4808,6 +4816,7 @@ static __init int svm_hardware_setup(void)
 	} else {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
+		svm_x86_ops.vcpu_has_apicv_inhibit_condition = NULL;
 	}
 
 	if (vls) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c8dedc4a068d2..3ef2681244e84 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -595,6 +595,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
+bool avic_has_vcpu_inhibit_condition(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c712c33c1521f..14b964eb079e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9681,6 +9681,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
+static bool vcpu_has_apicv_inhibit_condition(struct kvm_vcpu *vcpu)
+{
+	return static_call(kvm_x86_vcpu_has_apicv_inhibit_condition)(vcpu);
+}
+
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
 	bool activate;
@@ -9690,7 +9695,9 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 
 	down_read(&vcpu->kvm->arch.apicv_update_lock);
 
-	activate = kvm_apicv_activated(vcpu->kvm);
+	activate = kvm_apicv_activated(vcpu->kvm) &&
+		   !vcpu_has_apicv_inhibit_condition(vcpu);
+
 	if (vcpu->arch.apicv_active == activate)
 		goto out;
 
@@ -10091,7 +10098,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 * per-VM state, and responsing vCPUs must wait for the update
 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
 		 */
-		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
+		if (vcpu_has_apicv_inhibit_condition(vcpu))
+			WARN_ON_ONCE(kvm_vcpu_apicv_active(vcpu));
+		else
+			WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
+
 
 		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
-- 
2.26.3

