Return-Path: <kvm+bounces-65382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0C7CA99AB
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 33F643018EF0
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228A73009C1;
	Fri,  5 Dec 2025 23:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lEyX1Tqk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC63F2236F2
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976764; cv=none; b=Tw/CTUQ+0hCZGeZNb+ok2Ld0WGtYjyvBAIU4rKqyC/fRPmnGZBD4QPz1ZQsD+nmzJSRQ2zPOY3wJq7oXFbaHI/SXbGtn+bnmNWr9tko5eH21PkOowc6qLsDjwO7KhlstcGSsOTqx/Jx4SgVpfoW4DO92618gGBgjtXdpp9r+yX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976764; c=relaxed/simple;
	bh=UN8GPCeve/DEnaWE5Eh7JLbjimevNK5VLubSfh1kBU8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X0zbZlcLoi/8BlzIl7CcJBOBQQOBMUVaguKN2x6/3dRPl1GwIlk28h0vmJKaSgjZWGIRsPvh1gdnTlXx+vDzlNmOqncEJwtEuf73STmosigw319He7iIVCgfLpFbuQATbTf7fkA+JeeiPtLA3Y81PsnwvA5lkbh1SCapCLKgdno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lEyX1Tqk; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297e5a18652so32643945ad.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976759; x=1765581559; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5vbjlflukCzgVx857+Uo6D3SgSV5wlnI4XqtN/GelQI=;
        b=lEyX1TqkC4K4hUnFftOScGlCrB9m7gEv1y0gFoYjhLBBHJy4mORsxdvx3vYQaDPjXr
         myQEUjIM4DVnU3c5n6hrN/JlnzxFtwQOWzg0O0t1Sj6MukDwIqc/xxmcMsOMjcFesQ7w
         p9wjvhwSajHWy/s1OvhhbDYNdNGpwKQR7ICXsVrmrXwaDiJYES0wXRZRBjU/cfjcVHM0
         R/3rKawYsWnOIdGODh253d3aktC++Tb5Jk3qhWaAWiuk1tMjycGpBrddPBWEGUcJzjnT
         lMTcWTAkbc3wtHQAtM5mjC1yatXi6G1aqwqsUZrb81ROYK/TaEQNNLBGEOXz2lkfTqlm
         ogtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976759; x=1765581559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5vbjlflukCzgVx857+Uo6D3SgSV5wlnI4XqtN/GelQI=;
        b=paIr8VB2v/3MGmIWDvDCK3BkYOg5x83u2PBCHCBXeMfMsT65rk7OFOTwcURQC+THVA
         /+z8q3M/lJIQgncuSDljFq14N+wLNgFH1hk7V4wh1bMF5BwbOu83bJxRwwkI0YdsuKSf
         uzxyjUmStz80ntLSuAXtg4RWm1HFMyMSKnlP2a+40VWKnMjF/hnYfQ1GtD1j+Ia31h1c
         kLFTn/TB6Q3igoEBGNWbk8+uS/xGrGex/49QuhRihbi2kZYxa7maw8nQ7VU6FGmlgUFB
         iinCzkxQqlpt1ClolH8MR4LheE0uC5XCLkGDiAjRH8YYH8tMqVfsNTLJ8QlGcosY3XOi
         R1Gg==
X-Gm-Message-State: AOJu0YwQWK4cVe4Gc1rVCaImZv8kgRcgn8591SSpmu03l77PUEqpfPpH
	rkrkoEJiHbtKWG1/gFhoVxYq6YBL461PWQ9/W7QV1q44dKbIM4/tkpmwzIebJUG5ONMsVHCtsjV
	c6XjGrA==
