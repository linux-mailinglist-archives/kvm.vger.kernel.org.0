Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0AD517CF2A
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 16:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCGPvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 10:51:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgCGPvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 10:51:23 -0500
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6A582075A
        for <kvm@vger.kernel.org>; Sat,  7 Mar 2020 15:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583596282;
        bh=UHxMlOP/hMKn3CPcO52ZhGK0R4reGfeC/7/Iejr5PiA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=z5zX1UY+CewiQJLUN5LeDwd4BCjsjw4B4qiiBrixyfi+ihN7gVW14ngUcuOZwtHSE
         pPsQZp0oI5xTuDw96EKH4gztn43KLhb6o6ue2lewxzyZ6TdXozOx3lf3cPZO9zR4Tz
         XT9Pz2QoXY0SlCjvRNkqVbExWuIOc50g4mRL10E8=
Received: by mail-wr1-f43.google.com with SMTP id p2so5030473wrw.7
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2020 07:51:22 -0800 (PST)
X-Gm-Message-State: ANhLgQ12twmqXh9ZamL8wZ69U/2LsJj/45zowT81pTpJX/CrcWKl9W1J
        aiKedDCHbx0luwY/ax0Qn7Fju2yKrHRPXTxh/XguRg==
X-Google-Smtp-Source: ADFU+vtgNh5PYJKne88gissFLxjTWS1VeXc8orte5Y8BkODNVYeWMvlgtImIU25CRtMKj8UkYwMSHp3+27TmQojaohM=
X-Received: by 2002:adf:df8f:: with SMTP id z15mr10100162wrl.184.1583596281091;
 Sat, 07 Mar 2020 07:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de>
 <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
 <87r1y4a3gw.fsf@nanos.tec.linutronix.de> <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
In-Reply-To: <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 07:51:08 -0800
X-Gmail-Original-Message-ID: <CALCETrX4p+++nS6N_yW2CnvMGUxngQBua65x9A9T-PB740LY0A@mail.gmail.com>
Message-ID: <CALCETrX4p+++nS6N_yW2CnvMGUxngQBua65x9A9T-PB740LY0A@mail.gmail.com>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 7, 2020 at 7:10 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Sat, Mar 7, 2020 at 2:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Andy Lutomirski <luto@kernel.org> writes:

> Now I'm confused again.  Your patch is very careful not to schedule if
> we're in an RCU read-side critical section, but the regular preemption
> code (preempt_schedule_irq, etc) seems to be willing to schedule
> inside an RCU read-side critical section.  Why is the latter okay but
> not the async pf case?

I read more docs.  I guess the relevant situation is
CONFIG_PREEMPT_CPU, in which case it is legal to preempt an RCU
read-side critical section and obviously legal to put the whole CPU to
sleep, but it's illegal to explicitly block in an RCU read-side
critical section.  So I have a question for Paul: is it, in fact,
entirely illegal to block or merely illegal to block for an
excessively long time, e.g. waiting for user space or network traffic?
 In this situation, we cannot make progress until the host says we
can, so we are, in effect, blocking until the host tells us to stop
blocking.  Regardless, I agree that turning IRQs on is reasonable, and
allowing those IRQs to preempt us is reasonable.

As it stands in your patch, the situation is rather odd: we'll run
another task if that task *preempts* us (e.g. we block long enough to
run out of our time slice), but we won't run another task if we aren't
preempted.  This seems bizarre.

>
> Ignoring that, this still seems racy:
>
> STI
> nested #PF telling us to wake up
> #PF returns
> HLT
>
> doesn't this result in putting the CPU asleep for no good reason until
> the next interrupt hits?

I think this issue still stands and is actually a fairly easy race to hit.

STI
IRQ happens and we get preempted
another task runs and gets the #PF "async pf wakeup" event
reschedule, back to original task
HLT

The only particularly unusual thing here is that an IRQ (timer or
otherwise) needs to be queued up between when the #PF "async pf sleep"
event happens and STI so that it gets delivered before HLT.

ISTM the way to fully address this is to make the logic something like:

if (preemptible) {
  actually go to sleep.  do not HLT.  Do this even in an RCU read-side
critical section.
} else {
  /* ok, we have to wait, but it's still legal to handle IRQs. */
  if (choice A) {
    keep IRQs off.  Spin until we wake up.
  } else {
    while (still need to sleep) {
      HLT (with IRQs off!)
      local_irq_enable();
      /* if an interrupt was queued, handle it. */
      local_irq_disable();
    }
}
