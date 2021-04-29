Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87C3C36ED83
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 17:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240703AbhD2PkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 11:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233420AbhD2PkB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 11:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619710753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rl0f9PRkVEDvRlQejGvRFrQLs2o8eTr8cTwBM5oiXWk=;
        b=GqoijODNlqgjtKCaj72/5klTg06/6zs01k8MhYH6wI8oI6sLlcEtNSCmwTUIhWJj/pW119
        QrWlEx6oRrDE4PWwwOMkW8Ox7/YMKsuTdi/zs8Ufh+0n7MzLir33kiuSlC67KoQ3b7aVzB
        z8eVYLBH53n/Y7AnSgt7AckTS5+z0tk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-EZEgM4omPtelTqKnxnbXhQ-1; Thu, 29 Apr 2021 11:39:11 -0400
X-MC-Unique: EZEgM4omPtelTqKnxnbXhQ-1
Received: by mail-ej1-f72.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so13616049ejz.5
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 08:39:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rl0f9PRkVEDvRlQejGvRFrQLs2o8eTr8cTwBM5oiXWk=;
        b=qz2Jc9EsV+Ydkl5n9hx7ZAA9sLmO6VyDZHJWD+q/xZCMaVGONcyeCG4nrIERX0+fr2
         DJfnuoYcHU32dHV8Xj6sYw6FRo/mLa06AtjDCg2/PvbcamXzEtDE/P7IM9Y4o3O5JmAc
         f8FEYejpHhmdBw0KMk31u7KgPk5u6L5RpbzQpuBewQa6iMH48chPnbv88ZN4dGwpelz2
         E3QnG1ex2hloU0DKfKoiYotXrahWZoUpH0kCTawyf7lfvkcyE/BevDisdxU5Cc7SbWmw
         6o8YiBNOmw7eCmc4cX3VpRhEh48wVz5d7IfiJhjMbvkXthTfnQiGBbDwffHkvF1lBn1/
         xS9Q==
X-Gm-Message-State: AOAM530Z12wVntSHIvJE4JO3Hkn/PoICjcgqDFW6pJ4hQ/lNPo+xiabt
        UNtrUfCPVk+DzcSLV9ySB2cVzf4JdX5Mre5mjTBqZwMjY548tiQIXlSjDYt0rVwAm/MzKJ4dMYM
        mkJFtu34IJwZe
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr436425eja.377.1619710750279;
        Thu, 29 Apr 2021 08:39:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx21A1YlMpANQCE1KAtbp+/8NxVNsvztzUMv7CV14C7LXxrq4+7wsAmPNPrSX2GIB7Ydmvr+w==
X-Received: by 2002:a17:906:2287:: with SMTP id p7mr436412eja.377.1619710750060;
        Thu, 29 Apr 2021 08:39:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i19sm162439ejd.114.2021.04.29.08.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 08:39:09 -0700 (PDT)
Subject: Re: Subject: [RFC PATCH] kvm/x86: Fix 'lpages' kvm stat for TDM MMU
To:     "Shahin, Md Shahadat Hossain" <shahinmd@amazon.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Szczepanek, Bartosz" <bsz@amazon.de>,
        "seanjc@google.com" <seanjc@google.com>,
        "bgardon@google.com" <bgardon@google.com>
References: <1619700409955.15104@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dae9be92-00ab-2a2d-822b-e15abea6aeb6@redhat.com>
Date:   Thu, 29 Apr 2021 17:39:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1619700409955.15104@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 14:46, Shahin, Md Shahadat Hossain wrote:
> Large pages not being created properly may result in increased memory
> access time. The 'lpages' kvm stat used to keep track of the current
> number of large pages in the system, but with TDP MMU enabled the stat
> is not showing the correct number.
> 
> This patch extends the lpages counter to cover the TDP case.
> 
> Signed-off-by: Md Shahadat Hossain Shahin <shahinmd@amazon.de>
> Cc: Bartosz Szczepanek <bsz@amazon.de>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 34207b874886..1e2a3cb33568 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -425,6 +425,12 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   
>   	if (old_spte == new_spte)
>   		return;
> +	
> +	if (is_large_pte(old_spte))
> +		--kvm->stat.lpages;
> +	
> +	if (is_large_pte(new_spte))
> +		++kvm->stat.lpages;
>   
>   	trace_kvm_tdp_mmu_spte_changed(as_id, gfn, level, old_spte, new_spte);
>   
> 

Queued, thanks.

Paolo

