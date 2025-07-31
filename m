Return-Path: <kvm+bounces-53815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B37BB17937
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 00:56:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 440B97AAA49
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 22:54:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230B0279DC3;
	Thu, 31 Jul 2025 22:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEJ77wkh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3082253FD;
	Thu, 31 Jul 2025 22:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754002547; cv=none; b=FPJj6Uix9OeMb5tmu8MiEE3MH8+EzSMmucMcnHi2XbnT+dBmRseJfoX+Fef7y0VnRy7udzkm599m0SYK0znotI9IwdeMdyn6vLLYvSOBs3tEZAIOiDaL1I/TPTceWkyXpi02sHJ4UkxRvQ/7FP195EtN4xFFq+wT5Wxxdlq07xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754002547; c=relaxed/simple;
	bh=jVBqTX4LiFX2Ybg1vJa8X7czRMlNlRIvlu0u0+RCFzs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGH/a1gU8nVu3hwvc48F+OTMiJAkMuzHiquEFvWiBg/IEE+5qZa3ZKv8gFnaTdv2EXjCvKKWnY17WbdoNRlW8I5x2gxvDNQRq1ZgvnrkUf7AR2Jd9s1NibYlIMaH9xkTKe0fwjISR/CO4qXkalexPnl9ibAB7x6uSRGvQgvQ/9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEJ77wkh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D2EC4CEEF;
	Thu, 31 Jul 2025 22:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754002546;
	bh=jVBqTX4LiFX2Ybg1vJa8X7czRMlNlRIvlu0u0+RCFzs=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=YEJ77wkhpCgnUqYn4thx21LhLxcEUT7C/n69VGBJZKMz6aUpmg20i7GjrBXIXHNow
	 2G8uJWR4Y2sX04OoGVvvM6JM/ke4OV3UisD29+L8lsIzBaPNMcQsaSbOhRABLr9fRh
	 uUCU+fWOqu6NwLEKRBleld/gZyIec8YiwRaXqvTYJxCdruYE1qvL++W9NCtW3N9lc7
	 5p9g1S2Yh1o4L7Q8fQRQ5sSF+tvFZ9Zwz9pFEIyzu525Fv4ovd5g5FEbyMXzoTMA9k
	 otX6mnmTH3uz6rfImCsViA0mQPVNempBBJLm6eqvVdZefuKkrwBjopgPkYs1VHz6oh
	 AR2PQcf321d1A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 5EAA2CE09FA; Thu, 31 Jul 2025 15:55:46 -0700 (PDT)
Date: Thu, 31 Jul 2025 15:55:46 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, borntraeger@linux.ibm.com,
	linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
	ajd@linux.ibm.com, sfr@canb.auug.org.au,
	Mark Rutland <mark.rutland@arm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [GIT PULL 1/2] entry: Add arch_in_rcu_eqs()
Message-ID: <055235f7-9ea0-4a6d-8386-5893c737a459@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20250730081224.38778-1-frankja@linux.ibm.com>
 <20250730081224.38778-2-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730081224.38778-2-frankja@linux.ibm.com>

On Wed, Jul 30, 2025 at 10:10:32AM +0200, Janosch Frank wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> All architectures have an interruptible RCU extended quiescent state
> (EQS) as part of their idle sequences, where interrupts can occur
> without RCU watching. Entry code must account for this and wake RCU as
> necessary; the common entry code deals with this in irqentry_enter() by
> treating any interrupt from an idle thread as potentially having
> occurred within an EQS and waking RCU for the duration of the interrupt
> via rcu_irq_enter() .. rcu_irq_exit().
> 
> Some architectures may have other interruptible EQSs which require
> similar treatment. For example, on s390 it is necessary to enable
> interrupts around guest entry in the middle of a period where core KVM
> code has entered an EQS.
> 
> So that architectures can wake RCU in these cases, this patch adds a
> new arch_in_rcu_eqs() hook to the common entry code which is checked in
> addition to the existing is_idle_thread() check, with RCU woken if
> either returns true. A default implementation is provided which always
> returns false, which suffices for most architectures.
> 
> As no architectures currently implement arch_in_rcu_eqs(), there should
> be no functional change as a result of this patch alone. A subsequent
> patch will add an s390 implementation to fix a latent bug with missing
> RCU wakeups.
> 
> [ajd@linux.ibm.com: rebase, fix commit message]
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Link: https://lore.kernel.org/r/20250708092742.104309-2-ajd@linux.ibm.com
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Message-ID: <20250708092742.104309-2-ajd@linux.ibm.com>

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/entry-common.h | 16 ++++++++++++++++
>  kernel/entry/common.c        |  3 ++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
> index f94f3fdf15fc..3bf99cbad8a3 100644
> --- a/include/linux/entry-common.h
> +++ b/include/linux/entry-common.h
> @@ -86,6 +86,22 @@ static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs);
>  static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs) {}
>  #endif
>  
> +/**
> + * arch_in_rcu_eqs - Architecture specific check for RCU extended quiescent
> + * states.
> + *
> + * Returns: true if the CPU is potentially in an RCU EQS, false otherwise.
> + *
> + * Architectures only need to define this if threads other than the idle thread
> + * may have an interruptible EQS. This does not need to handle idle threads. It
> + * is safe to over-estimate at the cost of redundant RCU management work.
> + *
> + * Invoked from irqentry_enter()
> + */
> +#ifndef arch_in_rcu_eqs
> +static __always_inline bool arch_in_rcu_eqs(void) { return false; }
> +#endif
> +
>  /**
>   * enter_from_user_mode - Establish state when coming from user mode
>   *
> diff --git a/kernel/entry/common.c b/kernel/entry/common.c
> index a8dd1f27417c..eb52d38e8099 100644
> --- a/kernel/entry/common.c
> +++ b/kernel/entry/common.c
> @@ -220,7 +220,8 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
>  	 * TINY_RCU does not support EQS, so let the compiler eliminate
>  	 * this part when enabled.
>  	 */
> -	if (!IS_ENABLED(CONFIG_TINY_RCU) && is_idle_task(current)) {
> +	if (!IS_ENABLED(CONFIG_TINY_RCU) &&
> +	    (is_idle_task(current) || arch_in_rcu_eqs())) {
>  		/*
>  		 * If RCU is not watching then the same careful
>  		 * sequence vs. lockdep and tracing is required
> -- 
> 2.50.1
> 

