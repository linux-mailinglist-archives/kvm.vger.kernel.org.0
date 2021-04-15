Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC05235FF3F
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 03:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhDOBYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 21:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhDOBYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 21:24:08 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FB1C061574;
        Wed, 14 Apr 2021 18:23:46 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id i18so1109772oii.2;
        Wed, 14 Apr 2021 18:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CZcdY2ejeZuOhpZsOuHnpvCCg7RiVaBMVxDSkHSF7y0=;
        b=iL3jK0U603yotsEojoxtuCtkP4WtwrvrHtKPJJUua4sqphBWCJ2fEiM9kJzcyhUbdL
         iscEtYd7k73FiyaAXRGpskmYJ6P1q08LBuPZTJ6mHZVpnEmFCXuOmF3yj9ufQsUFjA/D
         znlZT5hHhCJscZVJWqUb6ack0Az9gOeLY/U2Cd+nCVmwFbppIAYbBCA+Si49yWUnVFvj
         SbpG3WgTUC0XN7HPG3zPd8C8iGvzi9qm/0TmJss8zkTrNNQ4FsLgivkA66zwA71q9zpk
         j++qV7N50icirT2dhjRo3pTWuHlOmVMg93KNmCbTaXDgvc4KgJdJj+1LQNaprbs3WXog
         46RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CZcdY2ejeZuOhpZsOuHnpvCCg7RiVaBMVxDSkHSF7y0=;
        b=FxcK8ZxAg/Xm5gGxT69CmjIzu0pj6y0UT/jUARelBpNCvKrU7wA59vafHQvS49FGd0
         BiECeXAUnPsBI9lrArgLMfZ83VKyW2BSgjJGCR1SIUeNc0DB6aeuO1jp6bwvLP2+ypPD
         Lvrea0APrfE7yq4uYi1UHpZN4Cqw+bsrZ9ojgA8Qyt2n5zqTGSEkUliO5nimSxGkiLHm
         X6oFcU2eC55g381HHt2UznGZvgUzNeGKWSPCPkGRVNPuUUMFPJ7HT3g6RfkrUS7nivXr
         44KF11Af/rIN8UgzSlrFwSF4sOISWA65gPLLbDhyOvNzOO7GgpX1K5q5bTryEi/cLxwy
         xV0A==
X-Gm-Message-State: AOAM533PFcGVn2kKur0MUR8oY4imEcYA0HGsvJFd4yDwabbwdHlQGYbO
        iuisFsPhujefeAs1QCb/f6SMGVJJQb/fqByNmQU=
X-Google-Smtp-Source: ABdhPJygWqXkYyK5dX5T7dq+TVzLm0GRN0+/rLx/yFhDvLtbDedf/L1xCFsFMPw9CwumB70NVXgYCjNXR4/A9YCNFbY=
X-Received: by 2002:a05:6808:5c5:: with SMTP id d5mr763874oij.141.1618449825677;
 Wed, 14 Apr 2021 18:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <YHXUFJuLXY8VZw3B@google.com> <CANRm+CzDW_5SPM0131OvRn3UPBp1nahxCykCP61XWeUpYeHU5Q@mail.gmail.com>
 <YHeNpUd1ZO1JVaAf@google.com>
In-Reply-To: <YHeNpUd1ZO1JVaAf@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 15 Apr 2021 09:23:34 +0800
Message-ID: <CANRm+Cxp47Howwusf04WyL5S0AJQx817wcq5BXBvO-U2p-D5OQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: Properly account for guest CPU time
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 15 Apr 2021 at 08:49, Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Apr 14, 2021, Wanpeng Li wrote:
> > On Wed, 14 Apr 2021 at 01:25, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Apr 13, 2021, Wanpeng Li wrote:
> > > > The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
> > > > reported that the guest time remains 0 when running a while true
> > > > loop in the guest.
> > > >
> > > > The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
> > > > belongs") moves guest_exit_irqoff() close to vmexit breaks the
> > > > tick-based time accouting when the ticks that happen after IRQs are
> > > > disabled are incorrectly accounted to the host/system time. This is
> > > > because we exit the guest state too early.
> > > >
> > > > This patchset splits both context tracking logic and the time accounting
> > > > logic from guest_enter/exit_irqoff(), keep context tracking around the
> > > > actual vmentry/exit code, have the virt time specific helpers which
> > > > can be placed at the proper spots in kvm. In addition, it will not
> > > > break the world outside of x86.
> > >
> > > IMO, this is going in the wrong direction.  Rather than separate context tracking,
> > > vtime accounting, and KVM logic, this further intertwines the three.  E.g. the
> > > context tracking code has even more vtime accounting NATIVE vs. GEN vs. TICK
> > > logic baked into it.
> > >
> > > Rather than smush everything into context_tracking.h, I think we can cleanly
> > > split the context tracking and vtime accounting code into separate pieces, which
> > > will in turn allow moving the wrapping logic to linux/kvm_host.h.  Once that is
> > > done, splitting the context tracking and time accounting logic for KVM x86
> > > becomes a KVM detail as opposed to requiring dedicated logic in the context
> > > tracking code.
> > >
> > > I have untested code that compiles on x86, I'll send an RFC shortly.
> >
> > We need an easy to backport fix and then we might have some further
> > cleanups on top.
>
> I fiddled with this a bit today, I think I have something workable that will be
> a relatively clean and short backport.  With luck, I'll get it posted tomorrow.

I think we should improve my posted version instead of posting a lot
of alternative versions to save everybody's time.

    Wanpeng
