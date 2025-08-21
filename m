Return-Path: <kvm+bounces-55411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0FD1B3088D
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 23:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 804B95882E3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 21:43:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 072F92EA478;
	Thu, 21 Aug 2025 21:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="06Tufx1W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF662E92AB
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 21:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755812540; cv=none; b=fQp3HkQFUXKI7Nj1xjq/6zzD90JgZUmflYSbt7R2KWFRN1TiOP3MyNFRWSVF2iRrR+4AIAN5o+OUMiMJNmwvc8CcNhWvq7ITBQPmYQT9/oc6pEqb/NaFQnZTPckrOWPN+cIjCCIf/IfiGNlZ6Rhvfi28hLQjhzk/aqJ4UsVRpME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755812540; c=relaxed/simple;
	bh=jO/gj25JzhDalfYTefJGdFK+irEJClGBRvjVRqOnfsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u9+K5RV9NOcyIe6AgCmb3pyJg0FZy3hjewqTTZZHTKBQfTToO+XoDiTmo8w7k8qctwpBfDCQbL7NJazlesLW84Ry96ohOPQvcBXDfImn67VF1IfNOoNRm7pRaETtGpQXrv/HFD5eWsC5CZacITDUPdBppl4ZbtR/i3Z1cFBgnHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=06Tufx1W; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806eab4so16977525ad.1
        for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 14:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755812537; x=1756417337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=e8pkHcdgPqI0ISkr0EzZdXVU8MYoR6lkGEb75P/NGP4=;
        b=06Tufx1WuMNaTrR661jIZWG5iTeBq6DmlLsWZccwUdqBAxCPtMD4VbklqCE0qEsEMz
         hcV7sb3dadXFg0cjkWijsvNore2DrVAEoj1hN2La7XS3WDszAtKQpH949aKgAlNaGKm2
         0ZsTuwoKpStjSr668nf1Os1TzzUeTs7jMzY++uP8wTyuYvTnvbiY2yaHdZjKhss5K5lt
         jlHgoynlK0EpshLmIaCeJGcfgWvlEaE3rgIMMyFUNfbTaGnHmXPOk3ukYpKJanUcYonZ
         CpxMhO2d2XKWQKTUgs5coTy+wLglDsArvymPI/35GApyq5cD4RuDbd8qAHJ6XwxG4kEe
         c5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755812537; x=1756417337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e8pkHcdgPqI0ISkr0EzZdXVU8MYoR6lkGEb75P/NGP4=;
        b=vxLppEPSXbw31lereS4/qsXYUCktuf82vO+BYiSof9fVJJZzNcrJwxeKLcOZMeKukX
         KP5J8xTxbkP9zP57Bhie5lIa2adJUSpJORRO9DqkAflXM9f1DuKGrwFRoSXoTg0HUY2S
         4kGNLrc0sRb3ZVsC9Lcd8PNmmWxd4DbRzfD8K7ZHmrFBTrAsLqzZDU90PJdzsbwLLs5X
         F32ir3O1Z345tG55ygDE3QTFK8ilcHJ1Ux8bve9+tek++TELhzt8iIJ5fyzodiwKFCci
         4eu/5bOTB0kNLlxSwPfVng4jL8wCdJFsb5WDzakA6xOuC74Xx9qPlcKO0uGqhT5w1Ae2
         cUqg==
X-Gm-Message-State: AOJu0Yxkhd3y1rGAH4CVI9ruxFh8MlwdDAGIAtiPV1WilNg7NNeGvvMN
	AFnzjv9ndkl0BGRe48Ovs1IzhyDEwhE83Lmm+XjzrSW5Zb1/6J2/9PPEcR+AAbZaMgPh85HosDs
	Tq0cVwQ==
X-Google-Smtp-Source: AGHT+IFT6Sn/6lo/x/nO8mYo4e+XE4zjzpgAf9RzlJKpSlQeT3lTnfh3y0Zb8gxOWD92wxfJvI93w2u+hBs=
X-Received: from pjbsi8.prod.google.com ([2002:a17:90b:5288:b0:320:e3b2:68de])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2a8b:b0:246:3964:63dc
 with SMTP id d9443c01a7336-2463964650fmr4102925ad.47.1755812537064; Thu, 21
 Aug 2025 14:42:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:42:09 -0700
In-Reply-To: <20250821214209.3463350-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821214209.3463350-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821214209.3463350-4-seanjc@google.com>
Subject: [PATCH 3/3] KVM: x86: Move vector_hashing into lapic.c
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move the vector_hashing module param into lapic.c now that all usage is
contained within the local APIC emulation code.

Opportunistically drop the accessor and append "_enabled" to the variable
to help capture that it's a boolean module param.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 arch/x86/kvm/x86.c   | 8 --------
 arch/x86/kvm/x86.h   | 1 -
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1a8bc81973e3..6fac6fb86c19 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -74,6 +74,10 @@ module_param(lapic_timer_advance, bool, 0444);
 #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+
+static bool __read_mostly vector_hashing_enabled = true;
+module_param_named(vector_hashing, vector_hashing_enabled, bool, 0444);
+
 static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data);
 
@@ -1152,7 +1156,7 @@ static inline bool kvm_apic_map_get_dest_lapic(struct kvm *kvm,
 	if (!kvm_lowest_prio_delivery(irq))
 		return true;
 
-	if (!kvm_vector_hashing_enabled()) {
+	if (!vector_hashing_enabled) {
 		lowest = -1;
 		for_each_set_bit(i, bitmap, 16) {
 			if (!(*dst)[i])
@@ -1293,7 +1297,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
 				r = 0;
 			r += kvm_apic_set_irq(vcpu, irq, dest_map);
 		} else if (kvm_apic_sw_enabled(vcpu->arch.apic)) {
-			if (!kvm_vector_hashing_enabled()) {
+			if (!vector_hashing_enabled) {
 				if (!lowest)
 					lowest = vcpu;
 				else if (kvm_apic_compare_prio(vcpu, lowest) < 0)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7ba2cdfdac44..554b36de700c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -164,9 +164,6 @@ module_param(kvmclock_periodic_sync, bool, 0444);
 static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, 0644);
 
-static bool __read_mostly vector_hashing = true;
-module_param(vector_hashing, bool, 0444);
-
 bool __read_mostly enable_vmware_backdoor = false;
 module_param(enable_vmware_backdoor, bool, 0444);
 EXPORT_SYMBOL_GPL(enable_vmware_backdoor);
@@ -13552,11 +13549,6 @@ bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
-bool kvm_vector_hashing_enabled(void)
-{
-	return vector_hashing;
-}
-
 bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	return (vcpu->arch.msr_kvm_poll_control & 1) == 0;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index eb3088684e8a..786e36fcd0fb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -431,7 +431,6 @@ void kvm_deliver_exception_payload(struct kvm_vcpu *vcpu,
 
 int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
-bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 				    void *insn, int insn_len);
-- 
2.51.0.261.g7ce5a0a67e-goog


