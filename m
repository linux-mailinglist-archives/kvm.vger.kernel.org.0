Return-Path: <kvm+bounces-21255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8699C92C903
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 05:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A96C31C22A9F
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 03:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CC92D613;
	Wed, 10 Jul 2024 03:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSzw3ify"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8401A28D;
	Wed, 10 Jul 2024 03:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720581221; cv=none; b=JWBkzmvI5O0sSpLNyb5KelnWqw6DjM1ehz/RLAxsiQEvFTgY9APq8A7Sh1QgPTOHTGhh9nMdTKf13fC4wtoBe+BIwI+Rex5EENUvsyM5pX4ob6Gcrl4nVzV0GAgVRjyGlix28TkfqM4fOrWBkQaXSNLg1zfaVzYX9vHFsH1VD44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720581221; c=relaxed/simple;
	bh=v/nfEaNXjXNsO3ehsKPHgPZKItGJIUJlqHLAqRYlVzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NmZ5h4NjHneF0OfrgkiXhdpc6Qu7ARqoZYCVp7SnFvg3njDChGUIkqL7dQTnrvTHkzUILQYJJ7kZH5rzsm6iJYL8WQIy4FwG2aXPEIp5ur9fvfiDLqAaMSH/RKAH9KcwKbYrJiQeEt/Q5vDduu96mKX2igw+K5gZMKEDeO1ofcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSzw3ify; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720581219; x=1752117219;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v/nfEaNXjXNsO3ehsKPHgPZKItGJIUJlqHLAqRYlVzY=;
  b=lSzw3ify9QRH70cuUn+ZFTURVJiKku9XjgUfnTgAFwuI4pEPicBIqg1P
   /4ftJrCej92+o/UcPfLg17SGUqnsNtQvJLemiUZP1cRLThP+9xEtge0+I
   pW1ZYFIVQc8nEIV0t9dV0KYgtIYt1Yd6laNzX4YeJQdhXcaitG8gbprfy
   B7M0DRjc7cdGwmERFQaltt9tIE7ehoUlObT90ao1yGKm6Kfo7JoAHb0Dp
   tmAF/cQnSz+z1egUwzhhAgElKKk0Nzj/2mKgecO7zi+fM3xsjHh4KenHc
   thZCuUs9yTw72meZ6jNc6qiGZKy932uyw95baNLNrHJltiulKoVQJliPt
   A==;
