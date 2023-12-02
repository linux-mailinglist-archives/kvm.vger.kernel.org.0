Return-Path: <kvm+bounces-3186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B9E7F801872
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:04:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 20DF9B2107E
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22D41FA2;
	Sat,  2 Dec 2023 00:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bnvDQHS1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB58DD
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:25 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-dae71322ed4so1486180276.1
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475464; x=1702080264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nrWuzJLU6tkGY/9zTZWBayZkZvRNlps9jlufvMoHa3o=;
        b=bnvDQHS1ASLYzy0iGleR821TTbLVLe3UBpHk1EooZPWXMX80awQrU504bt2vtetAB0
         E1dx/7B/YCdUrWJkm0BcdbL50Zb51lpmXo7d2RByYcafBxHvAnLzDhdGP6LWxwroXtch
         LIFOG1NdZrbTOUB/5rqUMda8wiTTfaIcS4+fCDABK1MriixfHX/GP8fJkcFvXSLCJQ+J
         X5KRGLE6P16KICm4Xryn6INWMmRS9RzfdcJ21qjrudARjrtmaFfKI1bacbQOlTHBFrWu
         nb08FV3xb6OT65/sf7HWtkUhmsqADkzbppD4l8XdOqx7Sl3lNFG9vUywHubXugLj3cxL
         yPBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475464; x=1702080264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nrWuzJLU6tkGY/9zTZWBayZkZvRNlps9jlufvMoHa3o=;
        b=qUmgK/39K//782XUzve1ol1xmYXoBPNZt7oOpEjhLQfY+a08vx3j6Geu9pkd1V68BA
         ghhlmKyHU8z8S8UViDLF9c+0eKeVtFTZe6gPOPyKYd2Z5139x1H3Pmevqp/2FYo6KknC
         kjQo0QX+ScamZrMiXeHIgL0ao6uOzbEqwwEJpm3OgLLi3WhRlCs53pOWwMbhHI126F14
         zV6rQR8Gp/V3Ugx4/i1qNcpdUL3XyyUi6H4Cf98lUAb+GHovAHH1IeWb+eF7zpNtTfwe
         igvVjsUzJFDG8qPTJ0Yxa9gYe8focXk88X3YtH8ItLqbZrsOnm0rNReRIHWr5/LdKsbD
         v2/w==
X-Gm-Message-State: AOJu0YxfKDv2cRXSawo/SLw8zQg4hixZc5UbDyMTul5o2zTmUjrD5d7M
	z5Rugi6knyt6oQp5/poSD4D+L/FVL08=
X-Google-Smtp-Source: AGHT+IGvzYY6w9hDUaeNhSFM+btGE1yy8puJp7XhMPs+wyjgw8ScMQHzXWcy+SxcTx6ROpwJYz9CCNTn70c=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3503:0:b0:db7:dcb9:790c with SMTP id
 c3-20020a253503000000b00db7dcb9790cmr13512yba.8.1701475464598; Fri, 01 Dec
 2023 16:04:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:03:51 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-3-seanjc@google.com>
Subject: [PATCH v9 02/28] KVM: x86/pmu: Allow programming events that match
 unsupported arch events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Remove KVM's bogus restriction that the guest can't program an event whose
encoding matches an unsupported architectural event.  The enumeration of
an architectural event only says that if a CPU supports an architectural
event, then the event can be programmed using the architectural encoding.
The enumeration does NOT say anything about the encoding when the CPU
doesn't report support the architectural event.

Preventing the guest from counting events whose encoding happens to match
an architectural event breaks existing functionality whenever Intel adds
an architectural encoding that was *ever* used for a CPU that doesn't
enumerate support for the architectural event, even if the encoding is for
the exact same event!

E.g. the architectural encoding for Top-Down Slots is 0x01a4.  Broadwell
CPUs, which do not support the Top-Down Slots architectural event, 0x01a4
is a valid, model-specific event.  Denying guest usage of 0x01a4 if/when
KVM adds support for Top-Down slots would break any Broadwell-based guest.

Reported-by: Kan Liang <kan.liang@linux.intel.com>
Closes: https://lore.kernel.org/all/2004baa6-b494-462c-a11f-8104ea152c6a@linux.intel.com
Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/pmu.c                     |  1 -
 arch/x86/kvm/pmu.h                     |  1 -
 arch/x86/kvm/svm/pmu.c                 |  6 ----
 arch/x86/kvm/vmx/pmu_intel.c           | 38 --------------------------
 5 files changed, 47 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 058bc636356a..d7eebee4450c 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -12,7 +12,6 @@ BUILD_BUG_ON(1)
  * a NULL definition, for example if "static_call_cond()" will be used
  * at the call sites.
  */
-KVM_X86_PMU_OP(hw_event_available)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 87cc6c8809ad..30945fea6988 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -441,7 +441,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 {
 	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
-	       static_call(kvm_x86_pmu_hw_event_available)(pmc) &&
 	       check_pmu_event_filter(pmc);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7caeb3d8d4fd..87ecf22f5b25 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -19,7 +19,6 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 struct kvm_pmu_ops {
-	bool (*hw_event_available)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b6a7ad4d6914..1475d47c821c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -73,11 +73,6 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return amd_pmc_idx_to_pmc(pmu, idx);
 }
 
-static bool amd_hw_event_available(struct kvm_pmc *pmc)
-{
-	return true;
-}
-
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -233,7 +228,6 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
-	.hw_event_available = amd_hw_event_available,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8207f8c03585..1a7d021a6c7b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -101,43 +101,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static bool intel_hw_event_available(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-	int i;
-
-	/*
-	 * Fixed counters are always available if KVM reaches this point.  If a
-	 * fixed counter is unsupported in hardware or guest CPUID, KVM doesn't
-	 * allow the counter's corresponding MSR to be written.  KVM does use
-	 * architectural events to program fixed counters, as the interface to
-	 * perf doesn't allow requesting a specific fixed counter, e.g. perf
-	 * may (sadly) back a guest fixed PMC with a general purposed counter.
-	 * But if _hardware_ doesn't support the associated event, KVM simply
-	 * doesn't enumerate support for the fixed counter.
-	 */
-	if (pmc_is_fixed(pmc))
-		return true;
-
-	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
-
-	/*
-	 * Disallow events reported as unavailable in guest CPUID.  Note, this
-	 * doesn't apply to pseudo-architectural events (see above).
-	 */
-	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
-		if (intel_arch_events[i].eventsel != event_select ||
-		    intel_arch_events[i].unit_mask != unit_mask)
-			continue;
-
-		return pmu->available_event_types & BIT(i);
-	}
-
-	return true;
-}
-
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -780,7 +743,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-	.hw_event_available = intel_hw_event_available,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.43.0.rc2.451.g8631bc7472-goog


