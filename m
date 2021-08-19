Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512FA3F1474
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 09:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhHSHmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 03:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbhHSHmI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 03:42:08 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37726C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 00:41:32 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y6so9950628lje.2
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 00:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tsSNbeEBNZSbQ4voZetX+01VzHddj7y0XxzZ0nw5plA=;
        b=UCPTM5pjh10EmmOOZD+LSwf70oIaUZEdd1Tk1Rt3fTZiGFM484FgkC68jJsHZRO0Fi
         jcsfJe3ddGYzaDwPLaasj7kp7b+8ClmMD0NgRNtAOpILPyah+mcSq1LDuXXbxf2yyjmu
         QVOLTI4HPYq6OPd2edlHh8MuMBYT6dE0EMHLruk7gYFHAXEmkipyx4hkzU2bNBZxB1eh
         sP5oHtNqH4OttIEmHbvPREPnYyROFFH7rNiyOBdWAZgFi3z0ZKUQKIKLOmt4QzWd5w+c
         QQmX4ubZUTe/KIcaHfhyOE4RORu1pG1A6L9pkeSr7070hgBTJLC7jNHN4qUdp9h1I0Qk
         bJxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tsSNbeEBNZSbQ4voZetX+01VzHddj7y0XxzZ0nw5plA=;
        b=ifobK2MGCG6lEMzI5E8SugoP7bjUYqyiAFxIcp3wSVZLZEyx3Lco2mUxJFcz1Zqs22
         LqjRJPMW7DIPvzcuufxRBIqa/Z5NvY4lNovgpVx8BdgpVnDNCTRGonB7QohW/t8eMj2c
         gTNY+hCfImTQ+5VkymC8YaN95fg8fg1xX7i4tC69q8xOwCtPwVnGLvrVCeB2Sm/qtatc
         X71nh2jQ25QAv3dCq0tegUKQ7pNMYEcvJvB8L9DZGW0ywusdN+0xelW0MF5btssTXWnz
         zcdZtbFGFRRJLpt4ACLBhgHiFW3kA7r+rFloiHd9SEoLocXR8C5ZwJ3PxdPELJvp8CK0
         RG4Q==
X-Gm-Message-State: AOAM5321Oq+Wr9bk7ltajKZgv/LIztyRJZ2xqulwEj2nOZ9l+cghlft/
        YTsaE/U6h2w+pZEVhbOc0EhnWQjZS3on65TM4VgHWw==
X-Google-Smtp-Source: ABdhPJznhi5l6W4aAokZEBPq3d/0zfR9rl3JaVxso8Q5Na5AMA8G8yWoZ++IGCK2T9z/3+3PJsjU9nTjVMBSL2fZxHY=
X-Received: by 2002:a05:651c:33b:: with SMTP id b27mr11512410ljp.314.1629358890171;
 Thu, 19 Aug 2021 00:41:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210818213205.598471-1-ricarkol@google.com> <CAOQ_QshVenuri8WdZdEis4szCv03U0KRNt4CqDNtvUBsqBqUoA@mail.gmail.com>
 <YR1/YEY8DX+r05nt@google.com>
In-Reply-To: <YR1/YEY8DX+r05nt@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 19 Aug 2021 00:41:19 -0700
Message-ID: <CAOQ_Qsgy7d7pWc=0AHpR2LHO67Z=gCa-TV46NxXMsFP8yqOzTw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: vgic: drop WARN from vgic_get_irq
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        james.morse@arm.com, Alexandru.Elisei@arm.com, drjones@redhat.com,
        catalin.marinas@arm.com, suzuki.poulose@arm.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 18, 2021 at 2:45 PM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Wed, Aug 18, 2021 at 02:34:03PM -0700, Oliver Upton wrote:
> > Hi Ricardo,
> >
> > On Wed, Aug 18, 2021 at 2:32 PM Ricardo Koller <ricarkol@google.com> wrote:
> > >
> > > vgic_get_irq(intid) is used all over the vgic code in order to get a
> > > reference to a struct irq. It warns whenever intid is not a valid number
> > > (like when it's a reserved IRQ number). The issue is that this warning
> > > can be triggered from userspace (e.g., KVM_IRQ_LINE for intid 1020).
> > >
> > > Drop the WARN call from vgic_get_irq.
> > >
> > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >
> > > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > > index 111bff47e471..81cec508d413 100644
> > > --- a/arch/arm64/kvm/vgic/vgic.c
> > > +++ b/arch/arm64/kvm/vgic/vgic.c
> > > @@ -106,7 +106,6 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> > >         if (intid >= VGIC_MIN_LPI)
> > >                 return vgic_get_lpi(kvm, intid);
> > >
> > > -       WARN(1, "Looking up struct vgic_irq for reserved INTID");
> >
> > Could we maybe downgrade the message to WARN_ONCE() (to get a stack)
> > or pr_warn_ratelimited()? I agree it is problematic that userspace can
> > cause this WARN to fire, but it'd be helpful for debugging too.
> >
>
> Was thinking about that, until I found this in bug.h:
>
>         /*
>          * WARN(), WARN_ON(), WARN_ON_ONCE, and so on can be used to report
>          * significant kernel issues that need prompt attention if they should ever
>          * appear at runtime.
>          *
>          * Do not use these macros when checking for invalid external inputs
>          * (e.g. invalid system call arguments, or invalid data coming from
>          * network/devices),
>
> Just in case, KVM_IRQ_LINE returns -EINVAL for an invalid intid (like
> 1020). I think it's more appropriate for the vmm to log it. What do you
> think?

vgic_get_irq() is called in a bunch of other places though, right?
IOW, intid doesn't necessarily come from userspace. In fact, I believe
KVM_IRQ_LINE is the only place we pass a value from userspace to
vgic_get_irq() (don't quote me on that).

Perhaps instead the fix could be to explicitly check that the intid
from userspace is valid and exit early rather than count on
vgic_get_irq() to do the right thing.

--
Thanks,
Oliver

> > >         return NULL;
> > >  }
> > >
> > > --
> > > 2.33.0.rc2.250.ged5fa647cd-goog
> > >
