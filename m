Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 919524A7CFC
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 01:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348325AbiBCAmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 19:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbiBCAmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 19:42:47 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93DBC061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 16:42:46 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id a25so1521018lji.9
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 16:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2CsW9/j6pAQT4zpRdG/Us4Mcz0r6Z0MURHErX6HpdY=;
        b=fVdg4kYrU1FavbvOflnpSPP9TRB0Pm87i0+knebqn7IOQR8NNFBPWYAnHP1tDXCHoH
         OMaywCKC/49JncJMXXUYNuFSXHa8ma+7sBSUrffR73r8p3OaWTxS0OP5aybohex03SFV
         uVd7cO8/ba3czttGI1x5yRTph5nBSEE/mwxSMa7b+meETMmVb3qsRBWAnwyYvpZmX7yp
         XYDQsXzZ4xzPhJbbKF5799qP7HjK3ItAPjPy3UMBB/KA6mzLFP8W25NCzGNv9Yfx+IkL
         +mjGTUB6HdZ1fHZKy17ItpIl7FFiGocAOHt08gcZ2lN5TERaBXEt5eHnKHqojmMdZiOa
         +l8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2CsW9/j6pAQT4zpRdG/Us4Mcz0r6Z0MURHErX6HpdY=;
        b=okCMQb2NbE+5d+1VFpuDJDLXooe3nnLMyOEIDqTRJsCEq9spBHTm8iP8na6d7Kn7mp
         neMIT0tSndlceVhsLde3Rcvol8aXtF2hh0Z/k5UI54WerNNVo2DiuPAI4GIx+q7bZRJP
         8HAOxpxIdc5BFxZ4FdiisVX1SctRUcDmk2pdyyd+QO6J3CH03OpJsZyIBgv6daDyVpdG
         GXZ2OTRWz38RysiCGub98HTpCFPoobpwhEg7DsGNNWxPqN2l4VWGgQlWL+SXAy07ivdv
         O+EzNrz8ImtOtl/SJml/B6bWgUgYflY3j+JiFQVOfPYqU4f7n6FPo5LIQJz8qtB3LbVG
         0PQg==
X-Gm-Message-State: AOAM530I+XZTcXwOmXuaTIzC7Y1MgN/YbyzTjLKWmTO4vGOdw2aV4KB2
        EEt/SF8NVrj/vZ+2eKcaCrG0HrmzCpEbTcG1SXGCYMYz5vxJfw==
X-Google-Smtp-Source: ABdhPJyQQFUSvoArlXwiH6UrgffD/R+p/zrXNa14YiGbHk+A9GFczRLel3nWKF27JkhKJUJPAwwvZZfvxu3tA+C2oM4=
X-Received: by 2002:a05:651c:108:: with SMTP id a8mr22282085ljb.479.1643848964879;
 Wed, 02 Feb 2022 16:42:44 -0800 (PST)
MIME-Version: 1.0
References: <20220202230433.2468479-1-oupton@google.com> <CALMp9eRotJRKXwPp=kVdfDjGBkqMJ+6wM+N=-7WnN7yr-azvxQ@mail.gmail.com>
 <Yfsi2dSZ6Ga3SnIh@google.com>
In-Reply-To: <Yfsi2dSZ6Ga3SnIh@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 2 Feb 2022 16:42:33 -0800
Message-ID: <CAOQ_Qsiv=QqKGr4H2dP30DEozzvmSpa1SLjX8T5vhSfv=gTy3g@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: nVMX: Fixes for VMX capability MSR invariance
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 2, 2022 at 4:33 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Feb 02, 2022, Jim Mattson wrote:
> > On Wed, Feb 2, 2022 at 3:04 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Ultimately, it is the responsibility of userspace to configure an
> > > appropriate MSR value for the CPUID it provides its guest. However,
> > > there are a few bits in VMX capability MSRs where KVM intervenes. The
> > > "load IA32_PERF_GLOBAL_CTRL", "load IA32_BNDCFGS", and "clear
> > > IA32_BNDCFGS" bits in the VMX VM-{Entry,Exit} control capability MSRs
> > > are updated every time userspace sets the guest's CPUID. In so doing,
> > > there is an imposed ordering between ioctls, that userspace must set MSR
> > > values *after* setting the guest's CPUID.
> >
> >  Do you mean *before*?
>
> No, after, otherwise the CPUID updates will override the MSR updates.
>
> MSR_IA32_FEAT_CTL has this same issue.  But that mess also highlights an issue
> with this series: if userspace relies on KVM to do the updates, it will break the
> existing ABI, e.g. I'm pretty sure older versions of QEMU rely on KVM to adjust
> the MSRs.

I realize I failed to add a note about exactly this in the cover
letter. It seems, based on the commit 5f76f6f5ff96 ("KVM: nVMX: Do not
expose MPX VMX controls when guest MPX disabled") we opted to handle
the VMX capability MSR in-kernel rather than expecting userspace to
pick a sane value that matches the set CPUID. So what really has
become ABI here? It seems as though one could broadly state that KVM
owns VMX VM-{Entry,Exit} control MSRs without opt-in, or narrowly
assert that only the bits in this series are in fact ABI.

Regardless, since we must uphold this misbehavior as ABI, we have a
regression since KVM doesn't override the MSR write if it comes after
the CPUID write.

> I agree that KVM should keep its nose out of this stuff, especially since most
> VMX controls are technically not architecturally tied to CPUID.  But we probably
> need an opt-in from userspace to stop mucking with the MSRs.

Bleh, I wanted to avoid the age-old problem of naming, but alas...

--
Thanks,
Oliver
