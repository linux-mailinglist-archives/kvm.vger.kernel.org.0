Return-Path: <kvm+bounces-32058-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FE69D282F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 15:30:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C0ED1F21A98
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 14:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF7B21CEE91;
	Tue, 19 Nov 2024 14:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ThYW/AZd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2081CC177
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 14:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732026628; cv=none; b=NQLuXRARjiWXwLXawF4waY2vWHa7BLkAUfJceckOuWNa9R56SBS5jmDzSgzvSlfrAHbrrw7NAUq0AGFKyIr5/nPkimg8dF8rHNXdnGshkGuhuUG/v86PfZ2o51rxXAuuWL7OV9SBlggWzS6tDWxuVrtJWYa6Rg0Nx2J4dF4hvWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732026628; c=relaxed/simple;
	bh=cBj12CA8mrU4sApMYhK3MpH1+4gVXA2iaiLQX195AbY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mW2U//lMzVDFpJVDP5fiT3t5VdfcpuibvSPE5bQfCr6x55Q14bVXf8jgcLmwg7RPWYEBxUILWW+JXmYz7k35ZP57fDFKXi5QSXc+NnTyY275yt9uVWlCzC98d7jDKWcTjIwFVGdQaz85JdR+tRGa7Vb4MLRjpAUGtL50zUdbMKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ThYW/AZd; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-71e6ee02225so3257208b3a.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 06:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732026625; x=1732631425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eBmU3ogPN1nxwBPSih6RQ5kXht81z5LpAS8pZkFAwGM=;
        b=ThYW/AZd7pZNBeR91yL3x8keDOLKgEF9Ovq3A0vK3wbFEhFaOX6Zq1Zbn3ZBEqUTzS
         YQIw4Jvnc0ln0yqY88tUTtDon7opfNBccIEXCw9hsbXWbq6F5yYz8c33uhUv3ZcnIVR6
         HuB2CmP5zeZZD46HmiPOZRNzoGhg/JCYMh4VeYaX3BixOgTVWAkfTpyxFSI4hR+kzB0D
         zvpRv+kYYBb6m7+srrLw8x/KDB330v69zT1f10wtX9CJ0yLjYedfTRl/oLVe8eslfwIg
         pURKpJcTXNSpUthJlvBadXBDUxyhr9zsB4F65Bl7r+2yol4yW7H7PeRId49rh6aoKlGm
         JPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732026625; x=1732631425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBmU3ogPN1nxwBPSih6RQ5kXht81z5LpAS8pZkFAwGM=;
        b=wYR0Qv5MY4fdQrEvz8mrECjYIUZbm32xEqKOevhybp9eebDjfngjGC7IOmfJNd0FpO
         Pul9I4KeksERgPrmHmQvnpbb6jPyo9fihX/8pykpjElITlxGznV09Qwl69IfzL5GJxEV
         5lQHHTs7rhEMPb7ncKkSGcnQc0ChkBCq9Yl8cI+P5l7ivlefHXrfts9WQabyC7LcuqWD
         FyFyNdUN8Q+KkcKIaoCfL0Xxko+8fDU4EuYW419zs/O+Bzwi8yggtykliIRQk1mn2ZYp
         yLw1rWgLh2zWgz9c02XKR1WmYn33zBHYD1RFVkJmCV+qAK/A73yajqK8SZcowbsYI/VU
         4K4A==
X-Forwarded-Encrypted: i=1; AJvYcCWAl9iv1rVmr55mRwcDqc6tVQOPDXfs2j7uAFRBg7PEH8GO2yviVB7kwmzhHtvERGj0Kok=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTiz0xDDYRBkDbSkFoj1864Lw8aMQNu+8jh6ZJdTKUzXRn1WBz
	KEJNAr8UbtovLaXg8uKBgaODeFBQO4rkDUAsFL8wOGno82GkYU1jCxidq0JV56K6lX1iLda4lZz
	Log==
X-Google-Smtp-Source: AGHT+IHT3kKjacRiRpiv3CWULp/80BF6XEK8gCyH5cMjMZy/c+E3fRI2E1HVKQbbygUtQ/31heyObakmVxs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:aa7:88c9:0:b0:71e:5e50:755e with SMTP id
 d2e1a72fcca58-72477110770mr80679b3a.6.1732026625375; Tue, 19 Nov 2024
 06:30:25 -0800 (PST)
Date: Tue, 19 Nov 2024 06:30:23 -0800
In-Reply-To: <20240801045907.4010984-19-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-19-mizhang@google.com>
Message-ID: <Zzyg_0ACKwHGLC7w@google.com>
Subject: Re: [RFC PATCH v3 18/58] KVM: x86/pmu: Introduce enable_passthrough_pmu
 module parameter
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla <manali.shukla@amd.com>, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Stephane Eranian <eranian@google.com>, Ian Rogers <irogers@google.com>, 
	Namhyung Kim <namhyung@kernel.org>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

As per my feedback in the initial RFC[*]:

 2. The module param absolutely must not be exposed to userspace until all patches
    are in place.  The easiest way to do that without creating dependency hell is
    to simply not create the module param.

