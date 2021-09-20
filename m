Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BE54118DC
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238363AbhITQIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 12:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhITQIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 12:08:37 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F44C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 09:07:10 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 145so2757769pfz.11
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 09:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=itsXyZ7jguPhr3bK0GIBz8XHWfLYp7eKoXqnDU/8Lpk=;
        b=Uy95jo46zcjnm1ARS467XhRXqOoHrxDj5afayc9YrQfXOn6c7dq/LA4TVa8BKcFu5P
         aKybacCfrfrMN8ZUXMlUPmocznl+1Ig7+uQX7omlu/vjsElNmEumpkBkq4w2hS5YgSxT
         nkXPiSDtvzRIGeKk0Llj/yT1yta+YLeJOWtJt8eGTZ06x7rmTESoLMSDA31FBbIeVAHA
         LItf0RKF6EWuI9FmX1vxwXBN0FO2b5EUiXDlB1/wAr+TZRR/Itc8UeGSB96vmJLMTe1i
         v8S8GLrRsn5YnyGLSYktPfyKmWGhjWA8/cr9x4IVhNtM9J3gGjwKpMwUy5f91vGirpNz
         7u0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=itsXyZ7jguPhr3bK0GIBz8XHWfLYp7eKoXqnDU/8Lpk=;
        b=I6EGHmoBoRU6rv51xkntlcfqtAhvpez+pFMWrNoDSgn8ZW29XVDvMV+hEXA9mcHV/V
         lmpvKgED2n1DJag+7Zb7UX1Y8hW3BWnIwZba/xWKyEX16ZfmSiPlolndmoqJhz8L5KQS
         HRycS0/Cf6ytROYVCIenNqG8cVTSlw+ay78ngTKoXdF6TbLHs89bUGXqMDJIcc1iQLeM
         CALePLyT/qjFLmSozOlSINmkqfsyedvgbXSBy0WgJaIppXPfF6NIUXvLxf+t5Oydba8b
         9bGDmWtaVFx9I62yN1jfN/Vft14Tc+nwFHNOpD5247FLMSfsbUMFnSuHXh3TbTb8hZt8
         6tbw==
X-Gm-Message-State: AOAM532Nb86hfRP6Zvdl00NSCsAELYAU/xGAaPK/2R0CCPO9humLIqpY
        ksTFLbTMOyxjZbZCMrE1BK1ePg==
X-Google-Smtp-Source: ABdhPJwfGga4x4k4I1A/DBJ/7hT5H15rnGUWQbAes0XcZJteGNIYvIfYM3Zjc73a/TQuNZjaAorFrg==
X-Received: by 2002:a62:4e4a:0:b0:444:59c3:665e with SMTP id c71-20020a624e4a000000b0044459c3665emr20809877pfb.0.1632154029683;
        Mon, 20 Sep 2021 09:07:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m28sm15749201pgl.9.2021.09.20.09.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 09:07:09 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:07:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@alien8.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YUixqL+SRVaVNF07@google.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021, Steve Rutherford wrote:
> Looking at these threads, this patch either:
> 1) Needs review/approval from a maintainer that is interested or
> 2) Should flip back to using alternative (as suggested by Sean). In
> particular: `ALTERNATIVE("vmmcall", "vmcall",
> ALT_NOT(X86_FEATURE_VMMCALL))`. My understanding is that the advantage
> of this is that (after calling apply alternatives) you get exactly the
> same behavior as before. But before apply alternatives, you get the
> desired flipped behavior. The previous patch changed the behavior
> after apply alternatives in a very slight manner (if feature flags
> were not set, you'd get a different instruction).
> 
> I personally don't have strong feelings on this decision, but this
> decision does need to be made for this patch series to move forward.
> 
> I'd also be curious to hear Sean's opinion on this since he was vocal
> about this previously.

Pulling in Ashish's last email from the previous thread, which I failed to respond
to.

https://lore.kernel.org/all/20210820133223.GA28059@ashkalra_ubuntu_server/T/#u

On Fri, Aug 20, 2021, Ashish Kalra wrote:
> On Thu, Aug 19, 2021 at 11:15:26PM +0000, Sean Christopherson wrote:
> > On Thu, Aug 19, 2021, Kalra, Ashish wrote:
> > >
> > > > On Aug 20, 2021, at 3:38 AM, Kalra, Ashish <Ashish.Kalra@amd.com> wrote:
> > > > I think it makes more sense to stick to the original approach/patch, i.e.,
> > > > introducing a new private hypercall interface like kvm_sev_hypercall3() and
> > > > let early paravirtualized kernel code invoke this private hypercall
> > > > interface wherever required.
> >
> > I don't like the idea of duplicating code just because the problem is tricky to
> > solve.  Right now it's just one function, but it could balloon to multiple in
> > the future.  Plus there's always the possibility of a new, pre-alternatives
> > kvm_hypercall() being added in generic code, at which point using an SEV-specific
> > variant gets even uglier.

...

> Now, apply_alternatives() is called much later when setup_arch() calls
> check_bugs(), so we do need some kind of an early, pre-alternatives
> hypercall interface.
>
> Other cases of pre-alternatives hypercalls include marking per-cpu GHCB
> pages as decrypted on SEV-ES and per-cpu apf_reason, steal_time and
> kvm_apic_eoi as decrypted for SEV generally.
>
> Actually using this kvm_sev_hypercall3() function may be abstracted
> quite nicely. All these early hypercalls are made through
> early_set_memory_XX() interfaces, which in turn invoke pv_ops.
>
> Now, pv_ops can have this SEV/TDX specific abstractions.
>
> Currently, pv_ops.mmu.notify_page_enc_status_changed() callback is setup
> to kvm_sev_hypercall3() in case of SEV.
>
> Similarly, in case of TDX, pv_ops.mmu.notify_page_enc_status_changed() can
> be setup to a TDX specific callback.
>
> Therefore, this early_set_memory_XX() -> pv_ops.mmu.notify_page_enc_status_changed()
> is a generic interface and can easily have SEV, TDX and any other future platform
> specific abstractions added to it.

Unless there's some fundamental technical hurdle I'm overlooking, if pv_ops can
be configured early enough to handle this, then so can alternatives.  Adding
notify_page_enc_status_changed() may be necessary in the future, e.g. for TDX
or SNP, but IMO that is orthogonal to adding a generic, 100% redundant helper.

I appreciate that simply swapping the default from VMCALL->VMMCALL is a bit dirty
since it gives special meaning to the default value, but if that's the argument
against reusing kvm_hypercall3() then we should solve the early alternatives
problem, not fudge around it.
