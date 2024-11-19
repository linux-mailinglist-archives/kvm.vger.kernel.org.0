Return-Path: <kvm+bounces-32086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8379D2CC9
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 18:38:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4B94B297CB
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 17:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236781CDA1C;
	Tue, 19 Nov 2024 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uUOZmhKV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63F51D0175
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732037556; cv=none; b=cXzsoiw0hjA93VpSdul3ZfnNSGDnaauHpADCQ3IDW8hBXVTn2jMplXEkDf5J59aEXinTkwj8WHlAEiDAjyng88xpVucgRuArd6It4v/TDDmABDfMD90kv6aE3Wn8yltYq6iFJP2BVFLkNJFRPZyvteOOvV0gLjm6Ot8jln2T19A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732037556; c=relaxed/simple;
	bh=1WrQ+zgab3hG/h+7G1Prd1RtR8sy51prU3LGZoGbG0k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5L+++cdU9q0asQikl2Q6YsSPxtbpbFWQf6gg/u3I967+o0cUz7vSLTHhH34hoSBFDzZFcerXUaUR//lSNCBAWKmNNr+5UrbhQOq2mN9aduV1QCxdWuz9Sg2RB2vSLIFo/NVwXMwajIoRlqqlpftxMDoeGCgJYOyXJ+oYq+mFwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uUOZmhKV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2124debb33cso164035ad.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 09:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732037554; x=1732642354; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jWbC/fZ7wTzsJNsqDVHTfCZk7/WZnnCCSq7uKfUPNpY=;
        b=uUOZmhKVtmBBWwM4MyZuc3Rr09NhcR1KjlmphcGFejWfnzlS782SyJAp+iuniajadj
         dR4cRaDNtEl2jnkcQIKO/GSBORhKyFFeq2JBn14O0J2wQEZ1eBAN7EiirHvzZ1vznH+a
         EQcopD5N9vPZVUNStw/DGNp0dYsLWPhqziNgiXatcRVFnISsQGmg1HqES2gNLFlbHdVo
         iHr9LXJEw1qj6MmZ2mEVwnrTUADx2TKbAt4GtDRhr/2kkOOrBcviMR1Kx1r/Xe6nZvN2
         YWvLiUjFM1NuxMielgihUGXm6Xo1JZecVMDC0ieGIf5+wYyMm9N4l6VkrMBa5Dsfl5Vz
         YxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732037554; x=1732642354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jWbC/fZ7wTzsJNsqDVHTfCZk7/WZnnCCSq7uKfUPNpY=;
        b=RbcCUiwxaQNWTg2ocOwOcdkLu7MM2OBKQjDWKK8I/WjXoVFbaLmBSUMYELCBIiuHjW
         2irxQgDdSf36WtOFQHSdOAuPM8pvE2RMhSsrRGn+urVpv3r6AGPOHBCCuOf+kd4Xe0TT
         +oJk6fEE9CQeEwBNQqMfuxDSR6k+L/1kcGOw+lLgvPCIzTlTkVDCbbFb9s5hGMJyIf19
         kRDuIDomJ8ssjjy5u3qDsSFLjEK+Fn01L7DlSWhjkOxXtqNhpWwGpqCNwSuJijJPw8XI
         rQ3HsOx2qIlzeyBCtCOHHoBlK6agckjab7/V4MHsQxnX2XtHrk+L5upVWU/JpyHYN3eY
         nG0g==
X-Forwarded-Encrypted: i=1; AJvYcCWDtMCPvoSzTuLrbVdKcZmRbGGMNoaDSmVXRbMg38cnBZR14lEOg+K2scZlmO3yYnfuv9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqnIJj3JaP/xsHv06tzQYJtG0rPQ1VNDrt2h9l0714OkfPYnEQ
	ldGVXwB7OGCBbIgoMB3U2WhVmJiROw7AKMiRmTiv0rEfgVDY3X1q9hrfDdBhyiusp0GxxCVBMwV
	xEQ==
