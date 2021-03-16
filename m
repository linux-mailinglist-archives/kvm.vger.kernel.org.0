Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0080833D7D3
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhCPPkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:40:47 -0400
Received: from foss.arm.com ([217.140.110.172]:47100 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhCPPkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:40:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 03FC3D6E;
        Tue, 16 Mar 2021 08:40:25 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E10593F792;
        Tue, 16 Mar 2021 08:40:23 -0700 (PDT)
Date:   Tue, 16 Mar 2021 15:40:02 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 2/6] arm/arm64: Remove dcache_line_size
 global variable
Message-ID: <20210316154002.3d9e0575@slackpad.fritz.box>
In-Reply-To: <ce582839-edef-c055-b0a3-6261397b6b8d@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
        <20210227104201.14403-3-alexandru.elisei@arm.com>
        <20210304150031.7805c75e@slackpad.fritz.box>
        <ce582839-edef-c055-b0a3-6261397b6b8d@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 15 Mar 2021 15:46:09 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi Alex,

> On 3/4/21 3:00 PM, Andre Przywara wrote:
> > On Sat, 27 Feb 2021 10:41:57 +0000
> > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >  
> >> Compute the dcache line size when doing dcache maintenance instead of using
> >> a global variable computed in setup(), which allows us to do dcache
> >> maintenance at any point in the boot process. This will be useful for
> >> running as an EFI app and it also aligns our implementation to that of the
> >> Linux kernel.  
> > Can you add that this changes the semantic of dcache_by_line_op to use
> > the size instead of the end address?  
> 
> Sure, I can do that. The dcache_by_line_op was never visible to code outside
> assembly, and it was only used by asm_mmu_disable, so no other callers are
> affected by this change.

Thanks, just a short sentence suffices. I was just mentioning this
since many cache-op wrappers I have seen use (start,stop) pairs, while
I actually think (start,length) is more practical. So it just deserves
a short mentioning in case anyone was familiar with the previous
arguments and wonders what's going on.

> >  
> >> For consistency, the arm code has been similary modified.
> >>
> >> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >> ---
> >>  lib/arm/asm/assembler.h   | 44 ++++++++++++++++++++++++++++++++
> >>  lib/arm/asm/processor.h   |  7 ------
> >>  lib/arm64/asm/assembler.h | 53 +++++++++++++++++++++++++++++++++++++++
> >>  lib/arm64/asm/processor.h |  7 ------
> >>  lib/arm/setup.c           |  7 ------
> >>  arm/cstart.S              | 18 +++----------
> >>  arm/cstart64.S            | 16 ++----------
> >>  7 files changed, 102 insertions(+), 50 deletions(-)
> >>  create mode 100644 lib/arm/asm/assembler.h
> >>  create mode 100644 lib/arm64/asm/assembler.h
> >>
> >> diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
> >> new file mode 100644
> >> index 000000000000..6b932df86204
> >> --- /dev/null
> >> +++ b/lib/arm/asm/assembler.h
> >> @@ -0,0 +1,44 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +/*
> >> + * Based on several files from Linux version v5.10: arch/arm/mm/proc-macros.S,
> >> + * arch/arm/mm/proc-v7.S.
> >> + */
> >> +
> >> +/*
> >> + * dcache_line_size - get the minimum D-cache line size from the CTR register
> > `> + * on ARMv7.  
> 
> Well, it's in the arm directory and there's a file with the same name under
> lib/arm64/asm/, so I don't think there's any room for confusion here.

Mmh, this v7 line was already in there, and I didn't complain, it was
apparently just a stray character sneaking in the reply which made this
look like a comment?

> 
> >> + */
> >> +	.macro	dcache_line_size, reg, tmp
> >> +	mrc	p15, 0, \tmp, c0, c0, 1		// read ctr
> >> +	lsr	\tmp, \tmp, #16
> >> +	and	\tmp, \tmp, #0xf		// cache line size encoding
> >> +	mov	\reg, #4			// bytes per word
> >> +	mov	\reg, \reg, lsl \tmp		// actual cache line size
> >> +	.endm
> >> +
> >> +/*
> >> + * Macro to perform a data cache maintenance for the interval
> >> + * [addr, addr + size).
> >> + *
> >> + * 	op:		operation to execute
> >> + * 	domain		domain used in the dsb instruction
> >> + * 	addr:		starting virtual address of the region
> >> + * 	size:		size of the region
> >> + * 	Corrupts:	addr, size, tmp1, tmp2
> >> + */
> >> +	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
> >> +	dcache_line_size \tmp1, \tmp2
> >> +	add	\size, \addr, \size
> >> +	sub	\tmp2, \tmp1, #1
> >> +	bic	\addr, \addr, \tmp2  
> > Just a nit, but since my brain was in assembly land: We could skip tmp2,
> > by adding back #1 to tmp1 after the bic.
> > Same for the arm64 code.  
> 
> Using one less temporary register wouldn't help with register pressure:
> 
> - On arm, registers r0-r3 are used, which ARM IHI 0042F says that they can be used
> as scratch registers and the caller will save their contents before the calling
> the function (or not use them at all).
> 
> - On arm64, register x0-x3 are used, which have a similar usage according to ARM
> IHI 0055B.
> 
> Using one less temporary register means one more instruction, but not relevant
> since the macro will perform writes, as even invalidation is transformed to a
> clean + invalidate under virtualization.

