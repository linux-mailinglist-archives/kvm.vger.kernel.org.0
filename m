Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EF42A2E4F
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 16:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgKBP3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 10:29:16 -0500
Received: from foss.arm.com ([217.140.110.172]:60994 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbgKBP3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 10:29:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF6F430E;
        Mon,  2 Nov 2020 07:29:15 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 06A583F66E;
        Mon,  2 Nov 2020 07:29:14 -0800 (PST)
Subject: Re: [PATCH 7/8] KVM: arm64: Simplify __kvm_enable_ssbs()
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-8-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <efe49392-b8ae-76fa-b581-d7ec8db2cac7@arm.com>
Date:   Mon, 2 Nov 2020 15:30:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026095116.72051-8-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/26/20 9:51 AM, Marc Zyngier wrote:
> Move the setting of SSBS directly into the HVC handler, using
> the C helpers rather than the inline asssembly code.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_asm.h    |  2 --
>  arch/arm64/include/asm/sysreg.h     |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c  |  6 +++++-
>  arch/arm64/kvm/hyp/nvhe/sysreg-sr.c | 11 -----------
>  4 files changed, 6 insertions(+), 14 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 54387ccd1ab2..a542c422a036 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -189,8 +189,6 @@ extern void __kvm_timer_set_cntvoff(u64 cntvoff);
>  
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
> -extern void __kvm_enable_ssbs(void);
> -
>  extern u64 __vgic_v3_get_ich_vtr_el2(void);
>  extern u64 __vgic_v3_read_vmcr(void);
>  extern void __vgic_v3_write_vmcr(u32 vmcr);
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index d52c1b3ce589..c9423f36e05c 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -461,6 +461,7 @@
>  
>  #define SYS_PMCCFILTR_EL0		sys_reg(3, 3, 14, 15, 7)
>  
> +#define SYS_SCTLR_EL2			sys_reg(3, 4, 1, 0, 0)
>  #define SYS_ZCR_EL2			sys_reg(3, 4, 1, 2, 0)
>  #define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
>  #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 2af8a5e902af..5125e934da22 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -58,7 +58,11 @@ static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
>  
>  static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
>  {
> -	__kvm_enable_ssbs();
> +	u64 tmp;
> +
> +	tmp = read_sysreg_el2(SYS_SCTLR);
> +	tmp |= SCTLR_ELx_DSSBS;
> +	write_sysreg_el2(tmp, SYS_SCTLR);

This looks identical to me to the inline assembly version:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  }
>  
>  static void handle___vgic_v3_get_ich_vtr_el2(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> index 88a25fc8fcd3..29305022bc04 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sysreg-sr.c
> @@ -33,14 +33,3 @@ void __sysreg_restore_state_nvhe(struct kvm_cpu_context *ctxt)
>  	__sysreg_restore_user_state(ctxt);
>  	__sysreg_restore_el2_return_state(ctxt);
>  }
> -
> -void __kvm_enable_ssbs(void)
> -{
> -	u64 tmp;
> -
> -	asm volatile(
> -	"mrs	%0, sctlr_el2\n"
> -	"orr	%0, %0, %1\n"
> -	"msr	sctlr_el2, %0"
> -	: "=&r" (tmp) : "L" (SCTLR_ELx_DSSBS));
> -}
