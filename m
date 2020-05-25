Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8FF1E0B0C
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 11:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389437AbgEYJxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 05:53:48 -0400
Received: from mail.skyhub.de ([5.9.137.197]:34124 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389333AbgEYJxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 05:53:48 -0400
Received: from zn.tnic (p200300ec2f06f30089d08c3691e46ece.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:f300:89d0:8c36:91e4:6ece])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 08BEC1EC015C;
        Mon, 25 May 2020 11:53:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590400427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9VzBtpWPU0udK1c1x3QSZ15i6vXLnUq6lBexMlFZdDw=;
        b=f75/oRPaAWlIyjcWmr6QIrmj4cZgSFjzANrLAL9ul+FOdvMd25H4cUnMA1+hiMnOuRfV0V
        kWXb/wEH5VNMjlJuLMhLZq07oxJScHT2D14MJb7INO8ym2mw8fL5u5mcwYmNPvncVtYmJa
        rIlP+DwLBHpf7Wj8SjEB5BsPgo9DKuM=
Date:   Mon, 25 May 2020 11:53:46 +0200
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
Subject: Re: [PATCH v3 53/75] x86/sev-es: Handle MSR events
Message-ID: <20200525095346.GF25636@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-54-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-54-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:03PM +0200, Joerg Roedel wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Implement a handler for #VC exceptions caused by RDMSR/WRMSR
> instructions.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> [ jroedel@suse.de: Adapt to #VC handling infrastructure ]
> Co-developed-by: Joerg Roedel <jroedel@suse.de>
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 84958a82f8e0..e43bba4c7d79 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -316,6 +316,31 @@ static phys_addr_t vc_slow_virt_to_phys(struct ghcb *ghcb, unsigned long vaddr)
>  /* Include code shared with pre-decompression boot stage */
>  #include "sev-es-shared.c"
>  
> +static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
> +{
> +	struct pt_regs *regs = ctxt->regs;
> +	enum es_result ret;
> +	u64 exit_info_1;
> +

A comment pls:

	/* Is it a WRMSR? */

> +	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
> +
> +	ghcb_set_rcx(ghcb, regs->cx);
> +	if (exit_info_1) {
> +		ghcb_set_rax(ghcb, regs->ax);
> +		ghcb_set_rdx(ghcb, regs->dx);
> +		exit_info_1 = 1;

No need to set it again - you just did above. :)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
