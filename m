Return-Path: <kvm+bounces-54050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA5C5B1BAB8
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 934A7628049
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5464C2C15A1;
	Tue,  5 Aug 2025 19:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VpnuU6x7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1B22C08AD
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420762; cv=none; b=uLWyeGgoK4ww47l8Eg6VDAfm12JThuVnsdKXtG0Vhm3yHUDxK7gYEI50racmQ/INi2Rs0o0wo+wPzZNFXHKvLJWaXLl7nXyTXaXxPuIwSMMn/VQSQesPXO+e4KwaqprO5/Dlw1v2RW0KuzjFqFsiZVgfh0I/LaqbBbQ9zPm5Rw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420762; c=relaxed/simple;
	bh=zATxkyxAcSPZiTxDepTukQWJ8dyUc3y2yARhHF2lPNo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lxy4F/w+/3F6bBC0cUzPaV07GMdqzxd+AcEkTcD7vPbsq0wKwQDqoYMf3i+w7y41v+s8Hg4aVzbLAgrSICJr7UYvZMxc39pVYSTJBRDwZiwERZSs13yya4Yk9uBwEYDrBpWbd4cBrpeVG06LmOqLfucObStCjyvVkzizlcJZ0dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VpnuU6x7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea6231678so144252a91.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420760; x=1755025560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rAVrGWcmedyfCvbeUeNYdLWZXibA/eVVDu2b3ZtfBaQ=;
        b=VpnuU6x7oAbvKQP03oy+uT1Rs2ZLS9gMTtf9f8mCuuyLgzNF9LYGz9Z6fYj59xoxHi
         Q+IExm9N8nxQA2tAiB00E4A6/Z0KAf9ntbOH3A1qDizz60t53PCv4mI3ApxfIsweoRLK
         kt++a8JWNVZQMeaeriMXw0izO0TpLtIBDTtcPvUrvIQtR2AiaxVALWcYdvJ8w/RZq3GO
         FH5aAOORD4PnK0PgwXO6qIR5BuF+N5KxNC8+46rXHYLYSHPoQQWtCNpl5du5QRHR4w2Y
         3ZloOqSHOcvz8Z0WD3JSlARlvUInFs0zG5f5LeQ92klXwGkiOATBgA+czQU4ZYPE8eI3
         54+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420760; x=1755025560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rAVrGWcmedyfCvbeUeNYdLWZXibA/eVVDu2b3ZtfBaQ=;
        b=mO0SvrZTVTdFjC78ACSlfEeNUlJ56AAulJwrYqgC/133R7wGSyhyOcGxH9nefX184P
         C7IF4yYOnhNVJdMb7Qram7KLiy/ms03WucoNeYq97/8qhIYe5g9OCxjn3Zwh5PNpJaUJ
         LtoeMw8Oq5efE0mthqVQxMIEdYO9YZP0si1v00fc6ek17Jiwclnu9VaL4+jDuNvD61Uy
         y2XalNOsgnFLPOBtpQBu64Nv+aNZ36Hz9g+VzrIbS4UG96j+Q7MYoN7Y7DKJXJLDCBPj
         azwc6cdJySRe9ZGBvISzY2hTtSgd+55B1v9v1FHhMoIMHXXj/eN4J8HpPn1WZAfXoePN
         SpSg==
X-Gm-Message-State: AOJu0YwCL0Zg/1c95XcJGD8+IO3vzJzgWRGyh3PpBEsPCFNylE9mbkPX
	yqZ+vpRhb2j5xzJnSDGBaCKsk0soG8RZynJ0AQPiPAP1VUNutdMyb+SNjFKqbRi1WXr5ny6SgTL
	SrTHPGg==
X-Google-Smtp-Source: AGHT+IHN8xHb/VjKiH3ppGdR8gJCBUsLr/MHH+tOxG5LkRUI154GMU25wC6+IauyXC0h6zXwo/6t8nUNWuw=
X-Received: from pjsk12.prod.google.com ([2002:a17:90a:62cc:b0:31f:37f:d381])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:568d:b0:31f:ecf:36f
 with SMTP id 98e67ed59e1d1-3216684b48dmr113350a91.1.1754420760530; Tue, 05
 Aug 2025 12:06:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:25 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-18-seanjc@google.com>
Subject: [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Acquire SRCU in the VM-Exit fastpath if and only if KVM needs to check the
PMU event filter, to further trim the amount of code that is executed with
SRCU protection in the fastpath.  Counter-intuitively, holding SRCU can do
more harm than good due to masking potential bugs, and introducing a new
SRCU-protected asset to code reachable via kvm_skip_emulated_instruction()
would be quite notable, i.e. definitely worth auditing.

E.g. the primary user of kvm->srcu is KVM's memslots, accessing memslots
all but guarantees guest memory may be accessed, accessing guest memory
can fault, and page faults might sleep, which isn't allowed while IRQs are
disabled.  Not acquiring SRCU means the (hypothetical) illegal sleep would
be flagged when running with PROVE_RCU=y, even if DEBUG_ATOMIC_SLEEP=n.

Note, performance is NOT a motivating factor, as SRCU lock/unlock only
adds ~15 cycles of latency to fastpath VM-Exits.  I.e. overhead isn't a
concern _if_ SRCU protection needs to be extended beyond PMU events, e.g.
to honor userspace MSR filters.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c |  4 +++-
 arch/x86/kvm/x86.c | 18 +++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e75671b6e88c..3206412a35a1 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -955,7 +955,7 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	struct kvm_pmc *pmc;
-	int i;
+	int i, idx;
 
 	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE != X86_PMC_IDX_MAX);
 
@@ -968,12 +968,14 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
 			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
 		return;
 
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
 		if (!pmc_is_event_allowed(pmc) || !cpl_is_matched(pmc))
 			continue;
 
 		kvm_pmu_incr_counter(pmc);
 	}
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 }
 
 void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f2b2eaaec6f8..a56f83b40a55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2137,7 +2137,6 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 {
 	u64 data = kvm_read_edx_eax(vcpu);
 	u32 msr = kvm_rcx_read(vcpu);
-	int r;
 
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
@@ -2152,13 +2151,12 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 	}
 
-	kvm_vcpu_srcu_read_lock(vcpu);
-	r = kvm_skip_emulated_instruction(vcpu);
-	kvm_vcpu_srcu_read_unlock(vcpu);
-
 	trace_kvm_msr_write(msr, data);
 
-	return r ? EXIT_FASTPATH_REENTER_GUEST : EXIT_FASTPATH_EXIT_USERSPACE;
+	if (!kvm_skip_emulated_instruction(vcpu))
+		return EXIT_FASTPATH_EXIT_USERSPACE;
+
+	return EXIT_FASTPATH_REENTER_GUEST;
 }
 EXPORT_SYMBOL_GPL(handle_fastpath_set_msr_irqoff);
 
@@ -11251,13 +11249,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_halt);
 
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
-	kvm_vcpu_srcu_read_lock(vcpu);
-	ret = kvm_emulate_halt(vcpu);
-	kvm_vcpu_srcu_read_unlock(vcpu);
-
-	if (!ret)
+	if (!kvm_emulate_halt(vcpu))
 		return EXIT_FASTPATH_EXIT_USERSPACE;
 
 	if (kvm_vcpu_running(vcpu))
-- 
2.50.1.565.gc32cd1483b-goog


