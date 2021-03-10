Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3C2334517
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 18:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhCJR1H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 12:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhCJR0s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 12:26:48 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD238C061760;
        Wed, 10 Mar 2021 09:26:47 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id k9so34802350lfo.12;
        Wed, 10 Mar 2021 09:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1LykyLduLhTeLGxvql/hvJyXPaRgNTwi4bgV8vO/5g4=;
        b=YQe5YX1lcwCRNB/R7ZSGLb8mFGu5AKEVnXHd/CLXHTxXrUVr0vrSYA2R2EbC1dubfE
         2HgXNCh8nrtz8pmwE3rDUrMbGV6U5Jbo2Q/2ujw9pDacr1J7iIWG4Ngt3JTUoMrPIiuD
         FDgE3/dkIYQe2L6r7e4r4Xb0oywHboVttJ53TB7Zi4L8STNcH99hdfv83Qemb03Oirug
         EyKi0Fx7sHCTNm/9VPp9XMAPRB7jaJ3qngVxeR/4o+Ny3z/2YMAQ2knp6ugT6u33VTey
         UjJnaTG9Hq55RaPEpZADXy+3Sr4Y4zuNP+VEDdKnguhTdt3ATUS2kUCyY/oWpyhp6j18
         g8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1LykyLduLhTeLGxvql/hvJyXPaRgNTwi4bgV8vO/5g4=;
        b=plPRcS9cw2uE5KQclb+JMtyzCf1GhJTgrfxTFt0NgPmMfBmtJ8c94bV+C+LBg2P9sj
         dCdPTiG3yrRgT5QKCOFtcKmU9uWUcZBqAf8tuhbZdFnd/t5tRXK/EkuZ7zXfjuCgzWcb
         L0inFmdcxf49NXKdYpwVrvRKWUyIvcqUIAowp/ba6s3/hfn0AVRzBKxIrq4hXDfWSU21
         NogGIcwCkF5bM2o6Tn16LQFEKF5P0QU9OC4OjWKMr06+3baAWgLbeDE1nRY0q5AWXxXS
         Byo92E4Bo/hvgf3x4Pbplpzy4BgK9w77eoL9IF13i/edKY25JMlEYWe0JrxbGM58wa26
         pQ9w==
X-Gm-Message-State: AOAM5333Eu3uO0tjGzxByJMfs5NBVhzTpP9TdqOPoAX2tpAVdaWLTIu/
        W9uo4hnO1cHKq9mY58DHshs=
X-Google-Smtp-Source: ABdhPJyiY5ZC4EfGObNl/uExMhFGrkhuDez57YxDH+cuVMI8cP63mfrS1PoAceVVTWUpLxkn7PvLBw==
X-Received: by 2002:a05:6512:1192:: with SMTP id g18mr2712428lfr.102.1615397206276;
        Wed, 10 Mar 2021 09:26:46 -0800 (PST)
Received: from martin-ThinkPad-T440p (88-115-234-24.elisa-laajakaista.fi. [88.115.234.24])
        by smtp.gmail.com with ESMTPSA id l5sm3055049lfc.137.2021.03.10.09.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 09:26:46 -0800 (PST)
Date:   Wed, 10 Mar 2021 18:26:43 +0100
From:   Martin Radev <martin.b.radev@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
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
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 5/7] x86/boot/compressed/64: Add CPUID sanity check to
 32-bit boot-path
Message-ID: <YEkBU9em9SQZ25vA@martin-ThinkPad-T440p>
References: <20210310084325.12966-1-joro@8bytes.org>
 <20210310084325.12966-6-joro@8bytes.org>
 <YEjvBfJg8P1SQt98@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEjvBfJg8P1SQt98@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:08:37AM -0800, Sean Christopherson wrote:
