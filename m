Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C67D8275
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 14:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjJZMTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 08:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbjJZMTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 08:19:22 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696221B8
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 05:19:16 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4078fe6a063so60075e9.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 05:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698322754; x=1698927554; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mn9vwEQwhu04QoIQoViUo1uyYhhZK+omIbWYXKZt2G0=;
        b=4vBAeB6+dWymdQ7lx+OaLwT/lkizkiOnU6+wLGKllSzf8B74PxqMH7t/8kcIe2oQ3d
         Hpo0opEQuZ9MvERHrpkQToDoS91/pbXozZcviJWfSVbiOgKu3vNY8O8pACF+Se3GB23V
         IXqXzDfs3aAdrl59UdgIhG4UC6elVK4HgMR8WpHRsvDaxhi3YltsoT7bbRlEIYYy4JMX
         kMKPtzi7wp+NIlgxRmDyAh0WX24nlcfb2398cSjF8at3UIXqvhupHKJQD6e5fMJAl8Md
         Z62zjmbADQLqY8BZEfC1shsWw7u8//+BAuHujn3yiiY3GmJmeyDDLDUqBHgwNf+X0e8g
         twvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698322754; x=1698927554;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mn9vwEQwhu04QoIQoViUo1uyYhhZK+omIbWYXKZt2G0=;
        b=rq/VadQ4E0XIlnjJD62fOx2DzykSsTu2QJlzK1b/4VVKfOA0bjejTo2iyoaoMfJZDK
         rpIgSi4j0wv69r1d4JNIXMD61WJPazGhAG2rH+OFyHqlveUoho6OpL9DFL9nkYDWiKOf
         wbbqHnCo9fQtBXO33uiJ6VvPD0dVDl137uaAru80AO+WYVvTvOX6IH2mrHAD90/9Unlg
         cMxc/78A/EgzLMN7yZuesAFmcwJ5nBNBxgKLhT72pPxkS3Urd5ywgMVxX6kscJRq7lLe
         1BkIaPoiUuW3ZJuEvK6ViUxJVa/kRuKR8jBpawbrsHok095TnO7vMxbTWC76tzfXP5cA
         6LvA==
X-Gm-Message-State: AOJu0YyNzG1vni57FXSYfe8oLz6BbG8cUXwmU+d37bPQiOIOzmVT9Mjd
        zxDmx/n9zva3YxRSgKzxhwnUNKEbLEQrafZEc+SOYSCfK4KIKr8hchnY1w==
X-Google-Smtp-Source: AGHT+IHFMPYOS4TQJcdWKAA3nE9+1HradjGomq6X4BQNrV+FIc9uYhsFJofMd+9S5E0v3J3FPDOYs7YXZRvjBChoa+I=
X-Received: by 2002:a05:600c:3c96:b0:404:74f8:f47c with SMTP id
 bg22-20020a05600c3c9600b0040474f8f47cmr225576wmb.5.1698322754434; Thu, 26 Oct
 2023 05:19:14 -0700 (PDT)
MIME-Version: 1.0
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
 <20231024075748.1675382-3-dapeng1.mi@linux.intel.com> <CALMp9eRqGr+5+C1OLhxv1i8Q=YVRmFxkZQJoh7HzWkPg2z=WoA@mail.gmail.com>
 <6132ba52-fdf1-4680-9e4e-5ea2fcb63b3c@linux.intel.com> <CALMp9eSX6OL9=9sgnKpNgRtuTV93A=G=u-5qT1_rpKFjL-dBNw@mail.gmail.com>
 <99684975-6317-4233-b87b-14ca731b335a@linux.intel.com>
