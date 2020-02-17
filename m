Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8111615CD
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 16:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgBQPNI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 10:13:08 -0500
Received: from foss.arm.com ([217.140.110.172]:37154 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgBQPNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 10:13:08 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D54AE328;
        Mon, 17 Feb 2020 07:13:07 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF4A03F703;
        Mon, 17 Feb 2020 07:13:06 -0800 (PST)
Date:   Mon, 17 Feb 2020 15:13:04 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH v2 31/94] KVM: arm64: nv: Only toggle cache for virtual
 EL2 when SCTLR_EL2 changes
Message-ID: <20200217151304.GF47755@lakrids.cambridge.arm.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-32-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211174938.27809-32-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 05:48:35PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@linaro.org>
> 
> So far we were flushing almost the entire universe whenever a VM would
> load/unload the SCTLR_EL1 and the two versions of that register had
> different MMU enabled settings.  This turned out to be so slow that it
> prevented forward progress for a nested VM, because a scheduler timer
> tick interrupt would always be pending when we reached the nested VM.
> 
> To avoid this problem, we consider the SCTLR_EL2 when evaluating if
> caches are on or off when entering virtual EL2 (because this is the
> value that we end up shadowing onto the hardware EL1 register).
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_mmu.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index ee47f7637f28..ec4de0613e7c 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -88,6 +88,7 @@ alternative_cb_end
>  #include <asm/cacheflush.h>
>  #include <asm/mmu_context.h>
>  #include <asm/pgtable.h>
> +#include <asm/kvm_emulate.h>
>  
>  void kvm_update_va_mask(struct alt_instr *alt,
>  			__le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -305,7 +306,10 @@ struct kvm;
>  
>  static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>  {
> -	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
> +	if (vcpu_mode_el2(vcpu))
> +		return (__vcpu_sys_reg(vcpu, SCTLR_EL2) & 0b101) == 0b101;
> +	else
> +		return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
>  }

How about:

static bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
{
	unsigned long cm = SCTLR_ELx_C | SCTLR_ELx_M;
	unsigned long sctlr;

	if (vcpu_mode_el2(vcpu))
		sctlr = __vcpu_sys_reg(vcpu, SCTLR_EL2);
	else
		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
	
	return (sctlr & cm) == cm;
}

... to avoid duplication and make it clearer which fields we're
accessing.

Thanks,
Mark.

>  
>  static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
> -- 
> 2.20.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
