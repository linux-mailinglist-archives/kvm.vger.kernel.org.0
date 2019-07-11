Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C45A658ED
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfGKO3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:29:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43852 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbfGKO3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:29:24 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO75F013247;
        Thu, 11 Jul 2019 14:26:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=DxKvEFI9OqvnwAFHfsS7VJpKVi8ynRLOZoMuRYswZIw=;
 b=k3XXPihT1uvy+OLIiRmWMdfDXIT+WHMFAjj45U6uCpQ8rV2jfdSnRJmMQA1mV5ALTQyT
 PERU4/YPhFf4ckQAGG2rOQDm5vbl52OROkwzviVZDqxaVQLQCpGKejd6n6Gi8g/OW973
 b1WRq4uNsMv9cAwP/H6vRscq1e3iobbZ324Tq6PgoCdWFemJ/1YPJhNIMn+keJv5JOQh
 Ff8q9kmaJ7pYkwC9amWnZvecFXs6OmpibtOtjhm23oXx9IX6dzIXv0YiCsY7b8cavCtn
 S3SvjejyJfLMAMiB7WwpFazOkLIoHuippfiDTsTbnPYepjTPVENPQMOCjagrpefgERlp TA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2tjm9r0brp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:41 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuA021444;
        Thu, 11 Jul 2019 14:26:37 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 17/26] rcu: Move tree.h static forward declarations to tree.c
Date:   Thu, 11 Jul 2019 16:25:29 +0200
Message-Id: <1562855138-19507-18-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree.h has static forward declarations for inline function declared
in tree_plugin.h and tree_stall.h. These forward declarations prevent
including tree.h into a file different from tree.c

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 kernel/rcu/tree.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/rcu/tree.h |   55 +----------------------------------------------------
 2 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 980ca3c..44dd3b4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -55,6 +55,60 @@
 #include "tree.h"
 #include "rcu.h"
 
