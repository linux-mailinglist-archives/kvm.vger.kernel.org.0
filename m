Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE3FC17CFD6
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 20:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCGTas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 14:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbgCGTas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 14:30:48 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7F42075B
        for <kvm@vger.kernel.org>; Sat,  7 Mar 2020 19:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583609447;
        bh=fhzNwKA40q0IdbkhU80FlUfcHKK7iyMZDd0dNV4Q+I0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ch8fNR+ilzoE7t7ODBmbduDTUUSqFPr/fZQyfPC//FpgdEaXBATeK81M871bQXl0m
         HjOkhyTjjAV1/RP5lvGcGh6I7QOM9+RjN2uH0O/cOdesH5uhxasJmAW9shbmzu19RD
         FCdxT/pD087PNNjkOogS12P/dq9YRaCyFbTW9xpg=
Received: by mail-wr1-f50.google.com with SMTP id r7so6270035wro.2
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2020 11:30:47 -0800 (PST)
X-Gm-Message-State: ANhLgQ3TK1++ysKo7ilhOrv26tvpM1JqVU4pkDdk2eRS5G/dkocs5s1G
        hRg905sWpMbo7HeENeY4DPOvOETZ3FqaisgO/hJDAg==
X-Google-Smtp-Source: ADFU+vu6/TnAzAxiBCDsfDFzp8RpDWRX4WbVq6XHVuTZ3+g3PNmpSdJUSkcbVCGeBOJQr1lwTbIdhfXhzHN+1cG/xwg=
X-Received: by 2002:a5d:4141:: with SMTP id c1mr2916669wrq.257.1583609445730;
 Sat, 07 Mar 2020 11:30:45 -0800 (PST)
MIME-Version: 1.0
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de>
 <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
 <87r1y4a3gw.fsf@nanos.tec.linutronix.de> <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
 <CALCETrX4p+++nS6N_yW2CnvMGUxngQBua65x9A9T-PB740LY0A@mail.gmail.com> <875zfg9do9.fsf@nanos.tec.linutronix.de>
In-Reply-To: <875zfg9do9.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 11:30:33 -0800
X-Gmail-Original-Message-ID: <CALCETrWV-9L=CgCV13sV+MQiQm7MAPberHV21CriWko7e8icKA@mail.gmail.com>
Message-ID: <CALCETrWV-9L=CgCV13sV+MQiQm7MAPberHV21CriWko7e8icKA@mail.gmail.com>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 7, 2020 at 11:18 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Andy Lutomirski <luto@kernel.org> writes:
> > On Sat, Mar 7, 2020 at 7:10 AM Andy Lutomirski <luto@kernel.org> wrote:
> >> On Sat, Mar 7, 2020 at 2:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >> >
> >> > Andy Lutomirski <luto@kernel.org> writes:
> >
> >> Now I'm confused again.  Your patch is very careful not to schedule if
> >> we're in an RCU read-side critical section, but the regular preemption
> >> code (preempt_schedule_irq, etc) seems to be willing to schedule
> >> inside an RCU read-side critical section.  Why is the latter okay but
> >> not the async pf case?
> >
> > I read more docs.  I guess the relevant situation is
> > CONFIG_PREEMPT_CPU, in which case it is legal to preempt an RCU
> > read-side critical section and obviously legal to put the whole CPU to
> > sleep, but it's illegal to explicitly block in an RCU read-side
> > critical section.  So I have a question for Paul: is it, in fact,
> > entirely illegal to block or merely illegal to block for an
> > excessively long time, e.g. waiting for user space or network traffic?
>
> Two issues here:
>
>     - excessive blocking time

We can't do anything about this.  We are blocked until the host says
otherwise, and the critical section cannot end until the host lets it
end.

>
>     - entering idle with an RCU read side critical section blocking

We could surely make this work.  I'm not at all convinced it's
worthwhile, though.

>
> >  In this situation, we cannot make progress until the host says we
> > can, so we are, in effect, blocking until the host tells us to stop
> > blocking.  Regardless, I agree that turning IRQs on is reasonable, and
> > allowing those IRQs to preempt us is reasonable.
> >
> > As it stands in your patch, the situation is rather odd: we'll run
> > another task if that task *preempts* us (e.g. we block long enough to
> > run out of our time slice), but we won't run another task if we aren't
> > preempted.  This seems bizarre.
>
> Yes, it looks odd. We could do:
>
>         preempt_disable();
>         while (!page_arrived()) {
>                 if (preempt_count() == 1 && this_cpu_runnable_tasks() > 1) {
>                         set_need_resched();
>                         schedule_preempt_disabled();

The downside here is that the scheduler may immediately reschedule us,
thus accomplishing nothing whatsoever.

>                 } else {
>                         native_safe_halt();
>                         local_irq_disable();
>                 }
>         }
>         preempt_enable();
>
> Don't know if it's worth the trouble. But that's not the problem :)

I suspect that we should either declare it entirely not worth the
trouble and do it like in your patch or we should teach preempt-rcu to
handle the special case of going idle while in a read-side critical
section.  For all I know, the latter is trivial, but it could easily
be a total disaster.  Paul?
