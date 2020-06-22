Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B5B2032CE
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgFVJFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:05:09 -0400
Received: from foss.arm.com ([217.140.110.172]:59368 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgFVJFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 05:05:09 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E1311FB;
        Mon, 22 Jun 2020 02:05:08 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70AF23F6CF;
        Mon, 22 Jun 2020 02:05:06 -0700 (PDT)
Date:   Mon, 22 Jun 2020 10:04:59 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 1/5] KVM: arm64: Enable Address Authentication at EL2
 if available
Message-ID: <20200622090459.GA88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622080643.171651-2-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 09:06:39AM +0100, Marc Zyngier wrote:
> While initializing EL2, enable Address Authentication if detected
> from EL1. We still use the EL1-provided keys though.
> 
> Acked-by: Andrew Scull <ascull@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/hyp-init.S | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
> index 6e6ed5581eed..1587d146726a 100644
> --- a/arch/arm64/kvm/hyp-init.S
> +++ b/arch/arm64/kvm/hyp-init.S
> @@ -104,6 +104,11 @@ alternative_else_nop_endif
>  	 */
>  	mov_q	x4, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
>  CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
> +alternative_if ARM64_HAS_ADDRESS_AUTH
> +	mov_q	x5, (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
> +		     SCTLR_ELx_ENDA | SCTLR_ELx_ENDB)
> +	orr	x4, x4, x5
> +alternative_else_nop_endif
>  	msr	sctlr_el2, x4
>  	isb
>  
> -- 
> 2.27.0
> 
