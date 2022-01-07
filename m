Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF44D487F85
	for <lists+kvm@lfdr.de>; Sat,  8 Jan 2022 00:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiAGXnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 18:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbiAGXnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 18:43:22 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA67FC06173E
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 15:43:21 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id w184so21067460ybg.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 15:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NVQO0hqDncW10QtXjDHk2S0GMpXvaQ8aqURw+uPH5wg=;
        b=h9pJpcJm/YMBAmJgf1a/hNcRkR8eituMdmkl0QZEo6aDIhoj9bNGkybBY9tLwABtu5
         T47vLXRIGeeLHeBuPozHHi8Pl/RQ9FhfwS4CsX5VbJEm+o+wzusNHWWSGZ6TJZLlaacs
         hFudIJXMhNvmwU+GrNuWtSqOe6shbDP1H4ZddJx+9I6jJuIazgHC+dfsYqqPX1/1YHJJ
         V6XbJI3aB9kMiqAK2jOUT7R604WZYwEtYUsLXxGIeATyYFqTvRlv+xz5DCzxYDdROZ8d
         GJ29YJCzQ0FTF/sStFeSpJgFrnNnSlnbqv7RAH1xaBsdO/kGKvx5sEJyEQJfFtB47w1k
         IEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVQO0hqDncW10QtXjDHk2S0GMpXvaQ8aqURw+uPH5wg=;
        b=gjLg7KC34oCUkgghN5HZx20B1SonSTdIEYkB4IRVJIcbjQweTK068AHpB4PvEqf6wM
         s+eTDJBjWXVu8/FLZEf7cDApd3np8zr+JgOHGQ2UZixsPk4vbwNmowFowIeOxtmzxLC1
         XB2HDjlAkWlbYHT2J29XP0GIw+VXKU5hDcbStC4SjeZbHHe5I4YzTbg0L93NuWCGDXVV
         /7bIxKHiJUWAxi+LGHz0rATKnLuPsHIciHru2ep7KVZ9qc2nm8tpk7KtUEUUdSwr9+3m
         zabURQ3+ovLOP4A6I2OqlgG2gidoR0Fzwquo+PlqzGgYhNtyR7NOSwCWomXpcOi5ScX5
         o+IA==
X-Gm-Message-State: AOAM531ftEqHpO/iqhrhgDrXod8SyOMgXWZn6J5tDyPvt2CW4G1JGLbe
        PxxreKQeaHYhfvQ2RPpm+KijiSQTVusMFdbNkNPJdg==
X-Google-Smtp-Source: ABdhPJyZoQctE8XarHYHTzHFEcdEszvQRqEN4nBFLuAThhkJYA2F4ThxIao4CKuearoh3PucipTEnVqNvqht/yFdp+Q=
X-Received: by 2002:a25:c841:: with SMTP id y62mr35443827ybf.196.1641599000772;
 Fri, 07 Jan 2022 15:43:20 -0800 (PST)
MIME-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com> <20220104194918.373612-2-rananta@google.com>
 <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
In-Reply-To: <CAAeT=Fxyct=WLUvfbpROKwB9huyt+QdJnKTaj8c5NKk+UY51WQ@mail.gmail.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Fri, 7 Jan 2022 15:43:08 -0800
Message-ID: <CAJHc60za+E-zEO5v2QeKuifoXznPnt5n--g1dAN5jgsuq+SxrA@mail.gmail.com>
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

Hi Reiji,

On Thu, Jan 6, 2022 at 10:07 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Raghu,
>
> On Tue, Jan 4, 2022 at 11:49 AM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Capture the start of the KVM VM, which is basically the
> > start of any vCPU run. This state of the VM is helpful
> > in the upcoming patches to prevent user-space from
> > configuring certain VM features after the VM has started
> > running.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  include/linux/kvm_host.h | 3 +++
> >  virt/kvm/kvm_main.c      | 9 +++++++++
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index c310648cc8f1..d0bd8f7a026c 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -623,6 +623,7 @@ struct kvm {
> >         struct notifier_block pm_notifier;
> >  #endif
> >         char stats_id[KVM_STATS_NAME_SIZE];
> > +       bool vm_started;
>
> Since KVM_RUN on any vCPUs doesn't necessarily mean that the VM
> started yet, the name might be a bit misleading IMHO.  I would
> think 'has_run_once' or 'ran_once' might be more clear (?).
>
I always struggle with the names; but if you feel that 'ran_once'
makes more sense for a reader, I can change it.
>
> >  };
> >
> >  #define kvm_err(fmt, ...) \
> > @@ -1666,6 +1667,8 @@ static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
> >         }
> >  }
> >
> > +#define kvm_vm_has_started(kvm) (kvm->vm_started)
> > +
> >  extern bool kvm_rebooting;
> >
> >  extern unsigned int halt_poll_ns;
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 72c4e6b39389..962b91ac2064 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3686,6 +3686,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >         int r;
> >         struct kvm_fpu *fpu = NULL;
> >         struct kvm_sregs *kvm_sregs = NULL;
> > +       struct kvm *kvm = vcpu->kvm;
> >
> >         if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
> >                 return -EIO;
> > @@ -3723,6 +3724,14 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >                         if (oldpid)
> >                                 synchronize_rcu();
> >                         put_pid(oldpid);
> > +
> > +                       /*
> > +                        * Since we land here even on the first vCPU run,
> > +                        * we can mark that the VM has started running.
> > +                        */
>
> It might be nicer to add a comment why the code below gets kvm->lock.
>
I've been going back and forth on this one. Initially I considered
simply going with atomic_t, but the patch 4/11 (KVM: arm64: Setup a
framework for hypercall bitmap firmware registers)
kvm_arm_set_fw_reg_bmap()'s implementation felt like we need a lock to
have the whole 'is the register busy?' operation atomic. But, that's
just one of the applications.
> Anyway, the patch generally looks good to me, and thank you
> for making this change (it works for my purpose as well).
>
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
>
Glad that it's helping you as well and thanks for the review.

Regards,
Raghavendra

> Thanks,
> Reiji
>
>
> > +                       mutex_lock(&kvm->lock);
> > +                       kvm->vm_started = true;
> > +                       mutex_unlock(&kvm->lock);
> >                 }
> >                 r = kvm_arch_vcpu_ioctl_run(vcpu);
> >                 trace_kvm_userspace_exit(vcpu->run->exit_reason, r);
> > --
> > 2.34.1.448.ga2b2bfdf31-goog
> >
