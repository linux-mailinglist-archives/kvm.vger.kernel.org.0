Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938EA7CD11C
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 02:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjJRACE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 20:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJRACD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 20:02:03 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0359F
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 17:02:01 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-66d1a05b816so37958546d6.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 17:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697587321; x=1698192121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/603XVHKaUaM8lugP87JFe8YYdPyptNnYZAmeymCgY=;
        b=majv7qatmKp5hGEMBDnrcA/xbS7deDukIQnOFM9dOmjfsR5yTtI/fh9vZqOeE6a3+I
         zHB0ptmqwmSjHEjaNF1bHyj76vG+mHkTb8CzzmS0CLSl8vW/xrdR+oeYtV3NDPbkhJuk
         eY9HfyzB3w8lKw22JBZALwsrMiVe0RQZ25wlVz4MruYuL0n9R6oiiqsUYSUo5sKCw35h
         hkSl5piDBIhaw1Ol1kWt61AdwUpalXYQUf66tmKAKa3PGAYdYe7bffojY0/2XCFfYaaJ
         Ek0QEgKSijvvlu0E+gHtOBCONzYD26k37W0AaIfIwtP6iBUMeUJ5wd2jCo/8vqNTA2LB
         Tx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697587321; x=1698192121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E/603XVHKaUaM8lugP87JFe8YYdPyptNnYZAmeymCgY=;
        b=XQspBADrZfAR3dH8L8XdIvQZ9saQWM/66pq3MAudGPVyCzK8SuwtmfgeQLhkgHOvX3
         42lgT9kWRGy+1nL8VcRj2mLZcS+Tb7z2GArYqi7TaZXVSSoNCdP4Y3Xr0TGg8wSbdpVL
         w6QTjDFl89J1CI8JkGk/RTRzo2/F9LooT68D8/in2ksfJszGpLcJMbeb9pe500EEXJdv
         4sPDRcO8pC40AO3SGR2/BeEmTZ59lbldk3NSiXiFGr3/NjZyvtkvEjBUUgDYAUzz0S2B
         kl4s0++WY/tQNpdyWPUgTv+1MGR1hEfpA2EnymAa3tAG4kRsFmvgGbM/ZKsPjj3Op/OF
         bf2Q==
X-Gm-Message-State: AOJu0Yww+7PWa8HC25TQLqMpYeOnKqAWpX8DUrxHGZfSZZ+rO8Bzuf/f
        N+2UGgbwDjMAQ1/UzJfQyDMfVEUqYwVXKB0Ygw9z5w==
X-Google-Smtp-Source: AGHT+IESc2jTZ14IErCtSD+XcH0XpFOrhUBDLZawZQWz8lF0Jn33Z5ZeUHxOsx7dhaVo+vey71zFifxSwADdtIjWyu0=
X-Received: by 2002:a05:6214:2aa1:b0:66d:3c8b:5f44 with SMTP id
 js1-20020a0562142aa100b0066d3c8b5f44mr4336406qvb.27.1697587320791; Tue, 17
 Oct 2023 17:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com> <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com> <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com> <ZR3hx9s1yJBR0WRJ@google.com>
 <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com> <03b7da03-78a1-95b1-3969-634b5c9a5a56@amd.com>
 <20231011141535.GF6307@noisy.programming.kicks-ass.net> <b2bfead3-0f48-d832-daee-e7c2069dae5d@amd.com>
 <CAL715WLhJ_xSL-cR+ppoJA+dwWK2gwCPb2ZqfToRYm-ShqkmEw@mail.gmail.com>
In-Reply-To: <CAL715WLhJ_xSL-cR+ppoJA+dwWK2gwCPb2ZqfToRYm-ShqkmEw@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 17 Oct 2023 17:01:23 -0700
Message-ID: <CAL715WLuO0WFumyTuahXoxxirFRknN4+nU_zNxbumuQjEVxfow@mail.gmail.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics event
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        David Dunn <daviddunn@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 9:58=E2=80=AFAM Mingwei Zhang <mizhang@google.com> =
wrote:
>
> On Tue, Oct 17, 2023 at 3:24=E2=80=AFAM Manali Shukla <manali.shukla@amd.=
com> wrote:
> >
> > On 10/11/2023 7:45 PM, Peter Zijlstra wrote:
> > > On Mon, Oct 09, 2023 at 10:33:41PM +0530, Manali Shukla wrote:
> > >> Hi all,
> > >>
> > >> I would like to add following things to the discussion just for the =
awareness of
> > >> everyone.
> > >>
> > >> Fully virtualized PMC support is coming to an upcoming AMD SoC and w=
e are
> > >> working on prototyping it.
> > >>
> > >> As part of virtualized PMC design, the PERF_CTL registers are define=
d as Swap
> > >> type C: guest PMC states are loaded at VMRUN automatically but host =
PMC states
> > >> are not saved by hardware.
> > >
> > > Per the previous discussion, doing this while host has active counter=
s
> > > that do not have ::exclude_guest=3D1 is invalid and must result in an
> > > error.
> > >
> >
> > Yeah, exclude_guest should be enforced on host, while host has active P=
MC
> > counters and VPMC is enabled.
> >
> > > Also, I'm assuming it is all optional, a host can still profile a gue=
st
> > > if all is configured just so?
> > >
> >
> > Correct, host should be able to profile guest, if VPMC is not enabled.
> >
> > >> If hypervisor is using the performance counters, it
> > >> is hypervisor's responsibility to save PERF_CTL registers to host sa=
ve area
> > >> prior to VMRUN and restore them after VMEXIT.
> > >
> > > Does VMEXIT clear global_ctrl at least?
> > >
> >
> > global_ctrl will be initialized to reset value(0x3F) during VMEXIT. Sim=
ilarly,
> > all the perf_ctl and perf_ctr are initialized to reset values(0) at VME=
XIT.
>
> Are these guest values (automatically) saved in the guest area of VMCB
> on VMEXIT?
>

Never mind on this one. So, if both values are in Type C, then they
should be saved to the guest area of VMCB on VMEXIT (according to APM
vol 2 Table B-3). So, this means KVM does not need to intercept these
MSRs on pass-through implementation.

Thanks.
-Mingwei

-Mingwei
