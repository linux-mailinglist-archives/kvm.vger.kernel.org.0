Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABCF51DF63F
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 11:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387741AbgEWJX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 05:23:58 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39588 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387678AbgEWJX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 05:23:58 -0400
Received: from zn.tnic (p200300ec2f1b96004c59f332ede330a0.dip0.t-ipconnect.de [IPv6:2003:ec:2f1b:9600:4c59:f332:ede3:30a0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D4F011EC00F8;
        Sat, 23 May 2020 11:23:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1590225837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RhlLOpWrzFCYAA5wjrrTkxDaFVK4ufjSSsBDJauVbXs=;
        b=W6i4bXYbASIdWPDlvAWA9Sw9TKs/imch2CRIvLqZAZ4AKkFkjp/UuQi1aiIvRsUqpb/Ijj
        rhKqdXWe1V8tbZrsV+ydJdjBXCSo3iOhh1eYx5fNwk/T/wLPMiQnd007L0F2AmgC3CZUHh
        n/hVT/CyRpJEn0ufXVLgJKYXhQaudvg=
Date:   Sat, 23 May 2020 11:23:51 +0200
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
Subject: Re: [PATCH v3 49/75] x86/sev-es: Handle instruction fetches from
 user-space
Message-ID: <20200523092351.GE27431@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-50-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-50-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:59PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> When a #VC exception is triggered by user-space the instruction decoder
> needs to read the instruction bytes from user addresses.  Enhance
> vc_decode_insn() to safely fetch kernel and user instructions.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev-es.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev-es.c b/arch/x86/kernel/sev-es.c
> index 85027fb4177e..c2223c2a28c2 100644
> --- a/arch/x86/kernel/sev-es.c
> +++ b/arch/x86/kernel/sev-es.c
> @@ -165,17 +165,30 @@ static enum es_result vc_decode_insn(struct es_em_ctxt *ctxt)
>  	enum es_result ret;
>  	int res;
>  
> -	res = vc_fetch_insn_kernel(ctxt, buffer);
> -	if (unlikely(res == -EFAULT)) {

Let's also test for 0 in case the probe_read* guts get changed and start
returning so other errval besides -EFAULT.

> -		ctxt->fi.vector     = X86_TRAP_PF;
> -		ctxt->fi.error_code = 0;
> -		ctxt->fi.cr2        = ctxt->regs->ip;
> -		return ES_EXCEPTION;
> +	if (!user_mode(ctxt->regs)) {

Flip that check so that it reads more naturally:

	if (user_mode(..)
			insn_fetch_from_user()

		...
	} else {
		vc_fetch_insn_kernel()

	}

> +		res = vc_fetch_insn_kernel(ctxt, buffer);



> +		if (unlikely(res == -EFAULT)) {
> +			ctxt->fi.vector     = X86_TRAP_PF;
> +			ctxt->fi.error_code = 0;
> +			ctxt->fi.cr2        = ctxt->regs->ip;
> +			return ES_EXCEPTION;
> +		}
> +
> +		insn_init(&ctxt->insn, buffer, MAX_INSN_SIZE - res, 1);
> +		insn_get_length(&ctxt->insn);
> +	} else {
> +		res = insn_fetch_from_user(ctxt->regs, buffer);
> +		if (res == 0) {

		if (!res)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
