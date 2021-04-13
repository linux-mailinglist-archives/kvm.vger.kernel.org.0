Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E66D35E3F7
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 18:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345433AbhDMQa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 12:30:27 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:42625 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245746AbhDMQaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Apr 2021 12:30:25 -0400
Received: by mail-pf1-f174.google.com with SMTP id w8so8290614pfn.9
        for <kvm@vger.kernel.org>; Tue, 13 Apr 2021 09:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oqhJruPf0NwKnqsJ3Jaa+s01j4A6O2IRGCY7jeCvEjQ=;
        b=XKBReT2XrUEt1w+jT4pbtUHl3cF32KtYjaF5SQLccnHL+XpnP7zvv3rclKhlcYkPgV
         i5/yyTRxcn/fwaetmCAHLyofv8PV2esgVWZgcEcGSBC7mYGU1MKwMuF5vviCRo666luc
         KRJu6xymR1ItKWeglIEaVkFwyLuTLZQ9B5pQkhVUgiIAylgvxpEIQ/SegqQAsC3f6aj6
         wCwUknA5m+wC9G3dp6LMXHrJqnY+XrDw/TMgrDz9HAqbpGu6KfPtBr5NJE4Sb+bTGWb3
         4+T7iTVi+EMjgIgUmWldR/BoW6xCaZlOcxaFReIi0F4t++wn0GklgdjSV8TiiDcuTXq+
         XNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oqhJruPf0NwKnqsJ3Jaa+s01j4A6O2IRGCY7jeCvEjQ=;
        b=N9WGqa+wsf0TmsHGs2hgEMrrNk4CPKQoRWKClScOZE8caqp0lgpfCUlkcBHJdGZf0s
         i2PI2tt+MHhXPxs0fFBnO2az9oFlDBsHyQDbAZj+6DFpcFstv2xl5cwX5/ddJ/QlBy94
         bWo/CVZCfoFgulPjDnh4C9OZWA6CSZW96pLmeMAGfJzTNXv2BuIX8pOlOU3VhMRtJean
         lkTowf5nnWJbA4X+zIxMYt2qpwW3x7FaETDeGCRBwzvNjANptBg7ZAqRty1wiyQ8kY/G
         w8/ESx7ZYgjp9Slozq1gpInnH43U07sYNc8DPOD5/v7jvznzns0j2bDlImiOF6YMqrVZ
         WS6g==
X-Gm-Message-State: AOAM530DdEBBQMwC8xx7y3GXz1fdHvCMvy2HuL6qSyCzfLiHbTRYy6rV
        eYiq2QzeKCicuo2ZJffcOLn4S3k/RoQMr4dOzhd+xv4Fr4Kc5LYE
X-Google-Smtp-Source: ABdhPJyOx4QyHWxeKoAkrYx5x4uINyJOVsWCteXITojz7YOTQRgq7zhGAxbaYCX3Rui16xUeaBA6V2/hAhIG8isjIhw=
X-Received: by 2002:a63:1024:: with SMTP id f36mr13005252pgl.299.1618331345196;
 Tue, 13 Apr 2021 09:29:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210413154739.490299-1-reijiw@google.com> <87a44c1d-8c69-8a1d-8348-4207bf7296a9@redhat.com>
In-Reply-To: <87a44c1d-8c69-8a1d-8348-4207bf7296a9@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 13 Apr 2021 09:28:49 -0700
Message-ID: <CAAeT=Fy_vM+yb8zC6fNNDjoWOzb+6wTNZTfp3iRbAFoK-D+abA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Don't use vcpu->run->internal.ndata as an array index
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13, 2021 at 8:51 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 13/04/21 17:47, Reiji Watanabe wrote:
> > __vmx_handle_exit() uses vcpu->run->internal.ndata as an index for
> > an array access.  Since vcpu->run is (can be) mapped to a user address
> > space with a writer permission, the 'ndata' could be updated by the
> > user process at anytime (the user process can set it to outside the
> > bounds of the array).
> > So, it is not safe that __vmx_handle_exit() uses the 'ndata' that way.
> >
> > Fixes: 1aa561b1a4c0 ("kvm: x86: Add "last CPU" to some KVM_EXIT information")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > ---
> >   arch/x86/kvm/vmx/vmx.c | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
>
> Ouch.  In theory it's an internal error, but we've seen it happen on
> problematic hardware.  Should we consider it a security issue?
>
> Paolo

A user application could intentionally create the case (with a
simple guest).  So, I would think this is a security issue.

Thanks,
Reiji


>
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 32cf8287d4a7..29b40e092d13 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6027,19 +6027,19 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> >            exit_reason.basic != EXIT_REASON_PML_FULL &&
> >            exit_reason.basic != EXIT_REASON_APIC_ACCESS &&
> >            exit_reason.basic != EXIT_REASON_TASK_SWITCH)) {
> > +             int ndata = 3;
> > +
> >               vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> >               vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_DELIVERY_EV;
> > -             vcpu->run->internal.ndata = 3;
> >               vcpu->run->internal.data[0] = vectoring_info;
> >               vcpu->run->internal.data[1] = exit_reason.full;
> >               vcpu->run->internal.data[2] = vcpu->arch.exit_qualification;
> >               if (exit_reason.basic == EXIT_REASON_EPT_MISCONFIG) {
> > -                     vcpu->run->internal.ndata++;
> > -                     vcpu->run->internal.data[3] =
> > +                     vcpu->run->internal.data[ndata++] =
> >                               vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> >               }
> > -             vcpu->run->internal.data[vcpu->run->internal.ndata++] =
> > -                     vcpu->arch.last_vmentry_cpu;
> > +             vcpu->run->internal.data[ndata++] = vcpu->arch.last_vmentry_cpu;
> > +             vcpu->run->internal.ndata = ndata;
> >               return 0;
> >       }
> >
> >
>
