Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86F24F0AE
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 02:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgHXATk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Aug 2020 20:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgHXATh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Aug 2020 20:19:37 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8908C061573;
        Sun, 23 Aug 2020 17:19:36 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l84so6763681oig.10;
        Sun, 23 Aug 2020 17:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kych+ri3hUY6V/ktyGfK/OBC9jYv1spc+PwgnTtgYJs=;
        b=oKWtTmtvR3+JNfRTZ/NJ3WAiLq5+qs73iozDtHuHc8/yLQQiEyJigMRt6SwykEZFvD
         NZt4k3Po/L/F+na04A3jEldSNpzPZOKkdCvscA9uxTl6g18gNDIhtN7RP4r3g90Vjp8b
         /DawnsBI5sZN1Iint5sDigc2l6ld/B9znyUXrRBJzFWhaOHdXKx3ERXxrHT+m5U4oc4/
         eRycZ83QLeh+LVP0fdCMIXxTRTH+hg6F1/iz+QUvDUy/QdXj1MupHx2z5gjX/U3CzJ8m
         kw76vuvPFmAXWdN9uUdhv8cgJ6dds3rnLiMqnjyltscGVhrp9QB4MLIiu4C5iGECVar9
         vMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kych+ri3hUY6V/ktyGfK/OBC9jYv1spc+PwgnTtgYJs=;
        b=OVWHR6OalV3PKeAPc0BO1PJaXEcAsWLlPVJsw48uPXJ84yGsAJKkrdhSo2NT4wJd1+
         i+dwb+XaRt5BzbXj/oUS2Mm7tYs+J7TojSQstpLHMU0YAlA9h+h75+Txm45CieL6BzN9
         QK2vNQiysAAJiAIfBiJ7eaiCvJ2Bke2hJq6mwXkBds5mMniWLtO0XG8iqflkXv6KaPpI
         kFM8T1unDgTgr1lEo8BghHtJqVTdivQIW8DCkHqe78LSEMNTZPCxy+7xjyo/jgRmjRg3
         +UstqBpfPL3Z8I02eXrL+bsASilgm6ziY1ECWsnO2uxGR8VPLHb0kWMBr4zUInL8I4D5
         aJwA==
X-Gm-Message-State: AOAM5338eOZ7qilRMtUr/Bl1CVHMvzenJCyjcwOFxKAmj3+JbO7SXQun
        PW/g4o+CUNW3G9szLDXbRbRoYA68RxvUfkFO6nI=
X-Google-Smtp-Source: ABdhPJyRqehejgcdV4LAMYuEp3Qxjp6LydJCIVtzvs6xO8SgWZnqfueRlM1p8xrFco0peS1l3QqjCrpT2lM4uiEy0ZY=
X-Received: by 2002:a05:6808:b:: with SMTP id u11mr1788658oic.33.1598228375958;
 Sun, 23 Aug 2020 17:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <1598001454-11709-1-git-send-email-wanpengli@tencent.com> <20200822040114.GF4769@sjchrist-ice>
In-Reply-To: <20200822040114.GF4769@sjchrist-ice>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 24 Aug 2020 08:19:25 +0800
Message-ID: <CANRm+Cxf9g7gvW1N7W0conMO4z-LUVuFiZ-ui37m1dtOwzzA1Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Don't kick vCPU which is injecting
 already-expired timer
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 22 Aug 2020 at 12:01, Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Aug 21, 2020 at 05:17:34PM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > The kick after setting KVM_REQ_PENDING_TIMER is used to handle the timer
> > fires on a different pCPU which vCPU is running on, we don't need this
> > kick when injecting already-expired timer, this kick is expensive since
> > memory barrier, rcu, preemption disable/enable operations. This patch
> > reduces the overhead by don't kick vCPU which is injecting already-expired
> > timer.
>
> This should also call out the VMX preemption timer case, which also passes
> from_timer_fn=false but doesn't need a kick because kvm_lapic_expired_hv_timer()
> is called from the target vCPU.
>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/lapic.c | 2 +-
> >  arch/x86/kvm/x86.c   | 5 +++--
> >  arch/x86/kvm/x86.h   | 2 +-
> >  3 files changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 248095a..5b5ae66 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1642,7 +1642,7 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
> >       }
> >
> >       atomic_inc(&apic->lapic_timer.pending);
> > -     kvm_set_pending_timer(vcpu);
> > +     kvm_set_pending_timer(vcpu, from_timer_fn);
>
> My vote would be to open code kvm_set_pending_timer() here and drop the
> helper, i.e.
>
>         kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
>         if (from_timer_fn)
>                 kvm_vcpu_kick(vcpu);
>
> with that and an updated changelog:

Agreed.

>
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks.
    Wanpeng
