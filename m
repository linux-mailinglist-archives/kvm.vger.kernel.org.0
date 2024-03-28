Return-Path: <kvm+bounces-13031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2950B89070A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 18:20:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 950C51F29613
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 17:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6413D12FB35;
	Thu, 28 Mar 2024 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iW/39pDo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0484512EBF3
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711646411; cv=none; b=GuKpvSOkACKbgcXqP61iHTdXhbFy41b9cP4v/dZTp75F1wQU5+znabz2e1NpZrvNGV4y/DcUPXTPDtsNxSnfxY3QmEaipjtl2UlYazi3o7VmwHZOUb8+fLW5AmjrGIDu+826aO/NZVZfp7iUbgKUKybYOvGlGHm/VyhmbINjWM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711646411; c=relaxed/simple;
	bh=9y2U5zj1XSiEZQqP81LBCuKEobrFxtST9vwkP9GvsHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfeQv7csLdFjGlXw7fd6CSZC49hxps1nf7jG3BEPIA9yi2tXq3wl1R8RTZr7SUe5ojoygqtm1/hAcWgYC5NH1hvvTVZkURamyni2bOHvtVPpD44baWWkCX4/pkdfAaUf+GShmuhqIGLMV8Yg1Bz85j2+w+ABdqnsMMaAe3TWlF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iW/39pDo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711646409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pOGUZjzjTM5VUWa9Ov+ku8ROX6G2+xVfPm/xO/kgd3w=;
	b=iW/39pDoI8497qY2VcIMIOvSyNge0Yu6AQLaksdnsrGyPGf7G8Y1qcaR+ff6BpNHmqFh0V
	SzV1uJByhxScDX44bWzlv6lclEAn12PR0YATZiXo6oSqrNk+jtRIX2LK0TRMwbFMrtXQQw
	E+kQ6IpnIkBBZdaOrTJGExafhd3EfVg=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-pxKe6mopN92iU6MKvaH-1w-1; Thu, 28 Mar 2024 13:20:07 -0400
X-MC-Unique: pxKe6mopN92iU6MKvaH-1w-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c3cd9d1741so790788b6e.0
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 10:20:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711646407; x=1712251207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pOGUZjzjTM5VUWa9Ov+ku8ROX6G2+xVfPm/xO/kgd3w=;
        b=Y56qmHnZpLdL4CMCv2zBuPgoMfRX5z8clfiMYOncblUyVEShe1mI97Orbcg3o858Lp
         i8ToqxgFW1tS4XyAXwa0C0B8dkXeOzO0L65edoN4hiwybN1TAUDvdHNbs6aQ0aH7Ze7c
         VuD7hBmxpCanZu2DsJjPtqdhOIUJX5gXDQKFcZMNBy2iStOtBb2shJyZGP6BraYv49Aj
         yiRrdDjoAkMYfC1nKHyoBU6z5SAxf3x6sUCmSVnhOWZgNmik6bYL9AmdbH//pHs9Heux
         q+a+xvWi1f1SRbgok605WKbNzWsoSD7UcE/7/LZZFe3Vhpoh2AQudEbkPPkQHLNyJhyv
         AQwA==
X-Forwarded-Encrypted: i=1; AJvYcCU0pMaT/9ouQc+BxQgnjNJH9aFfvMtMBf9SImnjt5bEay062ilK8GYs9R8c7xvUvKaF85Cq0H7VGKRjgJg0wkf9V6Am
X-Gm-Message-State: AOJu0YwAydXXZA+9tJAlkWGf6HWBEI+TTOk+UC98cQnseHnUxKsOgjmz
	jpC3ILZjMwSFuWS/RxWeNCF9tzRNjEltxwYhr/tQgw84AyaLYLHab9T6e1fTWW/JDpmNR2Xv1tv
	iFr2SAlv87YfONj/DENNFxT9AhansB5Di9eVm1LPuHV1Z9OZAfQ==
X-Received: by 2002:a05:6808:1242:b0:3c3:dfec:d9ee with SMTP id o2-20020a056808124200b003c3dfecd9eemr3965567oiv.32.1711646406952;
        Thu, 28 Mar 2024 10:20:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHu853ijuqNBx1nyDj4vEt9gDt5cv976tFHHSJ9WoGLzNibEXGLlQqgvCaSZT7OfU274ydjLg==
X-Received: by 2002:a05:6808:1242:b0:3c3:dfec:d9ee with SMTP id o2-20020a056808124200b003c3dfecd9eemr3965545oiv.32.1711646406669;
        Thu, 28 Mar 2024 10:20:06 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a801:d7ed:4b57:3fcd:d5e6:a613])
        by smtp.gmail.com with ESMTPSA id m13-20020ad45dcd000000b00696944e3ce6sm809078qvh.74.2024.03.28.10.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 10:20:06 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: [RFC PATCH v1 2/2] rcu: Ignore RCU in nohz_full cpus if it was running a guest recently
