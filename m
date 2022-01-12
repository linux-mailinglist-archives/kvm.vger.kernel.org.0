Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FF148C9F9
	for <lists+kvm@lfdr.de>; Wed, 12 Jan 2022 18:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243962AbiALRkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jan 2022 12:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbiALRki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jan 2022 12:40:38 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC147C061751
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:40:37 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id l15so6206593uai.11
        for <kvm@vger.kernel.org>; Wed, 12 Jan 2022 09:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dhM+RzO3xwFuopgokIVID6/QrF7tTW5/nX5Pew1Lc9Q=;
        b=SyYG7uLNTiZjxR2Z3l5y/XfsC4VwQmx/UbAni3zFA3TB6pm/1c6YxrYZDtGXRXOue3
         vp85vFta7lXTLdNX3DwyJzg/Galc+7SpOPngJOvXjApn+XU9otKCpQwKrhrq8lfTuH7S
         jLUzDBOP/aRViiStBjGc8A9bsYPSFxLUkwij+iHPmrA5hHMUf1ZOmm77v7LlVwYYqzai
         tmejXr0Z4PQgq1eSBhkvniR4NaOUk85CrQWQDZisE0bMXFJbHXuZ1jMe7w4elzyFiWlS
         fw4GLWFeuImOaNMtjVUdla30ieN/R+c+CbK2ZFuVZR6bWmTUI6BvzsfpryFoeF6KTuhu
         QMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dhM+RzO3xwFuopgokIVID6/QrF7tTW5/nX5Pew1Lc9Q=;
        b=ovXKawmUd7tC10eMLHZazL8k9iCJH2GiYAA1N7SYmVoDeAXAPpnctCrFIWADMIn/en
         rpXbtu8mk3ZlsvhXSbZIT4797eWdoN7/xsTSqHJwYJlAO0kVJTx9gcoO9TYx2Z8MfuJh
         Qrp76vDqmXMiOBeesdBa66qZlngw4DRerZ49SHoZY4FwI1QRGJv0Fh2O9mhulFvWVl88
         Pftc2f1j145lreSw0OllnNTh0wRZyJfYoGryHyZ1owmWJD7gVyEF3fAd2W6n9wb/Fgz7
         NcOiV2tXmbQ2URKA6gOgoVcw+JWk4zFncgerOv7lC2zVoHLsMXsaogXv0gCH5Jjo5DLN
         yabg==
X-Gm-Message-State: AOAM533yLee+IF53OSVOvS9KaRQAPaJBHozMYSFCMQy+x4TtjaCHgb5h
        WakVZUs0KhMfkHaAxBGV7ZkqsAO7/SAyJeFwbebcsA==
X-Google-Smtp-Source: ABdhPJwznL0hfPfcEMsiGVpmV5gcIpAD+uBmDTfAurrv7pJYzgxnie/RNnSPOLQWD3kNNt+AL8yF8iQh0VtaIh070hU=
X-Received: by 2002:ab0:13c3:: with SMTP id n3mr499265uae.39.1642009236785;
 Wed, 12 Jan 2022 09:40:36 -0800 (PST)
MIME-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
 <20220110210441.2074798-4-jingzhangos@google.com> <87a6g2tvia.wl-maz@kernel.org>
 <CAAdAUthmAMy3UE3_C_CitW9MWWMGcOPHu0x9aV72YEUL2kpO=g@mail.gmail.com> <87sfttrxqv.wl-maz@kernel.org>
In-Reply-To: <87sfttrxqv.wl-maz@kernel.org>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 12 Jan 2022 09:40:25 -0800
Message-ID: <CAAdAUthNCgihBVoJS1BFCzT=nxc6i7ceC_SDhUdKajhvXu3v9g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] KVM: selftests: Add vgic initialization for dirty
 log perf test for ARM
To:     Marc Zyngier <maz@kernel.org>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022 at 3:37 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 11 Jan 2022 22:16:01 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > On Tue, Jan 11, 2022 at 2:30 AM Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Mon, 10 Jan 2022 21:04:41 +0000,
> > > Jing Zhang <jingzhangos@google.com> wrote:
> > > >
> > > > For ARM64, if no vgic is setup before the dirty log perf test, the
> > > > userspace irqchip would be used, which would affect the dirty log perf
> > > > test result.
> > >
> > > Doesn't it affect *all* performance tests? How much does this change
> > > contributes to the performance numbers you give in the cover letter?
> > >
> > This bottleneck showed up after adding the fast path patch. I didn't
> > try other performance tests with this, but I think it is a good idea
> > to add a vgic setup for all performance tests. I can post another
> > patch later to make it available for all performance tests after
> > finishing this one and verifying all other performance tests.
> > Below is the test result without adding the vgic setup. It shows
> > 20~30% improvement for the different number of vCPUs.
> > +-------+------------------------+
> >     | #vCPU | dirty memory time (ms) |
> >     +-------+------------------------+
> >     | 1     | 965                    |
> >     +-------+------------------------+
> >     | 2     | 1006                    |
> >     +-------+------------------------+
> >     | 4     | 1128                    |
> >     +-------+------------------------+
> >     | 8     | 2005                   |
> >     +-------+------------------------+
> >     | 16    | 3903                   |
> >     +-------+------------------------+
> >     | 32    | 7595                   |
> >     +-------+------------------------+
> >     | 64    | 15783                  |
> >     +-------+------------------------+
>
> So please use these numbers in your cover letter when you repost your
> series, as the improvement you'd observe on actual workloads is likely
> to be less than what you claim due to this change in the test itself
> (in other words, if you are going to benchamark something, don't
> change the benchmark halfway).
Sure. Will clarify this in the cover letter in future posts.
Thanks,
Jing
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
