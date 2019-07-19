Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0362E6E9B0
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 18:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbfGSQz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 12:55:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33230 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729947AbfGSQz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 12:55:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so32993162wru.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 09:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RBvdy3j/dhCYKIZJnUPTzXQIvahYRfbHJdHaNI3eSIc=;
        b=sSl2YjgOtZfVuio/O/fbIjw3hHxdQilXrvSLCJOqGNcuQbRJf4M8OnoWWpTRv+Y9Li
         5bJEFk59SQ0xfT214gd1uuIijdNnw2JWO1rjjJWtuSoCDSojuQjte7gQfM5r4nwt0nbj
         +uHcG2S7euMy3EEMYQc3OBYMa+rLM9LzgnzW3BhSLA4l/kvjrGA2+u7KGY4EKTOAlmhU
         ou2sRnM2XVkpAGcBqeuVJwOBA5WKsGTwqhhm/8d9NY6bOYDOavUI1Cw3Ep+Dz4pnbkmo
         o2f0gsHMCfkE9XMCxGdZxBhOpClNvJmoCdkTggKux1iqOTxHMZTwZPrf3zLKfRImG+/s
         VK8Q==
X-Gm-Message-State: APjAAAUYFpnVozyL25Tl0lWlTAbwBprnMcYKwP+ok25kyaeDZYvF+zZm
        a5uwsDRx+qLv7Np9WvPL1W29sA==
X-Google-Smtp-Source: APXvYqwe2mJPKiPtJFOoa2KLgzD4pwJyIgLxoBcFNx6HMokPG7rxdxjAhwBpBI0dEokftw1KeRTy8g==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr55177677wrx.82.1563555355497;
        Fri, 19 Jul 2019 09:55:55 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id f3sm15880801wrt.56.2019.07.19.09.55.54
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 09:55:54 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Add fixed counters to PMU filter
To:     Eric Hankland <ehankland@google.com>,
        Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
References: <20190718183818.190051-1-ehankland@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e3d2ecb1-5a1d-3294-8de1-eff98a935a5f@redhat.com>
Date:   Fri, 19 Jul 2019 18:55:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718183818.190051-1-ehankland@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/07/19 20:38, Eric Hankland wrote:
> From: ehankland <ehankland@google.com>
> 
> Updates KVM_CAP_PMU_EVENT_FILTER so it can also whitelist or blacklist
> fixed counters.
> 
> Signed-off-by: ehankland <ehankland@google.com>

Very nice, thanks.

There's no need to check the padding for zero (flags can be defined to
give specific meanings in the future to the padding fields), I removed
that loop and queued the patch.

Paolo

> ---
>  Documentation/virtual/kvm/api.txt | 13 ++++++++-----
>  arch/x86/include/uapi/asm/kvm.h   |  9 ++++++---
>  arch/x86/kvm/pmu.c                | 30 +++++++++++++++++++++++++-----
>  3 files changed, 39 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 2cd6250b2896..96bcf1aa1931 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -4090,17 +4090,20 @@ Parameters: struct kvm_pmu_event_filter (in)
>  Returns: 0 on success, -1 on error
>  
>  struct kvm_pmu_event_filter {
> -       __u32 action;
> -       __u32 nevents;
> -       __u64 events[0];
> +	__u32 action;
> +	__u32 nevents;
> +	__u32 fixed_counter_bitmap;
> +	__u32 flags;
> +	__u32 pad[4];
> +	__u64 events[0];
>  };
>  
>  This ioctl restricts the set of PMU events that the guest can program.
>  The argument holds a list of events which will be allowed or denied.
>  The eventsel+umask of each event the guest attempts to program is compared
>  against the events field to determine whether the guest should have access.
> -This only affects general purpose counters; fixed purpose counters can
> -be disabled by changing the perfmon CPUID leaf.
> +The events field only controls general purpose counters; fixed purpose
> +counters are controlled by the fixed_counter_bitmap.
>  
>  Valid values for 'action':
>  #define KVM_PMU_EVENT_ALLOW 0
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index e901b0ab116f..503d3f42da16 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -435,9 +435,12 @@ struct kvm_nested_state {
>  
>  /* for KVM_CAP_PMU_EVENT_FILTER */
>  struct kvm_pmu_event_filter {
> -       __u32 action;
> -       __u32 nevents;
> -       __u64 events[0];
> +	__u32 action;
> +	__u32 nevents;
> +	__u32 fixed_counter_bitmap;
> +	__u32 flags;
> +	__u32 pad[4];
> +	__u64 events[0];
>  };
>  
>  #define KVM_PMU_EVENT_ALLOW 0
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index aa5a2597305a..ae5cd1b02086 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -19,8 +19,8 @@
>  #include "lapic.h"
>  #include "pmu.h"
>  
> -/* This keeps the total size of the filter under 4k. */
> -#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 63
> +/* This is enough to filter the vast majority of currently defined events. */
> +#define KVM_PMU_EVENT_FILTER_MAX_EVENTS 300
>  
>  /* NOTE:
>   * - Each perf counter is defined as "struct kvm_pmc";
> @@ -206,12 +206,25 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
>  {
>  	unsigned en_field = ctrl & 0x3;
>  	bool pmi = ctrl & 0x8;
> +	struct kvm_pmu_event_filter *filter;
> +	struct kvm *kvm = pmc->vcpu->kvm;
> +
>  
>  	pmc_stop_counter(pmc);
>  
>  	if (!en_field || !pmc_is_enabled(pmc))
>  		return;
>  
> +	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
> +	if (filter) {
> +		if (filter->action == KVM_PMU_EVENT_DENY &&
> +		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
> +			return;
> +		if (filter->action == KVM_PMU_EVENT_ALLOW &&
> +		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
> +			return;
> +	}
> +
>  	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
>  			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
>  			      !(en_field & 0x2), /* exclude user */
> @@ -376,7 +389,7 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  {
>  	struct kvm_pmu_event_filter tmp, *filter;
>  	size_t size;
> -	int r;
> +	int r, i;
>  
>  	if (copy_from_user(&tmp, argp, sizeof(tmp)))
>  		return -EFAULT;
> @@ -385,6 +398,13 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	    tmp.action != KVM_PMU_EVENT_DENY)
>  		return -EINVAL;
>  
> +	if (tmp.flags != 0)
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(tmp.pad); i++)
> +		if (tmp.pad[i] != 0)
> +			return -EINVAL;
> +
>  	if (tmp.nevents > KVM_PMU_EVENT_FILTER_MAX_EVENTS)
>  		return -E2BIG;
>  
> @@ -406,8 +426,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
>  	mutex_unlock(&kvm->lock);
>  
>  	synchronize_srcu_expedited(&kvm->srcu);
> - 	r = 0;
> +	r = 0;
>  cleanup:
>  	kfree(filter);
> - 	return r;
> +	return r;
>  }
> 

