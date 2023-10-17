Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2727CC94D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 18:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343689AbjJQQ7E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 12:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbjJQQ67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 12:58:59 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CA9F5
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:58:55 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-d865854ef96so6691079276.2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 09:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561935; x=1698166735; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehHiG5u8VUrGyvdvtZ5izhIhQL5g/E91S/K67Xu9F2I=;
        b=HsZ+yZMWmDsMDdrizETAGYwBuuk14i732KmQBss8+RTYrOYPV9NoVW/tKkNAnCUYw9
         gc5YzWhFtvm/7tsVFIdUZ92qutuLi+6uMoAyPMHCW+n6SHmzJ5Pf107eR7etY7E2svPN
         nYj8Mc3k+fIwBNBpM5IDfuksdX2XvZLWryzwPJUpiK2TBz2D8VPQlNZ8UcL2iZ3WT/7i
         +Vkeh6pHkUlEN01RJHho9jZv1gIJsS26Rv6RG32tVW40ALqKYQMrAOilAVrEpHECAF3y
         gHigajW4UztKWIJs6irQoFl9+/slSv6V7KzIM2k5I+4VJeQ5/nFoeWWqEuciHSKbyISp
         6IUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561935; x=1698166735;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehHiG5u8VUrGyvdvtZ5izhIhQL5g/E91S/K67Xu9F2I=;
        b=jdrNQZJ9xXholSX+xcJIg+7+w+HbNgK3bUGehHXm4uPLvnZoRjBIClXgvuH59LC7cN
         9My56FHvzQrsMz9XO8Fi7FvqPO13XLopaYZWXcYPVxkAz+Gr+L8+D+HaNiGdyuotJkEe
         h+3ecA1XPPG/jIMGEXvNRzTQ3lgKH7BGzui1S9jTkI0Fa/pXfxASEJf5JiYtzB7QCadT
         Y50AB8hcvRMpOEW+ZTFILuZQcVsj6xtVxf8e+QoIJKuSA5E879evhFC3G+/xAhfz13Lq
         AjRWzcbNRWsWcrvSZRgwvLzPG7e/ULU1d0g04vurdFiZ0WNJEQGItVi+yWisB8d54tBE
         UaOQ==
X-Gm-Message-State: AOJu0YyLHd8hKHdA9CHXaXjahprKcvSwNU2Y8U2j8H5gwKS57ysj0WtK
        9fYZVXdwyX1WxIDe/hmTK1fyzX31+C12oxeAVKNc7g==
X-Google-Smtp-Source: AGHT+IHOaiEbjDuLYdorEK43jj8fJOs7cFKMQURFdPfFeqgkvW7hcEnkbP461Ssg/kEGKu+TUJRF90EXB4vKRbRBnzU=
X-Received: by 2002:a25:ec02:0:b0:d86:357:e314 with SMTP id
 j2-20020a25ec02000000b00d860357e314mr2757061ybh.47.1697561934985; Tue, 17 Oct
 2023 09:58:54 -0700 (PDT)
MIME-Version: 1.0
References: <20231002204017.GB27267@noisy.programming.kicks-ass.net>
 <ZRtmvLJFGfjcusQW@google.com> <20231003081616.GE27267@noisy.programming.kicks-ass.net>
 <ZRwx7gcY7x1x3a5y@google.com> <20231004112152.GA5947@noisy.programming.kicks-ass.net>
 <CAL715W+RgX2JfeRsenNoU4TuTWwLS5H=P+vrZK_GQVQmMkyraw@mail.gmail.com>
 <ZR3eNtP5IVAHeFNC@google.com> <ZR3hx9s1yJBR0WRJ@google.com>
 <c69a1eb1-e07a-8270-ca63-54949ded433d@gmail.com> <03b7da03-78a1-95b1-3969-634b5c9a5a56@amd.com>
 <20231011141535.GF6307@noisy.programming.kicks-ass.net> <b2bfead3-0f48-d832-daee-e7c2069dae5d@amd.com>
In-Reply-To: <b2bfead3-0f48-d832-daee-e7c2069dae5d@amd.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Tue, 17 Oct 2023 09:58:18 -0700
Message-ID: <CAL715WLhJ_xSL-cR+ppoJA+dwWK2gwCPb2ZqfToRYm-ShqkmEw@mail.gmail.com>
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
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 3:24=E2=80=AFAM Manali Shukla <manali.shukla@amd.co=
m> wrote:
>
> On 10/11/2023 7:45 PM, Peter Zijlstra wrote:
> > On Mon, Oct 09, 2023 at 10:33:41PM +0530, Manali Shukla wrote:
> >> Hi all,
> >>
> >> I would like to add following things to the discussion just for the aw=
areness of
> >> everyone.
> >>
> >> Fully virtualized PMC support is coming to an upcoming AMD SoC and we =
are
> >> working on prototyping it.
> >>
> >> As part of virtualized PMC design, the PERF_CTL registers are defined =
as Swap
> >> type C: guest PMC states are loaded at VMRUN automatically but host PM=
C states
> >> are not saved by hardware.
> >
> > Per the previous discussion, doing this while host has active counters
> > that do not have ::exclude_guest=3D1 is invalid and must result in an
> > error.
> >
>
> Yeah, exclude_guest should be enforced on host, while host has active PMC
> counters and VPMC is enabled.
>
> > Also, I'm assuming it is all optional, a host can still profile a guest
> > if all is configured just so?
> >
>
> Correct, host should be able to profile guest, if VPMC is not enabled.
>
> >> If hypervisor is using the performance counters, it
> >> is hypervisor's responsibility to save PERF_CTL registers to host save=
 area
> >> prior to VMRUN and restore them after VMEXIT.
> >
> > Does VMEXIT clear global_ctrl at least?
> >
>
> global_ctrl will be initialized to reset value(0x3F) during VMEXIT. Simil=
arly,
> all the perf_ctl and perf_ctr are initialized to reset values(0) at VMEXI=
T.

Are these guest values (automatically) saved in the guest area of VMCB
on VMEXIT?

>
> >> In order to tackle PMC overflow
> >> interrupts in guest itself, NMI virtualization or AVIC can be used, so=
 that
> >> interrupt on PMC overflow in guest will not leak to host.
> >
> > Can you please clarify -- AMD has this history with very dodgy PMI
> > boundaries. See the whole amd_pmu_adjust_nmi_window() crud. Even the
> > PMUv2 update didn't fix that nonsense.
> >
> > How is any virt stuff supposed to fix this? If the hardware is late
> > delivering PMI, what guarantees a guest PMI does not land in host
> > context and vice-versa?
> >
> > How does NMI virtualization (what even is that) or AVIC (I'm assuming
> > that's a virtual interrupt controller) help?
> >
>
> When NMI virtualization is enabled and source of VNMI is in guest, micro =
code will
> make sure that VNMI will directly be delivered to the guest (even if NMI =
was late
> delivered), so there is no issue of leaking guest NMI to the host.
>
> > Please make very sure, with your hardware team, that PMI must not be
> > delivered after clearing global_ctrl (preferably) or at the very least,
> > there exists a sequence of operations that provides a hard barrier
> > to order PMI.
> >
> We are verifying all the corner cases, while prototyping PMC virtualizati=
on.
> As of now, we don't see guest NMIs leaking to host issue. But latency iss=
ues
> still stays.

How long is the latency? From the existing code (amd_pmu_disable_all()
=3D> amd_pmu_check_overflow()), it seems to take up to 50 microseconds
in amd_pmu_check_overflow(). But I wonder how much in reality.

Thanks.
-Mingwei
>
