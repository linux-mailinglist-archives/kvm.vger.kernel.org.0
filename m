Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457884AF746
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 17:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiBIQ4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 11:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbiBIQ43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 11:56:29 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83A75C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 08:56:32 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 476B0ED1;
        Wed,  9 Feb 2022 08:56:32 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 12B833F73B;
        Wed,  9 Feb 2022 08:56:28 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:56:48 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 31/64] KVM: arm64: nv: Only toggle cache for virtual
 EL2 when SCTLR_EL2 changes
Message-ID: <YgPyFASNCS8FLYd+@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-32-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-32-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:39PM +0000, Marc Zyngier wrote:
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
> index 81839e9a8a24..1b314b2a69bc 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -115,6 +115,7 @@ alternative_cb_end
>  #include <asm/cache.h>
>  #include <asm/cacheflush.h>
>  #include <asm/mmu_context.h>
> +#include <asm/kvm_emulate.h>
>  
>  void kvm_update_va_mask(struct alt_instr *alt,
>  			__le32 *origptr, __le32 *updptr, int nr_inst);
> @@ -187,7 +188,10 @@ struct kvm;
>  
>  static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
>  {
> -	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
> +	if (vcpu_is_el2(vcpu))
> +		return (__vcpu_sys_reg(vcpu, SCTLR_EL2) & 0b101) == 0b101;
> +	else
> +		return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;

Might be more readable if instead of 0b101 KVM would use defines, something
like:

 static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 {
-       return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
+       u64 cache_bits = SCTLR_ELx_M | SCTLR_ELx_C;
+
+       if (vcpu_is_el2(vcpu))
+               return (__vcpu_sys_reg(vcpu, SCTLR_EL2) & cache_bits) == cache_bits;
+       else
+               return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & cache_bits) == cache_bits;
 }

Regardless, it is correct to use vcpu_read_sys_reg() for the SCTLR_EL1 case, as
the most recent register value could be on the CPU in the VHE case, instead of
being in memory, like it's always the case with the SCTLR_EL2 register:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  }
>  
>  static inline void __clean_dcache_guest_page(void *va, size_t size)
> -- 
> 2.30.2
> 
