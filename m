Return-Path: <kvm+bounces-23122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D63394641C
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 21:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80FA71C21937
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 19:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34711386DF;
	Fri,  2 Aug 2024 19:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A/6RYMB7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B25D13049E
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 19:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722628291; cv=none; b=luV0/NsaxjaKNNQmjwRZEwwlJ7hfONcWK3DHu5J2S1gS0ZJXsRtqOsdsWRFK6e41fvbrORDcdY0ZBsgB/1OGMZjMKB8zeU977dizZfQjyLN7lEQkfUQgccgOIJg0fz7M7CIF5OV3gA3dj2NtX7Se0QH8XnMNHCZPum8DxCVIXFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722628291; c=relaxed/simple;
	bh=GisDFGhm1yyVC6WE7YFlKal02q+ebK2NzRvmB0/ukH4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eMXBchOaTCN+/OQfBb4eg+pacXfvdpoa8fkukiOu1wXHBHlvAVIAFyGbkWljhiFAiOZF0NBmH6/e0CUW7zpbQKNuGoFrJvvUu2xkykj8qwuJPq3WQ72gIzxx9p+Ei2FnzZp/ctHGnK1YEOPPGXeV8k9c3pYGJKPD/zt38NumObg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A/6RYMB7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fd6d695662so88996495ad.0
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2024 12:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722628289; x=1723233089; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rTtTuEYhkp7ZliDdCROPWm4/aH5E9MbOqSEDHs65qFg=;
        b=A/6RYMB7DxMNCw0lA6At4tRxJqtHXS87PyI1lKNVoylXhdaogfKBdS2dDADgngHVai
         1cRaUxXK0pzLO78vPRQy+FAlWJWGYzuw8xnPODS4CEQmZ0P7r+DiU7nOhmmYdSjpdD7l
         fPXfHPV1wPRjqZOu5GaZNqGUEZ6MbOIch/Nc2ysoyZOUTV15g7xbgIha8XNaN8OhgXHg
         HjSvNjYFW/2273E6AbZiWjE4daNO47Q36UjQbJZt+bq7i/ekAa/SyLZi/ROGyTkzrjmK
         ffTuq8BW1Dg67Ml+UqoTQVDcncPDpr7m2aWEQyZHjsIyZ7TqkEMdYE+GFZnEHB5s1TlF
         k/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722628289; x=1723233089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTtTuEYhkp7ZliDdCROPWm4/aH5E9MbOqSEDHs65qFg=;
        b=b3C8B+TRll5c9moyTTbHXZvRZ1aP7+1Ry5l9gNWv2W79aU5ENy0Y/ocmEcAPvnkNI6
         qe5rH/3nL+tNooxftdsMbUDTTTlaikMznWaAGOSaLCNcNaLZHIGusC8abC2kPykRaU6O
         gRzWVhq0LFxy6AbIv0uRUnqAQe6A2IA88nbgDCJQyYsiC1ruTKs1j5XwBzG7tKtxFa1V
         nqSfFECC2P5GI9K5tCqmL2plj7cLADjmyc8f6M88SM4ywyiql2dhBk56VTBEU6SVHHeg
         /Q7wixx6GriM1iQy6yAsyPIFHJf4RSQhm0R+sVd71oFYNBxrIEmiaZiqW04DcqNw1Sao
         bhUg==
X-Gm-Message-State: AOJu0YxV4bEvsKqSznrYBs3t4cEfOM6esr+nBZ2weMeR3x50o2Nk9H6e
	xYmz3cAF1Mjh/SbXlpysxzhB1iaWERUtihTKUivsGHAYr4Ww+aDsANaiZbc8bwks94bnhHXkl+C
	OWg==
X-Google-Smtp-Source: AGHT+IFBUss19Xpkp75NzbgRP0olqSoTDLPxcqWGsDO3MC/8JqTWqabd+CJKuvDdDMWWc9kapW0n3uESCPc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec92:b0:1fb:f03:8935 with SMTP id
 d9443c01a7336-1ff573e3bc2mr3366305ad.7.1722628289493; Fri, 02 Aug 2024
 12:51:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  2 Aug 2024 12:51:19 -0700
