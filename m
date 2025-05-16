Return-Path: <kvm+bounces-46804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AC65AB9D93
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A1A93B0153
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 13:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A48644C77;
	Fri, 16 May 2025 13:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FncOLA1C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F5C2A1AA
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747402415; cv=none; b=pmtLH9M9ZBHoDoF7CFLHHZCFqZDnqNMzVB1Hg0LgMpVLNngRu71e5HmPSvcOJf//EE4BTDBf/dqAczTA5J7gxlVa6YW1sJQNNWiGKdf/zGBq+HphDGZQ/jQ79ccd3zkAORaZPObwsF9/esvfdfRHumM8sq86bLb52UVeVpe5Mm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747402415; c=relaxed/simple;
	bh=FRhZIy8C0eW0eRV1rO4kuguYk5yijvbkKsK/cWBDRgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oVSagIPbTQ5e0UIfkcJmnlIVNPask5tSh6KBkh4psQTfXl7ETqpzmCBvHGMwglI0FPwcu1V1WJjtLPz4gCIdiAblDZC94fuLZ/bQ49swlaYR0TC1yJNdAgbRp5WmdgrRvRdDT+n/3f+aK+7hqdpbUQnc9cNckmD5s3mZ9AREngw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FncOLA1C; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-231c326fe2bso16677525ad.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 06:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747402413; x=1748007213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KDGUVX2RwhNLT5NPXxVSV0DdRBsVZS86wObxxPPsbk8=;
        b=FncOLA1Ci+PPI8KkrI4MVo2B1SzWYk4GQH5SBxaCnhOV/Jl/JikxORZrdmn2KLl4Is
         NHiOJZpi8akdmXOxXG8zUf7mTNTwnCkeGFriZydIOEBn3kj2HVXzSy9QTK40ncVXowFE
         hq6mqs9bLx7MUMhxtmYyL/yFJluuI+E5fKnmF3rko5LP0+YrpD5IdCTqZJm+QlTxpTrq
         qnwdLZC3uiMvzA0aL4sdWrrHYkp0RapQ2oHxAUL/66ZGPBmT926BSPZ/EtkiiBnS7aTA
         1KIRlIkmZq9pys74X/vdh6H3wQLV6zZ0MTx44IIBTkbn++g2pmPIXk2tMA/5I0rNwGoI
         Y4bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747402413; x=1748007213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDGUVX2RwhNLT5NPXxVSV0DdRBsVZS86wObxxPPsbk8=;
        b=gwmVnvlI80TynueIztmG3yFzi1QtEeef8FlKQSAw+QC/7E5v4oTN5D/jmoldkAW2NI
         6wM9LYDz4nQk9a1mdObYF7jUu0Oa/veyq7UjAILHdOLxGxs9y4pF9XATBUU1psaQudNC
         4vHM0o5TptyXcqqnC/Q76RfaZ5GUXvNu8q0umOmT36B9OOCplHx7Fzfj2h6HD1tm61Su
         9F+0TjQauCJE57Qa+q+faLeMLQmoluPnFQAnAng4rZfmt8b2EwH8APYw+/CGNVDY1p+k
         +IjAXDDerApSarPgT9vX91JmbtqudRfbLr/GF9Za/PYaku1WR3sAJ4AEMXjn6kae2r3g
         aP9A==
X-Forwarded-Encrypted: i=1; AJvYcCX3ARzUt0lg/mhtEd5n8H5h43/4M+MRyR0xKEebVrdniRj+SbEFWgoKzu0RP9uElO7cYYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDrvUATuODPFeSx1LSEUTopi2L/uOb7rn5nfHzdV+SI+ZDVhKR
	suxAfjFkP9l7VBEIIIc7AkkZrG/YlADjc4FwKs4Z+WAZYi53cqosmfy4CS/tcdUbj3nU9DH+E8c
	d/58QWQ==
