Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014F17E23B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 20:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfHASfG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 14:35:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37603 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfHASfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 14:35:05 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htFug-0007CB-NP; Thu, 01 Aug 2019 20:34:54 +0200
Date:   Thu, 1 Aug 2019 20:34:53 +0200 (CEST)
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
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [patch 2/5] x86/kvm: Handle task_work on VMENTER/EXIT
In-Reply-To: <20190801162451.GE31538@redhat.com>
Message-ID: <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
References: <20190801143250.370326052@linutronix.de> <20190801143657.887648487@linutronix.de> <20190801162451.GE31538@redhat.com>
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
> > @@ -8172,6 +8174,10 @@ static int vcpu_run(struct kvm_vcpu *vcp
> >  			++vcpu->stat.signal_exits;
> >  			break;
> >  		}
> > +
> > +		if (notify_resume_pending())
> > +			tracehook_handle_notify_resume();
> 
> shouldn't you drop kvm->srcu before tracehook_handle_notify_resume() ?
> 
> I don't understand this code at all, but vcpu_run() does this even before
> cond_resched().

Yeah, I noticed that it's dropped around cond_resched().

My understanding is that for voluntary giving up the CPU via cond_resched()
it needs to be dropped.

For involuntary preemption (CONFIG_PREEMPT=y) it's not required as the
whole code section after preempt_enable() is fully preemptible.

Now the 1Mio$ question is whether any of the notify functions invokes
cond_resched() and whether that really matters. Paolo?

Thanks,

	tglx
