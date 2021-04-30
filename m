Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB43A36FF56
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhD3RR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 13:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3RR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 13:17:29 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCDFC06174A
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 10:16:39 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso60275264otv.6
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 10:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g1ttLCcW/nGhZcY9yTkxX6ZUtwNAzhBBtVEEB75UXcA=;
        b=yPGGvOVBRE8QvYKntQneVaN0cN3nGP4zy7MfklcqCKffXHtU36NShOZbccMT+qbr3M
         fwkfII3O45DbzFGHakRHfGO7wfDNFoHj7yy6T8MLT6n23pEjASKJreZTo8uEAZhhRLGW
         Rmc2B/OH+OKsCwzHFKx6lJYA9ugIpUFtDUQhk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g1ttLCcW/nGhZcY9yTkxX6ZUtwNAzhBBtVEEB75UXcA=;
        b=cu+z/VXpfDwrRMKe8JquFVjkETamRQlT2pzsVz126+H4jr+Du3w15rmA5F37D8QK8N
         zvNAHCIPi1AQqiT3Qy3PbnXGebp9n4RuWowMIbQO3aCRgwc2QQUAgXaCTcJVS0zfhMLI
         sgXLQK9J0VX6JN4NBYI3gj2qj+Wdvk3AAFqLlduVmy5SXFcxnmFQZ66dYmnlo3Dg0vJF
         xpq2yJlx0tW2KmI9u2kMpsM1ou40tNP6CrFeauZbiatiLFHrHpECq7Cxp4FLtOzG0xGl
         Mkjy045Bj+hVyMKBbkmNc2EskhVJwsgALL0mh1scs4gb5lmPIKlLK9OTGr3ekuUJ33M2
         ri2w==
X-Gm-Message-State: AOAM532ECdIf3kca2xUE6ohgxf0tO4jO7wkS8Vz8YCq+RSfsmgTjhrVP
        yJZ8J/k0oNZXhO7te19+r6IA8sCxTKczK1mwwGJgnw==
X-Google-Smtp-Source: ABdhPJx9XlYR7IQTFj2hAHpZi75kz2P+NxV/riLTJtiNjE+oASj5yULWkX1Rn5848UiXCpyVGb++R9m0u8fCp1ro/IE=
X-Received: by 2002:a05:6830:1c76:: with SMTP id s22mr4369380otg.46.1619802999259;
 Fri, 30 Apr 2021 10:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GKd_YR9QmTR-6KsiE16=4s8fuqh8pmQTYnxHXS=mYp9g@mail.gmail.com>
 <YH2z3uuQYwSyGJfL@google.com> <CAJGDS+FGnDFssYXLfLrog+AJu62rrs6DzAQuESJSDaNNdsYdcw@mail.gmail.com>
 <CAJGDS+GT1mKHz6K=qHQf54S_97ym=nRP12MfO6OSEOpLYGht=A@mail.gmail.com>
 <YIbkxXwHPTPhN20C@google.com> <CAJGDS+EjtHmV7fdQmtHfiRG3uywd5=XbFb_VWr-GhCpmuN+=zA@mail.gmail.com>
In-Reply-To: <CAJGDS+EjtHmV7fdQmtHfiRG3uywd5=XbFb_VWr-GhCpmuN+=zA@mail.gmail.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Fri, 30 Apr 2021 22:46:28 +0530
Message-ID: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
Subject: Re: Intercepting RDTSC instruction by causing a VMEXIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sean,

Thank you for all your help. I've now managed to cause a VMEXIT in the
guest. I've also identified which guest registers to access to read
and record the tsc counter value when the vmexit handler is called in
userspace.

Best Regards,
Arnabjyoti Kalita

On Tue, Apr 27, 2021 at 7:49 AM Arnabjyoti Kalita
<akalita@cs.stonybrook.edu> wrote:
>
> Hello Sean,
>
> Thank you very much again. I didn't know about the tracepointing
> methodology. This is very helpful, indeed.
>
> In addition to my requirement of recording tsc values, I am trying to
> track when the VMEXITs happen in userspace(QEMU). This allows me to
> correlate recorded TSC values with the VMEXIT sequence. So, causing a
> VMEXIT in userspace is absolutely essential to me and I would love to
> have some pointers on how to do it.
>
> I run a server within the guest and I'm okay with performance dropping
> down to within a factor of 2 compared to running the server on native
> hardware. I run this experiment for about 20-30 seconds.
>
> Best Regards,
> Arnabjyoti Kalita
>
>
> On Mon, Apr 26, 2021 at 9:35 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Apr 26, 2021, Arnabjyoti Kalita wrote:
> > > Hello Sean,
> > >
> > > Thank you very much for your answer again. I could actually see that the
> > > RDTSC handler gets called successfully. I added a "printk" statement to the
> > > handler and I can see the messages being printed out to the kernel syslog.
> > >
> > > However, I am not sure if a VMEXIT is happening in userspace. I use QEMU
> > > and I do not see any notification from QEMU that tells me that a VMEXIT
> > > happened due to RDTSC being executed. Is there a mechanism to confirm this?
> >
> > Without further modification, KVM will _not_ exit to userspace in this case.
> >
> > > My actual requirement to record tsc values read out as a result of RDTSC
> > > execution still stands.
> >
> > Your requirement didn't clarify that userspace needed to record the values ;-)
> >
> > Forcing an exit to userspace is very doable, but will tank guest performance and
> > possibly interfere with whatever you're trying to do.  I would try adding a
> > tracepoint and using that to capture the TSC values.  Adding guest RIP, etc...
> > as needed is trivial.
> >
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index a61c015870e3..e962e813ba04 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -821,6 +821,23 @@ TRACE_EVENT(
> >                   __entry->gpa_match ? "GPA" : "GVA")
> >  );
> >
> > +TRACE_EVENT(kvm_emulate_rdtsc,
> > +       TP_PROTO(unsigned int vcpu_id, __u64 tsc),
> > +       TP_ARGS(vcpu_id, tsc),
> > +
> > +       TP_STRUCT__entry(
> > +               __field( unsigned int,  vcpu_id         )
> > +               __field(        __u64,  tsc             )
> > +       ),
> > +
> > +       TP_fast_assign(
> > +               __entry->vcpu_id                = vcpu_id;
> > +               __entry->tsc                    = tsc;
> > +       ),
> > +
> > +       TP_printk("vcpu=%u tsc=%llu", __entry->vcpu_id, __entry->tsc)
> > +);
> > +
> >  TRACE_EVENT(kvm_write_tsc_offset,
> >         TP_PROTO(unsigned int vcpu_id, __u64 previous_tsc_offset,
> >                  __u64 next_tsc_offset),
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 61bf0b86770b..1fbeef520349 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -5254,6 +5254,8 @@ static int handle_rdtsc(struct kvm_vcpu *vcpu)
> >  {
> >         u64 tsc = kvm_read_l1_tsc(vcpu, rdtsc());
> >
> > +       trace_kvm_emulate_rdtsc(vcpu->vcpu_id, tsc);
> > +
> >         kvm_rax_write(vcpu, tsc & -1u);
> >         kvm_rdx_write(vcpu, (tsc >> 32) & -1u);
> >         return kvm_skip_emulated_instruction(vcpu);
