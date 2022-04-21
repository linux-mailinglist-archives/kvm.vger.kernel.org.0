Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0037650A60D
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 18:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiDUQqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbiDUQqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 12:46:33 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6066A48E5F
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:43:41 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id q22so6448690ljh.10
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=86+E8N74tWcxl4OkHzKdfe2B+ol1qinsJ3i5kq4weyE=;
        b=a1dstvI3nz0xC9V2iEbO4mMe5jZ2oRMNhgkxJcw7TvRja8cD2HOxZiYNWufSrt9SGA
         QMh1V1vX1vRzQM5hZeAL1YURCc4bs8xoKqg3iyPeLYstklgJn3sGsxN0PS8qNyBuq5Cb
         fCV3rKD/e102wY82J1HLSHc3kz9Kn0RPPwPpo0xm+4077aTtzBTvmcNAOWXaLAqppWAt
         g8+UA8J0ej52+TXcdv6W0UUI7ypJOBzI66Dh5xFKYXYogABeN82excKo3y1XoMJCsxWK
         2Lho041K3nj1gXeUggyWCnxx1ugQDE7Z4iTBHt+fWGKdfCpRmZ7vSqZADl5Fj+vGYvl8
         oGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=86+E8N74tWcxl4OkHzKdfe2B+ol1qinsJ3i5kq4weyE=;
        b=lwfybWrDI9QTqWObbXi+8mwMwwGHF4NVu/LRQCj696z4EOprfma1194WjH/7rzSScU
         hrBbjoEhyxSu0MvbaELp06vEjYXxRam8BSJmb9PBr2Q/Aum4jh1ldsREVqWwxiX9XfKo
         LVVoY5+CiE1s5iKoccEFEV4DMXpFY5K2gwGMMvKwS5/3SYQW/ptVIr+Ybf3cH2XyQcAH
         uwK/AQ0CWx/D8QXLqiYSydVZV6TcF5IjNdxeEpXPmFxLoPUqYSp2SV8pyEFIRIcm9tqx
         nmzKvezU5jCDlB35UnnNlLzPBQUIg9nkGJw/h3ihmDTprXPQL8r8Z6XB/Ei+m1Bvsmq7
         lN0Q==
X-Gm-Message-State: AOAM532Ywtd3+TTQC70K5gJwBQsO3xK0WThxsUj2+zD9Hs/2x1AzsdYm
        Cgwg1vUn/prdE3hh4mnYJwMWF2w07OtCn6BTB+yi8g==
X-Google-Smtp-Source: ABdhPJxme7++mtYHiLB8A8sMAhxUEQ/TToGRr6G0ay3IKZ1/RbT2BsFMkUyKGRXbo7cKuJBLBODJSoFzCpUT4nR3vZE=
X-Received: by 2002:a05:651c:b0d:b0:24d:a008:46f1 with SMTP id
 b13-20020a05651c0b0d00b0024da00846f1mr334936ljr.198.1650559419407; Thu, 21
 Apr 2022 09:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com> <CALzav=c6jQ53G-2gEZYasH_b4_hLYtNAD5pW1TXSfPWxLf3_qw@mail.gmail.com>
 <YloIEfCjWyQKJMxI@google.com>
In-Reply-To: <YloIEfCjWyQKJMxI@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 21 Apr 2022 09:43:12 -0700
Message-ID: <CALzav=fk1obOQcYvguvcLww+q4yu5JLEvJkfKZt50dD9iScGKA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/17] KVM: arm64: Parallelize stage 2 fault handling
To:     Oliver Upton <oupton@google.com>
Cc:     KVMARM <kvmarm@lists.cs.columbia.edu>,
        kvm list <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 15, 2022 at 5:04 PM Oliver Upton <oupton@google.com> wrote:
