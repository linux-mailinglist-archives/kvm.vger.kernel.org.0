Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D54D3C3281
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 13:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731379AbfJALcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 07:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59377 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfJALcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 07:32:36 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2A0E81DE0
        for <kvm@vger.kernel.org>; Tue,  1 Oct 2019 11:32:35 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k184so1294263wmk.1
        for <kvm@vger.kernel.org>; Tue, 01 Oct 2019 04:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=kXv5iruapzFw1hsB9GePDq0/reKNI/98qxc8k7MxSvg=;
        b=rQ+XYTvMLRS9IEbJM6hl7rCaaHUmDe6htYqDjuosdvL5udPq2+zm9x5OEz3h3skBTA
         GLeM8kDtdbjNTttFyawIrQS5nSkQTI9wHv/uXIojhusJmpIndT9vrXgFgeyoYy8UAKOY
         wrx4sUMcwn0lPe5RMuhikZ2WltoOSGPSmmyUl0zmbdQR92vA6EPR9ny4AnFRuKTA1+p9
         Aru2tEqwSJslW9UzGdP2FlcFAnR5aofMp7IeDNV9FpFMj0k+65HIDKpcphsZa6V2BIRm
         aJl2xyjtx0FwJNJNwuiz6ScAwWfjErl62kRIJFVVifjCWTj3DqTeva/fZ+ztdDj0zETH
         4sSw==
X-Gm-Message-State: APjAAAXVZe0vKvWhLkHnnCZ27vIVez16MLrUJgBlUjhNg1AGhJ5dHjvV
        CQ7eqOltUI3TmpHS53oJcL7eg1/i3XELVBN1szume4CLqYsSuqj7rqq4jheMp4VEx6nqszFwt/P
        JjKhBJhNMr2RC
X-Received: by 2002:adf:f790:: with SMTP id q16mr16842682wrp.164.1569929554453;
        Tue, 01 Oct 2019 04:32:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIxnYkVu2Ibhkuh3y54PyOHrGHzpLXVlu4TExIrKE9Z8Nwkyku/JS0J8xB4o2+QGwXLux2xA==
X-Received: by 2002:adf:f790:: with SMTP id q16mr16842668wrp.164.1569929554189;
        Tue, 01 Oct 2019 04:32:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s12sm34807303wra.82.2019.10.01.04.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:32:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Marc Orr <marcorr@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: vmx: Limit guest PMCs to those supported on the host
In-Reply-To: <20190930233854.158117-1-jmattson@google.com>
References: <20190930233854.158117-1-jmattson@google.com>
Date:   Tue, 01 Oct 2019 13:32:32 +0200
Message-ID: <87blv03dm7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> KVM can only virtualize as many PMCs as the host supports.
>
> Limit the number of generic counters and fixed counters to the number
> of corresponding counters supported on the host, rather than to
> INTEL_PMC_MAX_GENERIC and INTEL_PMC_MAX_FIXED, respectively.
>
> Note that INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
> contiguous MSR indices reserved by Intel for event selectors. Since
> the existing code relies on a contiguous range of MSR indices for
> event selectors, it can't possibly work for more than 18 general
> purpose counters.

Should we also trim msrs_to_save[] by removing impossible entries
(18-31) then?

>
> Fixes: f5132b01386b5a ("KVM: Expose a version 2 architectural PMU to a guests")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> ---
>  arch/x86/kvm/vmx/pmu_intel.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 4dea0e0e7e392..3e9c059099e94 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -262,6 +262,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct x86_pmu_capability x86_pmu;
>  	struct kvm_cpuid_entry2 *entry;
>  	union cpuid10_eax eax;
>  	union cpuid10_edx edx;
> @@ -283,8 +284,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	if (!pmu->version)
>  		return;
>  
> +	perf_get_x86_pmu_capability(&x86_pmu);
> +
>  	pmu->nr_arch_gp_counters = min_t(int, eax.split.num_counters,
> -					INTEL_PMC_MAX_GENERIC);
> +					 x86_pmu.num_counters_gp);

This is a theoretical fix which is orthogonal to the issue with
state_test I reported on Friday, right? Because in my case
'eax.split.num_counters' is already 8.

>  	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << eax.split.bit_width) - 1;
>  	pmu->available_event_types = ~entry->ebx &
>  					((1ull << eax.split.mask_length) - 1);
> @@ -294,7 +297,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  	} else {
>  		pmu->nr_arch_fixed_counters =
>  			min_t(int, edx.split.num_counters_fixed,
> -				INTEL_PMC_MAX_FIXED);
> +			      x86_pmu.num_counters_fixed);
>  		pmu->counter_bitmask[KVM_PMC_FIXED] =
>  			((u64)1 << edx.split.bit_width_fixed) - 1;
>  	}

-- 
Vitaly