Date: Thu, 28 Mar 2024 14:19:47 -0300
Message-ID: <20240328171949.743211-3-leobras@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328171949.743211-1-leobras@redhat.com>
References: <20240328171949.743211-1-leobras@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In current code, we can ignore the RCU request on a nohz_full cpu for up to
a second if it has interrupted idle or userspace tasks, since those are
quiescent states, and will probably return to it soon thus not requiring
to run a softirq or a rcuc thread.

Running a guest is also considered to be a quiescent state, and will
follow the same logic, so it makes sense to also ignore the RCU request in
this case.

This solves a latency issue of a latency-sensitive workload running on a
guest pinned in nohz_full cpu: if the guest goes out for any reason, and a
synchronize_rcu() is requested between guest exit and a timer interrupt,
then invoke_rcu_core() is called, and introduce latency due to either a
softirq, or a reschedule to run rcuc, if the host is a PREEMPT_RT kernel.

Suggested-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Leonardo Bras <leobras@redhat.com>
---
 kernel/rcu/tree_plugin.h | 14 ++++++++++++++
 kernel/rcu/tree.c        |  4 +++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 36a8b5dbf5b5..16f3cf2e15df 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -5,20 +5,21 @@
  * or preemptible semantics.
  *
  * Copyright Red Hat, 2009
  * Copyright IBM Corporation, 2009
  *
  * Author: Ingo Molnar <mingo@elte.hu>
  *	   Paul E. McKenney <paulmck@linux.ibm.com>
  */
 
 #include "../locking/rtmutex_common.h"
+#include "linux/kvm_host.h"
 
 static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
 {
 	/*
 	 * In order to read the offloaded state of an rdp in a safe
 	 * and stable way and prevent from its value to be changed
 	 * under us, we must either hold the barrier mutex, the cpu
 	 * hotplug lock (read or write) or the nocb lock. Local
 	 * non-preemptible reads are also safe. NOCB kthreads and
 	 * timers have their own means of synchronization against the
@@ -1260,10 +1261,23 @@ static bool rcu_nohz_full_cpu(void)
 
 /*
  * Bind the RCU grace-period kthreads to the housekeeping CPU.
  */
 static void rcu_bind_gp_kthread(void)
 {
 	if (!tick_nohz_full_enabled())
 		return;
 	housekeeping_affine(current, HK_TYPE_RCU);
 }
+
+/*
+ * true if for this cpu guest exit is at most over a second ago,
+ * false otherwise
+ */
+static bool rcu_recent_guest_exit(void)
+{
+#ifdef CONFIG_KVM
+	return time_before(jiffies, guest_exit_last_time() + HZ);
+#else
+	return false;
+#endif
+}
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d9642dd06c25..e5ce00bf1898 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -148,20 +148,21 @@ static void rcu_report_qs_rnp(unsigned long mask, struct rcu_node *rnp,
 static struct task_struct *rcu_boost_task(struct rcu_node *rnp);
 static void invoke_rcu_core(void);
 static void rcu_report_exp_rdp(struct rcu_data *rdp);
 static void sync_sched_exp_online_cleanup(int cpu);
 static void check_cb_ovld_locked(struct rcu_data *rdp, struct rcu_node *rnp);
 static bool rcu_rdp_is_offloaded(struct rcu_data *rdp);
 static bool rcu_rdp_cpu_online(struct rcu_data *rdp);
 static bool rcu_init_invoked(void);
 static void rcu_cleanup_dead_rnp(struct rcu_node *rnp_leaf);
 static void rcu_init_new_rnp(struct rcu_node *rnp_leaf);
+static bool rcu_recent_guest_exit(void);
 
 /*
  * rcuc/rcub/rcuop kthread realtime priority. The "rcuop"
  * real-time priority(enabling/disabling) is controlled by
  * the extra CONFIG_RCU_NOCB_CPU_CB_BOOST configuration.
  */
 static int kthread_prio = IS_ENABLED(CONFIG_RCU_BOOST) ? 1 : 0;
 module_param(kthread_prio, int, 0444);
 
 /* Delay in jiffies for grace-period initialization delays, debug only. */
@@ -3931,21 +3932,22 @@ static int rcu_pending(int user)
 	lockdep_assert_irqs_disabled();
 
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rdp);
 
 	/* Does this CPU need a deferred NOCB wakeup? */
 	if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
 		return 1;
 
 	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
-	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
+	if ((user || rcu_is_cpu_rrupt_from_idle() || rcu_recent_guest_exit()) &&
+	    rcu_nohz_full_cpu())
 		return 0;
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	gp_in_progress = rcu_gp_in_progress();
 	if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
 		return 1;
 
 	/* Does this CPU have callbacks ready to invoke? */
 	if (!rcu_rdp_is_offloaded(rdp) &&
 	    rcu_segcblist_ready_cbs(&rdp->cblist))
-- 
2.44.0


