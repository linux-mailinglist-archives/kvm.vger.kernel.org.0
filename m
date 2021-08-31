Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE65E3FC0A9
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 04:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239381AbhHaCCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 22:02:11 -0400
Received: from smtp180.sjtu.edu.cn ([202.120.2.180]:49658 "EHLO
        smtp180.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbhHaCCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Aug 2021 22:02:10 -0400
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp180.sjtu.edu.cn (Postfix) with ESMTPS id 8F2D5100869B1;
        Tue, 31 Aug 2021 10:01:13 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 48F5D228C9242;
        Tue, 31 Aug 2021 10:01:11 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XeyUk3hsZDdE; Tue, 31 Aug 2021 10:01:11 +0800 (CST)
Received: from sky.ipads-lab.se.sjtu.edu.cn (unknown [202.120.40.82])
        (Authenticated sender: skyele@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id D7C062036576A;
        Tue, 31 Aug 2021 10:00:48 +0800 (CST)
From:   Tianqiang Xu <skyele@sjtu.edu.cn>
To:     x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        kvm@vger.kernel.org, hpa@zytor.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Tianqiang Xu <skyele@sjtu.edu.cn>
Subject: [PATCH 4/4] KVM guest implementation
Date:   Tue, 31 Aug 2021 09:59:19 +0800
Message-Id: <20210831015919.13006-4-skyele@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210831015919.13006-1-skyele@sjtu.edu.cn>
References: <20210831015919.13006-1-skyele@sjtu.edu.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guest OS uses 'is_idle' field of kvm_steal_time to know if a pCPU
is idle and decides whether to schedule a task to a preempted vCPU
or not. If the pCPU is idle, scheduling a task to this pCPU will
improve cpu utilization. If not, avoiding scheduling a task to this
preempted vCPU can avoid host/guest switch, hence improving performance.

Guest OS invokes available_idle_cpu_sched() to get the value of
'is_idle' field of kvm_steal_time.

Other modules in kernel except kernel/sched/fair.c which invokes
available_idle_cpu() is left unchanged, because other modules in
kernel need the semantic provided by 'preempted' field of kvm_steal_time.

--
Authors: Tianqiang Xu, Dingji Li, Zeyu Mi
	 Shanghai Jiao Tong University

Signed-off-by: Tianqiang Xu <skyele@sjtu.edu.cn>

---
 kernel/sched/fair.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c452072a1b..f69f0a8d2abe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5871,13 +5871,13 @@ wake_affine_idle(int this_cpu, int prev_cpu, int sync)
 	 * a cpufreq perspective, it's better to have higher utilisation
 	 * on one CPU.
 	 */
-	if (available_idle_cpu(this_cpu) && cpus_share_cache(this_cpu, prev_cpu))
-		return available_idle_cpu(prev_cpu) ? prev_cpu : this_cpu;
+	if (available_idle_cpu_sched(this_cpu) && cpus_share_cache(this_cpu, prev_cpu))
+		return available_idle_cpu_sched(prev_cpu) ? prev_cpu : this_cpu;
 
 	if (sync && cpu_rq(this_cpu)->nr_running == 1)
 		return this_cpu;
 
-	if (available_idle_cpu(prev_cpu))
+	if (available_idle_cpu_sched(prev_cpu))
 		return prev_cpu;
 
 	return nr_cpumask_bits;
@@ -5976,7 +5976,7 @@ find_idlest_group_cpu(struct sched_group *group, struct task_struct *p, int this
 		if (sched_idle_cpu(i))
 			return i;
 
-		if (available_idle_cpu(i)) {
+		if (available_idle_cpu_sched(i)) {
 			struct cpuidle_state *idle = idle_get_state(rq);
 			if (idle && idle->exit_latency < min_exit_latency) {
 				/*
@@ -6064,7 +6064,7 @@ static inline int find_idlest_cpu(struct sched_domain *sd, struct task_struct *p
 
 static inline int __select_idle_cpu(int cpu, struct task_struct *p)
 {
-	if ((available_idle_cpu(cpu) || sched_idle_cpu(cpu)) &&
+	if ((available_idle_cpu_sched(cpu) || sched_idle_cpu(cpu)) &&
 	    sched_cpu_cookie_match(cpu_rq(cpu), p))
 		return cpu;
 
@@ -6115,7 +6115,7 @@ void __update_idle_core(struct rq *rq)
 		if (cpu == core)
 			continue;
 
-		if (!available_idle_cpu(cpu))
+		if (!available_idle_cpu_sched(cpu))
 			goto unlock;
 	}
 
@@ -6138,7 +6138,7 @@ static int select_idle_core(struct task_struct *p, int core, struct cpumask *cpu
 		return __select_idle_cpu(core, p);
 
 	for_each_cpu(cpu, cpu_smt_mask(core)) {
-		if (!available_idle_cpu(cpu)) {
+		if (!available_idle_cpu_sched(cpu)) {
 			idle = false;
 			if (*idle_cpu == -1) {
 				if (sched_idle_cpu(cpu) && cpumask_test_cpu(cpu, p->cpus_ptr)) {
@@ -6171,7 +6171,7 @@ static int select_idle_smt(struct task_struct *p, struct sched_domain *sd, int t
 		if (!cpumask_test_cpu(cpu, p->cpus_ptr) ||
 		    !cpumask_test_cpu(cpu, sched_domain_span(sd)))
 			continue;
-		if (available_idle_cpu(cpu) || sched_idle_cpu(cpu))
+		if (available_idle_cpu_sched(cpu) || sched_idle_cpu(cpu))
 			return cpu;
 	}
 
@@ -6302,7 +6302,7 @@ select_idle_capacity(struct task_struct *p, struct sched_domain *sd, int target)
 	for_each_cpu_wrap(cpu, cpus, target) {
 		unsigned long cpu_cap = capacity_of(cpu);
 
-		if (!available_idle_cpu(cpu) && !sched_idle_cpu(cpu))
+		if (!available_idle_cpu_sched(cpu) && !sched_idle_cpu(cpu))
 			continue;
 		if (fits_capacity(task_util, cpu_cap))
 			return cpu;
@@ -6348,7 +6348,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 */
 	lockdep_assert_irqs_disabled();
 
-	if ((available_idle_cpu(target) || sched_idle_cpu(target)) &&
+	if ((available_idle_cpu_sched(target) || sched_idle_cpu(target)) &&
 	    asym_fits_capacity(task_util, target))
 		return target;
 
@@ -6356,7 +6356,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	 * If the previous CPU is cache affine and idle, don't be stupid:
 	 */
 	if (prev != target && cpus_share_cache(prev, target) &&
-	    (available_idle_cpu(prev) || sched_idle_cpu(prev)) &&
+	    (available_idle_cpu_sched(prev) || sched_idle_cpu(prev)) &&
 	    asym_fits_capacity(task_util, prev))
 		return prev;
 
@@ -6379,7 +6379,7 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 	if (recent_used_cpu != prev &&
 	    recent_used_cpu != target &&
 	    cpus_share_cache(recent_used_cpu, target) &&
-	    (available_idle_cpu(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
+	    (available_idle_cpu_sched(recent_used_cpu) || sched_idle_cpu(recent_used_cpu)) &&
 	    cpumask_test_cpu(p->recent_used_cpu, p->cpus_ptr) &&
 	    asym_fits_capacity(task_util, recent_used_cpu)) {
 		/*
-- 
2.26.0

