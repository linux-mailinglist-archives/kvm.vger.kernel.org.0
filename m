Return-Path: <kvm+bounces-17113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E47F68C0E09
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 12:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 134E91C21CE0
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 10:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0AF314B943;
	Thu,  9 May 2024 10:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCWOQPbD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA0314B086
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 10:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715249684; cv=none; b=OWcUXY8wvA15RWHJ8qvwtHQ/rwdk62Cj6ROwWpKeoe1zX+Gsptd5X48fwPBobPagi0fjhR4Yq8bYNPToQ/20v7RTgjeAdd1wR6u+BEUSVVubyYm5f2UdR3WCA6oTgtcAkDtC2SOm8AL7YPpwKaYGfQt9e2rCQA0w0APIAbNNIhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715249684; c=relaxed/simple;
	bh=KgdfPRGU/BUygq/vRrZlzXD4Zb3wjlPGMOETvS32BqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=eCRH9jN51qc4seFoNxaThFbItS4elJorDLqlDWDrCQo4x8ScbbKl4D2KfYrQ/Zh4rBn7RWUt4pN8j5umSWi9p6bX5wVVwkTa9sWgE+IXatj0rsaF5L3i73P8Ja0PWGRRhBcKBkZGmlDNNnmRskt0xSTvWKGNwczndfTiHIySHb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dCWOQPbD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715249680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y94ZLI6kJ1Hvts2f4+dyM/gxRfim2F0PWqoiLQCgXSQ=;
	b=dCWOQPbDrB3kg0KcWy/pRTvnQc5Gn2SC1mluIw6swvpIZsNgePcbX+nryd6uzvguHhw8aq
	BRfcSFY31c29Zy/45Tfg8YTVmDIUOAzcjgf02OARIBnnBBQaYBbrqj+d3uwelfvRVsYq4F
	8VW8DaU+zB42U+cqMUMAGyV50kUUha0=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-UBC840yFNnOu57Hb3kvH4A-1; Thu, 09 May 2024 06:14:39 -0400
X-MC-Unique: UBC840yFNnOu57Hb3kvH4A-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6f3efd63657so746216b3a.2
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 03:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715249678; x=1715854478;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y94ZLI6kJ1Hvts2f4+dyM/gxRfim2F0PWqoiLQCgXSQ=;
        b=pK+tVBwlnlvvarnCuK1I6HSml5DscdQg+GeFfeR0Rynx9kCSwrRpZPxELUw6l+ytAu
         nQUdN5k+fw7d6EfnzFaGN0Qyx5yin4sswn3uh4zSRTlJVrD9CbL99VwqSN/V3DynbYXS
         GsEAnf4zON7j/xhzecmn0gW26oZ/q+L2OpUXObFDQonzH7YWNNw/RiCxVN258vWMN2jf
         wnuPqHXLR/7b0SODtd1eZh/Wgt1SHYLDX64cbu2GevHR3RQseoabyc/2ieieJiZz0t7F
         cwoZLa8JpZyblqfPnaClZNBe/Lvt7y0udPh/HRP2HeYDvkmTbMVBgQhBoG5tKaOyFtJz
         s34g==
X-Forwarded-Encrypted: i=1; AJvYcCVEVTaIA67dFVnW911ZXUNhEBEkTgc8VrHeYlkLpKBFqyKjcPezE76IRhWynPKmHo6DD+NL8dBooFvf2G6AOJ7Ba+Qj
X-Gm-Message-State: AOJu0YzptsRfbal5saRC9o30gATnALs5EfAb3/LlXmvExVWeBdDS4xQI
	AzdsN+3ajxu/gKOKzagOI4I4Jc1ZisL+WNN06inJsGVA+9jykBITbkkSN0eqTr9SomJx5ASt2Zw
	4RsP54EUfJCQmehZTy3Qq3NQ4WX16T7e/BYLyf0YZYODUC6uQfA==
X-Received: by 2002:a05:6a00:740c:b0:6f4:5531:7ce4 with SMTP id d2e1a72fcca58-6f49c2a67camr5575818b3a.33.1715249677649;
        Thu, 09 May 2024 03:14:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjwd47saWkIqVMFUB6Yhmt+ToeU0rEJ6fpqUKdFc55ujNJNNla3mfw5zQE96EBqlbIhLs9CA==