>
> On Fri, Apr 15, 2022 at 04:35:24PM -0700, David Matlack wrote:
> > On Fri, Apr 15, 2022 at 2:59 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > Presently KVM only takes a read lock for stage 2 faults if it believes
> > > the fault can be fixed by relaxing permissions on a PTE (write unprotect
> > > for dirty logging). Otherwise, stage 2 faults grab the write lock, which
> > > predictably can pile up all the vCPUs in a sufficiently large VM.
> > >
> > > The x86 port of KVM has what it calls the TDP MMU. Basically, it is an
> > > MMU protected by the combination of a read-write lock and RCU, allowing
> > > page walkers to traverse in parallel.
> > >
> > > This series is strongly inspired by the mechanics of the TDP MMU,
> > > making use of RCU to protect parallel walks. Note that the TLB
> > > invalidation mechanics are a bit different between x86 and ARM, so we
> > > need to use the 'break-before-make' sequence to split/collapse a
> > > block/table mapping, respectively.
> >
> > An alternative (or perhaps "v2" [1]) is to make x86's TDP MMU
> > arch-neutral and port it to support ARM's stage-2 MMU. This is based
> > on a few observations:
> >
> > - The problems that motivated the development of the TDP MMU are not
> > x86-specific (e.g. parallelizing faults during the post-copy phase of
> > Live Migration).
> > - The synchronization in the TDP MMU (read/write lock, RCU for PT
> > freeing, atomic compare-exchanges for modifying PTEs) is complex, but
> > would be equivalent across architectures.
> > - Eventually RISC-V is going to want similar performance (my
> > understanding is RISC-V MMU is already a copy-paste of the ARM MMU),
> > and it'd be a shame to re-implement TDP MMU synchronization a third
> > time.
> > - The TDP MMU includes support for various performance features that
> > would benefit other architectures, such as eager page splitting,
> > deferred zapping, lockless write-protection resolution, and (coming
> > soon) in-place huge page promotion.
> > - And then there's the obvious wins from less code duplication in KVM
> > (e.g. get rid of the RISC-V MMU copy, increased code test coverage,
> > ...).
>
> I definitely agree with the observation -- we're all trying to solve the
> same set of issues. And I completely agree that a good long term goal
> would be to create some common parts for all architectures. Less work
> for us ARM folks it would seem ;-)
>
> What's top of mind is how we paper over the architectural differences
> between all of the architectures, especially when we need to do entirely
> different things because of the arch.
>
> For example, I whine about break-before-make a lot throughout this
> series which is somewhat unique to ARM. I don't think we can do eager
> page splitting on the base architecture w/o doing the TLBI for every
> block. Not only that, we can't do a direct valid->valid change without
> first making an invalid PTE visible to hardware. Things get even more
> exciting when hardware revisions relax break-before-make requirements.

Gotcha, so porting the TDP MMU to ARM would require adding
break-before-make support. That seems feasible and we could guard it
behind a e.g. static_key so there is no runtime overhead for
architectures (or ARM hardware revisions) that do not require it.
Anything else come to mind as major architectural differences?

 >
> There's also significant architectural differences between KVM on x86
> and KVM for ARM. Our paging code runs both in the host kernel and the
> hyp/lowvisor, and does:
>
>  - VM two dimensional paging (stage 2 MMU)
>  - Hyp's own MMU (stage 1 MMU)
>  - Host kernel isolation (stage 2 MMU)
>
> each with its own quirks. The 'not exactly in the kernel' part will make
> instrumentation a bit of a hassle too.

Ah, interesting. It'd probably make sense to start with the VM
2-dimensional paging use-case and leave the other use-cases using the
existing MMU, and then investigate transitioning the other use-cases.
Similarly in x86 we still have the legacy MMU for shadow paging (e.g.
hosts with no stage-2 hardware, and nested virtualization).

>
> None of this is meant to disagree with you in the slightest. I firmly
> agree we need to share as many parts between the architectures as
> possible. I'm just trying to call out a few of the things relating to
> ARM that will make this annoying so that way whoever embarks on the
> adventure will see it.
>
> > The side of this I haven't really looked into yet is ARM's stage-2
> > MMU, and how amenable it would be to being managed by the TDP MMU. But
> > I assume it's a conventional page table structure mapping GPAs to
> > HPAs, which is the most important overlap.
> >
> > That all being said, an arch-neutral TDP MMU would be a larger, more
> > complex code change than something like this series (hence my "v2"
> > caveat above). But I wanted to get this idea out there since the
> > rubber is starting to hit the road on improving ARM MMU scalability.
>
> All for it. I cc'ed you on the series for this exact reason, I wanted to
> grab your attention to spark the conversation :)
>
> --
> Thanks,
> Oliver
