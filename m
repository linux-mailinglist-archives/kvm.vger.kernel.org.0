Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C64364842
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhDSQdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232081AbhDSQdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:33:06 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C42BC061761
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:32:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id d10so24617750pgf.12
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Po8ZTryCmaCYRlNesK4Qbi+P2wBo0R9mSd8SxApaYsM=;
        b=SfS42w7lxwkVwfe7+1MBgZbbdaiD2/CEChHSlMTy6xm00biq+FUePeNbxqitTZejfZ
         zg2Bm4si/5sbMMXI6BBO9C8fxBbg874fzn3j6FZhg7pmT6lDa5K+dftGdg/hzDSCq3Vg
         EPVc83ZRpdqnuhfm6dI5yjcuzx4R0T/6UryU16YqNRsrk4ghAd1681K62n+qAfBaSJjL
         Q+nMiAYOVpMXYr8h/fj1NgIo5jdMcicWPdntv/p7d8otOyghfPE60mWaFVuAFyCMpLDy
         YOUbMn7aL2Hr+yOXV+cHYhl4au399YnzhAKFIl1mMlJ3mC6KdvNIkClpE3IqJhycRtRi
         TV4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Po8ZTryCmaCYRlNesK4Qbi+P2wBo0R9mSd8SxApaYsM=;
        b=ET2zhe9weFZonWBzBgg2td3f8RJnuuXPjiW949vGEOT7d/ECG4Po0dEQaJabVyIDTf
         d7EWyX9z++R+UYgzMPXDECrYxMgZTVD0zRLfjYbyMErw4MkfsgD6iTZNQaFjGKGrvRo4
         zpQSrNZNuSgsrD/hOpFurKnQlhTsPfGNwJG5QuIgn36/IfeUJ5K2geiYpS3Q5Fa14LUw
         K773QkpgvgUmh5cmXooVsicJ8UusP6wqt3jCFbqnUG8TzU++ZBU6pOTldWzDdqpDZbCA
         KfOpTZFPmu8e8veQ8cwhdqdHVCOfEz+x+jA8GBrWqO8lBUJnHd7QO7jY1/J4A3xLA/kC
         P78A==
X-Gm-Message-State: AOAM531UQxb4RHDdSpaxVA1fCL3r38zFLPqfgZcQx+KinvW4rnQdkjQY
        XxFbcVQajwfPKnwo2jI/G1nYTg==
X-Google-Smtp-Source: ABdhPJx3mBR4cgaLIzX+QZKSR72lGy+y/cIQaVq8jSoFaRpYpBsv8/ojiGloYCR8LYSGJjAizg7yNQ==
X-Received: by 2002:a63:1d18:: with SMTP id d24mr13065142pgd.402.1618849954664;
        Mon, 19 Apr 2021 09:32:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id gt22sm12209pjb.7.2021.04.19.09.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:32:34 -0700 (PDT)
Date:   Mon, 19 Apr 2021 16:32:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
Message-ID: <YH2wnl05UBqVhcHr@google.com>
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com>
 <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com>
 <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021, Wanpeng Li wrote:
> On Sat, 17 Apr 2021 at 21:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 16/04/21 05:08, Wanpeng Li wrote:
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > Both lock holder vCPU and IPI receiver that has halted are condidate for
> > > boost. However, the PLE handler was originally designed to deal with the
> > > lock holder preemption problem. The Intel PLE occurs when the spinlock
> > > waiter is in kernel mode. This assumption doesn't hold for IPI receiver,
> > > they can be in either kernel or user mode. the vCPU candidate in user mode
> > > will not be boosted even if they should respond to IPIs. Some benchmarks
> > > like pbzip2, swaptions etc do the TLB shootdown in kernel mode and most
> > > of the time they are running in user mode. It can lead to a large number
> > > of continuous PLE events because the IPI sender causes PLE events
> > > repeatedly until the receiver is scheduled while the receiver is not
> > > candidate for a boost.
> > >
> > > This patch boosts the vCPU candidiate in user mode which is delivery
> > > interrupt. We can observe the speed of pbzip2 improves 10% in 96 vCPUs
> > > VM in over-subscribe scenario (The host machine is 2 socket, 48 cores,
> > > 96 HTs Intel CLX box). There is no performance regression for other
> > > benchmarks like Unixbench spawn (most of the time contend read/write
> > > lock in kernel mode), ebizzy (most of the time contend read/write sem
> > > and TLB shoodtdown in kernel mode).
> > >
> > > +bool kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu)
> > > +{
> > > +     if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
> > > +             return true;
> > > +
> > > +     return false;
> > > +}
> >
> > Can you reuse vcpu_dy_runnable instead of this new function?
> 
> I have some concerns. For x86 arch, vcpu_dy_runnable() will add extra
> vCPU candidates by KVM_REQ_EVENT

Is bringing in KVM_REQ_EVENT a bad thing though?  I don't see how using apicv is
special in this case.  apicv is more precise and so there will be fewer false
positives, but it's still just a guess on KVM's part since the interrupt could
be for something completely unrelated.

If false positives are a big concern, what about adding another pass to the loop
and only yielding to usermode vCPUs with interrupts in the second full pass?
I.e. give vCPUs that are already in kernel mode priority, and only yield to
handle an interrupt if there are no vCPUs in kernel mode.

kvm_arch_dy_runnable() pulls in pv_unhalted, which seems like a good thing.

> and async pf(which has already opportunistically made the guest do other stuff).

Any reason not to use kvm_arch_dy_runnable() directly?

> For other arches, kvm_arch_dy_runnale() is equal to kvm_arch_vcpu_runnable()
> except powerpc which has too many events and is not conservative. In general,
> vcpu_dy_runnable() will loose the conditions and add more vCPU candidates.
> 
>     Wanpeng
