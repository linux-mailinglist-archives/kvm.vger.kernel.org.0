Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300E22181C6
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 09:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgGHHvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 03:51:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:60487 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbgGHHvJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 03:51:09 -0400
IronPort-SDR: yilGhIrU/OP6LOKCuixqzp+yPpl/2UerUc8ktlq9wnx74VDG27KEa3pkGb+mYe40wEUc9pqTf2
 8kRWlWClAphg==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="135988128"
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="135988128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 00:51:08 -0700
IronPort-SDR: Ru0rE6Z3RVwUmAkQ9gRuhp36wFoUkPXn8WyFCtuBRuHfvmiL9o5tYOThE5T4SevXJHLongB5Ti
 5rEHj6aKIF/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="268406535"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.249.171.189]) ([10.249.171.189])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jul 2020 00:51:06 -0700
Reply-To: like.xu@intel.com
Subject: Re: [PATCH] kvm: x86: limit the maximum number of vPMU fixed counters
 to 3
To:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20200624015928.118614-1-like.xu@linux.intel.com>
From:   "Xu, Like" <like.xu@intel.com>
Organization: Intel OTC
Message-ID: <8de3f450-7efd-96ab-fdf8-169b3327e5ac@intel.com>
Date:   Wed, 8 Jul 2020 15:51:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200624015928.118614-1-like.xu@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kindly ping.

I think we may need this patch, as we limit the maximum vPMU version to 2:
     eax.split.version_id = min(cap.version, 2);

Thanks,
Like Xu

On 2020/6/24 9:59, Like Xu wrote:
> Some new Intel platforms (such as TGL) already have the
> fourth fixed counter TOPDOWN.SLOTS, but it has not been
> fully enabled on KVM and the host.
>
> Therefore, we limit edx.split.num_counters_fixed to 3,
> so that it does not break the kvm-unit-tests PMU test
> case and bad-handled userspace.
>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 2 +-
>   arch/x86/kvm/pmu.h   | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8a294f9747aa..0a2c6d2b4650 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -604,7 +604,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		eax.split.bit_width = cap.bit_width_gp;
>   		eax.split.mask_length = cap.events_mask_len;
>   
> -		edx.split.num_counters_fixed = cap.num_counters_fixed;
> +		edx.split.num_counters_fixed = min(cap.num_counters_fixed, MAX_FIXED_COUNTERS);
>   		edx.split.bit_width_fixed = cap.bit_width_fixed;
>   		edx.split.reserved = 0;
>   
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index ab85eed8a6cc..067fef51760c 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -15,6 +15,8 @@
>   #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
>   #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
>   
> +#define MAX_FIXED_COUNTERS	3
> +
>   struct kvm_event_hw_type_mapping {
>   	u8 eventsel;
>   	u8 unit_mask;

