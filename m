Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C534CD653
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 15:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbiCDO20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 09:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiCDO2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 09:28:24 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 84BAEB9D
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 06:27:32 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 562451424;
        Fri,  4 Mar 2022 06:27:32 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.22.160])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 109173F70D;
        Fri,  4 Mar 2022 06:27:30 -0800 (PST)
Date:   Fri, 4 Mar 2022 14:27:22 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH] KVM: arm64: Only open the interrupt window on exit due
 to an interrupt
Message-ID: <YiIekBoAJqz4rI+Q@FVFF77S0Q05N>
References: <20220304135914.1464721-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304135914.1464721-1-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 01:59:14PM +0000, Marc Zyngier wrote:
> Now that we properly account for interrupts taken whilst the guest
> was running, it becomes obvious that there is no need to open
> this accounting window if we didn't exit because of an interrupt.
> 
> This saves a number of system register accesses and other barriers
> if we exited for any other reason (such as a trap, for example).
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kvm/arm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index fefd5774ab55..f49ebdd9c990 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -887,9 +887,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		 * context synchronization event) is necessary to ensure that
>  		 * pending interrupts are taken.
>  		 */
> -		local_irq_enable();
> -		isb();
> -		local_irq_disable();
> +		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
> +			local_irq_enable();
> +			isb();
> +			local_irq_disable();
> +		}
>  
>  		guest_timing_exit_irqoff();
>  
> -- 
> 2.34.1
> 
