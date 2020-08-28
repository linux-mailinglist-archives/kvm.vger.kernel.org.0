Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0669725604C
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 20:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgH1SNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 14:13:52 -0400
Received: from mail.skyhub.de ([5.9.137.197]:32984 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbgH1SNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 14:13:52 -0400
Received: from zn.tnic (p200300ec2f0ba60078cbaf9a215c2e9d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:a600:78cb:af9a:215c:2e9d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EFDBB1EC03E3;
        Fri, 28 Aug 2020 20:13:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598638430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/jYI5IHuv43D+ZADrXsFhwBXIJnV8i1FIyxJtyua/Yg=;
        b=KXRzfulyqoFzRZ+dj+HluE21PJnj0cjQ69UGDcWcPA264jRdoC9l65vRds3AZNoIGQLiw/
        etQ7GAfkKPIWNnJokkDlepYsvcxMPquvY19el5NfnOAs2br3nC3Vjryk/KQaFohIqhnVUW
        NNFAZll3B7FQ4406XApoT0w5nSGLFcY=
Date:   Fri, 28 Aug 2020 20:13:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 31/76] x86/head/64: Setup MSR_GS_BASE before calling
 into C code
Message-ID: <20200828181346.GB19342@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-32-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-32-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:26AM +0200, Joerg Roedel wrote:
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 2b2e91627221..800053219054 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -78,6 +78,14 @@ SYM_CODE_START_NOALIGN(startup_64)
>  	call	startup_64_setup_env
>  	popq	%rsi
>  
> +	/*
> +	 * Setup %gs here already to make stack-protector work - it needs to be
> +	 * setup again after the switch to kernel addresses. The address read
> +	 * from initial_gs is a kernel address, so it needs to be adjusted first
> +	 * for the identity mapping.
> +	 */
> +	movl	$MSR_GS_BASE,%ecx

I'm confused: is this missing those three lines:

        movl    initial_gs(%rip),%eax
        movl    initial_gs+4(%rip),%edx
        wrmsr

as it is done in secondary_startup_64 ?

Or why would you otherwise put 0xc0000101 in %ecx and not do anything
with it...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
