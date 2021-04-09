Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B2F35A480
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbhDIRS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:18:26 -0400
Received: from foss.arm.com ([217.140.110.172]:55682 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhDIRSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 13:18:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E7C71FB;
        Fri,  9 Apr 2021 10:18:08 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 970FB3F792;
        Fri,  9 Apr 2021 10:18:07 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/8] arm/arm64: Reorganize cstart assembler
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-2-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <cd8f7e2a-9d53-6793-a0dd-bf58ab491ad1@arm.com>
Date:   Fri, 9 Apr 2021 18:18:05 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/2021 19:59, Andrew Jones wrote:
> Move secondary_entry helper functions out of .init and into .text,
> since secondary_entry isn't run at "init" time.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>   arm/cstart.S   | 62 +++++++++++++++++++++++++++-----------------------
>   arm/cstart64.S | 22 +++++++++++-------
>   2 files changed, 48 insertions(+), 36 deletions(-)
> 
> diff --git a/arm/cstart.S b/arm/cstart.S
> index d88a98362940..653ab1e8a141 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -96,32 +96,7 @@ start:
>   	bl	exit
>   	b	halt
>   
> -
> -.macro set_mode_stack mode, stack
> -	add	\stack, #S_FRAME_SIZE
> -	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> -	isb
> -	mov	sp, \stack
> -.endm
> -
> -exceptions_init:
> -	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> -	bic	r2, #CR_V		@ SCTLR.V := 0
> -	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> -	ldr	r2, =vector_table
> -	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> -
> -	mrs	r2, cpsr
> -
> -	/* first frame reserved for svc mode */
> -	set_mode_stack	UND_MODE, r0
> -	set_mode_stack	ABT_MODE, r0
> -	set_mode_stack	IRQ_MODE, r0
> -	set_mode_stack	FIQ_MODE, r0
> -
> -	msr	cpsr_cxsf, r2		@ back to svc mode
> -	isb
> -	mov	pc, lr
> +.text
>   
>   enable_vfp:
>   	/* Enable full access to CP10 and CP11: */
> @@ -133,8 +108,6 @@ enable_vfp:
>   	vmsr	fpexc, r0
>   	mov	pc, lr
>   
> -.text
> -
>   .global get_mmu_off
>   get_mmu_off:
>   	ldr	r0, =auxinfo
> @@ -235,6 +208,39 @@ asm_mmu_disable:
>   
>   	mov     pc, lr
>   
> +/*
> + * Vectors
> + */
> +
> +.macro set_mode_stack mode, stack
> +	add	\stack, #S_FRAME_SIZE
> +	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
> +	isb
> +	mov	sp, \stack
> +.endm
> +
> +exceptions_init:
> +	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
> +	bic	r2, #CR_V		@ SCTLR.V := 0
> +	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
> +	ldr	r2, =vector_table
> +	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
> +
> +	mrs	r2, cpsr
> +
> +	/*
> +	 * Input r0 is the stack top, which is the exception stacks base

Minor, feel free to ignore - wouldn't it be better to put this comment 
at the start of this routine to inform the caller?

I am not sure about the practical implications of having an .init 
section but in any case, moving secondary_entry helper functions to 
.text seems sensible.

Reviewed-by Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

> +	 * The first frame is reserved for svc mode
> +	 */
> +	set_mode_stack	UND_MODE, r0
> +	set_mode_stack	ABT_MODE, r0
> +	set_mode_stack	IRQ_MODE, r0
> +	set_mode_stack	FIQ_MODE, r0
> +
> +	msr	cpsr_cxsf, r2		@ back to svc mode
> +	isb
> +	mov	pc, lr
> +
>   /*
>    * Vector stubs
>    * Simplified version of the Linux kernel implementation
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 0a85338bcdae..d39cf4dfb99c 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -89,10 +89,12 @@ start:
>   	msr	cpacr_el1, x4
>   
>   	/* set up exception handling */
> +	mov	x4, x0				// x0 is the addr of the dtb
>   	bl	exceptions_init
>   
>   	/* complete setup */
> -	bl	setup				// x0 is the addr of the dtb
> +	mov	x0, x4				// restore the addr of the dtb
> +	bl	setup
>   	bl	get_mmu_off
>   	cbnz	x0, 1f
>   	bl	setup_vm
> @@ -109,13 +111,6 @@ start:
>   	bl	exit
>   	b	halt
>   
> -exceptions_init:
> -	adrp	x4, vector_table
> -	add	x4, x4, :lo12:vector_table
> -	msr	vbar_el1, x4
> -	isb
> -	ret
> -
>   .text
>   
>   .globl get_mmu_off
> @@ -251,6 +246,17 @@ asm_mmu_disable:
>   
>   /*
>    * Vectors
> + */
> +
> +exceptions_init:
> +	adrp	x0, vector_table
> +	add	x0, x0, :lo12:vector_table
> +	msr	vbar_el1, x0
> +	isb
> +	ret
> +
> +/*
> + * Vector stubs
>    * Adapted from arch/arm64/kernel/entry.S
>    */
>   .macro vector_stub, name, vec
> 
