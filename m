Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5453DE6E4
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfJUIps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34464 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726648AbfJUIps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:45:48 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06796859FE
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:45:47 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id m16so4216594wmg.8
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 01:45:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NxcJsutZp4Mo+inbr1EsVh3q8y5mAmSjPcmb+JwWrvo=;
        b=mZ3V1mmqu0h7XeK+N1E6bM8zz3LzN8nTq+hhqfH9sYP2Y9p/Oz8bnV8Bzt+nBJVNrN
         3MCWwiK/d1zDhezt8M2JGoy+EKMaEWTpzgl//gaWuIKvUzL7tYaAYq3eyBH7xr66Tp3X
         I/Wp0SJFfXIicmtwUO6ZkFAHjbZ5yPAByypjcf1Zu6fg/ItXlXTLI+KZ+NK9d6C9cDBo
         l45AJnVWXOmpKx8VF4YYOXaY6h5IjQe2TlSUs6QLjEft1okEiSdHIaWxRa8GopKrOG81
         XeJRi1WuTRd/cN+RYM0u/pjQ44ZrVkxE3j4SVmFVOr+V9n4Cs2ilKbwXZoW/Fq7G4k9I
         p21A==
X-Gm-Message-State: APjAAAVfydgRCj8H6Ce4r1JeBjM+CKP0SrYxidK7yDd2tV3LS2woiSvp
        A0XdFw6BquZuXwo6Y9uMew3ADGSNglGX7Y4tqmTnsOCjJw0gIe6VmWEb3stLpjyyGRKo55VJlw5
        z1xf3xVkavIiK
X-Received: by 2002:adf:e2cc:: with SMTP id d12mr19224475wrj.345.1571647545482;
        Mon, 21 Oct 2019 01:45:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxVojICQ6wqgE+Ii+dj2hZY0riLQ1BiFmmATkozEB7yzKxHdkjMjT0mGDmSY0gy5e9Az2i/FQ==
X-Received: by 2002:adf:e2cc:: with SMTP id d12mr19224432wrj.345.1571647545055;
        Mon, 21 Oct 2019 01:45:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:566:fc24:94f2:2f13? ([2001:b07:6468:f312:566:fc24:94f2:2f13])
        by smtp.gmail.com with ESMTPSA id r81sm7595507wme.16.2019.10.21.01.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 01:45:44 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        peterz@infradead.org, Jim Mattson <jmattson@google.com>
Cc:     rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
References: <20191013091533.12971-1-like.xu@linux.intel.com>
 <20191013091533.12971-5-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5eb638a3-5ebe-219a-c975-19808ab702b9@redhat.com>
Date:   Mon, 21 Oct 2019 10:45:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013091533.12971-5-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/19 11:15, Like Xu wrote:
> Currently, a host perf_event is created for a vPMC functionality emulation.
> It’s unpredictable to determine if a disabled perf_event will be reused.
> If they are disabled and are not reused for a considerable period of time,
> those obsolete perf_events would increase host context switch overhead that
> could have been avoided.
> 
> If the guest doesn't access (set_msr/get_msr/rdpmc) any of the vPMC's MSRs
> during an entire vcpu sched time slice, and its independent enable bit of
> the vPMC isn't set, we can predict that the guest has finished the use of
> this vPMC, and then it's time to release non-reused perf_events in the
> first call of vcpu_enter_guest() after the vcpu gets next scheduled in.
> 
> This lazy mechanism delays the event release time to the beginning of the
> next scheduled time slice if vPMC's MSRs aren't accessed during this time
> slice. If guest comes back to use this vPMC in next time slice, a new perf
> event would be re-created via perf_event_create_kernel_counter() as usual.
> 
> Suggested-by: Wei W Wang <wei.w.wang@intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 15 ++++++++++++
>  arch/x86/kvm/pmu.c              | 43 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/pmu.h              |  3 +++
>  arch/x86/kvm/pmu_amd.c          | 13 ++++++++++
>  arch/x86/kvm/vmx/pmu_intel.c    | 25 +++++++++++++++++++
>  arch/x86/kvm/x86.c              | 12 +++++++++
>  6 files changed, 111 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1abbbbae4953..45f9cdae150b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -472,6 +472,21 @@ struct kvm_pmu {
>  	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
>  	struct irq_work irq_work;
>  	u64 reprogram_pmi;
> +
> +	/* for vPMC being set, do not released its perf_event (if any) */
> +	u64 lazy_release_ctrl;

Please use DECLARE_BITMAP(lazy_release_ctrl, X86_PMC_IDX_MAX).  I would
also rename the bitmap to pmc_in_use.

I know you're just copying what reprogram_pmi does, but that has to be
fixed too. :)  I'll send a patch now.

