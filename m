Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1E63B2E61
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 14:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhFXMCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 08:02:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39608 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229853AbhFXMCw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 08:02:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624536032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=avGojGcO92NTULuhKarR1IMbTxAu/KipAq8BEw7I0Ko=;
        b=NwH7B5NWjpeo7xHuBdxiGRVZh4xvFr+1lFCIJJITHPUdkX1qQF6HaOwh7QLG0Nd8FkYAvF
        xESavrCoW3oJDHBQuPpw3tbG2YBsPxiC6jO70F5rBsHr1BY5umW0PjAB5zZ5EoQX6wnH1p
        zktQA9JdpEloy+r80cSPmHzIxlXLtTM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-sZnP7kPRMHCzbhXUCc_SsA-1; Thu, 24 Jun 2021 08:00:31 -0400
X-MC-Unique: sZnP7kPRMHCzbhXUCc_SsA-1
Received: by mail-wr1-f70.google.com with SMTP id u16-20020a5d51500000b029011a6a17cf62so2098730wrt.13
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 05:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=avGojGcO92NTULuhKarR1IMbTxAu/KipAq8BEw7I0Ko=;
        b=UdKINW6F5fHSAvtrkq4oigcC7LXD2SxTCe3RUNcghcyiXy78CtJvCoNtEf4VqB7RvC
         CVRo8cwM4SnhwVXT0xF/yA2nmrwE6fvJCsnDqfxJyq5MOUze4SYXxCbZB2U8y9QNo49+
         syQwRdfrozr1i7mii5XU7hKnfsGm+L4Mk/NmjyIn7u+vQvwvBp2GP4TORuvlPGcoh1ew
         M/cYK2kl34f4xHw0AvM0Sh5WvLumyYGeRI2iPTTGh+yfgWE0sXZFFa3tXortGOqxLnUI
         alA6aN1+TPyeImNX/Qd1kFu8Hs7W9vC//LjKDglOgNfOEBgW06AmuKt5RSUlAcsBTKgV
         fI9A==
X-Gm-Message-State: AOAM533p4qWTzJuR31Mlt5ZwLoHywZCueLZd7BB/JMFNqdY5jcONJIa7
        1C2BlIamX/N4gYI72ZFUP12PpM2dvhnQaGveJvfOnqbdU2Hapo5O0DNAlIaVzVW4WMV3pgLKX5h
        Ciqe9HIARSayE
X-Received: by 2002:a1c:f215:: with SMTP id s21mr3879323wmc.179.1624536030034;
        Thu, 24 Jun 2021 05:00:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXFCnAp+BCIAB50GwF3Py3d9h4g0enz3/eZSVNkNtDC1Z07h1ecnwnq+OHmfePVB6B9P4IuQ==
X-Received: by 2002:a1c:f215:: with SMTP id s21mr3879281wmc.179.1624536029808;
        Thu, 24 Jun 2021 05:00:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o2sm3074141wrp.53.2021.06.24.05.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 05:00:29 -0700 (PDT)
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
Subject: Re: [PATCH 0/6] KVM: Remove uses of struct page from x86 and arm64
 MMU
Message-ID: <d06a8a55-bb9d-a6ef-21bb-0633b99a50d1@redhat.com>
Date:   Thu, 24 Jun 2021 14:00:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1624534759.nj0ylor2eh.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/06/21 13:42, Nicholas Piggin wrote:
> +static int kvm_try_get_pfn(kvm_pfn_t pfn)
> +{
> +	if (kvm_is_reserved_pfn(pfn))
> +		return 1;

So !pfn_valid would always return true.  Yeah, this should work and is 
certainly appealing!

Paolo


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

