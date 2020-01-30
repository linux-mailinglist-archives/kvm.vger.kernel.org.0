Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3314E00F
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 18:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgA3RkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 12:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgA3RkI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 12:40:08 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 080372083E;
        Thu, 30 Jan 2020 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580406007;
        bh=yR5hJFQwhragqRNRWC6IRUDBK/JgRFAWVTPBd2ZK8Fs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zOLUGBxh2CAVvpQxtgUHTJKkCLMZRiL7+WVv9Z0DKdt0Tnw2Y8/os0NqKsl1jtXUw
         JNA3QNmVRkYAzTiAIjR/nkY+GOgYdec/FmFBomNnMYPWf/ClJFtJJcGKToCF/i0ZjI
         rhPrXLxKPLwRslWJ3vlYKh0UpK/UMVEhH04/7Hrc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1ixDnR-002ENP-Ap; Thu, 30 Jan 2020 17:40:05 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Jan 2020 17:40:05 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH v3 5/7] lib: arm64: Add support for
 disabling and re-enabling VHE
In-Reply-To: <1577972806-16184-6-git-send-email-alexandru.elisei@arm.com>
References: <1577972806-16184-1-git-send-email-alexandru.elisei@arm.com>
 <1577972806-16184-6-git-send-email-alexandru.elisei@arm.com>
Message-ID: <ad46bedcc585d03399576ecfce4c17c0@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com, andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 2020-01-02 13:46, Alexandru Elisei wrote:
> Add a function to disable VHE and another one to re-enable VHE. Both
> functions work under the assumption that the CPU had VHE mode enabled 
> at
> boot.
> 
> Minimal support to run with VHE has been added to the TLB invalidate
> functions and to the exception handling code.
> 
> Since we're touch the assembly enable/disable MMU code, let's take this
> opportunity to replace a magic number with the proper define.

I've been using this test case to debug my NV code... only to realize
after a few hours of banging my head on the wall that it is the test
that needed debugging, see below... ;-)

> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm64/asm/mmu.h           |  11 ++-
>  lib/arm64/asm/pgtable-hwdef.h |  53 ++++++++---
>  lib/arm64/asm/processor.h     |  19 +++-
>  lib/arm64/processor.c         |  37 +++++++-
>  arm/cstart64.S                | 204 
> ++++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 300 insertions(+), 24 deletions(-)

[...]

> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -104,6 +104,13 @@ exceptions_init:
> 
>  .text
> 
> +exceptions_init_nvhe:
> +	adrp	x0, vector_table_nvhe
> +	add	x0, x0, :lo12:vector_table_nvhe
> +	msr	vbar_el2, x0
> +	isb
> +	ret
> +
>  .globl get_mmu_off
>  get_mmu_off:
>  	adrp	x0, auxinfo
> @@ -203,7 +210,7 @@ asm_mmu_enable:
>  		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
>  		     TCR_SHARED
>  	mrs	x2, id_aa64mmfr0_el1
> -	bfi	x1, x2, #32, #3
> +	bfi	x1, x2, #TCR_EL1_IPS_SHIFT, #3
>  	msr	tcr_el1, x1
> 
>  	/* MAIR */
> @@ -228,6 +235,41 @@ asm_mmu_enable:
> 
>  	ret
> 
> +asm_mmu_enable_nvhe:

Note the "_nvhe" suffix, which implies that...

> +	tlbi    alle2
> +	dsb     nsh
> +
> +        /* TCR */
> +	ldr	x1, =TCR_EL2_RES1 | 			\
> +		     TCR_T0SZ(VA_BITS) |		\
> +		     TCR_TG0_64K |                      \
> +		     TCR_IRGN0_WBWA | TCR_ORGN0_WBWA |	\
> +		     TCR_SH0_IS
> +	mrs	x2, id_aa64mmfr0_el1
> +	bfi	x1, x2, #TCR_EL2_PS_SHIFT, #3
> +	msr	tcr_el2, x1
> +
> +	/* Same MAIR and TTBR0 as in VHE mode */
> +	ldr	x1, =MAIR(0x00, MT_DEVICE_nGnRnE) |	\
> +		     MAIR(0x04, MT_DEVICE_nGnRE) |	\
> +		     MAIR(0x0c, MT_DEVICE_GRE) |	\
> +		     MAIR(0x44, MT_NORMAL_NC) |		\
> +		     MAIR(0xff, MT_NORMAL)
> +	msr	mair_el1, x1

... this should be mair_el2...

> +
> +	msr	ttbr0_el1, x0

... and this should be ttbr0_el2.

> +	isb
> +
> +	/* SCTLR */
> +	ldr	x1, =SCTLR_EL2_RES1 |			\
> +		     SCTLR_EL2_C | 			\
> +		     SCTLR_EL2_I | 			\
> +		     SCTLR_EL2_M
> +	msr	sctlr_el2, x1
> +	isb
> +
> +	ret
> +
>  /* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
>  .macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
>  	adrp	\tmp1, dcache_line_size
> @@ -242,21 +284,61 @@ asm_mmu_enable:
>  	dsb	\domain
>  .endm
> 
> +clean_inval_cache:
> +	adrp	x0, __phys_offset
> +	ldr	x0, [x0, :lo12:__phys_offset]
> +	adrp	x1, __phys_end
> +	ldr	x1, [x1, :lo12:__phys_end]
> +	dcache_by_line_op civac, sy, x0, x1, x2, x3
> +	isb
> +	ret
> +
>  .globl asm_mmu_disable
>  asm_mmu_disable:
>  	mrs	x0, sctlr_el1
>  	bic	x0, x0, SCTLR_EL1_M
>  	msr	sctlr_el1, x0
>  	isb
> +	b	clean_inval_cache
> 
> -	/* Clean + invalidate the entire memory */
> -	adrp	x0, __phys_offset
> -	ldr	x0, [x0, :lo12:__phys_offset]
> -	adrp	x1, __phys_end
> -	ldr	x1, [x1, :lo12:__phys_end]
> -	dcache_by_line_op civac, sy, x0, x1, x2, x3
> +asm_mmu_disable_nvhe:
> +	mrs	x0, sctlr_el2
> +	bic	x0, x0, SCTLR_EL2_M
> +	msr	sctlr_el2, x0
> +	isb
> +	b	clean_inval_cache
> +
> +.globl asm_disable_vhe
> +asm_disable_vhe:
> +	str	x30, [sp, #-16]!
> +
> +	bl	asm_mmu_disable
> +	msr	hcr_el2, xzr
> +	isb

At this stage, VHE is off...

> +	bl	exceptions_init_nvhe
> +	/* Make asm_mmu_enable_nvhe happy by having TTBR0 value in x0. */
> +	mrs	x0, ttbr0_el1

... so this is going to sample the wrong TTBR. It really should be
TTBR0_EL2!

> +	isb

nit: this ISB is useless, as you will have a dependency on x0 anyway.

With these fixes (and a few more terrible hacks to synchronize HCR_EL2
on ARMv8.4-NV), I can run this test reliably.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
