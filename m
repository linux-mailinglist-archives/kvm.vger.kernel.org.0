Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8033913A7BB
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 11:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgANKxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 05:53:33 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:44522 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgANKxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 05:53:32 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so12131901otj.11;
        Tue, 14 Jan 2020 02:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cn5oQa4AQw8CAHBLFyCfO9lTHCbEgvgO8kS0oRO7bOQ=;
        b=eK2Dg5z/JYnAaAy6xwTmYeSjPvJjm0B44DIx4I1iEs+x7RetgpH2bxuRg9XU2ddA+s
         yvJk4W4uXxtsjYY10pSPcdvwgzRXoTHfPNCjs7juDha99ypLF/CI+ZiR+1n+LF1MSI9e
         IsUJNA/MwMJ4PjqXR7xQMKcK42h6yssTx3yuTskJ5v2NhyECfnKY9wcfTtuspvItViB+
         xX8MeHMofmTJ4y9xpvMwrXV7olJeP/qyvpr3Ti6vgVGxlnDqDuIawEfZvrocueL5+wdk
         5KyZ8gf//54ZLlPevCJT0IC4N6g1jXbzei+H0KkL/lOXS5WmOFrnu8M+HUuzgdONO/yt
         kOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cn5oQa4AQw8CAHBLFyCfO9lTHCbEgvgO8kS0oRO7bOQ=;
        b=VJsF5j1RR+yWjtX0pzztD4y8JJihtNgn4OOHAWeN0nOYxfxINDb1a34xGbt5FANsvt
         VZxFUQZ5j6bJKBYvDby3MHf5j2VFqzymnQ+LkT4kPnpCg9TgPgFU6Ba7pIbgdpHMaqya
         EMDn/mxzDrmQSc2+4xJjX0qRu+sovw/80rudRUyhdMzXEBmTKcBEoJV0+u4RNN6W1Uiu
         DHRLooGTO1ghVeD8B7LzP8v5lEHU0RjfAuZtw/NJ5DBX0BUk9afaDYGnprcQ4cyaDKZs
         qN7s//REqU3JrObizTUFbM2RW9beDBsVSJk5bLrg4RX+zLYOhY2o+3sKnAY8uYy8+fay
         n8SQ==
X-Gm-Message-State: APjAAAWITXqLw5LK0grORBZkCevBK1/1MC5Phv+VtAa7LGOIilo7pePr
        46E/3gJiRBhPPfV9BwI+CvMGC/ZWTh+S0a1MCcw=
X-Google-Smtp-Source: APXvYqxhttxJBOc2iHCA0/wkTwR5uKcaMUnB+U6b9v/qVX340MTbr4dC/XjtB54IGpNIS77ISdOm2hRgUkn+e+kY654=
X-Received: by 2002:a05:6830:231d:: with SMTP id u29mr2091403ote.185.1578999212027;
 Tue, 14 Jan 2020 02:53:32 -0800 (PST)
MIME-Version: 1.0
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
 <20200108155040.GB2827@hirez.programming.kicks-ass.net> <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
 <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com>
 <20200113104314.GU2844@hirez.programming.kicks-ass.net> <ee2b6da2-be8c-2540-29e9-ffbb9fdfd3fc@redhat.com>
 <20200113123558.GF2827@hirez.programming.kicks-ass.net>
In-Reply-To: <20200113123558.GF2827@hirez.programming.kicks-ass.net>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 14 Jan 2020 18:53:19 +0800
Message-ID: <CANRm+Cz10Spq1mjBBa+RvgeUtNvWEXSfPzHy49gZbD-Z8+fh2A@mail.gmail.com>
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes mwait/hlt
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        christopher.s.hall@intel.com, hubert.chrzaniuk@intel.com,
        Len Brown <len.brown@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jan 2020 at 20:36, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Jan 13, 2020 at 12:52:20PM +0100, Paolo Bonzini wrote:
> > On 13/01/20 11:43, Peter Zijlstra wrote:
> > > So the very first thing we need to get sorted is that MPERF/TSC ratio
> > > thing. TurboStat does it, but has 'funny' hacks on like:
> > >
> > >   b2b34dfe4d9a ("tools/power turbostat: KNL workaround for %Busy and Avg_MHz")
> > >
> > > and I imagine that there's going to be more exceptions there. You're
> > > basically going to have to get both Intel and AMD to commit to this.
> > >
> > > IFF we can get concensus on MPERF/TSC, then yes, that is a reasonable
> > > way to detect a VCPU being idle I suppose. I've added a bunch of people
> > > who seem to know about this.
> > >
> > > Anyone, what will it take to get MPERF/TSC 'working' ?
> >
> > Do we really need MPERF/TSC for this use case, or can we just track
> > APERF as well and do MPERF/APERF to compute the "non-idle" time?
>
> So MPERF runs at fixed frequency (when !IDLE and typically the same
> frequency as TSC), APERF runs at variable frequency (when !IDLE)
> depending on DVFS state.
>
> So APERF/MPERF gives the effective frequency of the core, but since both
> stop during IDLE, it will not be a good indication of IDLE.
>
> Otoh, TSC doesn't stop in idle (.oO this depends on
> X86_FEATURE_CONSTANT_TSC) and therefore the MPERF/TSC ratio gives how
> much !idle time there was between readings.

Do you have a better solution to penalty vCPU process which mwait/hlt
executed inside? :)

    Wanpeng
