Return-Path: <kvm+bounces-65391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D252CA9A1F
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:29:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB87530AAD59
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B5818DB1F;
	Fri,  5 Dec 2025 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="14jDRNeM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A382A302CB2
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976778; cv=none; b=T0IFmHJyrl++AQMKxqyyN0Jqgopl+jeNMLxk1McoPCGS+MS8gHNuzZAgxjP9IdT/BL8xcuIebZV27LhOKCOaxIXh6C6ncdgSa/Eh5BMQfFRSOnjy8vIF9HDK5tgNUfSOOBz/zRvolR2sPvFA7HJO6ruKHGEsNErg4U0rDoAxfWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976778; c=relaxed/simple;
	bh=fQs9AfY4pm0GPg9NaBoZ2jNCluwsJfr8qcla3WFMQ5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZsBJky3nM4Ol930UmVBHT7/DBumKwSfGlUm8oqzW+ZHZW4NrPBpdKCifp+6hTIyS0WZrr9Mw/oylcJsfs1nOg3h0/6dE3ey0ZK+xerLlnnDoIRljED+7FX7t5EDaaqoQxbketuj4CJbLSN4SofmFkPRZ2Yv2NnPo9zaiCE6y+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=14jDRNeM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438b1220bcso3030090a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976776; x=1765581576; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=R6Kh5m2LegPUGsggLmMPv+v4opTfSNM4AlIRI1Wku5c=;
        b=14jDRNeMGHFHePsgl6Bf120m09Clveii24iiT00fajV9FuohrW8AJRiIryYxLiWzxz
         R0UwvwpI0MjTUFCpsEFx7X6WnH115uA2ZskBVrl62oorCCzYAQ2FWjUTos/mSQZL6LyO
         XEq74B115Ox5bmeCiRUVJFqLx39BkvrmoiV4h4g8n8iGZWso95YaQANL9RufxPMvir0a
         iDnlevPTmIldE4qUcwlqO0Ud8K/cdi+qVlZ5jHhr1oGuQJL/QmQyXTMjYSXWlegtXiTf
         17rQn8ZD0Vuu+o8qiWoUKL9X7sl2Ue5pXMUjD5I1MnpN5/kZU6Ub89nU2Iw67XOkhCHG
         a3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976776; x=1765581576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R6Kh5m2LegPUGsggLmMPv+v4opTfSNM4AlIRI1Wku5c=;
        b=B2pHWdeUazglOzg6KZLYU+8CJ8oo8+dY8W4GRN4aBfm6FmIqtgZx35C9KBRmz9mDMd
         yTdEy6RJP47jLl+Ive34vwYZYiKltG3ZGn4Ft0NeDaFJwsQ82IL2gb+C1Ua2z17Xfi18
         /D3ncy+pVeqnOCyf0MBAGjgCy2tUNI7QTdzXN9JkOHaX9XYHflvts3ZjzMITwfygFjoQ
         FnU3A3/ipP/9pUHPdKSQZXD4nI2W8Kyee3pxU8vCfH6AMT5HUDrmSvR+trx6dBhpSSeb
         5Dyou8KE1ABsjjG/zhzaLtVVMfzYVLCYVH7CI+pZWNs6ekBmLkymW/40Qch0rS/0O+dC
         H1OQ==
X-Gm-Message-State: AOJu0YwsGLmx0xMh6Kv/TJXUmVlQD2gPdKYLoLNO1c658qeTkoMA22lC
	WNQAOYRXt9Oa2rimqUy635F7lv6qOPRuvfh/m9VfXTnzFZOa4zWYNL6BX2vzC1MAerZaTRsCArj
	+tIRV0g==
X-Google-Smtp-Source: AGHT+IFHszwzJY+d/pKFPd2umP7/T4Pfq1HZsW4vbjXxV03FbJa0O3laYvMbjqBNzPWcHszIzGKJzLfhTxQ=
X-Received: from pjis4.prod.google.com ([2002:a17:90a:5d04:b0:340:b1b5:eb5e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d12:b0:330:7a32:3290
 with SMTP id 98e67ed59e1d1-349a26ea323mr429506a91.37.1764976775849; Fri, 05
 Dec 2025 15:19:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:13 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-11-seanjc@google.com>
Subject: [PATCH v3 10/10] KVM: x86: Update APICv ISR (a.k.a. SVI) as part of kvm_apic_update_apicv()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Fold the calls to .hwapic_isr_update() in kvm_apic_set_state() and
__kvm_vcpu_update_apicv() into kvm_apic_update_apicv(), as updating SVI is
directly related to updating KVM's own cache of ISR information, e.g.
SVI is more or less the APICv equivalent of highest_isr_cache.

Note, calling .hwapic_isr_update() during kvm_apic_update_apicv() has two
benign side effects.  First, it adds a call during kvm_lapic_reset(), but
that's a glorified nop as the ISR has already been zeroed.  Second, it
changes the order between .hwapic_isr_update() and
.apicv_post_state_restore() in kvm_apic_set_state(), but the former is
VMX-only and the latter is SVM-only, i.e. is also a glorified nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 21 +++++----------------
 arch/x86/kvm/lapic.h |  1 -
 arch/x86/kvm/x86.c   |  2 --
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1597dd0b0cc6..7be4d759884c 100644
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
@@ -2785,10 +2774,12 @@ void kvm_apic_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	apic->irr_pending = true;
 
-	if (apic->apicv_active)
+	if (apic->apicv_active) {
 		apic->isr_count = 1;
-	else
+		kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
+	} else {
 		apic->isr_count = count_vectors(apic->regs + APIC_ISR);
+	}
 
 	apic->highest_isr_cache = -1;
 }
@@ -3232,10 +3223,8 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
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
index ff8812f3a129..66c5edbbda2b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10894,8 +10894,6 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	 */
 	if (!apic->apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
-	else
-		kvm_apic_update_hwapic_isr(vcpu);
 
 out:
 	preempt_enable();
-- 
2.52.0.223.gf5cc29aaa4-goog


