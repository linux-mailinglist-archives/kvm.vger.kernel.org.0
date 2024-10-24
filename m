Return-Path: <kvm+bounces-29668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFD79AF326
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 21:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1524281F20
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 19:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D6081F9EB5;
	Thu, 24 Oct 2024 19:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h+somYLp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307DF18BB8F;
	Thu, 24 Oct 2024 19:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799913; cv=none; b=sFyQ2c6334akjw8W30LsqHwt0hy4hlb3PYa75TfWdxxC/mNDY0NEivMGMwCSX3IdV7cI9kCj00JQsabYPcehipIVjnKAz/gAL9exqa4yQCa1iA8qI6x3iHdpi12ABQopPbWgnN+ZYJTfU7Vk07NayFhDA4Tbu1FGIvAYplHKs0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799913; c=relaxed/simple;
	bh=s1H6CaKYkNRktEfhiN9h2IshOsrpesGONmNIuz4GNGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrD0hQ/pbHexNXA6xVKJzXl2fnOkpk3ehEg546YbJG4vydnvNwkd0BBNmpDXytUdUnPG2nDr52FJPw2jpKlJdV00PzAOoYb46DZT2SkjQ5/3/yD4ik1BKrDdJVC90OEn6vWCosfqCG0xRYzYeVBjjAq6qK5IKS9PnEU31L6QteA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h+somYLp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729799911; x=1761335911;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s1H6CaKYkNRktEfhiN9h2IshOsrpesGONmNIuz4GNGM=;
  b=h+somYLp9N1H9inFrHiiqb2QxpD+mkTiwgkcBxd/nVGoi8NBpnj1wJ2I
   kO/ON/P9aAWqUM30dm+LDX9lWIB40bUE6rcJR+Twkxfmc7ACkTSzgy7QL
   uBFCtJXkdR5vBAahEUhpOkeVjPYXXsIVllTFbAG0lJa+MS2g7+1iqPwPA
   bU4oOwryvu9zVwBPxQJMfoI6NSxe59ZUFAdXtuqVwcBhYKWpSEVl8gc4B
   IgKnf3FQjJCYmUA3YJKRYS0d3lIzg7zXQ0W6VFR0SnhH8/YLFLGQpqBNw
   Rwzax7/10mFvJfr1/a4M+4JIMsr6WzYr/LgocMUTeG/Y1qUNVFyXSIhY5
   A==;
X-CSE-ConnectionGUID: iy2Kg3ijQO6fFAwF6fN5aw==
X-CSE-MsgGUID: xiILFL7+RJSZxj2oWWoiGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52006382"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52006382"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 12:58:31 -0700
X-CSE-ConnectionGUID: 0mfCZxzSSXidjdvOnt7GGg==
X-CSE-MsgGUID: wBZK7cYEQzeTfJYxFrjw1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="81135051"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.24.8.117]) ([10.24.8.117])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 12:58:30 -0700
Message-ID: <b3e57722-3599-45c5-9307-e8797f167f3c@intel.com>
Date: Thu, 24 Oct 2024 12:58:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 27/58] KVM: x86/pmu: Create a function prototype to
 disable MSR interception
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-28-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240801045907.4010984-28-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
> Add one extra pmu function prototype in kvm_pmu_ops to disable PMU MSR
> interception.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
>  arch/x86/kvm/cpuid.c                   | 4 ++++
>  arch/x86/kvm/pmu.c                     | 5 +++++
>  arch/x86/kvm/pmu.h                     | 2 ++
>  4 files changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index fd986d5146e4..1b7876dcb3c3 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -24,6 +24,7 @@ KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
>  KVM_X86_PMU_OP_OPTIONAL(reset)
>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
> +KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
>  
>  #undef KVM_X86_PMU_OP
>  #undef KVM_X86_PMU_OP_OPTIONAL
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f2f2be5d1141..3deb79b39847 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -381,6 +381,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>  
>  	kvm_pmu_refresh(vcpu);
> +
> +	if (is_passthrough_pmu_enabled(vcpu))
> +		kvm_pmu_passthrough_pmu_msrs(vcpu);
> +
>  	vcpu->arch.cr4_guest_rsvd_bits =
>  	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
>  
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 3afefe4cf6e2..bd94f2d67f5c 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -1059,3 +1059,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	kfree(filter);
>  	return r;
>  }
> +
> +void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu)
> +{
> +	static_call_cond(kvm_x86_pmu_passthrough_pmu_msrs)(vcpu);
> +}
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index e1af6d07b191..63f876557716 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -41,6 +41,7 @@ struct kvm_pmu_ops {
>  	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
>  	void (*cleanup)(struct kvm_vcpu *vcpu);
>  	bool (*is_rdpmc_passthru_allowed)(struct kvm_vcpu *vcpu);
> +	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);

Seems after_set_cpuid() is a better name. It's more generic to reflect
the fact that PMU needs to do something after userspace sets CPUID.
Currently PMU needs to update the MSR interception policy, but it may
want to do more in the future.

Also, it's more consistent to other APIs called in
kvm_vcpu_after_set_cpuid().

>  
>  	const u64 EVENTSEL_EVENT;
>  	const int MAX_NR_GP_COUNTERS;
> @@ -292,6 +293,7 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
>  int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
>  void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
>  bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu);
> +void kvm_pmu_passthrough_pmu_msrs(struct kvm_vcpu *vcpu);
>  
>  bool is_vmware_backdoor_pmc(u32 pmc_idx);
>  


