Return-Path: <kvm+bounces-54044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A77B1BAA9
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 21:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40CCC18A7312
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 19:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0335B2BE64C;
	Tue,  5 Aug 2025 19:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SrsmURyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E832BDC37
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 19:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754420751; cv=none; b=WYsFunkDKEN+7EXXiNF5kp0PUkVY9ThC7LLTDIVrVgRlbZtf8Hg+ENWWuqhcIE7Agc4UuG6oau8avls0w7HMt1v/8VMMZ7M5r/Xc41VBFlHHy6HWFLvdqaSClIqbe6PwaNKO5XPtXrGw1Q5gnNP9y25/PUyTNmlONdH/ZJCoizA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754420751; c=relaxed/simple;
	bh=0v4/4KHczFm86J8EpOGmKd1AC5YsaffazCEHV5VEVkw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HYTe5h1/R7D6KXVRiGcn5fOQP2gom/5Hk3kyArbUkq6rwejQlNJWZdQhzUROYiNcNjDP8qq5LvfakdstAhOW6AMuZVeRD97w0T5t7MkFvTFqkwd1g7H53SVpN5MoQFBSoaW7NCzCniA/GLaar4P6XiT8ncyQTDqNEtEZ2ya/NLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SrsmURyf; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b423aba05feso4442403a12.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 12:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754420749; x=1755025549; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SMTNldksocyQikuDTQSTc2Wa+EvxEezz/3PYk/VDlp0=;
        b=SrsmURyfixCGZazaZxoxYydfyjMYIOhduTyUouqpsgK9VywERjLizkFZt2xTgH8T98
         kNQINdClh6UVVKCyCJzvHcqe61T1AGTDIB9nkdI83/WgCcNbB+9+Zd8qF1gx22RfSruI
         PZvrcbKq+BxOeyuD3LJUcpBaQUIWAh4cf1TkR4GLJC+BfV2xvM9CvV7w4kmgAVJHpT0h
         Iq6LjmcxN9PxBsaBJu9BYPRpVfnRFoqPDfnkcySaM1EJhwE+JB9LkBIj/EJQNmA1yWhI
         hQvvrqkx1XP3xa/R9Bh/UQDZ06CIfeHZthnfePnOoe56C/YMhz2iosK8MIJT6Aa5GQeW
         zxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754420749; x=1755025549;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SMTNldksocyQikuDTQSTc2Wa+EvxEezz/3PYk/VDlp0=;
        b=dhQi0iwFKZjosYbuelylcOec1nb9NYw6vvAv++fMTX6tlwahEFgdX+5a24YgAEFkqw
         hwRXekJrxMgWgY1Ir7Na1hYJJtLwHSDB8fjXM/asaNpHIoV5eLE1Ke7uOJK7ygE1Z9Gu
         ek9CECrO2afp7Gl6aKVxEebk7jGXL1J9EKqLCfI6GqJS7ehhvMgBprmo6DDGimQdHPT5
         iYXS7N3iqZJJznB3jDtf3RVtv6foF57jFdbH4B5/E0jwO7dWPqj7iFn3L9oIKw3h+zZE
         uLynvKi7rHBnD4X2dNQnDTt1PhUGQoq2SzQpmUJ5c75VsYo8xpuS0OB64iH7LJ5R1yjY
         i6kQ==
X-Gm-Message-State: AOJu0YwPljKzBUO5PVv5wHeRV0TGoEa8HbGLnKrEEjhec6XaW/aRYF/C
	pmgo8pTLd1bpvjrj9eSyvmeU3fDymZEtCPOImDEsQzkCTYs/2Md05mcd5FL7GukhCPiQm2ajjhk
	HfybFBw==
