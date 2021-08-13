Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC73EB2B0
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhHMIfH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhHMIfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 04:35:06 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC959C061756;
        Fri, 13 Aug 2021 01:34:39 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id u7so10010341ilk.7;
        Fri, 13 Aug 2021 01:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bE9TxV1NxGv6uJxQKHxpw5wNqdc2BaAqHYvz9Wy+fwc=;
        b=S8LL0yUkD360rWg8+AdVSuJEGuVgJ3p7K1oJ8exah+FLfY4yvPm2YNsW7VYP/Guch7
         WluEbiUDlYlbXxZKbxy7AhGGtYD4kftU1I5ee0IzMI9giAKsjh1gUylSag1/Ze0rEx17
         12sxRfz+/9YosvH/rDqsDyNJ/igq4AV93q+jypLL2wB79C8IAo74hfqK12rQ2CdtsbOz
         YQKPkiVTfvVUV2RIAM9+1Os9B/P8ceqpLwFtMhzU5DTXJB8yB85ORxSQQKuNvDc38djq
         jIATQex7NR/yMQtpSgJqmdGHii2CBkiTbIgURWIuuRPtcX7laDfFl/uD0NMNGoi97mDr
         7kLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bE9TxV1NxGv6uJxQKHxpw5wNqdc2BaAqHYvz9Wy+fwc=;
        b=ApBrYkb6gYSQrxdZh50A06oxD5Z967DOErwU6UqwW4UszA9ZJkmTyQQ14KNp7BNKFu
         pUuv076uazCieWDfpR3EiO08iprNkGO3rM7PF3EICu/nd5NYCgTHtApQ5mjR2c/jeIkg
         I53wKVQUAKbxu9NDMe46Xvb4zojTTYgaE8ljXUMH81OYz+K13sxE+ESIy7d0C0086+Bt
         +0fE03zNQwG9nrryNzJtrTy9Y1T4nYh1mgBXCaWlqVAa+7gst035T5NmWcqzhOrutgtX
         hDPBQoJxSt7UvrgeDoBiGKnegYlCRFFid0qasop8h4yfPA7679M6czhp5KIzFmaz9q3i
         kyUw==
X-Gm-Message-State: AOAM532Te/iwKvfkDFWXJzWH8FzFF7cHycQAjZZxcEePZgxcmzzlTUHL
        p3vjXkIhCP0NrCiw1J+A2wHYWKN+czJLWHLidCc=
X-Google-Smtp-Source: ABdhPJxbpOw72enS/WAszOVjZATUo1JYihbMnyiie96wVEdBZCmstMgDdxCfxx6xAR6JAc+4QJ72YN3B4Na6VzyWxzM=
X-Received: by 2002:a05:6e02:1543:: with SMTP id j3mr1020302ilu.308.1628843679474;
 Fri, 13 Aug 2021 01:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <1563961393-10301-1-git-send-email-wanpengli@tencent.com> <5ffaea5b-fb07-0141-cab8-6dce39071abe@redhat.com>
In-Reply-To: <5ffaea5b-fb07-0141-cab8-6dce39071abe@redhat.com>
From:   Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Date:   Fri, 13 Aug 2021 16:34:28 +0800
Message-ID: <CAJhGHyAY-kN-CYwoq_R2v9067fgjZVOimPOXv_kxzq8aZfFteg@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 9:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 24/07/19 11:43, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Commit 11752adb (locking/pvqspinlock: Implement hybrid PV queued/unfair=
 locks)
> > introduces hybrid PV queued/unfair locks
> >  - queued mode (no starvation)
> >  - unfair mode (good performance on not heavily contended lock)
> > The lock waiter goes into the unfair mode especially in VMs with over-c=
ommit
> > vCPUs since increaing over-commitment increase the likehood that the qu=
eue
> > head vCPU may have been preempted and not actively spinning.
> >
> > However, reschedule queue head vCPU timely to acquire the lock still ca=
n get
> > better performance than just depending on lock stealing in over-subscri=
be
> > scenario.
> >
> > Testing on 80 HT 2 socket Xeon Skylake server, with 80 vCPUs VM 80GB RA=
M:
> > ebizzy -M
> >              vanilla     boosting    improved
> >  1VM          23520        25040         6%
> >  2VM           8000        13600        70%
> >  3VM           3100         5400        74%
> >
> > The lock holder vCPU yields to the queue head vCPU when unlock, to boos=
t queue
> > head vCPU which is involuntary preemption or the one which is voluntary=
 halt
> > due to fail to acquire the lock after a short spin in the guest.
>
> Clever!  I have applied the patch.

Hello

I think this patch is very very counter-intuition.  The current vCPU
can now still continue to run, but this patch puts it on hold for a while
via yield_to().  KVM_HC_KICK_CPU is used by spin_unlock() in guest,
what if the guest CPU is in irq or in irq-disabled section, or nested
in other spin_lock(). It could add more latency to these cases.

It is convinced that the test proved the patch.  But I think we need
stronger reasoning between the code and the test (and even more tests)
since it is counter-intuition.  Why the code can boost the tests in
detail. I don't think these:

> The lock holder vCPU yields to the queue head vCPU when unlock, to boost =
queue
> head vCPU which is involuntary preemption or the one which is voluntary h=
alt
> due to fail to acquire the lock after a short spin in the guest.

are enough to explain it to me.  But I'm Okay with if this short
reason can be added to the code to reduce shockness.

At least when I glanced kvm_sched_yield() in case KVM_HC_KICK_CPU, it made
me wonder due to there is no reasoning comment before kvm_sched_yield().

Anyway, I don't object to this patch which also proves altruism is a good
strategy in the world.

Thanks
Lai

>
> Paolo
>
> > Cc: Waiman Long <longman@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 01e18ca..c6d951c 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7206,7 +7206,7 @@ static void kvm_sched_yield(struct kvm *kvm, unsi=
gned long dest_id)
> >
> >       rcu_read_unlock();
> >
> > -     if (target)
> > +     if (target && READ_ONCE(target->ready))
> >               kvm_vcpu_yield_to(target);
> >  }
> >
> > @@ -7246,6 +7246,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >               break;
> >       case KVM_HC_KICK_CPU:
> >               kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
> > +             kvm_sched_yield(vcpu->kvm, a1);
> >               ret =3D 0;
> >               break;
> >  #ifdef CONFIG_X86_64
> >
>
