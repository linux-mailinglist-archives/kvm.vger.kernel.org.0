Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D16B38B9F8
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 01:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhETXFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 19:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbhETXFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 19:05:23 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291A5C061761
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:01 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id v13-20020ac8578d0000b02901e4f5d48831so13497911qta.14
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 16:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=b7yOHMmFLrcErOMnqY+LVtxy8Wx78poOjcCXOFGFxdM=;
        b=laSXRSNVyv4GpLF+bQLsDCxDUz888lefm3aOVowOShUM7nPiAMZ2gzKTarpAZX4jRR
         xXaShoVoYsPWsFRZNFLXJ6Z6Mlt+PhRS4+B84BcObGhM0N8VKq5G3BaziyykU79S9xJv
         4m4SCQwExdKJs87enqQ1T4F8rfscuiTayCRY9P2T0a3UVSr6+bjKjZRPxVZFhz6vvOCv
         iWM6EyNtPi32gk+QHf3a3NcTXHc5r/LW40iPPwVey0bBzXZHLLQkF8SyijDEWWAERTmH
         +lfvozr2/4X+gX1p6qULMYajnuxYIlPuytaSFei4qsJU89DFfYDpNkLFjOAS21BfgB2b
         dmfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=b7yOHMmFLrcErOMnqY+LVtxy8Wx78poOjcCXOFGFxdM=;
        b=c8oi64hTQflBTeYQ26Qxyr5PX1mY/ztAOegadI1pf6IlLRiRs8nRKAPv3oQBKzcFiR
         S1GcjnK6qfyfH2A/MygYWlGalfyXaZCX0No23Qh1cdjBzkmvCckfiCqQ47e3G4HBjpgQ
         wK0+LHdh8cffKjxaoa0TwjMEaFaHuN4/KayWjnhuJTWpvFbveSPwaM6e/avKNawdI+F5
         Rk/m846iWhNJGjIYDsCHFtY6jxfKpcXgPgM8aGLkS4JbPbPPMA8txp5mbKgVs8csC62Z
         UhbMuCgeBsQxgLYHGpDoK9BdDKGr8OCS87CtR4U+BqZE8gVCIbPH+TXtF2tglkU0Eyyg
         kAaA==
X-Gm-Message-State: AOAM531i8bfel0X/nLUPkIZlHgbj1x095PI5AgKpjnPn7WTID/2DtGpE
        8KZTrpFTD/rddUyROB3l4os50fJgJXyOQqurCfrKwKPh2b2O3BtSLLac4WVVEQRjkpn+RNfSrWe
        m/ifMWAl/X1EG5+1JmwSwTYmivf7/muC2FyhDVpGp20UJe8sXH0GLX4ko69vysiQ=
X-Google-Smtp-Source: ABdhPJw0Amz/b8LPfhFK+uKtNdR3vLN6Np/cuHxop+moFmEn3fD4NNFMAk7K1dF0SMSoDUSY2ZB/NHhFBKW6Hw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:ad4:54c9:: with SMTP id
 j9mr8889175qvx.62.1621551840042; Thu, 20 May 2021 16:04:00 -0700 (PDT)
Date:   Thu, 20 May 2021 16:03:32 -0700
In-Reply-To: <20210520230339.267445-1-jmattson@google.com>
Message-Id: <20210520230339.267445-6-jmattson@google.com>
Mime-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 05/12] KVM: x86: Add a return code to kvm_apic_accept_events
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional change intended. At present, the only negative value
returned by kvm_check_nested_events is -EBUSY.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++-----
 arch/x86/kvm/lapic.h |  2 +-
 arch/x86/kvm/x86.c   | 22 ++++++++++++++++++----
 3 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c0ebef560bd1..f747864ff323 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2856,7 +2856,7 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
 }
 
-void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
+int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u8 sipi_vector;
@@ -2864,7 +2864,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 	unsigned long pe;
 
 	if (!lapic_in_kernel(vcpu))
-		return;
+		return 0;
 
 	/*
 	 * Read pending events before calling the check_events
@@ -2872,12 +2872,12 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
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
@@ -2898,7 +2898,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
 		if (test_bit(KVM_APIC_SIPI, &pe))
 			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
-		return;
+		return 0;
 	}
 
 	if (test_bit(KVM_APIC_INIT, &pe)) {
@@ -2919,6 +2919,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
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
index eb35536f8d06..9258fee4f272 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9242,7 +9242,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
@@ -9454,7 +9458,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
 			return 1;
 	}
 
-	kvm_apic_accept_events(vcpu);
+	if (kvm_apic_accept_events(vcpu) < 0)
+		return 0;
 	switch(vcpu->arch.mp_state) {
 	case KVM_MP_STATE_HALTED:
 	case KVM_MP_STATE_AP_RESET_HOLD:
@@ -9678,7 +9683,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
@@ -9880,11 +9888,16 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
+	int r = 0;
+
 	vcpu_load(vcpu);
 	if (kvm_mpx_supported())
 		kvm_load_guest_fpu(vcpu);
 
-	kvm_apic_accept_events(vcpu);
+	r = kvm_apic_accept_events(vcpu);
+	if (r < 0)
+		goto out;
+
 	if ((vcpu->arch.mp_state == KVM_MP_STATE_HALTED ||
 	     vcpu->arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) &&
 	    vcpu->arch.pv.pv_unhalted)
@@ -9892,6 +9905,7 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 	else
 		mp_state->mp_state = vcpu->arch.mp_state;
 
+out:
 	if (kvm_mpx_supported())
 		kvm_put_guest_fpu(vcpu);
 	vcpu_put(vcpu);
-- 
2.31.1.818.g46aad6cb9e-goog

