Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA2846EAC4
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhLIPNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbhLIPNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:13:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD6CC0617A2;
        Thu,  9 Dec 2021 07:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dcp/DLcq/tYHUUOo29oBlqjXVdLYFtHijfG9eHQJeNE=; b=SNUHCnPoe2yqv4DlJmMmcxf0ni
        eaZf326H5coJFpJ8VS2xDhgmj3MbEV786NGrsrSLtzADTLYwnLQ8jLJC8k80RwmUePhYjEIASqmdU
        LeTfcOuMQW2rf7wHGr2uxEO9CPG5s9Cwz9/zaUGEmR/o0JA9KXAtFlOtn0GbWjLKEBQHrsAdTE8dD
        PIRkWSz/nelM31aZECtK/R5R8Q8QHFovMVgzKoHU5vx8EWDofNyFZCqZNWYjcOItz2zcoh11ccg8I
        G8SwoGsK0oofXVKuHS5QijiS/mvW1Tqrxcr7RFb0EPX5c6A2GcRUbfFNplpdaWk7snkK7RrMdVi1o
        h4egZBlA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-000Nov-SW; Thu, 09 Dec 2021 15:09:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-0000xv-Gg; Thu, 09 Dec 2021 15:09:45 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH 03/11] rcu: Add mutex for rcu boost kthread spawning and affinity setting
Date:   Thu,  9 Dec 2021 15:09:30 +0000
Message-Id: <20211209150938.3518-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209150938.3518-1-dwmw2@infradead.org>
References: <20211209150938.3518-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

As we handle parallel CPU bringup, we will need to take care to avoid
spawning multiple boost threads, or race conditions when setting their
affinity. Spotted by Paul McKenney.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 kernel/rcu/tree.c        |  1 +
 kernel/rcu/tree.h        |  3 +++
 kernel/rcu/tree_plugin.h | 10 ++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index a1bb0b1229ed..809855474b39 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -4527,6 +4527,7 @@ static void __init rcu_init_one(void)
 			init_waitqueue_head(&rnp->exp_wq[2]);
 			init_waitqueue_head(&rnp->exp_wq[3]);
 			spin_lock_init(&rnp->exp_lock);
+			mutex_init(&rnp->boost_kthread_mutex);
 		}
 	}
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index aff4cc9303fb..055e30b3e5e0 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -108,6 +108,9 @@ struct rcu_node {
 				/*  side effect, not as a lock. */
 	unsigned long boost_time;
 				/* When to start boosting (jiffies). */
+	struct mutex boost_kthread_mutex;
+				/* Exclusion for thread spawning and affinity */
+				/*  manipulation. */
 	struct task_struct *boost_kthread_task;
 				/* kthread that takes care of priority */
 				/*  boosting for this rcu_node structure. */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 5199559fbbf0..3b4ee0933710 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1162,15 +1162,16 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
 	struct sched_param sp;
 	struct task_struct *t;
 
+	mutex_lock(&rnp->boost_kthread_mutex);
 	if (rnp->boost_kthread_task || !rcu_scheduler_fully_active)
-		return;
+		goto out;
 
 	rcu_state.boost = 1;
 
 	t = kthread_create(rcu_boost_kthread, (void *)rnp,
 			   "rcub/%d", rnp_index);
 	if (WARN_ON_ONCE(IS_ERR(t)))
-		return;
+		goto out;
 
 	raw_spin_lock_irqsave_rcu_node(rnp, flags);
 	rnp->boost_kthread_task = t;
@@ -1178,6 +1179,9 @@ static void rcu_spawn_one_boost_kthread(struct rcu_node *rnp)
 	sp.sched_priority = kthread_prio;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
+
+ out:
+	mutex_unlock(&rnp->boost_kthread_mutex);
 }
 
 /*
@@ -1200,6 +1204,7 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 		return;
 	if (!zalloc_cpumask_var(&cm, GFP_KERNEL))
 		return;
+	mutex_lock(&rnp->boost_kthread_mutex);
 	for_each_leaf_node_possible_cpu(rnp, cpu)
 		if ((mask & leaf_node_cpu_bit(rnp, cpu)) &&
 		    cpu != outgoingcpu)
@@ -1207,6 +1212,7 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 	if (cpumask_weight(cm) == 0)
 		cpumask_setall(cm);
 	set_cpus_allowed_ptr(t, cm);
+	mutex_unlock(&rnp->boost_kthread_mutex);
 	free_cpumask_var(cm);
 }
 
-- 
2.31.1

