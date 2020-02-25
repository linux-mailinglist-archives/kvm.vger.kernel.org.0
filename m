Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85F516C3D2
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 15:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgBYO0c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 09:26:32 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44484 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730525AbgBYO0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 09:26:32 -0500
Received: by mail-oi1-f194.google.com with SMTP id d62so12676354oia.11;
        Tue, 25 Feb 2020 06:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QVZ+sybgO0aKAmVZ2qg1eROixluCRNPHwtU0MppkuKU=;
        b=OpSF6Rm5Qu0v9jB/gF9QSNPI9lbEWCfSRdINO+sRis1bVFFjCgpvgvBMGjd7yjzLB3
         F4waFiJD9U2jd9tfKG+hDsApfQKEXXe8K9/KDpY7Hksor9SHoO5+ixv4D4/F+8FLRo3Z
         AyE8lrrqHwIGCOJuhmhZHKbNpjs7hcNKVLQuewbbZ5Rdh3Wd70vGyDLFlp47+Kukk2C0
         xx0/TkYnSBGytZOSTtlRTDGW9sK4yX0l8tIXETx0Fpd9Dt+BjYEKD/amkrv5TYywErUO
         7C07A9jDHhXSRc2i2oZVlLflOCg3P+miRrnHvQtJG0C41I8sicmB7TTQufRQmwj3StE/
         UQkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QVZ+sybgO0aKAmVZ2qg1eROixluCRNPHwtU0MppkuKU=;
        b=BJREBdPqCQ/KDV2IOIESeZkFpOQtpDAroBc9ERX5D9K3KrGJJrzPqmxKFHVlK9OB3S
         WTRPIqCTsd75l/jRT4VWv5RzkMkSS+okaFJA/GxteEB8qoCDntDOXVMTEWz0FTUSBf5l
         ZckMKRzJwEO+WXNSNsfLatv6PYdYGOpAlnKm41i/sXfG/bZt2La/zImsR+YcXxnYEnCW
         rVBdFSEBeootjaxHL61rJROphfKr41oAy2ss5gHaVDKis389r6YorydzjHk3Zf+/dwrg
         AoaqKiVlpUCPht9T4FkeUwfz5iNPKjDWqrFoZSOTdU2ZpKyj7dkSamwuJRb7LDrFL49+
         FmDg==
X-Gm-Message-State: APjAAAUYxihWLJa5oyU/WmrH0WuiMUlyrYhv9xvhuFwjXUvVjNY129Ix
        DByc2eV7esOf8GESRHLwwsMTZ9HE0/2yTcYOBEU=
X-Google-Smtp-Source: APXvYqwqOF94zwr1nS6udLZXJncXxj33efGYNtHI3II4N+LmaoKu0DilqoeydV7O+QDHO5yTlVFJPFzuQkOU3grDp7Q=
X-Received: by 2002:aca:1913:: with SMTP id l19mr3562113oii.47.1582640790320;
 Tue, 25 Feb 2020 06:26:30 -0800 (PST)
MIME-Version: 1.0
References: <1582624061-5814-1-git-send-email-wanpengli@tencent.com> <0af6b96a-16ac-5054-7754-6ab4a239a2d4@redhat.com>
In-Reply-To: <0af6b96a-16ac-5054-7754-6ab4a239a2d4@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 25 Feb 2020 22:26:19 +0800
Message-ID: <CANRm+Cz7mKjm7_9H4O4y2XYEv8VnErTtu=dr-8fN0RCCjf0wvA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Recalculate apic map in batch
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Feb 2020 at 22:20, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 25/02/20 10:47, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > In the vCPU reset and set APIC_BASE MSR path, the apic map will be recalculated
> > several times, each time it will consume 10+ us observed by ftrace in my
> > non-overcommit environment since the expensive memory allocate/mutex/rcu etc
> > operations. This patch optimizes it by recaluating apic map in batch, I hope
> > this can benefit the serverless scenario which can frequently create/destroy
> > VMs.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * add apic_map_dirty to kvm_lapic
> >  * error condition in kvm_apic_set_state, do recalcuate  unconditionally
> >
> >  arch/x86/kvm/lapic.c | 29 +++++++++++++++++++----------
> >  arch/x86/kvm/lapic.h |  2 ++
> >  arch/x86/kvm/x86.c   |  2 ++
> >  3 files changed, 23 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index afcd30d..3476dbc 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -164,7 +164,7 @@ static void kvm_apic_map_free(struct rcu_head *rcu)
> >       kvfree(map);
> >  }
> >
> > -static void recalculate_apic_map(struct kvm *kvm)
> > +void kvm_recalculate_apic_map(struct kvm *kvm)
> >  {
>
> It's better to add an "if" here rather than in every caller.  It should
> be like:
>
>         if (!apic->apic_map_dirty) {
>                 /*
>                  * Read apic->apic_map_dirty before
>                  * kvm->arch.apic_map.
>                  */
>                 smp_rmb();
>                 return;
>         }
>
>         mutex_lock(&kvm->arch.apic_map_lock);
>         if (!apic->apic_map_dirty) {
>                 /* Someone else has updated the map.  */
>                 mutex_unlock(&kvm->arch.apic_map_lock);
>                 return;
>         }
>         ...
> out:
>         old = rcu_dereference_protected(kvm->arch.apic_map,
>                         lockdep_is_held(&kvm->arch.apic_map_lock));
>         rcu_assign_pointer(kvm->arch.apic_map, new);
>         /*
>          * Write kvm->arch.apic_map before
>          * clearing apic->apic_map_dirty.
>          */
>         smp_wmb();
>         apic->apic_map_dirty = false;
>         mutex_unlock(&kvm->arch.apic_map_lock);
>         ...
>
> But actually it seems to me that, given we're going through all this
> pain, it's better to put the "dirty" flag in kvm->arch, next to the
> mutex and the map itself.  This should also reduce the number of calls
> to kvm_recalculate_apic_map that recompute the map.  A lot of them will
> just wait on the mutex and exit.

Good point, will do in next version.

    Wanpeng
