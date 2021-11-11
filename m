Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53744D7A5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 14:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhKKN7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 08:59:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhKKN7I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 08:59:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636638978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NrpakPP1mY1G8r2i5dS6QzcUMupraSda7zqzU1s+s/0=;
        b=eg8F+JI6R1dJ/e4+r+wB2de4xt5ZRSt5W2e2/PR28tbnRrkKRoHsa46vraW2gdzxbbt2xY
        KWz0f+T7JrATrK5n5t0fBtlWyfyDo4fU6g7QKlvKHEJu5Uj6rIhbQnF7YE8LQUN9T+9Ltl
        wiR3NBgMTnspct6GFkJfvz3NX+gQxNQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-LL3PZQ15PiyATkd9EU48aA-1; Thu, 11 Nov 2021 08:56:07 -0500
X-MC-Unique: LL3PZQ15PiyATkd9EU48aA-1
Received: by mail-ed1-f71.google.com with SMTP id w13-20020a05640234cd00b003e2fde5ff8aso5435261edc.14
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 05:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NrpakPP1mY1G8r2i5dS6QzcUMupraSda7zqzU1s+s/0=;
        b=ApnGLUvSVY0RH3qUh/n4ZlVXg0BUWXhmxWuEE5olSAkzbeFBaCoahhe7CE0OZngpoh
         L8/5k0zMXQtKoCtGC0ZqdXRfPMw2du2GeyPZV0JqU4lEFupJ3SE3p+2m4s27GCLi7ww7
         DE/OxFZH8vu/ugVWvENxDyGvDfiwaFlKdtJhX+lCl/tnZyMLrKtLl0iG//AxYjSgsPKp
         +bnW0a61B/gKN/7ybqaSBrD9TSrgaAtu/ge11mneJTtyTrl68Zh2f0rEBJFGSz4HxzKq
         5xiqVUV1KeNjTo4ZBXoo7fOWBG1Io6iwInIHx7E0OyN1Tp3NjzrtxuYo74KuMPEU1lkv
         GQXw==
X-Gm-Message-State: AOAM533aCpVvo+fLH20Y9yRdhLATvMnBJW72rT8RCxtbCXEGRDu85e22
        2jQFDRg6dQz2k7sb42dm6un0WTdibTs7oS+LKXZB+d/IjSSEomyWOpaXuJI5mlub2xJGXfIDKVX
        GJX0LnAPQMXRs
X-Received: by 2002:a17:907:1687:: with SMTP id hc7mr9530307ejc.232.1636638966248;
        Thu, 11 Nov 2021 05:56:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzX7HNPnRaZOIbVUD3tdZtrVd1c1/ljustC2Z6YzVjk057v5IsDHn+43SgHt6OJsVTF0zdqA==
X-Received: by 2002:a17:907:1687:: with SMTP id hc7mr9530276ejc.232.1636638966048;
        Thu, 11 Nov 2021 05:56:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id hs8sm1447154ejc.53.2021.11.11.05.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 05:56:05 -0800 (PST)
Message-ID: <a591894d-08a1-f681-aa39-a91ee36b1ed7@redhat.com>
Date:   Thu, 11 Nov 2021 14:56:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] kvm: mmu: Use fast PF path for access tracking of huge
 pages when possible
Content-Language: en-US
To:     Junaid Shahid <junaids@google.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, bgardon@google.com
References: <20211104003359.2201967-1-junaids@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211104003359.2201967-1-junaids@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/4/21 01:33, Junaid Shahid wrote:
> The fast page fault path bails out on write faults to huge pages in
> order to accommodate dirty logging. This change adds a check to do that
> only when dirty logging is actually enabled, so that access tracking for
> huge pages can still use the fast path for write faults in the common
> case.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---
> v2:
>   - Removed a stale comment
> 
>   arch/x86/kvm/mmu/mmu.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 354d2ca92df4..04c00c34517e 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3191,17 +3191,17 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   			new_spte |= PT_WRITABLE_MASK;
>   
>   			/*
> -			 * Do not fix write-permission on the large spte.  Since
> -			 * we only dirty the first page into the dirty-bitmap in
> +			 * Do not fix write-permission on the large spte when
> +			 * dirty logging is enabled. Since we only dirty the
> +			 * first page into the dirty-bitmap in
>   			 * fast_pf_fix_direct_spte(), other pages are missed
>   			 * if its slot has dirty logging enabled.
>   			 *
>   			 * Instead, we let the slow page fault path create a
>   			 * normal spte to fix the access.
> -			 *
> -			 * See the comments in kvm_arch_commit_memory_region().
>   			 */
> -			if (sp->role.level > PG_LEVEL_4K)
> +			if (sp->role.level > PG_LEVEL_4K &&
> +			    kvm_slot_dirty_track_enabled(fault->slot))
>   				break;
>   		}
>   
> 

Queued, thanks.

Paolo

