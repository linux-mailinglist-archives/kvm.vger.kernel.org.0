Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52AAB4C60B9
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 02:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiB1B7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Feb 2022 20:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbiB1B7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Feb 2022 20:59:40 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915BE3DDF2
        for <kvm@vger.kernel.org>; Sun, 27 Feb 2022 17:59:02 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id bt13so17549037ybb.2
        for <kvm@vger.kernel.org>; Sun, 27 Feb 2022 17:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hKKnafMuvL+k7uMKl6Y2H5aCo90HZR2FULFwDzu+Vw=;
        b=bSFtGkkzu1xs36jAzbD6kiZjtaN1CWgfqh2ZWb0VUQPM6Nn0i3t2ptXecBJSYi3Wgg
         U04RMTDlkMK7KjQC/go5CmcDb5FkAy3BQbWm/rkvdrmjvWf4GpUeIp8o23hWPKlhgBan
         LKNZ+ihTAgoZzbfOlTAcjKrxjAoTlZ40ZNUKaAPyJNlMCdk8wgp4XdPhEjXHhl8NRuuR
         Y74x/07WLx3AsP6f90pz9/BOW2ns8XWdCmw2hYT6yFQ5QIRhUQzbHmSvtfQ76m27tMD7
         Kf6n6PBhTJ+C8bkcgORs7BlCdactKskifS0yXImyRCXpid513FKtQs1FkZ8fy+ic6cL5
         ZUlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hKKnafMuvL+k7uMKl6Y2H5aCo90HZR2FULFwDzu+Vw=;
        b=e5WOMZ/lfJ76xeAaUhN475X5GaM1iep61quvYkXV+9xJ/4Cw49Z9fGgcm03ngs2DVq
         pDRkhCdjSYzW5WtCKjKF/PgMmLffW9GxhDEynyoa4NQqgus0fDGF2LqawWopswbqt24A
         EXyn58/OvPFkfr13Nl0vlGdXVzaXfuC06orRPsqTO9kPAjIhKUdInOWTaXJhSLbLY5RN
         /MH0oG/ddVHzCbNwqB1l6ku7QSGY09rYCeSaPvOdHrvtDfaeno98zX0vZetUlHhHQs0U
         eMmHmkLZwbTfT4MUDmQJmkU8HRAXUVVa6dqYtD9FdkH1gE+KaNVlHIFmzRKNT6i343rN
         EMMg==
X-Gm-Message-State: AOAM530SPrWFL3hXjCBgu8jklVMuSl6SBPLQJOLAqwqrcPl7ccfXE9d2
        cnIGJXDzSodJzUJr6XppATVIE5FZemCV6HY8jdg=
X-Google-Smtp-Source: ABdhPJwlyas0z2oZ7Fj29qdLJvPgHIS3YvYobMs8yTkK/tOb3F3tB25fwqm9TR4FcyWKVRQPjTFfBTR4bA+wcF81tmg=
X-Received: by 2002:a5b:891:0:b0:624:907a:79bf with SMTP id
 e17-20020a5b0891000000b00624907a79bfmr16582780ybq.178.1646013541753; Sun, 27
 Feb 2022 17:59:01 -0800 (PST)
MIME-Version: 1.0
References: <1645760664-26028-1-git-send-email-lirongqing@baidu.com>
 <CANRm+Czf8Ge4cMKrccq5yEbR=_bsCr-OxXpy0RVV4uk5vxR5yA@mail.gmail.com> <5b07dc0d6b164016af09704546aa07b5@baidu.com>
In-Reply-To: <5b07dc0d6b164016af09704546aa07b5@baidu.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 28 Feb 2022 09:58:50 +0800
Message-ID: <CANRm+CxDEe-cvdVOLE_Chq8LdX96R+w5z53OxYiWB2wVJLQr+w@mail.gmail.com>
Subject: Re: [PATCH][resend] KVM: x86: Yield to IPI target vCPU only if it is busy
To:     "Li,Rongqing" <lirongqing@baidu.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Feb 2022 at 09:27, Li,Rongqing <lirongqing@baidu.com> wrote:
>
> > On Fri, 25 Feb 2022 at 23:04, Li RongQing <lirongqing@baidu.com> wrote:
> > >
> > > When sending a call-function IPI-many to vCPUs, yield to the IPI
> > > target vCPU which is marked as preempted.
> > >
> > > but when emulating HLT, an idling vCPU will be voluntarily scheduled
> > > out and mark as preempted from the guest kernel perspective. yielding
> > > to idle vCPU is pointless and increase unnecessary vmexit, maybe miss
> > > the true preempted vCPU
> > >
> > > so yield to IPI target vCPU only if vCPU is busy and preempted
> >
> > This is not correct, there is an intention to boost the reactivation of idle vCPU,
> > PV sched yield is used in over-subscribe scenario and the pCPU which idle vCPU is
> > resident maybe busy, and the vCPU will wait in the host scheduler run queue.
> > There is a research paper [1] focusing on this boost and showing better
> > performance numbers, though their boost is more unfair.
> >
> > [1]. https://ieeexplore.ieee.org/document/8526900
> > "Accelerating Idle vCPU Reactivation"
> >
> >     Wanpeng
>
>
> I understand that over-subscribe system is not always over- subscribe, it should sometime true, sometime not.

You should pay the pain if you do not tune your setup well.

    Wanpeng
