Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7E8298E83
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 14:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780701AbgJZNxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 09:53:13 -0400
Received: from foss.arm.com ([217.140.110.172]:39934 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780698AbgJZNxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 09:53:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DB49106F;
        Mon, 26 Oct 2020 06:53:12 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1557A3F68F;
        Mon, 26 Oct 2020 06:53:10 -0700 (PDT)
Date:   Mon, 26 Oct 2020 13:53:08 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] KVM: arm64: Don't adjust PC on SError during SMC
 trap
Message-ID: <20201026135308.GC12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026133450.73304-2-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 01:34:40PM +0000, Marc Zyngier wrote:
> On SMC trap, the prefered return address is set to that of the SMC
> instruction itself. It is thus wrong to tyr and roll it back when

Typo: s/tyr/try/

> an SError occurs while trapping on SMC. It is still necessary on
> HVC though, as HVC doesn't cause a trap, and sets ELR to returning
> *after* the HVC.
> 
> It also became apparent that the is 16bit encoding for an AArch32

I guess s/that the is/that there is no/ ?

> HVC instruction, meaning that the displacement is always 4 bytes,
> no matter what the ISA is. Take this opportunity to simplify it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Assuming that there is no 16-bit HVC:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/handle_exit.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 5d690d60ccad..79a720657c47 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -245,15 +245,15 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
>  		u8 esr_ec = ESR_ELx_EC(kvm_vcpu_get_esr(vcpu));
>  
>  		/*
> -		 * HVC/SMC already have an adjusted PC, which we need
> -		 * to correct in order to return to after having
> -		 * injected the SError.
> +		 * HVC already have an adjusted PC, which we need to
> +		 * correct in order to return to after having injected
> +		 * the SError.
> +		 *
> +		 * SMC, on the other hand, is *trapped*, meaning its
> +		 * preferred return address is the SMC itself.
>  		 */
> -		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64 ||
> -		    esr_ec == ESR_ELx_EC_SMC32 || esr_ec == ESR_ELx_EC_SMC64) {
> -			u32 adj =  kvm_vcpu_trap_il_is32bit(vcpu) ? 4 : 2;
> -			*vcpu_pc(vcpu) -= adj;
> -		}
> +		if (esr_ec == ESR_ELx_EC_HVC32 || esr_ec == ESR_ELx_EC_HVC64)
> +			*vcpu_pc(vcpu) -= 4;
>  
>  		return 1;
>  	}
> -- 
> 2.28.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
