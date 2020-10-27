Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1882B29B266
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 15:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762123AbgJ0Ok4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 10:40:56 -0400
Received: from casper.infradead.org ([90.155.50.34]:43762 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368455AbgJ0Ojv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Kqa4yz0KkuVBYzisYBgpS52crCT6S1zza5R6m2vJgLM=; b=FGIqjYJGytS879QBSS19P1et+/
        G83SLYh56u2jo3v9R4Xl7YAnYA/1nHPvC48yrrdY4hC5n2QEx48roKnw2B2GHbbzDAsmMqDY0MG7m
        ZGeFqpplzjYZj/9mDMyPQRZn+aRnVb9TfzSX+foN04QdCIpSh22fm6GU1XkDixzN7z9IXP1qoIFIJ
        r4Q180PqX4f92Xv+3lUOVyL4CkmIL5wA/4mIWnTrYUnVvZ+6pxrLbJqDZ0pECLtMVEG0SegS4bxBK
        4Ev9yPfxhnk98PhWNLi/kiL7sdTWhNcGM4x6nFQeGNjgUY2riSArBS83oPyyA1q2QhOM46i8Jwpfk
        ld4HXjmQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXQ8Z-0005C4-1A; Tue, 27 Oct 2020 14:39:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kXQ8Y-002iqf-Eo; Tue, 27 Oct 2020 14:39:46 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 1/2] sched/wait: Add add_wait_queue_priority()
Date:   Tue, 27 Oct 2020 14:39:43 +0000
Message-Id: <20201027143944.648769-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201027143944.648769-1-dwmw2@infradead.org>
References: <20201026175325.585623-1-dwmw2@infradead.org>
 <20201027143944.648769-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This allows an exclusive wait_queue_entry to be added at the head of the
queue, instead of the tail as normal. Thus, it gets to consume events
first without allowing non-exclusive waiters to be woken at all.

The (first) intended use is for KVM IRQFD, which currently has
inconsistent behaviour depending on whether posted interrupts are
available or not. If they are, KVM will bypass the eventfd completely
and deliver interrupts directly to the appropriate vCPU. If not, events
are delivered through the eventfd and userspace will receive them when
polling on the eventfd.

By using add_wait_queue_priority(), KVM will be able to consistently
consume events within the kernel without accidentally exposing them
to userspace when they're supposed to be bypassed. This, in turn, means
that userspace doesn't have to jump through hoops to avoid listening
on the erroneously noisy eventfd and injecting duplicate interrupts.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/wait.h | 12 +++++++++++-
 kernel/sched/wait.c  | 17 ++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 27fb99cfeb02..fe10e8570a52 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -22,6 +22,7 @@ int default_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int
 #define WQ_FLAG_BOOKMARK	0x04
 #define WQ_FLAG_CUSTOM		0x08
 #define WQ_FLAG_DONE		0x10
+#define WQ_FLAG_PRIORITY	0x20
 
 /*
  * A single wait-queue entry structure:
@@ -164,11 +165,20 @@ static inline bool wq_has_sleeper(struct wait_queue_head *wq_head)
 
 extern void add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 extern void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
+extern void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 extern void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 
 static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
-	list_add(&wq_entry->entry, &wq_head->head);
+	struct list_head *head = &wq_head->head;
+	struct wait_queue_entry *wq;
+
+	list_for_each_entry(wq, &wq_head->head, entry) {
+		if (!(wq->flags & WQ_FLAG_PRIORITY))
+			break;
+		head = &wq->entry;
+	}
+	list_add(&wq_entry->entry, head);
 }
 
 /*
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 01f5d3020589..183cc6ae68a6 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -37,6 +37,17 @@ void add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive);
 
+void add_wait_queue_priority(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+{
+	unsigned long flags;
+
+	wq_entry->flags |= WQ_FLAG_EXCLUSIVE | WQ_FLAG_PRIORITY;
+	spin_lock_irqsave(&wq_head->lock, flags);
+	__add_wait_queue(wq_head, wq_entry);
+	spin_unlock_irqrestore(&wq_head->lock, flags);
+}
+EXPORT_SYMBOL_GPL(add_wait_queue_priority);
+
 void remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	unsigned long flags;
@@ -57,7 +68,11 @@ EXPORT_SYMBOL(remove_wait_queue);
 /*
  * The core wakeup function. Non-exclusive wakeups (nr_exclusive == 0) just
  * wake everything up. If it's an exclusive wakeup (nr_exclusive == small +ve
- * number) then we wake all the non-exclusive tasks and one exclusive task.
+ * number) then we wake that number of exclusive tasks, and potentially all
+ * the non-exclusive tasks. Normally, exclusive tasks will be at the end of
+ * the list and any non-exclusive tasks will be woken first. A priority task
+ * may be at the head of the list, and can consume the event without any other
+ * tasks being woken.
  *
  * There are circumstances in which we can try to wake a task which has already
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
-- 
2.26.2

