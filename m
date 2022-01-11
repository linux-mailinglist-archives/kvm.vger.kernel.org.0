Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44DCC48B62A
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 19:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350239AbiAKSyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 13:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350174AbiAKSyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 13:54:17 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905CAC061751
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 10:54:16 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id i3so49992778ybh.11
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 10:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dL+btzQ+xCxXspDJaZJGykFcK855V7Nc4qMk1w8Krog=;
        b=do5RkxEiTvBJKwP8Dwceb93LhoaiHtrVK3rpQLZL6591RN7aCxg+6wrPkIfrG+3vx2
         HZkeIHoe4AJ6wOHohpMrkiWbIOacLU6s2IyUsIXNJNiIK0g0t+oib5q4qKKfEC3MhWj2
         GQZUli8+aMDP731VX5OnkTNhIACQdB3JbOekC2lsqiITasdmocNW3gVj5WGQSo03IVpZ
         KGevY2wEgZdHPI7Dut+Y6Br/2su6UD48i9VKEk0Nfz81VvW8+YOPRnlaz8bGElKfazWR
         zD7scaBip1NPm0RwZdW9zkGduOghl2GO3aPzMVIKp12HHtga1ELUBnND7Rus/2DHk/Rp
         YTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dL+btzQ+xCxXspDJaZJGykFcK855V7Nc4qMk1w8Krog=;
        b=qGgZuL58UBSc6NhshZRt/eERV6uGSbzkZd/YDNPT/I+1qvYZmOLhiBDjoXezt0r0CP
         wAuLrFckH8YDNHnvsdemGCfjZw5/QmenSTVXdG3WLfKisR3dDwm6OzyJgSWF3pqQjPH5
         Ryv0kkV5wYaYsJ/6GXdFoMqipH8EEuBXiA4JxNvy4VzhGhsRTSk2hHYPQaCh+/gmGn5k
         t3sozsoaMzAlsNWWr8sbLPL/Y1PP0bHEJfEj/riPtThv/AtftkZZFjw3jXTAMMsxogaT
         Ed+q1Rk9T5JonaW9xEWf3whNTzECk+Yf9RppCHuKRBBfhFWLPcDfrN7EQ7sCQgSEdSbI
         OUuQ==
X-Gm-Message-State: AOAM532KgkBe595DSUG788DHAHvmcgljcOEzIB+ceSrRmyr7/6HrXt10
        41yySJWqizDfPRXjMkGXICB9gDTXVuFE4KPKkYPcaw==
X-Google-Smtp-Source: ABdhPJzdKh4TYtVP9wJaIC9WtAXx8WjDTCq5KBT609w0WccuH6YBlrmVHkTjxZ89JzWrJ3ZhBf1h0/HOXcQQkM4gZ+8=
X-Received: by 2002:a25:c841:: with SMTP id y62mr8493349ybf.196.1641927255567;
 Tue, 11 Jan 2022 10:54:15 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
 <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com> <CAAeT=FwfjUiaWAJHCEqTCyu9PRr+JEKx1v0P-CJ=2-yGBvaGbA@mail.gmail.com>
In-Reply-To: <CAAeT=FwfjUiaWAJHCEqTCyu9PRr+JEKx1v0P-CJ=2-yGBvaGbA@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 11 Jan 2022 10:54:05 -0800
Message-ID: <CAJHc60zTkVb6LJDrYLrYgZ8dDigcAFkCq9sr96g4Lz0fkVGROw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/11] KVM: Capture VM start
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 4:04 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> On Fri, Jan 7, 2022 at 3:43 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
> > >
> > > Hi Raghu,
> > >
> > > On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> > > <rananta@google.com> wrote:
> > > >
> > > > Capture the start of the KVM VM, which is basically the
> > > > start of any vCPU run. This state of the VM is helpful
> > > > in the upcoming patches to prevent user-space from
> > > > configuring certain VM features after the VM has started
> > > > running.
> > > >
> > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > ---
> > > >  include/linux/kvm_host.h | 3 +++
> > > >  virt/kvm/kvm_main.c      | 9 +++++++++
> > > >  2 files changed, 12 insertions(+)
> > > >
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index c310648cc8f1..d0bd8f7a026c 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -623,6 +623,7 @@ struct kvm {
> > > >         struct notifier_block pm_notifier;
> > > >  #endif
> > > >         char stats_id[KVM_STATS_NAME_SIZE];
> > > > +       bool vm_started;
> > >
> > > Since KVM_RUN on any vCPUs doesn't necessarily mean that the VM
> > > started yet, the name might be a bit misleading IMHO.  I would
> > > think 'has_run_once' or 'ran_once' might be more clear (?).
> > >
> > I always struggle with the names; but if you feel that 'ran_once'
> > makes more sense for a reader, I can change it.
>
> I would prefer 'ran_once'.
>
Yes, that makes sense. I think the name created a lot of confusion for
the patch.

Thanks,
Raghavendra
>
> > > >  };
> > > >
> > > >  #define kvm_err(fmt, ...) \
> > > > @@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
> > > >         }
> > > >  }
> > > >
> > > > +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> > > > +
> > > >  extern bool kvm_rebooting;
> > > >
> > > >  extern unsigned int halt_poll_ns;
> > > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > > index 72c4e6b39389..962b91ac2064 100644
> > > > --- a/virt/kvm/kvm_main.c
> > > > +++ b/virt/kvm/kvm_main.c
> > > > @@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> > > >         int r;
> > > >         struct kvm_fpu *fpu = NULL;
> > > >         struct kvm_sregs *kvm_sregs = NULL;
> > > > +       struct kvm *kvm = vcpu->kvm;
> > > >
> > > >         if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
> > > >                 return -EIO;
> > > > @@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
> > > >                         if (oldpid)
> > > >                                 synchronize_rcu();
> > > >                         put_pid(oldpid);
> > > > +
> > > > +                       /*
> > > > +                        * Since we land here even on the first vCPU run,
> > > > +                        * we can mark that the VM has started running.
> > > > +                        */
> > >
> > > It might be nicer to add a comment why the code below gets kvm->lock.
> > >
> > I've been going back and forth on this one. Initially I considered
> > simply going with atomic_t, but the patch 4/11 (KVM: arm64: Setup a
> > framework for hypercall bitmap firmware registers)
> > kvm_arm_set_fw_reg_bmap()'s implementation felt like we need a lock to
> > have the whole 'is the register busy?' operation atomic. But, that's
> > just one of the applications.
>
> I understand why you need the code to get the lock here with the
> current implementation.
> But, since the code just set the one field (vm_started) with the lock,
> I thought the intention of getting the lock might not be so obvious.
> (But, maybe clear enough looking at the code in the patch-4)
>
> Thanks,
> Reiji
>
>
> > > Anyway, the patch generally looks good to me, and thank you
> > > for making this change (it works for my purpose as well).
> > >
> > > Reviewed-by: Reiji Watanabe <reijiw@google.com>
> > >
> > Glad that it's helping you as well and thanks for the review.
> >
> > Regards,
> > Raghavendra
> >
> > > Thanks,
> > > Reiji
> > >
> > >
> > > > +                       mutex_lock(&kvm->lock);
> > > > +                       kvm->vm_started = true;
> > > > +                       mutex_unlock(&kvm->lock);
> > > >                 }
> > > >                 r = kvm_arch_vcpu_ioctl_run(vcpu);
> > > >                 trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
> > > > --
> > > > 2.34.1.448.ga2b2bfdf31-goog
> > > >
