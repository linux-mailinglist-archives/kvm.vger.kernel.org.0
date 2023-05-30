Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7896715B27
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 12:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjE3KMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 06:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231455AbjE3KLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 06:11:45 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A2115
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 03:11:38 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2af29b37bd7so45150171fa.1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 03:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685441496; x=1688033496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egMhbTKkclM967pMsKZ5ver0kUWnLswQow66f1F6DYU=;
        b=i96LJtr+7RGmqljqe27LJRp/Uhid+WvYssK/GFqplFgYHpUqiAS4KTkbudRL/L4xPp
         wB7OCBYr2L2/MM461al1wSe6xLSkEycQqqc/EiaGsw8IlBuisaQA/nWsWe/mwylE8Q4G
         qanvvaamiNZJM75lmOKcwvBGapCoPsMrZ05pURTL7NV1+4Mz1gTrPok1EkGlFThtLBhA
         HKhTFiqMhr9MWtFfyrWqze7CXM7ClJFV4IkbOowQa0UTnJ5khNWcanQ1hRJpjDTtMjCD
         gWPhlKLjk/eCoV7MHo4dx009RZhf0VB0uUEMJMmonuFkZmld89EwdAAsa8E/Dn3AKzJD
         a8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685441496; x=1688033496;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egMhbTKkclM967pMsKZ5ver0kUWnLswQow66f1F6DYU=;
        b=BfuGnFQfsQaZ/jKkMt2qqBC8WEEHfPFSEDZOwyySDxbbGE+6vvYeTwmG/cE+D/2o7z
         L3dCwe5wtdMLMTov59uCtja+LTxM+H27yOjH3pDtVC6IEt4aMSp7tB9L9FVXg8hIO3zk
         o9lvesGdybb7PEOCz/1kjhqd0/Q4eVfHg/ZFqmMjXiISJnXy1iAwVrCdPC3CkBhlEryF
         QpflpnwI1YCqat2Eyzm7BMJa7HeDNXlh/ETt9JMId4kyA3P2FmztC99Fg7Kz9di7F2cx
         wGKAnam1xb4ItgK+wEaWDfeRahRHoPGWYqzpTPudMYYakQOmVefpXYx2SWs65iXLlEPL
         IzAg==
X-Gm-Message-State: AC+VfDwUSzTvrApo1wrdbNjOUyYkSIOjt1FEGaVh8FV/wBZ5D1kewDlR
        HzNIZufSy2QdOxnt87IZmv/AOTUQFHLOIl1iwKyUCg==
X-Google-Smtp-Source: ACHHUZ6ec56xGdI2GYmu9XhF4T8bqxCxAsr6Yr7rh0/NnpfS0Ea//4Fxt9mmiBvT09dqjH4FMtY5dV3Z1h5eNO7Qmek=
X-Received: by 2002:a2e:9e89:0:b0:2af:2786:2712 with SMTP id
 f9-20020a2e9e89000000b002af27862712mr581793ljk.25.1685441496180; Tue, 30 May
 2023 03:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230518161949.11203-11-andy.chiu@sifive.com> <mhng-52fef833-2cdd-40c7-ba64-ef12da3fa853@palmer-ri-x1c9a>
In-Reply-To: <mhng-52fef833-2cdd-40c7-ba64-ef12da3fa853@palmer-ri-x1c9a>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 30 May 2023 18:11:25 +0800
Message-ID: <CABgGipUo3-HJobQ+eO44eHCvepaGfGF+yPOHq8nPf2yUCXEEpw@mail.gmail.com>
Subject: Re: [PATCH -next v20 10/26] riscv: Add task switch support for vector
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     linux-riscv@lists.infradead.org, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Vineet Gupta <vineetg@rivosinc.com>,
        greentime.hu@sifive.com, guoren@linux.alibaba.com,
        nick.knight@sifive.com, vincent.chen@sifive.com,
        ruinland.tsai@sifive.com, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, guoren@kernel.org, heiko.stuebner@vrull.eu,
        wangkefeng.wang@huawei.com, sunilvl@ventanamicro.com,
        Conor Dooley <conor.dooley@microchip.com>, jszhang@kernel.org,
        Bjorn Topel <bjorn@rivosinc.com>, peterz@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 8:49=E2=80=AFAM Palmer Dabbelt <palmer@dabbelt.com>=
 wrote:
