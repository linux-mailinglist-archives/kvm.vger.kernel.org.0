Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7274C511E6F
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242532AbiD0Q1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243318AbiD0Q0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:26:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A133D264F90
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsca3nN9F0L3L7CF4f4/JIiLe+nDncGsHBTvE+SQpns=;
        b=Nh6Dhltmu0r/XkRi+yKiSHncdF3ktBBthQizASkd9Leo34UPb+lkTiZVFQIgsM/71UjB2m
        qbI+q+nV8gGG3MiJXsXI3gP6Qrl1M2rjtcTGnb3RILKzLPtYG2F7rClpdJZcdu00rVltoH
        aRZ3VYMziPowuxVW50v/ujUr+L5npMQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-488-0uX0HV6kMPuiHQeLSK74Tw-1; Wed, 27 Apr 2022 12:20:43 -0400
X-MC-Unique: 0uX0HV6kMPuiHQeLSK74Tw-1
Received: by mail-ed1-f70.google.com with SMTP id ch28-20020a0564021bdc00b00425cb227ab4so1275680edb.4
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rsca3nN9F0L3L7CF4f4/JIiLe+nDncGsHBTvE+SQpns=;
        b=EkRixfzae+cpXTGGD849bnkgNHW6Zwk7PbiWS5M3MVV72An6omT9L3aG7YRMO4gVfz
         wDSbY9LR6UgWsTVvrZIluRbX7VmmybjlpEzey7EIhL4GC3+ou3epDZjHdkO1TDv0Ft8x
         v2ltpse0imfIE8mJSwqgpxNalUjNFTN76h4Nu//8isz6FJiAAaPcNK+ajtyr/9vjrEok
         bjWAV1DCVralBWiJZFmEgqeJlijCgyknyOaJ0hukmI3YnHZoRhs/hVVL+1dgo3ikemAX
         aGotEiOvv8MVN5pUaLUKSo/kBQ2R0dgoqx7WdBUcIfsccrw7l47rvFt/+d4KAEvUAYtn
         JCVA==
X-Gm-Message-State: AOAM532miA+EHOap+PxBom0qBsN2lz8eaXr9P/Sfq1cpETkmwhGXckdO
        5rUXC43RAYESkIgZfCT1DfzGo/WpVT+rjE/A0Ri64l2NEvhI9rL5V1bfbeslNBSRDBRU020LLRz
        PGd4SMVXwb1o2
X-Received: by 2002:a05:6402:1a42:b0:424:20bb:3e37 with SMTP id bf2-20020a0564021a4200b0042420bb3e37mr31381791edb.29.1651076441833;
        Wed, 27 Apr 2022 09:20:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzy79Ti+40bhX02i6AE/YohVsvCl0+6reMKemh3Hg1j7DTh1D/TMmfHWFR50FWzqoAwUbxSgA==
X-Received: by 2002:a05:6402:1a42:b0:424:20bb:3e37 with SMTP id bf2-20020a0564021a4200b0042420bb3e37mr31381758edb.29.1651076441571;
        Wed, 27 Apr 2022 09:20:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id s12-20020a1709062ecc00b006e8558c9a5csm7003572eji.94.2022.04.27.09.20.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:20:40 -0700 (PDT)
Message-ID: <143ede94-5231-de84-9e8a-97a5f9ca8563@redhat.com>
Date:   Wed, 27 Apr 2022 18:20:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.15 6/7] KVM: x86/mmu: avoid NULL-pointer
 dereference on page freeing bugs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155431.19458-1-sashal@kernel.org>
 <20220427155431.19458-6-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155431.19458-6-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 17:54, Sasha Levin wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> [ Upstream commit 9191b8f0745e63edf519e4a54a4aaae1d3d46fbd ]
> 
> WARN and bail if KVM attempts to free a root that isn't backed by a shadow
> page.  KVM allocates a bare page for "special" roots, e.g. when using PAE
> paging or shadowing 2/3/4-level page tables with 4/5-level, and so root_hpa
> will be valid but won't be backed by a shadow page.  It's all too easy to
> blindly call mmu_free_root_page() on root_hpa, be nice and WARN instead of
> crashing KVM and possibly the kernel.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 34e828badc51..806f9d42bcce 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3314,6 +3314,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>   		return;
>   
>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>   
>   	if (is_tdp_mmu_page(sp))
>   		kvm_tdp_mmu_put_root(kvm, sp, false);

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

