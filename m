Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A02D31DEB8
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 19:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhBQSBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 13:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbhBQSBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 13:01:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B80C061574;
        Wed, 17 Feb 2021 10:00:52 -0800 (PST)
Received: from zn.tnic (p200300ec2f05bb00a5a1b5cb6f03bfce.dip0.t-ipconnect.de [IPv6:2003:ec:2f05:bb00:a5a1:b5cb:6f03:bfce])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 426BF1EC0402;
        Wed, 17 Feb 2021 19:00:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613584851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=OyC60AEXb/9wdHg79nRJVAwmz+d5y82NOII64Aytkw4=;
        b=rZCe/fUCQVQIdCLfy0ZZX86wa1k2dVKkf+PDmFOG4MS7fmj2VZoM4iC/mO0MQe9ouVSUV4
        AA5HzXgovgE4O63ljYDoXrY24nbmBoNNpStJFJOEg2TL1n1FfPZSR6+rMznkaIIGgV6+e8
        Ls90hdQStGA73QaE4V43VHLz45AeEIc=
Date:   Wed, 17 Feb 2021 19:00:54 +0100
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 3/3] x86/sev-es: Improve comments in and around
 __sev_es_ist_enter/exit()
Message-ID: <20210217180054.GC6479@zn.tnic>
References: <20210217120143.6106-1-joro@8bytes.org>
 <20210217120143.6106-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210217120143.6106-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 17, 2021 at 01:01:43PM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Better explain why this code is necessary and what it is doing.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 0df38b185d53..79241bc45f25 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -127,14 +127,20 @@ static __always_inline bool on_vc_stack(unsigned long sp)
>  }
>  
>  /*
> - * This function handles the case when an NMI is raised in the #VC exception
> - * handler entry code. In this case, the IST entry for #VC must be adjusted, so
> - * that any subsequent #VC exception will not overwrite the stack contents of the
> - * interrupted #VC handler.
> + * This function handles the case when an NMI is raised in the #VC
> + * exception handler entry code, before the #VC handler has switched off
> + * its IST stack. In this case, the IST entry for #VC must be adjusted,
> + * so that any nested #VC exception will not overwrite the stack
> + * contents of the interrupted #VC handler.
>   *
>   * The IST entry is adjusted unconditionally so that it can be also be
> - * unconditionally adjusted back in sev_es_ist_exit(). Otherwise a nested
> - * sev_es_ist_exit() call may adjust back the IST entry too early.
> + * unconditionally adjusted back in __sev_es_ist_exit(). Otherwise a
> + * nested sev_es_ist_exit() call may adjust back the IST entry too
> + * early.
> + *
> + * The __sev_es_ist_enter() and __sev_es_ist_exit() functions always run
> + * on the NMI IST stack, as they are only called from NMI handling code
> + * right now.
>   */
>  void noinstr __sev_es_ist_enter(struct pt_regs *regs)
>  {
> @@ -143,7 +149,10 @@ void noinstr __sev_es_ist_enter(struct pt_regs *regs)
>  	/* Read old IST entry */
>  	old_ist = __this_cpu_read(cpu_tss_rw.x86_tss.ist[IST_INDEX_VC]);
>  
> -	/* Make room on the IST stack */
> +	/*
> +	 * Make room on the IST stack - Reserve 8 bytes to store the old
> +	 * IST entry.
> +	 */
>  	if (on_vc_stack(regs->sp) &&
>  	    !user_mode(regs) &&
>  	    !from_syscall_gap(regs))
> -- 

Yah, and then we probably should simplify this __sev_es_ist_enter()
function even more as it is not easy to grok.

For example, the ALIGN_DOWN(regs->sp, 8) is not really needed, right?

Also, both branches do "- sizeof(old_ist);" so you can just as well do
it unconditionally.

And the sizeof(old_ist) is just a confusing way to write 8, right? We're
64-bit only so there's no need for that, I'd say.

And then you probably should change the comments from

	/* Store old IST entry */

and

	/* Set new IST entry */

to something like:

 /*
  * If on the #VC IST stack, new_ist gets set to point one stack slot
  * further down from the #VC interrupt frame which has been pushed on
  * it during the first #VC exception entry.
  *
  * If not, simply the next slot on the #VC IST stack is set to point...

and here I'm not even sure why we're doing it?

The else branch, when we're not on the #VC stack, why are we doing

	new_ist = old_ist - sizeof(old_ist);

?

I mean, if the NMI handler causes a #VC exception, it will simply run on
the #VC IST stack so why do we have to do that - 8 thing at all?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
