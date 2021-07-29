Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6953DAD7F
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 22:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhG2UYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 16:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhG2UYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 16:24:10 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D358C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 13:24:05 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id d17so13393966lfv.0
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 13:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gj7yCj3TgjmiQPtQl0jHjvThrzk1CYgb/iJobvGGefk=;
        b=tl09esBor3zjI+pKbOaNgY4vHM/cu59XWi6upaP0j5ZXoIJjMeDMjLYtUFUsLyn+iW
         xo6xMo/kZo6MvUbXVq76eALXaBvUOZuBqlFleNDkQojj1DTWOmrC+aM1kCGXye8VKf1V
         wv5J3wu2RvdOaHyo1pFpCK9ko2I2tywWIMm0rCQ7J+cZ3Y5oZUSlXXhMXGc2XIr7/aU5
         QVP8igM173wDGREtV03oDcqNYlUSnhMYfx4/tjWFc2pj3LxwDw8Zq7wrvTwvpJRi1WSE
         qRY+A8YZFNHyax+N2dPeGqxEchGSO2B8vG23E2kN0nYBnY/q/TEi1FkqHdqRXowpjLkx
         m0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gj7yCj3TgjmiQPtQl0jHjvThrzk1CYgb/iJobvGGefk=;
        b=KQJd1YJt4djSl11O+RoHYXbMPkUKY/kZmQ+iC/M1vCG3uR3iV6ZMw2/hhQ5BWH7LaK
         8DvXHGuWr/mYIezHp7MeeVeKqB900evfDh9TinSp7jSvu4w7iUdqHpTxm2PHNl47wn7X
         M68OyL2Cc2mN9Sw7DVqwxk6MmxCZ4aY8usOq3CraD6IPLGtztlpUg87ToKw36jJiiND+
         +ltg7M+VQvL2274fk+XlTLi///pZIMYBSIXtcRdphm+dNhCTvZZypNoRecOK2D6R6853
         4GDsiZw0c9vfII1TQQHixF+hJnDREXJHZjFVLnnC3HfcwienkspSnfLErtviNuZnnNsd
         RRVg==
X-Gm-Message-State: AOAM530YJVCWhTXb4gMyODHI2Yx1YBDYPKUPVFI72zYrZBdItp6+DtOp
        q8xCMM1nXKLmED1vKreKpdgOVn+eWIyP7AqZPhLBOQ==
X-Google-Smtp-Source: ABdhPJzPxiDGiDFKysX5izFriQkSlWyo919HiI1mAjdl/EIF2YA5xH+2Ix5p0VGNtGuJGYezdz59xwCBRVN47iNQNuc=
X-Received: by 2002:a05:6512:3237:: with SMTP id f23mr4870368lfe.524.1627590243514;
 Thu, 29 Jul 2021 13:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210729195632.489978-1-oupton@google.com> <20210729195632.489978-2-oupton@google.com>
 <CAAdAUtge_wRL-Ri-TngototL5jixSfDyJm7nTaYBXJqXU0jfmw@mail.gmail.com>
In-Reply-To: <CAAdAUtge_wRL-Ri-TngototL5jixSfDyJm7nTaYBXJqXU0jfmw@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 29 Jul 2021 13:23:52 -0700
Message-ID: <CAOQ_QshrXJx42AS4Efu3gSZj1fnGgJ9FMFCydtdZ9h3Zj8cy=A@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: Record number of signal exits as a vCPU stat
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM ARM <kvmarm@lists.cs.columbia.edu>, KVM <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Guangyu Shi <guangyus@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 29, 2021 at 1:07 PM Jing Zhang <jingzhangos@google.com> wrote:
>
> On Thu, Jul 29, 2021 at 12:56 PM Oliver Upton <oupton@google.com> wrote:
> >
> > Most other architectures that implement KVM record a statistic
> > indicating the number of times a vCPU has exited due to a pending
> > signal. Add support for that stat to arm64.
> >
> > Cc: Jing Zhang <jingzhangos@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  arch/arm64/kvm/arm.c              | 1 +
> >  arch/arm64/kvm/guest.c            | 3 ++-
> >  3 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 41911585ae0c..70e129f2b574 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -576,6 +576,7 @@ struct kvm_vcpu_stat {
> >         u64 wfi_exit_stat;
> >         u64 mmio_exit_user;
> >         u64 mmio_exit_kernel;
> > +       u64 signal_exits;
> >         u64 exits;
> >  };
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index e9a2b8f27792..60d0a546d7fd 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                 if (signal_pending(current)) {
> >                         ret = -EINTR;
> >                         run->exit_reason = KVM_EXIT_INTR;
> > +                       ++vcpu->stat.signal_exits;
> >                 }
> >
> >                 /*
> > diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> > index 1dfb83578277..50fc16ad872f 100644
> > --- a/arch/arm64/kvm/guest.c
> > +++ b/arch/arm64/kvm/guest.c
> > @@ -50,7 +50,8 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
> >         STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
> >         STATS_DESC_COUNTER(VCPU, mmio_exit_user),
> >         STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
> > -       STATS_DESC_COUNTER(VCPU, exits)
> > +       STATS_DESC_COUNTER(VCPU, exits),
> > +       STATS_DESC_COUNTER(VCPU, signal_exits),
> How about put signal_exits before exits as the same order in
> kvm_vcpu_stat just for readability?

Definitely.

> >  };
> >  static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
> >                 sizeof(struct kvm_vcpu_stat) / sizeof(u64));
> > --
> > 2.32.0.554.ge1b32706d8-goog
> >
> Reviewed-by: Jing Zhang <jingzhangos@google.com>

Thanks Jing!