X-Google-Smtp-Source: AGHT+IGGGWzlhukNf7o4/R3m070bOr/gayV996esIb+fsIzTzw7B9dy/9JvMrkqeE6xa0MpUeOsIyRkHwJI=
X-Received: from plpf8.prod.google.com ([2002:a17:903:3c48:b0:297:fd8b:fe1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f60b:b0:297:db6a:a82f
 with SMTP id d9443c01a7336-29df5572c21mr4075325ad.24.1764976759407; Fri, 05
 Dec 2025 15:19:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:04 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-2-seanjc@google.com>
Subject: [PATCH v3 01/10] KVM: VMX: Update SVI during runtime APICv activation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dongli Zhang <dongli.zhang@oracle.com>

The APICv (apic->apicv_active) can be activated or deactivated at runtime,
for instance, because of APICv inhibit reasons. Intel VMX employs different
mechanisms to virtualize LAPIC based on whether APICv is active.

When APICv is activated at runtime, GUEST_INTR_STATUS is used to configure
and report the current pending IRR and ISR states. Unless a specific vector
is explicitly included in EOI_EXIT_BITMAP, its EOI will not be trapped to
KVM. Intel VMX automatically clears the corresponding ISR bit based on the
GUEST_INTR_STATUS.SVI field.

When APICv is deactivated at runtime, the VM_ENTRY_INTR_INFO_FIELD is used
to specify the next interrupt vector to invoke upon VM-entry. The
VMX IDT_VECTORING_INFO_FIELD is used to report un-invoked vectors on
VM-exit. EOIs are always trapped to KVM, so the software can manually clear
pending ISR bits.

There are scenarios where, with APICv activated at runtime, a guest-issued
EOI may not be able to clear the pending ISR bit.

Taking vector 236 as an example, here is one scenario.

1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
3. After VM-entry, vector 236 is invoked through the guest IDT. At this
point, the data in VM_ENTRY_INTR_INFO_FIELD is no longer valid. The guest
interrupt handler for vector 236 is invoked.
4. Suppose a VM exit occurs very early in the guest interrupt handler,
before the EOI is issued.
5. Nothing is reported through the IDT_VECTORING_INFO_FIELD because
vector 236 has already been invoked in the guest.
6. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
kvm_vcpu_update_apicv() to activate APICv.
7. Unfortunately, GUEST_INTR_STATUS.SVI is not configured, although
vector 236 is still pending in the ISR.
8. After VM-entry, the guest finally issues the EOI for vector 236.
However, because SVI is not configured, vector 236 is not cleared.
9. ISR is stalled forever on vector 236.

Here is another scenario.

1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
3. VM-exit occurs immediately after the next VM-entry. The vector 236 is
not invoked through the guest IDT. Instead, it is saved to the
IDT_VECTORING_INFO_FIELD during the VM-exit.
4. KVM calls kvm_queue_interrupt() to re-queue the un-invoked vector 236
into vcpu->arch.interrupt. A KVM_REQ_EVENT is requested.
5. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
kvm_vcpu_update_apicv() to activate APICv.
6. Although APICv is now active, KVM still uses the legacy
VM_ENTRY_INTR_INFO_FIELD to re-inject vector 236. GUEST_INTR_STATUS.SVI is
not configured.
7. After the next VM-entry, vector 236 is invoked through the guest IDT.
Finally, an EOI occurs. However, due to the lack of GUEST_INTR_STATUS.SVI
configuration, vector 236 is not cleared from the ISR.
8. ISR is stalled forever on vector 236.

Using QEMU as an example, vector 236 is stuck in ISR forever.

(qemu) info lapic 1
dumping local APIC state for CPU 1

LVT0	 0x00010700 active-hi edge  masked                      ExtINT (vec 0)
LVT1	 0x00010400 active-hi edge  masked                      NMI
LVTPC	 0x00000400 active-hi edge                              NMI
LVTERR	 0x000000fe active-hi edge                              Fixed  (vec 254)
LVTTHMR	 0x00010000 active-hi edge  masked                      Fixed  (vec 0)
LVTT	 0x000400ec active-hi edge                 tsc-deadline Fixed  (vec 236)
Timer	 DCR=0x0 (divide by 2) initial_count = 0 current_count = 0
SPIV	 0x000001ff APIC enabled, focus=off, spurious vec 255
ICR	 0x000000fd physical edge de-assert no-shorthand
ICR2	 0x00000000 cpu 0 (X2APIC ID)
ESR	 0x00000000
ISR	 236
IRR	 37(level) 236

The issue isn't applicable to AMD SVM as KVM simply writes vmcb01 directly
irrespective of whether L1 (vmcs01) or L2 (vmcb02) is active (unlike VMX,
there is no need/cost to switch between VMCBs).  In addition,
APICV_INHIBIT_REASON_IRQWIN ensures AMD SVM AVIC is not activated until
the last interrupt is EOI'd.

Fix the bug by configuring Intel VMX GUEST_INTR_STATUS.SVI if APICv is
activated at runtime.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Link: https://patch.msgid.link/20251110063212.34902-1-dongli.zhang@oracle.com
[sean: call out that SVM writes vmcb01 directly, tweak comment]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 ---------
 arch/x86/kvm/x86.c     | 7 +++++++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..6b96f7aea20b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6937,15 +6937,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
 	 * VM-Exit, otherwise L1 with run with a stale SVI.
 	 */
 	if (is_guest_mode(vcpu)) {
-		/*
-		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
-		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
-		 * Note, userspace can stuff state while L2 is active; assert
-		 * that VID is disabled if and only if the vCPU is in KVM_RUN
-		 * to avoid false positives if userspace is setting APIC state.
-		 */
-		WARN_ON_ONCE(vcpu->wants_to_run &&
-			     nested_cpu_has_vid(get_vmcs12(vcpu)));
 		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
 		return;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..ff8812f3a129 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10886,9 +10886,16 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
 	 * still active when the interrupt got accepted. Make sure
 	 * kvm_check_and_inject_events() is called to check for that.
+	 *
+	 * Update SVI when APICv gets enabled, otherwise SVI won't reflect the
+	 * highest bit in vISR and the next accelerated EOI in the guest won't
+	 * be virtualized correctly (the CPU uses SVI to determine which vISR
+	 * vector to clear).
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
+	else
+		kvm_apic_update_hwapic_isr(vcpu);
 
 out:
 	preempt_enable();
-- 
2.52.0.223.gf5cc29aaa4-goog


