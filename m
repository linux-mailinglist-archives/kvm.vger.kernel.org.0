Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9D3345C7A
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 12:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhCWLJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 07:09:29 -0400
Received: from foss.arm.com ([217.140.110.172]:44046 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhCWLJC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 07:09:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94F711042;
        Tue, 23 Mar 2021 04:09:01 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1ABBA3F719;
        Tue, 23 Mar 2021 04:09:00 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests v2] arm/arm64: Zero BSS and stack at
 startup
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>
References: <20210322162721.108514-1-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <ac1705ed-904b-6b99-4357-6b8cedd66bb2@arm.com>
Date:   Tue, 23 Mar 2021 11:09:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322162721.108514-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 3/22/21 4:27 PM, Andrew Jones wrote:
> So far we've counted on QEMU or kvmtool implicitly zeroing all memory.
> With our goal of eventually supporting bare-metal targets with
> target-efi we should explicitly zero any memory we expect to be zeroed
> ourselves. This obviously includes the BSS, but also the bootcpu's
> stack, as the bootcpu's thread-info lives in the stack and may get
> used in early setup to get the cpu index. Note, this means we still
> assume the bootcpu's cpu index to be zero. That assumption can be
> removed later.
>
> Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S   | 20 ++++++++++++++++++++
>  arm/cstart64.S | 22 +++++++++++++++++++++-
>  arm/flat.lds   |  4 ++++
>  3 files changed, 45 insertions(+), 1 deletion(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index ef936ae2f874..9eb11ba4dcaf 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -15,12 +15,32 @@
>  
>  #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
>  
> +.macro zero_range, tmp1, tmp2, tmp3, tmp4

tmp1 and tmp2 could be renamed to start and end (same for arm64), but the macro is
nice and simple, and it's also pretty clear what the arguments represent from the
call sites. Looks good either way:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

> +	mov	\tmp3, #0
> +	mov	\tmp4, #0
> +9998:	cmp	\tmp1, \tmp2
> +	beq	9997f
> +	strd	\tmp3, \tmp4, [\tmp1], #8
> +	b	9998b
> +9997:
> +.endm
> +
>  .arm
>  
>  .section .init
>  
>  .globl start
>  start:
> +	/* zero BSS */
> +	ldr	r4, =bss
> +	ldr	r5, =ebss
> +	zero_range r4, r5, r6, r7
> +
> +	/* zero stack */
> +	ldr	r5, =stacktop
> +	sub	r4, r5, #THREAD_SIZE
> +	zero_range r4, r5, r6, r7
> +
>  	/*
>  	 * set stack, making room at top of stack for cpu0's
>  	 * exception stacks. Must start wtih stackptr, not
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 0428014aa58a..2a691f8f5065 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -12,6 +12,15 @@
>  #include <asm/processor.h>
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
> +#include <asm/thread_info.h>
> +
> +.macro zero_range, tmp1, tmp2
> +9998:	cmp	\tmp1, \tmp2
> +	b.eq	9997f
> +	stp	xzr, xzr, [\tmp1], #16
> +	b	9998b
> +9997:
> +.endm
>  
>  .section .init
>  
> @@ -51,7 +60,18 @@ start:
>  	b	1b
>  
>  1:
> -	/* set up stack */
> +	/* zero BSS */
> +	adrp	x4, bss
> +	add	x4, x4, :lo12:bss
> +	adrp    x5, ebss
> +	add     x5, x5, :lo12:ebss
> +	zero_range x4, x5
> +
> +	/* zero and set up stack */
> +	adrp    x5, stacktop
> +	add     x5, x5, :lo12:stacktop
> +	sub	x4, x5, #THREAD_SIZE
> +	zero_range x4, x5
>  	mov	x4, #1
>  	msr	spsel, x4
>  	isb
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 25f8d03cba87..4d43cdfeab41 100644
> --- a/arm/flat.lds
> +++ b/arm/flat.lds
> @@ -17,7 +17,11 @@ SECTIONS
>  
>      .rodata   : { *(.rodata*) }
>      .data     : { *(.data) }
> +    . = ALIGN(16);
> +    PROVIDE(bss = .);
>      .bss      : { *(.bss) }
> +    . = ALIGN(16);
> +    PROVIDE(ebss = .);
>      . = ALIGN(64K);
>      PROVIDE(edata = .);
>  
