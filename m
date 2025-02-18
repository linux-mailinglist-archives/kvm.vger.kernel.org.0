Return-Path: <kvm+bounces-38483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B32EA3A974
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:41:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A939F7A550D
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:40:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748CB215791;
	Tue, 18 Feb 2025 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="f/bu+yi7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F42215169;
	Tue, 18 Feb 2025 20:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910479; cv=none; b=oWBJMoxYrx5hkt3HpXl8Unw9vnZIrKfHj6lgoXCCdMyc7YNC6e9WM/kIwI8Bq3kxrgh+W+CqQMwGKhNg5mPfnJFo2K405VvwkVp6y+1VgMtKM1qaS171El4aTi6HO3mNLU0IN8ADInuOvvp+G/VA7b2Bn+2hs4wRn+T9Lf+r4qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910479; c=relaxed/simple;
	bh=JTSEYbYS4Z/Ik62jE8h8jo3yLesydkKBCqS7gHREHyw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0pbn6yV/l4j7SDy4vCOtm/ZkQkRrGldy21/HlZPbyUOiFfsos6VuHG4CZjWbtBbBvlV3j/6xVVVjUmV3/0JFq6Uu4oLgI3zcOyEv0wez1TiL6eWEDExvV/GvU3JYIpU41yd8GytfqBkaSYwaz80K0E+rW3Nc0cD3MWNbC5pt/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=f/bu+yi7; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1739910476; x=1771446476;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=R71KixzSQhV/O62VTjLAK1KH6JMWl+uEPn9+qpQPkQU=;
  b=f/bu+yi7C+DU/XjFmM9TX7x1Ssaglr5HzXVrqsWLIW1qnKF/6TWkUrC1
   yiiYG3rBPH7QrxvPHvKWx8J1yHJ/gccWRAJ/Sa7GzErBtaRjOvWLeAiq5
   yok120g9wT3tuGIzEWSeo1iPk1fh3mrYHbgPi6qte8yhgJR2Wxvz+t11U
   0=;
X-IronPort-AV: E=Sophos;i="6.13,296,1732579200"; 
   d="scan'208";a="799874462"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2025 20:27:50 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.43.254:62137]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.11.108:2525] with esmtp (Farcaster)
 id 52050e94-2ff3-4b18-b080-d3b5f5682f76; Tue, 18 Feb 2025 20:27:48 +0000 (UTC)
X-Farcaster-Flow-ID: 52050e94-2ff3-4b18-b080-d3b5f5682f76
Received: from EX19D003EUB001.ant.amazon.com (10.252.51.97) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.39;
 Tue, 18 Feb 2025 20:27:46 +0000
Received: from u5934974a1cdd59.ant.amazon.com (10.146.13.227) by
 EX19D003EUB001.ant.amazon.com (10.252.51.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 18 Feb 2025 20:27:41 +0000
From: Fernand Sieber <sieberf@amazon.com>
To: <sieberf@amazon.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 3/3] sched,x86: Make the scheduler guest unhalted aware
Date: Tue, 18 Feb 2025 22:26:03 +0200
Message-ID: <20250218202618.567363-4-sieberf@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250218202618.567363-1-sieberf@amazon.com>
References: <20250218202618.567363-1-sieberf@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D035UWB001.ant.amazon.com (10.13.138.33) To
 EX19D003EUB001.ant.amazon.com (10.252.51.97)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With guest hlt/mwait/pause pass through, the scheduler has no visibility into
real vCPU activity as it sees them all 100% active. As such, load balancing
cannot make informed decisions on where it is preferrable to collocate
tasks when necessary. I.e as far as the load balancer is concerned, a
halted vCPU and an idle polling vCPU look exactly the same so it may decide
that either should be preempted when in reality it would be preferrable to
preempt the idle one.

This commits enlightens the scheduler to real guest activity in this
situation. Leveraging gtime unhalted, it adds a hook for kvm to communicate
to the scheduler the duration that a vCPU spends halted. This is then used in
PELT accounting to discount it from real activity. This results in better
placement and overall steal time reduction.

This initial implementation assumes that non-idle CPUs are ticking as it
hooks the unhalted time the PELT decaying load accounting. As such it
doesn't work well if PELT is updated infrequenly with large chunks of
halted time. This is not a fundamental limitation but more complex
accounting is needed to generalize the use case to nohz full.
---
 arch/x86/kvm/x86.c    |  8 ++++++--
 include/linux/sched.h |  4 ++++
 kernel/sched/core.c   |  1 +
 kernel/sched/fair.c   | 25 +++++++++++++++++++++++++
 kernel/sched/pelt.c   | 42 +++++++++++++++++++++++++++++++++++-------
 kernel/sched/sched.h  |  2 ++
 6 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46975b0a63a5..156cf05b325f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10712,6 +10712,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	int r;
 	unsigned long long cycles, cycles_start = 0;
 	unsigned long long unhalted_cycles, unhalted_cycles_start = 0;
+	unsigned long long halted_cycles_ns = 0;
 	bool req_int_win =
 		dm_request_for_irq_injection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
@@ -11083,8 +11084,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		cycles = get_cycles() - cycles_start;
 		unhalted_cycles = get_unhalted_cycles() -
 			unhalted_cycles_start;
