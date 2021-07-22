Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB3B3D1CD1
	for <lists+kvm@lfdr.de>; Thu, 22 Jul 2021 06:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhGVDZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 23:25:23 -0400
Received: from mx315.baidu.com ([180.101.52.204]:43427 "EHLO
        njjs-sys-mailin05.njjs.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229850AbhGVDZW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 23:25:22 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jul 2021 23:25:22 EDT
Received: from unknown.domain.tld (bjhw-sys-rpm015653cc5.bjhw.baidu.com [10.227.53.39])
        by njjs-sys-mailin05.njjs.baidu.com (Postfix) with ESMTP id C986CCF80058;
        Thu, 22 Jul 2021 11:58:07 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     pbonzini@redhat.com, mingo@redhat.com, peterz@infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Consider SMT idle status when halt polling
Date:   Thu, 22 Jul 2021 11:58:07 +0800
Message-Id: <20210722035807.36937-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.9.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SMT siblings share caches and other hardware, halt polling
will degrade its sibling performance if its sibling is busy

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/kvm_host.h |  5 ++++-
 include/linux/sched.h    | 17 +++++++++++++++++
 kernel/sched/fair.c      | 17 -----------------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b..15b3ef4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -269,7 +269,10 @@ static inline bool kvm_vcpu_mapped(struct kvm_host_map *map)
 
 static inline bool kvm_vcpu_can_poll(ktime_t cur, ktime_t stop)
 {
-	return single_task_running() && !need_resched() && ktime_before(cur, stop);
+	return single_task_running() &&
+		   !need_resched() &&
+		   ktime_before(cur, stop) &&
+		   is_core_idle(raw_smp_processor_id());
 }
 
 /*
diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8d07d..c333218 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -34,6 +34,7 @@
 #include <linux/rseq.h>
 #include <linux/seqlock.h>
 #include <linux/kcsan.h>
+#include <linux/topology.h>
 #include <asm/kmap_size.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
@@ -2191,6 +2192,22 @@ int sched_trace_rq_nr_running(struct rq *rq);
 
 const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
 
+static inline bool is_core_idle(int cpu)
+{
+#ifdef CONFIG_SCHED_SMT
+	int sibling;
+
+	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
+		if (cpu == sibling)
+			continue;
+
+		if (!idle_cpu(cpu))
+			return false;
+	}
+#endif
+	return true;
+}
+
 #ifdef CONFIG_SCHED_CORE
 extern void sched_core_free(struct task_struct *tsk);
 extern void sched_core_fork(struct task_struct *p);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c4520..5b0259c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1477,23 +1477,6 @@ struct numa_stats {
 	int idle_cpu;
 };
 
-static inline bool is_core_idle(int cpu)
-{
-#ifdef CONFIG_SCHED_SMT
-	int sibling;
-
-	for_each_cpu(sibling, cpu_smt_mask(cpu)) {
-		if (cpu == sibling)
-			continue;
-
-		if (!idle_cpu(cpu))
-			return false;
-	}
-#endif
-
-	return true;
-}
-
 struct task_numa_env {
 	struct task_struct *p;
 
-- 
2.9.4

