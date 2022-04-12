Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742DD4FE759
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358559AbiDLRlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349976AbiDLRlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:41:21 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFE762CA9
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:38:58 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z33so34372422ybh.5
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gRILn8/chMRCIi9sZ2MN6M60EoQ3IuVF2SSZ6iBuX/4=;
        b=B1kF7caEIMPGUnmUr9fKJphP16RZw3rWxad4j4qeA/4bdejMVB2nA+CqyF/tqI5blK
         LJO3ZDY25SI2rekTuoakAo0VExQJczaj5ayEseFXoUPquJyrXakft6imh6RuRn2l4GuB
         1v3LgX2ZfxVsbdLp5wMXlPTlVKhKriVC1JbBde47oE8k5xllAAVQNCrERCgtFc96D7X0
         fsIV075yfhOVsYbav3bLTiYZs9EkeXZH6giBP/LfLhL/tDBXeoSztqQIXqq0KJJpdbmv
         OoAaMzTLTPjgsIiLAdaKgt0THWjGel+ILUv2KMGWJ5Mi9RELAC+HIkZvzlOZEZCKG/7p
         dwfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gRILn8/chMRCIi9sZ2MN6M60EoQ3IuVF2SSZ6iBuX/4=;
        b=7yQvR1JjIiaFn60ca8Mv6jx/IRHOXDZjOf0wHejpZVAU9+7nzjnYAM91t4cNjJC/6k
         gR87Dhe18Bv3Nj80+YMCyDyOhe0yys6mytpkL7oJMwgvdvGJQ8lVvxZiIXLWJf48wzU2
         ktB4mbYqrSeezd0nLgYVjzTxj2sBKS0YVviMWD7K8uFDj6R6rcZiZk4ykx0uFOUHQHkX
         Bq9ms1uMCXW3eMIpo2q+OP6RJFmAMQ5K8HWw1d0YAdhB/ZdkY9BuH8Rc1q8pTpcntNuT
         Y7jz8Kq20ry8bRDRHmUoKdwBe3dOrW3UJXVtH4BQDsuPMV4AahRgUPK3KGrbdF0MeYr6
         l3jw==
X-Gm-Message-State: AOAM5306ymeIJASGv2rr+vKTDSm2ZObq2fh5SnVcIKHy+PewfUXIW9Aa
        omVOxSGGEPDSq4pJX7bRj422s6v3kNeDugs/2o/u2A==
X-Google-Smtp-Source: ABdhPJxDgaDEv0hlkNQCrDHEoQGZuKbChfOahaDLonkq8HdnQqvVbFIeoxQk5XW6nkU5RvtGPsgKzWUSpWay/G4F/Pk=
X-Received: by 2002:a25:df97:0:b0:641:af46:4b8b with SMTP id
 w145-20020a25df97000000b00641af464b8bmr2305874ybg.189.1649785137599; Tue, 12
 Apr 2022 10:38:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220225013929.3577699-1-seanjc@google.com> <609de7ff-92e2-f96e-e6f5-127251f6e16d@redhat.com>
In-Reply-To: <609de7ff-92e2-f96e-e6f5-127251f6e16d@redhat.com>
From:   Anton Romanov <romanton@google.com>
Date:   Tue, 12 Apr 2022 10:38:47 -0700
Message-ID: <CAHFSQMj-Q08Fu1tdPuz+kcdvAoh2cuc_ZgH=qijSet55fxHLNw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Don't snapshot "max" TSC if host TSC is constant
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 25, 2022 at 4:10 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 2/25/22 02:39, Sean Christopherson wrote:
> > Don't snapshot tsc_khz into max_tsc_khz during KVM initialization if the
> > host TSC is constant, in which case the actual TSC frequency will never
> > change and thus capturing the "max" TSC during initialization is
> > unnecessary, KVM can simply use tsc_khz during VM creation.
> >
> > On CPUs with constant TSC, but not a hardware-specified TSC frequency,
> > snapshotting max_tsc_khz and using that to set a VM's default TSC
> > frequency can lead to KVM thinking it needs to manually scale the guest's
> > TSC if refining the TSC completes after KVM snapshots tsc_khz.  The
> > actual frequency never changes, only the kernel's calculation of what
> > that frequency is changes.  On systems without hardware TSC scaling, this
> > either puts KVM into "always catchup" mode (extremely inefficient), or
> > prevents creating VMs altogether.
> >
> > Ideally, KVM would not be able to race with TSC refinement, or would have
> > a hook into tsc_refine_calibration_work() to get an alert when refinement
> > is complete.  Avoiding the race altogether isn't practical as refinement
> > takes a relative eternity; it's deliberately put on a work queue outside
> > of the normal boot sequence to avoid unnecessarily delaying boot.
> >
> > Adding a hook is doable, but somewhat gross due to KVM's ability to be
> > built as a module.  And if the TSC is constant, which is likely the case
> > for every VMX/SVM-capable CPU produced in the last decade, the race can
> > be hit if and only if userspace is able to create a VM before TSC
> > refinement completes; refinement is slow, but not that slow.
> >
> > For now, punt on a proper fix, as not taking a snapshot can help some
> > uses cases and not taking a snapshot is arguably correct irrespective of
> > the race with refinement.
> >
> > Cc: Suleiman Souhlal <suleiman@google.com>
> > Cc: Anton Romanov <romanton@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
>
> Queued, but I'd rather have a subject that calls out that max_tsc_khz
> needs a replacement at vCPU creation time.  In fact, the real change
> (and bug, and fix) is in kvm_arch_vcpu_create(), while the subject
> mentions only the change in kvm_timer_init().
>
> What do you think of "KVM: x86: Use current rather than max TSC
> frequency if it is constant"?
>
> Pao

Ping. This said "queued" but I don't think this ever landed.
What's the status of this?
Paolo, does this need more work?
