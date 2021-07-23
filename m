Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877F3D3CEF
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 17:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbhGWPOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 11:14:24 -0400
Received: from foss.arm.com ([217.140.110.172]:48256 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235740AbhGWPOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 11:14:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4B5613A1;
        Fri, 23 Jul 2021 08:54:35 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D1C443F73D;
        Fri, 23 Jul 2021 08:54:33 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 2/5] KVM: arm64: Avoid mapping size adjustment on
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
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-3-maz@kernel.org>
Message-ID: <a8f42fdf-4cbc-ad10-c8cc-cbbf850f85e4@arm.com>
Date:   Fri, 23 Jul 2021 16:55:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/17/21 10:55 AM, Marc Zyngier wrote:
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
> index db6314b93e99..c036a480ca27 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1088,9 +1088,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	 * If we are not forced to use page mapping, check if we are
>  	 * backed by a THP and thus use block mapping if possible.
>  	 */
> -	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
> -		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
> -							   &pfn, &fault_ipa);
> +	if (vma_pagesize == PAGE_SIZE && !force_pte) {

Looks like now it's possible to call transparent_hugepage_adjust() for devices (if
fault_status != FSC_PERM). Commit 2aa53d68cee6 ("KVM: arm64: Try stage2 block
mapping for host device MMIO") makes a good case for the !device check. Was the
check removed unintentionally?

> +		if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
> +			vma_pagesize = fault_granule;
> +		else
> +			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
> +								   hva, &pfn,
> +								   &fault_ipa);
> +	}

This change makes sense to me - we can only get stage 2 permission faults on a
leaf entry since stage 2 tables don't have the APTable/XNTable/PXNTable bits. The
biggest block mapping size that we support at stage 2 is PMD size (from
transparent_hugepage_adjust()), therefore if fault_granule is larger than
PAGE_SIZE, then it must be PMD_SIZE.

Thanks,

Alex

>  
>  	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
>  		/* Check the VMM hasn't introduced a new VM_SHARED VMA */
