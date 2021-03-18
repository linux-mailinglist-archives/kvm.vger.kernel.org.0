Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88323406E4
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhCRNcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhCRNcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 09:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 366D064F10;
        Thu, 18 Mar 2021 13:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616074345;
        bh=k/oQ8zP5s60bX2Q7fVafPs3TLGk3bNIqQryqUT2a1LM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fWBNJXdZdvEZpAGhCuiqIokjkwW7pCbd5R0/BOmSfXIIjt221+LzmJBc32/Fz3/NE
         R5Y3R24wGtMdb2duE8a8UqFBzZyWRDOtXmbeG0VflSDjWKZpF6MJguDMb7eEyA2G+F
         fBNTraqlKk37t/cUTiJH2ObT1pbm4tXusmorZM0YtcsMpqTJr34gZ4JhD8MH9DLmEP
         UGYO8UOs3figMLsbVLgmtBa2rci20YgwZA3ILsZtWm5okif+axoM6g1far9GkbCmj8
         wCMy2jYfaVp5JSxPtEloWaHZlh/2KUo1R4lFwvJt5VaQAudsz+iaVI33II/mRgodmS
         3XPYoH9sJtK4w==
Date:   Thu, 18 Mar 2021 13:32:19 +0000
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dave.martin@arm.com, daniel.kiss@arm.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        broonie@kernel.org, ascull@google.com, qperret@google.com,
        kernel-team@android.com
Subject: Re: [PATCH v2 05/11] arm64: sve: Provide a conditional update
 accessor for ZCR_ELx
Message-ID: <20210318133219.GB7055@willie-the-truck>
References: <20210318122532.505263-1-maz@kernel.org>
 <20210318122532.505263-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318122532.505263-6-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 18, 2021 at 12:25:26PM +0000, Marc Zyngier wrote:
> A common pattern is to conditionally update ZCR_ELx in order
> to avoid the "self-synchronizing" effect that writing to this
> register has.
> 
> Let's provide an accessor that does exactly this.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/fpsimd.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> index bec5f14b622a..05c9c55768b8 100644
> --- a/arch/arm64/include/asm/fpsimd.h
> +++ b/arch/arm64/include/asm/fpsimd.h
> @@ -130,6 +130,15 @@ static inline void sve_user_enable(void)
>  	sysreg_clear_set(cpacr_el1, 0, CPACR_EL1_ZEN_EL0EN);
>  }
>  
> +#define sve_cond_update_zcr_vq(val, reg)		\
> +	do {						\
> +		u64 __zcr = read_sysreg_s((reg));	\
> +		u64 __new = __zcr & ~ZCR_ELx_LEN_MASK;	\
> +		__new |= (val) & ZCR_ELx_LEN_MASK;	\
> +		if (__zcr != __new)			\
> +			write_sysreg_s(__new, (reg));	\
> +	} while (0)

Acked-by: Will Deacon <will@kernel.org>

Will
