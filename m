Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577FF233C4D
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 01:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgG3XxT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 19:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730729AbgG3XxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 19:53:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC142C061575
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 16:53:17 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j8so17700822ioe.9
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 16:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3CLzCjMBt0EKQ8Od8SUKp9/clTlKR5oUCuqD33/hskA=;
        b=XYTGewCy/RlfHIVseL4R2WM9baUKalaKyj/NzAx10Un+zLMe+y15BF9qzYaSZJQ9xP
         6yAeSFfKps5QOx3VQ5Q58Guy1ph9s33t3+GR/k/nrBhb4LjCJM5Ma6sCyPLsw8g6PYwb
         lyGDiqBe6vQuOdGF5gpjctO/B/9R+UmiyGFPPCq+iHQna7Ed79RZhHLD/CB/nl3WspHq
         E0xWcZqMGI43rC2eBCaf2U9v39UkJuuAzgWan3ahy3m/+CpMGnmB/lWNkB1MWvebdrFW
         iml1pVvm4Uvo5gBrtxqml8bG6A5mbL8SvsPRHVeZRxSV3oYQd/G+E5Qe9HGoP63VQI6k
         mRjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3CLzCjMBt0EKQ8Od8SUKp9/clTlKR5oUCuqD33/hskA=;
        b=YLg62upoXv2Cd28PmpmickBa2lmdIuhKGVcrPSIntGK+Io310e/N2jRLJ6MBOh6wMR
         jJl6cT4egXVt+Cc2wqzcLED/2GoDdEptOnUjSxzyIO7qKwdgNjd1/+Oqua8NY+++rDqu
         QZGGEzR+FdJbIGxGASOo9g50MoFUHXIvIBoAMFPqPAsDG2KQzTXBlLhjWJEXteYHgWLv
         f17A2Z7FdGHRcKMvdz4kvXyJp75PAI6t5Zy58f4WB8roL1QXgVIyTd8bNo/4t4gfSTAG
         +Jn6Zoz/0hGHreZYrzVzdzKOGxIBt614ur93ALIT7zfRgLgo2kOIZz45xSj8SqS+NPi6
         9Heg==
X-Gm-Message-State: AOAM532S+j0YtfiGJa0IZDw2gTzPFQLJVlefIBoFCCTcNzPIe3zfryWd
        pTBKBkRCdpsBadONrGtjzkPqWVdw6YItfY7qekrNTA==
X-Google-Smtp-Source: ABdhPJxdhCRMSR9raaPxevagNIQp0WilocU/CysoSyfc6CQBq2lFplC1V7dIcdYE1l2wtx2gNfczz6R4d/i2sn6sgPg=
X-Received: by 2002:a02:854a:: with SMTP id g68mr1963820jai.24.1596153196882;
 Thu, 30 Jul 2020 16:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200729235929.379-1-graf@amazon.com> <20200729235929.379-2-graf@amazon.com>
 <CALMp9eRq3QUG64BwSGLbehFr8k-OLSM3phcw7mhuZ9hVk_N2-A@mail.gmail.com> <e7cbf218-fb01-2f30-6c5c-a4b6e441b5e4@amazon.com>
In-Reply-To: <e7cbf218-fb01-2f30-6c5c-a4b6e441b5e4@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jul 2020 16:53:05 -0700
Message-ID: <CALMp9eRQRaw7raxeH1nOTGr0rBk5bqbmoxUo7txGyQfaBs0=4g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 30, 2020 at 4:08 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 31.07.20 00:42, Jim Mattson wrote:
> >
> > On Wed, Jul 29, 2020 at 4:59 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >> MSRs are weird. Some of them are normal control registers, such as EFER.
> >> Some however are registers that really are model specific, not very
> >> interesting to virtualization workloads, and not performance critical.
> >> Others again are really just windows into package configuration.
> >>
> >> Out of these MSRs, only the first category is necessary to implement in
> >> kernel space. Rarely accessed MSRs, MSRs that should be fine tunes against
> >> certain CPU models and MSRs that contain information on the package level
> >> are much better suited for user space to process. However, over time we have
> >> accumulated a lot of MSRs that are not the first category, but still handled
> >> by in-kernel KVM code.
> >>
> >> This patch adds a generic interface to handle WRMSR and RDMSR from user
> >> space. With this, any future MSR that is part of the latter categories can
> >> be handled in user space.
> >>
> >> Furthermore, it allows us to replace the existing "ignore_msrs" logic with
> >> something that applies per-VM rather than on the full system. That way you
> >> can run productive VMs in parallel to experimental ones where you don't care
> >> about proper MSR handling.
> >>
> >> Signed-off-by: Alexander Graf <graf@amazon.com>
> >
> > Can we just drop em_wrmsr and em_rdmsr? The in-kernel emulator is
> > already incomplete, and I don't think there is ever a good reason for
> > kvm to emulate RDMSR or WRMSR if the VM-exit was for some other reason
> > (and we shouldn't end up here if the VM-exit was for RDMSR or WRMSR).
> > Am I missing something?
>
> On certain combinations of CPUs and guest modes, such as real mode on
> pre-Nehalem(?) at least, we are running all guest code through the
> emulator and thus may encounter a RDMSR or WRMSR instruction. I *think*
> we also do so for big real mode on more modern CPUs, but I'm not 100% sure.

Oh, gag me with a spoon! (BTW, we shouldn't have to emulate big real
mode if the CPU supports unrestricted guest mode. If we do, something
is probably wrong.)

> > You seem to be assuming that the instruction at CS:IP will still be
> > RDMSR (or WRMSR) after returning from userspace, and we will come
> > through kvm_{get,set}_msr_user_space again at the next KVM_RUN. That
> > isn't necessarily the case, for a variety of reasons. I think the
>
> Do you have a particular situation in mind where that would not be the
> case and where we would still want to actually complete an MSR operation
> after the environment changed?

As far as userspace is concerned, if it has replied with error=0, the
instruction has completed and retired. If the kernel executes a
different instruction at CS:RIP, the state is certainly inconsistent
for WRMSR exits. It would also be inconsistent for RDMSR exits if the
RDMSR emulation on the userspace side had any side-effects.

> > 'completion' of the userspace instruction emulation should be done
> > with the complete_userspace_io [sic] mechanism instead.
>
> Hm, that would avoid a roundtrip into guest mode, but add a cycle
> through the in-kernel emulator. I'm not sure that's a net win quite yet.
>
> >
> > I'd really like to see this mechanism apply only in the case of
> > invalid/unknown MSRs, and not for illegal reads/writes as well.
>
> Why? Any #GP inducing MSR access will be on the slow path. What's the
> problem if you get a few more of them in user space that you just bounce
> back as failing, so they actually do inject a fault?

I'm not concerned about the performance. I think I'm just biased
because of what we have today. But since we're planning on dropping
that anyway, I take it back. IIRC, the plumbing to make the
distinction is a little painful, and I don't want to ask you to go
there.