[*] https://lore.kernel.org/all/ZhhQBHQ6V7Zcb8Ve@google.com

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Introduce enable_passthrough_pmu as a RO KVM kernel module parameter. This
> variable is true only when the following conditions satisfies:
>  - set to true when module loaded.
>  - enable_pmu is true.
>  - is running on Intel CPU.
>  - supports PerfMon v4.
>  - host PMU supports passthrough mode.
> 
> The value is always read-only because passthrough PMU currently does not
> support features like LBR and PEBS, while emualted PMU does. This will end
> up with two different values for kvm_cap.supported_perf_cap, which is
> initialized at module load time. Maintaining two different perf
> capabilities will add complexity. Further, there is not enough motivation
> to support running two types of PMU implementations at the same time,
> although it is possible/feasible in reality.
> 
> Finally, always propagate enable_passthrough_pmu and perf_capabilities into
> kvm->arch for each KVM instance.
> 
> Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/pmu.h              | 14 ++++++++++++++
>  arch/x86/kvm/vmx/vmx.c          |  7 +++++--
>  arch/x86/kvm/x86.c              |  8 ++++++++
>  arch/x86/kvm/x86.h              |  1 +
>  5 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f8ca74e7678f..a15c783f20b9 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1406,6 +1406,7 @@ struct kvm_arch {
>  
>  	bool bus_lock_detection_enabled;
>  	bool enable_pmu;
> +	bool enable_passthrough_pmu;

Again, as I suggested/requested in the initial RFC[*], drop the per-VM flag as well
as kvm_pmu.passthrough.  There is zero reason to cache the module param.  KVM
should always query kvm->arch.enable_pmu prior to checking if the mediated PMU
is enabled, so I doubt we even need a helper to check both.

[*] https://lore.kernel.org/all/ZhhOEDAl6k-NzOkM@google.com

>  
>  	u32 notify_window;
>  	u32 notify_vmexit_flags;
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index 4d52b0b539ba..cf93be5e7359 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -208,6 +208,20 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  			enable_pmu = false;
>  	}
>  
> +	/* Pass-through vPMU is only supported in Intel CPUs. */
> +	if (!is_intel)
> +		enable_passthrough_pmu = false;
> +
> +	/*
> +	 * Pass-through vPMU requires at least PerfMon version 4 because the
> +	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
> +	 * for counter emulation as well as PMU context switch.  In addition, it
> +	 * requires host PMU support on passthrough mode. Disable pass-through
> +	 * vPMU if any condition fails.
> +	 */
> +	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)

As is quite obvious by the end of the series, the v4 requirement is specific to
Intel.

	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
	    (is_intel && kvm_pmu_cap.version < 4) ||
	    (is_amd && kvm_pmu_cap.version < 2))
		enable_passthrough_pmu = false;

Furthermore, there is zero reason to explicitly and manually check the vendor,
kvm_init_pmu_capability() takes kvm_pmu_ops.  Adding a callback is somewhat
undesirable as it would lead to duplicate code, but we can still provide separation
of concerns by adding const variables to kvm_pmu_ops, a la MAX_NR_GP_COUNTERS.

E.g.

	if (enable_pmu) {
		perf_get_x86_pmu_capability(&kvm_pmu_cap);

		/*
		 * WARN if perf did NOT disable hardware PMU if the number of
		 * architecturally required GP counters aren't present, i.e. if
		 * there are a non-zero number of counters, but fewer than what
		 * is architecturally required.
		 */
		if (!kvm_pmu_cap.num_counters_gp ||
		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
			enable_pmu = false;
		else if (pmu_ops->MIN_PMU_VERSION > kvm_pmu_cap.version)
			enable_pmu = false;
	}

	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
	    pmu_ops->MIN_MEDIATED_PMU_VERSION > kvm_pmu_cap.version)
		enable_mediated_pmu = false;

> +		enable_passthrough_pmu = false;
> +
>  	if (!enable_pmu) {
>  		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>  		return;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ad465881b043..2ad122995f11 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -146,6 +146,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
>  extern bool __read_mostly allow_smaller_maxphyaddr;
>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
>  
> +module_param(enable_passthrough_pmu, bool, 0444);

Hmm, we either need to put this param in kvm.ko, or move enable_pmu to vendor
modules (or duplicate it there if we need to for backwards compatibility?).

There are advantages to putting params in vendor modules, when it's safe to do so,
e.g. it allows toggling the param when (re)loading a vendor module, so I think I'm
supportive of having the param live in vendor code.  I just don't want to split
the two PMU knobs.

>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
>  #define KVM_VM_CR0_ALWAYS_ON				\
> @@ -7924,7 +7926,8 @@ static __init u64 vmx_get_perf_capabilities(void)
>  	if (boot_cpu_has(X86_FEATURE_PDCM))
>  		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
>  
> -	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
> +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
> +	    !enable_passthrough_pmu) {
>  		x86_perf_get_lbr(&vmx_lbr_caps);
>  
>  		/*
> @@ -7938,7 +7941,7 @@ static __init u64 vmx_get_perf_capabilities(void)
>  			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
>  	}
>  
> -	if (vmx_pebs_supported()) {
> +	if (vmx_pebs_supported() && !enable_passthrough_pmu) {

Checking enable_mediated_pmu belongs in vmx_pebs_supported(), not in here,
otherwise KVM will incorrectly advertise support to userspace:

	if (vmx_pebs_supported()) {
		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
	}

>  		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
>  		/*
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f1d589c07068..0c40f551130e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -187,6 +187,10 @@ bool __read_mostly enable_pmu = true;
>  EXPORT_SYMBOL_GPL(enable_pmu);
>  module_param(enable_pmu, bool, 0444);
>  
> +/* Enable/disable mediated passthrough PMU virtualization */
> +bool __read_mostly enable_passthrough_pmu;
> +EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
> +
>  bool __read_mostly eager_page_split = true;
>  module_param(eager_page_split, bool, 0644);
>  
> @@ -6682,6 +6686,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		mutex_lock(&kvm->lock);
>  		if (!kvm->created_vcpus) {
>  			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
> +			/* Disable passthrough PMU if enable_pmu is false. */
> +			if (!kvm->arch.enable_pmu)
> +				kvm->arch.enable_passthrough_pmu = false;

And this code obviously goes away if the per-VM snapshot is removed.

