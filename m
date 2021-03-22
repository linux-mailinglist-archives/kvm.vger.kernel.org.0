Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D7E3449C4
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhCVPwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:52:14 -0400
Received: from foss.arm.com ([217.140.110.172]:34070 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230032AbhCVPvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:51:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C2A81042;
        Mon, 22 Mar 2021 08:51:48 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 83C063F719;
        Mon, 22 Mar 2021 08:51:47 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: Zero BSS and stack at startup
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>
References: <20210322121058.62072-1-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <38a908f6-1c7c-ee10-08ac-7204db2b54fc@arm.com>
Date:   Mon, 22 Mar 2021 15:52:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322121058.62072-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 3/22/21 12:10 PM, Andrew Jones wrote:
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
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S   | 22 ++++++++++++++++++++++
>  arm/cstart64.S | 23 ++++++++++++++++++++++-
>  arm/flat.lds   |  6 ++++++
>  3 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index ef936ae2f874..6de461ef94bf 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -15,12 +15,34 @@
>  
>  #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
>  
> +.macro zero_range, tmp1, tmp2, tmp3, tmp4
> +	mov	\tmp3, #0
> +	mov	\tmp4, #0
> +9998:	cmp	\tmp1, \tmp2
> +	beq	9997f
> +	strd	\tmp3, \tmp4, [\tmp1]
> +	add	\tmp1, \tmp1, #8

This could use post-indexed addressing and the add instruction could be removed.
Same for arm64.

> +	b	9998b
> +9997:
> +.endm
> +
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
> +	ldr	r4, =stackbase
> +	ldr	r5, =stacktop
> +	zero_range r4, r5, r6, r7
> +
>  	/*
>  	 * set stack, making room at top of stack for cpu0's
>  	 * exception stacks. Must start wtih stackptr, not
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 0428014aa58a..4dc5989ef50c 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -13,6 +13,15 @@
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
>  
> +.macro zero_range, tmp1, tmp2
> +9998:	cmp	\tmp1, \tmp2
> +	b.eq	9997f
> +	stp	xzr, xzr, [\tmp1]
> +	add	\tmp1, \tmp1, #16
> +	b	9998b
> +9997:
> +.endm
> +
>  .section .init
>  
>  /*
> @@ -51,7 +60,19 @@ start:
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
> +	adrp	x4, stackbase
> +	add	x4, x4, :lo12:stackbase
> +	adrp    x5, stacktop
> +	add     x5, x5, :lo12:stacktop
> +	zero_range x4, x5
>  	mov	x4, #1
>  	msr	spsel, x4
>  	isb
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 25f8d03cba87..8eab3472e2f2 100644
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
> @@ -26,6 +30,8 @@ SECTIONS
>       * sp must be 16 byte aligned for arm64, and 8 byte aligned for arm
>       * sp must always be strictly less than the true stacktop
>       */
> +    . = ALIGN(16);
> +    PROVIDE(stackbase = .);

This is correct, but strictly speaking, current_thread_info() accesses stacktop -
THREAD_SIZE, which is at most 64k. Is it worth declaring it after we add 644 and
we align it, something like this:

PROVIDE(stackbase = . - 64K)

Or maybe we shouldn't even create a variable for the base of the stack, and
compute it in cstart{,64}.S as stacktop - THREAD_SIZE? That could make the boot
process a tiny bit faster in some cases.

Thanks,

Alex

>      . += 64K;
>      . = ALIGN(64K);
>      PROVIDE(stackptr = . - 16);
