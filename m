Return-Path: <kvm+bounces-17084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 751AE8C0A29
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 05:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAE1EB224D5
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 03:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BC6147C9B;
	Thu,  9 May 2024 03:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yu5mE6mz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E51D13C3D3;
	Thu,  9 May 2024 03:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715225561; cv=none; b=Si46kXoEE5sBih7GdEEZGJugh4GtRSvQ6ipg8O3D0PGZPCIUh4jFOsOvgQbv9AoTYi1Bjx7PMgyEvudrMqVRMaifTBxM5977/MmCWMB5ONvkeiAuORiowUU6znVhz0G7VQFQxARXCkx4eBYCj9COS8bZk1/zSQ4XKl/bgM6b5b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715225561; c=relaxed/simple;
	bh=cU5rhukE0f4MXjKW6iNyEqKDgbf6wx3cyccwEox0vek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bg/TgtDlS8dWqOl+3QxfCKp7+37gJPSRdOxhAlqycgh/BBnwqmL6bCleA4v61fCztu2RNi9nsXIDzr9d8tPuJ0nduWaFJcXdQ0BJY3aqXrX79W8tzVpWTxGog9y2rTXARg/SLQpY9ZGRnJzLfF9YPd8s1lqXivgRZKxDy5fmcnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yu5mE6mz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA494C2BBFC;
	Thu,  9 May 2024 03:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715225560;
	bh=cU5rhukE0f4MXjKW6iNyEqKDgbf6wx3cyccwEox0vek=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=Yu5mE6mzvb4Q2w+6ai4dNJnbyMxoUDKXkCNq3h6CtQk57d+Me8ZV5WM1yyiUl+4OP
	 ARGeQWswZXUcfMMwoI6ZSFjcv3r/GH9e9yUtUrtLFnWs2Ybg2lvl2Ly2yvPJfZdoqA
	 xfRWYB3wQkxxuMhvgPyOXp8N3OTcFEt2UuWezJePNt7GsiScp/FDSx5xeu7OEuYY8E
	 LaBIYWWrmwRuJfOIfgfEkgLdLEGjuiWcixs4Ithi83hWX/ntGSP8yG8uZzdqUlghm2
	 rKiRNbLQHJnLFjmsHobazI/X15mH+kOu79os5nZ4AnIGFJsgSDlIOVpEtLUPq59lkJ
	 MCANTqJ7CZlYw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 4B2FCCE29D2; Wed,  8 May 2024 20:32:40 -0700 (PDT)
Date: Wed, 8 May 2024 20:32:40 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Leonardo Bras <leobras@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Message-ID: <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <ZjprKm5jG3JYsgGB@google.com>
 <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop>
 <ZjqWXPFuoYWWcxP3@google.com>
 <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com>
 <ZjrClk4Lqw_cLO5A@google.com>
 <Zjroo8OsYcVJLsYO@LeoBras>
 <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
 <ZjsZVUdmDXZOn10l@LeoBras>
 <ZjuFuZHKUy7n6-sG@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjuFuZHKUy7n6-sG@google.com>

On Wed, May 08, 2024 at 07:01:29AM -0700, Sean Christopherson wrote:
> On Wed, May 08, 2024, Leonardo Bras wrote:
> > Something just hit me, and maybe I need to propose something more generic.
> 
> Yes.  This is what I was trying to get across with my complaints about keying off
> of the last VM-Exit time.  It's effectively a broad stroke "this task will likely
> be quiescent soon" and so the core concept/functionality belongs in common code,
> not KVM.

OK, we could do something like the following wholly within RCU, namely
to make rcu_pending() refrain from invoking rcu_core() until the grace
period is at least the specified age, defaulting to zero (and to the
current behavior).

Perhaps something like the patch shown below.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

