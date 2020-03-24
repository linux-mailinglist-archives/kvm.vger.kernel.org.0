Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99643191A61
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 20:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCXT6c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 15:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgCXT6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 15:58:32 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E93D820753;
        Tue, 24 Mar 2020 19:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585079911;
        bh=dHOupjblYOUPni/ZcuLo31R0wGNwXOP6OpeHrlqDM2E=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=nOLwAAkzxMzoVLazg8LAEeBKflMvqJCwIm0ab+0FfgnaJtwPFE3YBUPYLR2MOBdtY
         5KaK3KEG9C/P6+Ja0PwCGP4M/yqqkiV700/u/Qhwi/9g2NaJUX2kc1Ic2t8xoPW31X
         raRf9fiPaUw1xQe43B3o0k53kWK+DxeW8nO5cN84=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id AEAD53522AC8; Tue, 24 Mar 2020 12:58:30 -0700 (PDT)
Date:   Tue, 24 Mar 2020 12:58:30 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RESEND][patch V3 17/23] rcu/tree: Mark the idle relevant
 functions noinstr
Message-ID: <20200324195830.GN19865@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200320175956.033706968@linutronix.de>
 <20200320180034.095809808@linutronix.de>
 <20200324160909.GD19865@paulmck-ThinkPad-P72>
 <87r1xhd02c.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1xhd02c.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 08:28:43PM +0100, Thomas Gleixner wrote:
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> > On Fri, Mar 20, 2020 at 07:00:13PM +0100, Thomas Gleixner wrote:
> 
> >> -void rcu_user_enter(void)
> >> +noinstr void rcu_user_enter(void)
> >>  {
> >>  	lockdep_assert_irqs_disabled();
> >
> > Just out of curiosity -- this means that lockdep_assert_irqs_disabled()
> > must be noinstr, correct?
> 
> Yes. noinstr functions can call other noinstr functions safely. If there
> is a instr_begin() then anything can be called up to the corresponding
> instr_end(). After that the noinstr rule applies again.

Thank you!

> >>  	if (rdp->dynticks_nmi_nesting != 1) {
> >> +		instr_begin();
> >>  		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2,
> >>  				  atomic_read(&rdp->dynticks));
> >>  		WRITE_ONCE(rdp->dynticks_nmi_nesting, /* No store tearing. */
> >>  			   rdp->dynticks_nmi_nesting - 2);
> >> +		instr_end();
> >>  		return;
> >>  	}
> >>  
> >> +		instr_begin();
> >
> > Indentation?
> 
> Is obviously wrong. You found it so please keep the extra TAB for times
> when you need a spare one :)

One of my parents like this.  https://en.wikipedia.org/wiki/Tab_(drink)

							Thanx, Paul

> >>   * If you add or remove a call to rcu_user_exit(), be sure to test with
> >>   * CONFIG_RCU_EQS_DEBUG=y.
> >>   */
> >> -void rcu_user_exit(void)
> >> +void noinstr rcu_user_exit(void)
> >>  {
> >>  	rcu_eqs_exit(1);
> >>  }
> >> @@ -830,27 +833,33 @@ static __always_inline void rcu_nmi_ente
> >>  			rcu_cleanup_after_idle();
> >>  
> >>  		incby = 1;
> >> -	} else if (irq && tick_nohz_full_cpu(rdp->cpu) &&
> >> -		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
> >> -		   READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {
> >> +	} else if (irq) {
> >>  		// We get here only if we had already exited the extended
> >>  		// quiescent state and this was an interrupt (not an NMI).
> >>  		// Therefore, (1) RCU is already watching and (2) The fact
> >>  		// that we are in an interrupt handler and that the rcu_node
> >>  		// lock is an irq-disabled lock prevents self-deadlock.
> >>  		// So we can safely recheck under the lock.
> >
> > The above comment is a bit misleading in this location.
> 
> True
> 
> >> -		raw_spin_lock_rcu_node(rdp->mynode);
> >> -		if (rdp->rcu_urgent_qs && !rdp->rcu_forced_tick) {
> >> -			// A nohz_full CPU is in the kernel and RCU
> >> -			// needs a quiescent state.  Turn on the tick!
> >> -			rdp->rcu_forced_tick = true;
> >> -			tick_dep_set_cpu(rdp->cpu, TICK_DEP_BIT_RCU);
> >> +		instr_begin();
> >> +		if (tick_nohz_full_cpu(rdp->cpu) &&
> >> +		    rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
> >> +		    READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {
> >
> > So how about like this?
> >
> > 			// We get here only if we had already exited
> > 			// the extended quiescent state and this was an
> > 			// interrupt (not an NMI).  Therefore, (1) RCU is
> > 			// already watching and (2) The fact that we are in
> > 			// an interrupt handler and that the rcu_node lock
> > 			// is an irq-disabled lock prevents self-deadlock.
> > 			// So we can safely recheck under the lock.
> 
> Yup
> 
> Thanks,
> 
>         tglx
