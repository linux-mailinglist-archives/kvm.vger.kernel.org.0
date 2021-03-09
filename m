Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD20332CD6
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhCIRHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbhCIRH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 12:07:26 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98499C06175F
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 09:07:26 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h26so6402218qtm.5
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 09:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=56FbvxYSyCO6wMKJdNcCg3DsZ58M3AgopzwpcrCwJ8M=;
        b=p9MFtEixfJK+C3OPIvyxsnbCCdPeJyP3yuIayQyx4bcy51/7AwiQHD3E2kH2inD3Sl
         dZDcwuFfelPyoPNTWto0FOXnVbZ4TquFs/P+y92UFfHoOXPVcFZcZFjDIoe77pTJT4OO
         SEt6H9KErkFAg7BGl7kYWMyC63q1CeR4dWZ4lyGhmbyb5fbOWiS5m5BxZb2huYOL+KuE
         FQjbUmGWAT1ypB8dukJilItUFmrV6gSu1Ryzz0clWm1Dpcqud3jCYwx0KM7HOpP9Ps3L
         a/I7xOsBGQqH8E/TXf1gdaLWPw2obeK/IAEpRUYkcrokwD4iBCSC6A3jvQ2t83xq8EGD
         MqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=56FbvxYSyCO6wMKJdNcCg3DsZ58M3AgopzwpcrCwJ8M=;
        b=aeoY/wnBgavdbX/4mBni+bCI3717aUPHsFKQlwhG5VBgPCd9h6Et0MwD3GwuhYIk24
         6TF4B7Cw7bn/3t3kRyw6kXoGK25b0BcANWmxe6p6rlXCEducT8QAjsyguZNr8rT7ZY86
         JdnrQb5AuGaHRUc7B8pcPXEF6XFM+K9FKrPAlXZ+bzpG441FdkfqtkkEN2qrNsL2+56Y
         bGNtplvL5CGakW3APnM17XTcjOnbLjxuF9naP1Pi1QW3MjhpCGmscq/3So9yL9y/im3x
         UPlTk2fJ0BlI2ES4wSM3Eq6DbcR8a48uzURHvfGquFWgjA5UPoMvL5Zv+1i+h2O6j1oz
         fXhQ==
X-Gm-Message-State: AOAM532DEyn1XrmCaebyj85f6CV2iJhECtQ0R4imlzj7a01Qxrj+aoId
        Z24tgxTJ4aRgixSVfhzYkk1hIWy+3KpByp5oDp78ig==
X-Google-Smtp-Source: ABdhPJxZX3UdvVqs1e2abPQvsIZT5YVWWWzFsq8aDd2lDWVh0cD2NXhUm8HucMz85rZmRKEA3T7/bWLQMWcO6Xm0t7Q=
X-Received: by 2002:ac8:7318:: with SMTP id x24mr7500268qto.67.1615309645573;
 Tue, 09 Mar 2021 09:07:25 -0800 (PST)
MIME-Version: 1.0
References: <20210305223331.4173565-1-seanjc@google.com> <053d0a22-394d-90d0-8d3b-3cd37ca3f378@intel.com>
 <YEXmILSHDNDuMk/N@hirez.programming.kicks-ass.net> <YEaLzKWd0wAmdqvs@google.com>
 <YEcn6bGYxdgrp0Ik@hirez.programming.kicks-ass.net> <YEc1mFkaILfF37At@hirez.programming.kicks-ass.net>
 <YEeqvC4QmJcj+pkC@google.com>
In-Reply-To: <YEeqvC4QmJcj+pkC@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 9 Mar 2021 18:07:14 +0100
Message-ID: <CACT4Y+b6rDO0PiHrhYHMynXmW+f_s5AaJLDo39rGJX69ZWSaMQ@mail.gmail.com>
Subject: Re: [PATCH] x86/perf: Fix guest_get_msrs static call if there is no PMU
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Xu, Like" <like.xu@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        KVM list <kvm@vger.kernel.org>,
        "Thomas Gleixner
        (x86/pti/timer/core/smp/irq/perf/efi/locking/ras/objtool)
        (x86@kernel.org)" <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 9, 2021 at 6:05 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Mar 09, 2021, Peter Zijlstra wrote:
> > On Tue, Mar 09, 2021 at 08:46:49AM +0100, Peter Zijlstra wrote:
> > > On Mon, Mar 08, 2021 at 12:40:44PM -0800, Sean Christopherson wrote:
> > > > On Mon, Mar 08, 2021, Peter Zijlstra wrote:
> > >
> > > > > Given the one user in atomic_switch_perf_msrs() that should work because
> > > > > it doesn't seem to care about nr_msrs when !msrs.
> > > >
> > > > Uh, that commit quite cleary says:
> > >
> > > D0h! I got static_call_cond() and __static_call_return0 mixed up.
> > > Anyway, let me see if I can make something work here.
> >
> > Does this work? I can never seem to start a VM, and if I do accidentally
> > manage, then it never contains the things I need :/
>
> Yep, once I found the dependencies in tip/sched/core (thank tip-bot!).  I'll
> send v2 your way.

If you are resending, please also add the syzbot Reported-by tag. Thanks.
