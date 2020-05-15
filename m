Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BB11D5829
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgEORlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:41:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30585 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEORly (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 May 2020 13:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589564513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=sT1ECfXJbWwVfrF28gOik3nME7pz8YvamFdmjiZK1Ic=;
        b=S8SZsqtN6TLRSgSnn/ibs6XquTd8kDQkVPNuMdDiINhruMqvW517Zy+NHs1Y9qH7qsDkm9
        ChwOCDX+WFSD4nijIM836q/u0l7VZgttx3sJMwThMPrZLs66kQFQGLP+Nju6szoQiXd7S8
        Kd2K9kbVjc9ZkjcM+MP4mJndXQVwjvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-bt3yTyiuPcW5WvIgd35C8Q-1; Fri, 15 May 2020 13:41:51 -0400
X-MC-Unique: bt3yTyiuPcW5WvIgd35C8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E2DF108BD09;
        Fri, 15 May 2020 17:41:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C734710002CD;
        Fri, 15 May 2020 17:41:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 5/7] KVM: nSVM: remove HF_VINTR_MASK
Date:   Fri, 15 May 2020 13:41:42 -0400
Message-Id: <20200515174144.1727-6-pbonzini@redhat.com>
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the int_ctl field is stored in svm->nested.int_ctl, we can
use it instead of vcpu->arch.hflags.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/svm/nested.c       | 12 ++++--------
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/svm/svm.h          |  4 +++-
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fd78bd44b2d6..6c8417d01bf9 100644
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
index 54be341322d8..e3338aa8b0a3 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -116,13 +116,13 @@ void recalc_intercepts(struct vcpu_svm *svm)
 	c->intercept_exceptions = h->intercept_exceptions;
 	c->intercept = h->intercept;
 
-	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
+	if (svm->nested.int_ctl & V_INTR_MASKING_MASK) {
 		/* We only want the cr8 intercept bits of L1 */
 		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
 		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
 
 		/*
-		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF does not
+		 * Once running L2 with V_INTR_MASKING set, EFLAGS.IF does not
 		 * affect any interrupt we may want to inject; therefore,
 		 * interrupt window vmexits are irrelevant to L0.
 		 */
@@ -297,10 +297,6 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm_flush_tlb(&svm->vcpu);
-	if (svm->nested.int_ctl & V_INTR_MASKING_MASK)
-		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset;
 
@@ -553,8 +549,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
-	/* We always set V_INTR_MASKING and remember the old value in hflags */
-	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
+	/* We always set V_INTR_MASKING and remember the old value in svm->nested */
+	if (!(svm->nested.int_ctl & V_INTR_MASKING_MASK))
 		nested_vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 	/* Restore the original control entries */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2b63d15328ba..95d16aa76ebb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3096,7 +3096,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
-		if ((svm->vcpu.arch.hflags & HF_VINTR_MASK)
+		if ((svm->nested.int_ctl & V_INTR_MASKING_MASK)
 		    ? !(svm->vcpu.arch.hflags & HF_HIF_MASK)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5cabed9c733a..39706aa845f2 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -388,7 +388,9 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu);
 
 static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 {
-	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return is_guest_mode(vcpu) && (svm->nested.int_ctl & V_INTR_MASKING_MASK);
 }
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
-- 
2.18.2


