Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533EA37CE9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 21:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfFFTDn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 15:03:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40276 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfFFTDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 15:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8G3tvCi6+3/hb0vOKPh90iBXziH3sHPyDE0f4Dydj4k=; b=LmGsjjyzMUJHCqoKJjpwf79JU
        wppznBFSfz0d2Dwsxx1O5jJDiXd+Q/DCFIiErVGnBglEDYPHjuN79tgv9DoxOhBMlHydyBzFUbEml
        IfGIFeamGTRkm462xO/qWs17g2QsYYom0hGIXHuJarsqsPgzZHRVNi/Z9DAR3+Zw0VxNP3/D99lcm
        GyrE/MdXsAxV3fU6tDeW18bvBjcnVKFF5mbccFEQImg/asCUeoGafI3Z3q8813c0noTNRGJ+lLTgc
        PVj+hK5W6VqpZF1+UCK6VQNkYMpmSuYDC/ZRz2Lgx2WJgz9SK8ws6n3w6xwUkGOKSnfL93XAfreAm
        Ko+TwJhEg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYxfa-000525-7M; Thu, 06 Jun 2019 19:03:26 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6BE5220227105; Thu,  6 Jun 2019 21:03:23 +0200 (CEST)
Date:   Thu, 6 Jun 2019 21:03:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?iso-8859-1?B?S3LEP23DocU/?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [patch 1/3] drivers/cpuidle: add cpuidle-haltpoll driver
Message-ID: <20190606190323.GM3419@hirez.programming.kicks-ass.net>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.212931277@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603225254.212931277@amt.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 03, 2019 at 07:52:43PM -0300, Marcelo Tosatti wrote:
> +static int haltpoll_enter_idle(struct cpuidle_device *dev,
> +			  struct cpuidle_driver *drv, int index)
> +{
> +	int do_halt = 0;
> +	unsigned int *cpu_halt_poll_ns;
> +	ktime_t start, now;
> +	int cpu = smp_processor_id();
> +
> +	cpu_halt_poll_ns = per_cpu_ptr(&halt_poll_ns, cpu);
> +
> +	/* No polling */
> +	if (guest_halt_poll_ns == 0) {
> +		if (current_clr_polling_and_test()) {
> +			local_irq_enable();
> +			return index;
> +		}
> +		default_idle();
> +		return index;
> +	}
> +
> +	local_irq_enable();
> +
> +	now = start = ktime_get();
> +	if (!current_set_polling_and_test()) {
> +		ktime_t end_spin;
> +
> +		end_spin = ktime_add_ns(now, *cpu_halt_poll_ns);
> +
> +		while (!need_resched()) {
> +			cpu_relax();
> +			now = ktime_get();
> +
> +			if (!ktime_before(now, end_spin)) {
> +				do_halt = 1;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (do_halt) {
> +		u64 block_ns;
> +
> +		/*
> +		 * No events while busy spin window passed,
> +		 * halt.
> +		 */
> +		local_irq_disable();
> +		if (current_clr_polling_and_test()) {
> +			local_irq_enable();
> +			return index;
> +		}
> +		default_idle();
> +		block_ns = ktime_to_ns(ktime_sub(ktime_get(), start));
> +		adjust_haltpoll_ns(block_ns, cpu_halt_poll_ns);
> +	} else {
> +		u64 block_ns = ktime_to_ns(ktime_sub(now, start));
> +
> +		trace_cpuidle_haltpoll_success(*cpu_halt_poll_ns, block_ns);
> +		current_clr_polling();
> +	}
> +
> +	return index;
> +}

You might want to look at using sched_clock() here instead of
ktime_get(). ktime_get() can get _very_ expensive when it drops back to
HPET or things like that, where sched_clock() will always keep using
TSC, even when it is not globally synchronized.

(and since this code runs with preemption disabled, we don't care about
the clock being globally sane)


So something like this:

	start = sched_clock();
	if (current_set_polling_and_test()) {
		local_irq_enable();
		goto out;
	}

	local_irq_enable();
	for (;;) {
		if (need_resched()) {
			current_clr_polling();
			trace_..();
			goto out;
		}

		now = sched_clock();
		if (now - start > cpu_halt_poll_ns)
			break;

		cpu_relax();
	}

	local_irq_disable();
	if (current_clr_polling_and_test()) {
		local_irq_enable();
		goto out;
	}

	default_idle();
	block_ns = sched_clock() - start;
	adjust_haltpoll_ns(block_ns, cpu_halt_poll_ns);

out:
	return index;

