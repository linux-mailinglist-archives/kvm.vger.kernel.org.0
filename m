Return-Path: <kvm+bounces-21228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C9292C376
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 20:46:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6D221C228B7
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 18:46:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E60E180054;
	Tue,  9 Jul 2024 18:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZASUvHM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5F21B86C2
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 18:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720550757; cv=none; b=NEzR1JQMVvcMQonqrwdV3S8GzcVa8QeQYDjIc8udcGCFxHonpLrbgE+kQCx9pdvZcnMbUjlPJGytznIvuFkcwTjO6UvsZdXLaXBhpYkVv/WR+yMolofy74vx3eBmXbxYlmrg31pjnAEekPdIpgVvtAJCA8LIfBdEahuvZxh+SwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720550757; c=relaxed/simple;
	bh=DZ9+8t+WkPgSQ8znv0DJ8bDk1A7MLccr3mMfUhEicCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TKgylgE4YfPbXtDwcYGwnnj9Et1DCojH50dIW0Z6IHJip0M5dYxlVtmbgJMfevtdxMAqyyh/+m9fsYGk0+SC/E5kKUWRfkC4xJ0RzAcm/wkOHteRSVxzBeki4g4Ne8J87Blbg9j750EdmplGspw4mcdSJdTapGKTJUsT8B10Dc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZASUvHM; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-6818fa37eecso4385928a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 11:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720550756; x=1721155556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oFkXIsaf/TPw78YVNz4BT3QVX826pe30lG1vGzhC0Y=;
        b=AZASUvHMyxDKA3/yb0oFGU4eScFyTosHEYUrHH6izLqVW5SS9x3sM/ifd20xysurZ9
         oUv7r49pXJ/dbAThYMgzxvhT5MixuMrauplkCtLjKp5eSGCN8gaRcOj3DKdr8zupzbMe
         vvCD3IuFVyEDUv0ftDJsuWJJV28nYqaimvI3QU7nxuPDWF9RLsGg4c1qMoH8tVztL/eG
         gSLOvYObfNvNAlY3ePApvSUXDB8BwhcOTluSAaRCF2inctk2895nTwueQa7RnscWF1q0
         KMmRpR0GOXBwcZ//MJtyxAPqUzBf/aTSmWqCc5sStStnuqJwvsV4LFucUW6/3gfveKBL
         9u1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720550756; x=1721155556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0oFkXIsaf/TPw78YVNz4BT3QVX826pe30lG1vGzhC0Y=;
        b=bp16Rj6fWqjP21Ij92kUZD47PLlTTrEbPUP/TjmvUDLdltBxhLL3cw+fQmYXst4CI5
         aeIwtPNbxsL36dNRhJ3/BsTliaDrPWK8ZVopbqq7F9MlXk91Xs1c1zE+fTKEMjYMqzIt
         Kz5Qd7RyxiS9XtjbbHDuAzKZxMDQ5ZdVPqedY3AXcuVwpKeLN94mLRZQGeZ44jET8T4Q
         wgCJSkFDTHIanNJICprrijj2Mb+q2qeYD+DwrJHfPHn+UR4YB1qEZRP+Ic3EI/bs94Il
         nWWAVBax6SQOzF+ymQx7anofiMCSakgRATdDjrsYgm93Yk+NcpdYpwLb2Qy71z42DSh9
         yVRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUakqmS6VfzF1od4je4DEhAFtzixZi4ZryaVSjbURdMqAPzZC89xHT+843AeNAhQit0VqKyVXmeIW3nnE5k6sTPSJZg
X-Gm-Message-State: AOJu0YzAi0n9KHGAMKvqhuDJGO6YNFvnbGSPdgxSjy+HS7yh+ihfbumG
	ppa2OIPUYY/g47heqnnvbf3vPQ1ftU0ML8DZCmDAAtoL4TIKJc7wnw65QVYof67NBPF3LRI75dT
	knw==
X-Google-Smtp-Source: AGHT+IEPP63rp5Trd9LeU9KzPvbSQUt5QZCeMWb97H+bNFEinDz3XkMbBMJ6H8xw67oHq0cXDafxJbsHJI4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2503:0:b0:771:88d7:c111 with SMTP id
 41be03b00d2f7-77db71c639bmr6791a12.4.1720550755584; Tue, 09 Jul 2024 11:45:55
 -0700 (PDT)
