Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16EC37DE7B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 17:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731490AbfHAPK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 11:10:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36395 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbfHAPK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 11:10:58 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCiy-0001mx-3A; Thu, 01 Aug 2019 17:10:36 +0200
Date:   Thu, 1 Aug 2019 17:10:35 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [patch 1/5] tracehook: Provide TIF_NOTIFY_RESUME handling for
 KVM
In-Reply-To: <20190801144814.GC31398@hirez.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.21.1908011708500.1725@nanos.tec.linutronix.de>
References: <20190801143250.370326052@linutronix.de> <20190801143657.785902257@linutronix.de> <20190801144814.GC31398@hirez.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Aug 2019, Peter Zijlstra wrote:
> On Thu, Aug 01, 2019 at 04:32:51PM +0200, Thomas Gleixner wrote:
> > +#ifdef CONFIG_HAVE_ARCH_TRACEHOOK
> > +/**
> > + * tracehook_handle_notify_resume - Notify resume handling for virt
> > + *
> > + * Called with interrupts and preemption enabled from VMENTER/EXIT.
> > + */
> > +void tracehook_handle_notify_resume(void)
> > +{
> > +	local_irq_disable();
> > +	while (test_and_clear_thread_flag(TIF_NOTIFY_RESUME)) {
> > +		local_irq_enable();
> > +		tracehook_notify_resume(NULL);
> > +		local_irq_disable();
> > +	}
> > +	local_irq_enable();
> 
> I'm confused by the IRQ state swizzling here, what is it doing?

Hmm, right. It's not really needed. Modeled it after the user space return
code, but the KVM case is different because it evaluates the TIF bit again
before entering the VM with interrupts disabled anyway.

I'll remove the brainfart in V2.

Thanks,

	tglx