X-CSE-ConnectionGUID: dXcMoL1HSM66EKvP0vrDMQ==
X-CSE-MsgGUID: UxQV+9ifS5u5+8OSHMIuUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="21643381"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="21643381"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 20:13:38 -0700
X-CSE-ConnectionGUID: zJftN6F/RMyQ1ectPGeWeA==
X-CSE-MsgGUID: 6FqYafGlQj+Y+hysS3LVrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="48146385"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.1]) ([10.124.225.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 20:13:36 -0700
Message-ID: <2205c1fc-e7c5-48aa-ac06-345227cc9bbb@linux.intel.com>
Date: Wed, 10 Jul 2024 11:13:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: Return KVM_MSR_RET_INVALID for invalid PMU
 MSR access
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
 Mingwei Zhang <mizhang@google.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Like Xu <like.xu.linux@gmail.com>,
 Jinrong Liang <cloudliang@tencent.com>, Yongwei Ma <yongwei.ma@intel.com>,
 Dapeng Mi <dapeng1.mi@intel.com>, Gleb Natapov <gleb@redhat.com>
References: <20240709145500.45547-1-dapeng1.mi@linux.intel.com>
 <Zo2FYieeerQzUGOa@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zo2FYieeerQzUGOa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 7/10/2024 2:45 AM, Sean Christopherson wrote:
> On Tue, Jul 09, 2024, Dapeng Mi wrote:
>> Return KVM_MSR_RET_INVALID instead of 0 to inject #GP to guest for all
>> invalid PMU MSRs access
>>
>> Currently KVM silently drops the access and doesn't inject #GP for some
>> invalid PMU MSRs like MSR_P6_PERFCTR0/MSR_P6_PERFCTR1,
>> MSR_P6_EVNTSEL0/MSR_P6_EVNTSEL1, but KVM still injects #GP for all other
>> invalid PMU MSRs. This leads to guest see different behavior on invalid
>> PMU access and may confuse guest.
> This is by design.  I'm not saying it's _good_ design, but it is very much
> intended.  More importantly, it's established behavior, i.e. having KVM inject
> #GP could break existing setups.
>
>> This behavior is introduced by the
>> 'commit 5753785fa977 ("KVM: do not #GP on perf MSR writes when vPMU is disabled")'
>> in 2012. This commit seems to want to keep back compatible with weird
>> behavior of some guests in vPMU disabled case,
> Ya, because at the time, guest kernels hadn't been taught to play nice with
> unexpected virtualization setups, i.e. VMs without PMUs.
>
>> but strongly suspect if it's still available nowadays.
> I don't follow this comment.
>
>> Since Perfmon v6 starts, the GP counters could become discontinuous on
>> HW, It's possible that HW doesn't support GP counters 0 and 1.
>> Considering this situation KVM should inject #GP for all invalid PMU MSRs
>> access.
> IIUC, the behavior you want is inject a #GP if the vCPU has a PMU and the MSR is
> not valid.  We can do that and still maintain backwards compatibility, hopefully
> without too much ugliness (maybe even an improvement!).
>
> This? (completely untested)

Seems no better method. Would adopt this. Thanks.

>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5aa7581802f7..b5e95e5f1f32 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4063,9 +4063,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
>         case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
>         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> -               if (kvm_pmu_is_valid_msr(vcpu, msr))
> -                       return kvm_pmu_set_msr(vcpu, msr_info);
> -
> +               if (vcpu_to_pmu(vcpu)->version)
> +                       goto default_handler;
>                 if (data)
>                         kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>                 break;
> @@ -4146,6 +4145,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 break;
>  #endif
>         default:
> +default_handler:
>                 if (kvm_pmu_is_valid_msr(vcpu, msr))
>                         return kvm_pmu_set_msr(vcpu, msr_info);
>  
> @@ -4251,8 +4251,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>         case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
>         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
> -               if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
> -                       return kvm_pmu_get_msr(vcpu, msr_info);
> +               if (vcpu_to_pmu(vcpu)->version)
> +                       goto default_handler;
>                 msr_info->data = 0;
>                 break;
>         case MSR_IA32_UCODE_REV:
> @@ -4505,6 +4505,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>                 break;
>  #endif
>         default:
> +default_handler:
>                 if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>                         return kvm_pmu_get_msr(vcpu, msr_info);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> index 96446134c00b..0de606b542ac 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
> @@ -344,7 +344,8 @@ static void guest_test_rdpmc(uint32_t rdpmc_idx, bool expect_success,
>  static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters,
>                                  uint8_t nr_counters, uint32_t or_mask)
>  {
> -       const bool pmu_has_fast_mode = !guest_get_pmu_version();
> +       const u8 pmu_version = guest_get_pmu_version();
> +       const bool pmu_has_fast_mode = !pmu_version;
>         uint8_t i;
>  
>         for (i = 0; i < nr_possible_counters; i++) {
> @@ -363,12 +364,13 @@ static void guest_rd_wr_counters(uint32_t base_msr, uint8_t nr_possible_counters
>                 const bool expect_success = i < nr_counters || (or_mask & BIT(i));
>  
>                 /*
> -                * KVM drops writes to MSR_P6_PERFCTR[0|1] if the counters are
> -                * unsupported, i.e. doesn't #GP and reads back '0'.
> +                * KVM drops writes to MSR_P6_PERFCTR[0|1] if the vCPU doesn't
> +                * have a PMU, i.e. doesn't #GP and reads back '0'.
>                  */
>                 const uint64_t expected_val = expect_success ? test_val : 0;
> -               const bool expect_gp = !expect_success && msr != MSR_P6_PERFCTR0 &&
> -                                      msr != MSR_P6_PERFCTR1;
> +               const bool expect_gp = !expect_success &&
> +                                      (pmu_version ||
> +                                       (msr != MSR_P6_PERFCTR0 && msr != MSR_P6_PERFCTR1));
>                 uint32_t rdpmc_idx;
>                 uint8_t vector;
>                 uint64_t val;
>

