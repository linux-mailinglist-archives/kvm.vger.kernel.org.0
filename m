Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B156573C1
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 23:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfFZViN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 17:38:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50389 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZViN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 17:38:13 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgFby-0007t9-8H; Wed, 26 Jun 2019 23:37:50 +0200
Date:   Wed, 26 Jun 2019 23:37:48 +0200 (CEST)
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
Subject: Re: [PATCH v9 14/17] x86/split_lock: Add a debugfs interface to
 enable/disable split lock detection during run time
In-Reply-To: <1560897679-228028-15-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1906262247230.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-15-git-send-email-fenghua.yu@intel.com>
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
> To simplify the code, Ingo suggests to use the global atomic
> split_lock_debug flag both for warning split lock in WARN_ONCE() and for
> writing the debugfs interface.

So how is that flag used for writing the debugfs interface? Did you use it
for writing the code or is it used by the admin to write to the interface?

> -static void split_lock_update_msr(void)
> +static void split_lock_update_msr(void *__unused)
>  {
> +	unsigned long flags;
> +
> +	/*
> +	 * Need to prevent msr_test_ctl_cached from being changed *and*
> +	 * completing its WRMSR between our read and our WRMSR. By turning
> +	 * IRQs off here, ensure that no split lock debugfs write happens
> +	 * on this CPU and that any concurrent debugfs write from a different
> +	 * CPU will not finish updating us via IPI until we're done.
> +	 */

That's the same convoluted comment as in the UMWAIT series, but aside of
that it's completely nonsensical here. This function is either called from
the early cpu init code or via an SMP function call. Both have interrupts
disabled.

> +	local_irq_save(flags);

So this is a pointless exercise.

>  	if (split_lock_detect_enabled) {
>  		/* Enable split lock detection */
>  		this_cpu_or(msr_test_ctl_cached, MSR_TEST_CTL_SPLIT_LOCK_DETECT);
> @@ -640,6 +653,8 @@ static void split_lock_update_msr(void)
>  		this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
>  	}
>  	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
> +
> +	local_irq_restore(flags);
>  }
>  
>  static void split_lock_init(struct cpuinfo_x86 *c)
> @@ -651,7 +666,7 @@ static void split_lock_init(struct cpuinfo_x86 *c)
>  		rdmsrl(MSR_TEST_CTL, test_ctl_val);
>  		this_cpu_write(msr_test_ctl_cached, test_ctl_val);
>  
> -		split_lock_update_msr();
> +		split_lock_update_msr(NULL);
>  	}
>  }
>  
> @@ -1077,10 +1092,23 @@ static atomic_t split_lock_debug;
>  
>  void split_lock_disable(void)
>  {
> +	unsigned long flags;
> +
> +	/*
> +	 * Need to prevent msr_test_ctl_cached from being changed *and*
> +	 * completing its WRMSR between our read and our WRMSR. By turning
> +	 * IRQs off here, ensure that no split lock debugfs write happens
> +	 * on this CPU and that any concurrent debugfs write from a different
> +	 * CPU will not finish updating us via IPI until we're done.
> +	 */

Please check the comment above umwait_cpu_online() in the version I fixed
up and make sure that the comment here makes sense as well. The above does
not make any sense at all here. But before you go there ....

> +	local_irq_save(flags);

Neither does this.

>  	/* Disable split lock detection on this CPU */
>  	this_cpu_and(msr_test_ctl_cached, ~MSR_TEST_CTL_SPLIT_LOCK_DETECT);
>  	wrmsrl(MSR_TEST_CTL, this_cpu_read(msr_test_ctl_cached));
>  
> +	local_irq_restore(flags);
> +
>  	/*
>  	 * Use the atomic variable split_lock_debug to ensure only the
>  	 * first CPU hitting split lock issue prints one single complete
> @@ -1094,3 +1122,92 @@ void split_lock_disable(void)
>  		atomic_set(&split_lock_debug, 0);
>  	}
>  }

The above is called from the AC handler:

+dotraplinkage void do_alignment_check(struct pt_regs *regs, long error_code)
+{
+	unsigned int trapnr = X86_TRAP_AC;
+	char str[] = "alignment check";
+	int signr = SIGBUS;
+
+	RCU_LOCKDEP_WARN(!rcu_is_watching(), "entry code didn't wake RCU");
+
+	if (notify_die(DIE_TRAP, str, regs, error_code, trapnr, signr) == NOTIFY_STOP)
+		return;
+
+	cond_local_irq_enable(regs);

So why enabling interrupts here at all? Just to disable them right away
when this was a split lock? Just keep them disabled, do the check with
interrupts disabled ...

+	if (!user_mode(regs) && static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT)) {
+		/*
+		 * Only split locks can generate #AC from kernel mode.
+		 *
+		 * The split-lock detection feature is a one-shot
+		 * debugging facility, so we disable it immediately and
+		 * print a warning.
+		 *
+		 * This also solves the instruction restart problem: we
+		 * return the faulting instruction right after this it
+		 * will be executed without generating another #AC fault
+		 * and getting into an infinite loop, instead it will
+		 * continue without side effects to the interrupted
+		 * execution context.
+		 *
+		 * Split-lock detection will remain disabled after this,
+		 * until the next reboot.
+		 */
+		split_lock_disable();

	split_lock_disable() wants a lockdep_assert_irqs_disabled() inside.

+
+		return;
+	}

