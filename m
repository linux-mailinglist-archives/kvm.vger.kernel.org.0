Return-Path: <kvm+bounces-10603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3569F86DD34
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 09:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E360C2830CF
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BAB869E08;
	Fri,  1 Mar 2024 08:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBClkucG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA5569D0F;
	Fri,  1 Mar 2024 08:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709282248; cv=none; b=iUTF0wjxLMN9HRIPoEY4BkAEt5vx24nzMNTq9l2VfojSgVaeu7Y56ve5kXaCfrcKqcqx3iPvFqIcEIgNr2u8P+eMklWWUcO2G2aUbc1Vn20pq0v5bxBu/6+0W1MKQwvMS/ON5DdiICB0K+631qpGDmNpbbcmkN3PaRjc43CZpZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709282248; c=relaxed/simple;
	bh=O/xcTjzqimRfgoome/Wsnc5JDospAjX/DhL+CZ4+z7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ak9+8ZhOSeSyitxu9vAfFnLdwc8jTEn27sC0mLsZ7yLbFKDZsd2b0f+sOWagQwh+PH5tz//D9CkbAq5XJadbmcxJl0L8gGkVPQs33p5zwH/XqbKdL7wNWDts8xynOP4JOKm8wXxRlx62hXuCD8odoK/nuh490BxjJWpIwcbRTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBClkucG; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-299ea1f1989so1356014a91.0;
        Fri, 01 Mar 2024 00:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709282246; x=1709887046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1KP1OIsCMvJGez96bNApKJ4GpsDICD3OZeSUcfZwjEc=;
        b=dBClkucGCNQG6VpUvd8UWVJPW500FjQnkWKP3U7h2qsmwr+Ke/uF98gNHQ2ko/rlsF
         vY9BwX3ZUBzFHDXrArfA2jXzVCTgC7+TN0jcE06j6nh5d21q40XsnuPKXNZSVbK5bijM
         MD65zuPubBoI0V5GmyZprrjFoWVgxaYGrmPngxxdv0OU+z6br3GTT6MC8eSvZ00i8q7Y
         aWf1sVdGQHMZiTUubN9HPTTPnDkIl/emlQaUY3dYzGDM5cxqo9dAaOdRPqvefBheYpEt
         hpo3LcpqRx6No9YcV56/eUq9OHC0FpFK5kI2lYeL0qe3s2hcisf/VfZh4RON0IuCx9Kq
         BsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709282246; x=1709887046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1KP1OIsCMvJGez96bNApKJ4GpsDICD3OZeSUcfZwjEc=;
        b=kWr5Oa+OpQMOeTfNQXKqzDKITSLifq/S7Hb11sKJv275KR+YHWNmTCA8Z6Z9seRYmf
         2Kg1sVxKDoIulgONvVZq8V2ZSlc4J7gtAXLy0kr8cUFzdDdfApSl32wTEEvfHn0dfNd3
         u6Uibo6wEDRIWBblFF/Oox04NLVhi7zDVnhU/8Nj8Fyh9PiJPD3J53MEQhkDmnIjdU/o
         N/16rx7GZtWqSJE87OhoTCZQQA7mC3slss8TlIUnhZk+qbZLE5BBuDyH0aABUGMZ/pa+
         tl62bpZ7f9j7/KZFF7hKNE4XRNfnwjOMdVezJRWy6rqXvlbsBOzKrutg800YJT4iSE/U
         zH2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNbfiJzI14onxQ4WOtol0sWTOCzOzVLhOM+lrMycFPcilmcL+dPU3m+j5DVw8VAZ0CEDEU0hqJtcoqFSjPpp9aO/6hzANAbR/Qf6jnEmOI3fbpli8CQ7rYu/jXP1niSj31
X-Gm-Message-State: AOJu0Yz1QCdGwf9ch/yrb9oms38kqn9FYwCcsZxOyS2Bu1tNkFj9irgd
	epxgZNXn7Lz7TElC95/ZfI9LISIStpFocVeuGPpLSpgPjWrXP0/O
X-Google-Smtp-Source: AGHT+IF6CJdU3IVs+5kG8Yi4Ol3M1o4Vi/U3gm2EL4hHhkVGhHKBRvvSuZZMH9oBYmRD/sFnfzUocA==
X-Received: by 2002:a17:90a:a8f:b0:299:7b37:9221 with SMTP id 15-20020a17090a0a8f00b002997b379221mr924936pjw.12.1709282246357;
        Fri, 01 Mar 2024 00:37:26 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id c13-20020a17090ae10d00b0029a8a599584sm2712200pjz.13.2024.03.01.00.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 00:37:25 -0800 (PST)
Message-ID: <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
Date: Fri, 1 Mar 2024 16:37:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
Content-Language: en-US
To: Sandipan Das <sandipan.das@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dapeng1.mi@linux.intel.com,
 mizhang@google.com, jmattson@google.com, ravi.bangoria@amd.com,
 nikunj.dadhania@amd.com, santosh.shukla@amd.com, manali.shukla@amd.com,
 babu.moger@amd.com, kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20240301075007.644152-1-sandipan.das@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/2024 3:50 pm, Sandipan Das wrote:
> With PerfMonV2, a performance monitoring counter will start operating
> only when both the PERF_CTLx enable bit as well as the corresponding
> PerfCntrGlobalCtl enable bit are set.
> 
> When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
> for a guest but the guest kernel does not support PerfMonV2 (such as
> kernels older than v5.19), the guest counters do not count since the
> PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
> writes to it.

If the vcpu has the PerfMonV2 feature, it should not work the way legacy
PMU does. Users need to use the new driver to operate the new hardware,
don't they ? One practical approach is that the hypervisor should not set
the PerfMonV2 bit for this unpatched 'v5.19' guest.

> 
> This is not observed on bare-metal as the default value of the
> PerfCntrGlobalCtl MSR after a reset is 0x3f (assuming there are six
> counters) and the counters can still be operated by using the enable
> bit in the PERF_CTLx MSRs. Replicate the same behaviour in guests for
> compatibility with older kernels.
> 
> Before:
> 
>    $ perf stat -e cycles:u true
> 
>     Performance counter stats for 'true':
> 
>                     0      cycles:u
> 
>           0.001074773 seconds time elapsed
> 
>           0.001169000 seconds user
>           0.000000000 seconds sys
> 
> After:
> 
>    $ perf stat -e cycles:u true
> 
>     Performance counter stats for 'true':
> 
>               227,850      cycles:u
> 
>           0.037770758 seconds time elapsed
> 
>           0.000000000 seconds user
>           0.037886000 seconds sys
> 
> Reported-by: Babu Moger <babu.moger@amd.com>
> Fixes: 4a2771895ca6 ("KVM: x86/svm/pmu: Add AMD PerfMonV2 support")
> Signed-off-by: Sandipan Das <sandipan.das@amd.com>
> ---
>   arch/x86/kvm/svm/pmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index b6a7ad4d6914..14709c564d6a 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>   	if (pmu->version > 1) {
>   		pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>   		pmu->global_status_mask = pmu->global_ctrl_mask;
> +		pmu->global_ctrl = ~pmu->global_ctrl_mask;
>   	}
>   
>   	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;

