Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191DE402CBB
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245695AbhIGQQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234466AbhIGQQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:16:13 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CD8C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 09:15:07 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id l9so8787613vsb.8
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 09:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53NoctMz48+CeLqiVC5I0V3NFwxWAgsbbnTUAzbd+hE=;
        b=YNYxpL3byJi9/i1wxvusekdfG85rJg2iAXadc+WxFxywy4oWvjMI3uXNcyWOlxxMrS
         EdpAOUgFjqpDIS/wwwtVDTmghSnl3ODhrbnz6soZ60h+yizjbAXAkJSf1grM7Teo2r0C
         vhpt1WVvz11f4Tc2cRbTDwOhKqZuJEOwhTWYAF1wvFhhF0XXyndZ4w25FOcpk2hHjbB5
         N01VZ0RdH41I+q8ndIQdwd1WcNIxYSM/6oqxKhJIjLE4udbySizWK7QbUakq4v5VKJIG
         OjyJBm5Vl29e29rFpxmIU8FKwDKc2afSbUPg+H8twGg1Pum+7VMJAOfkHMyxuVefxNlN
         fl0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53NoctMz48+CeLqiVC5I0V3NFwxWAgsbbnTUAzbd+hE=;
        b=NZSgqJxA/TSoxbFMpV8xjACMmQK16F4Ka6Fjqa3RAuH+JJmt8uRJ1q3kCCLbsU3d7o
         aHCkSD5umas1SR0VGP/vj+PSGhUE62cDrgEziUh1wFAVft1W3n9b8NdOU4QJgpq0Wcy+
         4Bvi/CDc3cN8isTfTHSLG/qzPskr786tes71Nc50+j4tlcB+LEL4U0+8KR2ohSYla2Kc
         jp6u85cN7FhdNCPo5Ou8qunPXNx/9Eakph52Wgi+Ogx5vj6X5fR/R17HRLtGH9mMK8cP
         PPBeLYiSnGui1ZGVaZrsnaPKo8h4uL9MZL0XOGy5mQu93PNEMEEvNRCYMiss+5eG809c
         urPQ==
X-Gm-Message-State: AOAM530oxC+PsQsse7VpFBOvRS12V7lZMpuc5yhEozRnfntuhRtvBFun
        ZjG7XwPD/gDzZcdmLaK7Zflg6/Zk7CWawF41Xq75TA==
X-Google-Smtp-Source: ABdhPJyPH1MEpxcXQlJbdJBRBkP9ThCEHiUxWntffEiOQeHb6NiMZUvRWykC9miCsBLizeK2Q+vVmPB6HEfXvgs4zYY=
X-Received: by 2002:a67:f74a:: with SMTP id w10mr9939395vso.13.1631031306233;
 Tue, 07 Sep 2021 09:15:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210901211412.4171835-1-rananta@google.com> <20210901211412.4171835-13-rananta@google.com>
 <20210903110514.22x3txynin5hg46z@gator.home> <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
 <20210906063900.t6rbykpwyau5u32s@gator.home>
In-Reply-To: <20210906063900.t6rbykpwyau5u32s@gator.home>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 7 Sep 2021 09:14:54 -0700
Message-ID: <CAJHc60xEj3Xw9wcSbxCUXg0GE5+NTadQeO17f6hpa9VqQ1o5tg@mail.gmail.com>
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU migration
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 5, 2021 at 11:39 PM Andrew Jones <drjones@redhat.com> wrote:
>
> On Fri, Sep 03, 2021 at 01:53:27PM -0700, Raghavendra Rao Ananta wrote:
> > On Fri, Sep 3, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> > > > Since the timer stack (hardware and KVM) is per-CPU, there
> > > > are potential chances for races to occur when the scheduler
> > > > decides to migrate a vCPU thread to a different physical CPU.
> > > > Hence, include an option to stress-test this part as well by
> > > > forcing the vCPUs to migrate across physical CPUs in the
> > > > system at a particular rate.
> > > >
> > > > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > > > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > > > was discovered using arch_timer test with vCPU migrations and
> > > > can be easily reproduced.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
> > > >  1 file changed, 107 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > index 1383f33850e9..de246c7afab2 100644
> > > > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > @@ -14,6 +14,8 @@
> > > >   *
> > > >   * The test provides command-line options to configure the timer's
> > > >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > > > + * To stress-test the timer stack even more, an option to migrate the
> > > > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> > > >   *
> > > >   * Copyright (c) 2021, Google LLC.
> > > >   */
> > > > @@ -24,6 +26,8 @@
> > > >  #include <pthread.h>
> > > >  #include <linux/kvm.h>
> > > >  #include <linux/sizes.h>
> > > > +#include <linux/bitmap.h>
> > > > +#include <sys/sysinfo.h>
> > > >
> > > >  #include "kvm_util.h"
> > > >  #include "processor.h"
> > > > @@ -41,12 +45,14 @@ struct test_args {
> > > >       int nr_vcpus;
> > > >       int nr_iter;
> > > >       int timer_period_ms;
> > > > +     int migration_freq_ms;
> > > >  };
> > > >
> > > >  static struct test_args test_args = {
> > > >       .nr_vcpus = NR_VCPUS_DEF,
> > > >       .nr_iter = NR_TEST_ITERS_DEF,
> > > >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > > > +     .migration_freq_ms = 0,         /* Turn off migrations by default */
> > >
> > > I'd rather we enable good tests like these by default.
> > >
> > Well, that was my original idea, but I was concerned about the ease
> > for diagnosing
> > things since it'll become too noisy. And so I let it as a personal
> > preference. But I can
> > include it back and see how it goes.
>
> Break the tests into two? One run without migration and one with. If
> neither work, then we can diagnose the one without first, possibly
> avoiding the need to diagnose the one with.
>
Right. I guess that's where the test's migration switch can come in handy.
Let's turn migration ON by default. If we see a failure, we can turn
OFF migration
and run the tests. I'll try to include some verbose printing for diagnosability.

Regards,
Raghavendra
> Thanks,
> drew
>
