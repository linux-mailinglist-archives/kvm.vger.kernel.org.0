Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A04A416352
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 18:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhIWQ2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 12:28:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242257AbhIWQ2r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 12:28:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632414435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z/oIhWC7fKtGzqQpQFubKmVS4zDGgUypTCxx/i3WpJk=;
        b=E1ICqCy5f0168WMaBKC+Z7Zyxc4hyjKsdaZFdtNIxK2NcQUzpHfSmP+vI8m3FYDFMWUdf3
        ewHeZ5s0LKygRzMUmvG18UY7k8FRs14+wYh1sWSUnq38p2IFUR8TuFFb7Sfd/Vpydt6uBl
        gQ9Avgnfd9Xdn4fHbdyG4xSKXkgtCm0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-37594I9DPdaR97aaJOWNbA-1; Thu, 23 Sep 2021 12:27:14 -0400
X-MC-Unique: 37594I9DPdaR97aaJOWNbA-1
Received: by mail-ed1-f69.google.com with SMTP id o23-20020a509b17000000b003d739e2931dso7329913edi.4
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 09:27:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z/oIhWC7fKtGzqQpQFubKmVS4zDGgUypTCxx/i3WpJk=;
        b=h9ckwV1xm0LG7u9BfrtW2+kzJx1sRF0kDkV1nXjgbGZb89tTWfZsd1xluqBQvCvGXs
         1MLFBHF9V+SJOWmmavQz38lxgn8g7XT8gJbEUralZHRH0HpZVuvplMau7Fyrsm2F59wf
         zLQnuFyxObZy3WYXnXI8FNjY+9q6cy51DS9fP/WGSv6z9J0aTfYF+pkNDRnCxVkWzU0i
         R490KKheKHH/hhezqTjf7eRvyTwn/9nBhxruNbNVzBJXTsznHsEdxGTpq0+5uqHydIxl
         1OqLjVPgiRZtjU/2/nGCZ/sQsMAvg3IUomSeVerfPTWyXozCxobuHnZgAz+ABLM4E8+T
         nSPQ==
X-Gm-Message-State: AOAM5339b+DCpHpVsQ9n4Fc7HcVvJR3bNa4VTs5Qs+HwFZR+b8fKapbG
        q0v//1VXF38lCSCE5spUVz7s33FWnFezQ4t0/pnxMbrMhKUSt1ql3Y/5lhTvP2cNvJxEDnFcd9x
        FmGTDRslX1iaw
X-Received: by 2002:a50:9d44:: with SMTP id j4mr6516600edk.173.1632414432819;
        Thu, 23 Sep 2021 09:27:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjtsayXjj1zF617T7nkdYFU89qfJnNI5OfixDS0D2PT/D4EIs3CWG+OjES7T9V4qthIO2T+g==
X-Received: by 2002:a50:9d44:: with SMTP id j4mr6516062edk.173.1632414427707;
        Thu, 23 Sep 2021 09:27:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u10sm3720729eds.83.2021.09.23.09.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 09:27:07 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/mmu: Complete prefetch for trailing SPTEs for
 direct, legacy MMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20210818235615.2047588-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c47ae22f-39ba-7f6b-c9c4-105a2e4c026d@redhat.com>
Date:   Thu, 23 Sep 2021 18:27:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210818235615.2047588-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/08/21 01:56, Sean Christopherson wrote:
> Make a final call to direct_pte_prefetch_many() if there are "trailing"
> SPTEs to prefetch, i.e. SPTEs for GFNs following the faulting GFN.  The
> call to direct_pte_prefetch_many() in the loop only handles the case
> where there are !PRESENT SPTEs preceding a PRESENT SPTE.
> 
> E.g. if the faulting GFN is a multiple of 8 (the prefetch size) and all
> SPTEs for the following GFNs are !PRESENT, the loop will terminate with
> "start = sptep+1" and not prefetch any SPTEs.
> 
> Prefetching trailing SPTEs as intended can drastically reduce the number
> of guest page faults, e.g. accessing the first byte of every 4kb page in
> a 6gb chunk of virtual memory, in a VM with 8gb of preallocated memory,
> the number of pf_fixed events observed in L0 drops from ~1.75M to <0.27M.
> 
> Note, this only affects memory that is backed by 4kb pages as KVM doesn't
> prefetch when installing hugepages.  Shadow paging prefetching is not
> affected as it does not batch the prefetches due to the need to process
> the corresponding guest PTE.  The TDP MMU is not affected because it
> doesn't have prefetching, yet...
> 
> Fixes: 957ed9effd80 ("KVM: MMU: prefetch ptes when intercepted guest #PF")
> Cc: Sergey Senozhatsky <senozhatsky@google.com>
> Cc: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> 
> Cc'd Ben as this highlights a potential gap with the TDP MMU, which lacks
> prefetching of any sort.  For large VMs, which are likely backed by
> hugepages anyways, this is a non-issue as the benefits of holding mmu_lock
> for read likely masks the cost of taking more VM-Exits.  But VMs with a
> small number of vCPUs won't benefit as much from parallel page faults,
> e.g. there's no benefit at all if there's a single vCPU.
> 
>   arch/x86/kvm/mmu/mmu.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..daf7df35f788 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2818,11 +2818,13 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
>   			if (!start)
>   				continue;
>   			if (direct_pte_prefetch_many(vcpu, sp, start, spte) < 0)
> -				break;
> +				return;
>   			start = NULL;
>   		} else if (!start)
>   			start = spte;
>   	}
> +	if (start)
> +		direct_pte_prefetch_many(vcpu, sp, start, spte);
>   }
>   
>   static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
> 

Queued, thanks.

Paolo

