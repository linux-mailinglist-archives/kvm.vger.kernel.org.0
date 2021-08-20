Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FAC3F26E1
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 08:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhHTGgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 02:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbhHTGge (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 02:36:34 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECBEC061756
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 23:35:57 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d5so6708009qtd.3
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 23:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x4BUx2XF2g+eANj8K3DiizaXKH8rES+7+IBJDMT/M84=;
        b=fEKmCkmPW2WRSTH0UOBZIggTO3VzSvZceyA2rDxv0GHM/eIW9xyTtwRGG/IG/RrvHQ
         RBDQ3PojrK85BTJLS06A3fsNsYc5EVQtSPEq9AzUDWDIvX6a0h16icO9BtnIDDmt3BP3
         U/6YCDEnnYBoCiSP8ZOF5TFvwLEzE38eCQ2Srvh3Xtik7z8B+nPZUESn81VTYA1NWtyh
         cf/Ps0dsmzJ3hwsXf1UUDYyOP13BVC5tGK59tTydrAvmHV+93tpyzOPdKT9yYT3UpP6a
         Kq2TMZY1/YwVAivFFABqh2kp+D4Bvqecwmlhx2/MFzKwkba0wXFURlimYWn0vDLbsTIL
         ALNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x4BUx2XF2g+eANj8K3DiizaXKH8rES+7+IBJDMT/M84=;
        b=DBIX+CbQEJXo5rL+xyIXIfrpV3imC0bmZfwdRW/lkw+617IxyndcznQf18DQzaBnr+
         vg9k8AFTb70fcoadK8zkevbjOvzwDUTt1PMqMn7iR6H4sJhosgnDRHQyrxVGHAK4AU4M
         6a8iXxAhIVhUQjBeeUgXHZ8CK5ZJQ+te/fC956wuJVbf+/kVp1au08PNati2Lm/STfQl
         JSg8jGVy72PHHnsgvhxT5GxbAbm8iH1sUP4cSAdKCWozPB6s3ShCJvLqn5WotP3WklOX
         x39SLZd+PWaAkvOXPEEncECPQd3Ez7e4ir0POLmO3Kn+W5b16eE9ZpzegTg7vqg/kp2m
         0gAA==
X-Gm-Message-State: AOAM532/ZikdGPqHnqa7+AI2Z2vrtK/xR6WlXuvVy8F7VWHmgCWzthby
        V/DyAX2dDnGDBfz3u79syzASKzABODYn8Kw6ShZ/2w==
X-Google-Smtp-Source: ABdhPJzszjsxOcKw23gqj3JYe++tO8Il5Wrqncm/dBgLF58wQcrlK8qhJO/51V6bt9Fg98a0gcw497JTpdQHs5q+b14=
X-Received: by 2002:ac8:7154:: with SMTP id h20mr16540010qtp.251.1629441356449;
 Thu, 19 Aug 2021 23:35:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210819154910.1064090-1-pgonda@google.com> <20210819154910.1064090-2-pgonda@google.com>
 <CAA03e5Gh0kJYHP1R3F7uh6x83LBFPp=af2xt7q3epgg+8XW53g@mail.gmail.com>
 <CAMkAt6oJcW3MHP3fod9RnRHCEYp-whdEtBTyfuqgFgATKa=3Hg@mail.gmail.com> <YR7iD6kdTUpWwwRn@google.com>
In-Reply-To: <YR7iD6kdTUpWwwRn@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Thu, 19 Aug 2021 23:35:45 -0700
Message-ID: <CAA03e5FAXDVSwMAQO57gztYmB2K8K8fNrHwsX_N3Hbgwch8pBw@mail.gmail.com>
Subject: Re: [PATCH 1/2 V4] KVM, SEV: Add support for SEV intra host migration
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Gonda <pgonda@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 3:58 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Aug 19, 2021, Peter Gonda wrote:
> > > >
> > > > +static int svm_sev_lock_for_migration(struct kvm *kvm)
> > > > +{
> > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +       int ret;
> > > > +
> > > > +       /*
> > > > +        * Bail if this VM is already involved in a migration to avoid deadlock
> > > > +        * between two VMs trying to migrate to/from each other.
> > > > +        */
> > > > +       spin_lock(&sev->migration_lock);
> > > > +       if (sev->migration_in_progress)
> > > > +               ret = -EBUSY;
> > > > +       else {
> > > > +               /*
> > > > +                * Otherwise indicate VM is migrating and take the KVM lock.
> > > > +                */
> > > > +               sev->migration_in_progress = true;
> > > > +               mutex_lock(&kvm->lock);
>
> Deadlock aside, mutex_lock() can sleep, which is not allowed while holding a
> spinlock, i.e. this patch does not work.  That's my suggestion did the crazy
> dance of "acquiring" a flag.
>
> What I don't know is why on earth I suggested a global spinlock, a simple atomic
> should work, e.g.
>
>                 if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
>                         return -EBUSY;
>
>                 mutex_lock(&kvm->lock);
>
> and on the backend...
>
>                 mutex_unlock(&kvm->lock);
>
>                 atomic_set_release(&sev->migration_in_progress, 0);
>
> > > > +               ret = 0;
> > > > +       }
> > > > +       spin_unlock(&sev->migration_lock);
> > > > +
> > > > +       return ret;
> > > > +}
> > > > +
> > > > +static void svm_unlock_after_migration(struct kvm *kvm)
> > > > +{
> > > > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +
> > > > +       mutex_unlock(&kvm->lock);
> > > > +       WRITE_ONCE(sev->migration_in_progress, false);
> > > > +}
> > > > +
> > >
> > > This entire locking scheme seems over-complicated to me. Can we simply
> > > rely on `migration_lock` and get rid of `migration_in_progress`? I was
> > > chatting about these patches with Peter, while he worked on this new
> > > version. But he mentioned that this locking scheme had been suggested
> > > by Sean in a previous review. Sean: what do you think? My rationale
> > > was that this is called via a VM-level ioctl. So serializing the
> > > entire code path on `migration_lock` seems fine. But maybe I'm missing
> > > something?
> >
> >
> > Marc I think that only having the spin lock could result in
> > deadlocking. If userspace double migrated 2 VMs, A and B for
> > discussion, A could grab VM_A.spin_lock then VM_A.kvm_mutex. Meanwhile
> > B could grab VM_B.spin_lock and VM_B.kvm_mutex. Then A attempts to
> > grab VM_B.spin_lock and we have a deadlock. If the same happens with
> > the proposed scheme when A attempts to lock B, VM_B.spin_lock will be
> > open but the bool will mark the VM under migration so A will unlock
> > and bail. Sean originally proposed a global spin lock but I thought a
> > per kvm_sev_info struct would also be safe.
>
> Close.  The issue is taking kvm->lock from both VM_A and VM_B.  If userspace
> double migrates we'll end up with lock ordering A->B and B-A, so we need a way
> to guarantee one of those wins.  My proposed solution is to use a flag as a sort
> of one-off "try lock" to detect a mean userspace.

Got it now. Thanks to you both, for the explanation. By the way, just
to make sure I completely follow, I assume that if a "double
migration" occurs, then user space is mis-behaving -- correct? But
presumably, we need to reason about how to respond to such
mis-behavior so that buggy or malicious user-space code cannot stumble
over/exploit this scenario?
