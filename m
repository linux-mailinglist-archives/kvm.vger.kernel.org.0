Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9091C3719
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 12:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgEDKlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 06:41:35 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55946 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbgEDKlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 06:41:35 -0400
Received: from zn.tnic (p200300EC2F08AF00A9258889345EFBFA.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:af00:a925:8889:345e:fbfa])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DC0E51EC011B;
        Mon,  4 May 2020 12:41:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1588588894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=iRUNm3gcqi81lpr43dwmxdWf16YWxyP1UxTVlnpFzUU=;
        b=kuIp+12Q+Ly/02XXR6hpYKN7OouGtkNo7biM9HOEmVEhTzPn6oWp7JLSYxLEcLL7THnsuI
        uOJ/KMNOHqrpBJLxGMZrz6Dnr3mvcCxOKjbb+pFhKh3I/1xOg9r8213Q4Y8B7Cn3h6pD+d
        lUiNekNhlKGzhQzLbDWp8+pUbFsCGjw=
Date:   Mon, 4 May 2020 12:41:29 +0200
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
Subject: Re: [PATCH v3 12/75] x86/boot/compressed/64: Switch to __KERNEL_CS
 after GDT is loaded
Message-ID: <20200504104129.GD15046@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-13-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-13-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:22PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When the pre-decompression code loads its first GDT in startup_64, it is
> still running on the CS value of the previous GDT. In the case of SEV-ES
> this is the EFI GDT.
> 
> To make exception handling work (especially IRET) the CPU needs to
> switch to a CS value in the current GDT, so jump to __KERNEL_CS after
> the first GDT is loaded.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/head_64.S | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 4f7e6b84be07..6b11060c3a0f 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -393,6 +393,14 @@ SYM_CODE_START(startup_64)
>  	addq	%rax, 2(%rax)
>  	lgdt	(%rax)
>  
> +	/* Reload CS so IRET returns to a CS actually in the GDT */
> +	pushq	$__KERNEL_CS
> +	leaq	.Lon_kernel_cs(%rip), %rax
> +	pushq	%rax
> +	lretq
> +
> +.Lon_kernel_cs:
> +
>  	/*
>  	 * paging_prepare() sets up the trampoline and checks if we need to
>  	 * enable 5-level paging.
> -- 

So I'm thinking I should take this one even now on the grounds that
it sanitizes CS to something known-good than what was there before and
who knows what set it and loaded the kernel...?

And that is a good thing in itself.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
