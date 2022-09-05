Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4665AD36B
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 15:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbiIENHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 09:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiIENH2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 09:07:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEB01FCFC;
        Mon,  5 Sep 2022 06:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C90B81141;
        Mon,  5 Sep 2022 13:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6BBC433D6;
        Mon,  5 Sep 2022 13:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662383244;
        bh=7g8Fl87EiIp0MAGm2fwDOr/M7eySmwTBGpTA8Hg0++c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TaU9odUXlZlOd8u9PAlqDRvhOHq3qcUmnL8iqNaA4dtLhcqMyMyve+QOtg94AVHmI
         bvshf8Ju+nL5NnLa4jx8j99rwxheJ3d2Rg45gZyeSZ/pxLYJ/Q6yVWnJgC3fGBaMiY
         SnOGn1OFB5TD6B4UR9L6qFjK5GFSQLkt/vUIxMKoovZ+VrS8Dh9IMMTA3F2ZJzkBqe
         6ACcQz9MMpK9iQEidp7N5y0Ow+WI9wPO4Eiw8Dr+frDwnLm6Jk27PpOtpSvItbJwtB
         NlkwBcQfz16+Gd9c7MFj+rcz3SjdVV7KR791+zKZeHubDrwSBBCCOvrODXToO6yP70
         /Zn3E9RPQ94sA==
Date:   Mon, 5 Sep 2022 20:58:03 +0800
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Guo Ren <guoren@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
Message-ID: <YxXyW18HtN6alf1E@xhacker>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <20220831175920.2806-5-jszhang@kernel.org>
 <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
 <YxWYh5C5swlyobi2@linutronix.de>
 <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 05, 2022 at 04:33:54PM +0800, Guo Ren wrote:
> On Mon, Sep 5, 2022 at 2:34 PM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> >
> > On 2022-09-04 23:16:12 [+0800], Guo Ren wrote:
> > > > diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
> > > > index b9eda3fcbd6d..595100a4c2c7 100644
> > > > --- a/arch/riscv/kernel/entry.S
> > > > +++ b/arch/riscv/kernel/entry.S
> > > > @@ -361,9 +361,14 @@ restore_all:
> > > >  resume_kernel:
> > > >         REG_L s0, TASK_TI_PREEMPT_COUNT(tp)
> > > >         bnez s0, restore_all
> > > > -       REG_L s0, TASK_TI_FLAGS(tp)
> > > > -       andi s0, s0, _TIF_NEED_RESCHED
> > > > +       REG_L s1, TASK_TI_FLAGS(tp)
> > > > +       andi s0, s1, _TIF_NEED_RESCHED
> > > > +       bnez s0, 1f
> > > > +       REG_L s0, TASK_TI_PREEMPT_LAZY_COUNT(tp)
> > > > +       bnez s0, restore_all
> > > > +       andi s0, s1, _TIF_NEED_RESCHED_LAZY
> > > Can you tell me, who increased/decreased the PREEMPT_LAZY_COUNT? And
> > > who set NEED_RESCHED_LAZY?
> >
> > There is "generic" code in the PREEMPT_RT patch doing that. The counter
> > is incremented/ decremented via preempt_lazy_enable()/disable() and one
> > of the user is migrate_disable()/enable().
> > Basically if a task is task_is_realtime() then NEED_RESCHED is set for
> > the wakeup. For the remaining states (SCHED_OTHER, …) NEED_RESCHED_LAZY
> > is set for the wakeup. This can be delayed if the task is in a "preempt
> > disable lazy" section (similar to a preempt_disable() section) but a
> > task_is_realtime() can still be scheduled if needed.
> Okay, It should be [PATCH RT]. RISC-V would also move to GENERIC_ENTRY

As said in the cover letter, this patch is expected to reviewed and
maintained in RT tree. If your GENERIC_ENTRY patches are merged, I will
send an updated patch.

> [1], so above assembly code would be replaced by generic one, right?
> 
> [1]: https://lore.kernel.org/linux-riscv/20220904072637.8619-3-guoren@kernel.org/T/#u
> 
> 
> > See details at
> >         https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/plain/patches/sched__Add_support_for_lazy_preemption.patch?h=linux-6.0.y-rt-patches
> 
> 
> >
> > Sebastian
> 
> 
> 
> -- 
> Best Regards
>  Guo Ren