I am not talking about micro-optimisation here, but this is a *macro*,
not a function, so could potentially be used in multiple different
places, for instance inside leaf functions. And maybe that already uses
two registers on its own, so can't spare three extra ones?

Was just a hint, anyway ...

> The reason I chose to keep the macro unchanged for arm64 is that it matches the
> Linux definition, and I think it's better to try not to deviate too much from it,
> as in the long it will make maintenance easier for everyone.

> For arm, I wrote it this way to match the arm64 definition.
> 
> >  
> >> +9998:
> >> +	.ifc	\op, dccimvac
> >> +	mcr	p15, 0, \addr, c7, c14, 1
> >> +	.else
> >> +	.err
> >> +	.endif
> >> +	add	\addr, \addr, \tmp1
> >> +	cmp	\addr, \size
> >> +	blo	9998b
> >> +	dsb	\domain
> >> +	.endm
> >> diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
> >> index 273366d1fe1c..3c36eac903f0 100644
> >> --- a/lib/arm/asm/processor.h
> >> +++ b/lib/arm/asm/processor.h
> >> @@ -9,11 +9,6 @@
> >>  #include <asm/sysreg.h>
> >>  #include <asm/barrier.h>  
> > Do we want the same protection against inclusion from C here as in the
> > arm64 version?  
> 
> We do, I will add it in the next iteration.
> 
> >  
> >> -#define CTR_DMINLINE_SHIFT	16
> >> -#define CTR_DMINLINE_MASK	(0xf << 16)
> >> -#define CTR_DMINLINE(x)	\
> >> -	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
> >> -
> >>  enum vector {
> >>  	EXCPTN_RST,
> >>  	EXCPTN_UND,
> >> @@ -89,6 +84,4 @@ static inline u32 get_ctr(void)
> >>  	return read_sysreg(CTR);
> >>  }
> >>  
> >> -extern unsigned long dcache_line_size;
> >> -
> >>  #endif /* _ASMARM_PROCESSOR_H_ */
> >> diff --git a/lib/arm64/asm/assembler.h b/lib/arm64/asm/assembler.h
> >> new file mode 100644
> >> index 000000000000..f801c0c43d02
> >> --- /dev/null
> >> +++ b/lib/arm64/asm/assembler.h
> >> @@ -0,0 +1,53 @@
> >> +/* SPDX-License-Identifier: GPL-2.0-only */
> >> +/*
> >> + * Based on the file arch/arm64/include/asm/assembled.h from Linux v5.10, which
> >> + * in turn is based on arch/arm/include/asm/assembler.h and
> >> + * arch/arm/mm/proc-macros.S
> >> + *
> >> + * Copyright (C) 1996-2000 Russell King
> >> + * Copyright (C) 2012 ARM Ltd.
> >> + */
> >> +#ifndef __ASSEMBLY__
> >> +#error "Only include this from assembly code"
> >> +#endif
> >> +
> >> +#ifndef __ASM_ASSEMBLER_H
> >> +#define __ASM_ASSEMBLER_H
> >> +
> >> +/*
> >> + * raw_dcache_line_size - get the minimum D-cache line size on this CPU
> >> + * from the CTR register.
> >> + */
> >> +	.macro	raw_dcache_line_size, reg, tmp
> >> +	mrs	\tmp, ctr_el0			// read CTR
> >> +	ubfm	\tmp, \tmp, #16, #19		// cache line size encoding  
> > this encoding of ubfm is supposed to be written as:
> > 	ubfx \tmp, \tmp, #16, #4
> > This is also what objdump makes of the above.  
> 
> I would rather keep it the same as Linux.

