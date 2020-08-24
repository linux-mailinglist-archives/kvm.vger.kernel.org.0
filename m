Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852E3250BD0
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 00:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgHXWpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 18:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgHXWpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 18:45:38 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC69C061574
        for <kvm@vger.kernel.org>; Mon, 24 Aug 2020 15:45:38 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id g18so2290323ooa.0
        for <kvm@vger.kernel.org>; Mon, 24 Aug 2020 15:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kz/k9wb2FtFBpuN0H9LrQExFH8jcMXPO4pczO7F26a8=;
        b=RzJVZWj2odYP6gj+fnANkDRiVVO5QhynntjYJvZQrziuYBLmg36YoSiEn+/tuSF6+l
         jSWpep4dxnzhgbca667Rpo5Mxk50/9gFQ6tQQBsZdz9Im5PIRnsfTdqdFJtoDKSu3KmC
         GABfjj4dKx0Ga2DUHZLRTUfZ/IE9hSQCBP0tLGFRDLgfEh2eV4Ge8e79ZidlpZso4sq1
         TJeK+3yi4N9NYShqELK6tdREyDCjIj52z0iXQRbLKKyy9oY74rVPBsXko1Y+Xueqw5ao
         0b5zrHgEFx/lPxfBW0oU3vY/nREloWj4xuxW7R/pQZIZY+GrfTpqK+z1MZAkAcyVWd3c
         Zg/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kz/k9wb2FtFBpuN0H9LrQExFH8jcMXPO4pczO7F26a8=;
        b=bS0TvUur386eAG1zIhFdygDw4MYyhfHRrZN9KWBzO0Ic86ulP2EWg5bO7r6i4Yaqts
         qrIJlWms2O6ha+Fzmu85Hz1B2C7Yz6rmZyW8L6UPaw4Fwmr9JCEBgbv8VcxB3oP2ZsQf
         FsYE8TUypLfCrYNBGrAf2+J8o1FNn7pYcRt+NCvQi4vsnvUnj0BClcdHUzAUhDPUCsoj
         76GW5efCKyMo0YvqxYGwUgvo5nZftppYNg712mrcH2hQgu+Mb9sT+BETNC5WokMxnERp
         uHvNEYOKyPs+SEVDIeJ8ZkFdJhz8EUtfsGGNMh2Frw8lBn8Viy2dIxa+i4O88co2IPJ0
         wbcQ==
X-Gm-Message-State: AOAM531V1OtPpFDq/M93r3blwoaU077EZ8lS4eZR8vaI0WyJZlbrpNjr
        km+MeObxN08werX9llDCT6O9Qu6RKfcfHaw8qUS+XA==
X-Google-Smtp-Source: ABdhPJxoitD/PnUJXpPvhw1LOyg4DhZctOdJ0E9ohQPLLvAmBu1DMELY+FzMW8VJkgep9J7crO1jfWH/4BKHIxWQXxw=
X-Received: by 2002:a4a:87c8:: with SMTP id c8mr5196624ooi.81.1598309137774;
 Mon, 24 Aug 2020 15:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200401081348.1345307-1-vkuznets@redhat.com> <CALMp9eROXAOg_g=R8JRVfywY7uQXzBtVxKJYXq0dUcob-BfR-g@mail.gmail.com>
 <20200822034046.GE4769@sjchrist-ice> <CALMp9eRHh9KXO12k4GaoenSJazFnSaN68FTVxOGhE9Mxw-hf2A@mail.gmail.com>
In-Reply-To: <CALMp9eRHh9KXO12k4GaoenSJazFnSaN68FTVxOGhE9Mxw-hf2A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 24 Aug 2020 15:45:26 -0700
Message-ID: <CALMp9eS1HusEZvzLShuuuxQnReKgTtunsKLoy+2GMVJAaTrZ7A@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: fix crash cleanup when KVM wasn't used
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 11:57 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Fri, Aug 21, 2020 at 8:40 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, Aug 20, 2020 at 01:08:22PM -0700, Jim Mattson wrote:
> > > On Wed, Apr 1, 2020 at 1:13 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> > > > ---
> > > >  arch/x86/kvm/vmx/vmx.c | 12 +++++++-----
> > > >  1 file changed, 7 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index 3aba51d782e2..39a5dde12b79 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -2257,10 +2257,6 @@ static int hardware_enable(void)
> > > >             !hv_get_vp_assist_page(cpu))
> > > >                 return -EFAULT;
> > > >
> > > > -       INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > > > -       INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> > > > -       spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> > > > -
> > > >         r = kvm_cpu_vmxon(phys_addr);
> > > >         if (r)
> > > >                 return r;
> > > > @@ -8006,7 +8002,7 @@ module_exit(vmx_exit);
> > > >
> > > >  static int __init vmx_init(void)
> > > >  {
> > > > -       int r;
> > > > +       int r, cpu;
> > > >
> > > >  #if IS_ENABLED(CONFIG_HYPERV)
> > > >         /*
> > > > @@ -8060,6 +8056,12 @@ static int __init vmx_init(void)
> > > >                 return r;
> > > >         }
> > > >
> > > > +       for_each_possible_cpu(cpu) {
> > > > +               INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> > > > +               INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
> > > > +               spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
> > > > +       }
> > >
> > > Just above this chunk, we have:
> > >
> > > r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
> > > if (r) {
> > >         vmx_exit();
> > > ...
> > >
> > > If we take that early exit, because vmx_setup_l1d_flush() fails, we
> > > won't initialize loaded_vmcss_on_cpu. However, vmx_exit() calls
> > > kvm_exit(), which calls on_each_cpu(hardware_disable_nolock, NULL, 1).
> > > Hardware_disable_nolock() then calls kvm_arch_hardware_disable(),
> > > which calls kvm_x86_ops.hardware_disable() [the vmx.c
> > > hardware_disable()], which calls vmclear_local_loaded_vmcss().
> > >
> > > I believe that vmclear_local_loaded_vmcss() will then try to
> > > dereference a NULL pointer, since per_cpu(loaded_vmcss_on_cpu, cpu) is
> > > uninitialzed.
> >
> > I agree the code is a mess (kvm_init() and kvm_exit() included), but I'm
> > pretty sure hardware_disable_nolock() is guaranteed to be a nop as it's
> > impossible for kvm_usage_count to be non-zero if vmx_init() hasn't
> > finished.
>
> Unless I'm missing something, there's no check for a non-zero
> kvm_usage_count on this path. There is such a check in
> hardware_disable_all_nolock(), but not in hardware_disable_nolock().

However, cpus_hardware_enabled shouldn't have any bits set, so
everything's fine. Nothing to see here, after all.
