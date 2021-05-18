Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A873338785A
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 14:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240508AbhERMEr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 08:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbhERMEq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 08:04:46 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2547C061573;
        Tue, 18 May 2021 05:03:27 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id x15so9491737oic.13;
        Tue, 18 May 2021 05:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k79vW2u79tJXgve+aRH1VfwPBT0AnMHP2JIefQMqRAs=;
        b=kR+59qVE9ePDScN4+7vEcEnxZwK12VuOtltQkkZMB7XoH5arDmZc9pE0b85wW2yOBp
         TDCtb3xnJShxG6zUqEPlylwDq3PC89ou1/2MOxkW15s9v6I5wYcpcHcqcvSoNKXePMuB
         u9l2eyYJFlK4fYpiZ9eBSpYUnfzGxBvkeG/XcPwfDgmXmaW4N4LGn2QgtEb/B0dBCSA1
         L7PeAVR57iosmuMrjRVWbi92n0HEwjwvRDGftKkHOtS+Lw6jwzNtn1Gsrw3IDg4bW5wX
         FfVpwQPEE5kDctmR2Hne5KfKuvN17ICHtdlOLmGcNQdQ50GxEWyUPDfxdx/YwvWoMQIs
         udOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k79vW2u79tJXgve+aRH1VfwPBT0AnMHP2JIefQMqRAs=;
        b=G52ha7JhPxpR/QWYOZIjyCfw5vvzymiwaTQtaFJEY+tPm7lYFxEsvb7q+4/5b4i19t
         Z+448sPgYatBDhZxc5xZpsiHIoZrIvvFiOuTfHcT3v3AZSvR8p0mWHicwDbhqgu4Vn3R
         syhh4yQJFjpR3AvNcTtw6RMJ2y3Hu8yt2PiqrbaKf7Xp7vWnObmJ9pxKaarCkbTG0vcc
         pOF+GmcXn+upWklYxI7mDa4QMW0A8VjH/z0sPk2BnGre6rVxOE3kCialYVG4opX9d260
         /uVORLiC0R3h8/9bEvUcrepVg/PhjyyYGbIOklfkdxzp6NeP1F+ALq+/Fjyuan/ARz6Y
         4V2A==
X-Gm-Message-State: AOAM533qhngKZAhPuEG8mRS3sMv5DbmpvE2j9ahkXrbmUa1GNEth/nr8
        ee+635TFKsf95Grvy+XHDMoTY6OSa5znSa0VdBg=
X-Google-Smtp-Source: ABdhPJz51rEOQLD2+EEtqmQ0Y4xfu8YkQtTAXJcixmMGBJW8jVvrf3Wo9wjBGmW3HA30GXeOn9psScMHZiyQBfr7D/c=
X-Received: by 2002:aca:4343:: with SMTP id q64mr3710079oia.33.1621339407416;
 Tue, 18 May 2021 05:03:27 -0700 (PDT)
MIME-Version: 1.0
References: <1621260028-6467-1-git-send-email-wanpengli@tencent.com> <CALzav=c+=Bi5HeuYfYKi3FRB6V88o7hCsGbgG+x3a4Mf3e9nVA@mail.gmail.com>
In-Reply-To: <CALzav=c+=Bi5HeuYfYKi3FRB6V88o7hCsGbgG+x3a4Mf3e9nVA@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 18 May 2021 20:03:16 +0800
Message-ID: <CANRm+Cx0VuwZUdggze-fQOMbeYe8QuFpH-bGqbdEOM7OnfZcaQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] KVM: exit halt polling on need_resched() for both
 book3s and generic halt-polling
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 May 2021 at 00:35, David Matlack <dmatlack@google.com> wrote:
>
> On Mon, May 17, 2021 at 7:01 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
> > as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
> > one task to get the task to block. It was likely allowing VMs to overrun their
> > quota when halt polling. Due to PPC implements an arch specific halt polling
> > logic, we should add the need_resched() checking there as well. This
> > patch adds a helper function that to be shared between book3s and generic
> > halt-polling loop.
> >
> > Cc: Ben Segall <bsegall@google.com>
> > Cc: Venkatesh Srinivas <venkateshs@chromium.org>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: David Matlack <dmatlack@google.com>
> > Cc: Paul Mackerras <paulus@ozlabs.org>
> > Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> Reviewed-by: David Matlack <dmatlack@google.com>
>
> > ---
> > v2 -> v3:
> >  * add a helper function
> > v1 -> v2:
> >  * update patch description
> >
> >  arch/powerpc/kvm/book3s_hv.c | 2 +-
> >  include/linux/kvm_host.h     | 2 ++
> >  virt/kvm/kvm_main.c          | 9 +++++++--
> >  3 files changed, 10 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index 28a80d240b76..360165df345b 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -3936,7 +3936,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
> >                                 break;
> >                         }
> >                         cur = ktime_get();
> > -               } while (single_task_running() && ktime_before(cur, stop));
> > +               } while (kvm_vcpu_can_block(cur, stop));
> >
> >                 spin_lock(&vc->lock);
> >                 vc->vcore_state = VCORE_INACTIVE;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 2f34487e21f2..bf4fd60c4699 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -1583,4 +1583,6 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
> >  /* Max number of entries allowed for each kvm dirty ring */
> >  #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> >
> > +bool kvm_vcpu_can_block(ktime_t cur, ktime_t stop);
> > +
> >  #endif
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 6b4feb92dc79..c81080667fd1 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2945,6 +2945,12 @@ update_halt_poll_stats(struct kvm_vcpu *vcpu, u64 poll_ns, bool waited)
> >                 vcpu->stat.halt_poll_success_ns += poll_ns;
> >  }
> >
> > +
> > +bool kvm_vcpu_can_block(ktime_t cur, ktime_t stop)
>
> nit: kvm_vcpu_can_poll() would be a more accurate name for this function.

Do it in v4. :)

    Wanpeng
