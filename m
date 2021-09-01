Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F043FE604
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbhIAXQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhIAXQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 19:16:41 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC72C061575
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 16:15:44 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k17so56912pls.0
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 16:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uLkRX3S7HGOH3GdjbZJv+B4Lvvu9s6EgNeW/1aZYJLQ=;
        b=RN3BnZBwO96riciijRXqXoQFBTBrohC3wUD7MTVF1WCmDe3w4DQravBqkmmdjFODBP
         s74FrqxTc7Zq5rmhv64juzrZcIWCB75JkO78J1my/hCcXt3A9XbXdgL0GQXOT7jRd57M
         MIB8CTKEQBSNl7ej2ckj28Kaf0cFmsy9eOK7qgYS87ccMLERmzf95AI5kI+YfgtblSaK
         Uspzks0jpCtsy4MVf51MU3hHPe2jcKkVMwCpny4qKYdXQM97iHzSOqFOnaA8Ir9IGNML
         URO4db0po9HRciSzH0Yn15NC+0ugIVKxjUE9YnkQsMgHq/DJwDa5q5U1FubuMQtnfhJS
         y5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uLkRX3S7HGOH3GdjbZJv+B4Lvvu9s6EgNeW/1aZYJLQ=;
        b=iq9YTCZ/OpCdECOIezoAaAPilSYSJlPg/MVEmDMuHzrRjs3GCAGqf+OObK/5KG9gh6
         NdCIkDqG5OejnOa9u8/X2M1d3ONZyWfv5xRj7nAxGzx3Yy0E4Vn4yo7ibRigpjARYPKA
         b4XmU5ud6m69qcSIMAzPU0CrLtBAx9sUa4VkUnU9avBqC5Kf9f8+ufsJDX1i/X8QpnJc
         xTw57Xm8U57a9KgYUV+nTjxgRyMqu08XRsohbwNxlXmm08Rm2S6KoMmgaMLX5rNP0P4B
         vQsXmlrr9bG8XzeBi7ahvAA/el6pNwinFtpWQ1oJveA3glfuIE1rUDo2QUudAlM4DydZ
         LQYA==
X-Gm-Message-State: AOAM530i0h2+j4Y+ODd2SUsjc6TJtFKBC3IJUYA9Ba83ciUa6f/JKchi
        02JaI4FEOa19qY2+phj8Wc0Uug==
X-Google-Smtp-Source: ABdhPJwqLGVyEByKojljzYoFCXPfkkHvZPBB5tyavPSMOTWdQ8nggbgYu+Blphdrk3MKgt0ElJwjfg==
X-Received: by 2002:a17:90a:49:: with SMTP id 9mr276332pjb.80.1630538143364;
        Wed, 01 Sep 2021 16:15:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i7sm35421pjm.55.2021.09.01.16.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:15:42 -0700 (PDT)
Date:   Wed, 1 Sep 2021 23:15:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, David Matlack <dmatlack@google.com>,
        peterx@redhat.com
Subject: Re: [PATCH 08/16] KVM: MMU: change handle_abnormal_pfn() arguments
 to kvm_page_fault
Message-ID: <YTAJm7c1a37N4adR@google.com>
References: <20210807134936.3083984-1-pbonzini@redhat.com>
 <20210807134936.3083984-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210807134936.3083984-9-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Aug 07, 2021, Paolo Bonzini wrote:
> Pass struct kvm_page_fault to handle_abnormal_pfn() instead of
> extracting the arguments from the struct.
> 
> Suggested-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 17 ++++++++---------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a6366f1c4197..cec59ac2e1cd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3024,18 +3024,18 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
>  	return -EFAULT;
>  }
>  
> -static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
> -				kvm_pfn_t pfn, unsigned int access,
> -				int *ret_val)
> +static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
> +				unsigned int access, int *ret_val)
>  {
>  	/* The pfn is invalid, report the error! */
> -	if (unlikely(is_error_pfn(pfn))) {
> -		*ret_val = kvm_handle_bad_page(vcpu, gfn, pfn);
> +	if (unlikely(is_error_pfn(fault->pfn))) {
> +		*ret_val = kvm_handle_bad_page(vcpu, fault->gfn, fault->pfn);
>  		return true;
>  	}
>  
> -	if (unlikely(is_noslot_pfn(pfn))) {
> -		vcpu_cache_mmio_info(vcpu, gva, gfn,
> +	if (unlikely(is_noslot_pfn(fault->pfn))) {
> +		gva_t gva = fault->is_tdp ? 0 : fault->addr;

Checkpatch wants a newline.  I'm also surprised you didn't abuse bitwise math:

		gva_t gva = fault->addr & ((u64)fault->is_tdp - 1);

I am _not_ suggesting you actually do that ;-)

> +		vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
>  				     access & shadow_mmio_access_mask);
>  		/*
>  		 * If MMIO caching is disabled, emulate immediately without
