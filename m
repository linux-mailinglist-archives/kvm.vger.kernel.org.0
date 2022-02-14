Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612FC4B5158
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354090AbiBNNQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:16:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354058AbiBNNQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:16:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C54D11F
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644844579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ehKQ+aC0ZDuNiHNtEQTAVlvj/qNFW9IRpYaxY//dgh0=;
        b=ApwIpvCmZ8qFkI42t+gkrnEy3DIKGZW56nHjevZYcX9b8k5C1H//KzNSBscuNBwhQC4qzp
        gojfH2nL4FFEUuLMKkBa7wV6pRRz0kxZBe8na3P1XnF+/W/dPBUqk21aeW3rN+V4g+6V44
        WT7Kg3kCK+trqIXFalM0YJaV/NvhP1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-yf3HOpeLNG-0kOX5Usy6Wg-1; Mon, 14 Feb 2022 08:16:18 -0500
X-MC-Unique: yf3HOpeLNG-0kOX5Usy6Wg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92818344E0;
        Mon, 14 Feb 2022 13:16:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 436AA106F75B;
        Mon, 14 Feb 2022 13:16:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 4/5] KVM: x86: make several APIC virtualization callbacks optional
Date:   Mon, 14 Feb 2022 08:16:13 -0500
Message-Id: <20220214131614.3050333-5-pbonzini@redhat.com>
In-Reply-To: <20220214131614.3050333-1-pbonzini@redhat.com>
References: <20220214131614.3050333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM does not need most of them, and there's no need for vendors to
support APIC virtualization to be supported in KVM, so mark them as
optional and delete the implementation.

For consistency, apicv_post_state_restore is also marked as optional
and called with static_call_cond, even though it is implemented for
both Intel APICv and AMD AVIC.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 10 +++++-----
 arch/x86/kvm/lapic.c               | 24 ++++++++++--------------
 arch/x86/kvm/svm/avic.c            | 18 ------------------
 arch/x86/kvm/svm/svm.c             |  4 ----
 arch/x86/kvm/svm/svm.h             |  1 -
 arch/x86/kvm/x86.c                 |  4 ++--
 6 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9415d9af204c..0a074354aaf7 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -74,11 +74,11 @@ KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_OPTIONAL(update_cr8_intercept)
 KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP(hwapic_irr_update)
-KVM_X86_OP(hwapic_isr_update)
+KVM_X86_OP_OPTIONAL(hwapic_irr_update)
+KVM_X86_OP_OPTIONAL(hwapic_isr_update)
 KVM_X86_OP_OPTIONAL(guest_apic_has_interrupt)
-KVM_X86_OP(load_eoi_exitmap)
-KVM_X86_OP(set_virtual_apic_mode)
+KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
+KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
 KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
@@ -101,7 +101,7 @@ KVM_X86_OP_OPTIONAL(vcpu_blocking)
 KVM_X86_OP_OPTIONAL(vcpu_unblocking)
 KVM_X86_OP_OPTIONAL(pi_update_irte)
 KVM_X86_OP_OPTIONAL(pi_start_assignment)
-KVM_X86_OP(apicv_post_state_restore)
+KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
 KVM_X86_OP_OPTIONAL(dy_apicv_has_pending_interrupt)
 KVM_X86_OP_OPTIONAL(set_hv_timer)
 KVM_X86_OP_OPTIONAL(cancel_hv_timer)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index dd4e2888c244..47f8606559a9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -492,8 +492,7 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	if (unlikely(vcpu->arch.apicv_active)) {
 		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		static_call(kvm_x86_hwapic_irr_update)(vcpu,
-				apic_find_highest_irr(apic));
+		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
@@ -523,7 +522,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 	 * just set SVI.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		static_call(kvm_x86_hwapic_isr_update)(vcpu, vec);
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, vec);
 	else {
 		++apic->isr_count;
 		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
@@ -571,8 +570,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(vcpu->arch.apicv_active))
-		static_call(kvm_x86_hwapic_isr_update)(vcpu,
-						apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2288,7 +2286,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
 		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
 
 	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
-		static_call(kvm_x86_set_virtual_apic_mode)(vcpu);
+		static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
 
 	apic->base_address = apic->vcpu->arch.apic_base &
 			     MSR_IA32_APICBASE_BASE;
@@ -2374,9 +2372,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
-		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
-		static_call(kvm_x86_hwapic_isr_update)(vcpu, -1);
+		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -2639,11 +2637,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
-		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call(kvm_x86_hwapic_irr_update)(vcpu,
-				apic_find_highest_irr(apic));
-		static_call(kvm_x86_hwapic_isr_update)(vcpu,
-				apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index abd0e664bf22..4245cb99b497 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -586,19 +586,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
-{
-	return;
-}
-
-void avic_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)
-{
-}
-
-void avic_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
-{
-}
-
 static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
 {
 	int ret = 0;
@@ -663,11 +650,6 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	avic_set_pi_irte_mode(vcpu, activated);
 }
 
-void avic_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
-{
-	return;
-}
-
 bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 {
 	return false;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4243bb355db0..4fa385490f22 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4595,12 +4595,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.enable_nmi_window = svm_enable_nmi_window,
 	.enable_irq_window = svm_enable_irq_window,
 	.update_cr8_intercept = svm_update_cr8_intercept,
-	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
-	.load_eoi_exitmap = avic_load_eoi_exitmap,
-	.hwapic_irr_update = avic_hwapic_irr_update,
-	.hwapic_isr_update = avic_hwapic_isr_update,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
 	.set_tss_addr = svm_set_tss_addr,
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c1f0cc4a9369..4f90d1f673b5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -581,7 +581,6 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
 bool avic_check_apicv_inhibit_reasons(ulong bit);
-void avic_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 void avic_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
 void avic_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
 bool avic_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6f5c6454f11..c921d68fc244 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9765,11 +9765,11 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 		bitmap_or((ulong *)eoi_exit_bitmap,
 			  vcpu->arch.ioapic_handled_vectors,
 			  to_hv_synic(vcpu)->vec_bitmap, 256);
-		static_call(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
+		static_call_cond(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
 		return;
 	}
 
-	static_call(kvm_x86_load_eoi_exitmap)(
+	static_call_cond(kvm_x86_load_eoi_exitmap)(
 		vcpu, (u64 *)vcpu->arch.ioapic_handled_vectors);
 }
 
-- 
2.31.1


