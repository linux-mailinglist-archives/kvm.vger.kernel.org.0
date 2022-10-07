Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD65D5F80C8
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 00:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJGW2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 18:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJGW1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 18:27:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF04A0279
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 15:27:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t12-20020a17090a3b4c00b0020b04251529so5835423pjf.5
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 15:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XCPFyE5W3Gb2XwMJCAS90JkzDHFPydn2y1iISed8r44=;
        b=aLguLEeccD1vUU7uhdr3i3/U9eMe7mOBjh7518ewke7SfE9lKu8sLdT9lXzVyuFJaV
         P39byuRg2X+cGiI/VKOFdhFSy7jNr6FQR0/Ic+SM4o2ie//tmbZuE3Ele/i934zXgwjQ
         UuvpiBx/FR5JhmNmztWHM+r/cHTitg5Udib7Wa6YZCrzbd9zQUJc+wHBIu8lEMm/dIai
         otPrgq1gNHL3xeqyTscRD3eAtfXWj2uR3aaw9eRPVOuF+39CzFhDF3RkMFKBoVS6D/FR
         Rfe3T6X9dL5ldtqowY95oMsntlHvZpjsgk5vXDjZv6TU+OgmQKLKMac7JfRcFPgj0vUa
         PGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XCPFyE5W3Gb2XwMJCAS90JkzDHFPydn2y1iISed8r44=;
        b=PlLtNpBithVJanWKyddnbnq3oh9agxv1S0X7YziUUm4ftlcTQKMgzctGGw8mq0pIat
         tVKYEArSRpuauCAq4Zoorj+gxInkOG7LNNZsiMjWGNGjC9TBmtbZd+k1/KeE6xqOBN66
         BhkKRKHLUuJhS/EDmDTghKekkLFm6OXxJAlruQrvME3iiD3acwEMZWmmOtjBxwBH3GcL
         5dn9vhVyNBj4nmnmgzZUrdMtNcUHP9H4lFVgZmiQlU0/0J9npK07oVHMOZeZPU+YgNud
         eMmuUfnz/2H8/TwtJhNWrDxVm3W+dt7QaF68gurYR7ymVIvlL6Bxj7vGJk3NbVRsEfra
         teRw==
X-Gm-Message-State: ACrzQf3iwSuDtQqes/GAfYyzf1MKfS663VcKHdd0DU4sw6Zse7XDklkc
        8M1cWKGFU/2vkKqjoi/Czb7i8A==
X-Google-Smtp-Source: AMsMyM6BvPjzsoTtyu89YHZ6oezxGx8MxufaaLACT7Rj8Bq8M1oiuwhLIA13ukUS7jpdZJoNZ0zuBw==
X-Received: by 2002:a17:902:e5d1:b0:178:443b:3e76 with SMTP id u17-20020a170902e5d100b00178443b3e76mr6717595plf.153.1665181671533;
        Fri, 07 Oct 2022 15:27:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v29-20020aa799dd000000b0056258a3606csm2087253pfi.215.2022.10.07.15.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 15:27:50 -0700 (PDT)
Date:   Fri, 7 Oct 2022 22:27:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Advertise that the SMM_CTL MSR is not supported
Message-ID: <Y0Cn4p6DjgO2skrL@google.com>
References: <20221007221644.138355-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221007221644.138355-1-jmattson@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 07, 2022, Jim Mattson wrote:
> CPUID.80000021H:EAX[bit 9] indicates that the SMM_CTL MSR (0xc0010116)
> is not supported. This defeature can be advertised by
> KVM_GET_SUPPORTED_CPUID regardless of whether or not the host
> enumerates it.

Might be worth noting that KVM will only enumerate the bit if the host happens to
have a max extend leaf > 80000021.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2796dde06302..b748fac2ae37 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1199,8 +1199,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		 * Other defined bits are for MSRs that KVM does not expose:
>  		 *   EAX      3      SPCL, SMM page configuration lock
>  		 *   EAX      13     PCMSR, Prefetch control MSR
> +		 *
> +		 * KVM doesn't support SMM_CTL.
> +		 *   EAX       9     SMM_CTL MSR is not supported
>  		 */
>  		entry->eax &= BIT(0) | BIT(2) | BIT(6);

I don't suppose I can bribe you to add a kvm_only_cpuid_leafs entry for these? :-)

> +		entry->eax |= BIT(9);
>  		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
>  			entry->eax |= BIT(2);
>  		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
> -- 
> 2.38.0.rc1.362.ged0d419d3c-goog
> 
