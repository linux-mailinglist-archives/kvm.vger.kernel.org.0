Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C7348D73A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 13:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiAMMMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 07:12:00 -0500
Received: from foss.arm.com ([217.140.110.172]:43762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230310AbiAMMMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 07:12:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C6CDED1;
        Thu, 13 Jan 2022 04:11:59 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BB763F774;
        Thu, 13 Jan 2022 04:11:57 -0800 (PST)
Date:   Thu, 13 Jan 2022 12:12:04 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 05/69] KVM: arm64: Allow preservation of the S2 SW bits
Message-ID: <YeAXFOR1wf3LekrQ@monolith.localdoman>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-6-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Mon, Nov 29, 2021 at 08:00:46PM +0000, Marc Zyngier wrote:
> The S2 page table code has a limited use the SW bits, but we are about
> to need them to encode some guest Stage-2 information (its mapping size
> in the form of the TTL encoding).
> 
> Propagate the SW bits specified by the caller, and store them into
> the corresponding entry.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 8cdbc43fa651..d69e400b2de6 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -1064,9 +1064,6 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	u32 level;
>  	kvm_pte_t set = 0, clr = 0;
>  
> -	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
> -		return -EINVAL;
> -
>  	if (prot & KVM_PGTABLE_PROT_R)
>  		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
>  
> @@ -1076,6 +1073,10 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	if (prot & KVM_PGTABLE_PROT_X)
>  		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
>  
> +	/* Always propagate the SW bits */
> +	clr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_HI_SW, 0xf);

Nitpick: isn't that the same as:

	clr |= KVM_PTE_LEAF_ATTR_HI_SW;

which looks more readable to me.

> +	set |= prot & KVM_PTE_LEAF_ATTR_HI_SW;

Checked stage2_attr_walker() callbak, first it clears the bits in clr, then
sets the bits in set, so this looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +
>  	ret = stage2_update_leaf_attrs(pgt, addr, 1, set, clr, NULL, &level);
>  	if (!ret)
>  		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, pgt->mmu, addr, level);
> -- 
> 2.30.2
> 
