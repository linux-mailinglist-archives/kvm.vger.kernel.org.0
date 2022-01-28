Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E7F49EFFB
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344745AbiA1AxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344743AbiA1AxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:17 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD971C061714
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:17 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id e7-20020a17090ac20700b001b586e65885so5237659pjt.1
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=D+8yLffBpcYXir7zQquCWfilc7hYk5NU754z8ZuVcI0=;
        b=l3oaC8bDMB6GHFPur3mfb80FvDtAg5hI8iGf6j0sAfZglYBFBVC7EoNNskV/Jn5sDp
         EJUUu0V1iztO/kgKkH8wrtkK2jk1Lqg3XydHWdvcwLPSF0ELu3fgnAeH6ws+cWx0yMVj
         grepJ49o05cY2m+gLEfP/jIMVUDJuVKAp2u52oFjQ3Mb4Yq95qOItBbmJUe4imwTxIwO
         APZ1g42kQ9LfMatasvoSNCtOL+/xxaC9iVwvYNjp47+8fKQkfPM1Kl31hp29KXIs5hK/
         8UZuGVHVKR8cJP0Lk7rtaENvE2SDQ+HPZhk/ZBuVJsgjzO8+SRbIOgEqujDE1R2lOCh1
         l1lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=D+8yLffBpcYXir7zQquCWfilc7hYk5NU754z8ZuVcI0=;
        b=IVYaeL/WNDa3hDkN7Ct1FUJ8ng4uJpfiEM9NsVKTOkYGazrHMI0qFD5AJ3aE3gd59S
         IWTmmC2vWo8F+UGwDjz1+SmgNvTjIehr+bktkD8K4K8kZzrxqZhixstkVK/AemxqLhW1
         6JOZvjgtSQBKnafCbxgOOytCMXN8ugHaPabLxPDvAHhak5YqQa43ZQ+vJhQi4l5jISOg
         q0L/VY94iLZjmFplRCaAfbaOBKzXUEPE7laakOaBa564Fp4mPGeO/bTduDtBtLMOx8Nd
         23IEQNXItqXgLB9P+pMCesgxoCpq18lsnjx0MIB7EmwrFSfYn/tmy7XaAls8tZsE7peo
         s5gQ==
X-Gm-Message-State: AOAM530fA0QvF+eI/MOFdlLmz+X0rPpCiTGS+3ulTxjGQP4X6IGSfHRk
        9dNAoWXt/IxU/JGdz1yTgkGoGn4RKAc=
X-Google-Smtp-Source: ABdhPJyPSYP7ieApS5vO+h7AYs12hkvF5vXsGKsjR1ZHetBHp7KGslfufN4eM93AcKJiDKQ1RWiSOrKTZuI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4d82:: with SMTP id
 oj2mr1878448pjb.1.1643331197011; Thu, 27 Jan 2022 16:53:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:48 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 02/22] KVM: x86: Move delivery of non-APICv interrupt into
 vendor code
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle non-APICv interrupt delivery in vendor code, even though it means
VMX and SVM will temporarily have duplicate code.  SVM's AVIC has a race
condition that requires KVM to fall back to legacy interrupt injection
_after_ the interrupt has been logged in the vIRR, i.e. to fix the race,
SVM will need to open code the full flow anyways[*].  Refactor the code
so that the SVM bug without introducing other issues, e.g. SVM would
return "success" and thus invoke trace_kvm_apicv_accept_irq() even when
delivery through the AVIC failed, and to opportunistically prepare for
using KVM_X86_OP to fill each vendor's kvm_x86_ops struct, which will
rely on the vendor function matching the kvm_x86_op pointer name.

No functional change intended.

[*] https://lore.kernel.org/all/20211213104634.199141-4-mlevitsk@redhat.com

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +-
 arch/x86/include/asm/kvm_host.h    |  3 ++-
 arch/x86/kvm/lapic.c               | 10 ++--------
 arch/x86/kvm/svm/svm.c             | 17 ++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c             | 17 ++++++++++++++++-
 5 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index e07151b2d1f6..fd134c436029 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -77,7 +77,7 @@ KVM_X86_OP(guest_apic_has_interrupt)
 KVM_X86_OP(load_eoi_exitmap)
 KVM_X86_OP(set_virtual_apic_mode)
 KVM_X86_OP(set_apic_access_page_addr)
-KVM_X86_OP(deliver_posted_interrupt)
+KVM_X86_OP(deliver_interrupt)
 KVM_X86_OP(sync_pir_to_irr)
 KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 756806d2e801..c895e94ffb80 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1409,7 +1409,8 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu);
-	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
+	void (*deliver_interrupt)(struct kvm_lapic *apic, int delivery_mode,
+				  int trig_mode, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4662469240bc..d7e6fde82d25 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1096,14 +1096,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 						       apic->regs + APIC_TMR);
 		}
 
-		if (static_call(kvm_x86_deliver_posted_interrupt)(vcpu, vector)) {
-			kvm_lapic_set_irr(vector, apic);
-			kvm_make_request(KVM_REQ_EVENT, vcpu);
-			kvm_vcpu_kick(vcpu);
-		} else {
-			trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
-						   trig_mode, vector);
-		}
+		static_call(kvm_x86_deliver_interrupt)(apic, delivery_mode,
+						       trig_mode, vector);
 		break;
 
 	case APIC_DM_REMRD:
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d73bff4f9e86..75d277067141 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3293,6 +3293,21 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 		SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_INTR;
 }
 
+static void svm_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+				  int trig_mode, int vector)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+
+	if (svm_deliver_avic_intr(vcpu, vector)) {
+		kvm_lapic_set_irr(vector, apic);
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_vcpu_kick(vcpu);
+	} else {
+		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
+					   trig_mode, vector);
+	}
+}
+
 static void svm_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -4547,7 +4562,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.pmu_ops = &amd_pmu_ops,
 	.nested_ops = &svm_nested_ops,
 
-	.deliver_posted_interrupt = svm_deliver_avic_intr,
+	.deliver_interrupt = svm_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
 	.update_pi_irte = svm_update_pi_irte,
 	.setup_mce = svm_setup_mce,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 92e30bfdf785..97d6edbd25a0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4041,6 +4041,21 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 	return 0;
 }
 
+static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
+				  int trig_mode, int vector)
+{
+	struct kvm_vcpu *vcpu = apic->vcpu;
+
+	if (vmx_deliver_posted_interrupt(vcpu, vector)) {
+		kvm_lapic_set_irr(vector, apic);
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_vcpu_kick(vcpu);
+	} else {
+		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
+					   trig_mode, vector);
+	}
+}
+
 /*
  * Set up the vmcs's constant host-state fields, i.e., host-state fields that
  * will not change in the lifetime of the guest.
@@ -7766,7 +7781,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
-	.deliver_posted_interrupt = vmx_deliver_posted_interrupt,
+	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 
 	.set_tss_addr = vmx_set_tss_addr,
-- 
2.35.0.rc0.227.g00780c9af4-goog

