Return-Path: <kvm+bounces-52160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E7CFB01D6A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 616415A313A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BCA2D3EEA;
	Fri, 11 Jul 2025 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bgVE5yeZ"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214EA2C17A8;
	Fri, 11 Jul 2025 13:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240402; cv=none; b=cbSOx3BX9d6YvWyue93bj7aRojNDj1xqGwzsJPoor/pjj8Hfxm9PNOgRZEkBuk6TrlaTYwWAGmZuZwHv8fY3l4s9LXT3YJ6XMp/TP8UTx9bUepqspkfJ9XM9kT+SqrVfk3AFaIM626rzXdGynPUqPhyo27x02L9jemGTnPvYLs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240402; c=relaxed/simple;
	bh=FUds8YAC31K9XfalgMco5YWlvmCyOswz0fMNKBk+eYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkSwtTS++L2oIpaW3ShkcmYnXox5+se6OVLbw11j4ZloGVZ6ehQIvVvMGou+y4uVWXhlec6+lrBC3H+IyQ3CEkyBZMaUgB6y3ECsH/6pF5Cg8T8QxhOL/9diMxug6B+DcI2WLvzh8MCrKZb9JC+hskdOHmfOjR4BOTJ2vuzxFhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bgVE5yeZ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XHU8ZG5YSE7CXEfYpaRxPv73WRqoLxVmJ8YxgEVEucY=; b=bgVE5yeZaCl9BmGol3nwNqapEr
	EM7J59owSdEL0onqrSc1HRl/6P/lt5BX6o3J9hN+Ih8MzkAoWDy0vNzD2E4N7lgjUGfh8NK9ncwWJ
	RpQADGCgmvEiOLXoRlw/Chuj3a5PjsbTeUc2fhzm2oBM2K2Ob9V3pRZo4W7DC0qNJ0YUx+VcROoIL
	3ErKHa6ptlnN/rExCSa8hMnwk2hpT0rFXKl1TMrVyZxyq7+RbN0YqhQm1/EQH+vGwEkOmrYHVnIMe
	f8bvVEZ8xlZJBkIFqGFmUFknJHPJ2fMGat+HD2mayh0pChCc8vFsJPKUp5GETbfhYUh8RE+u/v4k6
	9L6GNm9g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uaDlr-0000000D7iW-17Fp;
	Fri, 11 Jul 2025 13:26:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D67D43001AA; Fri, 11 Jul 2025 15:26:33 +0200 (CEST)
Date: Fri, 11 Jul 2025 15:26:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] entry: Add arch_in_rcu_eqs()
Message-ID: <20250711132633.GF905792@noisy.programming.kicks-ass.net>
References: <20250708092742.104309-1-ajd@linux.ibm.com>
 <20250708092742.104309-2-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708092742.104309-2-ajd@linux.ibm.com>

On Tue, Jul 08, 2025 at 07:27:41PM +1000, Andrew Donnellan wrote:
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

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

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
> 2.50.0
> 