> +	/*
> +	 * The gate to release perf_events not marked in
> +	 * lazy_release_ctrl only once in a vcpu time slice.
> +	 */
> +	bool need_cleanup;
> +
> +	/*
> +	 * The total number of programmed perf_events and it helps to avoid
> +	 * redundant check before cleanup if guest don't use vPMU at all.
> +	 */
> +	u8 event_count;
>  };
>  
>  struct kvm_pmu_ops;
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 09d1a03c057c..7ab262f009f6 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -137,6 +137,7 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  	}
>  
>  	pmc->perf_event = event;
> +	pmc_to_pmu(pmc)->event_count++;
>  	clear_bit(pmc->idx, (unsigned long*)&pmc_to_pmu(pmc)->reprogram_pmi);
>  }
>  
> @@ -368,6 +369,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	if (!pmc)
>  		return 1;
>  
> +	__set_bit(pmc->idx, (unsigned long *)&pmu->lazy_release_ctrl);
>  	*data = pmc_read_counter(pmc) & mask;
>  	return 0;
>  }
> @@ -385,11 +387,13 @@ bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>  
>  int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>  {
> +	kvm_x86_ops->pmu_ops->update_lazy_release_ctrl(vcpu, msr);

Instead of this new pmu_ops entry, please introduce two separate patches
to do the following:

1) rename the existing msr_idx_to_pmc to rdpmc_idx_to_pmc, and
is_valid_msr_idx to is_valid_rdpmc_idx (likewise for
kvm_pmu_is_valid_msr_idx).

2) introduce a new callback msr_idx_to_pmc that returns a struct
kvm_pmc*, and change kvm_pmu_is_valid_msr to do

bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
{
        return (kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
		kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr));
}

and AMD can just return false from .is_valid_msr.

Once this change is done, this patch can use simply:

static int kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
{
	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
	struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr);
	__set_bit(pmc->idx, pmu->pmc_in_use);
}

>  	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr, data);
>  }
>  
>  int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
> +	kvm_x86_ops->pmu_ops->update_lazy_release_ctrl(vcpu, msr_info->index);
>  	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
>  }
>  
> @@ -417,9 +421,48 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  	memset(pmu, 0, sizeof(*pmu));
>  	kvm_x86_ops->pmu_ops->init(vcpu);
>  	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
> +	pmu->lazy_release_ctrl = 0;
> +	pmu->event_count = 0;
> +	pmu->need_cleanup = false;
>  	kvm_pmu_refresh(vcpu);
>  }
>  
> +static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
> +{
> +	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> +
> +	if (pmc_is_fixed(pmc))
> +		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
> +			pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
> +
> +	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
> +}
> +
> +void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +	struct kvm_pmc *pmc = NULL;
> +	u64 bitmask = ~pmu->lazy_release_ctrl;

DECLARE_BITMAP(bitmask, X86_PMC_IDX_MAX);

> +	int i;
> +
> +	if (!unlikely(pmu->need_cleanup))
> +		return;
> +
> +	/* do cleanup before the first time of running vcpu after sched_in */
> +	pmu->need_cleanup = false;
> +
> +	/* release events for unmarked vPMCs in the last sched time slice */
> +	for_each_set_bit(i, (unsigned long *)&bitmask, X86_PMC_IDX_MAX) {

First, you could use for_each_clear_bit instead of inverting.

However, this is iterating unnecessarily through almost all of the 64
bits, most of which will not pass pmc_idx_to_pmc.  You can set up a
bitmap like

	/* in kvm_pmu_refresh */
	bitmap_set(pmu->all_valid_pmc_idx, 0,
		   pmu->nr_arch_fixed_counters);
	bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED,
		   pmu->nr_arch_gp_counters);

	/* on cleanup */
	bitmap_andnot(bitmask, pmu->all_valid_pmc_idx,
		      pmu->pmc_in_use, X86_PMC_IDX_MAX);

	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
		...
	}

Note that on 64-bit machines the bitmap_andnot will be compiled to a
single "x = y & ~z" expression.

> +		pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);
> +
> +		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
> +			pmc_stop_counter(pmc);
> +	}
> +
> +	/* reset vPMC lazy-release bitmap for this sched time slice */
> +	pmu->lazy_release_ctrl = 0;
> +}
> +
>  void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	kvm_pmu_reset(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..023ea5efb3bb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8080,6 +8080,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		goto cancel_injection;
>  	}
>  
> +	/*
> +	 * vPMU uses a lazy method to release the perf_events created for
> +	 * features emulation when the related MSRs weren't accessed during
> +	 * last vcpu time slice. Technically, this cleanup check happens on
> +	 * the first call of vcpu_enter_guest after the vcpu gets scheduled in.
> +	 */
> +	kvm_pmu_cleanup(vcpu);

Instead of calling this unconditionally from vcpu_enter_guest, please
request KVM_REQ_PMU in kvm_arch_sched_in, and call kvm_pmu_cleanup from
kvm_pmu_handle_event.

Paolo

>  	preempt_disable();
>  
>  	kvm_x86_ops->prepare_guest_switch(vcpu);
> @@ -9415,7 +9423,11 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  {
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
>  	vcpu->arch.l1tf_flush_l1d = true;
> +	if (pmu->version && unlikely(pmu->event_count))
> +		pmu->need_cleanup = true;
>  	kvm_x86_ops->sched_in(vcpu, cpu);
>  }
>  
> 