In-Reply-To: <20240802195120.325560-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802195120.325560-5-seanjc@google.com>
Subject: [PATCH 4/5] KVM: x86: Reorganize code in x86.c to co-locate vCPU
 blocking/running helpers
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Shuffle code around in x86.c so that the various helpers related to vCPU
blocking/running logic are (a) located near each other and (b) ordered so
that HLT emulation can use kvm_vcpu_has_events() in a future path.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 264 ++++++++++++++++++++++-----------------------
 1 file changed, 132 insertions(+), 132 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3c54a241696f..46686504cd47 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9927,51 +9927,6 @@ void kvm_x86_vendor_exit(void)
 }
 EXPORT_SYMBOL_GPL(kvm_x86_vendor_exit);
 
-static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
-{
-	/*
-	 * The vCPU has halted, e.g. executed HLT.  Update the run state if the
-	 * local APIC is in-kernel, the run loop will detect the non-runnable
-	 * state and halt the vCPU.  Exit to userspace if the local APIC is
-	 * managed by userspace, in which case userspace is responsible for
-	 * handling wake events.
-	 */
-	++vcpu->stat.halt_exits;
-	if (lapic_in_kernel(vcpu)) {
-		vcpu->arch.mp_state = state;
-		return 1;
-	} else {
-		vcpu->run->exit_reason = reason;
-		return 0;
-	}
-}
-
-int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
-{
-	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
-
-int kvm_emulate_halt(struct kvm_vcpu *vcpu)
-{
-	int ret = kvm_skip_emulated_instruction(vcpu);
-	/*
-	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
-	 * KVM_EXIT_DEBUG here.
-	 */
-	return kvm_emulate_halt_noskip(vcpu) && ret;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_halt);
-
-int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
-{
-	int ret = kvm_skip_emulated_instruction(vcpu);
-
-	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
-					KVM_EXIT_AP_RESET_HOLD) && ret;
-}
-EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
-
 #ifdef CONFIG_X86_64
 static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
 			        unsigned long clock_type)
@@ -11224,6 +11179,67 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
+		!vcpu->arch.apf.halted);
+}
+
+static bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
+{
+	if (!list_empty_careful(&vcpu->async_pf.done))
+		return true;
+
+	if (kvm_apic_has_pending_init_or_sipi(vcpu) &&
+	    kvm_apic_init_sipi_allowed(vcpu))
+		return true;
+
+	if (vcpu->arch.pv.pv_unhalted)
+		return true;
+
+	if (kvm_is_exception_pending(vcpu))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
+	    (vcpu->arch.nmi_pending &&
+	     kvm_x86_call(nmi_allowed)(vcpu, false)))
+		return true;
+
+#ifdef CONFIG_KVM_SMM
+	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
+	    (vcpu->arch.smi_pending &&
+	     kvm_x86_call(smi_allowed)(vcpu, false)))
+		return true;
+#endif
+
+	if (kvm_test_request(KVM_REQ_PMI, vcpu))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
+		return true;
+
+	if (kvm_arch_interrupt_allowed(vcpu) && kvm_cpu_has_interrupt(vcpu))
+		return true;
+
+	if (kvm_hv_has_stimer_pending(vcpu))
+		return true;
+
+	if (is_guest_mode(vcpu) &&
+	    kvm_x86_ops.nested_ops->has_events &&
+	    kvm_x86_ops.nested_ops->has_events(vcpu, false))
+		return true;
+
+	if (kvm_xen_has_pending_events(vcpu))
+		return true;
+
+	return false;
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
+}
+
 /* Called within kvm->srcu read side.  */
 static inline int vcpu_block(struct kvm_vcpu *vcpu)
 {
@@ -11295,12 +11311,6 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
-static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
-{
-	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
-		!vcpu->arch.apf.halted);
-}
-
 /* Called within kvm->srcu read side.  */
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
@@ -11352,6 +11362,77 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 	return r;
 }
 
