Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F501CBF98
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 11:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgEIJFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 9 May 2020 05:05:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35360 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgEIJFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 9 May 2020 05:05:54 -0400
Received: from zn.tnic (p200300EC2F1C0C00DCC140091142DC90.dip0.t-ipconnect.de [IPv6:2003:ec:2f1c:c00:dcc1:4009:1142:dc90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C21211EC015C;
        Sat,  9 May 2020 11:05:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589015153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iVC3CBm/wWZ2U9FGwvz+Ni8/0OmKU8wtGPsbrqlTREk=;
        b=McXNxHNK1dqr+8GXBdVgfEZhpk9vMQVtdJPIZ9QQRoOJU8AwKydzyPbMIb0LsrhBQX+esW
        ZGcGl0hlwjdYy7WA5fEaXo5Sjj6snHiiFYPUSp7eNNdth7Ip5AjeiLwirmT7cAhMEYHSlH
        8eOiOsncVLM6rfM+1eUYl/VeJqiNGqI=
Date:   Sat, 9 May 2020 11:05:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 19/75] x86/boot/compressed/64: Add stage1 #VC handler
Message-ID: <20200509090548.GA5893@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-20-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-20-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:29PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Add the first handler for #VC exceptions. At stage 1 there is no GHCB
> yet becaue we might still be on the EFI page table and thus can't map

     "... because the kernel might still be running on the EFI page table... "

> memory unencrypted.
> 
> The stage 1 handler is limited to the MSR based protocol to talk to
> the hypervisor and can only support CPUID exit-codes, but that is
> enough to get to stage 2.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/Makefile          |  1 +
>  arch/x86/boot/compressed/idt_64.c          |  4 ++
>  arch/x86/boot/compressed/idt_handlers_64.S |  4 ++
>  arch/x86/boot/compressed/misc.h            |  1 +
>  arch/x86/boot/compressed/sev-es.c          | 45 +++++++++++++++
>  arch/x86/include/asm/msr-index.h           |  1 +
>  arch/x86/include/asm/sev-es.h              | 37 ++++++++++++
>  arch/x86/include/asm/trap_defs.h           |  1 +
>  arch/x86/kernel/sev-es-shared.c            | 65 ++++++++++++++++++++++
>  9 files changed, 159 insertions(+)
>  create mode 100644 arch/x86/boot/compressed/sev-es.c
>  create mode 100644 arch/x86/include/asm/sev-es.h
>  create mode 100644 arch/x86/kernel/sev-es-shared.c
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index c6909d10a6b9..a7847a1ef63a 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -85,6 +85,7 @@ ifdef CONFIG_X86_64
>  	vmlinux-objs-y += $(obj)/idt_64.o $(obj)/idt_handlers_64.o
>  	vmlinux-objs-y += $(obj)/mem_encrypt.o
>  	vmlinux-objs-y += $(obj)/pgtable_64.o
> +	vmlinux-objs-$(CONFIG_AMD_MEM_ENCRYPT) += $(obj)/sev-es.o
>  endif
>  
>  vmlinux-objs-$(CONFIG_ACPI) += $(obj)/acpi.o
> diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
> index 99cc78062684..f8295d68b3e1 100644
> --- a/arch/x86/boot/compressed/idt_64.c
> +++ b/arch/x86/boot/compressed/idt_64.c
> @@ -31,6 +31,10 @@ void load_stage1_idt(void)
>  {
>  	boot_idt_desc.address = (unsigned long)boot_idt;
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	set_idt_entry(X86_TRAP_VC, boot_stage1_vc);
> +#endif

	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))

seems to work too and drops the ifdeffery ugliness.

...

> +void __init do_vc_no_ghcb(struct pt_regs *regs, unsigned long exit_code)
> +{
> +	unsigned int fn = lower_bits(regs->ax, 32);
> +	unsigned long val;
> +
> +	/* Only CPUID is supported via MSR protocol */
> +	if (exit_code != SVM_EXIT_CPUID)
> +		goto fail;
> +
> +	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EAX));
> +	VMGEXIT();
> +	val = sev_es_rd_ghcb_msr();
> +	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
> +		goto fail;
> +	regs->ax = val >> 32;
> +
> +	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EBX));
> +	VMGEXIT();
> +	val = sev_es_rd_ghcb_msr();
> +	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
> +		goto fail;
> +	regs->bx = val >> 32;
> +
> +	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_ECX));
> +	VMGEXIT();
> +	val = sev_es_rd_ghcb_msr();
> +	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
> +		goto fail;
> +	regs->cx = val >> 32;
> +
> +	sev_es_wr_ghcb_msr(GHCB_CPUID_REQ(fn, GHCB_CPUID_REQ_EDX));
> +	VMGEXIT();
> +	val = sev_es_rd_ghcb_msr();
> +	if (GHCB_SEV_GHCB_RESP_CODE(val) != GHCB_SEV_CPUID_RESP)
> +		goto fail;
> +	regs->dx = val >> 32;

This could use a comment:

	/* Skip over the CPUID two-byte opcode */

or so.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
