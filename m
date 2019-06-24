Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4C2509E6
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 13:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfFXLiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 07:38:22 -0400
Received: from foss.arm.com ([217.140.110.172]:47802 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbfFXLiW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 07:38:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98B262B;
        Mon, 24 Jun 2019 04:38:21 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 438093F718;
        Mon, 24 Jun 2019 04:38:20 -0700 (PDT)
Date:   Mon, 24 Jun 2019 12:38:18 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH 05/59] KVM: arm64: nv: Reset VCPU to EL2 registers if
 VCPU nested virt is set
Message-ID: <20190624113817.GN2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-6-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621093843.220980-6-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 21, 2019 at 10:37:49AM +0100, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kvm/reset.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 1140b4485575..675ca07dbb05 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -52,6 +52,11 @@ static const struct kvm_regs default_regs_reset = {
>  			PSR_F_BIT | PSR_D_BIT),
>  };
>  
> +static const struct kvm_regs default_regs_reset_el2 = {
> +	.regs.pstate = (PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT |
> +			PSR_F_BIT | PSR_D_BIT),
> +};
> +

Is it worth having a #define for the common non-mode bits?  It's a bit
weird for EL2 and EL1 to have indepedent DAIF defaults.

Putting a big block of zeros in the kernel text just to initialise one
register seems overkill.  Now we're adding a third block of zeros,
maybe this is worth refactoring?  We really just need a memset(0)
followed by config-dependent initialisation of regs.pstate AFAICT.

Not a big deal though: this doesn't look like a high risk for
maintainability.

Cheers
---Dave

>  static const struct kvm_regs default_regs_reset32 = {
>  	.regs.pstate = (PSR_AA32_MODE_SVC | PSR_AA32_A_BIT |
>  			PSR_AA32_I_BIT | PSR_AA32_F_BIT),
> @@ -302,6 +307,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  			if (!cpu_has_32bit_el1())
>  				goto out;
>  			cpu_reset = &default_regs_reset32;
> +		} else if (test_bit(KVM_ARM_VCPU_NESTED_VIRT, vcpu->arch.features)) {
> +			cpu_reset = &default_regs_reset_el2;
>  		} else {
>  			cpu_reset = &default_regs_reset;
>  		}
> -- 
> 2.20.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
