Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C833B2F3D
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhFXMnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:43:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30089 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231819AbhFXMnp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 08:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624538486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ao/aik86DETd7ceeMOwWvzTcaJv+rZayOURU+D31sn8=;
        b=GjvelJK9NqzwPH+wQt4p2rrMHQ+NmPcPSNVXrH2f0EGBGBkRWu28p8uhXdnkGg+jIxxi35
        K18CZYpwAQXIXJe/qoc0AAtBS6Xqn7n7gbbZtzOsuIr22LchymDudqsIDKQkzI+6dF6VBX
        PM/RTYHUvoAjjDy3wrUPGHfG0iT5m+I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-50AWQ2pGOZalxGhPM04L6w-1; Thu, 24 Jun 2021 08:41:25 -0400
X-MC-Unique: 50AWQ2pGOZalxGhPM04L6w-1
Received: by mail-wr1-f69.google.com with SMTP id u16-20020a5d51500000b029011a6a17cf62so2137997wrt.13
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 05:41:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ao/aik86DETd7ceeMOwWvzTcaJv+rZayOURU+D31sn8=;
        b=MUjPeh7/rX1SU2bokrZpDtSuJwl3BsiD8uKTW0vRbZJg3r6I/mlMvEIZANpPrX5Idx
         3YC5LFH++FNRZ2mdADHfPJsEZ4OAqw8A+4klHM+XDBDanKfAva4lw/NusvYQbOhtAHWC
         FJ/XdqrJUHnbWwbUJgkfUuo7C5XutmeyTvt10ro+s0T0t3ILH3/m+lVm+WnaYvqa4INL
         VHfwuHocHvF0swKAHyzC9G9aea4JV2/0oXkBn+xFnZV85cdUw81ug8P/ilpiy2ObpfPb
         8OO9HH/dj3R5wkD54C3+vtn4B2QK3FZnMy3c5k+IsZae/eDqAvT4az5BaBFbv9Gmz1jF
         djRQ==
X-Gm-Message-State: AOAM530pWzOdYZho+luO0kY00i66DNnS4GUycDqrpY8USs77z+fAzBDB
        F8WTjcNzU1UsydYmMNdWh3JGnvKzU+Dd5Iip09w/JeQF5WpCHVI+96Sygoqu9Ogf4PCEr5/ltST
        bggN49kUiTAqi
X-Received: by 2002:adf:f88e:: with SMTP id u14mr4211977wrp.391.1624538484097;
        Thu, 24 Jun 2021 05:41:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxX2C4aDAGP4h4xfzWoN2DoJE9Xd7OTVDMCCB2JExPqVzxr2MgGsOeSZupCF70+GqEZaJi1OA==
X-Received: by 2002:adf:f88e:: with SMTP id u14mr4211952wrp.391.1624538483934;
        Thu, 24 Jun 2021 05:41:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 22sm2818691wmi.4.2021.06.24.05.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 05:41:23 -0700 (PDT)
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64
 MMU
To:     Nicholas Piggin <npiggin@gmail.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        David Stevens <stevensd@chromium.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        James Morse <james.morse@arm.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvmarm@lists.cs.columbia.edu,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        David Stevens <stevensd@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Will Deacon <will@kernel.org>
References: <20210624035749.4054934-1-stevensd@google.com>
 <1624530624.8jff1f4u11.astroid@bobo.none>
 <1624534759.nj0ylor2eh.astroid@bobo.none>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d3a699a-15eb-9f1b-0735-79d14736f38c@redhat.com>
Date:   Thu, 24 Jun 2021 14:41:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624534759.nj0ylor2eh.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 13:42, Nicholas Piggin wrote:
> Excerpts from Nicholas Piggin's message of June 24, 2021 8:34 pm:
>> Excerpts from David Stevens's message of June 24, 2021 1:57 pm:
>>> KVM supports mapping VM_IO and VM_PFNMAP memory into the guest by using
>>> follow_pte in gfn_to_pfn. However, the resolved pfns may not have
>>> assoicated struct pages, so they should not be passed to pfn_to_page.
>>> This series removes such calls from the x86 and arm64 secondary MMU. To
>>> do this, this series modifies gfn_to_pfn to return a struct page in
>>> addition to a pfn, if the hva was resolved by gup. This allows the
>>> caller to call put_page only when necessated by gup.
>>>
>>> This series provides a helper function that unwraps the new return type
>>> of gfn_to_pfn to provide behavior identical to the old behavior. As I
>>> have no hardware to test powerpc/mips changes, the function is used
>>> there for minimally invasive changes. Additionally, as gfn_to_page and
>>> gfn_to_pfn_cache are not integrated with mmu notifier, they cannot be
>>> easily changed over to only use pfns.
>>>
>>> This addresses CVE-2021-22543 on x86 and arm64.
>>
>> Does this fix the problem? (untested I don't have a POC setup at hand,
>> but at least in concept)
> 
> This one actually compiles at least. Unfortunately I don't have much
> time in the near future to test, and I only just found out about this
> CVE a few hours ago.

And it also works (the reproducer gets an infinite stream of userspace 
exits and especially does not crash).  We can still go for David's 
solution later since MMU notifiers are able to deal with this pages, but 
it's a very nice patch for stable kernels.

If you provide a Signed-off-by, I can integrate it.

Paolo

> ---
> 
> 
> It's possible to create a region which maps valid but non-refcounted
> pages (e.g., tail pages of non-compound higher order allocations). These
> host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
> of APIs, which take a reference to the page, which takes it from 0 to 1.
> When the reference is dropped, this will free the page incorrectly.
> 
> Fix this by only taking a reference on the page if it was non-zero,
> which indicates it is participating in normal refcounting (and can be
> released with put_page).
> 
> ---
>   virt/kvm/kvm_main.c | 19 +++++++++++++++++--
>   1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6a6bc7af0e28..46fb042837d2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2055,6 +2055,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
>   	return true;
>   }
>   
> +static int kvm_try_get_pfn(kvm_pfn_t pfn)
> +{
> +	if (kvm_is_reserved_pfn(pfn))
> +		return 1;
> +	return get_page_unless_zero(pfn_to_page(pfn));
> +}
> +
>   static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   			       unsigned long addr, bool *async,
>   			       bool write_fault, bool *writable,
> @@ -2104,13 +2111,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 * Whoever called remap_pfn_range is also going to call e.g.
>   	 * unmap_mapping_range before the underlying pages are freed,
>   	 * causing a call to our MMU notifier.
> +	 *
> +	 * Certain IO or PFNMAP mappings can be backed with valid
> +	 * struct pages, but be allocated without refcounting e.g.,
> +	 * tail pages of non-compound higher order allocations, which
> +	 * would then underflow the refcount when the caller does the
> +	 * required put_page. Don't allow those pages here.
>   	 */
> -	kvm_get_pfn(pfn);
> +	if (!kvm_try_get_pfn(pfn))
> +		r = -EFAULT;
>   
>   out:
>   	pte_unmap_unlock(ptep, ptl);
>   	*p_pfn = pfn;
> -	return 0;
> +
> +	return r;
>   }
>   
>   /*
> 

