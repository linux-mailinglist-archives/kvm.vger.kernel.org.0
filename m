Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426C157275
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 22:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfFZUU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 16:20:26 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50285 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfFZUUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 16:20:25 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgEOk-00064v-BB; Wed, 26 Jun 2019 22:20:06 +0200
Date:   Wed, 26 Jun 2019 22:20:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
In-Reply-To: <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
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

On Tue, 18 Jun 2019, Fenghua Yu wrote:
> +
> +static atomic_t split_lock_debug;
> +
> +void split_lock_disable(void)
> +{
> +	/* Disable split lock detection on this CPU */
> +	this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
> +	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
> +
> +	/*
> +	 * Use the atomic variable split_lock_debug to ensure only the
> +	 * first CPU hitting split lock issue prints one single complete
> +	 * warning. This also solves the race if the split-lock #AC fault
> +	 * is re-triggered by NMI of perf context interrupting one
> +	 * split-lock warning execution while the original WARN_ONCE() is
> +	 * executing.
> +	 */
> +	if (atomic_cmpxchg(&split_lock_debug, 0, 1) == 0) {
> +		WARN_ONCE(1, "split lock operation detected\n");
> +		atomic_set(&split_lock_debug, 0);

What's the purpose of this atomic_set()?

> +dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
> +{
> +	unsigned int trapnr = X86_TRAP_AC;
> +	char str[] = "alignment check";
> +	int signr = SIGBUS;
> +
> +	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
> +
> +	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) == NOTIFY_STOP)
> +		return;
> +
> +	cond_local_irq_enable(regs);
> +	if (!user_mode(regs) && static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
> +		/*
> +		 * Only split locks can generate #AC from kernel mode.
> +		 *
> +		 * The split-lock detection feature is a one-shot
> +		 * debugging facility, so we disable it immediately and
> +		 * print a warning.
> +		 *
> +		 * This also solves the instruction restart problem: we
> +		 * return the faulting instruction right after this it

we return the faulting instruction ... to the store so we get our deposit
back :)

  the fault handler returns to the faulting instruction which will be then
  executed without ....

Don't try to impersonate code, cpus or whatever. It doesn't make sense and
confuses people.

> +		 * will be executed without generating another #AC fault
> +		 * and getting into an infinite loop, instead it will
> +		 * continue without side effects to the interrupted
> +		 * execution context.

That last part 'instead .....' is redundant. It's entirely clear from the
above that the faulting instruction is reexecuted ....

Please write concise comments and do try to repeat the same information
with a different painting.

> +		 *
> +		 * Split-lock detection will remain disabled after this,
> +		 * until the next reboot.
> +		 */
> +		split_lock_disable();
> +
> +		return;
> +	}
> +
> +	/* Handle #AC generated in any other cases. */
> +	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
> +		error_code, BUS_ADRALN, NULL);
> +}
> +
>  #ifdef CONFIG_VMAP_STACK
>  __visible void __noreturn handle_stack_overflow(const char *message,
>  						struct pt_regs *regs,
> -- 
> 2.19.1
> 
> 
