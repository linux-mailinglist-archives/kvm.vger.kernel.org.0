Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA8429D61D
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgJ1WLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730756AbgJ1WLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Oct 2020 18:11:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B01DC0613CF
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 15:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zUBsD6kXv9R5q2ieTU/vKIX/xuSzhBivJE07aN4MF88=; b=FCypvOLCfVeg4VmKUMbf0y+yjs
        kqSukqEpyEhgUUtkhIGxIRPRzTMLfboByDy6ZHLtf2J1MvHPSQpITW4dk67TQ4rXIGZeQXT7cd7dR
        Dyg464s1FjM7wI5Z8ag5Uq+4gZ9yF1sWNyDaC7U/laBdmLfs0E/XiT7PgXa+NluCNvsa4lv3qIoVF
        loLZQWae/vtm2zkwb9lsReDTjxNzGKTRyWfwWslkjAJMJqwLFS52ZPUTTBbpg5Ybt4PNA8JF03gel
        Q7/TgyahRKp0DB1chfw0Cj3gfWq3s2w72rTYtSA5w6Wg2WdU06IdUTxuWbjUch3hZ/0KH08Z2tAzX
        /8J0Qing==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXmJY-0003Uc-1B; Wed, 28 Oct 2020 14:20:36 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 22EE73006D0;
        Wed, 28 Oct 2020 15:20:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E0A0520315073; Wed, 28 Oct 2020 15:20:31 +0100 (CET)
Date:   Wed, 28 Oct 2020 15:20:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Davide Libenzi <davidel@xmailserver.org>,
        "Davi E. M. Arnaut" <davi@haxent.com.br>, davi@verdesmares.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
Message-ID: <20201028142031.GZ2628@hirez.programming.kicks-ass.net>
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
 <20201027143944.648769-2-dwmw2@infradead.org>
 <20201027190919.GO2628@hirez.programming.kicks-ass.net>
 <220a7b090d27ffc8f3d00253c289ddd964a8462b.camel@infradead.org>
 <20201027203041.GS2628@hirez.programming.kicks-ass.net>
 <0bc19d43229d73c0fcd5bda1987e3dbb9d62a7e0.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bc19d43229d73c0fcd5bda1987e3dbb9d62a7e0.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 27, 2020 at 09:32:11PM +0000, David Woodhouse wrote:
> On Tue, 2020-10-27 at 21:30 +0100, Peter Zijlstra wrote:
> > On Tue, Oct 27, 2020 at 07:27:59PM +0000, David Woodhouse wrote:
> > 
> > > > While looking at this I found that weird __add_wait_queue_exclusive()
> > > > which is used by fs/eventpoll.c and does something similar, except it
> > > > doesn't keep the FIFO order.
> > > 
> > > It does, doesn't it? Except those so-called "exclusive" entries end up
> > > in FIFO order amongst themselves at the *tail* of the queue, to be
> > > woken up only after all the other entries before them *haven't* been
> > > excluded.
> > 
> > __add_wait_queue_exclusive() uses __add_wait_queue() which does
> > list_add(). It does _not_ add at the tail like normal exclusive users,
> > and there is exactly _1_ user in tree that does this.
> > 
> > I'm not exactly sure how this happened, but:
> > 
> >   add_wait_queue_exclusive()
> > 
> > and
> > 
> >   __add_wait_queue_exclusive()
> > 
> > are not related :-(
> 
> I think that goes all the way back to here:
> 
> https://lkml.org/lkml/2007/5/4/530
> 
> It was rounded up in commit d47de16c72and subsequently "cleaned up"
> into an inline in wait.h, but I don't think there was ever a reason for
> it to be added to the head of the list instead of the tail.

Maybe, I'm not sure I can tell in a hurry. I've opted to undo the above
'cleanups'

> So I think we can reasonably make __add_wait_queue_exclusive() do
> precisely the same thing as add_wait_queue_exclusive() does (modulo
> locking).

Aye, see below.

> And then potentially rename them both to something that isn't quite
> such a lie. And give me the one I want that *does* actually exclude
> other waiters :)

I don't think we want to do that; people are very much used to the
current semantics.

I also very much want to do:
s/__add_wait_queue_entry_tail/__add_wait_queue_tail/ on top of all this.

Anyway, I'll agree to your patch. How do we route this? Shall I take the
waitqueue thing and stick it in a topic branch for Paolo so he can then
merge that and the kvm bits on top into the KVM tree?

---
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4df61129566d..a2a7e1e339f6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1895,10 +1895,12 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		 */
 		eavail = ep_events_available(ep);
 		if (!eavail) {
-			if (signal_pending(current))
+			if (signal_pending(current)) {
 				res = -EINTR;
-			else
-				__add_wait_queue_exclusive(&ep->wq, &wait);
+			} else {
+				wq_entry->flags |= WQ_FLAG_EXCLUSIVE;
+				__add_wait_queue(wq_head, wq_entry);
+			}
 		}
 		write_unlock_irq(&ep->lock);
 
diff --git a/fs/orangefs/orangefs-bufmap.c b/fs/orangefs/orangefs-bufmap.c
index 538e839590ef..8cac3589f365 100644
--- a/fs/orangefs/orangefs-bufmap.c
+++ b/fs/orangefs/orangefs-bufmap.c
@@ -86,7 +86,7 @@ static int wait_for_free(struct slot_map *m)
 	do {
 		long n = left, t;
 		if (likely(list_empty(&wait.entry)))
-			__add_wait_queue_entry_tail_exclusive(&m->q, &wait);
+			__add_wait_queue_exclusive(&m->q, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (m->c > 0)
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 27fb99cfeb02..4b8c4ece13f7 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -171,23 +171,13 @@ static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait
 	list_add(&wq_entry->entry, &wq_head->head);
 }
 
-/*
- * Used for wake-one threads:
- */
-static inline void
-__add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
-{
-	wq_entry->flags |= WQ_FLAG_EXCLUSIVE;
-	__add_wait_queue(wq_head, wq_entry);
-}
-
 static inline void __add_wait_queue_entry_tail(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	list_add_tail(&wq_entry->entry, &wq_head->head);
 }
 
 static inline void
-__add_wait_queue_entry_tail_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+__add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	wq_entry->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue_entry_tail(wq_head, wq_entry);

