Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3723345BA
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 18:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhCJRwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 12:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbhCJRv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 12:51:57 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D9AC061761
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 09:51:57 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so7914329pjb.2
        for <kvm@vger.kernel.org>; Wed, 10 Mar 2021 09:51:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YAIZBUejgsuRm3I/i8T3yjE4IQIAIxaYEAKBNsGudB8=;
        b=n7lAY9Mh6yDTmTTIv7zZyu41T9/hF6k4r9wQkCHFWNi0aKhriqdg3RwoAnkmp+lgwk
         Oy/bbQXbJgFLBo6GR1J30O/H2pM+3SOBLTotrHTTK0VLehStaNQLiDWXyxAJE2mjc1dC
         ntlQpJkvDo7H5ChokF7zw02U6yB/4+aEXUwD/2Pv32YC3hrMeWgJsBKnkja+L5kqQPis
         M5sJUpsQ6+Lckj2ERtiVM0F9lRmy8+qRydOp6ns1Gh33ktnXoaNPdndAPw7s0nZF9HER
         /8iZil8ckUoUwH6HzX7JXqVCfmQc1AkEcafLpOg1TaxViD/cyNak0teaHOHK2/PnZ8Dm
         ngVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YAIZBUejgsuRm3I/i8T3yjE4IQIAIxaYEAKBNsGudB8=;
        b=N70BhsWdJDvWhhFBE69l2S95xO8wVkhLCYxw/pujW4Pl4tLsg/5RldPnnbTP70CS2r
         lNmwQ8LZ7E0CAXaA8Nk8O/4M5KMXhAGLZduYSpTW/RP767eMXNWFBx71s6pS9T0MLgG/
         GNi8e1/1SjiUPJoZJYw1Ga6hkLPJLq3xa6cAxWbkt1EmYsxijS/SoOrC0U0awKh2E88Z
         ybG2K59IRYF37tlmuTI2KnxSnE4La5wZ5bPuqpPxYOuuPcpeRfIYDlDbX/ZnQ60uoef2
         iArWgHx3rcmrtjkeQwpCtZijxj6o5XhkVjTiBON51lP/GIVy47dEx9qFMyM50Vwv3sBE
         PxDg==
X-Gm-Message-State: AOAM532BQiD9DSqU0Sp4dxwzf3Qtclk0c0VdEzLTenLwOqfNuiBb3doK
        j+nAOgkqWcJqeINWiUs3slQoFw==
X-Google-Smtp-Source: ABdhPJx2/KjxJOlLrywlrZyCi4etdMjlYm9VOhRGmyxW79l/RXMdX6XsloC3NohTmM/VTndD9sLVmA==
X-Received: by 2002:a17:902:b610:b029:e3:2b1e:34ff with SMTP id b16-20020a170902b610b02900e32b1e34ffmr4041572pls.69.1615398716928;
        Wed, 10 Mar 2021 09:51:56 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
        by smtp.gmail.com with ESMTPSA id f3sm164471pfe.25.2021.03.10.09.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 09:51:56 -0800 (PST)
Date:   Wed, 10 Mar 2021 09:51:48 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Martin Radev <martin.b.radev@gmail.com>
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
Message-ID: <YEkHNDgmybNI+Ptt@google.com>
References: <20210310084325.12966-1-joro@8bytes.org>
 <20210310084325.12966-6-joro@8bytes.org>
 <YEjvBfJg8P1SQt98@google.com>
 <YEkBU9em9SQZ25vA@martin-ThinkPad-T440p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEkBU9em9SQZ25vA@martin-ThinkPad-T440p>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021, Martin Radev wrote:
> On Wed, Mar 10, 2021 at 08:08:37AM -0800, Sean Christopherson wrote:
> > On Wed, Mar 10, 2021, Joerg Roedel wrote:
> > > +	/*
> > > +	 * Sanity check CPUID results from the Hypervisor. See comment in
> > > +	 * do_vc_no_ghcb() for more details on why this is necessary.
> > > +	 */
> > > +
> > > +	/* Fail if Hypervisor bit not set in CPUID[1].ECX[31] */
> > 
> > This check is flawed, as is the existing check in 64-bit boot.  Or I guess more
> > accurately, the check in get_sev_encryption_bit() is flawed.  AIUI, SEV-ES
> > doesn't require the hypervisor to intercept CPUID.  A malicious hypervisor can
> > temporarily pass-through CPUID to bypass the CPUID[1].ECX[31] check.
> 
> If erroneous information is provided, either through interception or without, there's
> this check which is performed every time a new page table is set in the early linux stages:
> https://elixir.bootlin.com/linux/v5.12-rc2/source/arch/x86/kernel/sev_verify_cbit.S#L22
> 
> This should lead to a halt if corruption is detected, unless I'm overlooking something.
> Please share more info.

That check is predicated on sme_me_mask != 0, sme_me_mask is set based on the
result of get_sev_encryption_bit(), and that returns '0' if CPUID[1].ECX[31] is
'0'.

sme_enable() also appears to have the same issue, as CPUID[1].ECX[31]=0 would
cause it to check for SME instead of SEV, and the hypervisor can simply return
0 for a VMGEXIT to get MSR_K8_SYSCFG.

I've no idea if the guest would actually survive with a bogus sme_me_mask, but
relying on CPUID[1] to #VC is flawed.

Since MSR_AMD64_SEV is non-interceptable, that seems like it should be the
canonical way to detect SEV/SEV-ES.  The only complication seems to be handling
#GP faults on the RDMSR in early boot.

> > The hypervisor likely has access to the guest firmware source, so it
> > wouldn't be difficult for the hypervisor to disable CPUID interception once
> > it detects that firmware is handing over control to the kernel.
> > 
> 
> You probably don't even need to know the firmware for that. There the option
> to set CR* changes to cause #AE which probably gives away enough information.