> On Wed, Mar 10, 2021, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > The 32-bit #VC handler has no GHCB and can only handle CPUID exit codes.
> > It is needed by the early boot code to handle #VC exceptions raised in
> > verify_cpu() and to get the position of the C bit.
> > 
> > But the CPUID information comes from the hypervisor, which is untrusted
> > and might return results which trick the guest into the no-SEV boot path
> > with no C bit set in the page-tables. All data written to memory would
> > then be unencrypted and could leak sensitive data to the hypervisor.
> > 
> > Add sanity checks to the 32-bit boot #VC handler to make sure the
> > hypervisor does not pretend that SEV is not enabled.
> > 
> > Signed-off-by: Joerg Roedel <jroedel@suse.de>
> > ---
> >  arch/x86/boot/compressed/mem_encrypt.S | 36 ++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> > 
> > diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
> > index 2ca056a3707c..8941c3a8ff8a 100644
> > --- a/arch/x86/boot/compressed/mem_encrypt.S
> > +++ b/arch/x86/boot/compressed/mem_encrypt.S
> > @@ -145,6 +145,34 @@ SYM_CODE_START(startup32_vc_handler)
> >  	jnz	.Lfail
> >  	movl	%edx, 0(%esp)		# Store result
> >  
> > +	/*
> > +	 * Sanity check CPUID results from the Hypervisor. See comment in
> > +	 * do_vc_no_ghcb() for more details on why this is necessary.
> > +	 */
> > +
> > +	/* Fail if Hypervisor bit not set in CPUID[1].ECX[31] */
> 
> This check is flawed, as is the existing check in 64-bit boot.  Or I guess more
> accurately, the check in get_sev_encryption_bit() is flawed.  AIUI, SEV-ES
> doesn't require the hypervisor to intercept CPUID.  A malicious hypervisor can
> temporarily pass-through CPUID to bypass the CPUID[1].ECX[31] check.

If erroneous information is provided, either through interception or without, there's
this check which is performed every time a new page table is set in the early linux stages:
https://elixir.bootlin.com/linux/v5.12-rc2/source/arch/x86/kernel/sev_verify_cbit.S#L22

This should lead to a halt if corruption is detected, unless I'm overlooking something.
Please share more info.


> The
> hypervisor likely has access to the guest firmware source, so it wouldn't be
> difficult for the hypervisor to disable CPUID interception once it detects that
> firmware is handing over control to the kernel.
> 

You probably don't even need to know the firmware for that. There the option to set CR* changes to cause
#AE which probably gives away enough information.

> > +	cmpl    $1, %ebx
> > +	jne     .Lcheck_leaf
> > +	btl     $31, 4(%esp)
> > +	jnc     .Lfail
> > +	jmp     .Ldone
> > +
> > +.Lcheck_leaf:
> > +	/* Fail if SEV leaf not available in CPUID[0x80000000].EAX */
> > +	cmpl    $0x80000000, %ebx
> > +	jne     .Lcheck_sev
> > +	cmpl    $0x8000001f, 12(%esp)
> > +	jb      .Lfail
> > +	jmp     .Ldone
> > +
> > +.Lcheck_sev:
> > +	/* Fail if SEV bit not set in CPUID[0x8000001f].EAX[1] */
> > +	cmpl    $0x8000001f, %ebx
> > +	jne     .Ldone
> > +	btl     $1, 12(%esp)
> > +	jnc     .Lfail
> > +
> > +.Ldone:
> >  	popl	%edx
> >  	popl	%ecx
> >  	popl	%ebx
> > @@ -158,6 +186,14 @@ SYM_CODE_START(startup32_vc_handler)
> >  
> >  	iret
> >  .Lfail:
> > +	/* Send terminate request to Hypervisor */
> > +	movl    $0x100, %eax
> > +	xorl    %edx, %edx
> > +	movl    $MSR_AMD64_SEV_ES_GHCB, %ecx
> > +	wrmsr
> > +	rep; vmmcall
> > +
> > +	/* If request fails, go to hlt loop */
> >  	hlt
> >  	jmp .Lfail
> >  SYM_CODE_END(startup32_vc_handler)
> > -- 
> > 2.30.1
> > 
