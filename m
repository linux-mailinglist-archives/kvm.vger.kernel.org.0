Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C5D17A2ED
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCEKOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:14:02 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36972 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgCEKNz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 05:13:55 -0500
Received: by mail-wr1-f66.google.com with SMTP id 6so823402wre.4;
        Thu, 05 Mar 2020 02:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mf4pftpvyE6QdpnD7ythbs31rkJp2p0e3/GL3dyXTKY=;
        b=TMjNNRPkuZqL1OUT6F3LQqioqjXpbLmmSD9PM6lTfVCJi/S29CNaQY7PjskmJta6/r
         FVUN1JuszSkUelJbwCeaA8v9mYxolCX1ORkg5jwLyVFo9b2IHGRYodB9V+eZOXJXDbaL
         ahgg0LUPx+k79nWEIysdzjsUF/tjRogeYCA32QH7y5/03bAHMufMVV3qgReKjsv5BZqI
         CWAVu0plJphfIg9aYGhHxurPS7IFxf8a/Ur6zP/2Pgu7VDYeG8dGsrnYMcWC8yKC98E2
         konL7JwnxAnMi6nB1NvVBBP63lq5snkBocyg9rmZ8N4IzebqroJ8GHvMvzL2313/VXqt
         cD9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Mf4pftpvyE6QdpnD7ythbs31rkJp2p0e3/GL3dyXTKY=;
        b=gpk2Rx94bPNR9yza3uL6IIK+Wp+7QEs8FbPhNhbtzzH5fN8Z+JV08JkjDdkIkT9nWR
         rZyPkVSWGQeppnAQQMqQyk+tjj3nW1jDfFncBICYNHFBzzwZRbrM7HQdTG9JJIbqYZDh
         HEAwcctX1KGBTU56LVBaR8uPwu5+y1xidWLd5m+YbaFnIZWhgT3tuTHTcPoPZQGiqjCv
         hWxgFokwKkYDOAmBKJ4VQHtp5uR8G5pk3HF4Wi+NfMUG5O+vYpXRiDzhJZzeo01DdKeO
         kO+ml2oLY2dUNAfZEI7rIqp5f8oLI17Qb5dD8rwhwqv7NwQiykhnw4ou2RftZGhShF4o
         m0DA==
X-Gm-Message-State: ANhLgQ3AoGO0bcEN/NUSQkmAo88RlWzxrZDCXwq4EJGJ2/EPes/Hi+4N
        ASeSwIrbCJuvNZzGxLWkJ8BRo6y2
X-Google-Smtp-Source: ADFU+vtBxUZ2RbZNU0ecQ0/Lseev5+Lmswm5zJoQ6lkgU/Q5UOzqOI0ZNkDysB8Qjn7mUEi/njloZg==
X-Received: by 2002:a5d:5041:: with SMTP id h1mr9668627wrt.143.1583403232210;
        Thu, 05 Mar 2020 02:13:52 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id p15sm8331066wma.40.2020.03.05.02.13.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Mar 2020 02:13:51 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     cavery@redhat.com, vkuznets@redhat.com, jan.kiszka@siemens.com,
        wei.huang2@amd.com
Subject: [PATCH 2/4] KVM: nSVM: ignore L1 interrupt window while running L2 with V_INTR_MASKING=1
Date:   Thu,  5 Mar 2020 11:13:45 +0100
Message-Id: <1583403227-11432-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
References: <1583403227-11432-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a nested VM is started while an IRQ was pending and with
V_INTR_MASKING=1, the behavior of the guest depends on host IF.  If it
is 1, the VM should exit immediately, before executing the first
instruction of the guest, because VMRUN sets GIF back to 1.

