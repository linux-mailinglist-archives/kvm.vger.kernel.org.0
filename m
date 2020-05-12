Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8875E1CFCE9
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgELSME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 14:12:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:49754 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgELSMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 14:12:03 -0400
Received: from zn.tnic (p200300EC2F0A9D0078F56FA374005E53.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9d00:78f5:6fa3:7400:5e53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CFE771EC0103;
        Tue, 12 May 2020 20:12:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589307122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=n06HkraspKjUYFH+gKoPebqkaQ8Z/x23WE/L9W2ArvQ=;
        b=JNNu10YPtjFu/VVc212xf7QxTlLs+MZAbdqCSoX8g20Tu0FKcIuFtgffY4hzflLvmWuLPA
        M3J+77wtqImyqZ1srxYpVtviMu9tPFZdZk4CfnaTZi6FNvprR/upzHkEf5Fx+fCnzfd/Kp
        AKsWTgYnpfq0TG8sscy1JWXmai+V9rU=
Date:   Tue, 12 May 2020 20:11:57 +0200
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
Subject: Re: [PATCH v3 23/75] x86/boot/compressed/64: Setup GHCB Based VC
 Exception handler
Message-ID: <20200512181157.GD6859@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-24-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-24-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:33PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Install an exception handler for #VC exception that uses a GHCB. Also
> add the infrastructure for handling different exit-codes by decoding
> the instruction that caused the exception and error handling.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/Kconfig                           |   1 +
>  arch/x86/boot/compressed/Makefile          |   3 +
>  arch/x86/boot/compressed/idt_64.c          |   4 +
>  arch/x86/boot/compressed/idt_handlers_64.S |   3 +-
>  arch/x86/boot/compressed/misc.c            |   7 +
>  arch/x86/boot/compressed/misc.h            |   7 +
>  arch/x86/boot/compressed/sev-es.c          | 110 +++++++++++++++
>  arch/x86/include/asm/sev-es.h              |  39 ++++++
>  arch/x86/include/uapi/asm/svm.h            |   1 +
>  arch/x86/kernel/sev-es-shared.c            | 154 +++++++++++++++++++++
>  10 files changed, 328 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1197b5596d5a..2ba5f74f186d 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1523,6 +1523,7 @@ config AMD_MEM_ENCRYPT
>  	select DYNAMIC_PHYSICAL_MASK
>  	select ARCH_USE_MEMREMAP_PROT
>  	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
> +	select INSTRUCTION_DECODER
>  	---help---
>  	  Say yes to enable support for the encryption of system memory.
>  	  This requires an AMD processor that supports Secure Memory
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index a7847a1ef63a..8372b85c9c0e 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -41,6 +41,9 @@ KBUILD_CFLAGS += -Wno-pointer-sign
>  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
>  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  
> +# sev-es.c inludes generated $(objtree)/arch/x86/lib/inat-tables.c

	      "includes"

> +CFLAGS_sev-es.o += -I$(objtree)/arch/x86/lib/

Does it?

I see

#include "../../lib/inat.c"
#include "../../lib/insn.c"

only and with the above CFLAGS-line removed, it builds still.

Leftover from earlier?

> +
>  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  GCOV_PROFILE := n
>  UBSAN_SANITIZE :=n
> diff --git a/arch/x86/boot/compressed/idt_64.c b/arch/x86/boot/compressed/idt_64.c
> index f8295d68b3e1..44d20c4f47c9 100644
> --- a/arch/x86/boot/compressed/idt_64.c
> +++ b/arch/x86/boot/compressed/idt_64.c
> @@ -45,5 +45,9 @@ void load_stage2_idt(void)
>  
>  	set_idt_entry(X86_TRAP_PF, boot_page_fault);
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	set_idt_entry(X86_TRAP_VC, boot_stage2_vc);
> +#endif

if IS_ENABLED()...

...

> +static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
> +{
> +	char buffer[MAX_INSN_SIZE];
> +	enum es_result ret;
> +
> +	memcpy(buffer, (unsigned char *)ctxt->regs->ip, MAX_INSN_SIZE);
> +
> +	insn_init(&ctxt->insn, buffer, MAX_INSN_SIZE, 1);
> +	insn_get_length(&ctxt->insn);
> +
> +	ret = ctxt->insn.immediate.got ? ES_OK : ES_DECODE_FAILED;

Why are we checking whether the immediate? insn_get_length() sets
insn->length unconditionally while insn_get_immediate() can error out
and not set ->got... ?

> +
> +	return ret;
> +}

...

> +static bool sev_es_setup_ghcb(void)
> +{
> +	if (!sev_es_negotiate_protocol())
> +		sev_es_terminate(GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
> +
> +	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
> +		return false;
> +
> +	/* Page is now mapped decrypted, clear it */
> +	memset(&boot_ghcb_page, 0, sizeof(boot_ghcb_page));
> +
> +	boot_ghcb = &boot_ghcb_page;
> +
> +	/* Initialize lookup tables for the instruction decoder */
> +	inat_init_tables();

Yeah, that call doesn't logically belong in this function AFAICT as this
function should setup the GHCB only. You can move it to the caller.

> +
> +	return true;
> +}
> +
> +void sev_es_shutdown_ghcb(void)
> +{
> +	if (!boot_ghcb)
> +		return;
> +
> +	/*
> +	 * GHCB Page must be flushed from the cache and mapped encrypted again.
> +	 * Otherwise the running kernel will see strange cache effects when
> +	 * trying to use that page.
> +	 */
> +	if (set_page_encrypted((unsigned long)&boot_ghcb_page))
> +		error("Can't map GHCB page encrypted");

Is that error() call enough?

Shouldn't we BUG_ON() here or mark that page Reserved or so, so that
nothing uses it during the system lifetime and thus avoid the strange
cache effects?

...

> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					  struct es_em_ctxt *ctxt,
> +					  u64 exit_code, u64 exit_info_1,
> +					  u64 exit_info_2)
> +{
> +	enum es_result ret;
> +
> +	/* Fill in protocol and format specifiers */
> +	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> +	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
> +
> +	ghcb_set_sw_exit_code(ghcb, exit_code);
> +	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> +	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +	VMGEXIT();
> +
> +	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
					^^^^^^^^^^^

(1UL << 32) - 1

I guess.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
