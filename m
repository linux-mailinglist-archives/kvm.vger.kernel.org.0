Return-Path: <kvm+bounces-35482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 325C0A115FE
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 01:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A3FB188951F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:17:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45651FC0A;
	Wed, 15 Jan 2025 00:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRWJ/zJD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AEB10FD
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 00:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736900249; cv=none; b=M7TeITfK0bYaOKCglPDCyzSaHnD8cVyveVyT3l8pim5Y9JQGglUhC7Ydd2ZjVYTx11UHWADxvM6IDUTtWEcMhFHWLeaSa2HQogvHhNaieEzN7zr6DPXmgY67kVn5RGDfYxq9Yp5VP+hj0aokfAvLN7PCAH1BhZj41UClUa9CGEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736900249; c=relaxed/simple;
	bh=l++N0rRRnmhxtLecqKAzKpyOqgFEVFWwoimOEH4Hs6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HsG0JTMQv3KJFMzmkw3VytSkbF+QfifDo7JlVbF5XX/sDIzImXrcXe606q7o+uHUnkoo2mTKkZ7WI79gRzvGRrcUadri3IjcvSJrwWuX4eombn1zjpSb3rBd1WV7vxqIWjRFT2ahz06zt7yvE7MmMhb5QG8lN6cUMThgkJNNFk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRWJ/zJD; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2167141dfa1so5498805ad.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 16:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736900247; x=1737505047; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uOpQ4k9N7Yz9sD40MgkYZa7qAKsgRfoLfiT4EIq2i2Q=;
        b=eRWJ/zJDs8c3OUIypL2jihM/bimRUyz4Vhz65YzydCEYhT/rN5zvZb3FK0RnQNPJq2
         sb3F2kLF6LjKnLaMeU6BlYnmh8EvAa+F7adGUdydDsu9DzyXvx69lP5/Tf38O5JozkMh
         LLCfCKhY2TF+NznzvVL8wWjo9OwrxVQM97qPIigmshJ0tCQG6MKXVNC1CyQ3oKHtjXnf
         SxOIHYmBVRKfLs1yjuhDIJYSlhCb92f4s+MZoj2nt6odydHHUyfIDU9xbu8idb/w0XiS
         GlTHNW9IJXOp/OHpNAJV7ZFVH4+WK04mDFMkp6kxZx0sNA6Dbx/A6c2bZUR4eeGGbGhc
         6SiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736900247; x=1737505047;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uOpQ4k9N7Yz9sD40MgkYZa7qAKsgRfoLfiT4EIq2i2Q=;
        b=qD4OIZmcTGDEqU/2ihFi5y4XL0V+XaBalUYncEusrjuCSXQNjv78xqLA6Hhjp1nSOU
         uCHkywVj2UVfHq3SGse156XwBPWwiPNTMjpT9sPyiDOsUPW+/lI6t98TRt83QHx36wqP
         oZbMOedle3xL+hb2ZSk8dxqFB3xphuWxL2OhR+/Go3jvepo2O5xKXbgwUrx544fqyORy
         sELzxURXiRCe2zJIrow9yYuRUUR9fnHEJzKBAZKy1nwby9vsQrtv5gc+z/82WO9iQ7ej
         zeYZBLiDOTzXSzA+kQDbyXmBkGUPpnjVQMw49Z9Xg2gXOCRoMJh+rWN9FlkG4p47YQ7O
         JS3A==
X-Forwarded-Encrypted: i=1; AJvYcCVlpckCVTO0IbNfq7FVgKLCTuCa8Yfa5ra9U+yCXlG0rWBBwqQhbXTdojggCXRLFWnWh4I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG8omgn6tZtLBQ88iwvg0DL4FkisC+8jKXK2KZjVLS3ghRGwgL
	FJe89Zqm//5zLnVPmHp1o7BKwmr4r0jTSg18ujy28c0knYfxh3e6rEmjZx8zDQ==
