Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32CE5ACE1D
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 10:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiIEIg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 04:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbiIEIgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 04:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CA11821;
        Mon,  5 Sep 2022 01:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1CE6261183;
        Mon,  5 Sep 2022 08:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B817C43470;
        Mon,  5 Sep 2022 08:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662366847;
        bh=MFwr+ylrLqHsUdJos34a0n+CwOKCUfeTFHhIzjgR+eQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j36VktyFiKHbg5ZEF7eYwQw14//bO1WbHu8aKGzTeWRY2j1Zt0QCjLlOkiP9s+DYN
         56x38j43KsQwIm5I5734SyOvrRGvbdcy3709mYXgngkHE0GznBxnPOO0Pb6I5QV6gL
         k6eraIABCQjLDq4W3clDn29nde1Lcb5JehshdjtMlSukBy6CUtdsHopsJ+df1pzB0S
         leqQ1MkQ9MSzmQ82nHEidJ5l5tKuPVJxKfw6SCnFA3V77X4kTg5YTUM2IE3aMAyVb1
         pzDYNpFf9Ar+yJ++X+4jR5k1kJkl1AdRkUNRq7N+0lV4qBpkoOHIBMNsGcarMxIIq4
         1ZSsrLC67d8CA==
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1274ec87ad5so5011351fac.0;
        Mon, 05 Sep 2022 01:34:07 -0700 (PDT)
X-Gm-Message-State: ACgBeo3WP6pGCQK+AHttfilcGZBtW5QTsobY87WtXZGDXDDXbM9bHXOU
        sb76jl0Yfrm7A7NTwKRuF2LYWkSayuZlvn6nYNM=
X-Google-Smtp-Source: AA6agR5IglQGOyI7jNiRY0ei+A9SaaYr4Yxhd7s10i4P669D16mJGNnghE8P/xcvEucKgIbX3phIaTViycxWEFtW7D0=
X-Received: by 2002:a05:6870:7092:b0:11e:ff3a:d984 with SMTP id
 v18-20020a056870709200b0011eff3ad984mr8071019oae.19.1662366846586; Mon, 05
 Sep 2022 01:34:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220831175920.2806-1-jszhang@kernel.org> <20220831175920.2806-5-jszhang@kernel.org>
 <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com> <YxWYh5C5swlyobi2@linutronix.de>
In-Reply-To: <YxWYh5C5swlyobi2@linutronix.de>
From:   Guo Ren <guoren@kernel.org>
Date:   Mon, 5 Sep 2022 16:33:54 +0800
X-Gmail-Original-Message-ID: <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
Message-ID: <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] riscv: add lazy preempt support
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 5, 2022 at 2:34 PM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2022-09-04 23:16:12 [+0800], Guo Ren wrote:
> > > diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> > > index b9eda3fcbd6d..595100a4c2c7 100644
> > > --- a/arch/riscv/kernel/entry.S
> > > +++ b/arch/riscv/kernel/entry.S
> > > @@ -361,9 +361,14 @@ restore_all:
> > >  resume_kernel:
> > >         REG_L s0, TASK_TI_PREEMPT_COUNT(tp)
> > >         bnez s0, restore_all
> > > -       REG_L s0, TASK_TI_FLAGS(tp)
> > > -       andi s0, s0, _TIF_NEED_RESCHED
> > > +       REG_L s1, TASK_TI_FLAGS(tp)
> > > +       andi s0, s1, _TIF_NEED_RESCHED
> > > +       bnez s0, 1f
> > > +       REG_L s0, TASK_TI_PREEMPT_LAZY_COUNT(tp)
> > > +       bnez s0, restore_all
> > > +       andi s0, s1, _TIF_NEED_RESCHED_LAZY
> > Can you tell me, who increased/decreased the PREEMPT_LAZY_COUNT? And
> > who set NEED_RESCHED_LAZY?
>
> There is "generic" code in the PREEMPT_RT patch doing that. The counter
> is incremented/ decremented via preempt_lazy_enable()/disable() and one
> of the user is migrate_disable()/enable().
> Basically if a task is task_is_realtime() then NEED_RESCHED is set for
> the wakeup. For the remaining states (SCHED_OTHER, =E2=80=A6) NEED_RESCHE=
D_LAZY
> is set for the wakeup. This can be delayed if the task is in a "preempt
> disable lazy" section (similar to a preempt_disable() section) but a
> task_is_realtime() can still be scheduled if needed.
Okay, It should be [PATCH RT]. RISC-V would also move to GENERIC_ENTRY
[1], so above assembly code would be replaced by generic one, right?

[1]: https://lore.kernel.org/linux-riscv/20220904072637.8619-3-guoren@kerne=
l.org/T/#u


> See details at
>         https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel=
.git/plain/patches/sched__Add_support_for_lazy_preemption.patch?h=3Dlinux-6=
.0.y-rt-patches


>
> Sebastian



--=20
Best Regards
 Guo Ren
