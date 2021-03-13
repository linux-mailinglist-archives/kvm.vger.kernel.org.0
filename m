Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2785B339AA1
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhCMA5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhCMA5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:57:25 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D63C061574;
        Fri, 12 Mar 2021 16:57:25 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id x135so24202513oia.9;
        Fri, 12 Mar 2021 16:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xznO7qF0Fh32t6GWFRHABRU6yKc7RKkv+nykz4qj2eg=;
        b=SiObuZz7aXD2AihzXolqZpQvM7XzSoCfJ7gyUUOK1LcBC06Uw+KxadFLo3FayZaNPG
         gKTeByT/mdU/3GxrGnYSrKyz/oVZMTqqbXBWLMMfsUIiDGeO2v73a7kZNtb+jqbRZzxu
         HtsTSBO/4ufBlA8ZddvSLTwT+vFGB+Ynm+/q/WJcBIqFaTgBThltwq2/+qrqW3943AbE
         bDZmhnaHiWqM0XRcrKnCA6b8UmMY4XfiP7/JDRaEVb8+sgACIaWkqUAV7N5CtjmV1KDr
         wxaHKczsYq3WsRb2kscyEmYAxpsr2OUx+x2Dvxs2a5xcTM/NOC0xndElW1A4KR5Gzs2E
         AGLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xznO7qF0Fh32t6GWFRHABRU6yKc7RKkv+nykz4qj2eg=;
        b=SWjHW1fwkZzreFYb8wZ7NKd3h/r1NaGTQavJafw399I0GiYDZjP0YG7sD5GftBfV23
         yRXY/s30jvrvUbPJourobFX8W2d71OmILG0JFT5NwfPNskCpcqjVNzLv5MUzARuOBuKy
         YmrRmJ7vN/svgSYqEFzmTGqW142Ynu33qQCeOUgj4lTS8JJ359AoQbinNGFUDzDrjisB
         /jAUuVHOb3oM6su19ymd0wRNAKNgphbGAxNT+wD/tRx4L892MEm/1Xa4F3aOZrkVwB0+
         wfU6tYdFLu8vQ0zBvsWT0eGO6pkuLsV2agE7mFLXc1Puud1YaFFp3ltMQafhisn1C9JF
         BdzA==
X-Gm-Message-State: AOAM533Kcw9k4SDSrpS5bFoF3z2bx/zTFcm1CfBKznXBxTGaVDe6MIr6
        ArGqQ9gcxa1tLT4CGSet83uL/mXlJ9FZw3M5L5M=
X-Google-Smtp-Source: ABdhPJwr8iopn1z4CW9JBsvYgaer28n+yQtdO+sR7f1x8Uvjykfv9wldQXHyadYfSzGBYhpxIfYLphngh1Sh6DdxfYM=
X-Received: by 2002:aca:fccb:: with SMTP id a194mr11177348oii.5.1615597045131;
 Fri, 12 Mar 2021 16:57:25 -0800 (PST)
