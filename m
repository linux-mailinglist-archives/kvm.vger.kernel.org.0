Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0582834AD38
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCZRQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:16:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhCZRQ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:16:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616778989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r+9PCDWhRpr0iv5TeePa3grDyptBeVkxlXuZX+CdA6o=;
        b=i+kz92n1thTGlvWUP8AzsWgkS21beKc0JmBhyhy5HLpzkvFMPI7kmDccq2iAvHR8PsJenI
        tHBkLZPkZhR33Lx0A37Zh55WgbZL2++zZMMMKUrWLDTDT9SYkN9aI5RPr1CskxvtWwUp6I
        umdU2zjbXYdK29tNrdlUc+gtpMUIoHU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-BSnrPFFcOSu2GUoHyEnL0g-1; Fri, 26 Mar 2021 13:16:27 -0400
X-MC-Unique: BSnrPFFcOSu2GUoHyEnL0g-1
Received: by mail-wm1-f70.google.com with SMTP id o9-20020a05600c4fc9b029010cea48b602so2641108wmq.0
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 10:16:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r+9PCDWhRpr0iv5TeePa3grDyptBeVkxlXuZX+CdA6o=;
        b=adToNqLTH7spWulipSk/QCO19KBqDDs8H4oJM22cVU10qqxnBXYM6hz+l1cPdETnvk
         xBPA6q2+2SemPmkyx0LORGtUNSV3hUbf0WgHK8M8oxMeQ/9nxNH0TrCzl4VU3hqawH4g
         aTuVtGACE2RtwjMIX2NZjAbw6H0ALK5YOYiOee+cMWHT619FoDGTWeN69NkBSnfY/G6P
         LxrGwlFjLkbEA4QTtgkuYzzHxWAh3SEcHLWEpJCJrdFJG386mPvXNC9L57UMNNQ3K5sj
         6krmmnuuGR0Mzzy0bF0wFw+noHGiGul9+Z4FOXouun4ACxKueu5nzVGFBC910a/FX8n9
         1b8g==
X-Gm-Message-State: AOAM5311SdBf2xKtDZjPtVxqv5hrDE5UuF9PgxEsp8f3ILd8fnPbSgzV
        freB+AZX7lZMxCv/fnLp+On6/V1DYTdsxn1k7+g5ZoYDP5W0cC2tYgrNr9oqoQNNM2h57p2HXxZ
        Tmfb3HdxzEYKE
X-Received: by 2002:adf:f54c:: with SMTP id j12mr15627861wrp.264.1616778986139;
        Fri, 26 Mar 2021 10:16:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytlOVMMoHsu/LWrKqOB14c5WWXr51DhewRZdlReX2HsAhXqw9K5JzyuHeaQu58YP90TQXuGw==
X-Received: by 2002:adf:f54c:: with SMTP id j12mr15627842wrp.264.1616778985969;
        Fri, 26 Mar 2021 10:16:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f16sm13552380wrt.21.2021.03.26.10.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 10:16:25 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid writing to MSR_F15H_PERF MSRs when
 guest doesn't have X86_FEATURE_PERFCTR_CORE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org
References: <20210323084515.1346540-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a40090f1-23a1-fca0-3105-b5e48ee5c86e@redhat.com>
Date:   Fri, 26 Mar 2021 18:16:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210323084515.1346540-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/21 09:45, Vitaly Kuznetsov wrote:
> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs are only available when
> X86_FEATURE_PERFCTR_CORE CPUID bit was exposed to the guest. KVM, however,
> allows these MSRs unconditionally because kvm_pmu_is_valid_msr() ->
> amd_msr_idx_to_pmc() check always passes and because kvm_pmu_set_msr() ->
> amd_pmu_set_msr() doesn't fail.
> 
> In case of a counter (CTRn), no big harm is done as we only increase
> internal PMC's value but in case of an eventsel (CTLn), we go deep into
> perf internals with a non-existing counter.
> 
> Note, kvm_get_msr_common() just returns '0' when these MSRs don't exist
> and this also seems to contradict architectural behavior which is #GP
> (I did check one old Opteron host) but changing this status quo is a bit
> scarier.

Hmm, since these do have a cpuid bit it may not be that scary.

Queued anyway, thanks.

Paolo

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/svm/pmu.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index 035da07500e8..fdf587f19c5f 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -98,6 +98,8 @@ static enum index msr_to_index(u32 msr)
>   static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   					     enum pmu_type type)
>   {
> +	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> +
>   	switch (msr) {
>   	case MSR_F15H_PERF_CTL0:
>   	case MSR_F15H_PERF_CTL1:
> @@ -105,6 +107,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   	case MSR_F15H_PERF_CTL3:
>   	case MSR_F15H_PERF_CTL4:
>   	case MSR_F15H_PERF_CTL5:
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> +			return NULL;
> +		fallthrough;
>   	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
>   		if (type != PMU_TYPE_EVNTSEL)
>   			return NULL;
> @@ -115,6 +120,9 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
>   	case MSR_F15H_PERF_CTR3:
>   	case MSR_F15H_PERF_CTR4:
>   	case MSR_F15H_PERF_CTR5:
> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
> +			return NULL;
> +		fallthrough;
>   	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>   		if (type != PMU_TYPE_COUNTER)
>   			return NULL;
> 

