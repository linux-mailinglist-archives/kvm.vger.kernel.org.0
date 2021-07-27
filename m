Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE323D7D1F
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhG0SKv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0SKu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6349760F4F;
        Tue, 27 Jul 2021 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627409450;
        bh=1idsSsOLd6j5B3mlucoHIl85eXG29dW6Ac2vbhUO3Bs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EoFDUbpRaPCpop/dEtf4WAzlFiaUP3CjPo5T53gFnwUy4wbJ3B+0hT3gzFVMjsnrB
         gLndl4KBOIAQZyvL0c0pZSAOT1BEAhGFCmvzU3sAIoChqIerKeR98fF/2S2rQCDG5k
         phec+IZQs88i19ZKdLrLG/MT0rWFQp6Gr6SN/pSGHk77wCP1zP2QUcyqX54Z5C8OfW
         7/tAQFHm9Px4MW92GtYwlqwqMSfND8kFmfuzSsZaLwaZe6xug/nkg39LP9h2p2l4sP
         4rLd4bMxC2v7t5Scn4P2rhF4xDAP0+ukEt9wsgzbZmQbttMuWmezJZhFtCFQUOrOxx
         UFuCQq1bIr3ww==
Date:   Tue, 27 Jul 2021 19:10:45 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 02/16] KVM: arm64: Don't issue CMOs when the physical
 address is invalid
Message-ID: <20210727181044.GB19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-3-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-3-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:45PM +0100, Marc Zyngier wrote:
> Make sure we don't issue CMOs when mapping something that
> is not a memory address in the S2 page tables.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 05321f4165e3..a5874ebd0354 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -619,12 +619,16 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
>  	}
>  
>  	/* Perform CMOs before installation of the guest stage-2 PTE */
> -	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
> -		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
> -						granule);
> -
> -	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> -		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
> +	if (kvm_phys_is_valid(phys)) {
> +		if (mm_ops->dcache_clean_inval_poc &&
> +		    stage2_pte_cacheable(pgt, new))
> +			mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new,
> +								      mm_ops),
> +						       granule);
> +		if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
> +			mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
> +						 granule);
> +	}

Given that this check corresponds to checking the validity of 'new', I
wonder whether we'd be better off pushing the validity checks down into
stage2_pte_{cacheable,executable}()?

I.e. have stage2_pte_cacheable() return false if !kvm_pte_valid()

Will
