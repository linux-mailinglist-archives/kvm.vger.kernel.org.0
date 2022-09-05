Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D540D5ACB17
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 08:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiIEGfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 02:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbiIEGfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 02:35:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A22175AC;
        Sun,  4 Sep 2022 23:34:51 -0700 (PDT)
Date:   Mon, 5 Sep 2022 08:34:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662359689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymTw5XBMYgKVIeJh9aYTiMBe+I7d6R0sABW/gVPUNZY=;
        b=1JYwlslTPGKZVLWAgIQLOvrV5cS2f8XDBRsTxuEp4kuwx1izZCcslOZ3ouAyPBRPJAUipU
        8hkT40r2lrqxV36uNBcdu6GN3k+gRKy3A20Vfb6aDcTfykHqDETNrXxGNLsp1dkOwui7sv
        B+Upmccg8S3ynJn9P9xaZfzpC9gEedcnDR9EsaLT2GYIdQTtWEIxHR3w3lPPTqO+4IlQBe
        utoikxUCGJsQJnsm62aE3NQbaK+DGcg2mpPDh5mNL7Uj7HWjtLCUY/JHwTqdpUpvovO455
        AFcOc0s6k6weRuTpTXJkwfVeuKT6biMkgP3aRmN95R6tmvP3EE3MLdZx5GFb/A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662359689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymTw5XBMYgKVIeJh9aYTiMBe+I7d6R0sABW/gVPUNZY=;
        b=c1FZvonWTQ4c1SjsgaR7+xk9CjbBSZWzEPYyI813LvRBHJzV4x3X5FgF3oZajvj+l/9uTs
        x7xDwB890V4ZC4DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Guo Ren <guoren@kernel.org>
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
Subject: Re: [PATCH v2 4/5] riscv: add lazy preempt support
Message-ID: <YxWYh5C5swlyobi2@linutronix.de>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <20220831175920.2806-5-jszhang@kernel.org>
 <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-04 23:16:12 [+0800], Guo Ren wrote:
> > diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> > index b9eda3fcbd6d..595100a4c2c7 100644
> > --- a/arch/riscv/kernel/entry.S
> > +++ b/arch/riscv/kernel/entry.S
> > @@ -361,9 +361,14 @@ restore_all:
> >  resume_kernel:
> >         REG_L s0, TASK_TI_PREEMPT_COUNT(tp)
> >         bnez s0, restore_all
> > -       REG_L s0, TASK_TI_FLAGS(tp)
> > -       andi s0, s0, _TIF_NEED_RESCHED
> > +       REG_L s1, TASK_TI_FLAGS(tp)
> > +       andi s0, s1, _TIF_NEED_RESCHED
> > +       bnez s0, 1f
> > +       REG_L s0, TASK_TI_PREEMPT_LAZY_COUNT(tp)
> > +       bnez s0, restore_all
> > +       andi s0, s1, _TIF_NEED_RESCHED_LAZY
> Can you tell me, who increased/decreased the PREEMPT_LAZY_COUNT? And
> who set NEED_RESCHED_LAZY?

There is "generic" code in the PREEMPT_RT patch doing that. The counter
is incremented/ decremented via preempt_lazy_enable()/disable() and one
of the user is migrate_disable()/enable().
Basically if a task is task_is_realtime() then NEED_RESCHED is set for
the wakeup. For the remaining states (SCHED_OTHER, =E2=80=A6) NEED_RESCHED_=
LAZY
is set for the wakeup. This can be delayed if the task is in a "preempt
disable lazy" section (similar to a preempt_disable() section) but a
task_is_realtime() can still be scheduled if needed.
See details at
	https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/plai=
n/patches/sched__Add_support_for_lazy_preemption.patch?h=3Dlinux-6.0.y-rt-p=
atches

Sebastian