X-Google-Smtp-Source: AGHT+IEkU2DLpTTTF/CafhOsbR+sMu2xr0HobiD/z4Iv5/o9d7+Aigp4lVvqAMuxRXCbFsZ5KjBy8v86iD4=
X-Received: from pjbsx8.prod.google.com ([2002:a17:90b:2cc8:b0:312:187d:382d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e8d:b0:31f:336a:f0db
 with SMTP id 98e67ed59e1d1-3211620ad0fmr21125942a91.10.1754420748685; Tue, 05
 Aug 2025 12:05:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 12:05:19 -0700
In-Reply-To: <20250805190526.1453366-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805190526.1453366-12-seanjc@google.com>
Subject: [PATCH 11/18] KVM: x86/pmu: Calculate set of to-be-emulated PMCs at
 time of WRMSRs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="UTF-8"

Calculate and track PMCs that are counting instructions/branches retired
when the PMC's event selector (or fixed counter control) is modified
instead evaluating the event selector on-demand.  Immediately recalc a
PMC's configuration on writes to avoid false negatives/positives when
KVM skips an emulated WRMSR, which is guaranteed to occur before the
main run loop processes KVM_REQ_PMU.

Out of an abundance of caution, and because it's relatively cheap, recalc
reprogrammed PMCs in kvm_pmu_handle_event() as well.  Recalculating in
response to KVM_REQ_PMU _should_ be unnecessary, but for now be paranoid
to avoid introducing easily-avoidable bugs in edge cases.  The code can be
removed in the future if necessary, e.g. in the unlikely event that the
overhead of recalculating to-be-emulated PMCs is noticeable.

Note!  Deliberately don't check the PMU event filters, as doing so could
result in KVM consuming stale information.

Tracking which PMCs are counting branches/instructions will allow grabbing
SRCU in the fastpath VM-Exit handlers if and only if a PMC event might be
triggered (to consult the event filters), and will also allow the upcoming
mediated PMU to do the right thing with respect to counting instructions
(the mediated PMU won't be able to update PMCs in the VM-Exit fastpath).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/pmu.c              | 75 ++++++++++++++++++++++++---------
 arch/x86/kvm/pmu.h              |  4 ++
 3 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..d7680612ba1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -579,6 +579,9 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	DECLARE_BITMAP(pmc_counting_instructions, X86_PMC_IDX_MAX);
+	DECLARE_BITMAP(pmc_counting_branches, X86_PMC_IDX_MAX);
+
 	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_rsvd;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index e1911b366c43..b0f0275a2c2e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -542,6 +542,47 @@ static int reprogram_counter(struct kvm_pmc *pmc)
 				     eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 
+static bool pmc_is_event_match(struct kvm_pmc *pmc, u64 eventsel)
+{
+	/*
+	 * Ignore checks for edge detect (all events currently emulated by KVM
+	 * are always rising edges), pin control (unsupported by modern CPUs),
+	 * and counter mask and its invert flag (KVM doesn't emulate multiple
+	 * events in a single clock cycle).
+	 *
+	 * Note, the uppermost nibble of AMD's mask overlaps Intel's IN_TX (bit
+	 * 32) and IN_TXCP (bit 33), as well as two reserved bits (bits 35:34).
+	 * Checking the "in HLE/RTM transaction" flags is correct as the vCPU
+	 * can't be in a transaction if KVM is emulating an instruction.
+	 *
+	 * Checking the reserved bits might be wrong if they are defined in the
+	 * future, but so could ignoring them, so do the simple thing for now.
+	 */
+	return !((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB);
+}
+
+void kvm_pmu_recalc_pmc_emulation(struct kvm_pmu *pmu, struct kvm_pmc *pmc)
+{
+	bitmap_clear(pmu->pmc_counting_instructions, pmc->idx, 1);
+	bitmap_clear(pmu->pmc_counting_branches, pmc->idx, 1);
+
+	/*
+	 * Do NOT consult the PMU event filters, as the filters must be checked
+	 * at the time of emulation to ensure KVM uses fresh information, e.g.
+	 * omitting a PMC from a bitmap could result in a missed event if the
+	 * filter is changed to allow counting the event.
+	 */
+	if (!pmc_speculative_in_use(pmc))
+		return;
+
+	if (pmc_is_event_match(pmc, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED))
+		bitmap_set(pmu->pmc_counting_instructions, pmc->idx, 1);
+
+	if (pmc_is_event_match(pmc, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED))
+		bitmap_set(pmu->pmc_counting_branches, pmc->idx, 1);
+}
+EXPORT_SYMBOL_GPL(kvm_pmu_recalc_pmc_emulation);
+
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
@@ -577,6 +618,9 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 	 */
 	if (unlikely(pmu->need_cleanup))
 		kvm_pmu_cleanup(vcpu);
+
+	kvm_for_each_pmc(pmu, pmc, bit, bitmap)
+		kvm_pmu_recalc_pmc_emulation(pmu, pmc);
 }
 
 int kvm_pmu_check_rdpmc_early(struct kvm_vcpu *vcpu, unsigned int idx)
@@ -910,7 +954,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 							 select_user;
 }
 
-static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
+static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
+				  const unsigned long *event_pmcs)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -919,29 +964,17 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 
 	BUILD_BUG_ON(sizeof(pmu->global_ctrl) * BITS_PER_BYTE != X86_PMC_IDX_MAX);
 
+	if (bitmap_empty(event_pmcs, X86_PMC_IDX_MAX))
+		return;
+
 	if (!kvm_pmu_has_perf_global_ctrl(pmu))
-		bitmap_copy(bitmap, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
-	else if (!bitmap_and(bitmap, pmu->all_valid_pmc_idx,
+		bitmap_copy(bitmap, event_pmcs, X86_PMC_IDX_MAX);
+	else if (!bitmap_and(bitmap, event_pmcs,
 			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
 		return;
 
 	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
-		/*
-		 * Ignore checks for edge detect (all events currently emulated
-		 * but KVM are always rising edges), pin control (unsupported
-		 * by modern CPUs), and counter mask and its invert flag (KVM
-		 * doesn't emulate multiple events in a single clock cycle).
-		 *
-		 * Note, the uppermost nibble of AMD's mask overlaps Intel's
-		 * IN_TX (bit 32) and IN_TXCP (bit 33), as well as two reserved
-		 * bits (bits 35:34).  Checking the "in HLE/RTM transaction"
-		 * flags is correct as the vCPU can't be in a transaction if
-		 * KVM is emulating an instruction.  Checking the reserved bits
-		 * might be wrong if they are defined in the future, but so
-		 * could ignoring them, so do the simple thing for now.
-		 */
-		if (((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB) ||
-		    !pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
+		if (!pmc_event_is_allowed(pmc) || !cpl_is_matched(pmc))
 			continue;
 
 		kvm_pmu_incr_counter(pmc);
@@ -950,13 +983,13 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 
 void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu)
 {
-	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
+	kvm_pmu_trigger_event(vcpu, vcpu_to_pmu(vcpu)->pmc_counting_instructions);
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_instruction_retired);
 
 void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu)
 {
-	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
+	kvm_pmu_trigger_event(vcpu, vcpu_to_pmu(vcpu)->pmc_counting_branches);
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_branch_retired);
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 740af816af37..cb93a936a177 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -176,8 +176,12 @@ extern struct x86_pmu_capability kvm_pmu_cap;
 
 void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops);
 
+void kvm_pmu_recalc_pmc_emulation(struct kvm_pmu *pmu, struct kvm_pmc *pmc);
+
 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 {
+	kvm_pmu_recalc_pmc_emulation(pmc_to_pmu(pmc), pmc);
+
 	set_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
-- 
2.50.1.565.gc32cd1483b-goog


