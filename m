Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2575544EB75
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 17:33:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhKLQgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 11:36:08 -0500
Received: from mail.skyhub.de ([5.9.137.197]:42906 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235488AbhKLQgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 11:36:05 -0500
Received: from zn.tnic (p200300ec2f10ce00d18a941e5c4028b8.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:ce00:d18a:941e:5c40:28b8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 91C131EC02AD;
        Fri, 12 Nov 2021 17:33:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636734793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=h/TsHncJjdrq8Ez3Mrrmi4mEIhgDAK1/8P0J9kgkQaw=;
        b=etVAmwzzxO+maMIwttxgi5haSSvcNfD8F0QuOkxZyuizIvkNwjkJbWs1VP1ViyZ8eE0GEa
        vP/ea6wrz0yV63EHwXzkTuoDnpeppdeuj2hqJWlilXs7tiz2JSvCX1x4af05hYLQPpdkWT
        5SsndWm1PWqG8t+Y3vXs/iIg1id1UXY=
Date:   Fri, 12 Nov 2021 17:33:05 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 08/12] x86/sev: Park APs on AP Jump Table with GHCB
 protocol version 2
Message-ID: <YY6XQfmvmpmUiIGj@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-9-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913155603.28383-9-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 05:55:59PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> GHCB protocol version 2 adds the MSR-based AP-reset-hold VMGEXIT which
> does not need a GHCB. Use that to park APs in 16-bit protected mode on
> the AP Jump Table.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/realmode.h    |  3 +
>  arch/x86/kernel/sev.c              | 48 ++++++++++++++--
>  arch/x86/realmode/rm/Makefile      | 11 ++--
>  arch/x86/realmode/rm/header.S      |  3 +
>  arch/x86/realmode/rm/sev_ap_park.S | 89 ++++++++++++++++++++++++++++++
>  5 files changed, 144 insertions(+), 10 deletions(-)
>  create mode 100644 arch/x86/realmode/rm/sev_ap_park.S
> 
> diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
> index 29590a4ddf24..668de0a8b1ae 100644
> --- a/arch/x86/include/asm/realmode.h
> +++ b/arch/x86/include/asm/realmode.h
> @@ -23,6 +23,9 @@ struct real_mode_header {
>  	u32	trampoline_header;
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  	u32	sev_es_trampoline_start;
> +	u32	sev_real_ap_park_asm;

sev_ap_park;

> +	u32	sev_real_ap_park_seg;

sev_ap_park_seg;

> +	u32	sev_ap_park_gdt;

Yap, like thist one.

>  #endif
>  #ifdef CONFIG_X86_64
>  	u32	trampoline_pgd;
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index a98eab926682..20b439986d86 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -27,6 +27,7 @@
>  #include <asm/fpu/internal.h>
>  #include <asm/processor.h>
>  #include <asm/realmode.h>
> +#include <asm/tlbflush.h>
>  #include <asm/traps.h>
>  #include <asm/svm.h>
>  #include <asm/smp.h>
> @@ -695,6 +696,35 @@ static bool __init sev_es_setup_ghcb(void)
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +void __noreturn sev_jumptable_ap_park(void)
> +{
> +	local_irq_disable();
> +
> +	write_cr3(real_mode_header->trampoline_pgd);
> +
> +	/* Exiting long mode will fail if CR4.PCIDE is set. */
> +	if (boot_cpu_has(X86_FEATURE_PCID))

cpu_feature_enabled() is what we use everywhere now.

> +		cr4_clear_bits(X86_CR4_PCIDE);
> +
> +	asm volatile("xorq	%%r15, %%r15\n"
> +		     "xorq	%%r14, %%r14\n"
> +		     "xorq	%%r13, %%r13\n"
> +		     "xorq	%%r12, %%r12\n"
> +		     "xorq	%%r11, %%r11\n"
> +		     "xorq	%%r10, %%r10\n"
> +		     "xorq	%%r9,  %%r9\n"
> +		     "xorq	%%r8,  %%r8\n"
> +		     "xorq	%%rsi, %%rsi\n"
> +		     "xorq	%%rdi, %%rdi\n"
> +		     "xorq	%%rsp, %%rsp\n"
> +		     "xorq	%%rbp, %%rbp\n"

Use xorl and the 32-bit regs is enough - zero extension.

> +		     "ljmpl	*%0" : :
> +		     "m" (real_mode_header->sev_real_ap_park_asm),
> +		     "b" (sev_es_jump_table_pa >> 4));

In any case, this asm needs comments: why those regs, why
sev_es_jump_table_pa >> 4 in rbx (I found later in the patch why) and so
on.

> diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
> index 8c1db5bf5d78..6c17f8fd1eb4 100644
> --- a/arch/x86/realmode/rm/header.S
> +++ b/arch/x86/realmode/rm/header.S
> @@ -22,6 +22,9 @@ SYM_DATA_START(real_mode_header)
>  	.long	pa_trampoline_header
>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>  	.long	pa_sev_es_trampoline_start
> +	.long	pa_sev_ap_park_asm
> +	.long	__KERNEL32_CS
> +	.long	pa_sev_ap_park_gdt;
>  #endif
>  #ifdef CONFIG_X86_64
>  	.long	pa_trampoline_pgd;
> diff --git a/arch/x86/realmode/rm/sev_ap_park.S b/arch/x86/realmode/rm/sev_ap_park.S

arch/x86/realmode/rm/sev.S

is perfectly fine I guess.

> new file mode 100644
> index 000000000000..0b63d0569d4d
> --- /dev/null
> +++ b/arch/x86/realmode/rm/sev_ap_park.S
> @@ -0,0 +1,89 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/linkage.h>
> +#include <asm/segment.h>
> +#include <asm/page_types.h>
> +#include <asm/processor-flags.h>
> +#include <asm/msr-index.h>
> +#include <asm/sev-ap-jumptable.h>
> +#include "realmode.h"
> +
> +	.section ".text32", "ax"
> +	.code32
> +/*

"This is executed by ... when ... "

> + * The following code switches to 16-bit protected mode and sets up the
> + * execution environment for the AP Jump Table blob. Then it jumps to the AP
> + * Jump Table to park the AP.
> + *
> + * The code was copied from reboot.S and modified to fit the SEV-ES requirements
> + * for AP parking.

That sentence belongs at most in the commit message.

> When this code is entered, all registers except %EAX-%EDX are

%eax, etc. Lowercase pls.

> + * in reset state.
> + *
> + * The AP Jump Table physical base address is in %EBX upon entry.
> + *
> + * %EAX, %ECX, %EDX and EFLAGS are undefined. Only use registers %EAX-%EDX and
> + * %ESP in this code.
> + */
> +SYM_CODE_START(sev_ap_park_asm)

sev_ap_park

> +
> +	/* Switch to trampoline GDT as it is guaranteed < 4 GiB */
> +	movl	$__KERNEL_DS, %eax
> +	movl	%eax, %ds
> +	lgdt	pa_tr_gdt
> +
> +	/* Disable paging to drop us out of long mode */
> +	movl	%cr0, %eax
> +	btcl	$X86_CR0_PG_BIT, %eax
> +	movl	%eax, %cr0
> +

	/* Start executing from 32-bit addresses or so, I guess...

> +	ljmpl	$__KERNEL32_CS, $pa_sev_ap_park_paging_off

Please add a comment also about those pa_ things because they look like
magic but they're sed-generated into arch/x86/realmode/rm/pasyms.h by
the Makefile in that same dir.

> +SYM_INNER_LABEL(sev_ap_park_paging_off, SYM_L_GLOBAL)

Global symbol but used only in this file. .L-prefix then?

> +	/* Clear EFER */
> +	movl	$0, %eax
> +	movl	$0, %edx

both:	xorl

> +	movl	$MSR_EFER, %ecx
> +	wrmsr
> +
> +	/* Clear CR3 */
> +	movl	$0, %ecx

ditto

> +	movl	%ecx, %cr3
> +
> +	/* Set up the IDT for real mode. */
> +	lidtl	pa_machine_real_restart_idt
> +
> +	/*
> +	 * Load the GDT with the 16-bit segments for the AP Jump Table
> +	 */

	/* Load the GDT with the 16-bit segments for the AP Jump Table  */

works too.

> +	lgdtl	pa_sev_ap_park_gdt
> +
> +	/* Setup Code and Data segments for AP Jump Table */

	... code and data segments ...

you have been reading too much vendor text where they love to capitalize
everything.

> +	movw	$SEV_APJT_DS16, %ax
> +	movw	%ax, %ds
> +	movw	%ax, %ss
> +
> +	/* Jump to the AP Jump Table into 16 bit protected mode */
> +	ljmpw	$SEV_APJT_CS16, $SEV_APJT_ENTRY
> +SYM_CODE_END(sev_ap_park_asm)
> +
> +	.data
> +	.balign	16
> +SYM_DATA_START(sev_ap_park_gdt)
> +	/* Self-pointer */
> +	.word	sev_ap_park_gdt_end - sev_ap_park_gdt - 1
> +	.long	pa_sev_ap_park_gdt
> +	.word	0
> +
> +	/*
> +	 * Offset 0x8
> +	 * 32 bit code segment descriptor pointing to AP Jump table base
> +	 * Setup at runtime in sev_es_setup_ap_jump_table_data().
> +	 */
> +	.quad	0
> +
> +	/*
> +	 * Offset 0x10
> +	 * 32 bit data segment descriptor pointing to AP Jump table base
> +	 * Setup at runtime in sev_es_setup_ap_jump_table_data().
> +	 */
> +	.quad	0
> +SYM_DATA_END_LABEL(sev_ap_park_gdt, SYM_L_GLOBAL, sev_ap_park_gdt_end)
> -- 
> 2.33.0
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
