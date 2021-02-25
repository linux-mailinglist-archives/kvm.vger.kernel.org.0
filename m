Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5767D324FB6
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 13:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhBYMNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 07:13:54 -0500
Received: from mail.skyhub.de ([5.9.137.197]:43328 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhBYMNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 07:13:51 -0500
Received: from zn.tnic (p200300ec2f03dc0059e4821217d1e808.dip0.t-ipconnect.de [IPv6:2003:ec:2f03:dc00:59e4:8212:17d1:e808])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AD79C1EC052A;
        Thu, 25 Feb 2021 13:13:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1614255189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uowjjR43yhHROzZrr8+GTPAe1G0Z7p+VXIsXmHZT/DI=;
        b=C7l6RDM9UJMC40fLu4YLfez5BF6dXTtgOjtsFeZ/yBsJes9E+fS6f7NKObR7VNz8+enqge
        oZxlN/KVgnpBzKfk8dFfgDpWPFElVwVzwKnICt6v34WSqLKFNRlg3fvdIsUv7gp7wsl9Lr
        BQe/61MPSqaoFWiR09QP9VR+WflWms8=
Date:   Thu, 25 Feb 2021 13:13:08 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/7] x86/boot/compressed/64: Add 32-bit boot #VC handler
Message-ID: <20210225121308.GB380@zn.tnic>
References: <20210210102135.30667-1-joro@8bytes.org>
 <20210210102135.30667-5-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210210102135.30667-5-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021 at 11:21:32AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Add a #VC exception handler which is used when the kernel still executes
> in protected mode. This boot-path already uses CPUID, which will cause #VC
> exceptions in an SEV-ES guest.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/head_64.S     |  6 ++
>  arch/x86/boot/compressed/mem_encrypt.S | 77 +++++++++++++++++++++++++-
>  2 files changed, 82 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 8deeec78cdb4..eadaa0a082b8 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -34,6 +34,7 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/bootparam.h>
>  #include <asm/desc_defs.h>
> +#include <asm/trapnr.h>
>  #include "pgtable.h"
>  
>  /*
> @@ -856,6 +857,11 @@ SYM_FUNC_START(startup32_set_idt_entry)
>  SYM_FUNC_END(startup32_set_idt_entry)
>  
>  SYM_FUNC_START(startup32_load_idt)
> +	/* #VC handler */
> +	leal    rva(startup32_vc_handler)(%ebp), %eax
> +	movl    $X86_TRAP_VC, %edx
> +	call    startup32_set_idt_entry
> +
>  	/* Load IDT */
>  	leal	rva(boot32_idt)(%ebp), %eax
>  	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
> diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
> index aa561795efd1..350ecb56c7e4 100644
> --- a/arch/x86/boot/compressed/mem_encrypt.S
> +++ b/arch/x86/boot/compressed/mem_encrypt.S
> @@ -67,10 +67,85 @@ SYM_FUNC_START(get_sev_encryption_bit)
>  	ret
>  SYM_FUNC_END(get_sev_encryption_bit)
>  
> +/*
> + * Emit code to request an CPUID register from the Hypervisor using
> + * the MSR-based protocol.
> + *
> + * fn: The register containing the CPUID function
> + * reg: Register requested
> + *	1 = EAX
> + *	2 = EBX
> + *	3 = ECX
> + *	4 = EDX
> + *
> + * Result is in EDX. Jumps to .Lfail on error
> + */
> +.macro	SEV_ES_REQ_CPUID fn:req reg:req

I'm wondering - instead of replicating this 4 times, can this be a
function which you CALL? You do have a stack so you should be able to.

> +	/* Request CPUID[%ebx].EAX */
> +	movl	$\reg, %eax
> +	shll	$30, %eax
> +	orl	$0x00000004, %eax
> +	movl	\fn, %edx
> +	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
> +	wrmsr
> +	rep; vmmcall
> +	rdmsr
> +	/* Check response code */

Before you do that, I guess you wanna check:

GHCBData[29:12] – Reserved, must be zero

in the HV response.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
