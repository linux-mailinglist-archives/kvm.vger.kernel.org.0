Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946253C2838
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhGIRYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 13:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhGIRYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 13:24:41 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0879C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 10:21:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso7476335pjx.1
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 10:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nc1RujRxUKzPX3Wrhc15+dX4Hbs3SpGgW4ZBkvgtlWw=;
        b=vScavMm43CmPwbVKjYLaRrlJJBUpzt6Ad/5991OiMkMuKQlSiGQwiIYo4lHzl/QBJj
         TLW0rjN4FYi8zqNuiRyY4xktnEabUQQzzkhPw6vQzFmwI1ncCEBwFysmjz6ZXwfBLk0D
         CYBiXQMoGbRo0ye2XA7/7OWmS5svjqOKCkNPIbM25RX7FOrFG4QU72L1n1QI2RZrAo8A
         Z+FKcZDIkQZZQWnr8VbFrj3loB8V4Hvvs5dbsCeMUFJ5oSnsW0FDbYJHyk/xYVWsj0tQ
         +VNf7u4NJa8BTlJh0KclzgrLQNGwObZcVDyrht27TYXfsiImuv47RokCfemhaYoTtWOS
         t9pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nc1RujRxUKzPX3Wrhc15+dX4Hbs3SpGgW4ZBkvgtlWw=;
        b=SbrFc/h0sGUxJ9V4TOPpYNSMPB0DGSJ9LFo8LqZqh5YDxe3GSSb3H2DBwDJ2yRJXa6
         SMKm7xL01WNYujaHpMVqi4Wyfl0/EvLG5MOqjT1H/GivkKDdMOjxwMYNd7hUG9JDBWcp
         MTR+rdNR1bl+43a1vUCnPtS4GnZFeGt88ZTIHaoPDZEXPJbEYZZQAx1hFXjzIWMybKjr
         MmJaaODsriuXxxBCqRj87kr0oGabZiPp7Q0/HDWMBE+lgJv6Nz2LjVnAQMDV0XlrnfC5
         WXhYHkeQZdGTtK6tTYzXIKx3x84OfaYpjNwKLyYZXqKb8dV0Qzqx6EXdhRL3DjYjRscj
         InOw==
X-Gm-Message-State: AOAM530Cf6exQluaxI5J8jPCxY9z2f2nLk30JDkcFU7nRURNjMIqmtwg
        vzuwtmDhRKi4fbu2pAgeMlfcKw==
X-Google-Smtp-Source: ABdhPJzhykY6zt8ypwrURBbnuE9gwCHbkXLnj4Ko+JmUddPmGTfMZoWr75VP9CfeQGX0ZlXJ3PgRhA==
X-Received: by 2002:a17:902:7488:b029:129:c9cd:67ec with SMTP id h8-20020a1709027488b0290129c9cd67ecmr11958540pll.58.1625851316960;
        Fri, 09 Jul 2021 10:21:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d1sm6577298pfu.6.2021.07.09.10.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 10:21:56 -0700 (PDT)
Date:   Fri, 9 Jul 2021 17:21:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "KVM: x86: WARN and reject loading KVM if NX is
 supported but not enabled"
Message-ID: <YOiFsB9vZgMcpJZu@google.com>
References: <20210625001853.318148-1-seanjc@google.com>
 <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28ec9d07-756b-f546-dad1-0af751167838@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 08, 2021, Paolo Bonzini wrote:
> On 25/06/21 02:18, Sean Christopherson wrote:
> > Let KVM load if EFER.NX=0 even if NX is supported, the analysis and
> > testing (or lack thereof) for the non-PAE host case was garbage.
> > 
> > If the kernel won't be using PAE paging, .Ldefault_entry in head_32.S
> > skips over the entire EFER sequence.  Hopefully that can be changed in
> > the future to allow KVM to require EFER.NX, but the motivation behind
> > KVM's requirement isn't yet merged.  Reverting and revisiting the mess
> > at a later date is by far the safest approach.
> > 
> > This reverts commit 8bbed95d2cb6e5de8a342d761a89b0a04faed7be.
> > 
> > Fixes: 8bbed95d2cb6 ("KVM: x86: WARN and reject loading KVM if NX is supported but not enabled")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> > 
> > Hopefully it's not too late to just drop the original patch...
> > 
> >   arch/x86/kvm/x86.c | 3 ---
> >   1 file changed, 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4a597aafe637..1cc02a3685d0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10981,9 +10981,6 @@ int kvm_arch_hardware_setup(void *opaque)
> >   	int r;
> >   	rdmsrl_safe(MSR_EFER, &host_efer);
> > -	if (WARN_ON_ONCE(boot_cpu_has(X86_FEATURE_NX) &&
> > -			 !(host_efer & EFER_NX)))
> > -		return -EIO;
> >   	if (boot_cpu_has(X86_FEATURE_XSAVES))
> >   		rdmsrl(MSR_IA32_XSS, host_xss);
> > 
> 
> So do we want this or "depends on X86_64 || X86_PAE"?

Hmm, I'm leaning towards keeping !PAE support purely for testing the !PAE<->PAE
MMU transitions for nested virtualization.  It's not much coverage, and the !PAE
NPT horror is a much bigger testing gap (because KVM doesn't support it), but on
the other hand setting EFER.NX for !PAE kernels appears to be trivial, e.g.

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 67f590425d90..bfbea25a9fe8 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -214,12 +214,6 @@ SYM_FUNC_START(startup_32_smp)
        andl $~1,%edx                   # Ignore CPUID.FPU
        jz .Lenable_paging              # No flags or only CPUID.FPU = no CR4

-       movl pa(mmu_cr4_features),%eax
-       movl %eax,%cr4
-
-       testb $X86_CR4_PAE, %al         # check if PAE is enabled
-       jz .Lenable_paging
-
        /* Check if extended functions are implemented */
        movl $0x80000000, %eax
        cpuid

My only hesitation is the risk of somehow breaking ancient CPUs by falling into
the NX path.  Maybe try forcing EFER.NX=1 for !PAE, and fall back to requiring
PAE if that gets NAK'd or needs to be reverted for whatever reason?
