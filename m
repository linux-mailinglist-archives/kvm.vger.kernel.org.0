Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244E2379454
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 18:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbhEJQpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 12:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbhEJQpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 12:45:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00E5C06175F
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:43:54 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k5so513868pjj.1
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 09:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QULoJ0SNPB24UWoCTsLENCPq0GiItK6XvhhTWI3rQSE=;
        b=NGMRB8wqHqQxCcnVxtb+STRwI01jqDIsfmwmXAG4F8fO6jwGnhS3CV/77i9qG7uCE/
         SDJ26pVfhdr4tZjzv9dl8mS1UsyHN8Wo2OJFHaviPYXBST+OnBu3XkaG++Zo6BncMnH2
         4GEvBy/6dlGnQbwGRxNgynsQgSzyNJmTD+HAC8xNzR+OvgTZf3AuMySdKPJnE/mOKumb
         dm0AQFslgcgdgltgIowfi15piIccrGkqLgFrixkY3w2syx9rAHG9drCt4faByN5o8CGd
         3eGPzIUj4THZ5g6dyVQXXyZuvvSH/PErazoVh1Yhs4t2DyICZwij6t4hFBA6RrLg2p7O
         nZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QULoJ0SNPB24UWoCTsLENCPq0GiItK6XvhhTWI3rQSE=;
        b=TU3snqqqao77lGeEuvFw6nk+Frj1kC3nIoe96baLajh45y8EbkPjBuIkr6oH8RJ1B0
         TA2f3WGVB2ruRckdajxNmM9StycIuhUmpNlfbuzU67lr4NJtvQ9BJ010q+rmIXQfoSn6
         dTdLPc/v8yw0KYqrt8q5g/M6jGVq+Q8cY0uIFcAO7jm86xWFQHeqjtdOoo4SbKM7Eho9
         FkM/AkIhilI6LSQ0I620Nh+2QWp/8sMbKsCgHmgfHuRxFGGtg0VlaJTEzBbMsA9xdQTV
         fW2s/LBo88SDgPhzR9uG/2FFpou9FPK5RAm3E3OKTL/BUYB6o4/3STBcjaF5YCrWW1Gc
         En/w==
X-Gm-Message-State: AOAM532cJQV5eQHRvQtOlsPSA0wSlJmJv4AJnQCLYGnAz2FxPX2luCj0
        niDGjkWS4ldzO+3rILRtSRik6TrvoTjZMw==
X-Google-Smtp-Source: ABdhPJz7dR2r+pOIFi4B5085WH86k5cw6pZDQMSisn1SEYN1rA1HPgKbr53WG11MVV6txMyG4R6SOQ==
X-Received: by 2002:a17:90b:3689:: with SMTP id mj9mr28683768pjb.154.1620665034345;
        Mon, 10 May 2021 09:43:54 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id i20sm11290982pjz.48.2021.05.10.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 09:43:53 -0700 (PDT)
Date:   Mon, 10 May 2021 16:43:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 09/15] KVM: VMX: Use flag to indicate "active" uret MSRs
 instead of sorting list
Message-ID: <YJlixiTcwFkrnxIL@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
 <20210504171734.1434054-10-seanjc@google.com>
 <CAAeT=FyKjHykGNcQc=toqvhCR281SWc6UqNihsjyU+vuo3z5Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FyKjHykGNcQc=toqvhCR281SWc6UqNihsjyU+vuo3z5Yg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021, Reiji Watanabe wrote:
> > -static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
> > +static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
> > +                              bool load_into_hardware)
> >  {
> > -       struct vmx_uret_msr tmp;
> > -       int from, to;
> > +       struct vmx_uret_msr *uret_msr;
> >
> > -       from = __vmx_find_uret_msr(vmx, msr);
> > -       if (from < 0)
> > +       uret_msr = vmx_find_uret_msr(vmx, msr);
> > +       if (!uret_msr)
> >                 return;
> > -       to = vmx->nr_active_uret_msrs++;
> >
> > -       tmp = vmx->guest_uret_msrs[to];
> > -       vmx->guest_uret_msrs[to] = vmx->guest_uret_msrs[from];
> > -       vmx->guest_uret_msrs[from] = tmp;
> > +       uret_msr->load_into_hardware = load_into_hardware;
> >  }
> >
> >  /*
> > @@ -1785,30 +1781,36 @@ static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
> >   */
> >  static void setup_msrs(struct vcpu_vmx *vmx)
> >  {
> > -       vmx->guest_uret_msrs_loaded = false;
> > -       vmx->nr_active_uret_msrs = 0;
> >  #ifdef CONFIG_X86_64
> > +       bool load_syscall_msrs;
> > +
> >         /*
> >          * The SYSCALL MSRs are only needed on long mode guests, and only
> >          * when EFER.SCE is set.
> >          */
> > -       if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
> > -               vmx_setup_uret_msr(vmx, MSR_STAR);
> > -               vmx_setup_uret_msr(vmx, MSR_LSTAR);
> > -               vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK);
> > -       }
> > +       load_syscall_msrs = is_long_mode(&vmx->vcpu) &&
> > +                           (vmx->vcpu.arch.efer & EFER_SCE);
> > +
> > +       vmx_setup_uret_msr(vmx, MSR_STAR, load_syscall_msrs);
> > +       vmx_setup_uret_msr(vmx, MSR_LSTAR, load_syscall_msrs);
> > +       vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK, load_syscall_msrs);
> >  #endif
> > -       if (update_transition_efer(vmx))
> > -               vmx_setup_uret_msr(vmx, MSR_EFER);
> > +       vmx_setup_uret_msr(vmx, MSR_EFER, update_transition_efer(vmx));
> >
> > -       if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
> > -           guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
> > -               vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
> > +       vmx_setup_uret_msr(vmx, MSR_TSC_AUX,
> > +                          guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
> > +                          guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
> 
> Shouldn't vmx_setup_uret_msr(,MSR_TSC_AUX,) be called to update
> the new flag load_into_hardware for MSR_TSC_AUX when CPUID
> (X86_FEATURE_RDTSCP/X86_FEATURE_RDPID) of the vCPU is updated ?

Yes.  I have a patch in the massive vCPU RESET/INIT series to do exactly that.
I honestly can't remember if there was a dependency that "required" the fix to
be buried in the middle of that series.  I suspect not; I'm guessing I just
didn't think it was worth backporting to stable kernels and so didn't prioritize
hoisting the patch out of that mess.

https://lkml.kernel.org/r/20210424004645.3950558-34-seanjc@google.com
