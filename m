Return-Path: <kvm+bounces-8501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 062E484FFC7
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B4CE1C22608
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF39939FE1;
	Fri,  9 Feb 2024 22:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u4HpbLX8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6B038FBE
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707517253; cv=none; b=X556QNSBNJ55F5A5XCzXDEeULqdSNMoyA5uisCwPyqp/zPmSHYvdMuSp7fZPfa8cV/I/vsPYXZ/OLnsVcv6o7L4gEqJx5nOSTQwk9gDpFeFdTTXOhaQAnDSxXjFadIBNXOGtBWvZtrSlsdmqQ6Y7oIRqi8NRSCn7B3i7q1sE4Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707517253; c=relaxed/simple;
	bh=sq7lyUPuX+bZmIv/3kU7sl8tk0+vliGbARyV9b8Pmfs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QzxINe0mH2UX6f8CzUAvejo1rww1xkgFSy90ULO6sP8yfLhUex1NKhy/8Il8S3GiqLOqhnpv48rPndP3Z6syWpCLLsgmVm9fn2K9zmFW67sJ2pP28J8Ch2I4ccsvA4Mjqewi4kfjOe13id+3jIGx6WN9W9BVLyFlFFbrIHfi678=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u4HpbLX8; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e05118feabso1492035b3a.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707517251; x=1708122051; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GVXvcn6uB6wIRuqNemacA52ZGVu0PaYsVKCrJlCzyuw=;
        b=u4HpbLX8JcO2nzTE6Xwc/uN7LHKkA+XudR3D+P9yNVWhkEnbq5hAfi3MCT0pczRSDH
         NBsgCRU6Fd00qyWQ5TiNbyY53YyhgbqB3tFfgUmmtb3Iat9iWXYI7UAeLMyuZW7UUccR
         Jak9y8UHYlm0tc9ZKrtwWoecNae0UgIoi+TOcBfF2S0BbjgLSAo2R5YmY4yv1DfE8KWa
         bb4YlpeT8wSjGHMSdeVIz4x8Bs2SeezxlP5JJ5FRlUJ7a8Q8obO+zRaZFVMLQFwHFh2A
         JySZVod1PdxWGNxUkhaTOatV5wPq9dhUuZZUB+uuSYUcBuv65bylf5CDSjvx00aDTg/O
         Fz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707517251; x=1708122051;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GVXvcn6uB6wIRuqNemacA52ZGVu0PaYsVKCrJlCzyuw=;
        b=JbbMBJ7C52Ld3tqt7mwGxMGQxEv2qjjkqxD8R4y2/lYHCl0NLy2uOdtz35WQ2Ucqnx
         Of+YIsUrBg4tUKwspA16bw3IGyy4PjCwoNxp5kjN5DBcfON96volMpZJGQw8XcsxDzS7
         QBVOrVBb2F+/vzZyMwDxdqidaR8G1I8nnF5LURb8ZcsvC/9i7QNYZC+Y30sx9BcaU6Nr
         pL2bBYyWLrMMQ0r4vqfqEywZKd30zhku7rPjDEFYgrc626hrsmCyepMuX5x+86oi3UHV
         Kxdsk4exBAgSwgp2UyThpAWgql77jPfipHErt4anMGbzRF+kDuKk09JRNVJ3o6yWMkRr
         k8+Q==
X-Gm-Message-State: AOJu0YxA9XWr5fzrQmqgEmEy508jVAmXpeFUmq3wH4TSQTopCu+fK6W/
	F0+uQcalWAhZrLUJiGulpIriTmcAfgmM72MxzO4JVMHv0V5h6BOX9ubWpbrQUCXXUdTAeQ9GT9n
	7Pw==
X-Google-Smtp-Source: AGHT+IFPV5uyb68fUIJPtq8a4CaQ4lPPx4Tq8WYJiSe1vUbvkkeusQZiLXsza1gwmEtbSVCZ93DHoumhets=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d94:b0:6e0:351e:cea7 with SMTP id
 fb20-20020a056a002d9400b006e0351ecea7mr21807pfb.2.1707517250995; Fri, 09 Feb
 2024 14:20:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Feb 2024 14:20:46 -0800
In-Reply-To: <20240209222047.394389-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240209222047.394389-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <20240209222047.394389-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86: Move "KVM no-APIC vCPU" key management into
 local APIC code
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Move incrementing and decrementing of kvm_has_noapic_vcpu into
kvm_create_lapic() and kvm_free_lapic() respectively to fix a benign bug
bug where KVM fails to decrement the count if vCPU creation ultimately
fails, e.g. due to a memory allocation failing.

Note, the bug is benign as kvm_has_noapic_vcpu is used purely to optimize
lapic_in_kernel() checks, and that optimization is quite dubious.  That,
and practically speaking no setup that cares at all about performance runs
with a userspace local APIC.

Reported-by: Li RongQing <lirongqing@baidu.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c   | 29 +++--------------------------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..681f6d82d015 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -124,6 +124,9 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
+__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
+EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
+
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
 
@@ -2466,8 +2469,10 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!vcpu->arch.apic)
+	if (!vcpu->arch.apic) {
+		static_branch_dec(&kvm_has_noapic_vcpu);
 		return;
+	}
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
@@ -2809,6 +2814,11 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	ASSERT(vcpu != NULL);
 
+	if (!irqchip_in_kernel(vcpu->kvm)) {
+		static_branch_inc(&kvm_has_noapic_vcpu);
+		return 0;
+	}
+
 	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT);
 	if (!apic)
 		goto nomem;
@@ -2844,6 +2854,21 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	static_branch_inc(&apic_sw_disabled.key); /* sw disabled at reset */
 	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
+	/*
+	 * Defer evaluating inhibits until the vCPU is first run, as this vCPU
+	 * will not get notified of any changes until this vCPU is visible to
+	 * other vCPUs (marked online and added to the set of vCPUs).
+	 *
+	 * Opportunistically mark APICv active as VMX in particularly is highly
+	 * unlikely to have inhibits.  Ignore the current per-VM APICv state so
+	 * that vCPU creation is guaranteed to run with a deterministic value,
+	 * the request will ensure the vCPU gets the correct state before VM-Entry.
+	 */
+	if (enable_apicv) {
+		apic->apicv_active = true;
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+	}
+
 	return 0;
 nomem_free_apic:
 	kfree(apic);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b66c45e7f6f8..59119157bd20 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12053,27 +12053,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		return r;
 
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
-		if (r < 0)
-			goto fail_mmu_destroy;
-
-		/*
-		 * Defer evaluating inhibits until the vCPU is first run, as
-		 * this vCPU will not get notified of any changes until this
-		 * vCPU is visible to other vCPUs (marked online and added to
-		 * the set of vCPUs).  Opportunistically mark APICv active as
-		 * VMX in particularly is highly unlikely to have inhibits.
-		 * Ignore the current per-VM APICv state so that vCPU creation
-		 * is guaranteed to run with a deterministic value, the request
-		 * will ensure the vCPU gets the correct state before VM-Entry.
-		 */
-		if (enable_apicv) {
-			vcpu->arch.apic->apicv_active = true;
-			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
-		}
-	} else
-		static_branch_inc(&kvm_has_noapic_vcpu);
+	r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
+	if (r < 0)
+		goto fail_mmu_destroy;
 
 	r = -ENOMEM;
 
@@ -12194,8 +12176,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
-	if (!lapic_in_kernel(vcpu))
-		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -12472,9 +12452,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
-
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-- 
2.43.0.687.g38aa6559b0-goog


