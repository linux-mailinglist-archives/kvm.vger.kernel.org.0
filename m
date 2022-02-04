Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C4D4A9837
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357310AbiBDLKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:10:22 -0500
Received: from foss.arm.com ([217.140.110.172]:36266 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355712AbiBDLKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 06:10:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AF441435;
        Fri,  4 Feb 2022 03:10:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BEE53F774;
        Fri,  4 Feb 2022 03:10:17 -0800 (PST)
Date:   Fri, 4 Feb 2022 11:10:35 +0000
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
Subject: Re: [PATCH v6 20/64] KVM: arm64: nv: Trap CPACR_EL1 access in
 virtual EL2
Message-ID: <Yf0Jm4vUNrnTcylS@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-21-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-21-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

This also what Arm ARM recommends for a guest with HCR_EL2.E2H = 0 in section
D5.7.1 "Armv8.3 nested virtualization functionality".

The L1 guest hypervisor running at virtual EL2 is restoring the guest context at
EL1, but the host is actually running in hardware EL1 and the register access
needs to be trapped because it affects the guest hypervisor. And because the L0
host is running with HCR_EL2.E2H = 1, writes to CPACR_EL1 are redirected to
CPTR_EL2.

Also the reset value is correct, as CPACR_EL1 either has RES0 or UNKNOWN fields
are reset.

Looks good to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Jan 28, 2022 at 12:18:28PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> For the same reason we trap virtual memory register accesses in virtual
> EL2, we trap CPACR_EL1 access too; We allow the virtual EL2 mode to
> access EL1 system register state instead of the virtual EL2 one.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vhe/switch.c | 3 +++
>  arch/arm64/kvm/sys_regs.c       | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> index 6ed9e4893a02..1e6a00e7bfb3 100644
> --- a/arch/arm64/kvm/hyp/vhe/switch.c
> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> @@ -64,6 +64,9 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
>  		__activate_traps_fpsimd32(vcpu);
>  	}
>  
> +	if (vcpu_is_el2(vcpu) && !vcpu_el2_e2h_is_set(vcpu))
> +		val |= CPTR_EL2_TCPAC;
> +	
>  	write_sysreg(val, cpacr_el1);
>  
>  	write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el1);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 4f2bcc1e0c25..7f074a7f6eb3 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1819,7 +1819,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	{ SYS_DESC(SYS_SCTLR_EL1), access_vm_reg, reset_val, SCTLR_EL1, 0x00C50078 },
>  	{ SYS_DESC(SYS_ACTLR_EL1), access_actlr, reset_actlr, ACTLR_EL1 },
> -	{ SYS_DESC(SYS_CPACR_EL1), NULL, reset_val, CPACR_EL1, 0 },
> +	{ SYS_DESC(SYS_CPACR_EL1), access_rw, reset_val, CPACR_EL1, 0 },
>  
>  	MTE_REG(RGSR_EL1),
>  	MTE_REG(GCR_EL1),
> -- 
> 2.30.2
> 
