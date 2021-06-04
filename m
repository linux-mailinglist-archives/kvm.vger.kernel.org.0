Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E19139BEBA
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhFDR3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:37 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:54083 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFDR3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:36 -0400
Received: by mail-qt1-f201.google.com with SMTP id i12-20020ac860cc0000b02901cb6d022744so5586433qtm.20
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XlUk4pd7ZXaHcyBXLC2fZswqyhx828J/Q4tmnaU+kr4=;
        b=sFU9tmBV/um9g06KK4DLM6sqpMu9jDxyML/HjlJ4fM2DPDpXFLIRY0qBGKvXj50O6T
         VON3PaDO3sIm7k92Aiqj2y4PGphPSpftp0PdRfAY0VEbmfrWEb0IPye5vmX8nOj3XOKV
         WpeyDNp5SXQy9cpL4792sSRVJ00I+uJHrWyz4033zKERuYrrVqv7akZy82rsYKUpaHl5
         1L1WpWPK6rJlWr1PXD/HEAAkmOfkieMWtaKq71av9+Mbg4YqIo33Sg4kexbsJCDq3DO7
         U5osZ2KoO44H5B8d0ghshSmGxi8n+hdMX8i535aABDMUlDfxCsdNZmRvWrxtoV3OMjNH
         F1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XlUk4pd7ZXaHcyBXLC2fZswqyhx828J/Q4tmnaU+kr4=;
        b=m1e3n/T/+28JztflN8Kp+dO2ZlyMKCqlVyHXaEZQwUoUH07YIsLQfuXDULO7CkroH+
         1AsE9jfffd3VTTx599xbq59lYW3r82KWSd155J8a0pu6NAPeFBU+Ap1BLi6X+KGd8obE
         4yta7eXkjlJ30T15nway2UZYTq/MdoANZG15y23H8UAB9tJkMwa2juD1BpzJENbphZNI
         a7yeVwoXBY7A8l20bwkEq+gpD56sNGG+/89WgGairhASgTYi1DyUDTb/OZS3u6Rhowzr
         nEfogsaWkRF1HWkW6YvtRhcG1US/YFogS3SNG8miMBZI3yoNTay4EYuoMJTrLE+alAXR
         X7iQ==
X-Gm-Message-State: AOAM532t96g0/ATEw5WqaJRpaCfroJnSgiigrw7UAaQU+1hzt2E7IQHQ
        37N+iv2rw3V+ThJ9HkvrGs3iWLglZ3dKVh5wBVB/AAXhsozvwZ4chAdRHt2T4IM85zfa8mFwrI1
        rt5wquLZgchVxmfv8SoWYw7AVbxqJNihWJMICPLBo7Kp1QvTT+87Gd5PYNmPoE+o=
X-Google-Smtp-Source: ABdhPJx3vuhC/RFsamaEmoMfknzBiNbGM73yxM8nJL/uu/cx/b/u6xaS5tiPJgvphwrEzWf9nRjlzrxxYGdA5w==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:ad4:4e2e:: with SMTP id
 dm14mr5916921qvb.33.1622827595917; Fri, 04 Jun 2021 10:26:35 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:04 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-6-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 05/12] KVM: x86: Add a return code to kvm_apic_accept_events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended. At present, the only negative value
returned by kvm_check_nested_events is -EBUSY.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++-----
 arch/x86/kvm/lapic.h |  2 +-
 arch/x86/kvm/x86.c   | 25 ++++++++++++++++++++-----
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8120e8614b92..6a315ade6c41 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2864,7 +2864,7 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
 }
 
-void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
+int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u8 sipi_vector;
@@ -2872,7 +2872,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	unsigned long pe;
 
 	if (!lapic_in_kernel(vcpu))
-		return;
+		return 0;
 
 	/*
 	 * Read pending events before calling the check_events
@@ -2880,12 +2880,12 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	 */
 	pe = smp_load_acquire(&apic->pending_events);
 	if (!pe)
-		return;
+		return 0;
 
 	if (is_guest_mode(vcpu)) {
 		r = kvm_check_nested_events(vcpu);
 		if (r < 0)
-			return;
+			return r == -EBUSY ? 0 : r;
 		/*
 		 * If an event has happened and caused a vmexit,
 		 * we know INITs are latched and therefore
@@ -2906,7 +2906,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		if (test_bit(KVM_APIC_SIPI, &pe))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		return;
+		return 0;
 	}
 
 	if (test_bit(KVM_APIC_INIT, &pe)) {
@@ -2927,6 +2927,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
 		}
 	}
+	return 0;
 }
 
 void kvm_lapic_exit(void)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 997c45a5963a..d7c25d0c1354 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -76,7 +76,7 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu);
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
 int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
-void kvm_apic_accept_events(struct kvm_vcpu *vcpu);
+int kvm_apic_accept_events(struct kvm_vcpu *vcpu);
 void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event);
 u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
 void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f9b3ea916344..51d3b9ff4d96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9245,7 +9245,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
 	    kvm_xen_has_interrupt(vcpu)) {
 		++vcpu->stat.req_event;
-		kvm_apic_accept_events(vcpu);
+		r = kvm_apic_accept_events(vcpu);
+		if (r < 0) {
+			r = 0;
+			goto out;
+		}
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
 			r = 1;
 			goto out;
@@ -9457,7 +9461,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 			return 1;
 	}
 
-	kvm_apic_accept_events(vcpu);
+	if (kvm_apic_accept_events(vcpu) < 0)
+		return 0;
 	switch(vcpu->arch.mp_state) {
 	case KVM_MP_STATE_HALTED:
 	case KVM_MP_STATE_AP_RESET_HOLD:
@@ -9681,7 +9686,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 		kvm_vcpu_block(vcpu);
-		kvm_apic_accept_events(vcpu);
+		if (kvm_apic_accept_events(vcpu) < 0) {
+			r = 0;
+			goto out;
+		}
 		kvm_clear_request(KVM_REQ_UNHALT, vcpu);
 		r = -EAGAIN;
 		if (signal_pending(current)) {
@@ -9883,11 +9891,17 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
+	int r;
+
 	vcpu_load(vcpu);
 	if (kvm_mpx_supported())
 		kvm_load_guest_fpu(vcpu);
 
-	kvm_apic_accept_events(vcpu);
+	r = kvm_apic_accept_events(vcpu);
+	if (r < 0)
+		goto out;
+	r = 0;
+
 	if ((vcpu->arch.mp_state == KVM_MP_STATE_HALTED ||
 	     vcpu->arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) &&
 	    vcpu->arch.pv.pv_unhalted)
@@ -9895,10 +9909,11 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	else
 		mp_state->mp_state = vcpu->arch.mp_state;
 
+out:
 	if (kvm_mpx_supported())
 		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);
-	return 0;
+	return r;
 }
 
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
-- 
2.32.0.rc1.229.g3e70b5a671-goog

