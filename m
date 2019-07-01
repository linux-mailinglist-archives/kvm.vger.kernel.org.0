Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A305C14E
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 18:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbfGAQkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 12:40:16 -0400
Received: from foss.arm.com ([217.140.110.172]:37510 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727671AbfGAQkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 12:40:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 81FC92B;
        Mon,  1 Jul 2019 09:40:15 -0700 (PDT)
Received: from [10.1.31.185] (unknown [10.1.31.185])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABACA3F703;
        Mon,  1 Jul 2019 09:40:14 -0700 (PDT)
Subject: Re: [PATCH 20/59] KVM: arm64: nv: Trap CPACR_EL1 access in virtual
 EL2
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>
References: <20190621093843.220980-1-marc.zyngier@arm.com>
 <20190621093843.220980-21-marc.zyngier@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <a7b309a6-83c1-27cc-f587-17389ccfd857@arm.com>
Date:   Mon, 1 Jul 2019 17:40:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190621093843.220980-21-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/21/19 10:38 AM, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
>
> For the same reason we trap virtual memory register accesses in virtual
> EL2, we trap CPACR_EL1 access too; We allow the virtual EL2 mode to
> access EL1 system register state instead of the virtual EL2 one.
>
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 3 ++-
>  arch/arm64/kvm/hyp/switch.c      | 2 ++
>  arch/arm64/kvm/sys_regs.c        | 2 +-
>  3 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index b2e363ac624d..48e15af2bece 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -278,12 +278,13 @@
>  #define CPTR_EL2_TFP_SHIFT 10
>  
>  /* Hyp Coprocessor Trap Register */
> -#define CPTR_EL2_TCPAC	(1 << 31)
> +#define CPTR_EL2_TCPAC	(1U << 31)
>  #define CPTR_EL2_TTA	(1 << 20)
>  #define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
>  #define CPTR_EL2_TZ	(1 << 8)
>  #define CPTR_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 */
>  #define CPTR_EL2_DEFAULT	CPTR_EL2_RES1
> +#define CPTR_EL2_E2H_TCPAC	(1U << 31)
I'm not sure why CPTR_EL2_TCPAC is being renamed to CPTR_EL2_E2H_TCPAC.
CPTR_EL2.TCPAC is always bit 31, regardless of the value of HCR_EL2.E2H. I also
did a grep and it's only used in the one place added by this patch.
>  
>  /* Hyp Debug Configuration Register bits */
>  #define MDCR_EL2_TPMS		(1 << 14)
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 791b26570347..62359c7c3d6b 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -108,6 +108,8 @@ static void activate_traps_vhe(struct kvm_vcpu *vcpu)
>  		val &= ~CPACR_EL1_FPEN;
>  		__activate_traps_fpsimd32(vcpu);
>  	}
> +	if (vcpu_mode_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> +		val |= CPTR_EL2_E2H_TCPAC;
>  
>  	write_sysreg(val, cpacr_el1);
>  
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7fc87657382d..1d1312425cf2 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1773,7 +1773,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	ID_UNALLOCATED(7,7),
>  
>  	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
> -	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> +	{ SYS_DESC(SYS_CPACR_EL1), access_rw, reset_val, CPACR_EL1, 0 },
>  	{ SYS_DESC(SYS_ZCR_EL1), NULL, reset_val, ZCR_EL1, 0, .visibility = sve_visibility },
>  	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
>  	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