X-Gm-Gg: ASbGncspdfZgWAjZurMJ6vtfYn/1NJjLU16NsuFlcENYxiqV8+jZGyqlsX5k5Tl3nIF
	uim4RJ9199nQY2M6xTBFeUkRsYWv1m0ZRhRr0Xy2SzVg78maFDPP+Uh9PFlkuoqjcyPZsZD4acR
	DbLsd8uOv0NFWpFRjsxAGU2Y90FP93VYh3MquVPe1oUgUaX3U67LC5/ssxMHAQl7YL6MJdUvXH3
	QS/NTjvgQudXq9I4ALKgtl/TCZxt4ho5PUQLFpY6K8ZWgH+erT7eoXX3z/PPvsiVhB8ay9w6QR8
	IWv0NwanMRm4fPQ=
X-Google-Smtp-Source: AGHT+IHlp6t+xXJnV4P8Vu4aZmuAPI3oW4rb8hqktrWG5kw8S4ybvNBeeQDe7sLXbPwA/Tpw8T7PaA==
X-Received: by 2002:a17:902:ec87:b0:215:a808:61cf with SMTP id d9443c01a7336-21bf0d269e3mr13524095ad.25.1736900246677;
        Tue, 14 Jan 2025 16:17:26 -0800 (PST)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f25cc1esm71520325ad.213.2025.01.14.16.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 16:17:25 -0800 (PST)
Date: Wed, 15 Jan 2025 00:17:22 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 18/58] KVM: x86/pmu: Introduce
 enable_passthrough_pmu module parameter
Message-ID: <Z4b-kkRNp1V0faTq@google.com>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-19-mizhang@google.com>
 <Zzyg_0ACKwHGLC7w@google.com>
 <50ba7bd1-6acf-4b50-9eb1-8beb2beee9ec@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50ba7bd1-6acf-4b50-9eb1-8beb2beee9ec@linux.intel.com>

On Wed, Nov 20, 2024, Mi, Dapeng wrote:
> 
> On 11/19/2024 10:30 PM, Sean Christopherson wrote:
> > As per my feedback in the initial RFC[*]:
> >
> >  2. The module param absolutely must not be exposed to userspace until all patches
> >     are in place.  The easiest way to do that without creating dependency hell is
> >     to simply not create the module param.
> >
> > [*] https://lore.kernel.org/all/ZhhQBHQ6V7Zcb8Ve@google.com
> 
> Sure. It looks we missed this comment. Would address it.
> 

Dapeng, just synced with Sean offline. His point is that we still need
kernel parameter but introduce that in the last part of the series so
that any bisect won't trigger the new PMU logic in the middle of the
series. But I think you are right to create a global config and make it
false.

