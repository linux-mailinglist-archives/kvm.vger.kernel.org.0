Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C778E4A77BC
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiBBSSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:18:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346402AbiBBSST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 13:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643825898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfsD89RXkHNrOo3rdM2WwXKnhzWTYXgov/7DgzmxMHk=;
        b=OP17KHpLWG0imm66TBOyPYV91ttUFYI698Ei9FEDIIttdZZ2Ve3hojlpQtyneeCcbvv3r3
        XEtI0HmF3YF2swL+uXykwDEEKrcF9/R7LOxRKxO05TbGnzuhjEpxpdUczRFQfatx8F6CCh
        lN+AeHyL8bn0i9nUeoj1LHvrKTjJwzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282-WiEVCwneMGS54nEoUOwXMg-1; Wed, 02 Feb 2022 13:18:17 -0500
X-MC-Unique: WiEVCwneMGS54nEoUOwXMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DEA1180FD62;
        Wed,  2 Feb 2022 18:18:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E1E87745F;
        Wed,  2 Feb 2022 18:18:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 4/5] KVM: x86: change hwapic_{irr,isr}_update to NULLable calls
Date:   Wed,  2 Feb 2022 13:18:12 -0500
Message-Id: <20220202181813.1103496-5-pbonzini@redhat.com>
In-Reply-To: <20220202181813.1103496-1-pbonzini@redhat.com>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM does not need them, so mark them as optional.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  4 ++--
 arch/x86/kvm/lapic.c               | 18 +++++++-----------
 arch/x86/kvm/svm/avic.c            |  8 --------
 arch/x86/kvm/svm/svm.c             |  2 --
 4 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index a842f10f5778..843bd9efd2ae 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -74,8 +74,8 @@ KVM_X86_OP(enable_irq_window)
 KVM_X86_OP_NULL(update_cr8_intercept)
 KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP(hwapic_irr_update)
-KVM_X86_OP(hwapic_isr_update)
+KVM_X86_OP_NULL(hwapic_irr_update)
+KVM_X86_OP_NULL(hwapic_isr_update)
 KVM_X86_OP_NULL(guest_apic_has_interrupt)
 KVM_X86_OP(load_eoi_exitmap)
 KVM_X86_OP(set_virtual_apic_mode)
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 09bbb6a01c1d..fd10dd070d26 100644
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
@@ -2370,8 +2368,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
-		static_call(kvm_x86_hwapic_isr_update)(vcpu, -1);
+		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, -1);
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, -1);
 	}
 
 	vcpu->arch.apic_arb_prio = 0;
@@ -2635,10 +2633,8 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
 		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call(kvm_x86_hwapic_irr_update)(vcpu,
-				apic_find_highest_irr(apic));
-		static_call(kvm_x86_hwapic_isr_update)(vcpu,
-				apic_find_highest_isr(apic));
+		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
+		static_call_cond(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 99f907ec5aa8..b49ee6f34fe7 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -592,14 +592,6 @@ void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 	return;
 }
 
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7f70f456a5a5..ab50d73b1e2e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4540,8 +4540,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
 	.load_eoi_exitmap = avic_load_eoi_exitmap,
-	.hwapic_irr_update = avic_hwapic_irr_update,
-	.hwapic_isr_update = avic_hwapic_isr_update,
 	.apicv_post_state_restore = avic_apicv_post_state_restore,
 
 	.set_tss_addr = svm_set_tss_addr,
-- 
2.31.1


