Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83FFE7E267
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 20:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731616AbfHASlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 14:41:35 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37660 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727899AbfHASlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 14:41:35 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htG0x-0007Ns-FW; Thu, 01 Aug 2019 20:41:23 +0200
Date:   Thu, 1 Aug 2019 20:41:22 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Oleg Nesterov <oleg@redhat.com>
cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 4/5] posix-cpu-timers: Defer timer handling to
 task_work
In-Reply-To: <20190801153936.GD31538@redhat.com>
Message-ID: <alpine.DEB.2.21.1908012035130.1789@nanos.tec.linutronix.de>
References: <20190801143250.370326052@linutronix.de> <20190801143658.074833024@linutronix.de> <20190801153936.GD31538@redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Aug 2019, Oleg Nesterov wrote:
> On 08/01, Thomas Gleixner wrote:
> >
> > +static void __run_posix_cpu_timers(struct task_struct *tsk)
> > +{
> > +	/* FIXME: Init it proper in fork or such */
> > +	init_task_work(&tsk->cpu_timer_work, posix_cpu_timers_work);
> > +	task_work_add(tsk, &tsk->cpu_timer_work, true);
> > +}
> 
> What if update_process_times/run_posix_cpu_timers is called again before
> this task does task_work_run() ?
> 
> somehow it should check that ->cpu_timer_work is not already queued...

Right.

> Or suppose that this is called when task_work_run() executes this
> cpu_timer_work. Looks like you need another flag checked by
> __run_posix_cpu_timers() and cleare in posix_cpu_timers_work() ?

That's a non issue. The only thing which can happen is that it runs through
the task_work once more to figure out there is nothing to do.

Thanks,

	tglx
