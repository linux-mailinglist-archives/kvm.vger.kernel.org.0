Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D0B29C875
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 20:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829479AbgJ0TMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 15:12:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51986 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762525AbgJ0TJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 15:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CvGwbxdQWU0yUwxUSuiiHN1xqzMsQ3tR0c+NFhztTjs=; b=wRl0WMjVqZ536/QENSM5F95D2Z
        zKmyl13OUdU21RVCTpvd88havNzLv2qYPgEiKg0f67eXJ0Bv9tbF6S+gay5raVLsbJAwI+/syUoPV
        jmsj+R+tfp73VHXr9Lgm8XiypR9YDePazRl47Yjp49d9IYcf7Hy2XR7aIqVKBbq5/V8+/XIG9NF/L
        mfDFQ6W94Fzmb+FL7Wh6qtXCESNZcpWSk5tZ7k5pJGUvh3dF4yChOsUZu9nD09bHLZvjJllXy6ZU3
        g9bvuR7ry5c7LvO4mhzJ/Opoz4ZwldrKehbSzR8AXXpmvfVlAsqQe/0bajz/LnBeCPEB3ybykNNB+
        w726Fd2Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXULS-0002ex-Rq; Tue, 27 Oct 2020 19:09:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id EC2F5307A7C;
        Tue, 27 Oct 2020 20:09:19 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D109F203C2679; Tue, 27 Oct 2020 20:09:19 +0100 (CET)
Date:   Tue, 27 Oct 2020 20:09:19 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
Message-ID: <20201027190919.GO2628@hirez.programming.kicks-ass.net>
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
 <20201027143944.648769-2-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027143944.648769-2-dwmw2@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 02:39:43PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This allows an exclusive wait_queue_entry to be added at the head of the
> queue, instead of the tail as normal. Thus, it gets to consume events
> first without allowing non-exclusive waiters to be woken at all.
> 
> The (first) intended use is for KVM IRQFD, which currently has

Do you have more? You could easily special case this inside the KVM
code.

I don't _think_ the other users of __add_wait_queue() will mind the
extra branch, but what do I know.

> inconsistent behaviour depending on whether posted interrupts are
> available or not. If they are, KVM will bypass the eventfd completely
> and deliver interrupts directly to the appropriate vCPU. If not, events
> are delivered through the eventfd and userspace will receive them when
> polling on the eventfd.
> 
> By using add_wait_queue_priority(), KVM will be able to consistently
> consume events within the kernel without accidentally exposing them
> to userspace when they're supposed to be bypassed. This, in turn, means
> that userspace doesn't have to jump through hoops to avoid listening
> on the erroneously noisy eventfd and injecting duplicate interrupts.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>  include/linux/wait.h | 12 +++++++++++-
>  kernel/sched/wait.c  | 17 ++++++++++++++++-
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/wait.h b/include/linux/wait.h
> index 27fb99cfeb02..fe10e8570a52 100644
> --- a/include/linux/wait.h
> +++ b/include/linux/wait.h
> @@ -22,6 +22,7 @@ int default_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int
>  #define WQ_FLAG_BOOKMARK	0x04
>  #define WQ_FLAG_CUSTOM		0x08
>  #define WQ_FLAG_DONE		0x10
> +#define WQ_FLAG_PRIORITY	0x20
>  
>  /*
>   * A single wait-queue entry structure:
> @@ -164,11 +165,20 @@ static inline bool wq_has_sleeper(struct wait_queue_head *wq_head)
>  
>  extern void add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>  extern void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
> +extern void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>  extern void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
>  
>  static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
>  {
> -	list_add(&wq_entry->entry, &wq_head->head);
> +	struct list_head *head = &wq_head->head;
> +	struct wait_queue_entry *wq;
> +
> +	list_for_each_entry(wq, &wq_head->head, entry) {
> +		if (!(wq->flags & WQ_FLAG_PRIORITY))
> +			break;
> +		head = &wq->entry;
> +	}
> +	list_add(&wq_entry->entry, head);
>  }

So you're adding the PRIORITY things to the head of the list and need
the PRIORITY flag to keep them in FIFO order there, right?

While looking at this I found that weird __add_wait_queue_exclusive()
which is used by fs/eventpoll.c and does something similar, except it
doesn't keep the FIFO order.

The Changelog doesn't state how important this property is to you.

>  /*
> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
> index 01f5d3020589..183cc6ae68a6 100644
> --- a/kernel/sched/wait.c
> +++ b/kernel/sched/wait.c
> @@ -37,6 +37,17 @@ void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue
>  }
>  EXPORT_SYMBOL(add_wait_queue_exclusive);
>  
> +void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
> +{
> +	unsigned long flags;
> +
> +	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
> +	spin_lock_irqsave(&wq_head->lock, flags);
> +	__add_wait_queue(wq_head, wq_entry);
> +	spin_unlock_irqrestore(&wq_head->lock, flags);
> +}
> +EXPORT_SYMBOL_GPL(add_wait_queue_priority);
> +
>  void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
>  {
>  	unsigned long flags;
> @@ -57,7 +68,11 @@ EXPORT_SYMBOL(remove_wait_queue);
>  /*
>   * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
>   * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
> - * number) then we wake all the non-exclusive tasks and one exclusive task.
> + * number) then we wake that number of exclusive tasks, and potentially all
> + * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
> + * the list and any non-exclusive tasks will be woken first. A priority task
> + * may be at the head of the list, and can consume the event without any other
> + * tasks being woken.
>   *
>   * There are circumstances in which we can try to wake a task which has already
>   * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
> -- 
> 2.26.2
> 
