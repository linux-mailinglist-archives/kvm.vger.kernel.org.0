Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF9542FFC3
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 04:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbhJPCvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 22:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236923AbhJPCvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 22:51:05 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899CCC061570;
        Fri, 15 Oct 2021 19:48:58 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id w12-20020a056830410c00b0054e7ceecd88so96590ott.2;
        Fri, 15 Oct 2021 19:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJ4g3ZKnmvunJdi+ctLSl5Yeyu3gse79YN5zl1xBHRQ=;
        b=NsYEZQVNGVb+SrQVl+z43EzawS3aYeq38cjLN6UrUEykrUpxjLwLMvwt3Fz8rvRKE0
         93vHS4KjQavA/ShpX8W9rApnzzr56kzcONhr/MeucFn3ccxsOU+RpigH1ONC8WWu4Y0I
         Mq3n4A4QBpFiJjft6rE3qgeK73Ohka+nb0dkxxZVc+6QV0Xg4stYpzjUkgKih/5I1p2R
         ix5wRx68pwW8ZN3QZo8KxlIGC9AVaWEeaPoDoo8+U/LpYIeAQowUo5IzgtnMyOwbPxSa
         WTf/vNCRJPHTenI6m++UwwmMXRSkims5F40oKG4/jVqkrIjBYRHnmN59saxBWjdBE9W1
         uUCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJ4g3ZKnmvunJdi+ctLSl5Yeyu3gse79YN5zl1xBHRQ=;
        b=WQw3RYpZ/EiWQhJD7ZGp96Im925lHoSUa6OMIH9Kju4Ju9g0P+R+A7YQ3M/TFLec2D
         Z8GFBBJOLA4ckiVJnZ0/1mtrGgi7A4z9IPD+enisvPxLIxze5yeU5i6c6j0i0HN6vAM1
         +H1Md3JDM2kG47B96iDmIrpxRUVsOS4+1YtCppaT2E3zKRMHZ3v6s1in5VWjct2LfHWz
         Y0Y6TU6coCdRHsRglu5Hxo9vAdghqHT88l+GbmqL8++k5EEzP96fYPrrfOV2zGS64Tjf
         WgZ9IGTnqJr3tWO7Gz0Zu0E0f74QmP6nV8vxKhZkBCsgEvsiUEJyAfQ/tvo0p8i+PAxA
         nIuw==
X-Gm-Message-State: AOAM533RzIEjuHWZpinanIk244hsBm0C8ZIlS50ojMVh6dEAwjAHA01i
        V63AUsPVYSv2epCrGUmnI3phkhjhfHGnGX8cFUU=
X-Google-Smtp-Source: ABdhPJypMLEaDLhO7JUuoxChL2M9ZddWKVy7pPd4vNnSXoBjFbdzofH7xq+p3XVyFDab7cx1fWhr5u2ex/IdFfahE+M=
X-Received: by 2002:a9d:17cd:: with SMTP id j71mr11380632otj.169.1634352537921;
 Fri, 15 Oct 2021 19:48:57 -0700 (PDT)
MIME-Version: 1.0
References: <1633770532-23664-1-git-send-email-wanpengli@tencent.com>
 <1633770532-23664-3-git-send-email-wanpengli@tencent.com> <YWoOG40Ap0Islpu2@google.com>
In-Reply-To: <YWoOG40Ap0Islpu2@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 16 Oct 2021 10:48:46 +0800
Message-ID: <CANRm+CzyHmh03tpd7Xe7WSQhTd4gNLFt0Z8fka-9TEH4myaQUg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: vCPU kick tax cut for running vCPU
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 16 Oct 2021 at 07:26, Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Oct 09, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Sometimes a vCPU kick is following a pending request, even if @vcpu is
> > the running vCPU. It suffers from both rcuwait_wake_up() which has
> > rcu/memory barrier operations and cmpxchg(). Let's check vcpu->wait
> > before rcu_wait_wake_up() and whether @vcpu is the running vCPU before
> > cmpxchg() to tax cut this overhead.
> >
> > We evaluate the kvm-unit-test/vmexit.flat on an Intel ICX box, most of the
> > scores can improve ~600 cpu cycles especially when APICv is disabled.
> >
> > tscdeadline_immed
> > tscdeadline
> > self_ipi_sti_nop
> > ..............
> > x2apic_self_ipi_tpr_sti_hlt
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * move checking running vCPU logic to kvm_vcpu_kick
> >  * check rcuwait_active(&vcpu->wait) etc
> >
> >  virt/kvm/kvm_main.c | 13 ++++++++++---
> >  1 file changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 7851f3a1b5f7..18209d7b3711 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3314,8 +3314,15 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> >  {
> >       int me, cpu;
> >
> > -     if (kvm_vcpu_wake_up(vcpu))
> > -             return;
> > +     me = get_cpu();
> > +
> > +     if (rcuwait_active(&vcpu->wait) && kvm_vcpu_wake_up(vcpu))
>
> This needs to use kvm_arch_vcpu_get_wait(), not vcpu->wait, because PPC has some
> funky wait stuff.
>
> One potential issue I didn't think of before.  rcuwait_active() comes with the
> below warning, which means we might be at risk of a false negative that could
> result in a missed wakeup.  I'm not postive on that though.

There is only ever a single waiting vCPU, an event will be requested
before kick the sleeping vCPU and it will be checked after setting
vcpu->wait to task. I can't find scenario could result in a missed
wakeup.

    Wanpeng

>
> /*
>  * Note: this provides no serialization and, just as with waitqueues,
>  * requires care to estimate as to whether or not the wait is active.
>  */
