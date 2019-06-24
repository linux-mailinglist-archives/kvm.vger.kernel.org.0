Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D13450B7E
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfFXNIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 09:08:12 -0400
Received: from foss.arm.com ([217.140.110.172]:49762 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbfFXNIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 09:08:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0C4344;
        Mon, 24 Jun 2019 06:08:11 -0700 (PDT)
Received: from e103592.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC5173F71E;
        Mon, 24 Jun 2019 06:08:09 -0700 (PDT)
Date:   Mon, 24 Jun 2019 14:08:07 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Julien Thierry <julien.thierry@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: [PATCH 09/59] KVM: arm64: nv: Add nested virt VCPU primitives
 for vEL2 VCPU state
Message-ID: <20190624130807.GS2790@e103592.cambridge.arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-10-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621093843.220980-10-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 21, 2019 at 10:37:53AM +0100, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> When running a nested hypervisor we commonly have to figure out if
> the VCPU mode is running in the context of a guest hypervisor or guest
> guest, or just a normal guest.
> 
> Add convenient primitives for this.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_emulate.h | 55 ++++++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 39ffe41855bc..8f201ea56f6e 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -191,6 +191,61 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
>  		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
>  }
>  
> +static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)
> +{
> +	unsigned long cpsr = ctxt->gp_regs.regs.pstate;
> +	u32 mode;
> +
> +	if (cpsr & PSR_MODE32_BIT)
> +		return false;
> +
> +	mode = cpsr & PSR_MODE_MASK;
> +
> +	return mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t;

We could also treat PSR_MODE32_BIT and PSR_MODE_MASK as a single field,
similarly as in the next patch, say:

	switch (ctxt->gp_regs.regs.pstate & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
	case PSR_MODE_EL2h:
	case PSR_MODE_EL2t:
		return true;
	}

	return false;

(This is blatant bikeshedding...)

[...]

Cheers
---Dave
