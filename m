Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F173D7C7D
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 19:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhG0Rp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 13:45:26 -0400
Received: from foss.arm.com ([217.140.110.172]:42054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhG0RpZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 13:45:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44CB11FB;
        Tue, 27 Jul 2021 10:45:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F0803F70D;
        Tue, 27 Jul 2021 10:45:23 -0700 (PDT)
Subject: Re: [PATCH v2 5/6] KVM: arm64: Use get_page() instead of
 kvm_get_pfn()
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20210726153552.1535838-1-maz@kernel.org>
 <20210726153552.1535838-6-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <21cf5bb7-e70c-345b-be9e-ea009823c255@arm.com>
Date:   Tue, 27 Jul 2021 18:46:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726153552.1535838-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/26/21 4:35 PM, Marc Zyngier wrote:
> When mapping a THP, we are guaranteed that the page isn't reserved,
> and we can safely avoid the kvm_is_reserved_pfn() call.
>
> Replace kvm_get_pfn() with get_page(pfn_to_page()).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index ebb28dd4f2c9..b303aa143592 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -840,7 +840,7 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
>  		*ipap &= PMD_MASK;
>  		kvm_release_pfn_clean(pfn);
>  		pfn &= ~(PTRS_PER_PMD - 1);
> -		kvm_get_pfn(pfn);
> +		get_page(pfn_to_page(pfn));
>  		*pfnp = pfn;
>  
>  		return PMD_SIZE;

I am not very familiar with the mm subsystem, but I did my best to review this change.

kvm_get_pfn() uses get_page(pfn) if !PageReserved(pfn_to_page(pfn)). I looked at
the documentation for the PG_reserved page flag, and for normal memory, what
looked to me like the most probable situation where that can be set for a
transparent hugepage was for the zero page. Looked at mm/huge_memory.c, and
huge_zero_pfn is allocated via alloc_pages(__GFP_ZERO) (and other flags), which
doesn't call SetPageReserved().

I looked at how a huge page can be mapped from handle_mm_fault and from
khugepaged, and it also looks to like both are using using alloc_pages() to
allocate a new hugepage.

I also did a grep for SetPageReserved(), and there are very few places where that
is called, and none looked like they have anything to do with hugepages.

As far as I can tell, this change is correct, but I think someone who is familiar
with mm would be better suited for reviewing this patch.

