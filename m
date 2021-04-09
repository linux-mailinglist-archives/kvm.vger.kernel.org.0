Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B68359272
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 05:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhDIDFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 23:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbhDIDFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 23:05:25 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F174AC061760;
        Thu,  8 Apr 2021 20:05:12 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso2477641otb.13;
        Thu, 08 Apr 2021 20:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZAauTo+p3+o5110VbhLNzHzIGrbICjJmfEEY/9Ouk4k=;
        b=fcy27v0G77koIAzP8x3ZQC7AsiJ632w4zZTIwb2upvoL51vCSvSEeXHgPFIhIEaIF8
         3woYwf99gc8HnisNDkx4CHIPh4oOIQFwHjwBm3ileEY7T4+ndhS8bOOSilzsnppni2aM
         fe5u95g+e0Le1EFh6PX1gL1MFaOoBGQQ31RKGCw8j/DU7d0UlzzRwYKSnV0CyARzcXZ3
         XiGCIP5VJ2BZYe9r1Rw3pFZh4F+dl34Qe+66S8cyGY957sxa6x31OA6tMYnsyoHaiOri
         yx8Isq/uqvMPsGgaGET/Ms8JI0Zw1S+9JnbvTE5iDPQWWJoZyodhU1LsdQVdZtjkzEtl
         OGRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZAauTo+p3+o5110VbhLNzHzIGrbICjJmfEEY/9Ouk4k=;
        b=GFPZ665BkQRVEJoWVKF8rAN6R9/ychiOiQWT7InRYPXne+Kj/t9T6QvW2kvfCKbIFf
         /OK/4DtJH1og9ZVctPxAJInWpgHd6X/vJzEUrtPlzHpBMpRGq1rIEBnenPearPtdTUFs
         VB9Yjq/wsFw+9gYQkIC77jvVTOIHPvGIaYOxKDzZzUZ3DohkJpxz2owwJBPblo8WTn+l
         SQEc7QjYfAk6uYyutQrJXE/1hU5BOb6NyogeZOAJ/PqL9y4GrUTl3pQ9Bnk8IZrRYTJI
         /Gg4Y458xv6RCnLNpiuoCGPRg8TmGJTy1cFrOicNvg2NGYfpXo7HKjfltTFRZSInUagS
         Q7cA==
X-Gm-Message-State: AOAM531ZzNbzl34X7kCLusCmbNyY+tkMNh9EhWFc8/2I0FQwBjkRK+JZ
        KA8iNVWRmfvJ+Lbw4KBisyYupOS1gFYp7k1tq3gN1Ds8
X-Google-Smtp-Source: ABdhPJxWarAyWuF9tlAm2Gshxc9o7gNql9ifRB3jyrkYC2iMWXVhD+8W2dX4TgCGag0t4rRMg/hdD3ZNnKLUtfEcFR4=
X-Received: by 2002:a9d:6b13:: with SMTP id g19mr10343601otp.185.1617937512406;
 Thu, 08 Apr 2021 20:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <1617697935-4158-1-git-send-email-wanpengli@tencent.com> <YG84jSpRtgfhWaiw@google.com>
In-Reply-To: <YG84jSpRtgfhWaiw@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 9 Apr 2021 11:05:00 +0800
Message-ID: <CANRm+CwWOq1BUBEWXJVHu-o4SNiEHN6KC3_sFYTAEqGa0LU3Bw@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Count success and invalid yields
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

On Fri, 9 Apr 2021 at 01:08, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Apr 06, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > To analyze some performance issues with lock contention and scheduling,
> > it is nice to know when directed yield are successful or failing.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/x86.c              | 26 ++++++++++++++++++++------
> >  2 files changed, 22 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 44f8930..157bcaa 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1126,6 +1126,8 @@ struct kvm_vcpu_stat {
> >       u64 halt_poll_success_ns;
> >       u64 halt_poll_fail_ns;
> >       u64 nested_run;
> > +     u64 yield_directed;
> > +     u64 yield_directed_ignore;
> >  };
> >
> >  struct x86_instruction_info;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 16fb395..3b475cd 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -246,6 +246,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
> >       VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
> >       VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
> >       VCPU_STAT("nested_run", nested_run),
> > +     VCPU_STAT("yield_directed", yield_directed),
>
> This is ambiguous, it's not clear without looking at the code if it's counting
> attempts or actual yields.
>
> > +     VCPU_STAT("yield_directed_ignore", yield_directed_ignore),
>
> "ignored" also feels a bit misleading, as that implies KVM deliberately ignored
> a valid request, whereas many of the failure paths are due to invalid requests
> or errors of some kind.
>
> What about mirroring the halt poll stats, i.e. track "attempted" and "successful",
> as opposed to "attempted" and "ignored/failed".    And maybe switched directed
> and yield?  I.e. directed_yield_attempted and directed_yield_successful.

Good suggestion.

>
> Alternatively, would it make sense to do s/directed/pv, or is that not worth the
> potential risk of being wrong if a non-paravirt use case comes along?
>
>         pv_yield_attempted
>         pv_yield_successful
>
> >       VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
> >       VM_STAT("mmu_pte_write", mmu_pte_write),
> >       VM_STAT("mmu_pde_zapped", mmu_pde_zapped),
> > @@ -8211,21 +8213,33 @@ void kvm_apicv_init(struct kvm *kvm, bool enable)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_apicv_init);
> >
> > -static void kvm_sched_yield(struct kvm *kvm, unsigned long dest_id)
> > +static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
> >  {
> >       struct kvm_vcpu *target = NULL;
> >       struct kvm_apic_map *map;
> >
> > +     vcpu->stat.yield_directed++;
> > +
> >       rcu_read_lock();
> > -     map = rcu_dereference(kvm->arch.apic_map);
> > +     map = rcu_dereference(vcpu->kvm->arch.apic_map);
> >
> >       if (likely(map) && dest_id <= map->max_apic_id && map->phys_map[dest_id])
> >               target = map->phys_map[dest_id]->vcpu;
> >
> >       rcu_read_unlock();
> > +     if (!target)
> > +             goto no_yield;
> > +
> > +     if (!READ_ONCE(target->ready))
>
> I vote to keep these checks together.  That'll also make the addition of the
> "don't yield to self" check match the order of ready vs. self in kvm_vcpu_on_spin().

Do it in v2.

    Wanpeng
