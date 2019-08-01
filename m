Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 758FB7E4F5
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 23:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbfHAVoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 17:44:24 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbfHAVoY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 17:44:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1ar96WJvg+rUGDQFzZ4pf3M5QiEtuEbzxYYlSwg9wfw=; b=mSw/yP4yyNvayFNRYt37k8U0h
        YLMBlZZE4pCYSr8csebvJ9B9G80lFC9+fLMhveGNH29x36ufG1GzxF0ozU4ZdcWLL+6pa8fhTw0CJ
        wrarjVa7P19K4hNdI7xJ2DjuT81crKkFOiqfKLmVw5GPD4d9IodFMXfiMqJb4bY+WMeUowQc8c04K
        1fhc94dc5Cx6QYQdfFy09k7Gh4hIootp5sTyuMOKU3lglbqXfjMXVToT2+aWR36cN0mSxY9z60dY0
        utpENwwrpa8D88fZf63usTj/YaFxHbdpRg4Zq4Im8xA+mki59qKoadXgs9NyCFDYDMZrGh0CZDtPV
        RgIk84eBQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1htIrv-0002tf-BU; Thu, 01 Aug 2019 21:44:15 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 93D3F202953BA; Thu,  1 Aug 2019 23:44:13 +0200 (CEST)
Date:   Thu, 1 Aug 2019 23:44:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
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
Message-ID: <20190801214413.GA2332@hirez.programming.kicks-ass.net>
References: <20190801143250.370326052@linutronix.de>
 <20190801143657.887648487@linutronix.de>
 <20190801162451.GE31538@redhat.com>
 <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
 <20190801213550.GE6783@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801213550.GE6783@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 02:35:50PM -0700, Sean Christopherson wrote:
> On Thu, Aug 01, 2019 at 08:34:53PM +0200, Thomas Gleixner wrote:
> > On Thu, 1 Aug 2019, Oleg Nesterov wrote:
> > > On 08/01, Thomas Gleixner wrote:
> > > >
> > > > @@ -8172,6 +8174,10 @@ static int vcpu_run(struct kvm_vcpu *vcp
> > > >  			++vcpu->stat.signal_exits;
> > > >  			break;
> > > >  		}
> > > > +
> > > > +		if (notify_resume_pending())
> > > > +			tracehook_handle_notify_resume();
> > > 
> > > shouldn't you drop kvm->srcu before tracehook_handle_notify_resume() ?
> > > 
> > > I don't understand this code at all, but vcpu_run() does this even before
> > > cond_resched().
> > 
> > Yeah, I noticed that it's dropped around cond_resched().
> > 
> > My understanding is that for voluntary giving up the CPU via cond_resched()
> > it needs to be dropped.
> > 
> > For involuntary preemption (CONFIG_PREEMPT=y) it's not required as the
> > whole code section after preempt_enable() is fully preemptible.
> > 
> > Now the 1Mio$ question is whether any of the notify functions invokes
> > cond_resched() and whether that really matters. Paolo?
> 
> cond_resched() is called via tracehook_notify_resume()->task_work_run(),
> and "kernel code can only call cond_resched() in places where it ...
> cannot hold references to any RCU-protected data structures" according to
> https://lwn.net/Articles/603252/.

This is SRCU, you can reschedule while holding that just fine. It will
just delay some kvm operations, like the memslot stuff. I don't think it
is terrible to keep it, but people more versed in KVM might know of a
good reason to drop it anyway.
