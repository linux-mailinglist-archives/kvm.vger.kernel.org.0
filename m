Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30031658695
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 21:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbiL1UAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 15:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiL1UAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 15:00:52 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795B3FD3
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 12:00:51 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id i83so8734722ioa.11
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 12:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hh0jLv1v3mifCsnyvA1wHVm6IV5XJrWV+I9Jl/9s0fg=;
        b=f3smJMV9RbN9mhJO0VUeTINIduhc6je53ZXXppQin5xotzeR2NYHTAyPbTX16Zkiqn
         UVkDPDj97nXPxbXYpAu3B+HZaVZyYHMRyePY3tmZpEOsOMdaagbRTaEPFXAUKAXO/cG1
         g5PsleK/1DyYRSt8CTzJfs+UWP1V7BSjlbHfJOjuJo7Gndvb9Z+62sOl52a1c1tvDAAh
         8OjHeBfx8H1t9mta/U4ac8t+QkfMFAXnCZT+KZLx4JSWaott29XR59HdtFmREQ+RJoy8
         KQvtz2Gq99UbQVob/RiaxxlI2PyTyU60GtYjcDGbRwSvr99eGYw6xAYNjbkvHCybZkMk
         7Jjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hh0jLv1v3mifCsnyvA1wHVm6IV5XJrWV+I9Jl/9s0fg=;
        b=n+IgmMDbUGhPzJlCDO+4it6ZtYxUamVQJJianDDHkbdeoaZi1L3DSoKQhIooyoUQ2T
         F8lo/w2e5W5URXpBEvcMgCktuksM9cYn5cVJKJOF13STxlku/vYrux5h7INK6baS5fen
         Szji5qdKkCQzDkluYV5GUbiFbbNl9IrZo5O5VpBTawhncR18P2k3bQFGBujqG8GFgtYo
         jixKaT4pKxaX8H7Nw63LUFlrVa0TbI+9W+SRprnS2lzWc43vY5oNXnpLH1+y0dbsSxDB
         IkWydKsrtixf9WkHDye8VlzUdVqn/YB0FtENYR4Ep8/SRURn34ZAUvr/aRYkMU4jA7d0
         /dOA==
X-Gm-Message-State: AFqh2kpyOCCQReVY2gQnACqI5DN0F5hSFHp45FaaGFurFAmrMOZlg8bZ
        kKJuHXPhV1DtIcmNFOU/SEy+X6POMhAUnf+2Pdgfog==
X-Google-Smtp-Source: AMrXdXuXi27PPvPXUUNIso98/T7lSvVLH5087tzV1Yelr5s8dhTkYJJTN9mgKWc4MWTZC8jtYMXE2FJB/pyFwFr8s18=
X-Received: by 2002:a02:b784:0:b0:38a:7a:26e8 with SMTP id f4-20020a02b784000000b0038a007a26e8mr1827222jam.168.1672257650654;
 Wed, 28 Dec 2022 12:00:50 -0800 (PST)
MIME-Version: 1.0
References: <20221220161236.555143-1-aaronlewis@google.com>
 <20221220161236.555143-2-aaronlewis@google.com> <37064a64-47cb-aaad-4b8e-6ce2bdf68e56@gmail.com>
In-Reply-To: <37064a64-47cb-aaad-4b8e-6ce2bdf68e56@gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Wed, 28 Dec 2022 20:00:39 +0000
Message-ID: <CAAAPnDE2HjrDbgzJgj7G6=5NQ11BJ=x4wmEStJkoPPCyWQmK_w@mail.gmail.com>
Subject: Re: [PATCH v8 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kvm list <kvm@vger.kernel.org>
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

> > diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> > index 85ff3c0588ba..5b070c563a97 100644
> > --- a/arch/x86/kvm/pmu.h
> > +++ b/arch/x86/kvm/pmu.h
> > @@ -40,6 +40,8 @@ struct kvm_pmu_ops {
> >       void (*reset)(struct kvm_vcpu *vcpu);
> >       void (*deliver_pmi)(struct kvm_vcpu *vcpu);
> >       void (*cleanup)(struct kvm_vcpu *vcpu);
> > +
> > +     const u64 EVENTSEL_EVENT;
>
> Isn't it weird when the new thing added here is
> not of the same type as the existing members ?
>
> Doesn't "pmu->raw_event_mask" help here ?
>

In earlier revisions I had this as a callback, but it was a little
awkward being that I really just wanted it to be a const that differed
depending on platform.  Making it a const fit more naturally when
using it than the callback approach, so despite it being different
from the others here I think it works better overall.

> >   };
> >
> >   void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
> > diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> > index 0e313fbae055..d3ae261d56a6 100644
> > --- a/arch/x86/kvm/svm/pmu.c
> > +++ b/arch/x86/kvm/svm/pmu.c
> > @@ -229,4 +229,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
> >       .refresh = amd_pmu_refresh,
> >       .init = amd_pmu_init,
> >       .reset = amd_pmu_reset,
> > +     .EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
> >   };
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > index e5cec07ca8d9..edf23115f2ef 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -810,4 +810,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
> >       .reset = intel_pmu_reset,
> >       .deliver_pmi = intel_pmu_deliver_pmi,
> >       .cleanup = intel_pmu_cleanup,
> > +     .EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
> >   };
