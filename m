Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85195490ECE
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 18:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiAQRMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 12:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243788AbiAQRKY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 12:10:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8930C07E5FC
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 09:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/8mw8I5owI1/46b8zz3cNBJT1Qqemt9Avyidy1n3jAk=; b=AzZhyWhcs6HCnhiLli+L1XHDL8
        UzjAiESkdP41aQU1pXiu4wD4vOn02RrX1UJyfR4s9WcZUjHo25mfMzd5FnrY6E3ub27POrb9x/ows
        GvA0rKuUJ1IuQlEPl8azsYma731vWwaP2jyASvG83Bv2888nD/iYBCpLJnvla5yPGvRezQjr200J5
        Z7rSLzuldxkFcniwfoh2nFyOjIBbPr2Sak0GxLicZph2u8d6ZYUXnLAIpiv8Qkp7jaCLzdNt1Q8qs
        inI4/vnwby45zPzW8xjFbPQCt7aVjQtQWSWpCKR2EE8MVhz0hvD3smxdPHRT2uKM9z6z8YrB2HQFr
        nV21dldQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56736)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n9VSP-0002t2-Jj; Mon, 17 Jan 2022 17:06:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n9VSM-0003UN-2I; Mon, 17 Jan 2022 17:06:10 +0000
Date:   Mon, 17 Jan 2022 17:06:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH v5 08/69] KVM: arm64: nv: Reset VCPU to EL2 registers if
 VCPU nested virt is set
Message-ID: <YeWiAgWbDhTreD7y@shell.armlinux.org.uk>
References: <20211129200150.351436-1-maz@kernel.org>
 <20211129200150.351436-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129200150.351436-9-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 08:00:49PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
> feature is enabled on the VCPU.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> [maz: rework register reset not to use empty data structures]
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

However, a couple of comments below.

> ---
>  arch/arm64/kvm/reset.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 426bd7fbc3fd..38a7182819fb 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -27,6 +27,7 @@
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_nested.h>
>  #include <asm/virt.h>
>  
>  /* Maximum phys_shift supported for any VM on this host */
> @@ -38,6 +39,9 @@ static u32 kvm_ipa_limit;
>  #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
>  				 PSR_F_BIT | PSR_D_BIT)
>  
> +#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
> +				 PSR_F_BIT | PSR_D_BIT)
> +
>  #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
>  				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
>  
> @@ -176,8 +180,8 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
>  	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
>  		return false;
>  
> -	/* MTE is incompatible with AArch32 */
> -	if (kvm_has_mte(vcpu->kvm) && is32bit)
> +	/* MTE and NV are incompatible with AArch32 */
> +	if ((kvm_has_mte(vcpu->kvm) || nested_virt_in_use(vcpu)) && is32bit)
>  		return false;

It seems we have a bunch of:

	if (something && is32bit)
		return false;

tests here - would it make sense to do:

	if (is32bit) {
		if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1))
			return false;

		/* MTE is incompatible with AArch32 */
		if (kvm_has_mte(vcpu->kvm))
			return false;

		/* NV is incompatible with AArch32 */
		if (nested_virt_in_use(vcpu))
			return false;
	}

in terms of improved readability?

> @@ -255,6 +259,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
>  			pstate = VCPU_RESET_PSTATE_SVC;
> +		} else if (nested_virt_in_use(vcpu)) {
> +			pstate = VCPU_RESET_PSTATE_EL2;
>  		} else {
>  			pstate = VCPU_RESET_PSTATE_EL1;
>  		}

Not an issue with your patch, but the switch around this looks useless.
The only case is this default case, so it's entirely a no-op.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
