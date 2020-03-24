Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581CB190494
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 05:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgCXEqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 00:46:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:39590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCXEqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 00:46:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0E97FB1C6;
        Tue, 24 Mar 2020 04:46:10 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/4] rcuwait: Let rcuwait_wake_up() return whether or not a task was awoken
Date:   Mon, 23 Mar 2020 21:44:51 -0700
Message-Id: <20200324044453.15733-3-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200324044453.15733-1-dave@stgolabs.net>
References: <20200324044453.15733-1-dave@stgolabs.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Propagating the return value of wake_up_process() back to the caller
can come in handy for future users, such as for statistics or
accounting purposes.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/rcuwait.h | 2 +-
 kernel/exit.c           | 7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 2ffe1ee6d482..6ebb23258a27 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -25,7 +25,7 @@ static inline void rcuwait_init(struct rcuwait *w)
 	w->task = NULL;
 }
 
-extern void rcuwait_wake_up(struct rcuwait *w);
+extern int rcuwait_wake_up(struct rcuwait *w);
 
 /*
  * The caller is responsible for locking around rcuwait_wait_event(),
diff --git a/kernel/exit.c b/kernel/exit.c
index a33c0baffdae..dbddc9d83407 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -225,8 +225,9 @@ void release_task(struct task_struct *p)
 		goto repeat;
 }
 
-void rcuwait_wake_up(struct rcuwait *w)
+int rcuwait_wake_up(struct rcuwait *w)
 {
+	int ret = 0;
 	struct task_struct *task;
 
 	rcu_read_lock();
@@ -246,8 +247,10 @@ void rcuwait_wake_up(struct rcuwait *w)
 
 	task = rcu_dereference(w->task);
 	if (task)
-		wake_up_process(task);
+		ret = wake_up_process(task);
 	rcu_read_unlock();
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(rcuwait_wake_up);
 
-- 
2.16.4