>
> On Thu, 18 May 2023 09:19:33 PDT (-0700), andy.chiu@sifive.com wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> >
> > This patch adds task switch support for vector. It also supports all
> > lengths of vlen.
> >
> > Suggested-by: Andrew Waterman <andrew@sifive.com>
> > Co-developed-by: Nick Knight <nick.knight@sifive.com>
> > Signed-off-by: Nick Knight <nick.knight@sifive.com>
> > Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> > Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> > Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> > Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> > Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> > Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
> > Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > ---
> >  arch/riscv/include/asm/processor.h   |  1 +
> >  arch/riscv/include/asm/switch_to.h   |  3 +++
> >  arch/riscv/include/asm/thread_info.h |  3 +++
> >  arch/riscv/include/asm/vector.h      | 38 ++++++++++++++++++++++++++++
> >  arch/riscv/kernel/process.c          | 18 +++++++++++++
> >  5 files changed, 63 insertions(+)
> >
> > diff --git a/arch/riscv/include/asm/processor.h b/arch/riscv/include/as=
m/processor.h
> > index 94a0590c6971..f0ddf691ac5e 100644
> > --- a/arch/riscv/include/asm/processor.h
> > +++ b/arch/riscv/include/asm/processor.h
> > @@ -39,6 +39,7 @@ struct thread_struct {
> >       unsigned long s[12];    /* s[0]: frame pointer */
> >       struct __riscv_d_ext_state fstate;
> >       unsigned long bad_cause;
> > +     struct __riscv_v_ext_state vstate;
> >  };
> >
> >  /* Whitelist the fstate from the task_struct for hardened usercopy */
> > diff --git a/arch/riscv/include/asm/switch_to.h b/arch/riscv/include/as=
m/switch_to.h
> > index 4b96b13dee27..a727be723c56 100644
> > --- a/arch/riscv/include/asm/switch_to.h
> > +++ b/arch/riscv/include/asm/switch_to.h
> > @@ -8,6 +8,7 @@
> >
> >  #include <linux/jump_label.h>
> >  #include <linux/sched/task_stack.h>
> > +#include <asm/vector.h>
> >  #include <asm/hwcap.h>
> >  #include <asm/processor.h>
> >  #include <asm/ptrace.h>
> > @@ -78,6 +79,8 @@ do {                                                 =
       \
> >       struct task_struct *__next =3D (next);            \
> >       if (has_fpu())                                  \
> >               __switch_to_fpu(__prev, __next);        \
> > +     if (has_vector())                                       \
> > +             __switch_to_vector(__prev, __next);     \
> >       ((last) =3D __switch_to(__prev, __next));         \
> >  } while (0)
> >
> > diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/=
asm/thread_info.h
> > index e0d202134b44..97e6f65ec176 100644
> > --- a/arch/riscv/include/asm/thread_info.h
> > +++ b/arch/riscv/include/asm/thread_info.h
> > @@ -81,6 +81,9 @@ struct thread_info {
> >       .preempt_count  =3D INIT_PREEMPT_COUNT,   \
> >  }
> >
> > +void arch_release_task_struct(struct task_struct *tsk);
> > +int arch_dup_task_struct(struct task_struct *dst, struct task_struct *=
src);
> > +
> >  #endif /* !__ASSEMBLY__ */
> >
> >  /*
> > diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/v=
ector.h
> > index 3c29f4eb552a..ce6a75e9cf62 100644
> > --- a/arch/riscv/include/asm/vector.h
> > +++ b/arch/riscv/include/asm/vector.h
> > @@ -12,6 +12,9 @@
> >  #ifdef CONFIG_RISCV_ISA_V
> >
> >  #include <linux/stringify.h>
> > +#include <linux/sched.h>
> > +#include <linux/sched/task_stack.h>
> > +#include <asm/ptrace.h>
> >  #include <asm/hwcap.h>
> >  #include <asm/csr.h>
> >  #include <asm/asm.h>
> > @@ -124,6 +127,38 @@ static inline void __riscv_v_vstate_restore(struct=
 __riscv_v_ext_state *restore_
> >       riscv_v_disable();
> >  }
> >
> > +static inline void riscv_v_vstate_save(struct task_struct *task,
> > +                                    struct pt_regs *regs)
> > +{
> > +     if ((regs->status & SR_VS) =3D=3D SR_VS_DIRTY) {
> > +             struct __riscv_v_ext_state *vstate =3D &task->thread.vsta=
te;
> > +
> > +             __riscv_v_vstate_save(vstate, vstate->datap);
> > +             __riscv_v_vstate_clean(regs);
> > +     }
> > +}
> > +
> > +static inline void riscv_v_vstate_restore(struct task_struct *task,
> > +                                       struct pt_regs *regs)
> > +{
> > +     if ((regs->status & SR_VS) !=3D SR_VS_OFF) {
> > +             struct __riscv_v_ext_state *vstate =3D &task->thread.vsta=
te;
> > +
> > +             __riscv_v_vstate_restore(vstate, vstate->datap);
> > +             __riscv_v_vstate_clean(regs);
> > +     }
> > +}
> > +
> > +static inline void __switch_to_vector(struct task_struct *prev,
> > +                                   struct task_struct *next)
> > +{
> > +     struct pt_regs *regs;
> > +
> > +     regs =3D task_pt_regs(prev);
> > +     riscv_v_vstate_save(prev, regs);
> > +     riscv_v_vstate_restore(next, task_pt_regs(next));
> > +}
> > +
> >  #else /* ! CONFIG_RISCV_ISA_V  */
> >
> >  struct pt_regs;
> > @@ -132,6 +167,9 @@ static inline int riscv_v_setup_vsize(void) { retur=
n -EOPNOTSUPP; }
> >  static __always_inline bool has_vector(void) { return false; }
> >  static inline bool riscv_v_vstate_query(struct pt_regs *regs) { return=
 false; }
