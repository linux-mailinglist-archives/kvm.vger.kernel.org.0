Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3993F382274
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 03:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbhEQBFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 21:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhEQBFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 May 2021 21:05:14 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2392FC061573;
        Sun, 16 May 2021 18:03:59 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z3so5064916oib.5;
        Sun, 16 May 2021 18:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VTq4B8Xd+T34RrTcqGRr59KQ4TvmTyoYLB8a2xKQrCY=;
        b=NVUKcqoBrGekWdXAGDC7LIGpLDkRCB7Lye4BExfjwdo6t8KT6al2coJCJjjvG5WJP7
         sUJVfwA+ARu2a4PWEFsuW9tNzAl4FZrTgwxZFI16V6pWbfD6kjwtrwgkjY5VptaH9q01
         O9YGhhym0w4CfzC2/qcFxbkWNULGIMpQr2NkI0x9Y/LrtU1qYSsYdCO9Bl4UoZ+zWpCv
         rXYQH3hXgnf576ctc04xO+laaIX82JHqjL0r8fv1Vq5W+2UEFPZ/jk6e8FzuxxJHIqKV
         k4GbiwyznkbB/o3k6B36fK/PmXcdekaQ3q3zblIf40haSE6B70OHlNPo17bOS8/qCJSR
         URfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VTq4B8Xd+T34RrTcqGRr59KQ4TvmTyoYLB8a2xKQrCY=;
        b=CEV4YpcxfPfIpMDxboQXVTU9eqFvpsa8H6VKMIGVC+wyVQNUbnePkVy9z66kVk0bO1
         BTWKcCxbfemsWV93VrRopY1uFv3FRsgIzOjWx0H2XHO0Mvv9DZQSfEeEdZP+HibleG30
         yL6txFveQWtgEyoHK+OhkzVOY2+3aEyBg4E8/bgyaPfycO+3Cl9anqEltcDzfGgaQXxc
         n6AMeHaxlW9xCwgw6Z9bl3gXUjyc5P6CpBVa9aN/1BHXIqPfcp12s+nm1nH3EqEfAKCJ
         bSuIanJFuRQaQnX3sdINLkrvrfI7wTckscbg6TUzXBdlbQUBKg2mJnIjBde4t/OqqmgB
         rJRw==
X-Gm-Message-State: AOAM533abc46LApOVtm+9iNWUMFwVylvJgFGM1KFCkdcKK6BNu51/xWG
        1YdNvaw2GQcoJfNEA1VWlz6VJtr5iG+E6CQwEFo=
X-Google-Smtp-Source: ABdhPJzHa5kH9tYBGfvAdptNU/1urqtaKNoYoa/LLvQj7XCeVIHntkINCUt4TuYR52aky0rbYNjoc7G8GCYZVN8jNfY=
X-Received: by 2002:a05:6808:206:: with SMTP id l6mr13203833oie.5.1621213438674;
 Sun, 16 May 2021 18:03:58 -0700 (PDT)
MIME-Version: 1.0
References: <1620871189-4763-1-git-send-email-wanpengli@tencent.com> <CALzav=e98KRgG+z5oezPmENKDt+NqtEA57ijYh3kMBZyduQUZg@mail.gmail.com>
In-Reply-To: <CALzav=e98KRgG+z5oezPmENKDt+NqtEA57ijYh3kMBZyduQUZg@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 May 2021 09:03:47 +0800
Message-ID: <CANRm+CysOO=trayS6U_sYBm1pWbE8o-PjBqwfTZ_YoZXbX91vg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] KVM: X86: Bail out of direct yield in case of
 under-comitted scenarios
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 15 May 2021 at 05:33, David Matlack <dmatlack@google.com> wrote:
>
> On Wed, May 12, 2021 at 7:01 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > In case of under-comitted scenarios, vCPU can get scheduling easily,
> > kvm_vcpu_yield_to adds extra overhead, we can observe a lot of race
> > between vcpu->ready is true and yield fails due to p->state is
> > TASK_RUNNING. Let's bail out in such scenarios by checking the length
> > of current cpu runqueue, it can be treated as a hint of under-committed
> > instead of guarantee of accuracy.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * move the check after attempted counting
> >  * update patch description
> >
> >  arch/x86/kvm/x86.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9b6bca6..dfb7c32 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8360,6 +8360,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
> >
> >         vcpu->stat.directed_yield_attempted++;
> >
> > +       if (single_task_running())
> > +               goto no_yield;
>
> Since this is a heuristic, do you have any experimental or real world
> results that show the benefit?

I observe the directed_yield_successful/directed_yield_attempted
ratio, it can be improved from 50%+ to 80%+ in the under-committed
scenario.

     Wanpeng
