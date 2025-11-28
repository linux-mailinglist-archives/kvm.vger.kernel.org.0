Return-Path: <kvm+bounces-64938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D41C926D6
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 16:12:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4912C3ADACE
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 15:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E3932ED2F;
	Fri, 28 Nov 2025 15:12:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF9830BBB7
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764342727; cv=none; b=cvumi9NQ3QV49EXNIQwMwcUojoMtIjJ8MI2I4DojeYatnDWYU6D0oypIaMVHq3pqc+R4IubyPDeXlCOFJvv9lOKEETazsJdfvWDboDjNJESLryvhZp7oWzUGo+CV2imX/deno0eszgLV3j1PdPYA4WyMokSOJxC88WskSPUwgQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764342727; c=relaxed/simple;
	bh=1vkMm7X0ag8wG1nlAVMaE/y+4Yp/YeEYLUVV56D4qGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fp6POwOousabO22THEPLGEXpxw9c0kK49bs9qX+VsRfbpks2VgJ0yCdrtomwuWqNkfLaHrm+5N293mIQJLIg6eD/pqkw4VAXsOlogtebVCrOGiw4oSZfsxfqeO9z9UhjONG+88+dJ42mTlJRh71zkIJuUBeuJUprDbwovnE5ei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16D59176A;
	Fri, 28 Nov 2025 07:11:56 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 334A83F66E;
	Fri, 28 Nov 2025 07:12:02 -0800 (PST)
Date: Fri, 28 Nov 2025 15:11:16 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
	kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 01/10] arm64: drop to EL1 if booted at
 EL2
Message-ID: <20251128151116.GA3391839@e124191.cambridge.arm.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-2-joey.gouly@arm.com>
 <e4ffc74b-ae94-4304-9985-7e1f2df2767f@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4ffc74b-ae94-4304-9985-7e1f2df2767f@redhat.com>

