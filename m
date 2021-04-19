Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FDB363CA0
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 09:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbhDSHfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 03:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237670AbhDSHfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 03:35:33 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602E4C06174A;
        Mon, 19 Apr 2021 00:35:03 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id i16-20020a9d68d00000b0290286edfdfe9eso21113245oto.3;
        Mon, 19 Apr 2021 00:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n9kAD+An3yHMDHmSNL3zi3TsigAV5UlobdscCMtr7J4=;
        b=LzJLKOgsGPV/ZfICAzX/t5HEIjdhvhY2mRLcII5OwXFNSpUkoJmrhiReAU/wYMN+S6
         AzRRKcyNQje20Fig56y0AF60oCp1ebCHn+7I0lxHp0jZhXRdphiNtfUNJPB9FqTtL6cH
         9QaRKe8IUtR0Lmu9ylezZlhcuIWtPAFYo5kYOfhMTHqGEiL+UTpJqbD6/N0uu8B8ViQh
         vbYFb1gVMzAKY2kKHNh7Kh0t3KutK/EtQ35bf5ZIrcblK2xveaLlFxov7VUrI2eu+6qe
         D7Hc4CbecJQJKCcwrDBOJh4j0ST147nILYtaFuxbLWNm4lacUL+kOTw974ElZvSA3QQC
         8igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n9kAD+An3yHMDHmSNL3zi3TsigAV5UlobdscCMtr7J4=;
        b=OPUU5OIxv/kEcRtfr54wp03iM5ossgEAntLDgZ2K2ky06QzB3tAqbZZ3V1PnivdXhQ
         vMX4ECFhEo+6D9GAtuW+rckk0ConQZAC/wf9Nrk/wkOnloW/x/vbo116sLqbOHUAmZ0Z
         evIIdg4MyqnT0+AdL6/krJ34IBKCKuTrZLWY+Eo7ERlE34e0iE586d3MI/fgfqZtcrgW
         zRSurufisjXT5p4M5EHBGaEsWVHhJxra5MKsvSTIraCJi7+JZBWvDQF6OXzfYS7zCkfU
         GH24GKA+0gQP4BXmggb1EIl5pS7UxMQb4YMv/s5P4t57/+k2u6Xl/BdrzGYMj3ijHy3t
         u5kA==
X-Gm-Message-State: AOAM533YY1yh/Cf/pYTbcoSlkOZsLxpq9zSJyrBdiQ3zqm1mkacLitJL
        4vt8/chU0HA95DTd9deig5qsExIaDn+y+zvQ09sRTaEfa1k=
X-Google-Smtp-Source: ABdhPJzCFZnyv/Dk96lgn4f8UJjt/XXEK3GkjiKQny5+JtiGq8AeDJZ2pWhd7jifMpSi0QH6DSXQXZ0I2P7s1xErAaU=
X-Received: by 2002:a9d:6b13:: with SMTP id g19mr13803978otp.185.1618817702886;
 Mon, 19 Apr 2021 00:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <1618542490-14756-1-git-send-email-wanpengli@tencent.com> <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com>
In-Reply-To: <9c49c6ff-d896-e6a5-c051-b6707f6ec58a@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 19 Apr 2021 15:34:53 +0800
Message-ID: <CANRm+Cy-xmDRQoUfOYm+GGvWiS+qC_sBjyZmcLykbKqTF2YDxQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Boost vCPU candidiate in user mode which is
 delivering interrupt
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 17 Apr 2021 at 21:09, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 16/04/21 05:08, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Both lock holder vCPU and IPI receiver that has halted are condidate for
> > boost. However, the PLE handler was originally designed to deal with the
> > lock holder preemption problem. The Intel PLE occurs when the spinlock
> > waiter is in kernel mode. This assumption doesn't hold for IPI receiver,
> > they can be in either kernel or user mode. the vCPU candidate in user mode
> > will not be boosted even if they should respond to IPIs. Some benchmarks
> > like pbzip2, swaptions etc do the TLB shootdown in kernel mode and most
> > of the time they are running in user mode. It can lead to a large number
> > of continuous PLE events because the IPI sender causes PLE events
> > repeatedly until the receiver is scheduled while the receiver is not
> > candidate for a boost.
> >
> > This patch boosts the vCPU candidiate in user mode which is delivery
> > interrupt. We can observe the speed of pbzip2 improves 10% in 96 vCPUs
> > VM in over-subscribe scenario (The host machine is 2 socket, 48 cores,
> > 96 HTs Intel CLX box). There is no performance regression for other
> > benchmarks like Unixbench spawn (most of the time contend read/write
> > lock in kernel mode), ebizzy (most of the time contend read/write sem
> > and TLB shoodtdown in kernel mode).
> >
> > +bool kvm_arch_interrupt_delivery(struct kvm_vcpu *vcpu)
> > +{
> > +     if (vcpu->arch.apicv_active && static_call(kvm_x86_dy_apicv_has_pending_interrupt)(vcpu))
> > +             return true;
> > +
> > +     return false;
> > +}
>
> Can you reuse vcpu_dy_runnable instead of this new function?

I have some concerns. For x86 arch, vcpu_dy_runnable() will add extra
vCPU candidates by KVM_REQ_EVENT and async pf(which has already
opportunistically made the guest do other stuff). For other arches,
kvm_arch_dy_runnale() is equal to kvm_arch_vcpu_runnable() except
powerpc which has too many events and is not conservative. In general,
 vcpu_dy_runnable() will loose the conditions and add more vCPU
candidates.

    Wanpeng
