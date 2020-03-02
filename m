Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B07661764E7
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 21:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgCBU1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 15:27:20 -0500
Received: from thoth.sbs.de ([192.35.17.2]:37739 "EHLO thoth.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBU1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 15:27:20 -0500
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by thoth.sbs.de (8.15.2/8.15.2) with ESMTPS id 022KQsmq031508
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 2 Mar 2020 21:26:54 +0100
Received: from [139.25.68.37] ([139.25.68.37])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 022KQrZk021128;
        Mon, 2 Mar 2020 21:26:53 +0100
Subject: Re: [PATCH 1/6] KVM: x86: Fix tracing of CPUID.function when function
 is out-of-range
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-2-sean.j.christopherson@intel.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <188dc96a-6a3b-4021-061a-0f11cbb9f177@siemens.com>
Date:   Mon, 2 Mar 2020 21:26:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302195736.24777-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.03.20 20:57, Sean Christopherson wrote:
> Rework kvm_cpuid() to query entry->function when adjusting the output
> values so that the original function (in the aptly named "function") is
> preserved for tracing.  This fixes a bug where trace_kvm_cpuid() will
> trace the max function for a range instead of the requested function if
> the requested function is out-of-range and an entry for the max function
> exists.
> 
> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH")
> Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/cpuid.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index b1c469446b07..6be012937eba 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -997,12 +997,12 @@ static bool cpuid_function_in_range(struct kvm_vcpu *vcpu, u32 function)
>   	return max && function <= max->eax;
>   }
>   
> +/* Returns true if the requested leaf/function exists in guest CPUID. */
>   bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   	       u32 *ecx, u32 *edx, bool check_limit)
>   {
> -	u32 function = *eax, index = *ecx;
> +	const u32 function = *eax, index = *ecx;
>   	struct kvm_cpuid_entry2 *entry;
> -	struct kvm_cpuid_entry2 *max;
>   	bool found;
>   
>   	entry = kvm_find_cpuid_entry(vcpu, function, index);
> @@ -1015,18 +1015,17 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>   	 */
>   	if (!entry && check_limit && !guest_cpuid_is_amd(vcpu) &&
>   	    !cpuid_function_in_range(vcpu, function)) {
> -		max = kvm_find_cpuid_entry(vcpu, 0, 0);
> -		if (max) {
> -			function = max->eax;
> -			entry = kvm_find_cpuid_entry(vcpu, function, index);
> -		}
> +		entry = kvm_find_cpuid_entry(vcpu, 0, 0);
> +		if (entry)
> +			entry = kvm_find_cpuid_entry(vcpu, entry->eax, index);
>   	}
>   	if (entry) {
>   		*eax = entry->eax;
>   		*ebx = entry->ebx;
>   		*ecx = entry->ecx;
>   		*edx = entry->edx;
> -		if (function == 7 && index == 0) {
> +
> +		if (entry->function == 7 && index == 0) {
>   			u64 data;
>   		        if (!__kvm_get_msr(vcpu, MSR_IA32_TSX_CTRL, &data, true) &&
>   			    (data & TSX_CTRL_CPUID_CLEAR))
> 

What about the !entry case below this? It was impacted by the function 
capping so far, not it's no longer.

Jan

-- 
Siemens AG, Corporate Technology, CT RDA IOT SES-DE
Corporate Competence Center Embedded Linux
