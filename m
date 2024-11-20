Return-Path: <kvm+bounces-32216-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 226F19D4345
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 21:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CC1E1F2217E
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 20:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 364AB1BBBED;
	Wed, 20 Nov 2024 20:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zV9UvF0x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE875487A7
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 20:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732135940; cv=none; b=LgOp8j1M1KcK4y/ll9DpoDFfg3f1HD+NVPukaglwk4FEDnvtoya4j1yVbsCwpAiLERkVpGvl+nqSyWCu9n4M9jZyqDsXmtV6bO1mH7UEpgDdcFHG3XM3VasYdwF86DdvPN9uUxjkJYgDaaexnVdHlwKstEBmlLVU8FMJzEdihc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732135940; c=relaxed/simple;
	bh=2lfuRFHO8D9Blotpx7PaGyXdqYQdEFP6b2qFHXRQ92U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gb7toiSiRk+E9/GbXWxer52vlOxqQ1JjALcpxy9hD49VxpepU+sNCzwkLs169JLHBofBEeEEU7Y+nYaNWIVogBO3M4bCERyChb4FZl8W2kiVRjluYMAYleMSuck8hlxPM2F92SK34de0NQ/XrmoKvypm5qA9Dag9x6AtJxeRBSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zV9UvF0x; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ee07d0f395so223808a12.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 12:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732135938; x=1732740738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6y3gPUDEnGKQ0zDF1IV3hnwNEL2ky/1KJlWMStS7ey0=;
        b=zV9UvF0x0RlU0ObaV4JhSgAFRG20EP2K4FT+3ZFfa5RX4nvktsnqDL49V0RxaKY1G4
         vuefb3s37CAxcN5MAH3sdyK75ltynmtuWNIfTpovVI3gmIz0HFu0qEVZyVhd782/QLhk
         BO9dDcntwkc21jXiuxAl06+3uEUZdzjsgomvL+d26SHYaOVPaAwQYs/KL5//lmbVyso+
         JLv5uFqnA2hqwXQCT+SwB9HoS0bYaKLjG+QfWoXXNUcoKARA7AAmfSYe12+nbvoQKaqn
         nAcUtJMExTQzTUGuJB7gKfDkkyxeHpl0Z1ySWJXQcPRUFQn4AZSL3Pf1cw2Jx5X+c+1X
         zW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732135938; x=1732740738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6y3gPUDEnGKQ0zDF1IV3hnwNEL2ky/1KJlWMStS7ey0=;
        b=ssE0Vqx+Tt/l8SOjJ0vE/9Zz0vUEVki/8Y8+NBHQKipRjy0RZxh0UMQp7FSjhenOCS
         psDdyN7BDZbkGUaGrRplDdwpUvhrponcC9lRfqgAR437qhOoXgH2Ejnvp5jNWLsaJBUQ
         3tERC3ttO6LgTojPGWmipEzRBQlATjrFCCQNYSqcsBIjCNGf9yTkpV7ZqrZmwndcHMvU
         iIMjaDZdKWoDImxBPGZ6UzkfYy+76Qfab6JgGyArZyvNnzmZ2BoDvot8rh+w61zdzhKx
         jZj11DFMOciU9ABOo/I3Q3e1HaGeHDzJsjgfXP4uUd7qgKw98kiJznegNbASNV2xvX4w
         EAIg==
X-Forwarded-Encrypted: i=1; AJvYcCWHYHZI6jqWi9AGDWhNJ2If98wHkleGgZMg3R+RkRyBz3NT1Q5RkTruC4zIM+81QznDPyk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl66//2ENYOitxv0wITczURX7qRodxdPHGar5iLNixFxPynWW2
	Ut+5H93iLkRExV5fYXkrRuKUHtU/tDLGmXysoEzp23+TG677XseLHpii2bVNCmoSZDx+0iol6hB
	FPg==
X-Google-Smtp-Source: AGHT+IFvb93cQevJxFzWVFw8QdNjqH27DlzqjmZkLVPVGkn2IfmPcH9uB8QY8uQrg+Z8pbR2zhTZv8xmerE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:ed4c:0:b0:694:4311:6eb4 with SMTP id
 41be03b00d2f7-7fba7d49c89mr2293a12.8.1732135938101; Wed, 20 Nov 2024 12:52:18
 -0800 (PST)
Date: Wed, 20 Nov 2024 12:52:16 -0800
In-Reply-To: <20240801045907.4010984-48-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-48-mizhang@google.com>
Message-ID: <Zz5MADrxFt_atPph@google.com>
Subject: Re: [RFC PATCH v3 47/58] KVM: nVMX: Add nested virtualization support
 for passthrough PMU
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

