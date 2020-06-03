Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC771ECD06
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgFCJ70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 05:59:26 -0400
Received: from mail.skyhub.de ([5.9.137.197]:33834 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFCJ7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 05:59:25 -0400
Received: from zn.tnic (p200300ec2f0b230065380e66e0b088b7.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:2300:6538:e66:e0b0:88b7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 295AD1EC02CF;
        Wed,  3 Jun 2020 11:59:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1591178364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ZSIGNEfL6Ayr2ush2OvY8suckgH4tStEBhJ1EqO29j8=;
        b=AF8qxysH81/eRXfJNTzW4bclbP+TZSCTVSWFGUXe8z5Kocy7/M5D20vBFUP2fziRzsxEIv
        7o7mweDKVAky6yOKlqEzED25VQnfupBLexUJaUgpB+N2fOZpqIsutvR69VTp6+d/rGOCXD
        WSSIF/MwSbg7PLbMwieaUEOKdh3cmxw=
Date:   Wed, 3 Jun 2020 11:59:23 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 74/75] x86/sev-es: Handle NMI State
Message-ID: <20200603095923.GB19711@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-75-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-75-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:17:24PM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 27d1016ec840..8898002e5600 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -511,6 +511,13 @@ NOKPROBE_SYMBOL(is_debug_stack);
>  dotraplinkage notrace void
>  do_nmi(struct pt_regs *regs, long error_code)
>  {
> +	/*
> +	 * Re-enable NMIs right here when running as an SEV-ES guest. This might
> +	 * cause nested NMIs, but those can be handled safely.
> +	 */
> +	if (sev_es_active())
> +		sev_es_nmi_complete();

Pls move the comment and the sev_es_active() check into
the sev_es_nmi_complete() function.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
