Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E649D334652
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 19:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhCJSLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 13:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbhCJSLG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 13:11:06 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17723C061760;
        Wed, 10 Mar 2021 10:11:06 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id r3so26891689lfc.13;
        Wed, 10 Mar 2021 10:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u7OI8DEe+NFQ9osOSl+yhqMf9zckEsOBhWXjBCNNUbk=;
        b=WOAj1tiUzgeiWPaKYhYiHiSWjWJPR55uY7pPW48ySeBQVJdbndEtGD1a4FuLRINeEm
         AGDkYl6omMnOJoZxXLs09+i+jqt92g54LlJJ016fcAk4ZTsx/hj1XBrQqBztXIIrrUtH
         OsFzfdoMudG8MDmd8QCe+ROU7MyOlWi4VFML+aP31d2xs3V4quXulYM4B2ujz4JH0Wqu
         73QqgUAuaz7+DuODxFqOwZ87fb9cMA4RHMfzL8JWsJzAwrCose0DADEHZcc+3mNMlUiH
         CtqYBaAK04dQe6G8/13hCyLNl9kwGTIbfcYE7IfxTm1ksMS8WRuWfbFyYL6SX5lCU50W
         NFWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u7OI8DEe+NFQ9osOSl+yhqMf9zckEsOBhWXjBCNNUbk=;
        b=h+uoX9W5FLdekX2XP/wbOR9iVRXb5nRkDYfaPFUrgQgYVwpCNdcO3V5iHInO6UQE0t
         jb+eSO0CX6EHYvFHxmfnJlpvn4HqHJzZjkMThn9bGUsyv72acHdSivt2In4eDjP/zY8O
         L0DovLJVDml1xqe/MYWdw5MQ6h0WYpEZ4pXDZWHAW34CcQqDG/UEZXYl+ATigv7V06bk
         QA4SRAc4kY4d0AZmX4KgBT9RIzDDTyIgedQCIt0kBOR+N882SfIrXjTi1ZqFZhWXUj5s
         RFf3dHY/DcdbsWLIPzI6h+UoUlBaLvq9ynVJlh0qwN3tZ9lejmTCIkSH/v+1awHTQ44J
         CkXQ==
X-Gm-Message-State: AOAM533PwnKJyNpDj7nIBydDkOcbl14MO5V/+eYxbofHIwhJ/w3MyFy8
        HP+gOcYR5Bc4YrC9x+U1PNc=
X-Google-Smtp-Source: ABdhPJySmgeWkOYybrZfIw0tAmT+Y3eatieN0zNSm5zzMLBjTPV4MUO3wQBiwVM+YKvIXws2LdAc2A==
X-Received: by 2002:ac2:546b:: with SMTP id e11mr2663951lfn.48.1615399852379;
        Wed, 10 Mar 2021 10:10:52 -0800 (PST)
Received: from martin-ThinkPad-T440p (88-115-234-24.elisa-laajakaista.fi. [88.115.234.24])
        by smtp.gmail.com with ESMTPSA id r15sm68506ljj.88.2021.03.10.10.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 10:10:52 -0800 (PST)
Date:   Wed, 10 Mar 2021 19:10:49 +0100
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
Message-ID: <YEkLqawkO08wHWcx@martin-ThinkPad-T440p>
References: <20210310084325.12966-1-joro@8bytes.org>
 <20210310084325.12966-6-joro@8bytes.org>
 <YEjvBfJg8P1SQt98@google.com>
 <YEkBU9em9SQZ25vA@martin-ThinkPad-T440p>
 <YEkHNDgmybNI+Ptt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEkHNDgmybNI+Ptt@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 09:51:48AM -0800, Sean Christopherson wrote:
> On Wed, Mar 10, 2021, Martin Radev wrote:
> > On Wed, Mar 10, 2021 at 08:08:37AM -0800, Sean Christopherson wrote:
> > > On Wed, Mar 10, 2021, Joerg Roedel wrote:
> > > > +	/*
> > > > +	 * Sanity check CPUID results from the Hypervisor. See comment in
> > > > +	 * do_vc_no_ghcb() for more details on why this is necessary.
> > > > +	 */
> > > > +
> > > > +	/* Fail if Hypervisor bit not set in CPUID[1].ECX[31] */
> > > 
> > > This check is flawed, as is the existing check in 64-bit boot.  Or I guess more
> > > accurately, the check in get_sev_encryption_bit() is flawed.  AIUI, SEV-ES
> > > doesn't require the hypervisor to intercept CPUID.  A malicious hypervisor can
> > > temporarily pass-through CPUID to bypass the CPUID[1].ECX[31] check.
> > 
> > If erroneous information is provided, either through interception or without, there's
> > this check which is performed every time a new page table is set in the early linux stages:
> > https://elixir.bootlin.com/linux/v5.12-rc2/source/arch/x86/kernel/sev_verify_cbit.S#L22
> > 
> > This should lead to a halt if corruption is detected, unless I'm overlooking something.
> > Please share more info.
> 
> That check is predicated on sme_me_mask != 0, sme_me_mask is set based on the
> result of get_sev_encryption_bit(), and that returns '0' if CPUID[1].ECX[31] is
> '0'.
> 
> sme_enable() also appears to have the same issue, as CPUID[1].ECX[31]=0 would
> cause it to check for SME instead of SEV, and the hypervisor can simply return
> 0 for a VMGEXIT to get MSR_K8_SYSCFG.
> 
> I've no idea if the guest would actually survive with a bogus sme_me_mask, but
> relying on CPUID[1] to #VC is flawed.
> 
> Since MSR_AMD64_SEV is non-interceptable, that seems like it should be the
> canonical way to detect SEV/SEV-ES.  The only complication seems to be handling
> #GP faults on the RDMSR in early boot.
> 
> > > The hypervisor likely has access to the guest firmware source, so it
> > > wouldn't be difficult for the hypervisor to disable CPUID interception once
> > > it detects that firmware is handing over control to the kernel.
> > > 
> > 
> > You probably don't even need to know the firmware for that. There the option
> > to set CR* changes to cause #AE which probably gives away enough information.

I see what you mean but I never tried out disabling interception for cpuid.
There was the idea of checking for bogus information in the VC handler, but what
you suggested would bypass it, I guess.

If the C-bit is not set and memory gets interpreted as unencrypted, then the HV
can gain code execution easily by means of ROP and then switch to the OVMF page
table to easily do proper payload injection.

If interested, check video at https://fosdem.org/2021/schedule/event/tee_sev_es/
on minute 15.

