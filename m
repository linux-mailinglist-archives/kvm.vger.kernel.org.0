Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184A633384C
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 10:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhCJJIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 04:08:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232832AbhCJJIK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Mar 2021 04:08:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615367289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onwH43buJY+4pRwy25T93B+uL+ekLSAj/zUQnTgwwtE=;
        b=XlrA8a0pURjWErJOCnqLNgBEEAYgQw3co/8Z436O2AoFILMpJEbKUWlGCZdBvXQIEy91+e
        s5dlQb10Re3SKMe/6Xla9T0rtKtaDanFqggFAJn2AgOqAiDab0z91dq8dxSHDBY2IhJC8C
        a/ulzQLZlloO4+tCYvs3ThYOpyO9HIk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-mzLVel28M5O4fkaB9F_exQ-1; Wed, 10 Mar 2021 04:08:08 -0500
X-MC-Unique: mzLVel28M5O4fkaB9F_exQ-1
Received: by mail-wm1-f70.google.com with SMTP id f9so2393678wml.0
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 01:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=onwH43buJY+4pRwy25T93B+uL+ekLSAj/zUQnTgwwtE=;
        b=aOvqxb/tZl+MukgJGbkgWLGgxGnhc0/Ya5qlYFlM7oxvEOkzJ2uXoN0eTRd8YFlHD3
         n8WwNYAfyI2ImX/mj5eirxq8wOQCj0je8RQwdjMs0KrjkH0HzhUR9qgPtYLRqKOfIBrA
         ZzGnIl0zvFsiyFK6N+cg1fXpRleNZdnjCyvR4FhVyZp9YMHVqiPrRs9xBs09eRVZ+vVs
         pJZYIfa3qS+r+SNr/NgJ+/79H6aj82Qth33/aS2TxVXwpFoBiYGo9G26ht//9O88Et0B
         8/GwEXgmlq5iYIZGGCLO4t2pLDnYrXOzgOJppZF0b3hrffKsDxSK2+BjYzHyjMfGY1KJ
         MHlA==
X-Gm-Message-State: AOAM532WL3ldPXwdNqeVkdkrTtVkLd0UGpQ2KZQIJoQLFlvSewy2aDS5
        CGNAbaXOUVzFWTwBI15FfhSQyKI8N41F/UsyEHDrMZ2VMQU1AQKZSTztVC9kioWXrgfdg+rNkcX
        CtfII8HQI5cYA
X-Received: by 2002:a05:600c:22d9:: with SMTP id 25mr2273598wmg.108.1615367287035;
        Wed, 10 Mar 2021 01:08:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxramH2RbQZZh5ShQMu5/BRgsJl/CJyoOFHUKPgMzohma+8iv89kZpKLk/HpIKp0RgVaXnbw==
X-Received: by 2002:a05:600c:22d9:: with SMTP id 25mr2273576wmg.108.1615367286880;
        Wed, 10 Mar 2021 01:08:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n66sm7934392wmn.25.2021.03.10.01.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Mar 2021 01:08:06 -0800 (PST)
Subject: Re: [PATCH] KVM: x86/mmu: Skip !MMU-present SPTEs when removing SP in
 exclusive mode
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20210310003029.1250571-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <07cf7833-c74a-9ae0-6895-d74708b97f68@redhat.com>
Date:   Wed, 10 Mar 2021 10:08:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310003029.1250571-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/21 01:30, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 50ef757c5586..f0c99fa04ef2 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -323,7 +323,18 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt,
>   				cpu_relax();
>   			}
>   		} else {
> +			/*
> +			 * If the SPTE is not MMU-present, there is no backing
> +			 * page associated with the SPTE and so no side effects
> +			 * that need to be recorded, and exclusive ownership of
> +			 * mmu_lock ensures the SPTE can't be made present.
> +			 * Note, zapping MMIO SPTEs is also unnecessary as they
> +			 * are guarded by the memslots generation, not by being
> +			 * unreachable.
> +			 */
>   			old_child_spte = READ_ONCE(*sptep);
> +			if (!is_shadow_present_pte(old_child_spte))
> +				continue;
>   
>   			/*
>   			 * Marking the SPTE as a removed SPTE is not

Ben, do you plan to make this path take mmu_lock for read?  If so, this 
wouldn't be too useful IIUC.

Paolo

