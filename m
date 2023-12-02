Return-Path: <kvm+bounces-3188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73265801874
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 01:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A420F1C20C0A
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CC22F2B;
	Sat,  2 Dec 2023 00:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kI+/ibgM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E632DD
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 16:04:29 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-daee86e2d70so1516458276.0
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 16:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701475468; x=1702080268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nIOxy6M4X+Ql7aRps4Vs1bjcNWEAWUlJqdIwiwhjV/U=;
        b=kI+/ibgMIg4KxGHmFC5eMfYZb7cNC4SUlcuIhdeIuAb0VsJdRCW3bTKr8qWhDXY6IG
         +qZcDfutiNn0BhUZFdZ3yduqdV9Vk+VnOpVunl2h/lWJXX9yxNC2L7lDsckMRfxsQsST
         F3hcG2h5CDLUPHdtCPG9ySvW6uLH5tCoUJVEg2bawYOcHxmXWcfxBQuJF5uzhHT0iLrE
         Hgt3Vh7LWowDNTnBWdhv2QPczwD+hLCXvGVQaE/PPytIWLEn7Utmz+Fss1TE1pA0fO8J
         Y043TnFpw5fmkFXrCbiIOZJ/ckQC3vGGpUa9q0cwq8oZvZnjZ9K/VIa5kCTUUG+TtJhn
         JUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701475468; x=1702080268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nIOxy6M4X+Ql7aRps4Vs1bjcNWEAWUlJqdIwiwhjV/U=;
        b=F/4eIqPHTAJZ/Ea5zeOzu4C3+XEJP5pL01S3qk3BS40DXDuhXp3KCSidx/VOuvlhqC
         Se2CdqHholJOW/nKBbiTRYnriniCb52NxgmA68P1lyirGyxho/NYE8RdsfD0ax1p3oDU
         3XWGXX6o1Qv2vNDWBYEgraEy8xuuMzLUOrLpqUN6su27ZsG3P4sqlzKMK72FRpkF4d/+
         qz3textT9ztyJReTL51H6XFYBRA0gye/2TOGHR0WrB6YyrDeZxJpqIn4ecP3NhmAKn0o
         eTH57LsO7naZLF17TZRt8maUdqbUlqnFFQ1DUrc72S53FoNjspapitmBcIMTK6bqZ5Yq
         LRPg==
X-Gm-Message-State: AOJu0YxHnNwrp0Oo+PzwQPIDHuld3gxZtTMrIomEQV7vVuhoVrdi1CIn
	LElxFYwKEJeuCB8o4NjYTc/6V1HDwbQ=
X-Google-Smtp-Source: AGHT+IE8VTpP8iIpAtxJmnjFAbxSHkvt+0MQS5fKUuY2PbPdybPQNDNefIq9CU9yVFX2nrDSHES0zOtj1+E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:687:0:b0:db4:5e66:4a05 with SMTP id
 129-20020a250687000000b00db45e664a05mr804821ybg.2.1701475468385; Fri, 01 Dec
 2023 16:04:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  1 Dec 2023 16:03:53 -0800
In-Reply-To: <20231202000417.922113-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231202000417.922113-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231202000417.922113-5-seanjc@google.com>
Subject: [PATCH v9 04/28] KVM: x86/pmu: Setup fixed counters' eventsel during
 PMU initialization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Set the eventsel for all fixed counters during PMU initialization, the
eventsel is hardcoded and consumed if and only if the counter is supported,
i.e. there is no reason to redo the setup every time the PMU is refreshed.

Configuring all KVM-supported fixed counter also eliminates a potential
pitfall if/when KVM supports discontiguous fixed counters, in which case
configuring only nr_arch_fixed_counters will be insufficient (ignoring the
fact that KVM will need many other changes to support discontiguous fixed
counters).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f3c44ddc09f8..98e92b9ece09 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -407,27 +407,21 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
  * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
  * as there is no architectural general purpose encoding for reference cycles.
  */
-static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
+static u64 intel_get_fixed_pmc_eventsel(int index)
 {
 	const struct {
-		u8 eventsel;
+		u8 event;
 		u8 unit_mask;
 	} fixed_pmc_events[] = {
 		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
 		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
 		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
 	};
-	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
-		int index = array_index_nospec(i, KVM_PMC_MAX_FIXED);
-		struct kvm_pmc *pmc = &pmu->fixed_counters[index];
-
-		pmc->eventsel = (fixed_pmc_events[index].unit_mask << 8) |
-				 fixed_pmc_events[index].eventsel;
-	}
+	return (fixed_pmc_events[index].unit_mask << 8) |
+		fixed_pmc_events[index].event;
 }
 
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
@@ -493,7 +487,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 						  kvm_pmu_cap.bit_width_fixed);
 		pmu->counter_bitmask[KVM_PMC_FIXED] =
 			((u64)1 << edx.split.bit_width_fixed) - 1;
-		setup_fixed_pmc_eventsel(pmu);
 	}
 
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
@@ -571,6 +564,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 		pmu->fixed_counters[i].vcpu = vcpu;
 		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
 		pmu->fixed_counters[i].current_config = 0;
+		pmu->fixed_counters[i].eventsel = intel_get_fixed_pmc_eventsel(i);
 	}
 
 	lbr_desc->records.nr = 0;
-- 
2.43.0.rc2.451.g8631bc7472-goog