X-Received: by 2002:a05:6a00:740c:b0:6f4:5531:7ce4 with SMTP id d2e1a72fcca58-6f49c2a67camr5575785b3a.33.1715249677123;
        Thu, 09 May 2024 03:14:37 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a800:8d87:eac1:dae4:8dd4:fe50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a66616sm968113b3a.22.2024.05.09.03.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 03:14:36 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: Leonardo Bras <leobras@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
Date: Thu,  9 May 2024 07:14:18 -0300
Message-ID: <Zjyh-qRt3YewHsdP@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <ZjyGefTZ8ThZukNG@LeoBras>
References: <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop> <Zjq9okodmvkywz82@google.com> <ZjrClk4Lqw_cLO5A@google.com> <Zjroo8OsYcVJLsYO@LeoBras> <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop> <ZjsZVUdmDXZOn10l@LeoBras> <ZjuFuZHKUy7n6-sG@google.com> <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop> <ZjyGefTZ8ThZukNG@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, May 09, 2024 at 05:16:57AM -0300, Leonardo Bras wrote:
> On Wed, May 08, 2024 at 08:32:40PM -0700, Paul E. McKenney wrote:
> > On Wed, May 08, 2024 at 07:01:29AM -0700, Sean Christopherson wrote:
> > > On Wed, May 08, 2024, Leonardo Bras wrote:
> > > > Something just hit me, and maybe I need to propose something more generic.
> > > 
> > > Yes.  This is what I was trying to get across with my complaints about keying off
> > > of the last VM-Exit time.  It's effectively a broad stroke "this task will likely
> > > be quiescent soon" and so the core concept/functionality belongs in common code,
> > > not KVM.
> > 
> > OK, we could do something like the following wholly within RCU, namely
> > to make rcu_pending() refrain from invoking rcu_core() until the grace
> > period is at least the specified age, defaulting to zero (and to the
> > current behavior).
> > 
> > Perhaps something like the patch shown below.
> 
> That's exactly what I was thinking :)
> 
> > 
> > Thoughts?
> 
> Some suggestions below:
> 
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > commit abc7cd2facdebf85aa075c567321589862f88542
> > Author: Paul E. McKenney <paulmck@kernel.org>
> > Date:   Wed May 8 20:11:58 2024 -0700
> > 
> >     rcu: Add rcutree.nocb_patience_delay to reduce nohz_full OS jitter
> >     
> >     If a CPU is running either a userspace application or a guest OS in
> >     nohz_full mode, it is possible for a system call to occur just as an
> >     RCU grace period is starting.  If that CPU also has the scheduling-clock
> >     tick enabled for any reason (such as a second runnable task), and if the
> >     system was booted with rcutree.use_softirq=0, then RCU can add insult to
> >     injury by awakening that CPU's rcuc kthread, resulting in yet another
> >     task and yet more OS jitter due to switching to that task, running it,
> >     and switching back.
> >     
> >     In addition, in the common case where that system call is not of
> >     excessively long duration, awakening the rcuc task is pointless.
> >     This pointlessness is due to the fact that the CPU will enter an extended
> >     quiescent state upon returning to the userspace application or guest OS.
> >     In this case, the rcuc kthread cannot do anything that the main RCU
> >     grace-period kthread cannot do on its behalf, at least if it is given
> >     a few additional milliseconds (for example, given the time duration
> >     specified by rcutree.jiffies_till_first_fqs, give or take scheduling
> >     delays).
> >     
> >     This commit therefore adds a rcutree.nocb_patience_delay kernel boot
> >     parameter that specifies the grace period age (in milliseconds)
> >     before which RCU will refrain from awakening the rcuc kthread.
> >     Preliminary experiementation suggests a value of 1000, that is,
> >     one second.  Increasing rcutree.nocb_patience_delay will increase
> >     grace-period latency and in turn increase memory footprint, so systems
> >     with constrained memory might choose a smaller value.  Systems with
> >     less-aggressive OS-jitter requirements might choose the default value
> >     of zero, which keeps the traditional immediate-wakeup behavior, thus
> >     avoiding increases in grace-period latency.
> >     
> >     Link: https://lore.kernel.org/all/20240328171949.743211-1-leobras@redhat.com/
> >     
> >     Reported-by: Leonardo Bras <leobras@redhat.com>
> >     Suggested-by: Leonardo Bras <leobras@redhat.com>
> >     Suggested-by: Sean Christopherson <seanjc@google.com>
> >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > 
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 0a3b0fd1910e6..42383986e692b 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -4981,6 +4981,13 @@
> >  			the ->nocb_bypass queue.  The definition of "too
> >  			many" is supplied by this kernel boot parameter.
> >  
> > +	rcutree.nocb_patience_delay= [KNL]
> > +			On callback-offloaded (rcu_nocbs) CPUs, avoid
> > +			disturbing RCU unless the grace period has
> > +			reached the specified age in milliseconds.
> > +			Defaults to zero.  Large values will be capped
> > +			at five seconds.
> > +
> >  	rcutree.qhimark= [KNL]
> >  			Set threshold of queued RCU callbacks beyond which
> >  			batch limiting is disabled.
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index 7560e204198bb..6e4b8b43855a0 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -176,6 +176,8 @@ static int gp_init_delay;
> >  module_param(gp_init_delay, int, 0444);
> >  static int gp_cleanup_delay;
> >  module_param(gp_cleanup_delay, int, 0444);
> > +static int nocb_patience_delay;
> > +module_param(nocb_patience_delay, int, 0444);
> >  
> >  // Add delay to rcu_read_unlock() for strict grace periods.
> >  static int rcu_unlock_delay;
> > @@ -4334,6 +4336,8 @@ EXPORT_SYMBOL_GPL(cond_synchronize_rcu_full);
> >  static int rcu_pending(int user)
> >  {
> >  	bool gp_in_progress;
> > +	unsigned long j = jiffies;
> 
> I think this is probably taken care by the compiler, but just in case I would move the 
> j = jiffies;
> closer to it's use, in order to avoid reading 'jiffies' if rcu_pending 
> exits before the nohz_full testing.
> 
> 
> > +	unsigned int patience = msecs_to_jiffies(nocb_patience_delay);
> 
> What do you think on processsing the new parameter in boot, and saving it 
> in terms of jiffies already? 
> 
> It would make it unnecessary to convert ms -> jiffies every time we run 
> rcu_pending.
> 
> (OOO will probably remove the extra division, but may cause less impact in 
> some arch)
> 
> >  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
> >  	struct rcu_node *rnp = rdp->mynode;
> >  
> > @@ -4347,11 +4351,13 @@ static int rcu_pending(int user)
> >  		return 1;
> >  
> >  	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> > -	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> > +	gp_in_progress = rcu_gp_in_progress();
> > +	if ((user || rcu_is_cpu_rrupt_from_idle() ||
> > +	     (gp_in_progress && time_before(j + patience, rcu_state.gp_start))) &&
> 
> I think you meant:
> 	time_before(j, rcu_state.gp_start + patience)
> 
> or else this always fails, as we can never have now to happen before a 
> previously started gp, right?
> 
> Also, as per rcu_nohz_full_cpu() we probably need it to be read with 
> READ_ONCE():
> 
> 	time_before(j, READ_ONCE(rcu_state.gp_start) + patience)
> 
> > +	    rcu_nohz_full_cpu())
> >  		return 0;
> >  
> >  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> > -	gp_in_progress = rcu_gp_in_progress();
> >  	if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
> >  		return 1;
> >  
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 340bbefe5f652..174333d0e9507 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -93,6 +93,15 @@ static void __init rcu_bootup_announce_oddness(void)
> >  		pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
> >  	if (gp_cleanup_delay)
> >  		pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
> > +	if (nocb_patience_delay < 0) {
> > +		pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n", nocb_patience_delay);
> > +		nocb_patience_delay = 0;
> > +	} else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> > +		pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n", nocb_patience_delay, 5 * MSEC_PER_SEC);
> > +		nocb_patience_delay = 5 * MSEC_PER_SEC;
> > +	} else if (nocb_patience_delay) {
> 
> Here you suggest that we don't print if 'nocb_patience_delay == 0', 
> as it's the default behavior, right?
> 
> I think printing on 0 could be useful to check if the feature exists, even 
> though we are zeroing it, but this will probably add unnecessary verbosity.
> 
> > +		pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n", nocb_patience_delay);
> > +	}
> 
> Here I suppose something like this can take care of not needing to convert 
> ms -> jiffies every rcu_pending():
> 
> +	nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> 