In-Reply-To: <99684975-6317-4233-b87b-14ca731b335a@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 26 Oct 2023 05:19:01 -0700
Message-ID: <CALMp9eRdiyHQjiSRufKvBLHhXQ9LgTpNO8djETZ9tSYZR_FBFg@mail.gmail.com>
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
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 7:14=E2=80=AFPM Mi, Dapeng <dapeng1.mi@linux.intel.=
com> wrote:
>
>
> On 10/25/2023 8:35 PM, Jim Mattson wrote:
> > On Wed, Oct 25, 2023 at 4:23=E2=80=AFAM Mi, Dapeng <dapeng1.mi@linux.in=
tel.com> wrote:
> >>
> >> On 10/24/2023 9:03 PM, Jim Mattson wrote:
> >>> On Tue, Oct 24, 2023 at 12:51=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.=
intel.com> wrote:
> >>>> Along with the CPU HW's upgrade and optimization, the count of LLC
> >>>> misses event for running loop() helper could be 0 just like seen on
> >>>> Sapphire Rapids.
> >>>>
> >>>> So modify the lower limit of possible count range for LLC misses
> >>>> events to 0 to avoid LLC misses event test failure on Sapphire Rapid=
s.
> >>> I'm not convinced that these tests are really indicative of whether o=
r
> >>> not the PMU is working properly. If 0 is allowed for llc misses, for
> >>> instance, doesn't this sub-test pass even when the PMU is disabled?
> >>>
> >>> Surely, we can do better.
> >>
> >> Considering the testing workload is just a simple adding loop, it's
> >> reasonable and possible that it gets a 0 result for LLC misses and
> >> branch misses events. Yeah, I agree the 0 count makes the results not =
so
> >> credible. If we want to avoid these 0 count values, we may have to
> >> complicate the workload, such as adding flush cache instructions, or
> >> something like that (I'm not sure if there are instructions which can
> >> force branch misses). How's your idea about this?
> > CLFLUSH is probably a good way to ensure cache misses. IBPB may be a
> > good way to ensure branch mispredictions, or IBRS on parts without
> > eIBRS.
>
>
> Thanks Jim for the information. I'm not familiar with IBPB/IBRS
> instructions, but just a glance, it looks there two instructions are
> some kind of advanced instructions,  Not all Intel CPUs support these
> instructions and not sure if AMD has similar instructions. It would be
> better if there are more generic instruction to trigger branch miss.
> Anyway I would look at the details and come back again.

IBPB and IBRS are not instructions. IBPB (indirect branch predictor
barrier) is triggered by setting bit 0 of the IA32_PRED_CMD MSR. IBRS
(indirect branch restricted speculation) is triggered by setting bit 0
of the IA32_SPEC_CTRL MSR. It is true that the desired behavior of
IBRS (causing branch mispredictions) is only exhibited by certain
older parts. However, IBPB is now universally available, as it is
necessary to mitigate many speculative execution attacks. For Intel
documentation, see
https://www.intel.com/content/www/us/en/developer/articles/technical/softwa=
re-security-guidance/technical-documentation/cpuid-enumeration-and-architec=
tural-msrs.html.

If you don't want to use these, you could train a branch to go one way
prior to measurement, and then arrange for the branch under test go
the other way.

> >>>> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> >>>> ---
> >>>>    x86/pmu.c | 2 +-
> >>>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/x86/pmu.c b/x86/pmu.c
> >>>> index 0def28695c70..7443fdab5c8a 100644
> >>>> --- a/x86/pmu.c
> >>>> +++ b/x86/pmu.c
> >>>> @@ -35,7 +35,7 @@ struct pmu_event {
> >>>>           {"instructions", 0x00c0, 10*N, 10.2*N},
> >>>>           {"ref cycles", 0x013c, 1*N, 30*N},
> >>>>           {"llc references", 0x4f2e, 1, 2*N},
> >>>> -       {"llc misses", 0x412e, 1, 1*N},
> >>>> +       {"llc misses", 0x412e, 0, 1*N},
> >>>>           {"branches", 0x00c4, 1*N, 1.1*N},
> >>>>           {"branch misses", 0x00c5, 0, 0.1*N},
> >>>>    }, amd_gp_events[] =3D {
> >>>> --
> >>>> 2.34.1
> >>>>
