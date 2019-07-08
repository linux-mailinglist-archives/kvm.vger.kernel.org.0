Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E0061AE7
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 09:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfGHHHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 03:07:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:16452 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfGHHHS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 03:07:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 00:07:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,465,1557212400"; 
   d="scan'208";a="167592741"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.129.57]) ([10.238.129.57])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2019 00:07:16 -0700
Subject: Re: [PATCH 2/5] KVM: cpuid: extract do_cpuid_7_mask and support
 multiple subleafs
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190704140715.31181-1-pbonzini@redhat.com>
 <20190704140715.31181-3-pbonzini@redhat.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
Message-ID: <5af77de6-3a18-a3b9-b492-c280ac4310a1@linux.intel.com>
Date:   Mon, 8 Jul 2019 15:07:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704140715.31181-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Thank you for refining the cpuid codes especially for case 7! It looks
much clear now!

On 7/4/2019 10:07 PM, Paolo Bonzini wrote:
> CPUID function 7 has multiple subleafs.  Instead of having nested
> switch statements, move the logic to filter supported features to
> a separate function, and call it for each subleaf.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	Here you would have something like entry->eax = min(entry->eax, 1)
> 	when adding subleaf 1.
> 
>   arch/x86/kvm/cpuid.c | 128 +++++++++++++++++++++++++++----------------
>   1 file changed, 81 insertions(+), 47 deletions(-)
> 
[...]
> +
> +	switch (index) {
> +	case 0:
> +		entry->eax = 0;

Here, mark: when adding subleaf 1, change to
entry->eax = min(entry->eax, 1).

> +		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
> +		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
> +		/* TSC_ADJUST is emulated */
> +		entry->ebx |= F(TSC_ADJUST);
> +
> +		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
> +		f_la57 = entry->ecx & F(LA57);
> +		cpuid_mask(&entry->ecx, CPUID_7_ECX);
> +		/* Set LA57 based on hardware capability. */
> +		entry->ecx |= f_la57;
> +		entry->ecx |= f_umip;
> +		/* PKU is not yet implemented for shadow paging. */
> +		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
> +			entry->ecx &= ~F(PKU);
> +
> +		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
> +		cpuid_mask(&entry->edx, CPUID_7_EDX);
> +		/*
> +		 * We emulate ARCH_CAPABILITIES in software even
> +		 * if the host doesn't support it.
> +		 */
> +		entry->edx |= F(ARCH_CAPABILITIES);
> +		break;
And when adding subleaf 1, plan to add codes,

case 1:
	entry->eax |= kvm_cpuid_7_1_eax_x86_features;
	entry->ebx = entry->ecx = entry->edx =0;
	break;

What do you think?

> +	default:
> +		WARN_ON_ONCE(1);
> +		entry->eax = 0;
> +		entry->ebx = 0;
> +		entry->ecx = 0;
> +		entry->edx = 0;
> +		break;
> +	}
> +}
> +
>   static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
>   				  int *nent, int maxnent)
[...]
> +	/* function 7 has additional index. */
>   	case 7: {
> +		int i;
> +
>   		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> -		entry->eax = 0;
> -		/* Mask ebx against host capability word 9 */
> -		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
> -		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
> -		// TSC_ADJUST is emulated
> -		entry->ebx |= F(TSC_ADJUST);
> -		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
> -		f_la57 = entry->ecx & F(LA57);
> -		cpuid_mask(&entry->ecx, CPUID_7_ECX);
> -		/* Set LA57 based on hardware capability. */
> -		entry->ecx |= f_la57;
> -		entry->ecx |= f_umip;
> -		/* PKU is not yet implemented for shadow paging. */
> -		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
> -			entry->ecx &= ~F(PKU);
> -		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
> -		cpuid_mask(&entry->edx, CPUID_7_EDX);
> -		/*
> -		 * We emulate ARCH_CAPABILITIES in software even
> -		 * if the host doesn't support it.
> -		 */
> -		entry->edx |= F(ARCH_CAPABILITIES);
> +		for (i = 0; ; ) {
> +			do_cpuid_7_mask(&entry[i], i);
> +			if (i == entry->eax)
> +				break;
> +			if (*nent >= maxnent)
> +				goto out;
> +
> +			++i;
> +			do_cpuid_1_ent(&entry[i], function, i);
> +			entry[i].flags |=
> +			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> +			++*nent;
> +		}

The new logic is great and adding subleaf support would be much easier!

>   		break;
>   	}
>   	case 9:
> 

Thanks,
Jing