> 
> >
> > On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> >> Introduce enable_passthrough_pmu as a RO KVM kernel module parameter. This
> >> variable is true only when the following conditions satisfies:
> >>  - set to true when module loaded.
> >>  - enable_pmu is true.
> >>  - is running on Intel CPU.
> >>  - supports PerfMon v4.
> >>  - host PMU supports passthrough mode.
> >>
> >> The value is always read-only because passthrough PMU currently does not
> >> support features like LBR and PEBS, while emualted PMU does. This will end
> >> up with two different values for kvm_cap.supported_perf_cap, which is
> >> initialized at module load time. Maintaining two different perf
> >> capabilities will add complexity. Further, there is not enough motivation
> >> to support running two types of PMU implementations at the same time,
> >> although it is possible/feasible in reality.
> >>
> >> Finally, always propagate enable_passthrough_pmu and perf_capabilities into
> >> kvm->arch for each KVM instance.
> >>
> >> Co-developed-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> >> Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
> >> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> >> ---
> >>  arch/x86/include/asm/kvm_host.h |  1 +
> >>  arch/x86/kvm/pmu.h              | 14 ++++++++++++++
> >>  arch/x86/kvm/vmx/vmx.c          |  7 +++++--
> >>  arch/x86/kvm/x86.c              |  8 ++++++++
> >>  arch/x86/kvm/x86.h              |  1 +
> >>  5 files changed, 29 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> >> index f8ca74e7678f..a15c783f20b9 100644
> >> --- a/arch/x86/include/asm/kvm_host.h
> >> +++ b/arch/x86/include/asm/kvm_host.h
> >> @@ -1406,6 +1406,7 @@ struct kvm_arch {
> >>  
> >>  	bool bus_lock_detection_enabled;
> >>  	bool enable_pmu;
> >> +	bool enable_passthrough_pmu;
> > Again, as I suggested/requested in the initial RFC[*], drop the per-VM flag as well
> > as kvm_pmu.passthrough.  There is zero reason to cache the module param.  KVM
> > should always query kvm->arch.enable_pmu prior to checking if the mediated PMU
> > is enabled, so I doubt we even need a helper to check both.
> >
> > [*] https://lore.kernel.org/all/ZhhOEDAl6k-NzOkM@google.com
> 
> Sure.
> 
> 
> >
> >>  
> >>  	u32 notify_window;
> >>  	u32 notify_vmexit_flags;
> >> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> >> index 4d52b0b539ba..cf93be5e7359 100644
> >> --- a/arch/x86/kvm/pmu.h
> >> +++ b/arch/x86/kvm/pmu.h
> >> @@ -208,6 +208,20 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
> >>  			enable_pmu = false;
> >>  	}
> >>  
> >> +	/* Pass-through vPMU is only supported in Intel CPUs. */
> >> +	if (!is_intel)
> >> +		enable_passthrough_pmu = false;
> >> +
> >> +	/*
> >> +	 * Pass-through vPMU requires at least PerfMon version 4 because the
> >> +	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
> >> +	 * for counter emulation as well as PMU context switch.  In addition, it
> >> +	 * requires host PMU support on passthrough mode. Disable pass-through
> >> +	 * vPMU if any condition fails.
> >> +	 */
> >> +	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
> > As is quite obvious by the end of the series, the v4 requirement is specific to
> > Intel.
> >
> > 	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
> > 	    (is_intel && kvm_pmu_cap.version < 4) ||
> > 	    (is_amd && kvm_pmu_cap.version < 2))
> > 		enable_passthrough_pmu = false;
> >
> > Furthermore, there is zero reason to explicitly and manually check the vendor,
> > kvm_init_pmu_capability() takes kvm_pmu_ops.  Adding a callback is somewhat
> > undesirable as it would lead to duplicate code, but we can still provide separation
> > of concerns by adding const variables to kvm_pmu_ops, a la MAX_NR_GP_COUNTERS.
> >
> > E.g.
> >
> > 	if (enable_pmu) {
> > 		perf_get_x86_pmu_capability(&kvm_pmu_cap);
> >
> > 		/*
> > 		 * WARN if perf did NOT disable hardware PMU if the number of
> > 		 * architecturally required GP counters aren't present, i.e. if
> > 		 * there are a non-zero number of counters, but fewer than what
> > 		 * is architecturally required.
> > 		 */
> > 		if (!kvm_pmu_cap.num_counters_gp ||
> > 		    WARN_ON_ONCE(kvm_pmu_cap.num_counters_gp < min_nr_gp_ctrs))
> > 			enable_pmu = false;
> > 		else if (pmu_ops->MIN_PMU_VERSION > kvm_pmu_cap.version)
> > 			enable_pmu = false;
> > 	}
> >
> > 	if (!enable_pmu || !kvm_pmu_cap.passthrough ||
> > 	    pmu_ops->MIN_MEDIATED_PMU_VERSION > kvm_pmu_cap.version)
> > 		enable_mediated_pmu = false;
> 
> Sure.  would do.
> 
> 
> >> +		enable_passthrough_pmu = false;
> >> +
> >>  	if (!enable_pmu) {
> >>  		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
> >>  		return;
> >> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >> index ad465881b043..2ad122995f11 100644
> >> --- a/arch/x86/kvm/vmx/vmx.c
> >> +++ b/arch/x86/kvm/vmx/vmx.c
> >> @@ -146,6 +146,8 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
> >>  extern bool __read_mostly allow_smaller_maxphyaddr;
> >>  module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
> >>  
> >> +module_param(enable_passthrough_pmu, bool, 0444);
> > Hmm, we either need to put this param in kvm.ko, or move enable_pmu to vendor
> > modules (or duplicate it there if we need to for backwards compatibility?).
> >
> > There are advantages to putting params in vendor modules, when it's safe to do so,
> > e.g. it allows toggling the param when (re)loading a vendor module, so I think I'm
> > supportive of having the param live in vendor code.  I just don't want to split
> > the two PMU knobs.
> 
> Since enable_passthrough_pmu has already been in vendor modules,  we'd
> better duplicate enable_pmu module parameter in vendor modules as the 1st step.
> 
> 
> >
> >>  #define KVM_VM_CR0_ALWAYS_OFF (X86_CR0_NW | X86_CR0_CD)
> >>  #define KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST X86_CR0_NE
> >>  #define KVM_VM_CR0_ALWAYS_ON				\
> >> @@ -7924,7 +7926,8 @@ static __init u64 vmx_get_perf_capabilities(void)
> >>  	if (boot_cpu_has(X86_FEATURE_PDCM))
> >>  		rdmsrl(MSR_IA32_PERF_CAPABILITIES, host_perf_cap);
> >>  
> >> -	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
> >> +	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR) &&
> >> +	    !enable_passthrough_pmu) {
> >>  		x86_perf_get_lbr(&vmx_lbr_caps);
> >>  
> >>  		/*
> >> @@ -7938,7 +7941,7 @@ static __init u64 vmx_get_perf_capabilities(void)
> >>  			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
> >>  	}
> >>  
> >> -	if (vmx_pebs_supported()) {
> >> +	if (vmx_pebs_supported() && !enable_passthrough_pmu) {
> > Checking enable_mediated_pmu belongs in vmx_pebs_supported(), not in here,
> > otherwise KVM will incorrectly advertise support to userspace:
> >
> > 	if (vmx_pebs_supported()) {
> > 		kvm_cpu_cap_check_and_set(X86_FEATURE_DS);
> > 		kvm_cpu_cap_check_and_set(X86_FEATURE_DTES64);
> > 	}
> 
> Sure. Thanks for pointing this.
> 
> 
> >
> >>  		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
> >>  		/*
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index f1d589c07068..0c40f551130e 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -187,6 +187,10 @@ bool __read_mostly enable_pmu = true;
> >>  EXPORT_SYMBOL_GPL(enable_pmu);
> >>  module_param(enable_pmu, bool, 0444);
> >>  
> >> +/* Enable/disable mediated passthrough PMU virtualization */
> >> +bool __read_mostly enable_passthrough_pmu;
> >> +EXPORT_SYMBOL_GPL(enable_passthrough_pmu);
> >> +
> >>  bool __read_mostly eager_page_split = true;
> >>  module_param(eager_page_split, bool, 0644);
> >>  
> >> @@ -6682,6 +6686,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >>  		mutex_lock(&kvm->lock);
> >>  		if (!kvm->created_vcpus) {
> >>  			kvm->arch.enable_pmu = !(cap->args[0] & KVM_PMU_CAP_DISABLE);
> >> +			/* Disable passthrough PMU if enable_pmu is false. */
> >> +			if (!kvm->arch.enable_pmu)
> >> +				kvm->arch.enable_passthrough_pmu = false;
> > And this code obviously goes away if the per-VM snapshot is removed.

