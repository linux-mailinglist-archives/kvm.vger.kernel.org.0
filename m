Return-Path: <kvm+bounces-47178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAF8ABE380
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 21:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C638A429C
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2CA4280004;
	Tue, 20 May 2025 19:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LC6dB+Re"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BCE6BA45;
	Tue, 20 May 2025 19:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747768655; cv=none; b=P/3OSBYjNP7OVWfFYnSuEANfRkc60An/v0A+pGSArzxtF3vTor4b5pJ9Ls43iUWanyzgtWKtorOVD8LIq3aEu5YFhGWokMac3kIiwWrEF87vPNTyUT4KKhkTykebcEp6U3kOZc8OXhWUUn1xMMC/JPDFJBKwnjMfJSXh6T/Zyog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747768655; c=relaxed/simple;
	bh=UOBHlDuPgI3vmrS6szwU9kFfDoB8g+RmM40w1+PrVtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPDPizOH9QvJFbDmo3lsnVwjsLSVh4mtKFqThD63OFC+4YXd9AkCfgKEMlC8aFK99TSdkI2Lfa0uMg7H0kVCowzWN/+hRXKtiRAzt/dgQQEJIUGc4/Q7Z1xr4OD3qFmp+6mar7QMx6mnhpsVb+A+jNDAm/X0o6u/X09R1/kgohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LC6dB+Re; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s2duOlGKkCInlwogKebH77CQ5chyg8OhYTpGQwehpGg=; b=LC6dB+ReZgqhI/16zhwmZMQYU9
	sDZ4wpcDho5w1ohdtuG/vb638W5SbSIkUoIuVtbnSz+H1n8lZw+HPNsCKZ8loVTuIcy08EUHoDWno
	O0PpeC6jxy3ANrcZCj47sF1EgsX6Aqf1tW5xsNF9IolDcZ8H0s2NAx4ak5W2HjyhsnyQE9cuiARsV
	ie4mwIlqErpGlEy5obfR6XYvkRIq3oWiXPlXHAacfUiMVmlDrdb/Z+hJqTSRYmkbU9wCml8mNctns
	t/x7jTbaBsREwn4bi/DOb7nFBC3Dl/EllEbA610LAnwX3crCo9ze/LP5saeuszj5RxAvpIZ0wi2sa
	Z1vMIWlw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uHSSq-00000003kL2-3412;
	Tue, 20 May 2025 19:17:24 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CD5D3300677; Tue, 20 May 2025 21:17:23 +0200 (CEST)
Date: Tue, 20 May 2025 21:17:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
	David Matlack <dmatlack@google.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Subject: Re: [PATCH v2 06/12] sched/wait: Add a waitqueue helper for fully
 exclusive priority waiters
Message-ID: <20250520191723.GI16434@noisy.programming.kicks-ass.net>
References: <20250519185514.2678456-1-seanjc@google.com>
 <20250519185514.2678456-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519185514.2678456-7-seanjc@google.com>

On Mon, May 19, 2025 at 11:55:08AM -0700, Sean Christopherson wrote:
> Add a waitqueue helper to add a priority waiter that requires exclusive
> wakeups, i.e. that requires that it be the _only_ priority waiter.  The
> API will be used by KVM to ensure that at most one of KVM's irqfds is
> bound to a single eventfd (across the entire kernel).
> 
> Open code the helper instead of using __add_wait_queue() so that the
> common path doesn't need to "handle" impossible failures.
> 
> Note, the priority_exclusive() name is obviously confusing as the plain
> priority() API also sets WQ_FLAG_EXCLUSIVE.  This will be remedied once
> KVM switches to add_wait_queue_priority_exclusive(), as the only other
> user of add_wait_queue_priority(), Xen's privcmd, doesn't actually operate
> in exclusive mode (more than likely, the detail was overlooked when privcmd
> copy-pasted (sorry, "was inspired by") KVM's implementation).
> 
> Cc: K Prateek Nayak <kprateek.nayak@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  include/linux/wait.h |  2 ++
>  kernel/sched/wait.c  | 18 ++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 965a19809c7e..09855d819418 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -164,6 +164,8 @@ static inline bool wq_has_sleeper(struct wait_queue_head *wq_head)
>  extern void add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>  extern void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>  extern void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
> +extern int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
> +					     struct wait_queue_entry *wq_entry);
>  extern void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>  
>  static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 51e38f5f4701..03252badb8e8 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -47,6 +47,24 @@ void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_
>  }
>  EXPORT_SYMBOL_GPL(add_wait_queue_priority);
>  
> +int add_wait_queue_priority_exclusive(struct wait_queue_head *wq_head,
> +				      struct wait_queue_entry *wq_entry)
> +{
> +	struct list_head *head = &wq_head->head;
> +
> +	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
> +
> +	guard(spinlock_irqsave)(&wq_head->lock);
> +
> +	if (!list_empty(head) &&
> +	    (list_first_entry(head, typeof(*wq_entry), entry)->flags & WQ_FLAG_PRIORITY))
> +		return -EBUSY;
> +
> +	list_add(&wq_entry->entry, head);
> +	return 0;
> +}
> +EXPORT_SYMBOL(add_wait_queue_priority_exclusive);

add_wait_queue_priority() is a GPL export, leading me to believe the
whole priority thing is _GPL only, should we maintain that?

