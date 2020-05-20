Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852B81DBB4A
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgETRWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24508 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727819AbgETRWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=osxB5OVd+8V/5wuYjIIWK6D5QvfwU65EZsue7tkqQLQ=;
        b=imh20zeqakUzDU5Tpjmqs61XY0Bq8E04w4/zw69yGeU2AJ41CUI0u7Mzjwi+hQgfkDHWOO
        IeOBjljiX1H8MTND8HKEm8loNp/r0ZNMq5edU+AXtQLuINpaqUuuuDR+qp96ay+IbQffK4
        v/pd8g/t6op0W94COxeHP2jNOecuGOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-CtuufgVZNmS3Y9pTnZILuw-1; Wed, 20 May 2020 13:22:05 -0400
X-MC-Unique: CtuufgVZNmS3Y9pTnZILuw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 965A480B72E;
        Wed, 20 May 2020 17:22:03 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9362270461;
        Wed, 20 May 2020 17:22:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 14/24] KVM: nSVM: remove HF_VINTR_MASK
Date:   Wed, 20 May 2020 13:21:35 -0400
Message-Id: <20200520172145.23284-15-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the int_ctl field is stored in svm->nested.ctl.int_ctl, we can
use it instead of vcpu->arch.hflags to check whether L2 is running
in V_INTR_MASKING mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/nested.c       | 10 +++-------
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  4 +++-
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index db261da578f3..f1c4cb2d0541 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1594,7 +1594,6 @@ enum {
 
 #define HF_GIF_MASK		(1 << 0)
 #define HF_HIF_MASK		(1 << 1)
-#define HF_VINTR_MASK		(1 << 2)
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b6a1e1ff271e..9e4d24acadd7 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -118,7 +118,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
-	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
+	if (g->int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
 		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
 		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
@@ -276,10 +276,6 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm_flush_tlb(&svm->vcpu);
-	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
-		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
@@ -533,8 +529,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.event_inj         = 0;
 	nested_vmcb->control.event_inj_err     = 0;
 
-	/* We always set V_INTR_MASKING and remember the old value in hflags */
-	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
+	/* We always set V_INTR_MASKING and remember the old value in svm->nested */
+	if (!(svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK))
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ffb349739e0c..10c80c13b679 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3080,7 +3080,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
-		if ((svm->vcpu.arch.hflags & HF_VINTR_MASK)
+		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
 		    ? !(svm->vcpu.arch.hflags & HF_HIF_MASK)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index dd5418f20256..73986f96ba2a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -366,7 +366,9 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 
 static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 {
-	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return is_guest_mode(vcpu) && (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK);
 }
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
-- 
2.18.2