X-Google-Smtp-Source: AGHT+IGqXXBKxkrM7eRDYiPnM7bRnqmiBwCU1lHICfCxR4zzeniMzTPy5RM6XoGiiUxm0AtX4CbnBEq/OEA=
X-Received: from plgm8.prod.google.com ([2002:a17:902:f648:b0:223:f7b1:99cc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c949:b0:224:5a8:ba29
 with SMTP id d9443c01a7336-231de3ba251mr35699265ad.43.1747402413061; Fri, 16
 May 2025 06:33:33 -0700 (PDT)
Date: Fri, 16 May 2025 06:33:31 -0700
In-Reply-To: <20250324173121.1275209-33-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-33-mizhang@google.com>
Message-ID: <aCc-q_udsn8o1vBT@google.com>
Subject: Re: [PATCH v4 32/38] KVM: nVMX: Add nested virtualization support for
 mediated PMU
From: Sean Christopherson <seanjc@google.com>
To: Mingwei Zhang <mizhang@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Sandipan Das <sandipan.das@amd.com>, Zide Chen <zide.chen@intel.com>, 
	Eranian Stephane <eranian@google.com>, Shukla Manali <Manali.Shukla@amd.com>, 
	Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="us-ascii"

This shortlog is unnecessarily confusing.  It reads as if supported for running
L2 in a vCPU with a mediated PMU is somehow lacking.

On Mon, Mar 24, 2025, Mingwei Zhang wrote:
> Add nested virtualization support for mediated PMU by combining the MSR
> interception bitmaps of vmcs01 and vmcs12.

Do not phrase changelogs related to nested virtualization in terms of enabling a
_KVM_ feature.  KVM has no control over what hypervisor runs in L1.  It's a-ok to
provide example use cases, but they need to be just that, examples.

> Readers may argue even without this patch, nested virtualization works for
> mediated PMU because L1 will see Perfmon v2 and will have to use legacy vPMU
> implementation if it is Linux. However, any assumption made on L1 may be
> invalid, e.g., L1 may not even be Linux.
> 
> If both L0 and L1 pass through PMU MSRs, the correct behavior is to allow
> MSR access from L2 directly touch HW MSRs, since both L0 and L1 passthrough
> the access.
> 
> However, in current implementation, if without adding anything for nested,
> KVM always set MSR interception bits in vmcs02. This leads to the fact that
> L0 will emulate all MSR read/writes for L2, leading to errors, since the
> current mediated vPMU never implements set_msr() and get_msr() for any
> counter access except counter accesses from the VMM side.
> 
> So fix the issue by setting up the correct MSR interception for PMU MSRs.

This is not a fix.  

    KVM: nVMX: Disable PMU MSR interception as appropriate while running L2
    
    Merge KVM's PMU MSR interception bitmaps with those of L1, i.e. merge the
    bitmaps of vmcs01 and vmcs12, e.g. so that KVM doesn't interpose on MSR
    accesses unnecessarily if L1 exposes a mediated PMU (or equivalent) to L2.

> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cf557acf91f8..dbec40cb55bc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -626,6 +626,36 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
>  #define nested_vmx_merge_msr_bitmaps_rw(msr) \
>  	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW)
>  
> +/*
> + * Disable PMU MSRs interception for nested VM if L0 and L1 are
> + * both mediated vPMU.
> + */

Again, KVM has no idea what is running in L1.  Drop this.

> +static void nested_vmx_merge_pmu_msr_bitmaps(struct kvm_vcpu *vcpu,
> +					     unsigned long *msr_bitmap_l1,
> +					     unsigned long *msr_bitmap_l0)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	int i;
> +
> +	if (!kvm_mediated_pmu_enabled(vcpu))

This is a worthwhile check, but a comment would be helpful:

	/*
	 * Skip the merges if the vCPU doesn't have a mediated PMU MSR, i.e. if
	 * none of the MSRs can possibly be passed through to L1.
	 */
	if (!kvm_vcpu_has_mediated_pmu(vcpu))
		return;

> +		return;
> +
> +	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
> +		nested_vmx_merge_msr_bitmaps_rw(MSR_ARCH_PERFMON_EVENTSEL0 + i);

This is unnecessary, KVM always intercepts event selectors.

> +		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PERFCTR0 + i);
> +		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PMC0 + i);
> +	}
> +
> +	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
> +		nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_FIXED_CTR0 + i);
> +
> +	nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_FIXED_CTR_CTRL);

Same thing here.

> +	nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_GLOBAL_CTRL);
> +	nested_vmx_merge_msr_bitmaps_read(MSR_CORE_PERF_GLOBAL_STATUS);
> +	nested_vmx_merge_msr_bitmaps_write(MSR_CORE_PERF_GLOBAL_OVF_CTRL);
> +}

