Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F250C1FC21
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 23:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfEOVRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 17:17:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34104 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfEOVRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 17:17:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id j187so5582932wma.1
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 14:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BabFqaQpyxbmy413WqiCyauMZ8ra7wgMzOR+CdjgZ58=;
        b=d9VGkzwTWDwhG+tAtBi2f/1AqQ0L1atyjxtTUVJOVchVOYIdkBi2JO36lEOYSWrTYP
         0NBjex2AeM0qxWP75cxf3BqPyBEneaM13Fq4YfqJzyn7kKkVErnBJYJMps8smnplU453
         VRmRdLtf0Ed45U7hNP8leYEewnKfNKPZT6RH48fufYDOArTWc1OIkiytWPyPVSjd03sB
         SgLbK4dOnu3Rv+cWgmVn1CQ5Mkeog49spWKTiLYRtjuwPKDLTAMrTimxEV297LsIdiId
         7qcYlOxWIt9pxqVdGZWoyBoB+ChP+tH7obo3mLzEn5W4dBMAEgyKXkQAtQfaNkThLjb/
         WkEg==
X-Gm-Message-State: APjAAAXfONYGHh/rrqts1Ly7ld05Uq7eyVy2VEAZQjcneMQmqSQQ5TpY
        LfQGOFRdl2F2v7QWX9Bd7EZGxrHumzo=
X-Google-Smtp-Source: APXvYqwm9BE8YyCxtmvi8xDTtvo9Scw+tJomcAtaHTzw2CX/Pb9WkZrpsZoth8k1T2JJGfXUkhkRkg==
X-Received: by 2002:a1c:254:: with SMTP id 81mr2876286wmc.151.1557955017515;
        Wed, 15 May 2019 14:16:57 -0700 (PDT)
Received: from [172.10.18.228] (24-113-124-115.wavecable.com. [24.113.124.115])
        by smtp.gmail.com with ESMTPSA id s11sm5254576wrb.71.2019.05.15.14.16.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 14:16:56 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Fix L1TF mitigation for shadow MMU
To:     Kai Huang <kai.huang@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, junaids@google.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, kai.huang@intel.com
References: <20190503084025.24549-1-kai.huang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b3bca1c1-ed7d-6027-1e91-12b6a243c2c7@redhat.com>
Date:   Wed, 15 May 2019 23:16:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503084025.24549-1-kai.huang@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 10:40, Kai Huang wrote:
> Currently KVM sets 5 most significant bits of physical address bits
> reported by CPUID (boot_cpu_data.x86_phys_bits) for nonpresent or
> reserved bits SPTE to mitigate L1TF attack from guest when using shadow
> MMU. However for some particular Intel CPUs the physical address bits
> of internal cache is greater than physical address bits reported by
> CPUID.
> 
> Use the kernel's existing boot_cpu_data.x86_cache_bits to determine the
> five most significant bits. Doing so improves KVM's L1TF mitigation in
> the unlikely scenario that system RAM overlaps the high order bits of
> the "real" physical address space as reported by CPUID. This aligns with
> the kernel's warnings regarding L1TF mitigation, e.g. in the above
> scenario the kernel won't warn the user about lack of L1TF mitigation
> if x86_cache_bits is greater than x86_phys_bits.
> 
> Also initialize shadow_nonpresent_or_rsvd_mask explicitly to make it
> consistent with other 'shadow_{xxx}_mask', and opportunistically add a
> WARN once if KVM's L1TF mitigation cannot be applied on a system that
> is marked as being susceptible to L1TF.
> 
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> ---
> 
> This patch was splitted from old patch I sent out around 2 weeks ago:
> 
> kvm: x86: Fix several SPTE mask calculation errors caused by MKTME
> 
> After reviewing with Sean Christopherson it's better to split this out,
> since the logic in this patch is independent. And maybe this patch should
> also be into stable.
> 
> ---
>  arch/x86/kvm/mmu.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b0899f175db9..1b2380e0060f 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -511,16 +511,24 @@ static void kvm_mmu_reset_all_pte_masks(void)
>  	 * If the CPU has 46 or less physical address bits, then set an
>  	 * appropriate mask to guard against L1TF attacks. Otherwise, it is
>  	 * assumed that the CPU is not vulnerable to L1TF.
> +	 *
> +	 * Some Intel CPUs address the L1 cache using more PA bits than are
> +	 * reported by CPUID. Use the PA width of the L1 cache when possible
> +	 * to achieve more effective mitigation, e.g. if system RAM overlaps
> +	 * the most significant bits of legal physical address space.
>  	 */
> -	low_phys_bits = boot_cpu_data.x86_phys_bits;
> -	if (boot_cpu_data.x86_phys_bits <
> +	shadow_nonpresent_or_rsvd_mask = 0;
> +	low_phys_bits = boot_cpu_data.x86_cache_bits;
> +	if (boot_cpu_data.x86_cache_bits <
>  	    52 - shadow_nonpresent_or_rsvd_mask_len) {
>  		shadow_nonpresent_or_rsvd_mask =
> -			rsvd_bits(boot_cpu_data.x86_phys_bits -
> +			rsvd_bits(boot_cpu_data.x86_cache_bits -
>  				  shadow_nonpresent_or_rsvd_mask_len,
> -				  boot_cpu_data.x86_phys_bits - 1);
> +				  boot_cpu_data.x86_cache_bits - 1);
>  		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
> -	}
> +	} else
> +		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
> +
>  	shadow_nonpresent_or_rsvd_lower_gfn_mask =
>  		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
>  }
> 

Queued, thanks.

Paolo