Date: Tue, 9 Jul 2024 11:45:54 -0700
In-Reply-To: <20240709145500.45547-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240709145500.45547-1-dapeng1.mi@linux.intel.com>
Message-ID: <Zo2FYieeerQzUGOa@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Return KVM_MSR_RET_INVALID for invalid PMU
 MSR access
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Like Xu <like.xu.linux@gmail.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>, 
	Gleb Natapov <gleb@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 09, 2024, Dapeng Mi wrote:
> Return KVM_MSR_RET_INVALID instead of 0 to inject #GP to guest for all
> invalid PMU MSRs access
> 
> Currently KVM silently drops the access and doesn't inject #GP for some
> invalid PMU MSRs like MSR_P6_PERFCTR0/MSR_P6_PERFCTR1,
> MSR_P6_EVNTSEL0/MSR_P6_EVNTSEL1, but KVM still injects #GP for all other
> invalid PMU MSRs. This leads to guest see different behavior on invalid
> PMU access and may confuse guest.

This is by design.  I'm not saying it's _good_ design, but it is very much
intended.  More importantly, it's established behavior, i.e. having KVM inject
#GP could break existing setups.

> This behavior is introduced by the
> 'commit 5753785fa977 ("KVM: do not #GP on perf MSR writes when vPMU is disabled")'
> in 2012. This commit seems to want to keep back compatible with weird
> behavior of some guests in vPMU disabled case,

Ya, because at the time, guest kernels hadn't been taught to play nice with
unexpected virtualization setups, i.e. VMs without PMUs.

> but strongly suspect if it's still available nowadays.

I don't follow this comment.

> Since Perfmon v6 starts, the GP counters could become discontinuous on
> HW, It's possible that HW doesn't support GP counters 0 and 1.
> Considering this situation KVM should inject #GP for all invalid PMU MSRs
> access.

IIUC, the behavior you want is inject a #GP if the vCPU has a PMU and the MSR is
not valid.  We can do that and still maintain backwards compatibility, hopefully
without too much ugliness (maybe even an improvement!).

This? (completely untested)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5aa7581802f7..b5e95e5f1f32 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4063,9 +4063,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
        case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
        case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-               if (kvm_pmu_is_valid_msr(vcpu, msr))
-                       return kvm_pmu_set_msr(vcpu, msr_info);
-
+               if (vcpu_to_pmu(vcpu)->version)
+                       goto default_handler;
                if (data)
                        kvm_pr_unimpl_wrmsr(vcpu, msr, data);
                break;
@@ -4146,6 +4145,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                break;
 #endif
        default:
+default_handler:
                if (kvm_pmu_is_valid_msr(vcpu, msr))
                        return kvm_pmu_set_msr(vcpu, msr_info);
 
@@ -4251,8 +4251,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
        case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
        case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
        case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
-               if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
-                       return kvm_pmu_get_msr(vcpu, msr_info);
+               if (vcpu_to_pmu(vcpu)->version)
+                       goto default_handler;
                msr_info->data = 0;
                break;
        case MSR_IA32_UCODE_REV:
@@ -4505,6 +4505,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                break;
 #endif
        default:
+default_handler:
                if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
                        return kvm_pmu_get_msr(vcpu, msr_info);
 
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 96446134c00b..0de606b542ac 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -344,7 +344,8 @@ static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
 static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
                                 uint8_t nr_counters, uint32_t or_mask)
 {
-       const bool pmu_has_fast_mode = !guest_get_pmu_version();
+       const u8 pmu_version = guest_get_pmu_version();
+       const bool pmu_has_fast_mode = !pmu_version;
        uint8_t i;
 
        for (i = 0; i < nr_possible_counters; i++) {
@@ -363,12 +364,13 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
                const bool expect_success = i < nr_counters || (or_mask & BIT(i));
 
                /*
-                * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
-                * unsupported, i.e. doesn't #GP and reads back '0'.
+                * KVM drops writes to MSR_P6_PERFCTR[0|1] if the vCPU doesn't
+                * have a PMU, i.e. doesn't #GP and reads back '0'.
                 */
                const uint64_t expected_val = expect_success ? test_val : 0;
-               const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
-                                      msr != MSR_P6_PERFCTR1;
+               const bool expect_gp = !expect_success &&
+                                      (pmu_version ||
+                                       (msr != MSR_P6_PERFCTR0 && msr != MSR_P6_PERFCTR1));
                uint32_t rdpmc_idx;
                uint8_t vector;
                uint64_t val;

