Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24EA23E4741
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 16:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbhHIOMr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 10:12:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:40934 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233274AbhHIOMr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 10:12:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="275737180"
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="275737180"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 07:12:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,307,1620716400"; 
   d="scan'208";a="514968970"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Aug 2021 07:12:24 -0700
Received: from [10.209.33.137] (kliang2-MOBL.ccr.corp.intel.com [10.209.33.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 202EE580910;
        Mon,  9 Aug 2021 07:12:23 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/pmu: Don't expose guest LBR if the LBR_SELECT is
 shared per physical core
To:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Andi Kleen <ak@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210809074803.43154-1-likexu@tencent.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Message-ID: <7599a987-c931-20f1-9441-d86222a4519d@linux.intel.com>
Date:   Mon, 9 Aug 2021 10:12:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809074803.43154-1-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/9/2021 3:48 AM, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> According to Intel SDM, the Last Branch Record Filtering Select Register
> (R/W) is defined as shared per physical core rather than per logical core
> on some older Intel platforms: Silvermont, Airmont, Goldmont and Nehalem.
> 
> To avoid LBR attacks or accidental data leakage, on these specific
> platforms, KVM should not expose guest LBR capability even if HT is
> disabled on the host, considering that the HT state can be dynamically
> changed, yet the KVM capabilities are initialized at module initialisation.
> 
> Fixes: be635e34c284 ("KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   arch/x86/include/asm/intel-family.h |  1 +
>   arch/x86/kvm/vmx/capabilities.h     | 19 ++++++++++++++++++-
>   2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
> index 27158436f322..f35c915566e3 100644
> --- a/arch/x86/include/asm/intel-family.h
> +++ b/arch/x86/include/asm/intel-family.h
> @@ -119,6 +119,7 @@
>   
>   #define INTEL_FAM6_ATOM_SILVERMONT	0x37 /* Bay Trail, Valleyview */
>   #define INTEL_FAM6_ATOM_SILVERMONT_D	0x4D /* Avaton, Rangely */
> +#define INTEL_FAM6_ATOM_SILVERMONT_X3	0x5D /* X3-C3000 based on Silvermont */


Please submit a separate patch if you want to add a new CPU ID. Also, 
the comments should be platform code name, not the model.

AFAIK, Atom X3 should be SoFIA which is for mobile phone. It's an old 
product. I don't think I enabled it in perf. I have no idea why you want 
to add it here for KVM. If you have a product and want to enable it, I 
guess you may want to enable it for perf first.

Thanks,
Kan

>   #define INTEL_FAM6_ATOM_SILVERMONT_MID	0x4A /* Merriefield */
>   
>   #define INTEL_FAM6_ATOM_AIRMONT		0x4C /* Cherry Trail, Braswell */
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 4705ad55abb5..ff9596d7112d 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -3,6 +3,7 @@
>   #define __KVM_X86_VMX_CAPS_H
>   
>   #include <asm/vmx.h>
> +#include <asm/cpu_device_id.h>
>   
>   #include "lapic.h"
>   
> @@ -376,6 +377,21 @@ static inline bool vmx_pt_mode_is_host_guest(void)
>   	return pt_mode == PT_MODE_HOST_GUEST;
>   }
>   
> +static const struct x86_cpu_id lbr_select_shared_cpu[] = {
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_MID, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_D, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT_X3, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT_MID, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_GOLDMONT_PLUS, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EP, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_G, NULL),
> +	X86_MATCH_INTEL_FAM6_MODEL(NEHALEM_EX, NULL),
> +	{}
> +};
> +
>   static inline u64 vmx_get_perf_capabilities(void)
>   {
>   	u64 perf_cap = 0;
> @@ -383,7 +399,8 @@ static inline u64 vmx_get_perf_capabilities(void)
>   	if (boot_cpu_has(X86_FEATURE_PDCM))
>   		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
>   
> -	perf_cap &= PMU_CAP_LBR_FMT;
> +	if (!x86_match_cpu(lbr_select_shared_cpu))
> +		perf_cap &= PMU_CAP_LBR_FMT;
>   
>   	/*
>   	 * Since counters are virtualized, KVM would support full
> 