+/* Forward declarations for tree_plugin.h */
+static void rcu_bootup_announce(void);
+static void rcu_qs(void);
+static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
+#ifdef CONFIG_HOTPLUG_CPU
+static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static int rcu_print_task_exp_stall(struct rcu_node *rnp);
+static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
+static void rcu_flavor_sched_clock_irq(int user);
+static void dump_blkd_tasks(struct rcu_node *rnp, int ncheck);
+static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
+static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
+static void invoke_rcu_callbacks_kthread(void);
+static bool rcu_is_callbacks_kthread(void);
+static void __init rcu_spawn_boost_kthreads(void);
+static void rcu_prepare_kthreads(int cpu);
+static void rcu_cleanup_after_idle(void);
+static void rcu_prepare_for_idle(void);
+static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
+static bool rcu_preempt_need_deferred_qs(struct task_struct *t);
+static void rcu_preempt_deferred_qs(struct task_struct *t);
+static void zero_cpu_stall_ticks(struct rcu_data *rdp);
+static bool rcu_nocb_cpu_needs_barrier(int cpu);
+static struct swait_queue_head *rcu_nocb_gp_get(struct rcu_node *rnp);
+static void rcu_nocb_gp_cleanup(struct swait_queue_head *sq);
+static void rcu_init_one_nocb(struct rcu_node *rnp);
+static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
+			    bool lazy, unsigned long flags);
+static bool rcu_nocb_adopt_orphan_cbs(struct rcu_data *my_rdp,
+				      struct rcu_data *rdp,
+				      unsigned long flags);
+static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
+static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
+static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
+static void rcu_spawn_cpu_nocb_kthread(int cpu);
+static void __init rcu_spawn_nocb_kthreads(void);
+#ifdef CONFIG_RCU_NOCB_CPU
+static void __init rcu_organize_nocb_kthreads(void);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+static bool init_nocb_callback_list(struct rcu_data *rdp);
+static unsigned long rcu_get_n_cbs_nocb_cpu(struct rcu_data *rdp);
+static void rcu_bind_gp_kthread(void);
+static bool rcu_nohz_full_cpu(void);
+static void rcu_dynticks_task_enter(void);
+static void rcu_dynticks_task_exit(void);
+
+/* Forward declarations for tree_stall.h */
+static void record_gp_stall_check_time(void);
+static void rcu_iw_handler(struct irq_work *iwp);
+static void check_cpu_stall(struct rcu_data *rdp);
+static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
+				     const unsigned long gpssdelay);
+
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
 #endif
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index e253d11..9790b58 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -392,58 +392,5 @@ struct rcu_state {
 #endif /* #else #ifdef CONFIG_TRACING */
 
 int rcu_dynticks_snap(struct rcu_data *rdp);
-
-/* Forward declarations for tree_plugin.h */
-static void rcu_bootup_announce(void);
-static void rcu_qs(void);
-static int rcu_preempt_blocked_readers_cgp(struct rcu_node *rnp);
-#ifdef CONFIG_HOTPLUG_CPU
-static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
-#endif /* #ifdef CONFIG_HOTPLUG_CPU */
-static int rcu_print_task_exp_stall(struct rcu_node *rnp);
-static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
-static void rcu_flavor_sched_clock_irq(int user);
 void call_rcu(struct rcu_head *head, rcu_callback_t func);
-static void dump_blkd_tasks(struct rcu_node *rnp, int ncheck);
-static void rcu_initiate_boost(struct rcu_node *rnp, unsigned long flags);
-static void rcu_preempt_boost_start_gp(struct rcu_node *rnp);
-static void invoke_rcu_callbacks_kthread(void);
-static bool rcu_is_callbacks_kthread(void);
-static void __init rcu_spawn_boost_kthreads(void);
-static void rcu_prepare_kthreads(int cpu);
-static void rcu_cleanup_after_idle(void);
-static void rcu_prepare_for_idle(void);
-static bool rcu_preempt_has_tasks(struct rcu_node *rnp);
-static bool rcu_preempt_need_deferred_qs(struct task_struct *t);
-static void rcu_preempt_deferred_qs(struct task_struct *t);
-static void zero_cpu_stall_ticks(struct rcu_data *rdp);
-static bool rcu_nocb_cpu_needs_barrier(int cpu);
-static struct swait_queue_head *rcu_nocb_gp_get(struct rcu_node *rnp);
-static void rcu_nocb_gp_cleanup(struct swait_queue_head *sq);
-static void rcu_init_one_nocb(struct rcu_node *rnp);
-static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
-			    bool lazy, unsigned long flags);
-static bool rcu_nocb_adopt_orphan_cbs(struct rcu_data *my_rdp,
-				      struct rcu_data *rdp,
-				      unsigned long flags);
-static int rcu_nocb_need_deferred_wakeup(struct rcu_data *rdp);
-static void do_nocb_deferred_wakeup(struct rcu_data *rdp);
-static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
-static void rcu_spawn_cpu_nocb_kthread(int cpu);
-static void __init rcu_spawn_nocb_kthreads(void);
-#ifdef CONFIG_RCU_NOCB_CPU
-static void __init rcu_organize_nocb_kthreads(void);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
-static bool init_nocb_callback_list(struct rcu_data *rdp);
-static unsigned long rcu_get_n_cbs_nocb_cpu(struct rcu_data *rdp);
-static void rcu_bind_gp_kthread(void);
-static bool rcu_nohz_full_cpu(void);
-static void rcu_dynticks_task_enter(void);
-static void rcu_dynticks_task_exit(void);
-
-/* Forward declarations for tree_stall.h */
-static void record_gp_stall_check_time(void);
-static void rcu_iw_handler(struct irq_work *iwp);
-static void check_cpu_stall(struct rcu_data *rdp);
-static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
-				     const unsigned long gpssdelay);
+
-- 
1.7.1