Which means I need to send a patch there? ;-)
I am all for copying from reliable sources, but that doesn't mean that
we can't improve on them.

The ARM ARM says that ubfx is the preferred disassembly for this opcode.
Plus there is a ubfx in AArch32 (with the exact same semantic and
arguments), but no ubfm.

It's just that my brain expects ubfx when extracting bits from a
register, and I needed to wade through the exact definition of ubfm to
understand what it does.

So your choice, just wanted to point that out.

Cheers,
Andre

> >
> > The rest looks good, I convinced myself that the assembly algorithms are
> > correct.  
> 
> Thanks, much appreciated!
> 
> Thanks,
> 
> Alex
> 
> >
> > Cheers,
> > Andre
> >
> >  
> >> +	mov	\reg, #4			// bytes per word
> >> +	lsl	\reg, \reg, \tmp		// actual cache line size
> >> +	.endm
> >> +
> >> +/*
> >> + * Macro to perform a data cache maintenance for the interval
> >> + * [addr, addr + size). Use the raw value for the dcache line size because
> >> + * kvm-unit-tests has no concept of scheduling.
> >> + *
> >> + * 	op:		operation passed to dc instruction
> >> + * 	domain:		domain used in dsb instruciton
> >> + * 	addr:		starting virtual address of the region
> >> + * 	size:		size of the region
> >> + * 	Corrupts:	addr, size, tmp1, tmp2
> >> + */
> >> +
> >> +	.macro dcache_by_line_op op, domain, addr, size, tmp1, tmp2
> >> +	raw_dcache_line_size \tmp1, \tmp2
> >> +	add	\size, \addr, \size
> >> +	sub	\tmp2, \tmp1, #1
> >> +	bic	\addr, \addr, \tmp2
> >> +9998:
> >> +	dc	\op, \addr
> >> +	add	\addr, \addr, \tmp1
> >> +	cmp	\addr, \size
> >> +	b.lo	9998b
> >> +	dsb	\domain
> >> +	.endm
> >> +
> >> +#endif	/* __ASM_ASSEMBLER_H */
> >> diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
> >> index 771b2d1e0c94..cdc2463e1981 100644
> >> --- a/lib/arm64/asm/processor.h
> >> +++ b/lib/arm64/asm/processor.h
> >> @@ -16,11 +16,6 @@
> >>  #define SCTLR_EL1_A	(1 << 1)
> >>  #define SCTLR_EL1_M	(1 << 0)
> >>  
> >> -#define CTR_DMINLINE_SHIFT	16
> >> -#define CTR_DMINLINE_MASK	(0xf << 16)
> >> -#define CTR_DMINLINE(x)	\
> >> -	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
> >> -
> >>  #ifndef __ASSEMBLY__
> >>  #include <asm/ptrace.h>
> >>  #include <asm/esr.h>
> >> @@ -115,8 +110,6 @@ static inline u64 get_ctr(void)
> >>  	return read_sysreg(ctr_el0);
> >>  }
> >>  
> >> -extern unsigned long dcache_line_size;
> >> -
> >>  static inline unsigned long get_id_aa64mmfr0_el1(void)
> >>  {
> >>  	return read_sysreg(id_aa64mmfr0_el1);
> >> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> >> index 066524f8bf61..751ba980000a 100644
> >> --- a/lib/arm/setup.c
> >> +++ b/lib/arm/setup.c
> >> @@ -42,8 +42,6 @@ static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
> >>  struct mem_region *mem_regions = __initial_mem_regions;
> >>  phys_addr_t __phys_offset, __phys_end;
> >>  
> >> -unsigned long dcache_line_size;
> >> -
> >>  int mpidr_to_cpu(uint64_t mpidr)
> >>  {
> >>  	int i;
> >> @@ -72,11 +70,6 @@ static void cpu_init(void)
> >>  	ret = dt_for_each_cpu_node(cpu_set, NULL);
> >>  	assert(ret == 0);
> >>  	set_cpu_online(0, true);
> >> -	/*
> >> -	 * DminLine is log2 of the number of words in the smallest cache line; a
> >> -	 * word is 4 bytes.
> >> -	 */
> >> -	dcache_line_size = 1 << (CTR_DMINLINE(get_ctr()) + 2);
> >>  }
> >>  
> >>  unsigned int mem_region_get_flags(phys_addr_t paddr)
> >> diff --git a/arm/cstart.S b/arm/cstart.S
> >> index ef936ae2f874..954748b00f64 100644
> >> --- a/arm/cstart.S
> >> +++ b/arm/cstart.S
> >> @@ -7,6 +7,7 @@
> >>   */
> >>  #define __ASSEMBLY__
> >>  #include <auxinfo.h>
> >> +#include <asm/assembler.h>
> >>  #include <asm/thread_info.h>
> >>  #include <asm/asm-offsets.h>
> >>  #include <asm/pgtable-hwdef.h>
> >> @@ -197,20 +198,6 @@ asm_mmu_enable:
> >>  
> >>  	mov     pc, lr
> >>  
> >> -.macro dcache_clean_inval domain, start, end, tmp1, tmp2
> >> -	ldr	\tmp1, =dcache_line_size
> >> -	ldr	\tmp1, [\tmp1]
> >> -	sub	\tmp2, \tmp1, #1
> >> -	bic	\start, \start, \tmp2
> >> -9998:
> >> -	/* DCCIMVAC */
> >> -	mcr	p15, 0, \start, c7, c14, 1
> >> -	add	\start, \start, \tmp1
> >> -	cmp	\start, \end
> >> -	blo	9998b
> >> -	dsb	\domain
> >> -.endm
> >> -
> >>  .globl asm_mmu_disable
> >>  asm_mmu_disable:
> >>  	/* SCTLR */
> >> @@ -223,7 +210,8 @@ asm_mmu_disable:
> >>  	ldr	r0, [r0]
> >>  	ldr	r1, =__phys_end
> >>  	ldr	r1, [r1]
> >> -	dcache_clean_inval sy, r0, r1, r2, r3
> >> +	sub	r1, r1, r0
> >> +	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
> >>  	isb
> >>  
> >>  	mov     pc, lr
> >> diff --git a/arm/cstart64.S b/arm/cstart64.S
> >> index fc1930bcdb53..046bd3914098 100644
> >> --- a/arm/cstart64.S
> >> +++ b/arm/cstart64.S
> >> @@ -8,6 +8,7 @@
> >>  #define __ASSEMBLY__
> >>  #include <auxinfo.h>
> >>  #include <asm/asm-offsets.h>
> >> +#include <asm/assembler.h>
> >>  #include <asm/ptrace.h>
> >>  #include <asm/processor.h>
> >>  #include <asm/page.h>
> >> @@ -204,20 +205,6 @@ asm_mmu_enable:
> >>  
> >>  	ret
> >>  
> >> -/* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
> >> -.macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
> >> -	adrp	\tmp1, dcache_line_size
> >> -	ldr	\tmp1, [\tmp1, :lo12:dcache_line_size]
> >> -	sub	\tmp2, \tmp1, #1
> >> -	bic	\start, \start, \tmp2
> >> -9998:
> >> -	dc	\op , \start
> >> -	add	\start, \start, \tmp1
> >> -	cmp	\start, \end
> >> -	b.lo	9998b
> >> -	dsb	\domain
> >> -.endm
> >> -
> >>  .globl asm_mmu_disable
> >>  asm_mmu_disable:
> >>  	mrs	x0, sctlr_el1
> >> @@ -230,6 +217,7 @@ asm_mmu_disable:
> >>  	ldr	x0, [x0, :lo12:__phys_offset]
> >>  	adrp	x1, __phys_end
> >>  	ldr	x1, [x1, :lo12:__phys_end]
> >> +	sub	x1, x1, x0
> >>  	dcache_by_line_op civac, sy, x0, x1, x2, x3
> >>  	isb
> >>    

