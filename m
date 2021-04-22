Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4160A368379
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 17:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbhDVPhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 11:37:34 -0400
Received: from foss.arm.com ([217.140.110.172]:52924 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237944AbhDVPhd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 11:37:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F8BF13A1;
        Thu, 22 Apr 2021 08:36:58 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0AD43F73B;
        Thu, 22 Apr 2021 08:36:57 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2 1/8] arm/arm64: Reorganize cstart
 assembler
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210420190002.383444-1-drjones@redhat.com>
 <20210420190002.383444-2-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e0a23c7c-d9e1-676f-d7d5-956d93825bb9@arm.com>
Date:   Thu, 22 Apr 2021 16:37:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420190002.383444-2-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/20/21 7:59 PM, Andrew Jones wrote:
> Move secondary_entry helper functions out of .init and into .text,
> since secondary_entry isn't run at at "init" time. Actually, anything
> that is used after init time should be in .text, as we may not include
> .init in some build configurations.
>
> Reviewed-by Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S   | 66 +++++++++++++++++++++++++++++---------------------
>  arm/cstart64.S | 18 ++++++++------
>  2 files changed, 49 insertions(+), 35 deletions(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index d88a98362940..b2c0ba061cd5 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -96,32 +96,7 @@ start:
>  	bl	exit
>  	b	halt
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
>  enable_vfp:
>  	/* Enable full access to CP10 and CP11: */
> @@ -133,8 +108,6 @@ enable_vfp:
>  	vmsr	fpexc, r0
>  	mov	pc, lr
>  
> -.text
> -
>  .global get_mmu_off
>  get_mmu_off:
>  	ldr	r0, =auxinfo
> @@ -235,6 +208,43 @@ asm_mmu_disable:
>  
>  	mov     pc, lr
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
> +/*
> + * exceptions_init
> + *
> + * Input r0 is the stack top, which is the exception stacks base
> + */
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
>  /*
>   * Vector stubs
>   * Simplified version of the Linux kernel implementation
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 0a85338bcdae..7963e1fea979 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -109,13 +109,6 @@ start:
>  	bl	exit
>  	b	halt
>  
> -exceptions_init:
> -	adrp	x4, vector_table
> -	add	x4, x4, :lo12:vector_table
> -	msr	vbar_el1, x4
> -	isb
> -	ret
> -
>  .text
>  
>  .globl get_mmu_off
> @@ -251,6 +244,17 @@ asm_mmu_disable:
>  
>  /*
>   * Vectors
> + */
> +
> +exceptions_init:
> +	adrp	x4, vector_table
> +	add	x4, x4, :lo12:vector_table
> +	msr	vbar_el1, x4
> +	isb
> +	ret
> +
> +/*
> + * Vector stubs
>   * Adapted from arch/arm64/kernel/entry.S
>   */
>  .macro vector_stub, name, vec

The diff looks nice and clean, exactly what you want from a straightforward move.
I checked that the new code matches the old one, but for arm I haven't checked
that the code is correct, because I'm not familiar with arm assembly. I also
compiled for arm and arm64:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

