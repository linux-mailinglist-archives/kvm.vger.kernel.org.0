Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A097340167F
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 08:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbhIFGkP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 02:40:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239629AbhIFGkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 02:40:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630910345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pFZpAGoXWqtD1eNY9zjgxvjbpkWIm9fS1Q1YaYaJFgM=;
        b=OBZ1bQilztxl4te6PG57UvNVqo6kIW1jESOeTAr3soI9DA5bjMl7K54uPJ1ANHaF0Q4AN2
        ePo8CZvny2AhHhlB5I0t/BS4GGYx9xlFU43dzJrVWEdaUAr7fD3eTC2QBciMkNrK3yl4yP
        vXPrkFT1VrEzLq3qSsJ2el/OrVm4xyk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-H4EsMekjOwa6sXJ-6s-x6w-1; Mon, 06 Sep 2021 02:39:03 -0400
X-MC-Unique: H4EsMekjOwa6sXJ-6s-x6w-1
Received: by mail-ed1-f69.google.com with SMTP id y10-20020a056402270a00b003c8adc4d40cso3041770edd.15
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 23:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pFZpAGoXWqtD1eNY9zjgxvjbpkWIm9fS1Q1YaYaJFgM=;
        b=E1nbdqp92PhJFBoBbpaAlcSo6MOZNJrPOrY95x9pD0lH+A2cAa0JhaigjvN47GXBG8
         9o/U50Ga6MWrw9LAaIjdnUV/Tw2sJHw05JE8HSJTUlkwQtEL01V0hLpnZ7cAST/VvRMK
         1Nk3gnxOYEq6EydY3negqepyX73chMLAZYSjsNMotF1Dmt2wzjm/lmWb4cw4nLuiga3i
         kkyVtVsfVLfteabwj7WQnovtPH9DQt9SiozzU2gpRrCTPLN76BfqfduryoUAEWDuEhq8
         bci7YfSEUY4t/ZbKiSDeofr7x6wnRKuZ1APUIuz9KwwyoK2vOYGQmxVcoHaFcVFkBs8N
         VRKw==
X-Gm-Message-State: AOAM533ezyApJGuFy3XBlnm3CeQrg2gwdK5ASY6UFxInsiS8jHxrCTET
        UpNMrd/294gZ5lgd3BysYr4rbjynv/f7lJodk23WNwkTXfM5Mam5oDsrMdy5UJuM83LEnb3kG1s
        eCyKd+w2M4L04
X-Received: by 2002:a05:6402:4404:: with SMTP id y4mr11919675eda.52.1630910342563;
        Sun, 05 Sep 2021 23:39:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyX0TpXnbRYGfoD24m32rvU84qJrmQaW7wiPn31Nr/Q9F8DbdaCT6Gpt6cuVdJvK5mJP25OsQ==
X-Received: by 2002:a05:6402:4404:: with SMTP id y4mr11919656eda.52.1630910342402;
        Sun, 05 Sep 2021 23:39:02 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id i13sm3885374edc.48.2021.09.05.23.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 23:39:02 -0700 (PDT)
Date:   Mon, 6 Sep 2021 08:39:00 +0200
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
Message-ID: <20210906063900.t6rbykpwyau5u32s@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-13-rananta@google.com>
 <20210903110514.22x3txynin5hg46z@gator.home>
 <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60xf90-0E8vkge=UC0Mq3Wz3g=n1OuHa2Lchw4G6egJEig@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 01:53:27PM -0700, Raghavendra Rao Ananta wrote:
> On Fri, Sep 3, 2021 at 4:05 AM Andrew Jones <drjones@redhat.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 09:14:12PM +0000, Raghavendra Rao Ananta wrote:
> > > Since the timer stack (hardware and KVM) is per-CPU, there
> > > are potential chances for races to occur when the scheduler
> > > decides to migrate a vCPU thread to a different physical CPU.
> > > Hence, include an option to stress-test this part as well by
> > > forcing the vCPUs to migrate across physical CPUs in the
> > > system at a particular rate.
> > >
> > > Originally, the bug for the fix with commit 3134cc8beb69d0d
> > > ("KVM: arm64: vgic: Resample HW pending state on deactivation")
> > > was discovered using arch_timer test with vCPU migrations and
> > > can be easily reproduced.
> > >
> > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > ---
> > >  .../selftests/kvm/aarch64/arch_timer.c        | 108 +++++++++++++++++-
> > >  1 file changed, 107 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > index 1383f33850e9..de246c7afab2 100644
> > > --- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > +++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
> > > @@ -14,6 +14,8 @@
> > >   *
> > >   * The test provides command-line options to configure the timer's
> > >   * period (-p), number of vCPUs (-n), and iterations per stage (-i).
> > > + * To stress-test the timer stack even more, an option to migrate the
> > > + * vCPUs across pCPUs (-m), at a particular rate, is also provided.
> > >   *
> > >   * Copyright (c) 2021, Google LLC.
> > >   */
> > > @@ -24,6 +26,8 @@
> > >  #include <pthread.h>
> > >  #include <linux/kvm.h>
> > >  #include <linux/sizes.h>
> > > +#include <linux/bitmap.h>
> > > +#include <sys/sysinfo.h>
> > >
> > >  #include "kvm_util.h"
> > >  #include "processor.h"
> > > @@ -41,12 +45,14 @@ struct test_args {
> > >       int nr_vcpus;
> > >       int nr_iter;
> > >       int timer_period_ms;
> > > +     int migration_freq_ms;
> > >  };
> > >
> > >  static struct test_args test_args = {
> > >       .nr_vcpus = NR_VCPUS_DEF,
> > >       .nr_iter = NR_TEST_ITERS_DEF,
> > >       .timer_period_ms = TIMER_TEST_PERIOD_MS_DEF,
> > > +     .migration_freq_ms = 0,         /* Turn off migrations by default */
> >
> > I'd rather we enable good tests like these by default.
> >
> Well, that was my original idea, but I was concerned about the ease
> for diagnosing
> things since it'll become too noisy. And so I let it as a personal
> preference. But I can
> include it back and see how it goes.

Break the tests into two? One run without migration and one with. If
neither work, then we can diagnose the one without first, possibly
avoiding the need to diagnose the one with.

Thanks,
drew

