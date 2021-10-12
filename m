Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE842A71B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 16:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237190AbhJLO0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 10:26:07 -0400
Received: from mail.skyhub.de ([5.9.137.197]:46946 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhJLO0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 10:26:06 -0400
Received: from zn.tnic (p200300ec2f104900035bec0fa4850493.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:4900:35b:ec0f:a485:493])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D5AB11EC0445;
        Tue, 12 Oct 2021 16:24:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634048644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KGkEaAfGtfuF2SEf8zLbxAF2MRYs15s5QsP17xmqNkc=;
        b=rnLpF8N07LpwwPjIuiuSLWOVSiN3q1aP0B/08T3fgkwAqacI5a+YtseblU7ATvhi7Iim09
        hTvrB5Eg9drv+thM/QeVnjM37mN/wEtBfxEBexYoEDUxK+tPg/UFWUq12qWLbE3yYJ4H9a
        sKwDMmitJ7Z73Ov3JqQGSwFZiDV7yR0=
Date:   Tue, 12 Oct 2021 16:24:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 04/31] x86/fpu: Restrict xsaves()/xrstors() to
 independent states
Message-ID: <YWWagCMsVduf4yVn@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223610.524176686@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223610.524176686@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:04AM +0200, Thomas Gleixner wrote:
> These interfaces are really only valid for features which are independently
> managed and not part of the task context state for various reasons.
> 
> Tighten the checks and adjust the misleading comments.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/fpu/xstate.c |   14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> --- a/arch/x86/kernel/fpu/xstate.c
> +++ b/arch/x86/kernel/fpu/xstate.c
> @@ -1182,13 +1182,9 @@ static bool validate_xsaves_xrstors(u64

I guess then change the name too, to:

validate_indep_xstate_components()

or so?

Then you don't need the comment below.

>  	if (WARN_ON_FPU(!cpu_feature_enabled(X86_FEATURE_XSAVES)))
>  		return false;
>  	/*
> -	 * Validate that this is either a task->fpstate related component
> -	 * subset or an independent one.
> +	 * Validate that this is a independent compoment.

WARNING: 'compoment' may be misspelled - perhaps 'component'?
#78: FILE: arch/x86/kernel/fpu/xstate.c:1185:
+        * Validate that this is a independent compoment.
                                               ^^^^^^^^^
>  	 */
> -	if (mask & xfeatures_mask_independent())
> -		xchk = ~xfeatures_mask_independent();
> -	else
> -		xchk = ~xfeatures_mask_all;
> +	xchk = ~xfeatures_mask_independent();
>  
>  	if (WARN_ON_ONCE(!mask || mask & xchk))
>  		return false;
> @@ -1206,8 +1202,7 @@ static bool validate_xsaves_xrstors(u64
>   * buffer should be zeroed otherwise a consecutive XRSTORS from that buffer
>   * can #GP.
>   *
> - * The feature mask must either be a subset of the independent features or
> - * a subset of the task->fpstate related features.
> + * The feature mask must be a subset of the independent features

End with a fullstop.

>   */
>  void xsaves(struct xregs_state *xstate, u64 mask)
>  {
> @@ -1231,8 +1226,7 @@ void xsaves(struct xregs_state *xstate,
>   * Proper usage is to restore the state which was saved with
>   * xsaves() into @xstate.
>   *
> - * The feature mask must either be a subset of the independent features or
> - * a subset of the task->fpstate related features.
> + * The feature mask must be a subset of the independent features

Ditto.

>   */
>  void xrstors(struct xregs_state *xstate, u64 mask)
>  {

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
