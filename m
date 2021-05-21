Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C40338C05E
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbhEUHI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbhEUHIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:08:51 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF47C061347
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 00:07:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id k5so10498776pjj.1
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 00:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fvdGa2W6OZw/8qxLvD+ODbIG5yXPMASpgnmjBv0KFYg=;
        b=LfUV8jky5sez+lV6LBBxjR6j//RTUAB7gRqIHldrM1y9zrapoHULxXCg2yfmCFg28o
         +jiJ8sYvxdVgBnWLSrpCEp2PpK3R7bhelKJfEl5R3fR2HRtf2BBP2DJhMvYgPdPY+34E
         ApQY6p4IAHU2SjjrGLiRmsTKo0uSZbylw1aUkTgQdOmw1wANg/bhrGCRDLiXbHOqr+dI
         OieDVmBIYFdpvyoWoxH4Cu9pUmsB1P+HpovshrWpaRq7lih9ApyAKzM6bjLMvk9CGdgJ
         VRKm6+ufztaNXlAaam0PkOZNZYc6jQ1uKEY7kErk+l98KJi8uU3fy6DfbafXwgunzNoc
         ig/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fvdGa2W6OZw/8qxLvD+ODbIG5yXPMASpgnmjBv0KFYg=;
        b=FbIeoEcJ5dxMX/1B555PzJ3IwDVdwYIkxa/o9JDam8TDpUlMajX4Yup/sjbJr8H3TN
         8DhYa5l3O5qg2IJJqa5Ga9+eLPFsmDcfS+QM+BbGHrG8ukit2RHLDmQlytwJ15+rfGHb
         6AGUjkxmm175ZCliRosemsrB5zRgBI0lg3oqguXFDwYqfbqleGGbFFNNb1DNA/rUjl5/
         2UMhObye/SX6UTmCi9KDbWBG24LmLk0GhUeMjNJ/aO7ryBQnttrab19Dv+4Gpnf+p2yN
         jodAa0NGtCzyBkWTjSSPEhI2x+ry1oxS+gWorTykEZZuL7y3HJLw2vZ6mM9N4EVaz4yh
         TNjg==
X-Gm-Message-State: AOAM531hSm422YY86kNoATWZ4ZWQyVmz5CA7fXAcJwL8q8RaIoADDqY1
        2M1EDeiz6CwhCv5hSpGhDMyBOlp/QbDNhJWhYMplUg==
X-Google-Smtp-Source: ABdhPJyOgFYIsz++rTquSbrKidXOaZ1MVIXBLwb/aKF11GJv12HKYkYTcfLnuWskvaTvzU81A+hLb/gevmBViXZsQt8=
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr9092828pjb.168.1621580840163;
 Fri, 21 May 2021 00:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-3-seanjc@google.com>
 <CAAeT=FyNo1CGvnamc3_J9EEQUn6WcdkMp50-QgmLYYVCFA2fZA@mail.gmail.com> <YKVdUtvSg7/I7Ses@google.com>
In-Reply-To: <YKVdUtvSg7/I7Ses@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Fri, 21 May 2021 00:07:04 -0700
Message-ID: <CAAeT=FxvS_hzcZbZQ_jQnWwX+xDT0SqQoHKELeviqu_QvvnbYg@mail.gmail.com>
Subject: Re: [PATCH 02/43] KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 11:47 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 18, 2021, Reiji Watanabe wrote:
> > > @@ -4504,7 +4505,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> > >
> > >         vmx->msr_ia32_umwait_control = 0;
> > >
> > > -       vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> > > +       eax = 1;
> > > +       if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
> > > +               eax = get_rdx_init_val();
> > > +       kvm_rdx_write(vcpu, eax);
> >
> > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> >
> > For RESET, I assume that rdx should be set by userspace
> > when userspace changes CPUID.0x1.EAX.
>
> Ya, although the ideal solution is to add a proper RESET ioctl() so userspace can
> configure the vCPU model and then pull RESET#.

Thank you so much for the answer !
It sounds like a good idea in terms of userspace handling as well
as KVM implementation (I assume it would be something similar to
KVM_ARM_VCPU_INIT).


> > BTW, I would think having a default CPUID for CPUID.(EAX=0x1) would be better
> > for consistency of a vCPU state for RESET.  I would think it doesn't matter
> > practically anyway though.
>
> Probably, but that would require defining default values for all of CPUID.0x0 and
> CPUID.0x1, which is a can of worms I'd rather not open.  E.g. vendor info, basic
> feature set, APIC ID, etc... would all need default values.  On the other hand,
> the EDX value stuffing predates CPUID, so using 0x600 isn't provably wrong, just
> a bit anachronistic. :-)

I see... Then I don't think it's worth doing...
Just out of curiosity, can't we simply use a vcpu_id for the APIC ID ?
Also, can't we simply use the same values that KVM_GET_SUPPORTED_CPUID
provides for other CPUID fields ?

Thanks,
Reiji
