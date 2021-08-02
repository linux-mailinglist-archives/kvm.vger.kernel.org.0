Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CBE3DDF4D
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhHBSei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 14:34:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232147AbhHBSea (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 14:34:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627929260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6HVFpYSmCUC73fYc2XvgRjgXqIhW7rxFKrmz3wMoOM=;
        b=DUg3jZvvpws7nyn0/TQty8W1tWiajzrTvp7gMwq7A4EvWtCyB0gkihdiVhBPyCR2Q+Zzwx
        6o67bxxPXobW5xPRPBpKW9R6e+TuIRj0HbaIRuBw/QYK/ebFoMC1rDHs8QPGpIgalqwkDF
        RaAFVrQDPJFOIN08LsukF3NeZE0aLgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-dJOvgjAEPwGkDD2SY0TC0Q-1; Mon, 02 Aug 2021 14:34:18 -0400
X-MC-Unique: dJOvgjAEPwGkDD2SY0TC0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9E22871812;
        Mon,  2 Aug 2021 18:34:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FBF13AE1;
        Mon,  2 Aug 2021 18:34:12 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 10/12] KVM: SVM: remove svm_toggle_avic_for_irq_window
Date:   Mon,  2 Aug 2021 21:33:27 +0300
Message-Id: <20210802183329.2309921-11-mlevitsk@redhat.com>
In-Reply-To: <20210802183329.2309921-1-mlevitsk@redhat.com>
References: <20210802183329.2309921-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that kvm_request_apicv_update doesn't need to drop the kvm->srcu lock,
we can call kvm_request_apicv_update directly.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 11 -----------
 arch/x86/kvm/svm/svm.c  |  4 ++--
 arch/x86/kvm/svm/svm.h  |  1 -
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index d0acbeeab3d6..1def54c26259 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -582,17 +582,6 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
 	avic_handle_ldr_update(vcpu);
 }
 
-void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate)
-{
-	if (!enable_apicv || !lapic_in_kernel(vcpu))
-		return;
-
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-	kvm_request_apicv_update(vcpu->kvm, activate,
-				 APICV_INHIBIT_REASON_IRQWIN);
-	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-}
-
 void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 {
 	return;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3923d383face..c8827de49c75 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2994,7 +2994,7 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
 	 * In this case AVIC was temporarily disabled for
 	 * requesting the IRQ window and we have to re-enable it.
 	 */
-	svm_toggle_avic_for_irq_window(vcpu, true);
+	kvm_request_apicv_update(vcpu->kvm, true, APICV_INHIBIT_REASON_IRQWIN);
 
 	++vcpu->stat.irq_window_exits;
 	return 1;
@@ -3546,7 +3546,7 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 		 * via AVIC. In such case, we need to temporarily disable AVIC,
 		 * and fallback to injecting IRQ via V_IRQ.
 		 */
-		svm_toggle_avic_for_irq_window(vcpu, false);
+		kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_IRQWIN);
 		svm_set_vintr(svm);
 	}
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index bd41f2a32838..aae851762b59 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -524,7 +524,6 @@ int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
 void avic_init_vmcb(struct vcpu_svm *svm);
-void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
-- 
2.26.3

