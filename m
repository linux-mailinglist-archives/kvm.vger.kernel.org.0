Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4353037BE6B
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 15:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhELNpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 09:45:03 -0400
Received: from foss.arm.com ([217.140.110.172]:39418 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230037AbhELNpD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 09:45:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B061B6D;
        Wed, 12 May 2021 06:43:54 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 523793F718;
        Wed, 12 May 2021 06:43:54 -0700 (PDT)
Subject: Re: [PATCH v2 kvm-unit-tests 2/2] arm: add eabi version of 64-bit
 division functions
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210512105440.748153-1-pbonzini@redhat.com>
 <20210512105440.748153-3-pbonzini@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e1aa58da-c4c9-6bb0-3aef-f17c12349577@arm.com>
Date:   Wed, 12 May 2021 14:44:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210512105440.748153-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 5/12/21 11:54 AM, Paolo Bonzini wrote:
> eabi prescribes different entry points for 64-bit division on
> 32-bit platforms.  Implement a wrapper for the GCC-style __divmoddi4
> and __udivmoddi4 functions.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arm/Makefile.arm  |  1 +
>  lib/arm/ldivmod.S | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>  create mode 100644 lib/arm/ldivmod.S
>
> diff --git a/arm/Makefile.arm b/arm/Makefile.arm
> index 687a8ed..3a4cc6b 100644
> --- a/arm/Makefile.arm
> +++ b/arm/Makefile.arm
> @@ -24,6 +24,7 @@ cflatobjs += lib/arm/spinlock.o
>  cflatobjs += lib/arm/processor.o
>  cflatobjs += lib/arm/stack.o
>  cflatobjs += lib/ldiv32.o
> +cflatobjs += lib/arm/ldivmod.o
>  
>  # arm specific tests
>  tests =
> diff --git a/lib/arm/ldivmod.S b/lib/arm/ldivmod.S
> new file mode 100644
> index 0000000..de11ac9
> --- /dev/null
> +++ b/lib/arm/ldivmod.S
> @@ -0,0 +1,32 @@
> +// EABI ldivmod and uldivmod implementation based on libcompiler-rt
> +//
> +// This file is dual licensed under the MIT and the University of Illinois Open
> +// Source Licenses.

At first I was confused about the prototype for these functions, but I suppose
they are the functions defined by [1] and [2], and they take a two int64
arguments, the numerator and the denominator.

[1]
https://android.googlesource.com/toolchain/compiler-rt/+/refs/heads/master/lib/builtins/arm/aeabi_uldivmod.S
[2]
https://android.googlesource.com/toolchain/compiler-rt/+/refs/heads/master/lib/builtins/arm/aeabi_ldivmod.S
> +
> +	.syntax unified
> +	.align 2
> +	.globl __aeabi_uldivmod
> +	.type __aeabi_uldivmod, %function
> +__aeabi_uldivmod:
> +	push	{r11, lr}
> +	sub	sp, sp, #16
> +	add	r12, sp, #8
> +	str	r12, [sp]                // third argument to __udivmoddi4

The way we call __udivmoddi4 looks correct to me. We make room on the stack to
store the remainder, and push that address at the top of the stack so it can be
used by the function as the third argument

> +	bl	__udivmoddi4
> +	ldr	r2, [sp, #8]             // remainder returned in r2-r3
> +	ldr	r3, [sp, #12]
> +	add	sp, sp, #16
> +	pop	{r11, pc}

I'm not sure what is going on here. Is the function returning 2 64bit arguments as
an 128bit vector? Or is the function being called from assembly and this is a
convention between it and the caller? I did a grep in the compiler-rt repo for
__aeabi_uldivmod and couldn't find any uses.

Other than my confusion about the return value, both functions match the
compiler-rt definitions.

Thanks,

Alex

> +
> +	.globl __aeabi_ldivmod
> +	.type __aeabi_ldivmod, %function
> +__aeabi_ldivmod:
> +	push	{r11, lr}
> +	sub	sp, sp, #16
> +	add	r12, sp, #8
> +	str	r12, [sp]                // third argument to __divmoddi4
> +	bl	__divmoddi4
> +	ldr	r2, [sp, #8]             // remainder returned in r2-r3
> +	ldr	r3, [sp, #12]
> +	add	sp, sp, #16
> +	pop	{r11, pc}