+static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
+{
+	/*
+	 * The vCPU has halted, e.g. executed HLT.  Update the run state if the
+	 * local APIC is in-kernel, the run loop will detect the non-runnable
+	 * state and halt the vCPU.  Exit to userspace if the local APIC is
+	 * managed by userspace, in which case userspace is responsible for
+	 * handling wake events.
+	 */
+	++vcpu->stat.halt_exits;
+	if (lapic_in_kernel(vcpu)) {
+		vcpu->arch.mp_state = state;
+		return 1;
+	} else {
+		vcpu->run->exit_reason = reason;
+		return 0;
+	}
+}
+
+int kvm_emulate_halt_noskip(struct kvm_vcpu *vcpu)
+{
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_halt_noskip);
+
+int kvm_emulate_halt(struct kvm_vcpu *vcpu)
+{
+	int ret = kvm_skip_emulated_instruction(vcpu);
+	/*
+	 * TODO: we might be squashing a GUESTDBG_SINGLESTEP-triggered
+	 * KVM_EXIT_DEBUG here.
+	 */
+	return kvm_emulate_halt_noskip(vcpu) && ret;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_halt);
+
+int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
+{
+	int ret = kvm_skip_emulated_instruction(vcpu);
+
+	return __kvm_emulate_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD,
+					KVM_EXIT_AP_RESET_HOLD) && ret;
+}
+EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
+
+bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_apicv_active(vcpu) &&
+	       kvm_x86_call(dy_apicv_has_pending_interrupt)(vcpu);
+}
+
+bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.preempted_in_kernel;
+}
+
+bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
+{
+	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
+		return true;
+
+	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
+#ifdef CONFIG_KVM_SMM
+		kvm_test_request(KVM_REQ_SMI, vcpu) ||
+#endif
+		 kvm_test_request(KVM_REQ_EVENT, vcpu))
+		return true;
+
+	return kvm_arch_dy_has_pending_interrupt(vcpu);
+}
+
 static inline int complete_emulated_io(struct kvm_vcpu *vcpu)
 {
 	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
@@ -13163,87 +13244,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		kvm_arch_free_memslot(kvm, old);
 }
 
-static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
-{
-	if (!list_empty_careful(&vcpu->async_pf.done))
-		return true;
-
-	if (kvm_apic_has_pending_init_or_sipi(vcpu) &&
-	    kvm_apic_init_sipi_allowed(vcpu))
-		return true;
-
-	if (vcpu->arch.pv.pv_unhalted)
-		return true;
-
-	if (kvm_is_exception_pending(vcpu))
-		return true;
-
-	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
-	    (vcpu->arch.nmi_pending &&
-	     kvm_x86_call(nmi_allowed)(vcpu, false)))
-		return true;
-
-#ifdef CONFIG_KVM_SMM
-	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
-	    (vcpu->arch.smi_pending &&
-	     kvm_x86_call(smi_allowed)(vcpu, false)))
-		return true;
-#endif
-
-	if (kvm_test_request(KVM_REQ_PMI, vcpu))
-		return true;
-
-	if (kvm_test_request(KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, vcpu))
-		return true;
-
-	if (kvm_arch_interrupt_allowed(vcpu) && kvm_cpu_has_interrupt(vcpu))
-		return true;
-
-	if (kvm_hv_has_stimer_pending(vcpu))
-		return true;
-
-	if (is_guest_mode(vcpu) &&
-	    kvm_x86_ops.nested_ops->has_events &&
-	    kvm_x86_ops.nested_ops->has_events(vcpu, false))
-		return true;
-
-	if (kvm_xen_has_pending_events(vcpu))
-		return true;
-
-	return false;
-}
-
-int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
-{
-	return kvm_vcpu_running(vcpu) || kvm_vcpu_has_events(vcpu);
-}
-
-bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu)
-{
-	return kvm_vcpu_apicv_active(vcpu) &&
-	       kvm_x86_call(dy_apicv_has_pending_interrupt)(vcpu);
-}
-
-bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu)
-{
-	return vcpu->arch.preempted_in_kernel;
-}
-
-bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
-{
-	if (READ_ONCE(vcpu->arch.pv.pv_unhalted))
-		return true;
-
-	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
-#ifdef CONFIG_KVM_SMM
-		kvm_test_request(KVM_REQ_SMI, vcpu) ||
-#endif
-		 kvm_test_request(KVM_REQ_EVENT, vcpu))
-		return true;
-
-	return kvm_arch_dy_has_pending_interrupt(vcpu);
-}
-
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.guest_state_protected)
-- 
2.46.0.rc2.264.g509ed76dc8-goog