commit abc7cd2facdebf85aa075c567321589862f88542
Author: Paul E. McKenney <paulmck@kernel.org>
Date:   Wed May 8 20:11:58 2024 -0700

    rcu: Add rcutree.nocb_patience_delay to reduce nohz_full OS jitter
    
    If a CPU is running either a userspace application or a guest OS in
    nohz_full mode, it is possible for a system call to occur just as an
    RCU grace period is starting.  If that CPU also has the scheduling-clock
    tick enabled for any reason (such as a second runnable task), and if the
    system was booted with rcutree.use_softirq=0, then RCU can add insult to
    injury by awakening that CPU's rcuc kthread, resulting in yet another
    task and yet more OS jitter due to switching to that task, running it,
    and switching back.
    
    In addition, in the common case where that system call is not of
    excessively long duration, awakening the rcuc task is pointless.
    This pointlessness is due to the fact that the CPU will enter an extended
    quiescent state upon returning to the userspace application or guest OS.
    In this case, the rcuc kthread cannot do anything that the main RCU
    grace-period kthread cannot do on its behalf, at least if it is given
    a few additional milliseconds (for example, given the time duration
    specified by rcutree.jiffies_till_first_fqs, give or take scheduling
    delays).
    
    This commit therefore adds a rcutree.nocb_patience_delay kernel boot
    parameter that specifies the grace period age (in milliseconds)
    before which RCU will refrain from awakening the rcuc kthread.
    Preliminary experiementation suggests a value of 1000, that is,
    one second.  Increasing rcutree.nocb_patience_delay will increase
    grace-period latency and in turn increase memory footprint, so systems
    with constrained memory might choose a smaller value.  Systems with
    less-aggressive OS-jitter requirements might choose the default value
    of zero, which keeps the traditional immediate-wakeup behavior, thus
    avoiding increases in grace-period latency.
    
    Link: https://lore.kernel.org/all/20240328171949.743211-1-leobras@redhat.com/
    
    Reported-by: Leonardo Bras <leobras@redhat.com>
    Suggested-by: Leonardo Bras <leobras@redhat.com>
    Suggested-by: Sean Christopherson <seanjc@google.com>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0a3b0fd1910e6..42383986e692b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4981,6 +4981,13 @@
 			the ->nocb_bypass queue.  The definition of "too
 			many" is supplied by this kernel boot parameter.
 
+	rcutree.nocb_patience_delay= [KNL]
+			On callback-offloaded (rcu_nocbs) CPUs, avoid
+			disturbing RCU unless the grace period has
+			reached the specified age in milliseconds.
+			Defaults to zero.  Large values will be capped
+			at five seconds.
+
 	rcutree.qhimark= [KNL]
 			Set threshold of queued RCU callbacks beyond which
 			batch limiting is disabled.
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7560e204198bb..6e4b8b43855a0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -176,6 +176,8 @@ static int gp_init_delay;
 module_param(gp_init_delay, int, 0444);
 static int gp_cleanup_delay;
 module_param(gp_cleanup_delay, int, 0444);
+static int nocb_patience_delay;
+module_param(nocb_patience_delay, int, 0444);
 
 // Add delay to rcu_read_unlock() for strict grace periods.
 static int rcu_unlock_delay;
@@ -4334,6 +4336,8 @@ EXPORT_SYMBOL_GPL(cond_synchronize_rcu_full);
 static int rcu_pending(int user)
 {
 	bool gp_in_progress;
+	unsigned long j = jiffies;
+	unsigned int patience = msecs_to_jiffies(nocb_patience_delay);
 	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
 	struct rcu_node *rnp = rdp->mynode;
 
@@ -4347,11 +4351,13 @@ static int rcu_pending(int user)
 		return 1;
 
 	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
-	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
+	gp_in_progress = rcu_gp_in_progress();
+	if ((user || rcu_is_cpu_rrupt_from_idle() ||
+	     (gp_in_progress && time_before(j + patience, rcu_state.gp_start))) &&
+	    rcu_nohz_full_cpu())
 		return 0;
 
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
-	gp_in_progress = rcu_gp_in_progress();
 	if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
 		return 1;
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 340bbefe5f652..174333d0e9507 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -93,6 +93,15 @@ static void __init rcu_bootup_announce_oddness(void)
 		pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
 	if (gp_cleanup_delay)
 		pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
+	if (nocb_patience_delay < 0) {
+		pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n", nocb_patience_delay);
+		nocb_patience_delay = 0;
+	} else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
+		pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n", nocb_patience_delay, 5 * MSEC_PER_SEC);
+		nocb_patience_delay = 5 * MSEC_PER_SEC;
+	} else if (nocb_patience_delay) {
+		pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n", nocb_patience_delay);
+	}
 	if (!use_softirq)
 		pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
 	if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))

