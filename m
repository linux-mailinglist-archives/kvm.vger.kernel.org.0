Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8686849660
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 02:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbfFRAnZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 20:43:25 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42342 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRAnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 20:43:25 -0400
Received: by mail-ot1-f67.google.com with SMTP id l15so2138119otn.9;
        Mon, 17 Jun 2019 17:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k2lbSxS7dzxwxb6i0Oq5RHt/qUDihaL0G0ctkpHTiJo=;
        b=qjQIrGkQ5XeuD8j9pDA0Qpe4HhzVjPlsGzACmzSceha6vC5OX5Kql7+UP7LiIlWHYj
         acDmor3TqCWB6woaO12rj90cteAj0iWOiIdLkIQTSPNU8dvie8Fv1E/XTkLLu33fGmud
         fOmmk0eExMhiBZFbPKu2VezF+vxVgwa+ZQg/0lV9BSMpZZJ3hk4QU+Ag92nlvBm2IN/4
         Npi4k2gwdgLHq5jzQtAPO7AuJ9sC01TAjX9HE5vW8h0jsEPuHN/FPY2p3CR3aoeAm8cg
         F8JFjUyKGFHqYl38TzGsG/NQbcQ3o/IEwDQHqbxchAKbcEpEDKGo0+OjXj7fMGSjY3Mt
         +9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k2lbSxS7dzxwxb6i0Oq5RHt/qUDihaL0G0ctkpHTiJo=;
        b=Ms7JEPv06MAQ+GIER49ZroFukCjdFs3Pm4zXGwEJB9yiUKtux1noUh7ql3wfjSRhKe
         lj4CAwrrvDaqcDhagAV2PSg2JTm75ukSvhdtwLbvh6nnpBuk5b+PqLOg8x7vqGm0+/fa
         pVT5BqGhWtqpfwrgUzTjD8tC9VEAkq3uwSowd2y+dJScI2b40GR4B2t2XZLZWtFfEbzY
         kgV1czym4/IcqcEQgU5CPqvMyeH6anNn0cRWclChy1nplocxPRegXmTgOsYavRkGujZY
         Vv/pgfA3TvV3nLo+/aA98OUEm5zkzIhTKyaIevTyPXku/I1oZLJPYAaMft7AHlOB33Jc
         hniA==
X-Gm-Message-State: APjAAAUoExTbNCg/5rKZVqxMksooSXbRTEqvEU47k9sE0PQI48zSF7nh
        zP6Uo/mLon6w8lr+5kTqnvabHixJTXqfXDnNEG4=
X-Google-Smtp-Source: APXvYqz4ITqIRl3oYOhvThVAimSH0fc5M/eLGiTGrmNUEYhqJJXeEUPvocWkLLkya2ZPWQgr46dZhjjTUATXxbsVOfA=
X-Received: by 2002:a9d:6959:: with SMTP id p25mr38008868oto.118.1560818604278;
 Mon, 17 Jun 2019 17:43:24 -0700 (PDT)
MIME-Version: 1.0
References: <1560770687-23227-1-git-send-email-wanpengli@tencent.com>
 <1560770687-23227-6-git-send-email-wanpengli@tencent.com> <20190617213201.GA26346@flask>
In-Reply-To: <20190617213201.GA26346@flask>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 18 Jun 2019 08:44:00 +0800
Message-ID: <CANRm+Cxrn51mJUvjH7df+U-HpPPLJJzsRf+BMebxDogSabex3g@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] KVM: LAPIC: add advance timer support to pi_inject_timer
To:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jun 2019 at 05:32, Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.c=
om> wrote:
>
> 2019-06-17 19:24+0800, Wanpeng Li:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Wait before calling posted-interrupt deliver function directly to add
> > advance timer support to pi_inject_timer.
> >
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
>
> Please merge this patch with [2/5], so bisection doesn't break.

Agreed.

>
> >  arch/x86/kvm/lapic.c   | 6 ++++--
> >  arch/x86/kvm/lapic.h   | 2 +-
> >  arch/x86/kvm/svm.c     | 2 +-
> >  arch/x86/kvm/vmx/vmx.c | 2 +-
> >  4 files changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 1a31389..1a31ba5 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1462,6 +1462,8 @@ static void apic_timer_expired(struct kvm_lapic *=
apic, bool can_pi_inject)
> >               return;
> >
> >       if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu)) {
> > +             if (apic->lapic_timer.timer_advance_ns)
> > +                     kvm_wait_lapic_expire(vcpu, true);
>
> From where does kvm_wait_lapic_expire() take
> apic->lapic_timer.expired_tscdeadline?

Sorry, I failed to understand this.
https://git.kernel.org/pub/scm/virt/kvm/kvm.git/tree/arch/x86/kvm/lapic.c?h=
=3Dqueue#n1541
We can get apic->lapic_timer.expired_tscdeadline in
kvm_wait_lapic_expire() directly.

Regards,
Wanpeng Li