MIME-Version: 1.0
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com> <YEo9GsUTKQRbd3HF@google.com>
In-Reply-To: <YEo9GsUTKQRbd3HF@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 13 Mar 2021 08:57:13 +0800
Message-ID: <CANRm+Cy42tM1M2vkuZk3y_-_wD-re9QxvoxWPGmyew+k1j_67w@mail.gmail.com>
Subject: Re: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Mar 2021 at 23:54, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Feb 23, 2021, Wanpeng Li wrote:
> > On Tue, 23 Feb 2021 at 13:25, Wanpeng Li <kernellwp@gmail.com> wrote:
> > >
> > > From: Wanpeng Li <wanpengli@tencent.com>
> > >
> > > After commit 997acaf6b4b59c (lockdep: report broken irq restoration), the guest
> > > splatting below during boot:
> > >
> > >  raw_local_irq_restore() called with IRQs enabled
> > >  WARNING: CPU: 1 PID: 169 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x26/0x30
> > >  Modules linked in: hid_generic usbhid hid
> > >  CPU: 1 PID: 169 Comm: systemd-udevd Not tainted 5.11.0+ #25
> > >  RIP: 0010:warn_bogus_irq_restore+0x26/0x30
> > >  Call Trace:
> > >   kvm_wait+0x76/0x90
> > >   __pv_queued_spin_lock_slowpath+0x285/0x2e0
> > >   do_raw_spin_lock+0xc9/0xd0
> > >   _raw_spin_lock+0x59/0x70
> > >   lockref_get_not_dead+0xf/0x50
> > >   __legitimize_path+0x31/0x60
> > >   legitimize_root+0x37/0x50
> > >   try_to_unlazy_next+0x7f/0x1d0
> > >   lookup_fast+0xb0/0x170
> > >   path_openat+0x165/0x9b0
> > >   do_filp_open+0x99/0x110
> > >   do_sys_openat2+0x1f1/0x2e0
> > >   do_sys_open+0x5c/0x80
> > >   __x64_sys_open+0x21/0x30
> > >   do_syscall_64+0x32/0x50
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > The irqflags handling in kvm_wait() which ends up doing:
> > >
> > >         local_irq_save(flags);
> > >         safe_halt();
> > >         local_irq_restore(flags);
> > >
> > > which triggered a new consistency checking, we generally expect
> > > local_irq_save() and local_irq_restore() to be pared and sanely
> > > nested, and so local_irq_restore() expects to be called with
> > > irqs disabled.
> > >
> > > This patch fixes it by adding a local_irq_disable() after safe_halt()
> > > to avoid this warning.
> > >
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > > ---
> > >  arch/x86/kernel/kvm.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > > index 5e78e01..688c84a 100644
> > > --- a/arch/x86/kernel/kvm.c
> > > +++ b/arch/x86/kernel/kvm.c
> > > @@ -853,8 +853,10 @@ static void kvm_wait(u8 *ptr, u8 val)
> > >          */
> > >         if (arch_irqs_disabled_flags(flags))
> > >                 halt();
> > > -       else
> > > +       else {
> > >                 safe_halt();
> > > +               local_irq_disable();
> > > +       }
> >
> > An alternative fix:
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index 5e78e01..7127aef 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -836,12 +836,13 @@ static void kvm_kick_cpu(int cpu)
> >
> >  static void kvm_wait(u8 *ptr, u8 val)
> >  {
> > -    unsigned long flags;
> > +    bool disabled = irqs_disabled();
> >
> >      if (in_nmi())
> >          return;
> >
> > -    local_irq_save(flags);
> > +    if (!disabled)
> > +        local_irq_disable();
> >
> >      if (READ_ONCE(*ptr) != val)
> >          goto out;
> > @@ -851,13 +852,14 @@ static void kvm_wait(u8 *ptr, u8 val)
> >       * for irq enabled case to avoid hang when lock info is overwritten
> >       * in irq spinlock slowpath and no spurious interrupt occur to save us.
> >       */
> > -    if (arch_irqs_disabled_flags(flags))
> > +    if (disabled)
> >          halt();
> >      else
> >          safe_halt();
> >
> >  out:
> > -    local_irq_restore(flags);
> > +    if (!disabled)
> > +        local_irq_enable();
> >  }
> >
> >  #ifdef CONFIG_X86_32
>
> A third option would be to split the paths.  In the end, it's only the ptr/val
> line that's shared.

I just sent out a formal patch for my alternative fix, I think the
whole logic in kvm_wait is more clear w/ my version.

>
> ---
>  arch/x86/kernel/kvm.c | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01ca3b4..78bb0fae3982 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -836,28 +836,25 @@ static void kvm_kick_cpu(int cpu)
>
>  static void kvm_wait(u8 *ptr, u8 val)
>  {
> -       unsigned long flags;
> -
>         if (in_nmi())
>                 return;
>
> -       local_irq_save(flags);
> -
> -       if (READ_ONCE(*ptr) != val)
> -               goto out;
> -
>         /*
>          * halt until it's our turn and kicked. Note that we do safe halt
>          * for irq enabled case to avoid hang when lock info is overwritten
>          * in irq spinlock slowpath and no spurious interrupt occur to save us.
>          */
> -       if (arch_irqs_disabled_flags(flags))
> -               halt();
> -       else
> -               safe_halt();
> +       if (irqs_disabled()) {
> +               if (READ_ONCE(*ptr) == val)
> +                       halt();
> +       } else {
> +               local_irq_disable();
>
> -out:
> -       local_irq_restore(flags);
> +               if (READ_ONCE(*ptr) == val)
> +                       safe_halt();
> +
> +               local_irq_enable();
> +       }
>  }
>
>  #ifdef CONFIG_X86_32
> --
