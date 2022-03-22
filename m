Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB574E4556
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 18:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbiCVRnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 13:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239865AbiCVRmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 13:42:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F5D3888E0
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 10:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647970881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yRZVgnhGNhp1SEmmju1ezoyCZEkfsIAzfhESgLEwrvA=;
        b=gPE2T06juXt/p8ckFx+wbscTOxcm+GiQw/WuiORWfbo9c/2opY6Cr/q/B5TXS06c082suy
        w2IpBlXBr8rLxU2NaKTaXCEdPFi8pY7AQo0XPGyyKnaN/ZXixNhZUGLamyR8zdt8+5DE/l
        OgGpcXq5OKZcsztHLtuSjwVlAM+Ekbk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-v9SZljw5P-ucCsTym0YxEQ-1; Tue, 22 Mar 2022 13:41:18 -0400
X-MC-Unique: v9SZljw5P-ucCsTym0YxEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 967DC85A5BE;
        Tue, 22 Mar 2022 17:41:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70E26C26E9B;
        Tue, 22 Mar 2022 17:41:14 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 6/6] KVM: x86: SVM: allow AVIC to co-exist with a nested guest running
Date:   Tue, 22 Mar 2022 19:40:50 +0200
Message-Id: <20220322174050.241850-7-mlevitsk@redhat.com>
In-Reply-To: <20220322174050.241850-1-mlevitsk@redhat.com>
References: <20220322174050.241850-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c   |  7 +++++++
 arch/x86/kvm/svm/nested.c | 17 ++++++++++-------
 arch/x86/kvm/svm/svm.c    | 30 +++++++++++++++++++-----------
 arch/x86/kvm/svm/svm.h    |  1 +
 4 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b39fe614467a..334fca06a3c8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -357,6 +357,13 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
+{
+	if (is_guest_mode(vcpu))
+		return APICV_INHIBIT_REASON_NESTED;
+	return 0;
+}
+
 static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
 {
 	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 47a5e8d8b578..26fd48603fab 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -619,13 +619,6 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
 	 */
 
-	/*
-	 * Also covers avic_vapic_bar, avic_backing_page, avic_logical_id,
-	 * avic_physical_id.
-	 */
-	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
-
-
 
 	if (svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
 		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
@@ -766,6 +759,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	svm_set_gif(svm, true);
 
+	if (kvm_vcpu_apicv_active(vcpu))
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+
 	return 0;
 }
 
@@ -1043,6 +1039,13 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (unlikely(vmcb01->save.rflags & X86_EFLAGS_TF))
 		kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
 
+	/*
+	 * Un-inhibit the AVIC right away, so that other vCPUs can start
+	 * to benefit from it right away.
+	 */
+	if (kvm_apicv_activated(vcpu->kvm))
+		kvm_vcpu_update_apicv(vcpu);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7fb4cf3bce4f..28d7a4aebafd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1468,7 +1468,7 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 	/*
 	 * The following fields are ignored when AVIC is enabled
 	 */
-	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
+	WARN_ON(kvm_vcpu_apicv_activated(&svm->vcpu));
 
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
@@ -2977,9 +2977,16 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	svm_clear_vintr(to_svm(vcpu));
 
 	/*
-	 * For AVIC, the only reason to end up here is ExtINTs.
+	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
 	 * In this case AVIC was temporarily disabled for
 	 * requesting the IRQ window and we have to re-enable it.
+	 *
+	 * If running nested, still remove the VM wide AVIC inhibit to
+	 * support case in which the interrupt window was requested when the
+	 * vCPU was not running nested.
+
+	 * All vCPUs which run still run nested, will remain to have their
+	 * AVIC still inhibited due to per-cpu AVIC inhibition.
 	 */
 	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
 
@@ -3574,10 +3581,16 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 		/*
 		 * IRQ window is not needed when AVIC is enabled,
 		 * unless we have pending ExtINT since it cannot be injected
-		 * via AVIC. In such case, we need to temporarily disable AVIC,
+		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
 		 * and fallback to injecting IRQ via V_IRQ.
+		 *
+		 * If running nested, AVIC is already locally inhibited
+		 * on this vCPU, therefore there is no need to request
+		 * the VM wide AVIC inhibition.
 		 */
-		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+		if (!is_guest_mode(vcpu))
+			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+
 		svm_set_vintr(svm);
 	}
 }
@@ -4048,13 +4061,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		 */
 		if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
 			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_X2APIC);
-
-		/*
-		 * Currently, AVIC does not work with nested virtualization.
-		 * So, we disable AVIC when cpuid for SVM is set in the L1 guest.
-		 */
-		if (nested && guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_NESTED);
 	}
 	init_vmcb_after_set_cpuid(vcpu);
 }
@@ -4717,6 +4723,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
 };
 
 /*
@@ -4918,6 +4925,7 @@ static __init int svm_hardware_setup(void)
 	} else {
 		svm_x86_ops.vcpu_blocking = NULL;
 		svm_x86_ops.vcpu_unblocking = NULL;
+		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
 	}
 
 	if (vls) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ba0c90bc5c55..c6db1fe17cbc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -622,6 +622,7 @@ int avic_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
 void avic_ring_doorbell(struct kvm_vcpu *vcpu);
+unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-- 
2.26.3

