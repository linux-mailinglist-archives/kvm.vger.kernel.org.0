Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E034299595
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 19:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790216AbgJZSmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 14:42:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38716 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1790210AbgJZSmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 14:42:50 -0400
X-Greylist: delayed 2953 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 14:42:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Reply-To:
        Cc:Content-Type:Content-ID:Content-Description;
        bh=3eNfIxXQfuIT8PEgxo5d3Pp3p468YN5tOuhs/d1crmY=; b=HQBtrqmTjyu28+6/7d8Np+Tb1x
        EPWE2+Q5Ha4DJTVrtZEHqtwb1hCq6qG3NlQrkcwZ6t1UgY2eof5d8Wy6mZXiHEe/+leFLQHVaFVlz
        nXf3FjG6KYlPI8h89eW2y97p3fcp3D97AMiXjhVjKr91fUteoS6rivHE5IOn6n08yPln/VyrVx2NZ
        xOTLS013Ob03riuBTlwLWMhYELZAyu2D8fMR5rBoYAQOvGRjkhTBRg0LjcVRC0Ecwsgt2dYAxMynb
        tkSjB8LgnOo/eXnZ0gEDyIQ59jMFH6FpuC7TdAmLhkIYoHgM4MJ64eNmZvxvGpeciFii5a0Q5XVV1
        g5/kLCUQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kX6gR-0007Pa-07; Mon, 26 Oct 2020 17:53:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kX6gP-002SMJ-VV; Mon, 26 Oct 2020 17:53:25 +0000
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
Subject: [RFC PATCH 2/2] kvm/eventfd: Use priority waitqueue to catch events before userspace
Date:   Mon, 26 Oct 2020 17:53:25 +0000
Message-Id: <20201026175325.585623-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026175325.585623-1-dwmw2@infradead.org>
References: <20201026175325.585623-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

As far as I can tell, when we use posted interrupts we silently cut off
the events from userspace, if it's listening on the same eventfd that
feeds the irqfd.

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
index d6408bb497dc..39443e2f72bf 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -191,6 +191,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 	struct kvm *kvm = irqfd->kvm;
 	unsigned seq;
 	int idx;
+	int ret = 0;
 
 	if (flags & EPOLLIN) {
 		idx = srcu_read_lock(&kvm->irq_srcu);
@@ -204,6 +205,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 					      false) == -EWOULDBLOCK)
 			schedule_work(&irqfd->inject);
 		srcu_read_unlock(&kvm->irq_srcu, idx);
+		ret = 1;
 	}
 
 	if (flags & EPOLLHUP) {
@@ -227,7 +229,7 @@ irqfd_wakeup(wait_queue_entry_t *wait, unsigned mode, int sync, void *key)
 		spin_unlock_irqrestore(&kvm->irqfds.lock, iflags);
 	}
 
-	return 0;
+	return ret;
 }
 
 static void
@@ -236,7 +238,7 @@ irqfd_ptable_queue_proc(struct file *file, wait_queue_head_t *wqh,
 {
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(pt, struct kvm_kernel_irqfd, pt);
-	add_wait_queue(wqh, &irqfd->wait);
+	add_wait_queue_priority(wqh, &irqfd->wait);
 }
 
 /* Must be called under irqfds.lock */
-- 
2.26.2

