Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF633CBE31
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhGPVKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbhGPVKQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:10:16 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B64EC06175F
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:07:20 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so11241241otq.11
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+KcxcljLGJIVJWS815GhZ8vwrKBLUZUCoehT4sKIick=;
        b=QnfCOaF+t/airvvWleBWMXi4bMAV8F8C07l/T21uynV4up468L9W/0CdIOvo/1Ioa+
         3Nq3QpfIdmG2aHxBU8+fchqhDTbq+QALYfwICHMMLDq2xDVmXKwD2p5A/zt1kpKgmcLR
         3Rv9fl+CacqOqDy2bfRXC48IE+KHTvF2Fj0pDj4L+e0wif8olOH6OiHxTXNaS8IWhovm
         srV6dFZmOAYSg23tqf7uOHyQWF/y5bZHWcW5dAlsRVqGgeI9zQQ+hdvMnRzy0XFHm7Yi
         6uxumbS1rmq6jAdLTjZNdyULanX8BhvaeBdyZAj9dvJmJ+rB2bclMcsrAM+PV93H3FT1
         /Ekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+KcxcljLGJIVJWS815GhZ8vwrKBLUZUCoehT4sKIick=;
        b=Yn8vULe8P2G7T5EvlWU/PSzc1714ZAfyD+IxmcCLjlvbwkjdrktjeni74hLTP9eTFL
         1iezJtukHqi22MQeoQs+oYr+gj2e50sQ9pYqjJLb4pZPZbeIge3RoEK5fHVTdhfYTGQT
         L78uyrp4kDE9Yx13j8YpZqwiDhFhtJebJZ48t5qrrhsddJ38it3t/NH/uhoDuiBa0KVV
         9GwKndJWygVfPBul9g6Bwg1+5M9MCefWi0dCR88sQj+fWuX8Zx1gIKnSiC1/xlQyVd7q
         hNRfx5kqJMbTwqpf/mGSa4L57pl/EFD+u11wRXBXT65u6D4cxLa/aplJeDPFjTmLDLRG
         fCrg==
X-Gm-Message-State: AOAM530DSOrPNgBtE0AyZe6AS7TkvaDnCOesbogtVMwAnrlSEPlT+oqC
        1hXx8zYmFw15W/eAjhqE50TlH4gJPFghsmZgcoteng==
X-Google-Smtp-Source: ABdhPJxZhcCMqABPArOjR6KxEAGcwcKS907SlOyiKyyWtfF7hMD1MQl52qvcSETXu2JFjm9Jid+Nc49wBRQrisucJHY=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr9890451oth.241.1626469639196;
 Fri, 16 Jul 2021 14:07:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <CALMp9eSz6RPN=spjN6zdD5iQY2ZZDwM2bHJ2R4qWijOt1A_6aw@mail.gmail.com> <b6568241-02e3-faf6-7507-c7ad1c4db281@linux.intel.com>
In-Reply-To: <b6568241-02e3-faf6-7507-c7ad1c4db281@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Jul 2021 14:07:08 -0700
Message-ID: <CALMp9eT48THXwEG23Kb0-QExyA8qZAtkXxrxc+6+pdvtvVVN0A@mail.gmail.com>
Subject: Re: [PATCH V8 00/18] KVM: x86/pmu: Add *basic* support to enable
 guest PEBS via DS
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, peterz@infradead.org,
        pbonzini@redhat.com, bp@alien8.de, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        boris.ostrvsky@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 12:00 PM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 7/16/2021 1:02 PM, Jim Mattson wrote:
> > On Fri, Jul 16, 2021 at 1:54 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>
> >> The guest Precise Event Based Sampling (PEBS) feature can provide an
> >> architectural state of the instruction executed after the guest instruction
> >> that exactly caused the event. It needs new hardware facility only available
> >> on Intel Ice Lake Server platforms. This patch set enables the basic PEBS
> >> feature for KVM guests on ICX.
> >>
> >> We can use PEBS feature on the Linux guest like native:
> >>
> >>     # echo 0 > /proc/sys/kernel/watchdog (on the host)
> >>     # perf record -e instructions:ppp ./br_instr a
> >>     # perf record -c 100000 -e instructions:pp ./br_instr a
> >>
> >> To emulate guest PEBS facility for the above perf usages,
> >> we need to implement 2 code paths:
> >>
> >> 1) Fast path
> >>
> >> This is when the host assigned physical PMC has an identical index as the
> >> virtual PMC (e.g. using physical PMC0 to emulate virtual PMC0).
> >> This path is used in most common use cases.
> >>
> >> 2) Slow path
> >>
> >> This is when the host assigned physical PMC has a different index from the
> >> virtual PMC (e.g. using physical PMC1 to emulate virtual PMC0) In this case,
> >> KVM needs to rewrite the PEBS records to change the applicable counter indexes
> >> to the virtual PMC indexes, which would otherwise contain the physical counter
> >> index written by PEBS facility, and switch the counter reset values to the
> >> offset corresponding to the physical counter indexes in the DS data structure.
> >>
> >> The previous version [0] enables both fast path and slow path, which seems
> >> a bit more complex as the first step. In this patchset, we want to start with
> >> the fast path to get the basic guest PEBS enabled while keeping the slow path
> >> disabled. More focused discussion on the slow path [1] is planned to be put to
> >> another patchset in the next step.
> >>
> >> Compared to later versions in subsequent steps, the functionality to support
> >> host-guest PEBS both enabled and the functionality to emulate guest PEBS when
> >> the counter is cross-mapped are missing in this patch set
> >> (neither of these are typical scenarios).
> >
> > I'm not sure exactly what scenarios you're ruling out here. In our
> > environment, we always have to be able to support host-level
> > profiling, whether or not the guest is using the PMU (for PEBS or
> > anything else). Hence, for our *basic* vPMU offering, we only expose
> > two general purpose counters to the guest, so that we can keep two
> > general purpose counters for the host. In this scenario, I would
> > expect cross-mapped counters to be common. Are we going to be able to
> > use this implementation?
> >
>
> Let's say we have 4 GP counters in HW.
> Do you mean that the host owns 2 GP counters (counter 0 & 1) and the
> guest own the other 2 GP counters (counter 2 & 3) in your envirinment?
> We did a similar implementation in V1, but the proposal has been denied.
> https://lore.kernel.org/kvm/20200306135317.GD12561@hirez.programming.kicks-ass.net/

It's the other way around. AFAIK, there is no architectural way to
specify that only counters 2 and 3 are available, so we have to give
the guest counters 0 and 1.

> For the current proposal, both guest and host can see all 4 GP counters.
> The counters are shared.

I don't understand how that can work. If the host programs two
counters, how can you give the guest four counters?

> The guest cannot know the availability of the counters. It may requires
> a counter (e.g., counter 0) which may has been used by the host. Host
> may provides another counter (e.g., counter 1) to the guest. This is the
> case described in the slow path. For this case, we have to modify the
> guest PEBS record. Because the counter index in the PEBS record is 1,
> while the guest perf driver expects 0.

If we reserve counters 0 and 1 for the guest, this is not a problem
(assuming we tell the guest it only has two counters). If we don't
statically partition the counters, I don't see how you can ensure that
the guest behaves as architected. For example, what do you do when the
guest programs four counters and the host programs two?

> If counter 0 is available, guests can use counter 0. That's the fast
> path. I think the fast path should be more common even both host and
> guest are profiling. Because except for some specific events, we may
> move the host event to the counters which are not required by guest if
> we have enough resources.

And if you don't have enough resources?
