Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB9638B56A
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 19:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235118AbhETRrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 13:47:02 -0400
Received: from foss.arm.com ([217.140.110.172]:56404 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230339AbhETRrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 13:47:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2AC0411B3;
        Thu, 20 May 2021 10:45:39 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF6BF3F719;
        Thu, 20 May 2021 10:45:37 -0700 (PDT)
Subject: Re: [PATCH v3 2/9] KVM: arm64: Handle physical FIQ as an IRQ while
 running a guest
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
References: <20210510134824.1910399-1-maz@kernel.org>
 <20210510134824.1910399-3-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2311e75e-589c-4602-e81f-c639e7a33bd9@arm.com>
Date:   Thu, 20 May 2021 18:46:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210510134824.1910399-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/10/21 2:48 PM, Marc Zyngier wrote:
> As we we now entertain the possibility of FIQ being used on the host,
> treat the signalling of a FIQ while running a guest as an IRQ,
> causing an exit instead of a HYP panic.

I've mulling over this, and I can't find anything wrong with it. Any FIQs for
which there is no handler registered by the interrupt controller will panic in the
default_handle_fiq() FIQ handler, similar to the current KVM behaviour. And if
there is a handler registered (only AIC does it for now), then a FIQ will be
handled just like any other interrupt instead of KVM panic'ing when the host can
handle it just fine.

I've briefly considered creating a new return code from __kvm_vcpu_run,
ARM_EXCEPTION_FIQ, but I really don't see any reason for it, since it will serve
the same purpose as ARM_EXCEPTION_IRQ, which is to resume the guest without any
special exit handling.

It makes sense to me for KVM to handle FIQs just like IRQs, now that the kernel
treats them the same:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/hyp-entry.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
> index 5f49df4ffdd8..9aa9b73475c9 100644
> --- a/arch/arm64/kvm/hyp/hyp-entry.S
> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
> @@ -76,6 +76,7 @@ el1_trap:
>  	b	__guest_exit
>  
>  el1_irq:
> +el1_fiq:
>  	get_vcpu_ptr	x1, x0
>  	mov	x0, #ARM_EXCEPTION_IRQ
>  	b	__guest_exit
> @@ -131,7 +132,6 @@ SYM_CODE_END(\label)
>  	invalid_vector	el2t_error_invalid
>  	invalid_vector	el2h_irq_invalid
>  	invalid_vector	el2h_fiq_invalid
> -	invalid_vector	el1_fiq_invalid
>  
>  	.ltorg
>  
> @@ -179,12 +179,12 @@ SYM_CODE_START(__kvm_hyp_vector)
>  
>  	valid_vect	el1_sync		// Synchronous 64-bit EL1
>  	valid_vect	el1_irq			// IRQ 64-bit EL1
> -	invalid_vect	el1_fiq_invalid		// FIQ 64-bit EL1
> +	valid_vect	el1_fiq			// FIQ 64-bit EL1
>  	valid_vect	el1_error		// Error 64-bit EL1
>  
>  	valid_vect	el1_sync		// Synchronous 32-bit EL1
>  	valid_vect	el1_irq			// IRQ 32-bit EL1
> -	invalid_vect	el1_fiq_invalid		// FIQ 32-bit EL1
> +	valid_vect	el1_fiq			// FIQ 32-bit EL1
>  	valid_vect	el1_error		// Error 32-bit EL1
>  SYM_CODE_END(__kvm_hyp_vector)
>  
