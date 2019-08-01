Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6DB7E4D0
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 23:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389178AbfHAVfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 17:35:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:35131 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfHAVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 17:35:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 14:35:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="173038368"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 01 Aug 2019 14:35:51 -0700
Date:   Thu, 1 Aug 2019 14:35:50 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
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
Message-ID: <20190801213550.GE6783@linux.intel.com>
References: <20190801143250.370326052@linutronix.de>
 <20190801143657.887648487@linutronix.de>
 <20190801162451.GE31538@redhat.com>
 <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 01, 2019 at 08:34:53PM +0200, Thomas Gleixner wrote:
> On Thu, 1 Aug 2019, Oleg Nesterov wrote:
> > On 08/01, Thomas Gleixner wrote:
> > >
> > > @@ -8172,6 +8174,10 @@ static int vcpu_run(struct kvm_vcpu *vcp
> > >  			++vcpu->stat.signal_exits;
> > >  			break;
> > >  		}
> > > +
> > > +		if (notify_resume_pending())
> > > +			tracehook_handle_notify_resume();
> > 
> > shouldn't you drop kvm->srcu before tracehook_handle_notify_resume() ?
> > 
> > I don't understand this code at all, but vcpu_run() does this even before
> > cond_resched().
> 
> Yeah, I noticed that it's dropped around cond_resched().
> 
> My understanding is that for voluntary giving up the CPU via cond_resched()
> it needs to be dropped.
> 
> For involuntary preemption (CONFIG_PREEMPT=y) it's not required as the
> whole code section after preempt_enable() is fully preemptible.
> 
> Now the 1Mio$ question is whether any of the notify functions invokes
> cond_resched() and whether that really matters. Paolo?

cond_resched() is called via tracehook_notify_resume()->task_work_run(),
and "kernel code can only call cond_resched() in places where it ...
cannot hold references to any RCU-protected data structures" according to
https://lwn.net/Articles/603252/.