> >  #define riscv_v_vsize (0)
> > +#define riscv_v_vstate_save(task, regs)              do {} while (0)
> > +#define riscv_v_vstate_restore(task, regs)   do {} while (0)
> > +#define __switch_to_vector(__prev, __next)   do {} while (0)
> >  #define riscv_v_vstate_off(regs)             do {} while (0)
> >  #define riscv_v_vstate_on(regs)                      do {} while (0)
> >
> > diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> > index e2a060066730..b7a10361ddc6 100644
> > --- a/arch/riscv/kernel/process.c
> > +++ b/arch/riscv/kernel/process.c
> > @@ -24,6 +24,7 @@
> >  #include <asm/switch_to.h>
> >  #include <asm/thread_info.h>
> >  #include <asm/cpuidle.h>
> > +#include <asm/vector.h>
> >
> >  register unsigned long gp_in_global __asm__("gp");
> >
> > @@ -146,12 +147,28 @@ void flush_thread(void)
> >       fstate_off(current, task_pt_regs(current));
> >       memset(&current->thread.fstate, 0, sizeof(current->thread.fstate)=
);
> >  #endif
> > +#ifdef CONFIG_RISCV_ISA_V
> > +     /* Reset vector state */
> > +     riscv_v_vstate_off(task_pt_regs(current));
> > +     kfree(current->thread.vstate.datap);
> > +     memset(&current->thread.vstate, 0, sizeof(struct __riscv_v_ext_st=
ate));
> > +#endif
> > +}
> > +
> > +void arch_release_task_struct(struct task_struct *tsk)
> > +{
> > +     /* Free the vector context of datap. */
> > +     if (has_vector())
> > +             kfree(tsk->thread.vstate.datap);
> >  }
> >
> >  int arch_dup_task_struct(struct task_struct *dst, struct task_struct *=
src)
> >  {
> >       fstate_save(src, task_pt_regs(src));
> >       *dst =3D *src;
> > +     /* clear entire V context, including datap for a new task */
> > +     memset(&dst->thread.vstate, 0, sizeof(struct __riscv_v_ext_state)=
);
> > +
> >       return 0;
> >  }
> >
> > @@ -184,6 +201,7 @@ int copy_thread(struct task_struct *p, const struct=
 kernel_clone_args *args)
> >               p->thread.s[0] =3D 0;
> >       }
> >       p->thread.ra =3D (unsigned long)ret_from_fork;
> > +     riscv_v_vstate_off(childregs);
>
> When is V still on at this point?  If we got here via clone() (or any
> other syscall) it should be off already, so if we need to turn it off
> here then we must have arrived via something that's not a syscall.  I
> don't know what that case is, so it's not clear we can just throw away
> the V state.

I think we should move this callsite into the else clause of the
previous if-else statement. We must clear status.VS for every newly
forked process in order to make the first-use trap work. Since a
parent process may fork a child after the parent obtains a valid V
context in the first-use trap, and has status.VS enabled. Then, all
register contents are copied into child's, including the status.VS at
L:196. If we do not specifically turn off V after the copy, then we
will break the determination of  first-use trap and scheduling
routing, where the kernel assumes a valid V context exists if it sees
status.VS not being "OFF".

For the kernel thread we don't need to make this call because status
is set to SR_PP | SR_PIE for all.

>
> >       p->thread.sp =3D (unsigned long)childregs; /* kernel sp */
> >       return 0;
> >  }

Cheers,
Andy