On Thu, Aug 01, 2024, Mingwei Zhang wrote:
> Add nested virtualization support for passthrough PMU by combining the MSR
> interception bitmaps of vmcs01 and vmcs12. Readers may argue even without
> this patch, nested virtualization works for passthrough PMU because L1 will
> see Perfmon v2 and will have to use legacy vPMU implementation if it is
> Linux. However, any assumption made on L1 may be invalid, e.g., L1 may not
> even be Linux.
> 
> If both L0 and L1 pass through PMU MSRs, the correct behavior is to allow
> MSR access from L2 directly touch HW MSRs, since both L0 and L1 passthrough
> the access.
> 
> However, in current implementation, if without adding anything for nested,
> KVM always set MSR interception bits in vmcs02. This leads to the fact that
> L0 will emulate all MSR read/writes for L2, leading to errors, since the
> current passthrough vPMU never implements set_msr() and get_msr() for any
> counter access except counter accesses from the VMM side.
> 
> So fix the issue by setting up the correct MSR interception for PMU MSRs.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 52 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 643935a0f70a..ef385f9e7513 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -612,6 +612,55 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
>  						   msr_bitmap_l0, msr);
>  }
>  
> +/* Pass PMU MSRs to nested VM if L0 and L1 are set to passthrough. */
> +static void nested_vmx_set_passthru_pmu_intercept_for_msr(struct kvm_vcpu *vcpu,
> +							  unsigned long *msr_bitmap_l1,
> +							  unsigned long *msr_bitmap_l0)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	int i;
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +						 msr_bitmap_l0,
> +						 MSR_ARCH_PERFMON_EVENTSEL0 + i,
> +						 MSR_TYPE_RW);
> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +						 msr_bitmap_l0,
> +						 MSR_IA32_PERFCTR0 + i,
> +						 MSR_TYPE_RW);
> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +						 msr_bitmap_l0,
> +						 MSR_IA32_PMC0 + i,
> +						 MSR_TYPE_RW);

I think we should add (gross) macros to dedup the bulk of this boilerplate, by
referencing the local variables in the macros.  Like I said, gross.  But I think
it'd be less error prone and easier to read than the copy+paste mess we have today.
E.g. it's easy to miss that only writes are allowed for MSR_IA32_FLUSH_CMD and
MSR_IA32_PRED_CMD, because there's so much boilerplate.

Something like:

#define nested_vmx_merge_msr_bitmaps(msr, type)	\
	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0, msr, type)

#define nested_vmx_merge_msr_bitmaps_read(msr)	\
	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_R);

#define nested_vmx_merge_msr_bitmaps_write(msr)	\
	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_W);

#define nested_vmx_merge_msr_bitmaps_rw(msr)	\
	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW);


	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
		nested_vmx_merge_msr_bitmaps_rw(MSR_ARCH_PERFMON_EVENTSEL0 + i);
		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PERFCTR0+ i);
		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PMC0+ i);
	}

	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++)
		nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_FIXED_CTR_CTRL);

	blah blah blah

> +	}
> +
> +	for (i = 0; i < vcpu_to_pmu(vcpu)->nr_arch_fixed_counters; i++) {

Curly braces are unnecessary.

> +		nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +						 msr_bitmap_l0,
> +						 MSR_CORE_PERF_FIXED_CTR0 + i,
> +						 MSR_TYPE_RW);
> +	}
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +					 msr_bitmap_l0,
> +					 MSR_CORE_PERF_FIXED_CTR_CTRL,
> +					 MSR_TYPE_RW);
> +
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +					 msr_bitmap_l0,
> +					 MSR_CORE_PERF_GLOBAL_STATUS,
> +					 MSR_TYPE_RW);
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +					 msr_bitmap_l0,
> +					 MSR_CORE_PERF_GLOBAL_CTRL,
> +					 MSR_TYPE_RW);
> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,
> +					 msr_bitmap_l0,
> +					 MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> +					 MSR_TYPE_RW);
> +}
> +
>  /*
>   * Merge L0's and L1's MSR bitmap, return false to indicate that
>   * we do not use the hardware.
> @@ -713,6 +762,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>  					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>  
> +	if (is_passthrough_pmu_enabled(vcpu))
> +		nested_vmx_set_passthru_pmu_intercept_for_msr(vcpu, msr_bitmap_l1, msr_bitmap_l0);

Please wrap.  Or better yet:

	nested_vmx_merge_pmu_msr_bitmaps(vmx, msr_bitmap_1, msr_bitmap_l0);

and handle the enable_mediated_pmu check in the helper.

> +
>  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>  
>  	vmx->nested.force_msr_bitmap_recalc = false;
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