If it is 0 and the host has VGIF, however, at the time of the VMRUN
instruction L0 is running the guest with a pending interrupt window
request.  This interrupt window request is completely irrelevant to
L2, since IF only controls virtual interrupts, so this patch drops
INTERCEPT_VINTR from the VMCB while running L2 under these circumstances.
To simplify the code, both steps of enabling the interrupt window
(setting the VINTR intercept and requesting a fake virtual interrupt
in svm_inject_irq) are grouped in the svm_set_vintr function, and
likewise for dismissing the interrupt window request in svm_clear_vintr.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c | 55 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 14cb5c194008..25827b79cf96 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -528,6 +528,13 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 		/* We only want the cr8 intercept bits of L1 */
 		c->intercept_cr &= ~(1U << INTERCEPT_CR8_READ);
 		c->intercept_cr &= ~(1U << INTERCEPT_CR8_WRITE);
+
+		/*
+		 * Once running L2 with HF_VINTR_MASK, EFLAGS.IF does not
+		 * affect any interrupt we may want to inject; therefore,
+		 * interrupt window vmexits are irrelevant to L0.
+		 */
+		c->intercept &= ~(1ULL << INTERCEPT_VINTR);
 	}
 
 	/* We don't want to see VMMCALLs from a nested guest */
@@ -641,6 +648,11 @@ static inline void clr_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline bool is_intercept(struct vcpu_svm *svm, int bit)
+{
+	return (svm->vmcb->control.intercept & (1ULL << bit)) != 0;
+}
+
 static inline bool vgif_enabled(struct vcpu_svm *svm)
 {
 	return !!(svm->vmcb->control.int_ctl & V_GIF_ENABLE_MASK);
@@ -2438,14 +2450,38 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	}
 }
 
+static inline void svm_enable_vintr(struct vcpu_svm *svm)
+{
+	struct vmcb_control_area *control;
+
+	/* The following fields are ignored when AVIC is enabled */
+	WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
+
+	/*
+	 * This is just a dummy VINTR to actually cause a vmexit to happen.
+	 * Actual injection of virtual interrupts happens through EVENTINJ.
+	 */
+	control = &svm->vmcb->control;
+	control->int_vector = 0x0;
+	control->int_ctl &= ~V_INTR_PRIO_MASK;
+	control->int_ctl |= V_IRQ_MASK |
+		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
+	mark_dirty(svm->vmcb, VMCB_INTR);
+}
+
 static void svm_set_vintr(struct vcpu_svm *svm)
 {
 	set_intercept(svm, INTERCEPT_VINTR);
+	if (is_intercept(svm, INTERCEPT_VINTR))
+		svm_enable_vintr(svm);
 }
 
 static void svm_clear_vintr(struct vcpu_svm *svm)
 {
 	clr_intercept(svm, INTERCEPT_VINTR);
+
+	svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
+	mark_dirty(svm->vmcb, VMCB_INTR);
 }
 
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
@@ -3833,11 +3869,8 @@ static int clgi_interception(struct vcpu_svm *svm)
 	disable_gif(svm);
 
 	/* After a CLGI no interrupts should come */
-	if (!kvm_vcpu_apicv_active(&svm->vcpu)) {
+	if (!kvm_vcpu_apicv_active(&svm->vcpu))
 		svm_clear_vintr(svm);
-		svm->vmcb->control.int_ctl &= ~V_IRQ_MASK;
-		mark_dirty(svm->vmcb, VMCB_INTR);
-	}
 
 	return ret;
 }
@@ -5123,19 +5156,6 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 	++vcpu->stat.nmi_injections;
 }
 
-static inline void svm_inject_irq(struct vcpu_svm *svm, int irq)
-{
-	struct vmcb_control_area *control;
-
-	/* The following fields are ignored when AVIC is enabled */
-	control = &svm->vmcb->control;
-	control->int_vector = irq;
-	control->int_ctl &= ~V_INTR_PRIO_MASK;
-	control->int_ctl |= V_IRQ_MASK |
-		((/*control->int_vector >> 4*/ 0xf) << V_INTR_PRIO_SHIFT);
-	mark_dirty(svm->vmcb, VMCB_INTR);
-}
-
 static void svm_set_irq(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5559,7 +5579,6 @@ static void enable_irq_window(struct kvm_vcpu *vcpu)
 		 */
 		svm_toggle_avic_for_irq_window(vcpu, false);
 		svm_set_vintr(svm);
-		svm_inject_irq(svm, 0x0);
 	}
 }
 
-- 
1.8.3.1


