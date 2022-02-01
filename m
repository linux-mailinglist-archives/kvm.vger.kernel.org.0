Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 806DF4A6331
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 19:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241700AbiBASHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 13:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbiBASHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 13:07:10 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77486C061714
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 10:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R0yDYfpqv6G0qJ4TWP//kGvyk3PTrL93oe5AIU5CW6c=; b=alv69qVY7neZLMb2jWDPTVT/gY
        csZplivBxQyArYTFpA01gUCYds1v3D3yjk/04JAmQowplxF/zLpHbgRywYjI7MZzhpe8b5rTJImCF
        8u+e30lFOLj+u6F0l5J9Rnp02ujyEJqlxg61WIA68z6D+DmBLzzHSXtsFpBZcFO6Tvh/Mjmq4Iz8h
        va2Q1cUEIJ828sh6a+JiVB9LIqPaOD4FVTdK5/xdQ/N6VwVMMxtJtvzVjrpXYTbWhQeRKig5mCKd8
        VgsngbRgHt71xMyadE56GZRHyZpxMpQaK/i7az1CJ5mVALEVElJWPO3co4hU1oyuYv2UIbTxLYtP9
        quo/zp8w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56978)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nExYR-0000vL-FQ; Tue, 01 Feb 2022 18:06:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nExYJ-0002GW-9U; Tue, 01 Feb 2022 18:06:51 +0000
Date:   Tue, 1 Feb 2022 18:06:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 17/64] KVM: arm64: nv: Emulate PSTATE.M for a guest
 hypervisor
Message-ID: <Yfl2u69WA2sYcyom@shell.armlinux.org.uk>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-18-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128121912.509006-18-maz@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022 at 12:18:25PM +0000, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> We can no longer blindly copy the VCPU's PSTATE into SPSR_EL2 and return
> to the guest and vice versa when taking an exception to the hypervisor,
> because we emulate virtual EL2 in EL1 and therefore have to translate
> the mode field from EL2 to EL1 and vice versa.
> 
> This requires keeping track of the state we enter the guest, for which
> we transiently use a dedicated flag.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h          |  1 +
>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 19 ++++++++++++++++-
>  arch/arm64/kvm/hyp/vhe/switch.c            | 24 ++++++++++++++++++++++
>  3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8fffe2888403..fa253f08e0fd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -472,6 +472,7 @@ struct kvm_vcpu_arch {
>  #define KVM_ARM64_DEBUG_STATE_SAVE_SPE	(1 << 12) /* Save SPE context if active  */
>  #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
>  #define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
> +#define KVM_ARM64_IN_HYP_CONTEXT	(1 << 15) /* Guest running in HYP context */
>  
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>  				 KVM_GUESTDBG_USE_SW_BP | \
> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> index 283f780f5f56..e3689c6ce4cc 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
> @@ -157,9 +157,26 @@ static inline void __sysreg_restore_el1_state(struct kvm_cpu_context *ctxt,
>  	write_sysreg_el1(ctxt_sys_reg(ctxt, SPSR_EL1),	SYS_SPSR);
>  }
>  
> +/* Read the VCPU state's PSTATE, but translate (v)EL2 to EL1. */
> +static inline u64 to_hw_pstate(const struct kvm_cpu_context *ctxt)
> +{
> +	u64 mode = ctxt->regs.pstate & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +	switch (mode) {
> +	case PSR_MODE_EL2t:
> +		mode = PSR_MODE_EL1t;
> +		break;
> +	case PSR_MODE_EL2h:
> +		mode = PSR_MODE_EL1h;
> +		break;
> +	}
> +
> +	return (ctxt->regs.pstate & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
> +}
> +

Wondering if it makes sense to also have the reverse translation as an
inline function after the above too, so the two translations are
together - but as it's only used (in this patch at least) in switch.c
there probably isn't too much point.

So:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
