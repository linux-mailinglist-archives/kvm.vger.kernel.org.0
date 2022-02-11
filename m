Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0E74B23D6
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343651AbiBKLB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:01:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349277AbiBKLBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:01:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7770FD57
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644577281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HbCq9HJ8rOhlcUl0t+RPa0U4m8SExi/yPyb/lnSUVQQ=;
        b=EeKmQdLjKFKZ5vcVV7tsg++LXqooYzOya3PiJ5+NAt7KsVzSLK+XFZnvS3UL+OK4p4UKBP
        0IiG532PJ8w2iTNCJgUVz3iW1MZV9gfv2rcC11n0JWHd4WMVZn1AA3f5S9MFgi9yLx6vqY
        NnBdbTWeH3ljs8ek9Cj5V/mth4apXVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-dLumQZiNM7qhm116BiJr4g-1; Fri, 11 Feb 2022 06:01:20 -0500
X-MC-Unique: dLumQZiNM7qhm116BiJr4g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 734FE84B9A4;
        Fri, 11 Feb 2022 11:01:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 171DF7C0D7;
        Fri, 11 Feb 2022 11:01:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 3/3] KVM: SVM: fix race between interrupt delivery and AVIC inhibition
Date:   Fri, 11 Feb 2022 06:01:17 -0500
Message-Id: <20220211110117.2764381-4-pbonzini@redhat.com>
In-Reply-To: <20220211110117.2764381-1-pbonzini@redhat.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

If svm_deliver_avic_intr is called just after the target vcpu's AVIC got
inhibited, it might read a stale value of vcpu->arch.apicv_active
which can lead to the target vCPU not noticing the interrupt.

To fix this use load-acquire/store-release so that, if the target vCPU
is IN_GUEST_MODE, we're guaranteed to see a previous disabling of the
AVIC.  If AVIC has been disabled in the meanwhile, proceed with the
KVM_REQ_EVENT-based delivery.

Incomplete IPI vmexit has the same races as svm_deliver_avic_intr, and
in fact it can be handled in exactly the same way; the only difference
lies in who has set IRR, whether svm_deliver_interrupt or the processor.
Therefore, svm_complete_interrupt_delivery can be used to fix incomplete
IPI vmexits as well.

Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 48 +++++++----------------------------------
 arch/x86/kvm/svm/svm.c  | 48 +++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.h  |  4 +++-
 arch/x86/kvm/x86.c      |  4 +++-
 4 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 1e1890721634..c32c46b15cb9 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -270,7 +270,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 }
 
 
-static void avic_ring_doorbell(struct kvm_vcpu *vcpu)
+void avic_ring_doorbell(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * Note, the vCPU could get migrated to a different pCPU at any
@@ -302,8 +302,13 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
 					GET_APIC_DEST_FIELD(icrh),
-					icrl & APIC_DEST_MASK))
-			kvm_vcpu_wake_up(vcpu);
+					icrl & APIC_DEST_MASK)) {
+			vcpu->arch.apic->irr_pending = true;
+			svm_complete_interrupt_delivery(vcpu,
+							icrl & APIC_MODE_MASK,
+							icrl & APIC_INT_LEVELTRIG,
+							icrl & APIC_VECTOR_MASK);
+		}
 	}
 }
 
@@ -665,43 +670,6 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	return;
 }
 
