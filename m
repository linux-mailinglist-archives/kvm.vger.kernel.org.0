Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C687E405B06
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237564AbhIIQkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 12:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237333AbhIIQkS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 12:40:18 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B51C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 09:39:09 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id z18so5096327ybg.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 09:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6S9aCreq/0VGuneRW3q7amVuNejEfZAPRbvdWpbNPQ=;
        b=m6C+xr8tBL6hn8M8cZtiWUFtOEKpLOROHS4EvWaOJSbMPA7AjRIRr1vjbiUaLXdHri
         9bChgFEoA7TNwaIB2TxgMA7wdFDJ9wlKq71tu4BLkfkS5MTzQ26PFHISd9tpV4M3imSE
         QGv01Iujhkw0xNImfBFO/zLPR8xyfFHJs5LYzOtGCVPAXXaOpZrLqwu9aW7BDbNX1jF9
         bZyN/dJlHSEnfAZJhYmTl2j93j7oCs4u4IJoQL2RBGzQ3SrLvdei7URfW3nBY/I+KbnI
         2fXNMFhGYk7bOI8C9+qndcbxbrCBqkwBQkMwJmF07nSgKWQvjwdtAF5XbVnq7umSh8Mf
         /Rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6S9aCreq/0VGuneRW3q7amVuNejEfZAPRbvdWpbNPQ=;
        b=Xeqtx8Kazs18U8N2Ms6FxWCa4tGjp3E8fl4V2fOg/G0uyHJRvP0ld5REx41XHsQeai
         NfbRMJHraG5LM5hJ6V3HzFubV9XNhzCbbmTyeEOw8sAHXtfoxmB/Jy6t6uucFS6eClot
         fnWXeRYZWauSAX780ILUaEnjDha5QCqS1Yc28H6OMheUK1LpLORiiPQ5JaR0+iUuh44A
         vGnHSlRmDW/wqXfRdwWVRGMLswR+p2cSyQ3YA7grDqahCPKJk6dHm/W+lY48Ylhh1Osr
         2BXZw8UIXZfvHlkwi7Mh9BHLip8t1m6nOPVLKNWEpMkpv6kUfntUtho5F7tsqNwYfrD1
         BeAw==
X-Gm-Message-State: AOAM532Pk6QJSu5HeKa6JnT2GDWSSQzD4TnyM3zxv6H4YsEOLq+PU8G0
        yXloCUufq11hF1mm7RtW4COKKuqHWNUybwfpXW07Lw==
X-Google-Smtp-Source: ABdhPJzQhQS8ZeN1ti9BJ6nGicAZyMX4s6L1J/GWjGE8KzWUlbKpTmRa1mxRjjyzjuZ9X5UHGcqUo+phpbusAExxylk=
X-Received: by 2002:a25:21c5:: with SMTP id h188mr4685737ybh.23.1631205548028;
 Thu, 09 Sep 2021 09:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com> <20210909013818.1191270-12-rananta@google.com>
 <YTmZPSEm3Fj6l1PN@google.com>
In-Reply-To: <YTmZPSEm3Fj6l1PN@google.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 9 Sep 2021 09:38:56 -0700
Message-ID: <CAJHc60x_r46W+81=A76zC=zW_3xqmvMWf3CspiQKVVnPA0TtTA@mail.gmail.com>
Subject: Re: [PATCH v4 11/18] KVM: arm64: selftests: Add basic GICv3 support
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 8, 2021 at 10:18 PM Oliver Upton <oupton@google.com> wrote:
>
> On Thu, Sep 09, 2021 at 01:38:11AM +0000, Raghavendra Rao Ananta wrote:
> > Add basic support for ARM Generic Interrupt Controller v3.
> > The support provides guests to setup interrupts.
> >
> > The work is inspired from kvm-unit-tests and the kernel's
> > GIC driver (drivers/irqchip/irq-gic-v3.c).
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   2 +-
> >  .../selftests/kvm/include/aarch64/gic.h       |  21 ++
> >  tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++++
> >  .../selftests/kvm/lib/aarch64/gic_private.h   |  21 ++
> >  .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 ++++++++++++++++++
> >  .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++++
> >  6 files changed, 446 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> >  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
> >
>
> [...]
>
> > +static void
> > +gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
> > +{
> > +     const struct gic_common_ops *gic_ops;
>
> does this need to be initialized? I haven't tried compiling, but it
> seems it should trigger a compiler warning as it is only initialized if
> type == GIC_V3.
>
Huh, I thought I had a default case covering this (must have gone lost
during code reorg).
Nice catch though! Surprisingly, the compiler never warned. I'm not
sure if its smart
enough to figure out that the caller of this function had
GUEST_ASSERT(type < GIC_TYPE_MAX);
Anyway, I'll clean it up.

Regards,
Raghavendra

> > +     spin_lock(&gic_lock);
> > +
> > +     /* Distributor initialization is needed only once per VM */
> > +     if (gic_common_ops) {
> > +             spin_unlock(&gic_lock);
> > +             return;
> > +     }
> > +
> > +     if (type == GIC_V3)
> > +             gic_ops = &gicv3_ops;
> > +
> > +     gic_ops->gic_init(nr_cpus, dist_base);
> > +     gic_common_ops = gic_ops;
> > +
> > +     /* Make sure that the initialized data is visible to all the vCPUs */
> > +     dsb(sy);
> > +
> > +     spin_unlock(&gic_lock);
> > +}
>
