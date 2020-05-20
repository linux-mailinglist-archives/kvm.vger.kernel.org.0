Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C493B1DBDEC
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 21:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgETTWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 15:22:39 -0400
Received: from mail.skyhub.de ([5.9.137.197]:36860 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbgETTWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 15:22:38 -0400
Received: from zn.tnic (p200300ec2f0bab0028d24a65f02999fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ab00:28d2:4a65:f029:99fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 729681EC0350;
        Wed, 20 May 2020 21:22:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590002556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YoNcQo6x1W8TxzWUCk2SRnUEN6+ujdV8K1zMMMM7K9w=;
        b=QnDgj2c7erKXF3m48N2kXaCZYdPDB5MWID4LlHGbzp/0OLMhpPWVLM4Ckuu+4FzqSymM2b
        Tn1sEI7aI7cqIuJQ5hI/AOTJELuDaDwk+EATRLjvONMnutf0FLFVVYGLQ8g9ONbAl0jE49
        jCzdAiOusfz1gfqvMpn9h0w2u4PG2Po=
Date:   Wed, 20 May 2020 21:22:30 +0200
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
Subject: Re: [PATCH v3 42/75] x86/sev-es: Setup GHCB based boot #VC handler
Message-ID: <20200520192230.GK1457@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-43-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-43-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:52PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/include/asm/sev-es.h b/arch/x86/include/asm/sev-es.h
> index b2cbcd40b52e..e1ed963a57ec 100644
> --- a/arch/x86/include/asm/sev-es.h
> +++ b/arch/x86/include/asm/sev-es.h
> @@ -74,5 +74,6 @@ static inline u64 lower_bits(u64 val, unsigned int bits)
>  }
>  
>  extern void vc_no_ghcb(void);
> +extern bool vc_boot_ghcb(struct pt_regs *regs);

Those function names need verbs:

	handle_vc_no_ghcb
	handle_vc_boot_ghcb

> @@ -161,3 +176,104 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>  
>  /* Include code shared with pre-decompression boot stage */
>  #include "sev-es-shared.c"
> +
> +/*
> + * This function runs on the first #VC exception after the kernel
> + * switched to virtual addresses.
> + */
> +static bool __init sev_es_setup_ghcb(void)

There's already another sev_es_setup_ghcb() in compressed/. All those
functions with the same name are just confusion waiting to happen. Let's
prepend the ones in compressed/ with "early_" or so, so that their names
are at least different even if they're in two different files with the
same name.

This way you know at least which function is used in which boot stages.

> +{
> +	/* First make sure the hypervisor talks a supported protocol. */
> +	if (!sev_es_negotiate_protocol())
> +		return false;

<---- newline here.

> +	/*
> +	 * Clear the boot_ghcb. The first exception comes in before the bss
> +	 * section is cleared.
> +	 */
> +	memset(&boot_ghcb_page, 0, PAGE_SIZE);
> +
> +	/* Alright - Make the boot-ghcb public */
> +	boot_ghcb = &boot_ghcb_page;
> +
> +	return true;
> +}
> +
> +static void __init vc_early_vc_forward_exception(struct es_em_ctxt *ctxt)

That second "vc" looks redundant.

> +{
> +	int trapnr = ctxt->fi.vector;
> +
> +	if (trapnr == X86_TRAP_PF)
> +		native_write_cr2(ctxt->fi.cr2);
> +
> +	ctxt->regs->orig_ax = ctxt->fi.error_code;
> +	do_early_exception(ctxt->regs, trapnr);
> +}
> +
> +static enum es_result vc_handle_exitcode(struct es_em_ctxt *ctxt,
> +					 struct ghcb *ghcb,
> +					 unsigned long exit_code)
> +{
> +	enum es_result result;
> +
> +	switch (exit_code) {
> +	default:
> +		/*
> +		 * Unexpected #VC exception
> +		 */
> +		result = ES_UNSUPPORTED;
> +	}
> +
> +	return result;
> +}
> +
> +bool __init vc_boot_ghcb(struct pt_regs *regs)
> +{
> +	unsigned long exit_code = regs->orig_ax;
> +	struct es_em_ctxt ctxt;
> +	enum es_result result;
> +
> +	/* Do initial setup or terminate the guest */
> +	if (unlikely(boot_ghcb == NULL && !sev_es_setup_ghcb()))
> +		sev_es_terminate(GHCB_SEV_ES_REASON_GENERAL_REQUEST);
> +
> +	vc_ghcb_invalidate(boot_ghcb);

Newline here...

> +	result = vc_init_em_ctxt(&ctxt, regs, exit_code);
> +

... remove that one here.

> +	if (result == ES_OK)
> +		result = vc_handle_exitcode(&ctxt, boot_ghcb, exit_code);

...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
