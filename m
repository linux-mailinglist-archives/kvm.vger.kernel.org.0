Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008BF512094
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 20:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243291AbiD0Q2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 12:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242939AbiD0Q2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 12:28:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD56059BA2
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651076547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++UuqgJt9YgxlZT4xRTgU+kEGmMRwOlAsDaCv/rlgcE=;
        b=HzCV0ML2XAyt9nhL5JsimfSCN4ib1mW1RT13vMOiM0a2Xx1sZx+BQnNnqg6JPkWuK/Thz6
        3yZdUPIwVF4hhBTx80BnMIM5jRbS70AmNS5x1fqT7HaNdKfamOqs2YVpk4S6vgjld/CeD/
        vK+oJEdgdyJqmKTtLeEB8wcG4ew3dLc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-aGDsow_fMCenaWNJ4ONIFg-1; Wed, 27 Apr 2022 12:19:13 -0400
X-MC-Unique: aGDsow_fMCenaWNJ4ONIFg-1
Received: by mail-ed1-f69.google.com with SMTP id dn26-20020a05640222fa00b00425e4b8efa9so1277189edb.1
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 09:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=++UuqgJt9YgxlZT4xRTgU+kEGmMRwOlAsDaCv/rlgcE=;
        b=ZmapECpIsQhh7EgGqfW74xO2iS+KbTcFp0mKwAvij0ZgfVMIRsEIualLGwSsNPtIIe
         pCDd9FcONdhzv7RTlk4wGVHYDKCsZ5l8zCljL+77fTPVhYl//AKSM9irgr72YKNh31e9
         +ANXY9ksmws44cHNS68T4RQPNfxu2V9iagSPWv++eMbyBoeIXzPRKoVulgp+8gu0W8qw
         /hv/7ITUJaXFGyOwsW20w0vatgCq6ekE+3DIIBStiSbysTt8qhWc9/hTj3IzPpeKhD4Q
         dqOHiiIAhUnXHKICGSCEbL8QgQzlk9CaQHtD5EQOwPEIZet/ppr6JdOV6lwW4vOE0ReC
         G2xg==
X-Gm-Message-State: AOAM532enoy9Deq/k/jIBvxv8yWvq663x2iW9S6ajBpcsjOqC9XLPsr2
        CWnAkThaRGRK1rs/ObA9mpl9PdJt/xzmm2qmuJAFgXBlxAqRqRwMv/ZOTkCxbWxsw2ABO5Ns5AR
        O1bUPM1cid8v2
X-Received: by 2002:a05:6402:400b:b0:425:f59a:c221 with SMTP id d11-20020a056402400b00b00425f59ac221mr13331404eda.307.1651076352253;
        Wed, 27 Apr 2022 09:19:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPfGEmBUJ67ZizyPHjPOEfag4PaOgCK7brbyiJjf81tHh9zOvEYRKi3rSxDx1hdZ20vjrEHg==
X-Received: by 2002:a05:6402:400b:b0:425:f59a:c221 with SMTP id d11-20020a056402400b00b00425f59ac221mr13331379eda.307.1651076352033;
        Wed, 27 Apr 2022 09:19:12 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id cn27-20020a0564020cbb00b00418b0c7fbbfsm8594619edb.32.2022.04.27.09.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 09:19:11 -0700 (PDT)
Message-ID: <5d9b9296-f116-0661-d1c2-6eb7d132e4f0@redhat.com>
Date:   Wed, 27 Apr 2022 18:19:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH MANUALSEL 5.10 3/4] KVM: x86/mmu: avoid NULL-pointer
 dereference on page freeing bugs
Content-Language: en-US
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
References: <20220427155435.19554-1-sashal@kernel.org>
 <20220427155435.19554-3-sashal@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427155435.19554-3-sashal@kernel.org>
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
> index 99ea1ec12ffe..70ef5b542681 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3140,6 +3140,8 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>   		return;
>   
>   	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
> +	if (WARN_ON(!sp))
> +		return;
>   
>   	if (kvm_mmu_put_root(kvm, sp)) {
>   		if (sp->tdp_mmu_page)

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

