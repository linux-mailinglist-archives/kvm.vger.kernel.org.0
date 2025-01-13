Return-Path: <kvm+bounces-35321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5F0A0C24F
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 21:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E9047A387B
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BE831D1730;
	Mon, 13 Jan 2025 20:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t4f2V5Zr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E481C760D
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 20:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736798545; cv=none; b=IyvckdhQ/Hs7iM8MqdKjWywy0oJpGpCi6SJhdjmMoACKb4Ue2LoSePLcSX+tU7wptgUiGoTjjz3NQ4zw9lYCJLqtPQqtR+/1lcePCgvEzW0gTXZmYxMbN0ENBRNrpakPNDkDMK5TchvmyEZbj2+p0aplmS1rzS1YDf3kifRlMHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736798545; c=relaxed/simple;
	bh=YTs1dpjXQrZJaO2PwxhJPmloP3yUD+EWIBykta6id/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bUY6YY99poV+eqvh+NdOe9BvcfgpObvJxeBWB97bGMsd2oRLmnspyXvjuiiKXOLbsQbgjjd9RJUFUeNJipExXTdebjKsfXa9spAfpk6XuSd8VvR/wpCrLkxgA5l7V7zTWgUQMKTeJWDhonWdvS2uF4iU7DTkgXDcx5Q3Sz3rm0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t4f2V5Zr; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so12204101a91.3
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 12:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736798542; x=1737403342; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jtdiVJ+ztNcHT3qzoC9fhmElHCLjwxZM/dCdTnmBzy4=;
        b=t4f2V5Zr4iBGFF9WlJe0/K6br7MzjYP3IYzlAVFP+74J1puELYyJGrCNyAjIaaUGAA
         uyqnenenPXmxIkCpx7MC4J9I90ryL8A1v7w5eXLhyLXkkxtH7JED76uukqOYoDsdEcoH
         Sjzsshod8jpm7VTySOo3y9mUZ9bfGHmb4bGUgnbKc32VJO6ZBASa7BgXZ5xjny/RwBs5
         NIUlkSwlvmop6wYCkFZbRuHEs2Y2HWC1uHAfmcr8LES13N5+UVrek6kjxmwWGsoPM7TZ
         4Qt3fJbdk6AwkcgPYzCD1e4Aja2wy408gQhRMa4i6/l1UI26ItfnPy2zXd5vDc6s0xOG
         5CbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736798542; x=1737403342;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jtdiVJ+ztNcHT3qzoC9fhmElHCLjwxZM/dCdTnmBzy4=;
        b=i5KUkGcxSfnwc9l1FdAbWsWbTNfWYn1p10dAxTvA+KY5c6CF2auCBRMm20eoPSVDXY
         fmqlwMDdbUoEAGKWJt4m4xkEZaL8Yzbl2d6wObp8KX99jBP392YyCMrom3zqXQokAHXQ
         jruN2r0kQU3iyqraslEPOTmJz0SnovPfV0KIXpzg/4NPf2GGSh2OWi+p7SymVQfkC8tM
         Uql7Qyxa3+igk/TqG2zByp8FVSYD8jGb4QLyoHgIiYhnFV0JCtqW7wPi+kKY3GccGjn4
         RpVkRjHaYwUbjmmIvGlUcYOcmphtY1hTWcqa0v6k3O07lWM6qBzvd6KgKPwj/VoZ0Bui
         cL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWgJ4PhNw1dv1mK+j9ZWe2kf99VxcLWamA/3xBUpfwxJ/Wedb3xsf6utj8NclWCKtGtCMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcOlQBcOhE+GbKI6/vrHzobjQn3Zl5CChnfoV3x4EWAB4GfJTo
	CrqUJ1cMejJkvx1gmazJWaitr8emJDN2iCeLLSCjtzW9CkObgavWFzMKd/jRLA1m5R+PZ8hEGVf
	kv6iN30cC7g==
X-Google-Smtp-Source: AGHT+IGRDP+dLbZYnL6SPBzmcxG2KKCHdES/kfIarY6JU5nffIgg/+20LS/dSG2aIOK4rzFmwsSpg55z3V3Ilw==
X-Received: from pfiy3.prod.google.com ([2002:a05:6a00:1903:b0:72b:ccb:c99b])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4fd3:b0:72a:83ec:b1c9 with SMTP id d2e1a72fcca58-72d21f35ae3mr31398282b3a.6.1736798542485;
 Mon, 13 Jan 2025 12:02:22 -0800 (PST)
