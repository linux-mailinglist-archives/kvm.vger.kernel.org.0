Return-Path: <kvm+bounces-21877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E279352DF
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:10:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8F3028169E
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3611459F8;
	Thu, 18 Jul 2024 21:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDBSCNYB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE401EA8F
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 21:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337017; cv=none; b=Lm9wdmX/kQX2Gj1b49ov/O9Sysaqsxzdr8SivFcmpgO2hdWcQXIhHONy4mRGxI/f1cMByZkeenDodyxLPZMWgvQQgeXRyPRu0sucovYqTJsKfxbne8lfDzho7D0A8aJYCMG6NPlS/aQzd0lb6fJJV1IIaRey0ljXnvcjCZXJypU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337017; c=relaxed/simple;
	bh=Mu/jPdIQGHsNBN8Hn15TYNmcUp3/Eqvt1Dx7g67c8FI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K2gWfAT6f/4rlm/4rMWr1F3EOmm0go5pVGkeubHh0PsXADrfkwwfAyX5JlrIXgyWyDio3jWwPPERjxDbgsd508zAToYg62nQvN1KdVnIdw0RtZmNB+zbZw7bGe1eJ0UIfKSJAB3KMeDcfv0QkeScJR+jcBr9lml2K8wSCrFNB7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDBSCNYB; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337016; x=1752873016;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Mu/jPdIQGHsNBN8Hn15TYNmcUp3/Eqvt1Dx7g67c8FI=;
  b=IDBSCNYBa0ZbBDgK9oXma7YBtHqFbekoRUL8OWxfmcaQNMPJC44xDC+1
   71mvEMsk6CRqlSAhVTrE8vkHpjdnKa2QGKRT7HX5VfJUEYMISr+/1X5Vu
   111kI/15otpgEfMznEi2570nEV1IQ6XTC06T92Io9k3wungKinnb6s1RM
   QmdvyIEy7m3u+L0hdPIgPy5alu+6o5iTh+kD9q7ytU3qjoRuVILw43fLy
   +++foJT5oZx91e9vKWMdXgERKzq8OeyuWNpNP568dQ1Zr8PZAB88Cgd0w
   bXalZ/VPrj0TVdL8qyaCNwQ9v4Qwttq258rHDkaxfZPOjjbbRNA0XhoRV
   Q==;
X-CSE-ConnectionGUID: lgLdIktOQeK9fkkNP9Wdbw==
X-CSE-MsgGUID: l5JSGn5/T5+602HWakm6FA==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="21831709"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="21831709"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:15 -0700
X-CSE-ConnectionGUID: aXW8prndTe2V2GTOZUC36A==
X-CSE-MsgGUID: E6OJ4AytS2mYQBfS9lDnFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55179108"
Received: from soc-cp83kr3.jf.intel.com (HELO [10.24.10.107]) ([10.24.10.107])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:10:15 -0700
Message-ID: <13e03ddc-d6e3-47a6-bb1a-2b6cbd57e1a7@intel.com>
Date: Thu, 18 Jul 2024 14:10:14 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/9] target/i386/kvm: Save/load MSRs of kvmclock2
 (KVM_FEATURE_CLOCKSOURCE2)
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716161015.263031-1-zhao1.liu@intel.com>
 <20240716161015.263031-5-zhao1.liu@intel.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240716161015.263031-5-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/16/2024 9:10 AM, Zhao Liu wrote:
> MSR_KVM_SYSTEM_TIME_NEW and MSR_KVM_WALL_CLOCK_NEW are bound to
> kvmclock2 (KVM_FEATURE_CLOCKSOURCE2).
> 
> Add the save/load support for these 2 MSRs just like kvmclock MSRs.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>

Reviewed-by: Zide Chen <zide.chen@intel.com>

> ---
>  target/i386/cpu.h     |  2 ++
>  target/i386/kvm/kvm.c | 16 ++++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index b59bdc1c9d9d..35dc68631989 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1826,6 +1826,8 @@ typedef struct CPUArchState {
>  
>      uint64_t system_time_msr;
>      uint64_t wall_clock_msr;
> +    uint64_t system_time_new_msr;
> +    uint64_t wall_clock_new_msr;
>      uint64_t steal_time_msr;
>      uint64_t async_pf_en_msr;
>      uint64_t async_pf_int_msr;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ac434e83b64c..64e54beac7b3 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -3423,6 +3423,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
>              kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
>          }
> +        if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK2) {
> +            kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME_NEW,
> +                              env->system_time_new_msr);
> +            kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK_NEW,
> +                              env->wall_clock_new_msr);
> +        }
>          if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
>              kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, env->async_pf_int_msr);
>          }
> @@ -3901,6 +3907,10 @@ static int kvm_get_msrs(X86CPU *cpu)
>          kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, 0);
>          kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, 0);
>      }
> +    if (env->features[FEAT_KVM] & CPUID_KVM_CLOCK2) {
> +        kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME_NEW, 0);
> +        kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK_NEW, 0);
> +    }
>      if (env->features[FEAT_KVM] & CPUID_KVM_ASYNCPF_INT) {
>          kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_INT, 0);
>      }
> @@ -4167,6 +4177,12 @@ static int kvm_get_msrs(X86CPU *cpu)
>          case MSR_KVM_WALL_CLOCK:
>              env->wall_clock_msr = msrs[i].data;
>              break;
> +        case MSR_KVM_SYSTEM_TIME_NEW:
> +            env->system_time_new_msr = msrs[i].data;
> +            break;
> +        case MSR_KVM_WALL_CLOCK_NEW:
> +            env->wall_clock_new_msr = msrs[i].data;
> +            break;
>          case MSR_MCG_STATUS:
>              env->mcg_status = msrs[i].data;
>              break;

