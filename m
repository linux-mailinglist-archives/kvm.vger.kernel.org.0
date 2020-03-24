Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2BA1919E0
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 20:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCXT3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 15:29:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45936 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgCXT3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 15:29:20 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGpEC-0004Uw-EV; Tue, 24 Mar 2020 20:28:44 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 94BA5100292; Tue, 24 Mar 2020 20:28:43 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     paulmck@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes \(Google\)" <joel@joelfernandes.org>,
        "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>,
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
Subject: Re: [RESEND][patch V3 17/23] rcu/tree: Mark the idle relevant functions noinstr
In-Reply-To: <20200324160909.GD19865@paulmck-ThinkPad-P72>
References: <20200320175956.033706968@linutronix.de> <20200320180034.095809808@linutronix.de> <20200324160909.GD19865@paulmck-ThinkPad-P72>
Date:   Tue, 24 Mar 2020 20:28:43 +0100
Message-ID: <87r1xhd02c.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:
> On Fri, Mar 20, 2020 at 07:00:13PM +0100, Thomas Gleixner wrote:

>> -void rcu_user_enter(void)
>> +noinstr void rcu_user_enter(void)
>>  {
>>  	lockdep_assert_irqs_disabled();
>
> Just out of curiosity -- this means that lockdep_assert_irqs_disabled()
> must be noinstr, correct?

Yes. noinstr functions can call other noinstr functions safely. If there
is a instr_begin() then anything can be called up to the corresponding
instr_end(). After that the noinstr rule applies again.

>>  	if (rdp->dynticks_nmi_nesting != 1) {
>> +		instr_begin();
>>  		trace_rcu_dyntick(TPS("--="), rdp->dynticks_nmi_nesting, rdp->dynticks_nmi_nesting - 2,
>>  				  atomic_read(&rdp->dynticks));
>>  		WRITE_ONCE(rdp->dynticks_nmi_nesting, /* No store tearing. */
>>  			   rdp->dynticks_nmi_nesting - 2);
>> +		instr_end();
>>  		return;
>>  	}
>>  
>> +		instr_begin();
>
> Indentation?

Is obviously wrong. You found it so please keep the extra TAB for times
when you need a spare one :)

>>   * If you add or remove a call to rcu_user_exit(), be sure to test with
>>   * CONFIG_RCU_EQS_DEBUG=y.
>>   */
>> -void rcu_user_exit(void)
>> +void noinstr rcu_user_exit(void)
>>  {
>>  	rcu_eqs_exit(1);
>>  }
>> @@ -830,27 +833,33 @@ static __always_inline void rcu_nmi_ente
>>  			rcu_cleanup_after_idle();
>>  
>>  		incby = 1;
>> -	} else if (irq && tick_nohz_full_cpu(rdp->cpu) &&
>> -		   rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
>> -		   READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {
>> +	} else if (irq) {
>>  		// We get here only if we had already exited the extended
>>  		// quiescent state and this was an interrupt (not an NMI).
>>  		// Therefore, (1) RCU is already watching and (2) The fact
>>  		// that we are in an interrupt handler and that the rcu_node
>>  		// lock is an irq-disabled lock prevents self-deadlock.
>>  		// So we can safely recheck under the lock.
>
> The above comment is a bit misleading in this location.

True

>> -		raw_spin_lock_rcu_node(rdp->mynode);
>> -		if (rdp->rcu_urgent_qs && !rdp->rcu_forced_tick) {
>> -			// A nohz_full CPU is in the kernel and RCU
>> -			// needs a quiescent state.  Turn on the tick!
>> -			rdp->rcu_forced_tick = true;
>> -			tick_dep_set_cpu(rdp->cpu, TICK_DEP_BIT_RCU);
>> +		instr_begin();
>> +		if (tick_nohz_full_cpu(rdp->cpu) &&
>> +		    rdp->dynticks_nmi_nesting == DYNTICK_IRQ_NONIDLE &&
>> +		    READ_ONCE(rdp->rcu_urgent_qs) && !rdp->rcu_forced_tick) {
>
> So how about like this?
>
> 			// We get here only if we had already exited
> 			// the extended quiescent state and this was an
> 			// interrupt (not an NMI).  Therefore, (1) RCU is
> 			// already watching and (2) The fact that we are in
> 			// an interrupt handler and that the rcu_node lock
> 			// is an irq-disabled lock prevents self-deadlock.
> 			// So we can safely recheck under the lock.

Yup

Thanks,

        tglx
