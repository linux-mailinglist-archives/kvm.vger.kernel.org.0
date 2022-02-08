Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A7E4ADCC5
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380578AbiBHPfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:35:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380405AbiBHPez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:34:55 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63703C06157A
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 07:34:54 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28A122B;
        Tue,  8 Feb 2022 07:34:54 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1959A3F73B;
        Tue,  8 Feb 2022 07:34:50 -0800 (PST)
Date:   Tue, 8 Feb 2022 15:35:06 +0000
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
Subject: Re: [PATCH v6 28/64] KVM: arm64: nv: Emulate EL12 register accesses
 from the virtual EL2
Message-ID: <YgKNe+/CQdhkV6Ey@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-29-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-29-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Jan 28, 2022 at 12:18:36PM +0000, Marc Zyngier wrote:
> From: Jintack Lim <jintack.lim@linaro.org>
> 
> With HCR_EL2.NV bit set, accesses to EL12 registers in the virtual EL2
> trap to EL2. Handle those traps just like we do for EL1 registers.
> 
> One exception is CNTKCTL_EL12. We don't trap on CNTKCTL_EL1 for non-VHE
> virtual EL2 because we don't have to. However, accessing CNTKCTL_EL12
> will trap since it's one of the EL12 registers controlled by HCR_EL2.NV
> bit.  Therefore, add a handler for it and don't treat it as a
> non-trap-registers when preparing a shadow context.
> 
> These registers, being only a view on their EL1 counterpart, are
> permanently hidden from userspace.
> 
> Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
> [maz: EL12_REG(), register visibility]
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 0c9bbe5eee5e..697bf0bca550 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1634,6 +1634,26 @@ static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
>  	.val = v,				\
>  }
>  
> +/*
> + * EL{0,1}2 registers are the EL2 view on an EL0 or EL1 register when
> + * HCR_EL2.E2H==1, and only in the sysreg table for convenience of
> + * handling traps. Given that, they are always hidden from userspace.
> + */
> +static unsigned int elx2_visibility(const struct kvm_vcpu *vcpu,
> +				    const struct sys_reg_desc *rd)
> +{
> +	return REG_HIDDEN_USER;
> +}
> +
> +#define EL12_REG(name, acc, rst, v) {		\
> +	SYS_DESC(SYS_##name##_EL12),		\
> +	.access = acc,				\
> +	.reset = rst,				\
> +	.reg = name##_EL1,			\
> +	.val = v,				\
> +	.visibility = elx2_visibility,		\
> +}
> +
>  /* sys_reg_desc initialiser for known cpufeature ID registers */
>  #define ID_SANITISED(name) {			\
>  	SYS_DESC(SYS_##name),			\
> @@ -2194,6 +2214,23 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	EL2_REG(CNTVOFF_EL2, access_rw, reset_val, 0),
>  	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
>  
> +	EL12_REG(SCTLR, access_vm_reg, reset_val, 0x00C50078),
> +	EL12_REG(CPACR, access_rw, reset_val, 0),
> +	EL12_REG(TTBR0, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(TTBR1, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(TCR, access_vm_reg, reset_val, 0),
> +	{ SYS_DESC(SYS_SPSR_EL12), access_spsr},
> +	{ SYS_DESC(SYS_ELR_EL12), access_elr},
> +	EL12_REG(AFSR0, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(AFSR1, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(ESR, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(FAR, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(MAIR, access_vm_reg, reset_unknown, 0),
> +	EL12_REG(AMAIR, access_vm_reg, reset_amair_el1, 0),
> +	EL12_REG(VBAR, access_rw, reset_val, 0),
> +	EL12_REG(CONTEXTIDR, access_vm_reg, reset_val, 0),
> +	EL12_REG(CNTKCTL, access_rw, reset_val, 0),

Compared against Table D5-48 from ARM DDI 0487G.a (page D5-2768), everything
looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> +
>  	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
>  };
>  
> -- 
> 2.30.2
> 