Uh, there is more to it, actually. We need to make sure the user 
understands that we are rounding-down the value to multiple of a jiffy 
period, so it's not a surprise if the delay value is not exactly the same 
as the passed on kernel cmdline.

So something like bellow diff should be ok, as this behavior is explained 
in the docs, and pr_info() will print the effective value.

What do you think?

Thanks!
Leo

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0a3b0fd1910e..9a50be9fd9eb 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4974,20 +4974,28 @@
                        otherwise be caused by callback floods through
                        use of the ->nocb_bypass list.  However, in the
                        common non-flooded case, RCU queues directly to
                        the main ->cblist in order to avoid the extra
                        overhead of the ->nocb_bypass list and its lock.
                        But if there are too many callbacks queued during
                        a single jiffy, RCU pre-queues the callbacks into
                        the ->nocb_bypass queue.  The definition of "too
                        many" is supplied by this kernel boot parameter.
 
+       rcutree.nocb_patience_delay= [KNL]
+                       On callback-offloaded (rcu_nocbs) CPUs, avoid
+                       disturbing RCU unless the grace period has
+                       reached the specified age in milliseconds.
+                       Defaults to zero.  Large values will be capped
+                       at five seconds. Values rounded-down to a multiple
+                       of a jiffy period.
+
        rcutree.qhimark= [KNL]
                        Set threshold of queued RCU callbacks beyond which
                        batch limiting is disabled.
 
        rcutree.qlowmark= [KNL]
                        Set threshold of queued RCU callbacks below which
                        batch limiting is re-enabled.
 
        rcutree.qovld= [KNL]
                        Set threshold of queued RCU callbacks beyond which
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index fcf2b4aa3441..62ede401420f 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -512,20 +512,21 @@ do {                                                              \
        local_irq_save(flags);                                  \
        if (rcu_segcblist_is_offloaded(&(rdp)->cblist)) \
                raw_spin_lock(&(rdp)->nocb_lock);               \
 } while (0)
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 #define rcu_nocb_lock_irqsave(rdp, flags) local_irq_save(flags)
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
 
 static void rcu_bind_gp_kthread(void);
 static bool rcu_nohz_full_cpu(void);
