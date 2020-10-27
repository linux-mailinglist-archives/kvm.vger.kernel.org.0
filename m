Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0073D29B268
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 15:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762129AbgJ0OlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 10:41:05 -0400
Received: from casper.infradead.org ([90.155.50.34]:43764 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368457AbgJ0Oju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tbOYj5t0+tvCkSDg3zSqNJaUCRlXrtQoNZf64wI8RcI=; b=wA7xeMSpDfKI2x3RCUXsWrZ+tx
        x5PE0v2FwERIRcZVCXTLumHTQ80DtcQcYmNCJi0cnnjZtIVIKeylA74z1Lnn/kz9SaMcxnq+dZ0s9
        aaSktn1KpMSYG9lwZ5UtvG9u/VimZbqXFX1KPGKzOTFfC9lCfdqJjeed3vvIvn8bZCo0adFXCs6Df
        0y4nrGHWoB8vImeBWmN0nvFjqsHfHEwY6Jjb6Zp8LPjhpqr48v9PU/2dYy5hTuxTPC+bUYgyo0auv
        l+m+wBJ1fspkW1dbODaolSzoy1GeASoyB5rtLZ0ObBzrHCAnXZHJCgs1U+6/pC4vlSOamcDMfaj1u
        +8Tgg2yQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXQ8Z-0005C5-1A; Tue, 27 Oct 2020 14:39:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kXQ8Y-002iqk-Fl; Tue, 27 Oct 2020 14:39:46 +0000
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
Subject: [PATCH v2 2/2] kvm/eventfd: Use priority waitqueue to catch events before userspace
Date:   Tue, 27 Oct 2020 14:39:44 +0000
Message-Id: <20201027143944.648769-3-dwmw2@infradead.org>
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

When posted interrupts are available, the IRTE is modified to deliver
interrupts direclty to the vCPU and nothing ever reaches userspace, if
it's listening on the same eventfd that feeds the irqfd.

I like that behaviour. Let's do it all the time, even without posted
interrupts. It makes it much easier to handle IRQ remapping invalidation
without having to constantly add/remove the fd from the userspace poll
set. We can just leave userspace polling on it, and the bypass will...
well... bypass it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/eventfd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 87fe94355350..09cbdf2ded70 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -191,6 +191,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	struct kvm *kvm = irqfd->kvm;
 	unsigned seq;
 	int idx;
+	int ret = 0;
 
 	if (flags & EPOLLIN) {
 		u64 cnt;
@@ -207,6 +208,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 					      false) == -EWOULDBLOCK)
 			schedule_work(&irqfd->inject);
 		srcu_read_unlock(&kvm->irq_srcu, idx);
+		ret = 1;
 	}
 
 	if (flags & EPOLLHUP) {
@@ -230,7 +232,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 		spin_unlock_irqrestore(&kvm->irqfds.lock, iflags);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void
@@ -239,7 +241,7 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(pt, struct kvm_kernel_irqfd, pt);
-	add_wait_queue(wqh, &irqfd->wait);
+	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
 /* Must be called under irqfds.lock */
-- 
2.26.2

