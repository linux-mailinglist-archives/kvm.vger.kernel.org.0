Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3973C6837
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 03:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbhGMBsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 21:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhGMBsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 21:48:47 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932DAC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 18:45:58 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id v32-20020a0568300920b02904b90fde9029so6291729ott.7
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 18:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=amHpZtSdIEej/owL8aVzmXyTCQ7j7cjyj5v+QZPgqdI=;
        b=Qz72lTahuK4Mhg06ZsvY7pm8tv1/hJkQryfMRJMeHgc1SG/iyMcekbh4O460T+pgjJ
         D0HFc3GDfPWsPoMXg4obK2uP7fYCq+mZ0e99mvCngGgQNmwGo32r4sy1hCv7fkoAvGhG
         zUaIYS1T+FpWMMiVjxPrZSSwKtQ1KvpdRjdwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amHpZtSdIEej/owL8aVzmXyTCQ7j7cjyj5v+QZPgqdI=;
        b=H3rBocLaKqqdUZhSVzASW9CSEesCt0wWOsGG19MUG0jy7M4yWNYoK9KlO9H5JBJeNz
         OQQW4xwSxvqQd/TWPkfeCTtAqmeQhDOGhhK+dKgZRVKtt91TMGyiek0oGuXk1M0lvmrH
         ipzB57fd6GNaLOqWxPkp0SpygBH9rN0YTlrwEbSyhSlzXC/9pfjWZfU3nLJqg/c8vJk5
         t0kCVBao4z8eS5zB5WcHLYENzZNbKGTedViJo3eN8F9NqDlAFRZcrI/lQtFCxkhG+z1j
         kk/SCBFqrigCSrqtBHjhwjJ6dQMwre3mhVvC9mdtWRBHlzx2MHI37yysglJuvSFP7iAM
         jwKA==
X-Gm-Message-State: AOAM530ijepg+GE3yQ9Guv4JpOJkIjU6x+W2FRKfwWfxcMnDvD1GlAhU
        7ah2cY5UOZ64T3PgDjS7Wmen0ZIllHdRvav3BeMd1w==
X-Google-Smtp-Source: ABdhPJxVJAotLnMqO+eWnqQcBDOlctirw2WJyy8srNVUx7n6HKcLFhYvaILsjqvETpoSmGj61KqFtBAT3qsCFoc5UTg=
X-Received: by 2002:a05:6830:544:: with SMTP id l4mr1530242otb.164.1626140758004;
 Mon, 12 Jul 2021 18:45:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210630031037.584190-1-venkateshs@chromium.org>
 <YNyayUOiDDZ9V3Ex@google.com> <YOiLlqZBhEK0hsie@google.com>
In-Reply-To: <YOiLlqZBhEK0hsie@google.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Mon, 12 Jul 2021 18:45:47 -0700
Message-ID: <CAA0tLEo+t+d09h=OdDO8KiQ11xVBPixv_rg-xCca+rzXbqeRgg@mail.gmail.com>
Subject: Re: [PATCH] KVM: kvm_vcpu_kick: Do not read potentially-stale vcpu->cpu
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org,
        Jim Mattson <jmattson@google.com>, elver@google.com,
        dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 10:47 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Jun 30, 2021, David Matlack wrote:
> > On Tue, Jun 29, 2021 at 08:10:37PM -0700, Venkatesh Srinivas wrote:
> > > vcpu->cpu contains the last cpu a vcpu run/is running on;
> > > kvm_vcpu_kick is used to 'kick' a guest vcpu by sending an IPI
> > > to the last CPU; vcpu->cpu is updated on sched_in when a vcpu
> > > moves to a new CPU, so it possible for the vcpu->cpu field to
> > > be stale.
>
> This fails to document the actual bug being fixed, and why the fix is correct.
> The fact that vcpu->cpu may be stale is itself not a bug, e.g. even with this
> patch, the IPI can be sent to the "wrong", i.e. smp_send_reschedule() can still
> consume a stale vcpu->cpu.
>
> The bug that's being fixed is that grabbing the potentially-stale vcpu->cpu
> _before_ kvm_arch_vcpu_should_kick() can cause KVM to send an IPI to the wrong
> CPU _and_ let the vCPU run longer than intended.  The fix is correct because KVM
> doesn't truly care about sending an IPI to the correct pCPU, it only cares about
> about kicking the pCPU out of the guest.  If the vCPU has exited and been loaded
> on a different pCPU after kvm_arch_vcpu_should_kick(), then its mission has been
> accomplished and the IPI (to the wrong pCPU) is truly spurious.

Will improve the comment for V2.

> > > kvm_vcpu_kick also read vcpu->cpu early with a plain read,
> > > while vcpu->cpu could be concurrently written. This caused
> > > a data race, found by kcsan:
> > >
> > > write to 0xffff8880274e8460 of 4 bytes by task 30718 on cpu 0:
> > >  kvm_arch_vcpu_load arch/x86/kvm/x86.c:4018
> > >  kvm_sched_in virt/kvm/kvm_main.c:4864
> > >
> > > vs
> > >  kvm_vcpu_kick virt/kvm/kvm_main.c:2909
> > >  kvm_arch_async_page_present_queued arch/x86/kvm/x86.c:11287
> > >  async_pf_execute virt/kvm/async_pf.c:79
> > >  ...
> > >
> > > Use a READ_ONCE to atomically read vcpu->cpu and avoid the
> > > data race.
> > >
> > > Found by kcsan & syzbot.
> > >
> > > Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
>
> > Reviewed-by: David Matlack <dmatlack@google.com>
> >
> > > ---
> > >  virt/kvm/kvm_main.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 46fb042837d2..0525f42afb7d 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3058,16 +3058,18 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
> > >   */
> > >  void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> > >  {
> > > -   int me;
> > > -   int cpu = vcpu->cpu;
> > > +   int me, cpu;
> > >
> > >     if (kvm_vcpu_wake_up(vcpu))
> > >             return;
> > >
> > >     me = get_cpu();
> > > -   if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> > > -           if (kvm_arch_vcpu_should_kick(vcpu))
> > > +   if (kvm_arch_vcpu_should_kick(vcpu)) {
> > > +           cpu = READ_ONCE(vcpu->cpu);
> > > +           WARN_ON_ONCE(cpu == me);
> >
> > nit: A comment here may be useful to explain the interaction with
> > kvm_arch_vcpu_should_kick(). Took me a minute to understand why you
> > added the warning.
>
> Agreed.

Will do for V2

> > > +           if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> > >                     smp_send_reschedule(cpu);
> > > +   }
> > >     put_cpu();
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> > > --
> > > 2.30.2
> > >
