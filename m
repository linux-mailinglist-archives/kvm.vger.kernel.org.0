Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A961402CC2
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhIGQV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:21:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230091AbhIGQV2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Sep 2021 12:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631031621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s5kpwoL6JLP9VWq157hj4yt5pn95OzlSkFYcjxu+uM8=;
        b=A//GbMzVInx3sIjulM8vMA2hwvrRkGYJHTASDkQ2/e56WCkn6o1BuF9szfdJ2r4jigSVSc
        wBA48ke7CgXgXcBx6OKsrk26TkUfeb/89wag7B6Ls9sgoBhrSOM0noizfDUHs3UItTJwVd
        4EBtaP5KQ7o9ZSGfdDuYN5UsED45+QM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-8zLwx0vjNfuTCtmrdREaHg-1; Tue, 07 Sep 2021 12:20:20 -0400
X-MC-Unique: 8zLwx0vjNfuTCtmrdREaHg-1
Received: by mail-ej1-f70.google.com with SMTP id bi9-20020a170906a24900b005c74b30ff24so3934746ejb.5
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 09:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s5kpwoL6JLP9VWq157hj4yt5pn95OzlSkFYcjxu+uM8=;
        b=HCZHpW/LesYhc9qIfU/33ofRFWvUbe3suKQxiY6SdhX8SEl/aWV9sy8/sRNNisluQo
         gL15ZLC4RY//Z6OKkf+mhW1IcW+uN0p5p82x/lN8aSindWI/RSjW19cSzjatFQi8xtqm
         xhaGiR4kbOhrqT7uTFQe3bsqgk5xHsg07eSsFPQd2tmx5MsQSCTMwGpi2VBQ/MBCugnF
         YSHYG08hR9Q3lwjMTx11vz9HZ0v0ylhbTR+kWpRVFrrRmfU7caQbo4qQrCNpMq1LlsLb
         HLrOlEWOFz9f3opyrJX1I47U21RpKCV/xFTqVnHVJ5oQ/7XAdHtPmGPigJH0946ov+Ql
         wA4Q==
X-Gm-Message-State: AOAM532KGQVewNVNA31jW+KoJQ9Cuf7/lYEw4J/tgief5MEvc3QmGK1U
        KoY+MHPG/17DS1eIPAE8VjgrMPR0Wqbmt0PmtgTQuZWwd2izpvJ0MYQRILW0wx0a78lm/xRMpBz
        Vb6FLtsmRALap
X-Received: by 2002:aa7:d351:: with SMTP id m17mr307623edr.72.1631031618937;
        Tue, 07 Sep 2021 09:20:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlG1x6vmubv9Q2F6F+Q/kXpwV0kbe4co0LWgBBS7NPE4nU1F3mfGZ5885MxN5txLMEejY+/w==
X-Received: by 2002:aa7:d351:: with SMTP id m17mr307607edr.72.1631031618753;
        Tue, 07 Sep 2021 09:20:18 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id a24sm6571101edu.49.2021.09.07.09.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 09:20:18 -0700 (PDT)
Date:   Tue, 7 Sep 2021 18:20:16 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 12/12] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
Message-ID: <20210907162016.2axil4gjjvkafnkx@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
 <20210903110514.22x3txynin5hg46z@gator.home>
 <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
 <20210906063900.t6rbykpwyau5u32s@gator.home>
 <CAJHc60xEj3Xw9wcSbxCUXg0GE5+NTadQeO17f6hpa9VqQ1o5tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60xEj3Xw9wcSbxCUXg0GE5+NTadQeO17f6hpa9VqQ1o5tg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 07, 2021 at 09:14:54AM -0700, Raghavendra Rao Ananta wrote:
> On Sun, Sep 5, 2021 at 11:39 PM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Fri, Sep 03, 2021 at 01:53:27PM -0700, Raghavendra Rao Ananta wrote:
> > > On Fri, Sep 3, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> > > >
> > > > On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> > > > > Since the timer stack (hardware and KVM) is per-CPU, there
> > > > > are potential chances for races to occur when the scheduler
> > > > > decides to migrate a vCPU thread to a different physical CPU.
> > > > > Hence, include an option to stress-test this part as well by
> > > > > forcing the vCPUs to migrate across physical CPUs in the
> > > > > system at a particular rate.
> > > > >
> > > > > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > > > > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > > > > was discovered using arch_timer test with vCPU migrations and
> > > > > can be easily reproduced.
> > > > >
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > > ---
> > > > >  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
> > > > >  1 file changed, 107 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > > index 1383f33850e9..de246c7afab2 100644
> > > > > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > > > @@ -14,6 +14,8 @@
> > > > >   *
> > > > >   * The test provides command-line options to configure the timer's
> > > > >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > > > > + * To stress-test the timer stack even more, an option to migrate the
> > > > > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> > > > >   *
> > > > >   * Copyright (c) 2021, Google LLC.
> > > > >   */
> > > > > @@ -24,6 +26,8 @@
> > > > >  #include <pthread.h>
> > > > >  #include <linux/kvm.h>
> > > > >  #include <linux/sizes.h>
> > > > > +#include <linux/bitmap.h>
> > > > > +#include <sys/sysinfo.h>
> > > > >
> > > > >  #include "kvm_util.h"
> > > > >  #include "processor.h"
> > > > > @@ -41,12 +45,14 @@ struct test_args {
> > > > >       int nr_vcpus;
> > > > >       int nr_iter;
> > > > >       int timer_period_ms;
> > > > > +     int migration_freq_ms;
> > > > >  };
> > > > >
> > > > >  static struct test_args test_args = {
> > > > >       .nr_vcpus = NR_VCPUS_DEF,
> > > > >       .nr_iter = NR_TEST_ITERS_DEF,
> > > > >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > > > > +     .migration_freq_ms = 0,         /* Turn off migrations by default */
> > > >
> > > > I'd rather we enable good tests like these by default.
> > > >
> > > Well, that was my original idea, but I was concerned about the ease
> > > for diagnosing
> > > things since it'll become too noisy. And so I let it as a personal
> > > preference. But I can
> > > include it back and see how it goes.
> >
> > Break the tests into two? One run without migration and one with. If
> > neither work, then we can diagnose the one without first, possibly
> > avoiding the need to diagnose the one with.
> >
> Right. I guess that's where the test's migration switch can come in handy.
> Let's turn migration ON by default. If we see a failure, we can turn
> OFF migration
> and run the tests. I'll try to include some verbose printing for diagnosability.
>

Sounds good. You can also consider using pr_debug if you feel the need to
balance verbosity with diagnostics.

Thanks,
drew

