Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C501B35FE
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 06:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgDVELx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 00:11:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:60088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgDVELw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 00:11:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 850FFADE1;
        Wed, 22 Apr 2020 04:11:49 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/5] rcuwait: Introduce prepare_to and finish_rcuwait
Date:   Tue, 21 Apr 2020 21:07:37 -0700
Message-Id: <20200422040739.18601-4-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200422040739.18601-1-dave@stgolabs.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows further flexibility for some callers to implement
ad-hoc versions of the generic rcuwait_wait_event(). For example,
kvm will need this to maintain tracing semantics. The naming
is of course similar to what waitqueue apis offer.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/rcuwait.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/rcuwait.h b/include/linux/rcuwait.h
index 6ebb23258a27..0c6a3d0d25ab 100644
--- a/include/linux/rcuwait.h
+++ b/include/linux/rcuwait.h
@@ -29,12 +29,25 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 
 /*
  * The caller is responsible for locking around rcuwait_wait_event(),
- * such that writes to @task are properly serialized.
+ * and prepare_to_rcuwait() such that writes to @task are properly
+ * serialized.
  */
+
+static inline void prepare_to_rcuwait(struct rcuwait *w)
+{
+	rcu_assign_pointer(w->task, current);
+}
+
+static inline void finish_rcuwait(struct rcuwait *w)
+{
+	WRITE_ONCE(w->task, NULL);
+	__set_current_state(TASK_RUNNING);
+}
+
 #define rcuwait_wait_event(w, condition, state)				\
 ({									\
 	int __ret = 0;							\
-	rcu_assign_pointer((w)->task, current);				\
+	prepare_to_rcuwait(w);						\
 	for (;;) {							\
 		/*							\
 		 * Implicit barrier (A) pairs with (B) in		\
@@ -51,9 +64,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
 									\
 		schedule();						\
 	}								\
-									\
-	WRITE_ONCE((w)->task, NULL);					\
-	__set_current_state(TASK_RUNNING);				\
+	finish_rcuwait(w);						\
 	__ret;								\
 })
 
-- 
2.16.4