and put the cond_local_irq_enable() here.

+	/* Handle #AC generated in any other cases. */
+	do_trap(X86_TRAP_AC, SIGBUS, "alignment check", regs,
+		error_code, BUS_ADRALN, NULL);

> +
> +static ssize_t split_lock_detect_rd(struct file *f, char __user *user_buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	unsigned int len;
> +	char buf[8];
> +
> +	len = sprintf(buf, "%u\n", split_lock_detect_enabled);

The state is inconsistent when AC triggered in the kernel. Because nothing
clears that enabled variable, but the lock detection is disabled.

> +	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
> +}
> +
> +static ssize_t split_lock_detect_wr(struct file *f, const char __user *user_buf,
> +				    size_t count, loff_t *ppos)
> +{
> +	unsigned int len;
> +	char buf[8];
> +	bool val;
> +
> +	len = min(count, sizeof(buf) - 1);
> +	if (copy_from_user(buf, user_buf, len))
> +		return -EFAULT;
> +
> +	buf[len] = '\0';
> +	if (kstrtobool(buf, &val))
> +		return -EINVAL;
> +
> +	while (atomic_cmpxchg(&split_lock_debug, 1, 0))
> +		cpu_relax();

I assume that this is the magic thing what Ingo suggested. But that's
completely non obvious and of course because it's non obvious it lacks a
comment as well.

I assume that is considered to be magic serialization of the debugfs
write. Let's have a look.

First caller:

       debug == 1

       For simplicity we assume no concurrency

       while ...
       	     1st round:  atomic_cmpxchg(&debug, 1, 0) -> returns 1

	     so the atomic_cmpxchg() succeeded because it returned oldval
	     and that was 1

	     debug contains 0 now

	     so it has to go through a second round

       	     2nd round:  atomic_cmpxchg(&debug, 1, 0) -> returns 0

	     because debug is 0

That means the debug print thing is now disabled and the first caller proceeds.

Guess what happens if another one comes in. It will only take one round to
proceed because debug is already 0

So both think they are alone. Interesting concept.

> +	if (split_lock_detect_enabled == val)
> +		goto out_unlock;

Now lets go to 'out_unlock' ....

> +
> +	split_lock_detect_enabled = val;
> +
> +	/* Update the split lock detection setting in MSR on all online CPUs. */
> +	on_each_cpu(split_lock_update_msr, NULL, 1);
> +
> +	if (split_lock_detect_enabled)
> +		pr_info("enabled\n");
> +	else
> +		pr_info("disabled\n");

Errm. No. The admin wrote to the file. Why do we need to make noise in
dmesg about that?

> +
> +out_unlock:
> +	atomic_set(&split_lock_debug, 0);

out_unlock writes the variable which is already 0 to 0. I'm failing to see
how that locking works, but clearly once the debugfs file is written to the
kernel side debug print is disabled forever.

I have no idea how that is supposed to work, but then I might be missing
the magic logic behind it.

Aside of that. Doing locking with atomic_cmpxhg() spinning for such an
interface is outright crap even if implemented correctly. The first writer
might be preempted after acquiring the 'lock' and then the second one spins
until the first one comes back on the CPU and completes. We have spinlocks
for that, but spinlocks are the wrong tool here. Why not using a good old
mutex and be done with it? Just because this file is root only does not
justify any of this.

> +	return count;

> +}
> +
> +static const struct file_operations split_lock_detect_fops = {
> +	.read = split_lock_detect_rd,
> +	.write = split_lock_detect_wr,
> +	.llseek = default_llseek,

Even if I repeat myself. May I ask you more or less politely to use tabular
aligned initializers?

> +};
> +
> +/*
> + * Before resume from hibernation, TEST_CTL MSR has been initialized to
> + * default value in split_lock_init() on BP. On resume, restore the MSR
> + * on BP to previous value which could be changed by debugfs and thus could
> + * be different from the default value.

What has this to do with debugfs? This is about state in the kernel which
starts up after hibernation and the state in the hibernated kernel. Their
state can differ for whatever reason and is just unconditionally restored
to the state it had before hibernation. The whole debugfs blurb is
irrelevant.

> + *
> + * The MSR on BP is supposed not to be changed during suspend and thus it's
> + * unnecessary to set it again during resume from suspend. But at this point
> + * we don't know resume is from suspend or hibernation. To simplify the
> + * situation, just set up the MSR on resume from suspend.
> + *
> + * Set up the MSR on APs when they are re-added later.

See the fixed up UMWAIT comment on this.

Thanks,

	tglx
