Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A7B3305DF
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 03:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233506AbhCHC0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Mar 2021 21:26:17 -0500
Received: from mga17.intel.com ([192.55.52.151]:24107 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233441AbhCHC0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Mar 2021 21:26:07 -0500
IronPort-SDR: n0yWkPXabg+f8BJCFVkga4mR3hVF2IHVMZIMBQK0xDW6w4TEKZ47QWAbD3gVxNpVUWlhhNVRir
 UXRQ01zvXkyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="167861023"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="167861023"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 18:26:07 -0800
IronPort-SDR: agRF+I/ATsQ+wOLFCyQguMyFtP39FdHEbbtUCNQ4kVrRdL1zfbuCIGmdxjtbJzIv5mfZJZ5jKy
 uJOFLBk8tgAA==
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="409126690"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.93]) ([10.238.4.93])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 18:26:01 -0800
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no
 PMU
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dmitry Vyukov <dvyukov@google.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Thomas Gleixner
         "(x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)"
         "(x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
References: <20210305223331.4173565-1-seanjc@google.com>
From:   "Xu, Like" <like.xu@intel.com>
Message-ID: <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
Date:   Mon, 8 Mar 2021 10:25:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305223331.4173565-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/3/6 6:33, Sean Christopherson wrote:
> Handle a NULL x86_pmu.guest_get_msrs at invocation instead of patching
> in perf_guest_get_msrs_nop() during setup.  If there is no PMU, setup

"If there is no PMU" ...

How to set up this kind of environment,
and what changes are needed in .config or boot parameters ?

> bails before updating the static calls, leaving x86_pmu.guest_get_msrs
> NULL and thus a complete nop.

> Ultimately, this causes VMX abort on
> VM-Exit due to KVM putting random garbage from the stack into the MSR
> load list.
>
> Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
> Cc: Like Xu <like.xu@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: kvm@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/events/core.c | 16 +++++-----------
>   1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 6ddeed3cd2ac..ff874461f14c 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -671,7 +671,11 @@ void x86_pmu_disable_all(void)
>   
>   struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
>   {
> -	return static_call(x86_pmu_guest_get_msrs)(nr);
> +	if (x86_pmu.guest_get_msrs)
> +		return static_call(x86_pmu_guest_get_msrs)(nr);

How about using "static_call_cond" per commit "452cddbff7" ?

> +
> +	*nr = 0;
> +	return NULL;
>   }
>   EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
>   
> @@ -1944,13 +1948,6 @@ static void _x86_pmu_read(struct perf_event *event)
>   	x86_perf_event_update(event);
>   }
>   
> -static inline struct perf_guest_switch_msr *
> -perf_guest_get_msrs_nop(int *nr)
> -{
> -	*nr = 0;
> -	return NULL;
> -}
> -
>   static int __init init_hw_perf_events(void)
>   {
>   	struct x86_pmu_quirk *quirk;
> @@ -2024,9 +2021,6 @@ static int __init init_hw_perf_events(void)
>   	if (!x86_pmu.read)
>   		x86_pmu.read = _x86_pmu_read;
>   
> -	if (!x86_pmu.guest_get_msrs)
> -		x86_pmu.guest_get_msrs = perf_guest_get_msrs_nop;
> -
>   	x86_pmu_static_call_update();
>   
>   	/*

