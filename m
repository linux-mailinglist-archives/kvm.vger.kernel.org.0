Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD30682C9D
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 13:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjAaMeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 07:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjAaMeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 07:34:21 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0687629438
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 04:34:21 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 123so17837695ybv.6
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 04:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lqhu7Hk+UNTFHzvYJyWe2Ndz9V/GBcG2ePRKmQszGf8=;
        b=V0sMxhP16KEvIXXzY7pdlOOlnk+2oN3a3A3u0xtReGz/HDV9INbUMbNK+4/B8jIUc/
         9qHFppixcW3T2nBYh0xic1Uxe/rs3JvNrjNELV+FsIqkQDqduNHuMA/4j/P1OwyJJsZh
         KZ6cIJw0y1f/P/2Ztgui7cm82d0A0+/oDjGl00pQs9j4LuPBTsKOnjMGkI6tKNSOfUdj
         L0BEeqfH7wJ6ZWTtDn7hhOnw2WOqy1PqQASHB1B0eF4uIKxN7RSSRSoYJZ7YLg2tdl8H
         5U17SsuBifcT0/MmM7KVzFge4alC3ZCvLT8QT9wRdRdu8di1BTugZi7l146AR7xwMU3X
         m5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lqhu7Hk+UNTFHzvYJyWe2Ndz9V/GBcG2ePRKmQszGf8=;
        b=xmMcP2qNQlNNlmcj0Nv1xBTmGVt7MIhD7Sl5UUthaXF3FJcw353UgJfQ82qn/4ypAx
         OtN4w34fstnNBGMa0nP6Aa16fNQleOAgssFRUsz1AgJo8Pn7OciOBBDxNglPM5YeyI/8
         k8cFEIT7qB86nTM+pcgzzQIPZea7zTCY2mZrBI1QUPznmazR52YkEyTgmcDi6PXUS6rf
         SQoly2cO/A9rowMQ3j6fClmrYi7xrsEam0TlSL5ck8Iks41hK3nBLTPDX9/SYBfVqUAw
         LqB0g3Wbvyk80+waNRSbcFh/gMM3eeSjKCDJGVjNg01pOs7/GAYd1SScN7gkska66iMH
         FRTQ==
X-Gm-Message-State: AO0yUKV28/N0mqPVRLi3qf7sOLL4iHhLchFMz2eUMl8lriKPFdHcC1dZ
        LLKfCqd++11ICXXscaAbv0D59vaODEWR5r8Nly1ADA==
X-Google-Smtp-Source: AK7set+SsjzVzMKV0mDDXrbeQGwZgSq6PsL8UvHR8BqGD2um1NQTdB/Syzn6pI+UaGShMerrkFnfmzIVlHkSJydJpeQ=
X-Received: by 2002:a25:8388:0:b0:80b:79e1:bdad with SMTP id
 t8-20020a258388000000b0080b79e1bdadmr3423465ybk.196.1675168460174; Tue, 31
 Jan 2023 04:34:20 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-16-andy.chiu@sifive.com>
 <Y9Q0h88UL0BRaF8d@spud>
In-Reply-To: <Y9Q0h88UL0BRaF8d@spud>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 31 Jan 2023 20:34:00 +0800
Message-ID: <CABgGipW5Ba7wc8K1QXY=aiT0xGMSiTo4LdhsxpNn7pr58jiekw@mail.gmail.com>
Subject: Re: [PATCH -next v13 15/19] riscv: Fix a kernel panic issue if $s2 is
 set to a specific value before entering Linux
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, ShihPo Hung <shihpo.hung@sifive.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Myrtle Shah <gatecat@ds0.me>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 28, 2023 at 4:31 AM Conor Dooley <conor@kernel.org> wrote:
> grepping for code that does this (with your series applied), you are
> the only one who is using PT_SIZE rather than PT_SIZE_ON_STACK:
Yes, you are right. It should be PT_SIZE_ON_STACK, which considers
alignment of the stack top. The task_pt_regs() counter parts, which is
the macro that operates on it, also aligns to STACK_ALIGN. So , we
should use PT_SIZE_ON_STACK instead of PT_SIZE here.
#define task_pt_regs(tsk)                                               \
        ((struct pt_regs *)(task_stack_page(tsk) + THREAD_SIZE          \
                            - ALIGN(sizeof(struct pt_regs), STACK_ALIGN)))

Thanks,
Andy
