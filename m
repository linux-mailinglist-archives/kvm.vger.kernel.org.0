Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2496F3D7A54
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 17:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236974AbhG0P73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 11:59:29 -0400
Received: from foss.arm.com ([217.140.110.172]:40702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229569AbhG0P73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 11:59:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D938A31B;
        Tue, 27 Jul 2021 08:59:28 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5A6A3F70D;
        Tue, 27 Jul 2021 08:59:26 -0700 (PDT)
Subject: Re: [PATCH v2 3/6] KVM: arm64: Avoid mapping size adjustment on
 permission fault
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
 <20210726153552.1535838-4-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5216fbb0-1df2-325c-5e4d-98245c7470e6@arm.com>
Date:   Tue, 27 Jul 2021 17:00:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210726153552.1535838-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/26/21 4:35 PM, Marc Zyngier wrote:
> Since we only support PMD-sized mappings for THP, getting
> a permission fault on a level that results in a mapping
> being larger than PAGE_SIZE is a sure indication that we have
> already upgraded our mapping to a PMD.
>
> In this case, there is no need to try and parse userspace page
> tables, as the fault information already tells us everything.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0adc1617c557..ebb28dd4f2c9 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1076,9 +1076,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
> -		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
> -							   &pfn, &fault_ipa);
> +	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
> +		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
> +			vma_pagesize = fault_granule;
> +		else
> +			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
> +								   hva, &pfn,
> +								   &fault_ipa);
> +	}

Looks good:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  
>  	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
