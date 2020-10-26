Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7001299468
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 18:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788609AbgJZRxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 13:53:41 -0400
Received: from casper.infradead.org ([90.155.50.34]:46426 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781494AbgJZRxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 13:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=FBYzkNP+Cx2t2+3fMBPbsAF59I/mFG4FBtQVNq5FELU=; b=OOi9IhPPOXxjSjoIy5MiTJk6Zk
        3x3IjQEqzm0akf8SgC6HRY7vPt354oCO5ldxZDm7wddxMLSxc/06+SWeIfqeFjR7YZ/GvzdaTqLjO
        D4SOc3xGC94d8GQtMsKBjt3GvrIxgo/RuTORS5H+24MfdUd3yePkQbFfntv0AgRR942Z8cC/EWrza
        JmFm3I7Rrc+y8uBWe/nVAqfh27Ho1ScOTfkzNwJVGWozsi4skFFQOgoTGDP1UCx7ZEQTGlsI8hoLm
        sKgSQbmrSsX5O+qzHWG9ENThF5W7P1BsEgLTOHd/I5Oe0ZjuFwu1Hw+4cP38ZpKthir9fUflqH79r
        udE24Rww==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kX6gQ-0008Em-C8; Mon, 26 Oct 2020 17:53:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kX6gP-002SMG-Um; Mon, 26 Oct 2020 17:53:25 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC PATCH 1/2] sched/wait: Add add_wait_queue_priority()
Date:   Mon, 26 Oct 2020 17:53:24 +0000
Message-Id: <20201026175325.585623-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
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
first.

The problem I'm trying to solve here is interrupt remapping invalidation
vs. MSI interrupts from VFIO. I'd really like KVM IRQFD to be able to
consume events before (and indeed instead of) userspace.

When the remapped MSI target in the KVM routing table is invalidated,
the VMM needs to *deassociate* the IRQFD and fall back to handling the
next IRQ in userspace, so it can be retranslated and a fault reported
if appropriate.

It's possible to do that by constantly registering and deregistering the
fd in the userspace poll loop, but it gets ugly especially because the
fallback handler isn't really local to the core MSI handling.

It's much nicer if the userspace handler can just remain registered all
the time, and it just doesn't get any events when KVM steals them first.
Which is precisely what happens with posted interrupts, and this makes
it consistent. (Unless I'm missing something that prevents posted
interrupts from working when there's another listener on the eventfd?)

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/wait.h | 12 +++++++++++-
 kernel/sched/wait.c  | 11 +++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)

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
index 01f5d3020589..d2a84c8e88bf 100644
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
-- 
2.26.2

