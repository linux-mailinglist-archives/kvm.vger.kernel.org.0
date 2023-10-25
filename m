Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F607D6BED
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 14:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344059AbjJYMgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 08:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344015AbjJYMgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 08:36:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5834E129
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 05:36:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-53eeb28e8e5so9926a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 05:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698237361; x=1698842161; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGOk0CnKeZPsdii6KIyKL0bEMGOZJembVuo8Q1dzylc=;
        b=YBoQjRLw9+oHFDgYKkjzpB+K08IZRJAZ62luCZ2odV/Y8L9LLaQs/qMAi2CQFfzmMF
         9zZfzIBkhFKDI/Mev26IL+S0yohinfDqzvYPsqrY/jvpi4fhfoT1XMLb7IFmB6DZYVOm
         IolLVixIXL9YlT4JUpz/eQpl7MhysL/hVGf039lE9CyMaWU82KgIyncI81xR1n9PRAyd
         RFbR3XqggLk8haLusZpMZ36QgXHAZV+VSso0J2H7h/fGNfCaNcWfDIlxoVZ+3u8N4kKP
         BMO8h4Uo/l4d8IV6iF4GPj9YthZhQG+cWy7wLRverZ0mYB2lSe1qvjq8iGReWS1KNDuc
         SOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698237361; x=1698842161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGOk0CnKeZPsdii6KIyKL0bEMGOZJembVuo8Q1dzylc=;
        b=p4qq4e4dQSVYMg6Xx7yi1NBFHDY/hW2lQejm48AnTC8qW9i+elDjfeUsF/E3VBYL4P
         7lfubzGFrR0lvsY4xPaHe9MVxYci5tZ66CTj2jRWU8xt6EGr1QslHhq8tG/jA7ijp8BG
         0+g0xmeqzm6b/hsc2gn6chCzEMLV+RRJdT5LPKA2GrQz6eNjvwymVgKSduMPb5//7/yb
         bB5YwFQ36pr+RaHYTi8p108TiF850OreIVoL/UKgiO3Ae38YdQlHOIeIdJ6ENEJXgcqd
         G32Uw4aDkG4LgpbTsz1rKXUINslk2ZJ3Scktw6o7Ou8piK+reMwTAGCocqOrkNHCMubc
         ffhA==
X-Gm-Message-State: AOJu0YzR1BekkGPXhiXMm37PjIudSPxjKioXj8NSJpHVNNWwItKncDmB
        kwYty0xT45KrKsWwuwRMW43LrOv/XXv8bG5nqXIbbw==
X-Google-Smtp-Source: AGHT+IFEpfxrI8CLUEQxg5JfpcGaKukYdSHtSjSmABmdlig6tD0vaaHz20rghsrGGrvjeWn8s+35DKPxd+teg+FQvl4=
X-Received: by 2002:aa7:da95:0:b0:540:e46d:1ee8 with SMTP id
 q21-20020aa7da95000000b00540e46d1ee8mr80496eds.4.1698237360568; Wed, 25 Oct
 2023 05:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <20231024075748.1675382-3-dapeng1.mi@linux.intel.com> <CALMp9eRqGr+5+C1OLhxv1i8Q=YVRmFxkZQJoh7HzWkPg2z=WoA@mail.gmail.com>
 <6132ba52-fdf1-4680-9e4e-5ea2fcb63b3c@linux.intel.com>
In-Reply-To: <6132ba52-fdf1-4680-9e4e-5ea2fcb63b3c@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 25 Oct 2023 05:35:44 -0700
Message-ID: <CALMp9eSX6OL9=9sgnKpNgRtuTV93A=G=u-5qT1_rpKFjL-dBNw@mail.gmail.com>
Subject: Re: [kvm-unit-tests Patch 2/5] x86: pmu: Change the minimum value of
 llc_misses event to 0
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Mingwei Zhang <mizhang@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Wed, Oct 25, 2023 at 4:23=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 10/24/2023 9:03 PM, Jim Mattson wrote:
> > On Tue, Oct 24, 2023 at 12:51=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.in=
tel.com> wrote:
> >> Along with the CPU HW's upgrade and optimization, the count of LLC
> >> misses event for running loop() helper could be 0 just like seen on
> >> Sapphire Rapids.
> >>
> >> So modify the lower limit of possible count range for LLC misses
> >> events to 0 to avoid LLC misses event test failure on Sapphire Rapids.
> > I'm not convinced that these tests are really indicative of whether or
> > not the PMU is working properly. If 0 is allowed for llc misses, for
> > instance, doesn't this sub-test pass even when the PMU is disabled?
> >
> > Surely, we can do better.
>
>
> Considering the testing workload is just a simple adding loop, it's
> reasonable and possible that it gets a 0 result for LLC misses and
> branch misses events. Yeah, I agree the 0 count makes the results not so
> credible. If we want to avoid these 0 count values, we may have to
> complicate the workload, such as adding flush cache instructions, or
> something like that (I'm not sure if there are instructions which can
> force branch misses). How's your idea about this?

CLFLUSH is probably a good way to ensure cache misses. IBPB may be a
good way to ensure branch mispredictions, or IBRS on parts without
eIBRS.

>
> >
> >> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >> ---
> >>   x86/pmu.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/x86/pmu.c b/x86/pmu.c
> >> index 0def28695c70..7443fdab5c8a 100644
> >> --- a/x86/pmu.c
> >> +++ b/x86/pmu.c
> >> @@ -35,7 +35,7 @@ struct pmu_event {
> >>          {"instructions", 0x00c0, 10*N, 10.2*N},
> >>          {"ref cycles", 0x013c, 1*N, 30*N},
> >>          {"llc references", 0x4f2e, 1, 2*N},
> >> -       {"llc misses", 0x412e, 1, 1*N},
> >> +       {"llc misses", 0x412e, 0, 1*N},
> >>          {"branches", 0x00c4, 1*N, 1.1*N},
> >>          {"branch misses", 0x00c5, 0, 0.1*N},
> >>   }, amd_gp_events[] =3D {
> >> --
> >> 2.34.1
> >>
