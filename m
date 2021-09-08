Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C814040D0
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 00:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhIHWCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 18:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbhIHWCB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 18:02:01 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91684C061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 15:00:52 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id r3so3855832ljc.4
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 15:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GDe9/Ly5F2n1g5YILCIvzMoK8BHDpL9Shfxx8ob78n4=;
        b=ejEiHkTbeEbIe67154apcT6mUJBjbEHtHjSH6KVMwCN8+RT2TpS8G0QlBpEgX0pUJX
         LzgWU3tVcaSU7vKRiDKGv9cm6pBYL0hv+hs5sIy/jbtxngC97nN7EwipCaUbadrIGRsq
         Sl1aUxqaKsteQoj9w7oiv1ZeuxRPJNvIjuqVGNiI2sZ1+xU9p0CspL8j+F2+n+x6oR3z
         Hb0ULJLmgmce9LYYuL9thl9cimbDBD6CNRrwdbShlRAIWAJ2/1MCGN/WvNdxDPeu0Ca3
         /N9f3PB9u2TD92YzD7weC0FRLI4n0pkw1azmceDiMcdd654fsUrQhAbRji62whb2iPVg
         v59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GDe9/Ly5F2n1g5YILCIvzMoK8BHDpL9Shfxx8ob78n4=;
        b=IORyIR+eENN8RTpshljeG0sascPvUQnR/FpSOhvYsBYqUZRlyln/n4sYpTrrMvyqwA
         mmFFLt2GEs7U/5JJQMnS4KDyzzw0KWUdiTTVZ5xAbM/4BITYtC+iPy9Ssq0fUDdv9M1Y
         3dpytrZoCujbormLZbnKEs6yN57QK9uKSuQmEW1Tm62uWwoh2YH8RTjp3/1cot3pXUfL
         ZmdCa4gGahzO5YuvnuOw8qJb9FFOq15Gjplp5kGoBo1vfNXn93Ypm54zTaNgvQ8SPSQ2
         XPBTRHfpvhH3CcFaaceBcCPnxpBhWrWB1cOvqkOT9WEhEKlGaPAm67+RtPeuQvJnsId1
         o1Cg==
X-Gm-Message-State: AOAM531O8zQ3BFZEPwkVaVfWLF2JnVYQBVgmSfyW4gLIlx7OmjUKeLzE
        OgkOTYme/2rLFZcrejLw8yIIVwpupJdzU1KNJxLLdQ==
X-Google-Smtp-Source: ABdhPJxPzpIxpaq3ZMzFadWNqfu8YiOXjvgiyHMV9g8NIse80i9fIoc1m0TkP2py7fGZEiT8oipYK0+5WfGzQIekGMc=
X-Received: by 2002:a2e:5c9:: with SMTP id 192mr359998ljf.337.1631138450633;
 Wed, 08 Sep 2021 15:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210908210320.1182303-1-ricarkol@google.com> <20210908210320.1182303-2-ricarkol@google.com>
 <YTkr1c7S0wPRv6hH@google.com> <YTkwGHdBcy7v/mSA@google.com>
In-Reply-To: <YTkwGHdBcy7v/mSA@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Wed, 8 Sep 2021 18:00:39 -0400
Message-ID: <CAOQ_QsjZMSXYz_BES8JBQncSN5ubdPhs5GrF3OU8KkLf=TiSfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        Alexandru.Elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 8, 2021 at 5:50 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Sep 08, 2021 at 09:32:05PM +0000, Oliver Upton wrote:
> > Hi Ricardo,
> >
> > On Wed, Sep 08, 2021 at 02:03:19PM -0700, Ricardo Koller wrote:
> > > Extend vgic_v3_check_base() to verify that the redistributor regions
> > > don't go above the VM-specified IPA size (phys_size). This can happen
> > > when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> > >
> > >   base + size > phys_size AND base < phys_size
> > >
> > > vgic_v3_check_base() is used to check the redist regions bases when
> > > setting them (with the vcpus added so far) and when attempting the first
> > > vcpu-run.
> > >
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> > > index 66004f61cd83..5afd9f6f68f6 100644
> > > --- a/arch/arm64/kvm/vgic/vgic-v3.c
> > > +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> > > @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
> > >             if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
> > >                     rdreg->base)
> > >                     return false;
> >
> > Can we drop this check in favor of explicitly comparing rdreg->base with
> > kvm_phys_size()? I believe that would be more readable.
> >
>
> You mean the integer overflow check above? in that case, I would prefer
> to leave it, if you don't mind. It seems that this type of check is used
> in some other places in KVM (like kvm_assign_ioeventfd and
> vgic_v3_alloc_redist_region).

I would expect rdreg->base to exceed kvm_phys_size() before wrapping,
but we do derive rdreg->count from what userspace gives us. In that
case, your addition in combination with this makes sense, so no real
objections here.

> > > +
> > > +           if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> > > +                   kvm_phys_size(kvm))
> > > +                   return false;
> > >     }
> > >
> > >     if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> > > --
> > > 2.33.0.153.gba50c8fa24-goog
> > >
> >
> > --
> > Thanks,
> > Oliver

Reviewed-by: Oliver Upton <oupton@google.com>
