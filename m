Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482904A89F7
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239705AbiBCR1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:27:06 -0500
Received: from foss.arm.com ([217.140.110.172]:59428 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344988AbiBCR1E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Feb 2022 12:27:04 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B00A7147A;
        Thu,  3 Feb 2022 09:27:03 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B4983F40C;
        Thu,  3 Feb 2022 09:27:00 -0800 (PST)
Date:   Thu, 3 Feb 2022 17:27:17 +0000
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
Subject: Re: [PATCH v6 19/64] KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and
 VBAR_EL1 from virtual EL2
Message-ID: <YfwQB/jnlxYpYrBg@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-20-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-20-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The previous patch:

"KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2" -> sets the trap
bits to trap EL1 VM registers.

This patch:

"KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2" -> does
not set the trap bits to trap the registers.

Might be worth changing the subject to something like "Add accessors for
<register list here>" to reflect what the patch does.

Other than that, the patch looks good to me.

Thanks,
Alex

On Fri, Jan 28, 2022 at 12:18:27PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> For the same reason we trap virtual memory register accesses at virtual
> EL2, we need to trap SPSR_EL1, ELR_EL1 and VBAR_EL1 accesses. ARM v8.3
> introduces the HCR_EL2.NV1 bit to be able to trap on those register
> accesses in EL1. Do not set this bit until the whole nesting support is
> completed.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 9d3520f1d17a..4f2bcc1e0c25 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1650,6 +1650,30 @@ static bool access_sp_el1(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +static bool access_elr(struct kvm_vcpu *vcpu,
> +		       struct sys_reg_params *p,
> +		       const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
> +	else
> +		p->regval = vcpu_read_sys_reg(vcpu, ELR_EL1);
> +
> +	return true;
> +}
> +
> +static bool access_spsr(struct kvm_vcpu *vcpu,
> +			struct sys_reg_params *p,
> +			const struct sys_reg_desc *r)
> +{
> +	if (p->is_write)
> +		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
> +	else
> +		p->regval = __vcpu_sys_reg(vcpu, SPSR_EL1);
> +
> +	return true;
> +}
> +
>  static bool access_spsr_el2(struct kvm_vcpu *vcpu,
>  			    struct sys_reg_params *p,
>  			    const struct sys_reg_desc *r)
> @@ -1812,6 +1836,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	PTRAUTH_KEY(APDB),
>  	PTRAUTH_KEY(APGA),
>  
> +	{ SYS_DESC(SYS_SPSR_EL1), access_spsr},
> +	{ SYS_DESC(SYS_ELR_EL1), access_elr},
> +
>  	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
>  	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
>  	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
> @@ -1859,7 +1886,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_LORC_EL1), trap_loregion },
>  	{ SYS_DESC(SYS_LORID_EL1), trap_loregion },
>  
> -	{ SYS_DESC(SYS_VBAR_EL1), NULL, reset_val, VBAR_EL1, 0 },
> +	{ SYS_DESC(SYS_VBAR_EL1), access_rw, reset_val, VBAR_EL1, 0 },
>  	{ SYS_DESC(SYS_DISR_EL1), NULL, reset_val, DISR_EL1, 0 },
>  
>  	{ SYS_DESC(SYS_ICC_IAR0_EL1), write_to_read_only },
> -- 
> 2.30.2
> 
