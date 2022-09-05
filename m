Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0605ACE31
	for <lists+kvm@lfdr.de>; Mon,  5 Sep 2022 10:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbiIEIqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Sep 2022 04:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236650AbiIEIqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Sep 2022 04:46:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32874D4CE;
        Mon,  5 Sep 2022 01:46:45 -0700 (PDT)
Date:   Mon, 5 Sep 2022 10:46:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662367603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99mp8geWAAkeObjUx/ShqenPtDH+4Vzc9b2C8frtuew=;
        b=3bgyMX1lfzvfLarSqLyYkBCf05nax7ELI5WVXvk1hzcHWL3HXmWCpcCxKLcmuv2gR8sRZn
        RHdw5gXiNUuHF3/PVdkQ3fUBvKJO/cxGaKUIZWnnyTdu1MgjxLpiFtquoPvaIdp3pS2IYr
        m3857wZ06SavUl7uqfovdfNTPCaHHOM4+mJPbkIbrg30XnJfLJN93rOP+SatK7ktzNcXfq
        Zk5gIO5ksGB6T0LVVgVSjFY7a/Qh3BXGZTyculFX/sos0I+vjkNAiSygogFRBrYSitGIaF
        gEvWWEpTlEDtB2C311WfB34PB4yW9jSDozAe7Rq9lzuNNKqADOD2gMJKVtFy6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662367603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99mp8geWAAkeObjUx/ShqenPtDH+4Vzc9b2C8frtuew=;
        b=lwBLiyEYMKYIix4ELUfOpUUN1tyc5gpqkoZJfN8EeqhJcnSRXA7QFrq0gLcanRbscYXn8w
        c10xR98CcEPnifBg==
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
Message-ID: <YxW3cZEhEideZon2@linutronix.de>
References: <20220831175920.2806-1-jszhang@kernel.org>
 <20220831175920.2806-5-jszhang@kernel.org>
 <CAJF2gTQMM50TZZ95XOY+Rgvm2hZ3nLxkYfaSW_2MvPiJeqTtJw@mail.gmail.com>
 <YxWYh5C5swlyobi2@linutronix.de>
 <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJF2gTR=Cmcox5JrX2bB12MdmurY3vexSA6vw1cdXXbCNB8tXw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-09-05 16:33:54 [+0800], Guo Ren wrote:
> > There is "generic" code in the PREEMPT_RT patch doing that. The counter
> > is incremented/ decremented via preempt_lazy_enable()/disable() and one
> > of the user is migrate_disable()/enable().
> > Basically if a task is task_is_realtime() then NEED_RESCHED is set for
> > the wakeup. For the remaining states (SCHED_OTHER, =E2=80=A6) NEED_RESC=
HED_LAZY
> > is set for the wakeup. This can be delayed if the task is in a "preempt
> > disable lazy" section (similar to a preempt_disable() section) but a
> > task_is_realtime() can still be scheduled if needed.
> Okay, It should be [PATCH RT]. RISC-V would also move to GENERIC_ENTRY
> [1], so above assembly code would be replaced by generic one, right?

correct.

Sebastian
