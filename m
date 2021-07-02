Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD8F3BA0AF
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 14:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhGBMtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 08:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhGBMtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 08:49:52 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16403C061762;
        Fri,  2 Jul 2021 05:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NhPbyO7JE4bS3uwJd81k6yyv7xC+fFP5FE+cPKnwlHE=; b=jB0z2wRpKQvM4CwKSllmU4Pt1K
        9qa2jyEn179Nfk/1oWb23TM/bWLc/AbntbuZAa8SSpYo23TYk1pAZ8mLP21NdsOhhX8xyfOL08qOi
        AanC46QDVbzENcmc3skRi+uBuAIUljcxbszSuPmGS9C7mpEnCkpCnWjWcN6pYxqaD1iRdi1FcnJhX
        pwPQ6jU8LNSNxsGMBCYEfQilIkgxUyRcTEH1jamEXghdIhblkKMRMZTb8/WUyHLn/D8ZMsL8Z5vT4
        o+NhpTvET7HmCGxLo8oCQa6NM0ATW2YprsZunwD7OA/8cPtW6qL6WKbL54Z6zQv+kEi4r3HEAf3dP
        nhsrLHVg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lzIZG-00DrLQ-KR; Fri, 02 Jul 2021 12:46:50 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 48289300091;
        Fri,  2 Jul 2021 14:46:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 32059299AFBF7; Fri,  2 Jul 2021 14:46:48 +0200 (CEST)
Date:   Fri, 2 Jul 2021 14:46:48 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, weijiang.yang@intel.com,
        kan.liang@linux.intel.com, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        like.xu.linux@gmail.com, Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH V7 15/18] KVM: x86/pmu: Disable guest PEBS temporarily in
 two rare situations
Message-ID: <YN8KuNOOm1UBBsGJ@hirez.programming.kicks-ass.net>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-16-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622094306.8336-16-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 22, 2021 at 05:43:03PM +0800, Zhu Lingshan wrote:
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 22386c1a32b4..8bf494f8af3e 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3970,8 +3970,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
>  	};
>  
> -	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
> -	arr[0].guest |= arr[*nr].guest;
> +	if (arr[*nr].host) {
> +		/* Disable guest PEBS if host PEBS is enabled. */
> +		arr[*nr].guest = 0;
> +	} else {
> +		/* Disable guest PEBS for cross-mapped PEBS counters. */
> +		arr[*nr].guest &= ~pmu->host_cross_mapped_mask;
> +		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
> +		arr[0].guest |= arr[*nr].guest;
> +	}

Not saying I disagree, but is there any way for the guest to figure out
why things aren't working? Is there like a guest log we can dump
something in?

> +void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
> +{
> +	struct kvm_pmc *pmc = NULL;
> +	int bit;
> +
> +	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
> +			 X86_PMC_IDX_MAX) {
> +		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
> +
> +		if (!pmc || !pmc_speculative_in_use(pmc) ||
> +		    !pmc_is_enabled(pmc))
> +			continue;
> +
> +		if (pmc->perf_event && (pmc->idx != pmc->perf_event->hw.idx))
> +			pmu->host_cross_mapped_mask |=
> +				BIT_ULL(pmc->perf_event->hw.idx);

{ } again.

> +	}
> +}
