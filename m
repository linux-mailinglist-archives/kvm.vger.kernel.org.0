Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6905137B437
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 04:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhELCoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 22:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhELCoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 22:44:37 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E31CC061763;
        Tue, 11 May 2021 19:43:30 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id w22so7099858oiw.9;
        Tue, 11 May 2021 19:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jiFXw0djjJoh6U5BPJwzizmPY29AVsMjgO4iqC1nUPc=;
        b=SVp23lzqVA+XUl5i76vOZyM8rl+ajveVK61N2LBOTHRk75uvk9Wt8kB/2nir0m2NCq
         aPXmE1/DxBoxgnVAAuYnyNMcN3ZtU1M9g4a6f6h9XURr80cXTv4FdpCsPv/upH5t9+vp
         qPjbyhkfwBHxxU0RkOH6wB8LimzXwnAPUXQnFEMC3ee/2vCsypSrgUzl0qD+7OG9FjXe
         wwdTEXQ6pnOqzqa3/XAINjHY3n7eLj93DRuXu88ofc8qnS23xOVlLVFjHlGZM4SvdFVO
         YFx/CJS2COabTMY/LSavmoV0LjaQVFaXuhXLmqaKM+AwvTBDkDOCZCNgHGZ8sKq2LZmx
         dgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jiFXw0djjJoh6U5BPJwzizmPY29AVsMjgO4iqC1nUPc=;
        b=fzVvKLho3AkV9dHQJKSRr1jo2Jm7cnTlZfiqPl+N8ni+aFml4Op/B9t4tsGTGRkIp6
         Ld2yVpABORVwao6ZCHdzpA8KRYXNAFW3Cdkpwj6c/eXbidNoh06hSsHCF5VRDkxBIdIj
         RRs0v+9M5gfbhwYhvTkKBRXEtmfWe0yZmpeXJ13b/IOcnG1oWKxEHUFxhiiCsyyg0Oms
         KD0/2WZwbZO95KiDm4q0qRxICFbr0tnP2xzhlePfbXjr4zODe7Ua1+Q2EUEvaDnyhwR8
         Egf3q2q0Wnfyxm8v9jQXZRZ1R99psbhgILvZQUhK73HwjypKqcTAL937faRvnLzP/ZDM
         iYNw==
X-Gm-Message-State: AOAM532m6lG8re37UVqYFS1d0wwkOpbdXlU4ReEOYIqsNVHsd6L896KO
        a0/Hhaf+QtwqAmtDmdF6GKSOgRS5tD3BTJgjkfk=
X-Google-Smtp-Source: ABdhPJzvibUVZXLXUlvNTMe/9ojiBltyI639HptwJYY0KtqjTv9dj8CnsFVyD5qD95iVH9unX6iGskwDi7QtCz/dC8k=
X-Received: by 2002:aca:aa12:: with SMTP id t18mr1920871oie.141.1620787409603;
 Tue, 11 May 2021 19:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
 <1620466310-8428-2-git-send-email-wanpengli@tencent.com> <YJr6v+hfMJxI2iAn@google.com>
In-Reply-To: <YJr6v+hfMJxI2iAn@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 May 2021 10:43:18 +0800
Message-ID: <CANRm+Czbc9AX3=Qj7dDCENyWj27drWniimZLnyKd9=--Ag8F+g@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: X86: Bail out of direct yield in case of
 undercomitted scenarios
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 May 2021 at 05:44, Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, May 08, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > In case of undercomitted scenarios, vCPU can get scheduling easily,
> > kvm_vcpu_yield_to adds extra overhead, we can observe a lot of race
> > between vcpu->ready is true and yield fails due to p->state is
> > TASK_RUNNING. Let's bail out is such scenarios by checking the length
> > of current cpu runqueue.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5bd550e..c0244a6 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8358,6 +8358,9 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
> >       struct kvm_vcpu *target = NULL;
> >       struct kvm_apic_map *map;
> >
> > +     if (single_task_running())
> > +             goto no_yield;
> > +
>
> Hmm, could we push the result of kvm_sched_yield() down into the guest?
> Currently the guest bails after the first attempt, which is perfect for this
> scenario, but it seems like it would make sense to keep trying to yield if there
> are multiple preempted vCPUs and

It can have a race in case of sustain yield if there are multiple
preempted vCPUs , the vCPU which you intend to yield may have already
completed to handle IPI and be preempted now when the yielded sender
is scheduled again and checks the next preempted candidate.

> the "problem" was with the target.  E.g.

At the beginning of kvm_sched_yield() we can just get the run queue
length of the source, it can be treated as a hint of under-committed
instead of guarantee of accuracy.

>
>         /*
>          * Make sure other vCPUs get a chance to run if they need to.  Yield at
>          * most once, and stop trying to yield if the VMM says yielding isn't
>          * going to happen.
>          */
>         for_each_cpu(cpu, mask) {
>                 if (vcpu_is_preempted(cpu)) {
>                         r = kvm_hypercall1(KVM_HC_SCHED_YIELD,
>                                            per_cpu(x86_cpu_to_apicid, cpu));
>                         if (r != -EBUSY)
>                                 break;
>                 }
>         }
>
>
> Unrelated to this patch, but it's the first time I've really looked at the guest
> side of directed yield...
>
> Wouldn't it also make sense for the guest side to hook .send_call_func_single_ipi?

reschedule ipi is called by .smp_send_reschedule hook, there are a lot
of researches intend to accelerate idle vCPU reactivation, my original
attemption is to boost synchronization primitive, I believe we need a
lot of benchmarkings to consider inter-VM fairness and performance
benefit for  hooks .send_call_func_single_ipi and
.smp_send_reschedule.

>
> >       vcpu->stat.directed_yield_attempted++;
>
> Shouldn't directed_yield_attempted be incremented in this case?  It doesn't seem
> fundamentally different than the case where the target was scheduled in between
> the guest's check and the host's processing of the yield request.  In both
> instances, the guest did indeed attempt to yield.

Yes, it should be treated as attempted, I move it above the counting
because this patch helps improve successful ratio in under-committed
scenarios and easily shows me how much failure ratio leaves over. I
can move it after the counting in the next version.

    Wanpeng
