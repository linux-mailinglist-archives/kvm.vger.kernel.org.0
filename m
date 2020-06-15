Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2571F9438
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgFOKD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:03:27 -0400
Received: from foss.arm.com ([217.140.110.172]:44104 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728833AbgFOKD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 06:03:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F0E51F1;
        Mon, 15 Jun 2020 03:03:26 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.221])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 39CB53F71F;
        Mon, 15 Jun 2020 03:03:25 -0700 (PDT)
Date:   Mon, 15 Jun 2020 11:03:18 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: Re: [PATCH 1/4] KVM: arm64: Enable Pointer Authentication at EL2 if
 available
Message-ID: <20200615100318.GA773@C02TD0UTHF1T.local>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-2-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:51AM +0100, Marc Zyngier wrote:
> While initializing EL2, switch Pointer Authentication if detected
> from EL1. We use the EL1-provided keys though.

Perhaps "enable address authentication", to avoid confusion with
context-switch, and since generic authentication cannot be disabled
locally at EL2.

> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp-init.S | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 6e6ed5581eed..81732177507d 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -104,6 +104,17 @@ alternative_else_nop_endif
>  	 */
>  	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
>  CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
> +alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> +	b	1f
> +alternative_else_nop_endif
> +alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> +	b	2f
> +alternative_else_nop_endif

I see this is the same pattern we use in the kvm context switch, but I
think we can use the ARM64_HAS_ADDRESS_AUTH cap instead (likewise in the
existing code).

AFAICT that won't permit mismatch given both ARM64_HAS_ADDRESS_AUTH_ARCH
and ARM64_HAS_ADDRESS_AUTH_IMP_DEF are dealt with as
ARM64_CPUCAP_BOOT_CPU_FEATURE.

> +1:
> +	orr	x4, x4, #(SCTLR_ELx_ENIA | SCTLR_ELx_ENIB)
> +	orr	x4, x4, #SCTLR_ELx_ENDA
> +	orr	x4, x4, #SCTLR_ELx_ENDB

Assuming we have a spare register, it would be nice if we could follow the same
pattern as in proc.S, where we do:

| ldr     x2, =SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
|              SCTLR_ELx_ENDA | SCTLR_ELx_ENDB
| orr     x0, x0, x2

... though we could/should use mov_q rather than a load literal, here and in
proc.S.

... otherwise this looks sound to me.

Thanks,
Mark.

> +2:
>  	msr	sctlr_el2, x4
>  	isb
>  
> -- 
> 2.27.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
