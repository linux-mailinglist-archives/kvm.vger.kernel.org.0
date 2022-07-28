Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273F75846F4
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiG1UPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiG1UPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:15:54 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88553747B4;
        Thu, 28 Jul 2022 13:15:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id o13so3571825edc.0;
        Thu, 28 Jul 2022 13:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4S0mMfGnyRuF8ikfL4mmZ+1Q0MllTpdpEE+oMIn4K8E=;
        b=dT/6fWpwg48FRzDzpqVPQxXaBbgwSGT8VwBraEBdMxBeaczJbJu9y7pfI7+PashNtb
         pCGfS+v70b3pRzAKaRAD+6QFT7edmfRhUHAU058uqh2/FtUgNzyFGCaTjgBo9fSHP6oP
         uihGzY8NdeFO8c/90CADpUvSG5W8UQ5eZU/icVoNAat69Vzf3L/iRCumozEHRU3kBaBo
         dmZb7B9Myr5xPfW6tS5wKMg8M/tHzTdG7b3OUZTNEPzRXx1gLtGo/Q981KVoc8mx5ek5
         S8qVDa2O1yYDGJcxovoOWlBwTbz9Cxo8bvmUVpfzN1rjjQYJUEySQPFlfoDHg/G6groY
         zTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4S0mMfGnyRuF8ikfL4mmZ+1Q0MllTpdpEE+oMIn4K8E=;
        b=yqri/O0pZzDZZ+2SZhO7aFa4Uu8puHLMAUi71f+4ceTBvxwDiCBfZGPAqiP/JVgD9r
         tl4RuXPDxxoxxL5fyP1B4CcyxYV93RagXj7GndOco5G08HvTZUDB1nPih9KH8ecXzOpe
         i4e7udAxgwqoTG/9ho13cl8+LUjeUIO74wqXkmgUrY2bgSEFlrhMbD16KnaQUcd7gDny
         m6WFQOmeDVJLPdhECs3rIESBu3HIubcEqNLUVPjJCyAGaLDDTbtkis7NE8j6/Y+RvHeI
         Q992R2CNKyPGnBrfMgHaC11ZFlkmZU4aKwkrsg2BVdVfVw1buoXgO5NGmwnrK6Syyjl1
         JZDQ==
X-Gm-Message-State: AJIora8D0tQsM+STEUgAse5rcECMf17Lodt+e//kfTvbPVr/h1bOXy9q
        EZv3LBa0hjhFFY1A1jpfgJDWj3/O6exOwg==
X-Google-Smtp-Source: AGRyM1sbY7Ahfp0Mwc3Ffsv9jEuRczlu/jFRcxM9zgCiXhi8y4VQ+EMAe5MjHrvXPhzcYQG+Ij24aA==
X-Received: by 2002:a05:6402:5412:b0:435:5997:ccb5 with SMTP id ev18-20020a056402541200b004355997ccb5mr562565edb.167.1659039351013;
        Thu, 28 Jul 2022 13:15:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id r9-20020a17090609c900b0072f5fa11d19sm765176eje.202.2022.07.28.13.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 13:15:50 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <31ab1931-7737-2052-398b-0bb49281e561@redhat.com>
Date:   Thu, 28 Jul 2022 22:15:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Properly account NX huge page
 workaround for nonpaging MMUs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-3-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220723012325.1715714-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/22 03:23, Sean Christopherson wrote:
> +
> +	/*
> +	 * Note, enforcing the NX huge page mitigation for nonpaging MMUs
> +	 * (shadow paging, CR0.PG=0 in the guest) is completely unnecessary.
> +	 * The guest doesn't have any page tables to abuse and is guaranteed
> +	 * to switch to a different MMU when CR0.PG is toggled on (may not
> +	 * always be guaranteed when KVM is using TDP).  See also make_spte().
> +	 */
>   	const bool nx_huge_page_workaround_enabled;
>   
>   	/*
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..9f3e5af088a5 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -147,6 +147,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   	if (!prefetch)
>   		spte |= spte_shadow_accessed_mask(spte);
>   
> +	/*
> +	 * For simplicity, enforce the NX huge page mitigation even if not
> +	 * strictly necessary.  KVM could ignore if the mitigation if paging is
> +	 * disabled in the guest, but KVM would then have to ensure a new MMU
> +	 * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
> +	 * and that's a net negative for performance when TDP is enabled.  KVM
> +	 * could ignore the mitigation if TDP is disabled and CR0.PG=0, as KVM
> +	 * will always switch to a new MMU if paging is enabled in the guest,
> +	 * but that adds complexity just to optimize a mode that is anything
> +	 * but performance critical.

Why even separate the two comments?  I think they both belong in 
make_spte().

Paolo