X-Google-Smtp-Source: AGHT+IHt0cviA4CjNoaA2xaQQtrrvRdF865/qj4o5zsRbEpZ0OPIg/1JCWX3P5YE+B7c70W5J/wd/B1omGU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:903:2386:b0:211:e4c4:9739 with SMTP id
 d9443c01a7336-2124b605591mr66635ad.3.1732037554021; Tue, 19 Nov 2024 09:32:34
 -0800 (PST)
Date: Tue, 19 Nov 2024 09:32:32 -0800
In-Reply-To: <20240801045907.4010984-26-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com> <20240801045907.4010984-26-mizhang@google.com>
Message-ID: <ZzzLsLE-BmzVAXF0@google.com>
Subject: Re: [RFC PATCH v3 25/58] KVM: x86/pmu: Introduce PMU operator to
 check if rdpmc passthrough allowed
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
> Introduce a vendor specific API to check if rdpmc passthrough allowed.
> RDPMC passthrough requires guest VM have the full ownership of all
> counters. These include general purpose counters and fixed counters and
> some vendor specific MSRs such as PERF_METRICS. Since PERF_METRICS MSR is
> Intel specific, putting the check into vendor specific code.
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Tested-by: Yongwei Ma <yongwei.ma@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
>  arch/x86/kvm/pmu.c                     |  1 +
>  arch/x86/kvm/pmu.h                     |  1 +
>  arch/x86/kvm/svm/pmu.c                 |  6 ++++++
>  arch/x86/kvm/vmx/pmu_intel.c           | 16 ++++++++++++++++
>  5 files changed, 25 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> index f852b13aeefe..fd986d5146e4 100644
> --- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
> @@ -20,6 +20,7 @@ KVM_X86_PMU_OP(get_msr)
>  KVM_X86_PMU_OP(set_msr)
>  KVM_X86_PMU_OP(refresh)
>  KVM_X86_PMU_OP(init)
> +KVM_X86_PMU_OP(is_rdpmc_passthru_allowed)
>  KVM_X86_PMU_OP_OPTIONAL(reset)
>  KVM_X86_PMU_OP_OPTIONAL(deliver_pmi)
>  KVM_X86_PMU_OP_OPTIONAL(cleanup)
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 19104e16a986..3afefe4cf6e2 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -102,6 +102,7 @@ bool kvm_pmu_check_rdpmc_passthrough(struct kvm_vcpu *vcpu)
>  
>  	if (is_passthrough_pmu_enabled(vcpu) &&
>  	    !enable_vmware_backdoor &&
> +	    static_call(kvm_x86_pmu_is_rdpmc_passthru_allowed)(vcpu) &&

If the polarity is inverted, the callback can be OPTIONAL_RET0 on AMD.  E.g.

	if (kvm_pmu_call(rdpmc_needs_intercept(vcpu)))
		return false;

> +static bool intel_is_rdpmc_passthru_allowed(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Per Intel SDM vol. 2 for RDPMC, 


Please don't reference specific sections in the comments.  For changelogs it's
ok, because changelogs are a snapshot in time.  But comments are living things
and will become stale in almost every case.  And I don't see any reason to reference
the SDM, just state the behavior; it's implied that that's the architectural
behavior, otherwise KVM is buggy.

> MSR_PERF_METRICS is accessible by

This is technically wrong, the SDM states that the RDPMC behavior is implementation
specific.  That matters to some extent, because if it was _just_ one MSR and was
guaranteed to always be that one MSR, it might be worth creating a virtualization
hole.

	/*
	 * Intercept RDPMC if the host supports PERF_METRICS, but the guest
	 * does not, as RDPMC with type 0x2000 accesses implementation specific
	 * metrics.
	 */


All that said, isn't this redundant with the number of fixed counters?  I'm having
a hell of a time finding anything concrete in the SDM, but IIUC fixed counter 3
is tightly coupled to perf metrics.  E.g. rather than add a vendor hook just for
this, rely on the fixed counters and refuse to enable the mediated PMU if the
underlying CPU model is nonsensical, i.e. perf metrics exists without ctr3.

And I kinda think we have to go that route, because enabling RDPMC interception
based on future features is doomed from the start.  E.g. if this code had been
written prior to PERF_METRICS, older KVMs would have zero clue that RDPMC needs
to be intercepted on newer hardware.