-		if (likely(cycles > unhalted_cycles))
-			current->gtime_halted += cycles2ns(cycles - unhalted_cycles);
+		if (likely(cycles > unhalted_cycles)) {
+			halted_cycles_ns = cycles2ns(cycles - unhalted_cycles);
+			current->gtime_halted += halted_cycles_ns;
+			sched_account_gtime_halted(current, halted_cycles_ns);
+		}
 	}

 	local_irq_enable();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5f6745357e20..5409fac152c9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -367,6 +367,8 @@ struct vtime {
 	u64			gtime;
 };

+extern void sched_account_gtime_halted(struct task_struct *p, u64 gtime_halted);
+
 /*
  * Utilization clamp constraints.
  * @UCLAMP_MIN:	Minimum utilization
@@ -588,6 +590,8 @@ struct sched_entity {
 	 */
 	struct sched_avg		avg;
 #endif
+
+	u64				gtime_halted;
 };

 struct sched_rt_entity {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9aecd914ac69..1f3ced2b2636 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4487,6 +4487,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	p->se.nr_migrations		= 0;
 	p->se.vruntime			= 0;
 	p->se.vlag			= 0;
+	p->se.gtime_halted              = 0;
 	INIT_LIST_HEAD(&p->se.group_node);

 	/* A delayed task cannot be in clone(). */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1c0ef435a7aa..5ff52711d459 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -13705,4 +13705,29 @@ __init void init_sched_fair_class(void)
 #endif
 #endif /* SMP */

+
+}
+
+#ifdef CONFIG_NO_HZ_FULL
+void sched_account_gtime_halted(struct task_struct *p, u64 gtime_halted)
+{
 }
+#else
+/*
+ * The implementation hooking into PELT requires regular updates of
+ * gtime_halted. This is guaranteed unless we run on CONFIG_NO_HZ_FULL.
+ */
+void sched_account_gtime_halted(struct task_struct *p, u64 gtime_halted)
+{
+	struct sched_entity *se = &p->se;
+
+	if (unlikely(!gtime_halted))
+		return;
+
+	for_each_sched_entity(se) {
+		se->gtime_halted += gtime_halted;
+		se->cfs_rq->gtime_halted += gtime_halted;
+	}
+}
+#endif
+EXPORT_SYMBOL(sched_account_gtime_halted);
diff --git a/kernel/sched/pelt.c b/kernel/sched/pelt.c
index 7a8534a2deff..9f96b7c46c00 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -305,10 +305,23 @@ int __update_load_avg_blocked_se(u64 now, struct sched_entity *se)

 int __update_load_avg_se(u64 now, struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	if (___update_load_sum(now, &se->avg, !!se->on_rq, se_runnable(se),
-				cfs_rq->curr == se)) {
+	int ret = 0;
+	u64 delta = now - se->avg.last_update_time;
+	u64 gtime_halted = min(delta, se->gtime_halted);

-		___update_load_avg(&se->avg, se_weight(se));
+	ret = ___update_load_sum(now - gtime_halted, &se->avg, !!se->on_rq, se_runnable(se),
+			cfs_rq->curr == se);
+
+	if (gtime_halted) {
+		ret |= ___update_load_sum(now, &se->avg, 0, 0, 0);
+		se->gtime_halted -= gtime_halted;
+
+		/* decay residual halted time */
+		if (ret && se->gtime_halted)
+			se->gtime_halted = decay_load(se->gtime_halted, delta / 1024);
+	}
+
+	if (ret) {
 		cfs_se_util_change(&se->avg);
 		trace_pelt_se_tp(se);
 		return 1;
@@ -319,10 +332,25 @@ int __update_load_avg_se(u64 now, struct cfs_rq *cfs_rq, struct sched_entity *se

 int __update_load_avg_cfs_rq(u64 now, struct cfs_rq *cfs_rq)
 {
-	if (___update_load_sum(now, &cfs_rq->avg,
-				scale_load_down(cfs_rq->load.weight),
-				cfs_rq->h_nr_runnable,
-				cfs_rq->curr != NULL)) {
+	int ret = 0;
+	u64 delta = now - cfs_rq->avg.last_update_time;
+	u64 gtime_halted = min(delta, cfs_rq->gtime_halted);
+
+	ret =  ___update_load_sum(now - gtime_halted, &cfs_rq->avg,
+			scale_load_down(cfs_rq->load.weight),
+			cfs_rq->h_nr_runnable,
+			cfs_rq->curr != NULL);
+
+	if (gtime_halted) {
+		ret |= ___update_load_sum(now, &cfs_rq->avg, 0, 0, 0);
+		cfs_rq->gtime_halted -= gtime_halted;
+
+		/* decay any residual halted time */
+		if (ret && cfs_rq->gtime_halted)
+			cfs_rq->gtime_halted = decay_load(cfs_rq->gtime_halted, delta / 1024);
+	}
+
+	if (ret) {

 		___update_load_avg(&cfs_rq->avg, 1);
 		trace_pelt_cfs_tp(cfs_rq);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b93c8c3dc05a..79b1166265bf 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -744,6 +744,8 @@ struct cfs_rq {
 	struct list_head	throttled_csd_list;
 #endif /* CONFIG_CFS_BANDWIDTH */
 #endif /* CONFIG_FAIR_GROUP_SCHED */
+
+	u64			gtime_halted;
 };

 #ifdef CONFIG_SCHED_CLASS_EXT
--
2.43.0




Amazon Development Centre (South Africa) (Proprietary) Limited
29 Gogosoa Street, Observatory, Cape Town, Western Cape, 7925, South Africa
Registration Number: 2004 / 034463 / 07


