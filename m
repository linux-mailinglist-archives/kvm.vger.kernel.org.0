Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5C838271A
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 10:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhEQIeZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 04:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEQIeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 04:34:24 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAB1C06174A;
        Mon, 17 May 2021 01:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=20zL0ln3LHXNxQ0Sy6jUMuXo+7cHfsXLR0tupctFTis=; b=WlTl1db9TAltXyeem9fz3X6wG2
        gZXKbdrTfVRmRnpnCIuZNJCM7OgUBFZVl5OWZtIbTman1axDLUH3ymi/WA0VzgqrORDF2dDBc2AK9
        qTTORVakvJB9Ns0IlTwiD6eS8flT/qNVKfnfbRKn2NApyGrYqurfU00Tx6nGvKN9SrBTcc9hmP3lf
        VNwhJn2xxUyquAm9MBBoKzsAJkgrLvPDcA4LtHV6XUTZwDiJ8PbheZjxWVUvVyxZNJxihMM4I/L0w
        16QyygZIdKNKZ35ndg/By2WOEIxzn5XGCbY4SH8yLMen8yitRFBbU5Axp6O1+PFTXM1vXRiVcnNil
        lW1ExkNw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1liYg2-00EG1I-K0; Mon, 17 May 2021 08:32:40 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5AB14300095;
        Mon, 17 May 2021 10:32:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 43FCE2D3D3E90; Mon, 17 May 2021 10:32:37 +0200 (CEST)
Date:   Mon, 17 May 2021 10:32:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Luwei Kang <luwei.kang@intel.com>
Subject: Re: [PATCH v6 06/16] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR
 emulation for extended PEBS
Message-ID: <YKIqJTe/StbBrrUy@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-7-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511024214.280733-7-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 10:42:04AM +0800, Like Xu wrote:
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2f89fd599842..c791765f4761 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3898,31 +3898,49 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
>  	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
>  	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
>  	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
> +	u64 pebs_mask = (x86_pmu.flags & PMU_FL_PEBS_ALL) ?
> +		cpuc->pebs_enabled : (cpuc->pebs_enabled & PEBS_COUNTER_MASK);
> +
> +	*nr = 0;
> +	arr[(*nr)++] = (struct perf_guest_switch_msr){
> +		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
> +		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
> +		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
> +	};
>  
> +	if (!x86_pmu.pebs)
> +		return arr;
>  
> +	/*
> +	 * If PMU counter has PEBS enabled it is not enough to
> +	 * disable counter on a guest entry since PEBS memory
> +	 * write can overshoot guest entry and corrupt guest
> +	 * memory. Disabling PEBS solves the problem.
> +	 *
> +	 * Don't do this if the CPU already enforces it.
> +	 */
> +	if (x86_pmu.pebs_no_isolation) {
> +		arr[(*nr)++] = (struct perf_guest_switch_msr){
> +			.msr = MSR_IA32_PEBS_ENABLE,
> +			.host = cpuc->pebs_enabled,
> +			.guest = 0,
> +		};
> +		return arr;
>  	}
>  
> +	if (!x86_pmu.pebs_vmx)
> +		return arr;
> +
> +	arr[*nr] = (struct perf_guest_switch_msr){
> +		.msr = MSR_IA32_PEBS_ENABLE,
> +		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
> +		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
> +	};
> +
> +	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
> +	arr[0].guest |= arr[*nr].guest;
> +
> +	++(*nr);
>  	return arr;
>  }

ISTR saying I was confused as heck by this function, I still don't see
clarifying comments :/

What's .host and .guest ?