Date: Mon, 13 Jan 2025 12:01:43 -0800
In-Reply-To: <20250113200150.487409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250113200150.487409-1-jmattson@google.com>
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113200150.487409-2-jmattson@google.com>
Subject: [PATCH 1/2] KVM: x86: Introduce kvm_set_mp_state()
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Replace all open-coded assignments to vcpu->arch.mp_state with calls
to a new helper, kvm_set_mp_state(), to centralize all changes to
mp_state.

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/lapic.c      |  6 +++---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/sev.c    |  4 ++--
 arch/x86/kvm/vmx/nested.c |  4 ++--
 arch/x86/kvm/x86.c        | 17 ++++++++---------
 arch/x86/kvm/x86.h        |  5 +++++
 arch/x86/kvm/xen.c        |  4 ++--
 7 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c83951c619e..bfbc4bc70595 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -3392,9 +3392,9 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	if (test_and_clear_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		kvm_vcpu_reset(vcpu, true);
 		if (kvm_vcpu_is_bsp(apic->vcpu))
-			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+			kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 		else
-			vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+			kvm_set_mp_state(vcpu, KVM_MP_STATE_INIT_RECEIVED);
 	}
 	if (test_and_clear_bit(KVM_APIC_SIPI, &apic->pending_events)) {
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
@@ -3403,7 +3403,7 @@ int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 			sipi_vector = apic->sipi_vector;
 			kvm_x86_call(vcpu_deliver_sipi_vector)(vcpu,
 							       sipi_vector);
-			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+			kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 		}
 	}
 	return 0;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b708bdf7eaff..f47906fd9b03 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -994,7 +994,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
 	/* in case we halted in L2 */
-	svm->vcpu.arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
 	/* Give the current vmcb to the guest */
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d3..b4d9efd7537d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3831,7 +3831,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 
 	/* Mark the vCPU as offline and not runnable */
 	vcpu->arch.pv.pv_unhalted = false;
-	vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_HALTED);
 
 	/* Clear use of the VMSA */
 	svm->vmcb->control.vmsa_pa = INVALID_PAGE;
@@ -3870,7 +3870,7 @@ static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
 
 		/* Mark the vCPU as runnable */
 		vcpu->arch.pv.pv_unhalted = false;
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
 		svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aa78b6f38dfe..d53bf4a5ad99 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3791,7 +3791,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		break;
 	case GUEST_ACTIVITY_WAIT_SIPI:
 		vmx->nested.nested_run_pending = 0;
-		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_INIT_RECEIVED);
 		break;
 	default:
 		break;
@@ -5055,7 +5055,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx->nested.need_vmcs12_to_shadow_sync = true;
 
 	/* in case we halted in L2 */
-	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
 	if (likely(!vmx->fail)) {
 		if (vm_exit_reason != -1)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c79a8cc57ba4..d6679df95a75 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11208,8 +11208,7 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
 	case KVM_MP_STATE_HALTED:
 	case KVM_MP_STATE_AP_RESET_HOLD:
 		vcpu->arch.pv.pv_unhalted = false;
-		vcpu->arch.mp_state =
-			KVM_MP_STATE_RUNNABLE;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 		fallthrough;
 	case KVM_MP_STATE_RUNNABLE:
 		vcpu->arch.apf.halted = false;
@@ -11288,7 +11287,7 @@ static int __kvm_emulate_halt(struct kvm_vcpu *vcpu, int state, int reason)
 		if (kvm_vcpu_has_events(vcpu))
 			vcpu->arch.pv.pv_unhalted = false;
 		else
-			vcpu->arch.mp_state = state;
+			kvm_set_mp_state(vcpu, state);
 		return 1;
 	} else {
 		vcpu->run->exit_reason = reason;
@@ -11804,10 +11803,10 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		goto out;
 
 	if (mp_state->mp_state == KVM_MP_STATE_SIPI_RECEIVED) {
-		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_INIT_RECEIVED);
 		set_bit(KVM_APIC_SIPI, &vcpu->arch.apic->pending_events);
 	} else
-		vcpu->arch.mp_state = mp_state->mp_state;
+		kvm_set_mp_state(vcpu, mp_state->mp_state);
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	ret = 0;
@@ -11934,7 +11933,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	if (kvm_vcpu_is_bsp(vcpu) && kvm_rip_read(vcpu) == 0xfff0 &&
 	    sregs->cs.selector == 0xf000 && sregs->cs.base == 0xffff0000 &&
 	    !is_protmode(vcpu))
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 
 	return 0;
 }
@@ -12237,9 +12236,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm);
 
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 	else
-		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_UNINITIALIZED);
 
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
@@ -13459,7 +13458,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
 	}
 
 	vcpu->arch.apf.halted = false;
-	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+	kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 }
 
 void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d13d..bc3b5a9490c6 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -121,6 +121,11 @@ static inline bool kvm_vcpu_has_run(struct kvm_vcpu *vcpu)
 	return vcpu->arch.last_vmentry_cpu != -1;
 }
 
+static inline void kvm_set_mp_state(struct kvm_vcpu *vcpu, int mp_state)
+{
+	vcpu->arch.mp_state = mp_state;
+}
+
 static inline bool kvm_is_exception_pending(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.exception.pending ||
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index a909b817b9c0..f65ca27888e9 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1480,7 +1480,7 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 	set_bit(vcpu->vcpu_idx, vcpu->kvm->arch.xen.poll_mask);
 
 	if (!wait_pending_event(vcpu, sched_poll.nr_ports, ports)) {
-		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_HALTED);
 
 		if (sched_poll.timeout)
 			mod_timer(&vcpu->arch.xen.poll_timer,
@@ -1491,7 +1491,7 @@ static bool kvm_xen_schedop_poll(struct kvm_vcpu *vcpu, bool longmode,
 		if (sched_poll.timeout)
 			del_timer(&vcpu->arch.xen.poll_timer);
 
-		vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
+		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 	}
 
 	vcpu->arch.xen.poll_evtchn = 0;
-- 
2.47.1.688.g23fc6f90ad-goog


