Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3AB33F2AD
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 15:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhCQOcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 10:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231920AbhCQOcD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 10:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EAD664E13;
        Wed, 17 Mar 2021 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615991523;
        bh=9PV7SAdG8UI+hcTymUc6iMtrRcc/ff/6MFt24sMoR4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jphF1XmayKtQgSAtPuUftY5Qv/YT6yoj383uQjZE9zvLm8jWI0tGF3DKhJvZHyA51
         VnqyWU7ZTXljYlMjbty/RyYjFGXE0grk9sDvV7aa8J5Uvr/IADhNbo5vB3vIhLTqMW
         b7w/nLO7cbrpcFlk1s6mUXORXdd+LGgUmFOcBwSZ4Wei55J8dDDJQwlAlr824DnzuB
         l5rhJxilxB0D0sR1G711IZs0i4BocWJo8eBBZEFnF+2AWPkXIyFOBT8yK3b0zr8L2S
         qKkM4NSqSu5LucgAZEYY/jHlcF8flGsXAnjXOvZQef+nOE2VduRVqOy/asdAIsAXqK
         BwfJLxLH6a8VQ==
Date:   Wed, 17 Mar 2021 14:31:57 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, kernel-team@android.com
Subject: Re: [PATCH 03/10] KVM: arm64: Let vcpu_sve_pffr() handle HYP VAs
Message-ID: <20210317143157.GD5393@willie-the-truck>
References: <20210316101312.102925-1-maz@kernel.org>
 <20210316101312.102925-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316101312.102925-4-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 10:13:05AM +0000, Marc Zyngier wrote:
> The vcpu_sve_pffr() returns a pointer, which can be an interesting
> thing to do on nVHE. Wrap the pointer with kern_hyp_va(), and
> take this opportunity to remove the unnecessary casts (sve_state
> being a void *).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3d10e6527f7d..fb1d78299ba0 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -372,8 +372,8 @@ struct kvm_vcpu_arch {
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> -#define vcpu_sve_pffr(vcpu) ((void *)((char *)((vcpu)->arch.sve_state) + \
> -				      sve_ffr_offset((vcpu)->arch.sve_max_vl)))
> +#define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> +			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
>  
>  #define vcpu_sve_state_size(vcpu) ({					\
>  	size_t __size_ret;						\

Acked-by: Will Deacon <will@kernel.org>

Will