+static bool rcu_on_patience_delay(void);
 
 /* Forward declarations for tree_stall.h */
 static void record_gp_stall_check_time(void);
 static void rcu_iw_handler(struct irq_work *iwp);
 static void check_cpu_stall(struct rcu_data *rdp);
 static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
                                     const unsigned long gpssdelay);
 
 /* Forward declarations for tree_exp.h. */
 static void sync_rcu_do_polled_gp(struct work_struct *wp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 340bbefe5f65..639243b0410f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -5,20 +5,21 @@
  * or preemptible semantics.
  *
  * Copyright Red Hat, 2009
  * Copyright IBM Corporation, 2009
  *
  * Author: Ingo Molnar <mingo@elte.hu>
  *        Paul E. McKenney <paulmck@linux.ibm.com>
  */
 
 #include "../locking/rtmutex_common.h"
+#include <linux/jiffies.h>
 
 static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
 {
        /*
         * In order to read the offloaded state of an rdp in a safe
         * and stable way and prevent from its value to be changed
         * under us, we must either hold the barrier mutex, the cpu
         * hotplug lock (read or write) or the nocb lock. Local
         * non-preemptible reads are also safe. NOCB kthreads and
         * timers have their own means of synchronization against the
@@ -86,20 +87,33 @@ static void __init rcu_bootup_announce_oddness(void)
        if (rcu_kick_kthreads)
                pr_info("\tKick kthreads if too-long grace period.\n");
        if (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD))
                pr_info("\tRCU callback double-/use-after-free debug is enabled.\n");
        if (gp_preinit_delay)
                pr_info("\tRCU debug GP pre-init slowdown %d jiffies.\n", gp_preinit_delay);
        if (gp_init_delay)
                pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
        if (gp_cleanup_delay)
                pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
+       if (nocb_patience_delay < 0) {
+               pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n",
+                       nocb_patience_delay);
+               nocb_patience_delay = 0;
+       } else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
+               pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n",
+                       nocb_patience_delay, 5 * MSEC_PER_SEC);
+               nocb_patience_delay = msecs_to_jiffies(5 * MSEC_PER_SEC);
+       } else if (nocb_patience_delay) {
+               nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
+               pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n",
+                       jiffies_to_msecs(nocb_patience_delay);
+       }
        if (!use_softirq)
                pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
        if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
                pr_info("\tRCU debug extended QS entry/exit.\n");
        rcupdate_announce_bootup_oddness();
 }
 
 #ifdef CONFIG_PREEMPT_RCU
 
 static void rcu_report_exp_rnp(struct rcu_node *rnp, bool wake);
@@ -1260,10 +1274,29 @@ static bool rcu_nohz_full_cpu(void)
 
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
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU if the time since the
+ * start of current grace period is smaller than nocb_patience_delay ?
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * RCU_NOCB_CPU CPUs.
+ */
+static bool rcu_on_patience_delay(void)
+{
+#ifdef CONFIG_NO_HZ_FULL
+       if (!nocb_patience_delay)
+               return false;
+
+       if (time_before(jiffies, READ_ONCE(rcu_state.gp_start) + nocb_patience_delay))
+               return true;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+       return false;
+}
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7560e204198b..7a2d94370ab4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -169,20 +169,22 @@ static int kthread_prio = IS_ENABLED(CONFIG_RCU_BOOST) ? 1 : 0;
 module_param(kthread_prio, int, 0444);
 
 /* Delay in jiffies for grace-period initialization delays, debug only. */
 
 static int gp_preinit_delay;
 module_param(gp_preinit_delay, int, 0444);
 static int gp_init_delay;
 module_param(gp_init_delay, int, 0444);
 static int gp_cleanup_delay;
 module_param(gp_cleanup_delay, int, 0444);
+static int nocb_patience_delay;
+module_param(nocb_patience_delay, int, 0444);
 
 // Add delay to rcu_read_unlock() for strict grace periods.
 static int rcu_unlock_delay;
 #ifdef CONFIG_RCU_STRICT_GRACE_PERIOD
 module_param(rcu_unlock_delay, int, 0444);
 #endif
 
 /*
  * This rcu parameter is runtime-read-only. It reflects
  * a minimum allowed number of objects which can be cached
@@ -4340,25 +4342,27 @@ static int rcu_pending(int user)
        lockdep_assert_irqs_disabled();
 
        /* Check for CPU stalls, if enabled. */
        check_cpu_stall(rdp);
 
        /* Does this CPU need a deferred NOCB wakeup? */
        if (rcu_nocb_need_deferred_wakeup(rdp, RCU_NOCB_WAKE))
                return 1;
 
        /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
-       if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
+       gp_in_progress = rcu_gp_in_progress();
+       if ((user || rcu_is_cpu_rrupt_from_idle() ||
+            (gp_in_progress && rcu_on_patience_delay())) &&
+           rcu_nohz_full_cpu())
                return 0;
 
        /* Is the RCU core waiting for a quiescent state from this CPU? */
-       gp_in_progress = rcu_gp_in_progress();
        if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
                return 1;
 
        /* Does this CPU have callbacks ready to invoke? */
        if (!rcu_rdp_is_offloaded(rdp) &&
            rcu_segcblist_ready_cbs(&rdp->cblist))
                return 1;
 
        /* Has RCU gone idle with this CPU needing another grace period? */
        if (!gp_in_progress && rcu_segcblist_is_enabled(&rdp->cblist) &&




