Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D87E13E2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 10:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390211AbfJWIRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 04:17:09 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39661 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389987AbfJWIRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 04:17:08 -0400
Received: by mail-ot1-f65.google.com with SMTP id s22so16644346otr.6;
        Wed, 23 Oct 2019 01:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFfoWoAOi1Gcw21Dvgij8W69ZIOoeiIbU6wqQ9bvYIs=;
        b=qyhPtzj+Q83LmFli8fCHnZNkQXis8IZzO3MVaa0FxB62+2mfVWi/37dqpW9Zymo/UF
         NaLAdqwRO7psvPqF8oEse1+JFvHpHtlmasmDlS/69Al343m3dYlb3Iuu9lL07t6S4Xk3
         84vkM9fVls39ER5OF2wdNVds3H89FhtrMUFkvtdn7jzyJcjUIwF3UOcWXbcRBGHSh6bb
         h3jfAtPfJiWG93mxyw7x9k4zStqocpe5nixXmIfE5RyPox1H9Ukihn9MJMR3SxUFXZZ8
         L7CTaFKW+kUB4IDuXCG0NP1k/+gsYa13SoYTrgLe32LAPtZ8q584KbVMpihol4Ig1tRx
         66Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFfoWoAOi1Gcw21Dvgij8W69ZIOoeiIbU6wqQ9bvYIs=;
        b=O4grJiy/tnAVeEJ/7wd9wKafstqRMp24X0Gcd+nXpH/eLMMftiZWZMErQ8HfyZobkj
         oSGM4TaN/gF0BuXIgDT8Y/EYdnHnRMBvsl8vhH9SoMt/IfDUc6hSOWowxtr/WzclIa5t
         8gpDnqRbK1gmxsJsASHMASfrmLMxAkDZ/WBr4PGxlgEb9naoHJVXgg+DUcLWJDoCdM/9
         Y3HJx7/DQiEWggKa8c7y3xm+SyIYJTe5bM7WOkE1uEyxOMRf4S37Neo6EiYt4GURmIat
         TEIJ9ynmwpgctfOUGmLlxV5L1NEQmOK5MT4yXU0k6AZ7qSrh5h+urc5+7Ln7ctFu9QlJ
         lnbQ==
X-Gm-Message-State: APjAAAUXXY/9E+iWfN66CBeXPZVXdCR9WijGFvDI1J4OHdHQ1QXsSQw8
        B1dcGtUZVX/FHcHTEy3GZc2L5ZDH+q6R8JvDE8A=
X-Google-Smtp-Source: APXvYqzcv+GPuUgPESRDeCMqNkyh/xbdfpRDVj9dr96h1BCtFi1FqDllWpfX+LIbUpptSCrp0t1mCJjfD5nEkUqJ9O4=
X-Received: by 2002:a9d:69c7:: with SMTP id v7mr867245oto.45.1571818626331;
 Wed, 23 Oct 2019 01:17:06 -0700 (PDT)
MIME-Version: 1.0
References: <1561682593-12071-1-git-send-email-wanpengli@tencent.com> <20190628011012.GA19488@lerouge>
In-Reply-To: <20190628011012.GA19488@lerouge>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 23 Oct 2019 16:16:55 +0800
Message-ID: <CANRm+CxUpwZ9KwOcQp=Ok64giyjjcJOGb2=zU6vayQzLqYvpXQ@mail.gmail.com>
Subject: Re: [PATCH v2] sched/nohz: Optimize get_nohz_timer_target()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, kvm <kvm@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 28 Jun 2019 at 09:10, Frederic Weisbecker <frederic@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 08:43:12AM +0800, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > On a machine, cpu 0 is used for housekeeping, the other 39 cpus in the
> > same socket are in nohz_full mode. We can observe huge time burn in the
> > loop for seaching nearest busy housekeeper cpu by ftrace.
> >
> >   2)               |       get_nohz_timer_target() {
> >   2)   0.240 us    |         housekeeping_test_cpu();
> >   2)   0.458 us    |         housekeeping_test_cpu();
> >
> >   ...
> >
> >   2)   0.292 us    |         housekeeping_test_cpu();
> >   2)   0.240 us    |         housekeeping_test_cpu();
> >   2)   0.227 us    |         housekeeping_any_cpu();
> >   2) + 43.460 us   |       }
> >
> > This patch optimizes the searching logic by finding a nearest housekeeper
> > cpu in the housekeeping cpumask, it can minimize the worst searching time
> > from ~44us to < 10us in my testing. In addition, the last iterated busy
> > housekeeper can become a random candidate while current CPU is a better
> > fallback if it is a housekeeper.
> >
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Frederic Weisbecker <frederic@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>
> Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

Hi Thomas,

I didn't see your refactor to get_nohz_timer_target() which you
mentioned in IRC after four months, I can observe cyclictest drop from
4~5us to 8us in kvm guest(we offload the lapic timer emulation to
housekeeping cpu to avoid timer fire external interrupt on the pCPU
which vCPU resident incur a vCPU vmexit) w/o this patch in the case of
there is no busy housekeeping cpu. The score can be recovered after I
give stress to create a busy housekeeping cpu.

Could you consider applying this patch for temporary since I'm not
sure when the refactor can be ready.

    Wanpeng
