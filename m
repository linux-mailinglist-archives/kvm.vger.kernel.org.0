Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41FE4349C1
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 13:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhJTLJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 07:09:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229864AbhJTLJM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 07:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634728018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8clfGjJTwttWCiDQZKtYU+5PDFlvzDwGeraH2AZ1ESc=;
        b=C94FnU/SS0Wj4ix5CSzH0a/ln0RBr+XsYCBodahCdIsWPR2hUPoLxXwE0N2QD1tIvQkgOE
        Hzd760oMT7sDvwZTGhMipna2z91sz47NVHoTu1IG7nSbbFuIVu3wtAb/22VxL9KkPyZ4H9
        o2Q3XxXQnEbgU+VXx64j/kQWHw6AGsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-evsykViCM7CgqIU9vSKmuw-1; Wed, 20 Oct 2021 07:06:52 -0400
X-MC-Unique: evsykViCM7CgqIU9vSKmuw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 392D719251A2;
        Wed, 20 Oct 2021 11:06:51 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EB5960CC4;
        Wed, 20 Oct 2021 11:06:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH] rcuwait: do not enter RCU protection unless a wakeup is needed
Date:   Wed, 20 Oct 2021 07:06:38 -0400
Message-Id: <20211020110638.797389-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some cases, rcuwait_wake_up can be called even if the actual likelihood
of a wakeup is very low.  If CONFIG_PREEMPT_RCU is active, the resulting
rcu_read_lock/rcu_read_unlock pair can be relatively expensive, and in
fact it is unnecessary when there is no w->task to keep alive: the
memory barrier before the read is what matters in order to avoid missed
wakeups.

Therefore, do an early check of w->task right after the barrier, and skip
rcu_read_lock/rcu_read_unlock unless there is someone waiting for a wakeup.

Running kvm-unit-test/vmexit.flat with APICv disabled, most interrupt
injection tests (tscdeadline*, self_ipi*, x2apic_self_ipi*) improve
by around 600 cpu cycles.

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Reported-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 kernel/exit.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 91a43e57a32e..a38a08dbf85e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -234,8 +234,6 @@ int rcuwait_wake_up(struct rcuwait *w)
 	int ret = 0;
 	struct task_struct *task;
 
-	rcu_read_lock();
-
 	/*
 	 * Order condition vs @task, such that everything prior to the load
 	 * of @task is visible. This is the condition as to why the user called
@@ -245,10 +243,22 @@ int rcuwait_wake_up(struct rcuwait *w)
 	 *    WAIT                WAKE
 	 *    [S] tsk = current	  [S] cond = true
 	 *        MB (A)	      MB (B)
-	 *    [L] cond		  [L] tsk
+	 *    [L] cond		  [L] rcuwait_active(w)
+	 *                            task = rcu_dereference(w->task)
 	 */
 	smp_mb(); /* (B) */
 
+#ifdef CONFIG_PREEMPT_RCU
+	/*
+	 * The cost of rcu_read_lock() dominates for preemptible RCU,
+	 * avoid it if possible.
+	 */
+	if (!rcuwait_active(w))
+		return ret;
+#endif
+
+	rcu_read_lock();
+
 	task = rcu_dereference(w->task);
 	if (task)
 		ret = wake_up_process(task);
-- 
2.27.0

