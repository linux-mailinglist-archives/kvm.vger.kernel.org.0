Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B43D3FC0A5
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 04:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbhHaCBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 22:01:21 -0400
Received: from smtp181.sjtu.edu.cn ([202.120.2.181]:41048 "EHLO
        smtp181.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239357AbhHaCBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 22:01:20 -0400
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp181.sjtu.edu.cn (Postfix) with ESMTPS id 5E22D1008CBCD;
        Tue, 31 Aug 2021 10:00:23 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id B8CB4228C9242;
        Tue, 31 Aug 2021 10:00:21 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id va3NV7d66HyK; Tue, 31 Aug 2021 10:00:21 +0800 (CST)
Received: from sky.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
        (Authenticated sender: skyele@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id B4C51228C9235;
        Tue, 31 Aug 2021 09:59:58 +0800 (CST)
From:   Tianqiang Xu <skyele@sjtu.edu.cn>
To:     x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        kvm@vger.kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Tianqiang Xu <skyele@sjtu.edu.cn>
Subject: [PATCH 2/4] Scheduler changes
Date:   Tue, 31 Aug 2021 09:59:17 +0800
Message-Id: <20210831015919.13006-2-skyele@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831015919.13006-1-skyele@sjtu.edu.cn>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

available_idle_cpu_sched() invokes pcpu_is_idle() to detect whether
a pCPU where the preempted vCPU most recently run is idle or not, which
is used by the guest OS.

get_cpu_nr_running() gets the run queue of current cpu, which is used
by the host KVM to know whether a pCPU where the preempted vCPU mostly
recently run is idle or not.

--
Authors: Tianqiang Xu, Dingji Li, Zeyu Mi
	 Shanghai Jiao Tong University

Signed-off-by: Tianqiang Xu <skyele@sjtu.edu.cn>

---
 include/linux/sched.h |  1 +
 kernel/sched/core.c   | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ec8d07d88641..dd4c41d2d8d3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1736,6 +1736,7 @@ extern int can_nice(const struct task_struct *p, const int nice);
 extern int task_curr(const struct task_struct *p);
 extern int idle_cpu(int cpu);
 extern int available_idle_cpu(int cpu);
+extern int available_idle_cpu_sched(int cpu);
 extern int sched_setscheduler(struct task_struct *, int, const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int, const struct sched_param *);
 extern void sched_set_fifo(struct task_struct *p);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f3b27c6c5153..c777dbcbeb9c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6752,6 +6752,17 @@ int available_idle_cpu(int cpu)
 	return 1;
 }
 
+int available_idle_cpu_sched(int cpu)
+{
+	if (!idle_cpu(cpu))
+		return 0;
+
+	if (!pcpu_is_idle(cpu))
+		return 0;
+
+	return 1;
+}
+
 /**
  * idle_task - return the idle task for a given CPU.
  * @cpu: the processor in question.
@@ -10504,3 +10515,9 @@ void call_trace_sched_update_nr_running(struct rq *rq, int count)
 {
         trace_sched_update_nr_running_tp(rq, count);
 }
+
+int get_cpu_nr_running(int cpu)
+{
+	return cpu_rq(cpu)->nr_running;
+}
+EXPORT_SYMBOL_GPL(get_cpu_nr_running);
-- 
2.26.0