-int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
-{
-	if (!vcpu->arch.apicv_active)
-		return -1;
-
-	/*
-	 * Pairs with the smp_mb_*() after setting vcpu->guest_mode in
-	 * vcpu_enter_guest() to ensure the write to the vIRR is ordered before
-	 * the read of guest_mode, which guarantees that either VMRUN will see
-	 * and process the new vIRR entry, or that the below code will signal
-	 * the doorbell if the vCPU is already running in the guest.
-	 */
-	smp_mb__after_atomic();
-
-	/*
-	 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
-	 * is in the guest.  If the vCPU is not in the guest, hardware will
-	 * automatically process AVIC interrupts at VMRUN.
-	 */
-	if (vcpu->mode == IN_GUEST_MODE) {
-		/*
-		 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
-		 * is in the guest.  If the vCPU is not in the guest, hardware will
-		 * automatically process AVIC interrupts at VMRUN.
-		 */
-		avic_ring_doorbell(vcpu);
-	} else {
-		/*
-		 * Wake the vCPU if it was blocking.  KVM will then detect the
-		 * pending IRQ when checking if the vCPU has a wake event.
-		 */
-		kvm_vcpu_wake_up(vcpu);
-	}
-
-	return 0;
-}
-
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd769ff8af16..2ad158b27e91 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3299,21 +3299,55 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
-static void svm_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-				  int trig_mode, int vector)
+void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
+				     int trig_mode, int vector)
 {
-	struct kvm_vcpu *vcpu = apic->vcpu;
+	/*
+	 * vcpu->arch.apicv_active must be read after vcpu->mode.
+	 * Pairs with smp_store_release in vcpu_enter_guest.
+	 */
+	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
 
-	kvm_lapic_set_irr(vector, apic);
-	if (svm_deliver_avic_intr(vcpu, vector)) {
+	if (!READ_ONCE(vcpu->arch.apicv_active)) {
+		/* Process the interrupt with a vmexit.  */
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_vcpu_kick(vcpu);
+		return;
+	}
+
+	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
+	if (in_guest_mode) {
+		/*
+		 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
+		 * is in the guest.  If the vCPU is not in the guest, hardware will
+		 * automatically process AVIC interrupts at VMRUN.
+		 */
+		avic_ring_doorbell(vcpu);
 	} else {
-		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
-					   trig_mode, vector);
+		/*
+		 * Wake the vCPU if it was blocking.  KVM will then detect the
+		 * pending IRQ when checking if the vCPU has a wake event.
+		 */
+		kvm_vcpu_wake_up(vcpu);
 	}
 }
 
+static void svm_deliver_interrupt(struct kvm_lapic *apic,  int delivery_mode,
+				  int trig_mode, int vector)
+{
+	kvm_lapic_set_irr(vector, apic);
+
+	/*
+	 * Pairs with the smp_mb_*() after setting vcpu->guest_mode in
+	 * vcpu_enter_guest() to ensure the write to the vIRR is ordered before
+	 * the read of guest_mode.  This guarantees that either VMRUN will see
+	 * and process the new vIRR entry, or that svm_complete_interrupt_delivery
+	 * will signal the doorbell if the CPU has already performed vmentry.
+	 */
+	smp_mb__after_atomic();
+	svm_complete_interrupt_delivery(apic->vcpu, delivery_mode, trig_mode, vector);
+}
+
 static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 8cc45f27fcbd..dd895f0f5569 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -489,6 +489,8 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 int svm_invoke_exit_handler(struct kvm_vcpu *vcpu, u64 exit_code);
 void set_msr_interception(struct kvm_vcpu *vcpu, u32 *msrpm, u32 msr,
 			  int read, int write);
+void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
+		  int trig_mode, int vec);
 
 /* nested.c */
 
@@ -572,12 +574,12 @@ bool svm_check_apicv_inhibit_reasons(ulong bit);
 void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
-int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
 bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		       uint32_t guest_irq, bool set);
 void avic_vcpu_blocking(struct kvm_vcpu *vcpu);
 void avic_vcpu_unblocking(struct kvm_vcpu *vcpu);
+void avic_ring_doorbell(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7131d735b1ef..641044db415d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9983,7 +9983,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	 * result in virtual interrupt delivery.
 	 */
 	local_irq_disable();
-	vcpu->mode = IN_GUEST_MODE;
+
+	/* Store vcpu->apicv_active before vcpu->mode.  */
+	smp_store_release(&vcpu->mode, IN_GUEST_MODE);
 
 	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
-- 
2.31.1