On Thu, Nov 27, 2025 at 06:07:27PM +0100, Eric Auger wrote:
> Hi Joey,
> 
> On 9/25/25 4:19 PM, Joey Gouly wrote:
> > EL2 is not currently supported, drop to EL1 to conitnue booting.
> continue
> >
> > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > ---
> >  arm/cstart64.S         | 47 +++++++++++++++++++++++++++++++++++++++---
> >  lib/arm64/asm/sysreg.h | 14 +++++++++++++
> >  2 files changed, 58 insertions(+), 3 deletions(-)
> >
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index 014c9c7b..79b93dd4 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -15,6 +15,46 @@
> >  #include <asm/thread_info.h>
> >  #include <asm/sysreg.h>
> >  
> > +.macro init_el, tmp
> 
> init_el2? but also likely to fall back to EL1. At least add a doc comment to explain what the function does.
> 
> > +	mrs	\tmp, CurrentEL
> > +	cmp	\tmp, CurrentEL_EL2
> > +	b.ne	1f
> > +	/* EL2 setup */
> > +	mrs	\tmp, mpidr_el1
> > +	msr	vmpidr_el2, \tmp
> > +	mrs	\tmp, midr_el1
> > +	msr	vpidr_el2, \tmp
> > +	/* clear trap registers */
> clear FGT registers if FGT feature supported
> > +	mrs	\tmp, id_aa64mmfr0_el1
> > +	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> > +	cbz	\tmp, .Lskip_fgt_\@
> > +	mov	\tmp, #0
> > +	msr_s	SYS_HFGRTR_EL2, \tmp
> > +	msr_s	SYS_HFGWTR_EL2, \tmp
> > +	msr_s	SYS_HFGITR_EL2, \tmp
> > +	mrs	\tmp, id_aa64mmfr0_el1
> > +	ubfx	\tmp, \tmp, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> > +	cmp	\tmp, #ID_AA64MMFR0_EL1_FGT_FGT2
> > +	bne	.Lskip_fgt_\@
> > +	mov	\tmp, #0
> > +	msr_s	SYS_HFGRTR2_EL2, \tmp
> > +	msr_s	SYS_HFGWTR2_EL2, \tmp
> > +	msr_s	SYS_HFGITR2_EL2, \tmp
> > +.Lskip_fgt_\@:
> > +	mov	\tmp, #0
> > +	msr	cptr_el2, \tmp
> > +	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
> > +	msr	hcr_el2, \tmp
> > +	mov	\tmp, PSR_MODE_EL1t
> > +	msr	spsr_el2, \tmp
> > +	adrp	\tmp, 1f
> > +	add	\tmp, \tmp, :lo12:1f
> > +	msr	elr_el2, \tmp
> > +	eret
> > +1:
> > +.endm
> 
> I read in the coverletter you chose to not reuse include/asm/el2_setup.h
> which indeed would look overkill given the reduced scope that we target
> here. However compared to init_el2_state we seem to do very few things
> in the EL2 setup before switching to EL1. I would give a bit more info
> in the commit msg about what you keep and what you dropped and why it is
> reasonable (stage2, timers, debug at least).
> 
> > +
> > +
> >  #ifdef CONFIG_EFI
> >  #include "efi/crt0-efi-aarch64.S"
> >  #else
> > @@ -56,15 +96,15 @@ start:
> >  	add     x6, x6, :lo12:reloc_end
> >  1:
> >  	cmp	x5, x6
> > -	b.hs	1f
> > +	b.hs	reloc_done
> >  	ldr	x7, [x5]			// r_offset
> >  	ldr	x8, [x5, #16]			// r_addend
> >  	add	x8, x8, x4			// val = base + r_addend
> >  	str	x8, [x4, x7]			// base[r_offset] = val
> >  	add	x5, x5, #24
> >  	b	1b
> > -
> > -1:
> > +reloc_done:
> > +	init_el x4
> >  	/* zero BSS */
> >  	adrp	x4, bss
> >  	add	x4, x4, :lo12:bss
> > @@ -185,6 +225,7 @@ get_mmu_off:
> >  
> >  .globl secondary_entry
> >  secondary_entry:
> > +	init_el x0
> >  	/* enable FP/ASIMD and SVE */
> >  	mov	x0, #(3 << 20)
> >  	orr	x0, x0, #(3 << 16)
> > diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> > index e537bb46..ed776716 100644
> > --- a/lib/arm64/asm/sysreg.h
> > +++ b/lib/arm64/asm/sysreg.h
> > @@ -77,6 +77,9 @@ asm(
> >  #define ID_AA64ISAR0_EL1_RNDR_SHIFT	60
> >  #define ID_AA64PFR1_EL1_MTE_SHIFT	8
> >  
> > +#define ID_AA64MMFR0_EL1_FGT_SHIFT	56
> > +#define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
> > +
> >  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> >  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
> >  #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> > @@ -113,6 +116,17 @@ asm(
> >  #define SCTLR_EL1_TCF0_SHIFT	38
> >  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
> >  
> > +#define HCR_EL2_RW		_BITULL(31)
> > +
> > +#define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)
> 
> I don't really understand the renaming

It's just a define similar to INIT_HCR_EL2, that's added in patch 9.

> 
> > +
> > +#define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
> > +#define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)
> > +#define SYS_HFGITR_EL2		sys_reg(3, 4, 1, 1, 6)
> > +#define SYS_HFGRTR2_EL2		sys_reg(3, 4, 3, 1, 2)
> > +#define SYS_HFGWTR2_EL2		sys_reg(3, 4, 3, 1, 3)
> > +#define SYS_HFGITR2_EL2		sys_reg(3, 4, 3, 1, 7)
> > +
> >  #define INIT_SCTLR_EL1_MMU_OFF	\
> >  			(SCTLR_EL1_ITD | SCTLR_EL1_SED | SCTLR_EL1_EOS | \
> >  			 SCTLR_EL1_TSCXT | SCTLR_EL1_EIS | SCTLR_EL1_SPAN | \
> Thanks
> 
> Eric
> 

Thanks,
Joey

