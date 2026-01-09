Return-Path: <kvm+bounces-67512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2BFD07087
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:49:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0685308145B
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40352DF3F2;
	Fri,  9 Jan 2026 03:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MEi6CxWY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0542D978B
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930351; cv=none; b=YsnYTdipC90/lhHsf5zpYMqh9pjDuu7V8vQUokrsxvIbKxzqRg0vN/6Q1CLWulu5Zi2F/UZqyikI31RjFi47jc0iRspoK3A77u8Z9eQS92Gci4P148k3RGlguMVoMVR85Z5weVBvWCM1UzA1+1pRuaRA11Pod7RdvvVDN7gDFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930351; c=relaxed/simple;
	bh=4msjTg1i7XaDvd1QuEQZzoFMT5VhByOA6HB8ET5wU8E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5cnncRm7ED+3SiGamcLH8VuUaYRthlQ+S7WfMz6G7kkWNdj24gbTsbHOwgBPvTupN42Lk6aA2MEFkjWsaTS1Ih6ltJzIcDP3U1CsrnvJrw7EeXcI399zQ4MhGqTMtFJMlOx8oF+Z1p2PriUzBc+bvvhd3tSQXbyCE5f1D48dys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MEi6CxWY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81c68fef4d4so2951166b3a.2
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930349; x=1768535149; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=10FjfRsFdnZmF34U5UFQ1XPMg3h7zF2rzmscv7r4ebk=;
        b=MEi6CxWYSrZUATblUJEQFEBw2DTr2kvmNakvWIfnqaFeh9bqypJtPCz8sr1xodZRFb
         dd4AYJIPsRenDI4w9Y0mItoXh30I6FHdMK2KNedSObGReqTAFfuFG77GBwd5UrFd8OpJ
         zQ/nDOSo2CPTAkX1TpZtbgbRCre37otXr2oleRmOROm0k5Q0qh7NF3dmCTLfqOC4EoBQ
         lPqYu+tvFLwbyve7Azi19jIJbMJRtJ2XxVPZHkwoSd3W4VMFU1W7oUBvAoSpU85j77Tb
         0E43J4lPOFQUTGkJdp17HO/CRd7t3icWxF4aKvOGntIBTj2abBG3kXmJEblOF1r+lIjH
         g+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930349; x=1768535149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=10FjfRsFdnZmF34U5UFQ1XPMg3h7zF2rzmscv7r4ebk=;
        b=TYAHSGPCWbzqz7sYN4QHtHwN8slfrL1zt359RNgJ0gsD96aeVBqZBalSHYin+nrcSX
         4dwO8HDrhYHtrHDSMW6v6xZoPtik9EQlSzlTyuPK6EEatzNFHQc/bE7wmngqTFkXqdux
         WtYX2U282dSK8igch7SwtbhO6FaaOpE3VTmareNNOW9yr+/taVD70dHOOHWQcRBx218m
         Glcpn/pPWMnX2CvYZwPqSg2SJRpkb/JFvhQc0vCJI5R9Ed38gNIvVwt6xLhlcZaxTrKx
         3WriYAQFR7WXJRrPViPp0d21XFK1DuZuKP6rJOEnwFZxR2Z1v6Odp+KYz0zWRv5ALlIh
         /oog==
X-Gm-Message-State: AOJu0YwZxvCBNus38vZvaKs6OPPYyFC2ywBMsAdOb01L7gSpM9Otbhxb
	I7SIlIJiWun/HGhGjVbgTR8dLJ1TIfsBYXNuiivKnzqv8QBC7a8874Be1YAXTQW18c7BBCQ+6FE
	p3fVF1Q==
X-Google-Smtp-Source: AGHT+IF+n8CHKQkZPkcMtUGYOluM0zEQvfHMGi/MUBUCyGUaDQhoy6jg4em+1v2tpH7hoYL3Xe3tU7uY0dk=
X-Received: from pfblh1.prod.google.com ([2002:a05:6a00:7101:b0:7a9:968d:6b38])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:299a:b0:817:9a85:549f
 with SMTP id d2e1a72fcca58-81b7d850288mr8307437b3a.20.1767930349149; Thu, 08
 Jan 2026 19:45:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:32 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-9-seanjc@google.com>
Subject: [PATCH v4 8/8] KVM: x86: Update APICv ISR (a.k.a. SVI) as part of kvm_apic_update_apicv()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold the calls to .hwapic_isr_update() in kvm_apic_set_state(),
kvm_lapic_reset(), and __kvm_vcpu_update_apicv() into
kvm_apic_update_apicv(), as updating SVI is directly related to updating
KVM's own cache of ISR information, e.g. SVI is more or less the APICv
equivalent of highest_isr_cache.

Note, calling .hwapic_isr_update() during kvm_apic_update_apicv() has
benign side effects, as doing so changes the orders of the calls in
kvm_lapic_reset() and kvm_apic_set_state(), specifically with respect to
to the order between .hwapic_isr_update() and .apicv_post_state_restore().
However, the changes in ordering are glorified nops as the former hook is
VMX-only and the latter is SVM-only.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 31 ++++++++++++-------------------
 arch/x86/kvm/lapic.h |  1 -
 arch/x86/kvm/x86.c   |  7 -------
 3 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1597dd0b0cc6..9b791e728ec1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -770,17 +770,6 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	}
 }
 
-void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
-	if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active)
-		return;
-
-	kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
-}
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_apic_update_hwapic_isr);
-
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
 	/* This may race with setting of irr in __apic_accept_irq() and
@@ -2785,10 +2774,18 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	apic->irr_pending = true;
 
-	if (apic->apicv_active)
+	/*
+	 * Update SVI when APICv gets enabled, otherwise SVI won't reflect the
+	 * highest bit in vISR and the next accelerated EOI in the guest won't
+	 * be virtualized correctly (the CPU uses SVI to determine which vISR
+	 * vector to clear).
+	 */
+	if (apic->apicv_active) {
 		apic->isr_count = 1;
-	else
+		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
+	} else {
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
+	}
 
 	apic->highest_isr_cache = -1;
 }
@@ -2916,10 +2913,8 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
-	if (apic->apicv_active) {
+	if (apic->apicv_active)
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_isr_update)(vcpu, -1);
-	}
 
 	vcpu->arch.apic_arb_prio = 0;
 	vcpu->arch.apic_attention = 0;
@@ -3232,10 +3227,8 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	__start_apic_timer(apic, APIC_TMCCT);
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
-	if (apic->apicv_active) {
+	if (apic->apicv_active)
 		kvm_x86_call(apicv_post_state_restore)(vcpu);
-		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
-	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 #ifdef CONFIG_KVM_IOAPIC
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 282b9b7da98c..aa0a9b55dbb7 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -126,7 +126,6 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high);
 int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiated);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
-void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
 
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..0c6d899d53dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10886,16 +10886,9 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
 	 * kvm_check_and_inject_events() is called to check for that.
-	 *
-	 * Update SVI when APICv gets enabled, otherwise SVI won't reflect the
-	 * highest bit in vISR and the next accelerated EOI in the guest won't
-	 * be virtualized correctly (the CPU uses SVI to determine which vISR
-	 * vector to clear).
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-	else
-		kvm_apic_update_hwapic_isr(vcpu);
 
 out:
 	preempt_enable();
-- 
2.52.0.457.g6b5491de43-goog


