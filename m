Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2144C1E821C
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgE2Pkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:41 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36702 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727995AbgE2Pjx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StoEXxV2eBHV8Zykyiia/2jSDrCiXWnuEsF3ZdEOZLM=;
        b=UGiGK6Zmrin8QbC3qaJpMGlr5jZseAndcTrIVisg9UV8Lbhff+YUpcDK46HeWv+eQ5XlxI
        i24M+uGQmP9BU5rP/XrKwxNBijLYmuOyCKEzFGOHw6zUCnVrWBBc/nfimA9A6RJZxiIP2f
        jlrrZBRQTabXIrljFm6iLClqkAfV/80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-jDINxDEcNISrWQt2Z7rqcA-1; Fri, 29 May 2020 11:39:48 -0400
X-MC-Unique: jDINxDEcNISrWQt2Z7rqcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F19B107ACCA;
        Fri, 29 May 2020 15:39:47 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3996810013C2;
        Fri, 29 May 2020 15:39:47 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 22/30] KVM: nSVM: remove HF_VINTR_MASK
Date:   Fri, 29 May 2020 11:39:26 -0400
Message-Id: <20200529153934.11694-23-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the int_ctl field is stored in svm->nested.ctl.int_ctl, we can
use it instead of vcpu->arch.hflags to check whether L2 is running
in V_INTR_MASKING mode.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/svm/nested.c       | 6 +-----
 arch/x86/kvm/svm/svm.c          | 2 +-
 arch/x86/kvm/svm/svm.h          | 4 +++-
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e6f2e1a2dab6..0dfc522f96cc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1596,7 +1596,6 @@ enum {
 
 #define HF_GIF_MASK		(1 << 0)
 #define HF_HIF_MASK		(1 << 1)
-#define HF_VINTR_MASK		(1 << 2)
 #define HF_NMI_MASK		(1 << 3)
 #define HF_IRET_MASK		(1 << 4)
 #define HF_GUEST_MASK		(1 << 5) /* VCPU is in guest-mode */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c3c04fef11df..6967fe884eaf 100644
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
@@ -338,10 +338,6 @@ static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 	kvm_mmu_reset_context(&svm->vcpu);
 
 	svm_flush_tlb(&svm->vcpu);
-	if (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
-		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 422b1cc62a20..6867dba4f736 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3104,7 +3104,7 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
-		if ((svm->vcpu.arch.hflags & HF_VINTR_MASK)
+		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
 		    ? !(svm->vcpu.arch.hflags & HF_HIF_MASK)
 		    : !(kvm_get_rflags(vcpu) & X86_EFLAGS_IF))
 			return true;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 10b7b55720a0..be8e830f83fa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -367,7 +367,9 @@ void svm_set_gif(struct vcpu_svm *svm, bool value);
 
 static inline bool svm_nested_virtualize_tpr(struct kvm_vcpu *vcpu)
 {
-	return is_guest_mode(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK);
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return is_guest_mode(vcpu) && (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK);
 }
 
 static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
-- 
2.26.2


