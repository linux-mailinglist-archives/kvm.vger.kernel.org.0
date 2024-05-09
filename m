Return-Path: <kvm+bounces-17103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D76C8C0C5D
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 10:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03F152823EC
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 08:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1874149DEA;
	Thu,  9 May 2024 08:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JsTVAzeN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B701013D292
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 08:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715242633; cv=none; b=HjL4/5QngyYYNRM11eHnQL/ulofpztYS6K3JsjR8pE7jMyS6AfLuw/QyCBZTjfbRXKUr4iqAwxzNUrJFvRifY1kBLQlRgNOFFoDRwMFUYKuISo0Iyk2kipMwihGtltg7jfTsaBibt8HZh9od3++l0w6x+d/eUqZ2/pVDTcwbu+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715242633; c=relaxed/simple;
	bh=z+Jz0XJNCIYfLXyzhPT9j7ItAc6fH11c9EUoLCJDGsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=RHnfFmTnv7SAgo2pFSNkJkJcHpTAJsXvMkEeWQ62qw/C9iGOmpi8Yr0hTIULpvFGz2OzHICqFeqTNrK01oLZkWOoKtr0NIIcpZeTck9I1vdHm7qaKpqv2FfSJrA0xKfzxQVOIPePOQmqnzfJrhZWYnK5haCB/IcRmWxR9fV2jWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JsTVAzeN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715242630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mOTfAiwr8LPoxMSWtWdohs6mTjoqQRYS+50SI4ZMF78=;
	b=JsTVAzeN5XM+P1w3a79CMfBqcJJkViDvSaY5oUtZbwqzVotCp4NzYE6Cq2oIWmMrb36FIp
	w7Hl2cGb0YdOLaQYeEJ2M0gN87mOd1rFBzQ/EBanc3X5Y3rJjv5vgn2+jYeKM/0fEyVKLj
	lKTPI/AjOjUaVqiJgLY6YMuT4L9NWdo=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-671-kOa79mG9O8iqAhzfBT-jFw-1; Thu, 09 May 2024 04:17:09 -0400
X-MC-Unique: kOa79mG9O8iqAhzfBT-jFw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2b33fb417f3so594767a91.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 01:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715242628; x=1715847428;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOTfAiwr8LPoxMSWtWdohs6mTjoqQRYS+50SI4ZMF78=;
        b=Mi89OUWfFD2cFoNUQc2KuNYSw3At298onrC2EONa16Ml21gg9A8nxHcBP+qShuLZlz
         dEsum4FF0N5umQOhNGfizXKiWSpuA41E3IQFC7GjI6aPuFLrvGa/0j0IwLfh8rsgMsGx
         tF45PO59V8MaSXnbXIq5IVFaYdAmK6HNiMWUiBjd4nvfHEDhINJF/vJ8ppT2WLg/Wuft
         bn9lgiqVBZFDzrsVfJn1J6gBgk3P2/n8A1iwAsrFOpFZ+RAKMeKHLCPGhL7s9DRg6jjG
         bMTfjXu0IfLsBxxYeKYYE2drQ3iBlVALbAD9LHlg1LAOtruWWUPLgPOgG2Rf+ofZAKNA
         gabg==
X-Forwarded-Encrypted: i=1; AJvYcCU/0pPDp8oMj6p2k6u6GMrDm+bPAUbbnRhw5l4LGvDvelDL3LIe8XYV3EblxZOIvvtiokU/KF9fxvXi3eNErNqMlkri
X-Gm-Message-State: AOJu0YxIoS+usMfRFgEEEOlGJzQfFjuOV7BzclbUUw1ywBiAs9z9ppwI
	UMCrwZNBsxyaEpU4HspLux44DhBi1S94u3u+Hur9ZxbrTHwjdU6En0LC0m/dTMHYe5k4rWrmX1h
	H5t7b2aVIguYxdZz1NNeWmOZD7+xLzENqIZ6ykZ4Nho1pQ2sTQA==
X-Received: by 2002:a17:90b:1207:b0:2b1:1c1e:f489 with SMTP id 98e67ed59e1d1-2b6163a22b4mr4576627a91.4.1715242628331;
        Thu, 09 May 2024 01:17:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1A96obndE18f37GMHCs8NrHkLBSwaU944om0lk68JAKckCEop7wqS+RM99maUMjHe2qfTqg==
X-Received: by 2002:a17:90b:1207:b0:2b1:1c1e:f489 with SMTP id 98e67ed59e1d1-2b6163a22b4mr4576608a91.4.1715242627852;
        Thu, 09 May 2024 01:17:07 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:8d87:eac1:dae4:8dd4:fe50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b628ea6ae7sm2721939a91.51.2024.05.09.01.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 01:17:07 -0700 (PDT)
From: Leonardo Bras <leobras@redhat.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Leonardo Bras <leobras@redhat.com>,
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
Date: Thu,  9 May 2024 05:16:57 -0300
Message-ID: <ZjyGefTZ8ThZukNG@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
References: <663a659d-3a6f-4bec-a84b-4dd5fd16c3c1@paulmck-laptop> <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop> <Zjq9okodmvkywz82@google.com> <ZjrClk4Lqw_cLO5A@google.com> <Zjroo8OsYcVJLsYO@LeoBras> <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop> <ZjsZVUdmDXZOn10l@LeoBras> <ZjuFuZHKUy7n6-sG@google.com> <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, May 08, 2024 at 08:32:40PM -0700, Paul E. McKenney wrote:
> On Wed, May 08, 2024 at 07:01:29AM -0700, Sean Christopherson wrote:
> > On Wed, May 08, 2024, Leonardo Bras wrote:
> > > Something just hit me, and maybe I need to propose something more generic.
> > 
> > Yes.  This is what I was trying to get across with my complaints about keying off
> > of the last VM-Exit time.  It's effectively a broad stroke "this task will likely
> > be quiescent soon" and so the core concept/functionality belongs in common code,
> > not KVM.
> 
> OK, we could do something like the following wholly within RCU, namely
> to make rcu_pending() refrain from invoking rcu_core() until the grace
> period is at least the specified age, defaulting to zero (and to the
> current behavior).
> 
> Perhaps something like the patch shown below.

That's exactly what I was thinking :)

> 
> Thoughts?

Some suggestions below:

> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> commit abc7cd2facdebf85aa075c567321589862f88542
> Author: Paul E. McKenney <paulmck@kernel.org>
> Date:   Wed May 8 20:11:58 2024 -0700
> 
>     rcu: Add rcutree.nocb_patience_delay to reduce nohz_full OS jitter
>     
>     If a CPU is running either a userspace application or a guest OS in
>     nohz_full mode, it is possible for a system call to occur just as an
>     RCU grace period is starting.  If that CPU also has the scheduling-clock
>     tick enabled for any reason (such as a second runnable task), and if the
>     system was booted with rcutree.use_softirq=0, then RCU can add insult to
>     injury by awakening that CPU's rcuc kthread, resulting in yet another
>     task and yet more OS jitter due to switching to that task, running it,
>     and switching back.
>     
>     In addition, in the common case where that system call is not of
>     excessively long duration, awakening the rcuc task is pointless.
>     This pointlessness is due to the fact that the CPU will enter an extended
>     quiescent state upon returning to the userspace application or guest OS.
>     In this case, the rcuc kthread cannot do anything that the main RCU
>     grace-period kthread cannot do on its behalf, at least if it is given
>     a few additional milliseconds (for example, given the time duration
>     specified by rcutree.jiffies_till_first_fqs, give or take scheduling
>     delays).
>     
>     This commit therefore adds a rcutree.nocb_patience_delay kernel boot
>     parameter that specifies the grace period age (in milliseconds)
>     before which RCU will refrain from awakening the rcuc kthread.
>     Preliminary experiementation suggests a value of 1000, that is,
>     one second.  Increasing rcutree.nocb_patience_delay will increase
>     grace-period latency and in turn increase memory footprint, so systems
>     with constrained memory might choose a smaller value.  Systems with
>     less-aggressive OS-jitter requirements might choose the default value
>     of zero, which keeps the traditional immediate-wakeup behavior, thus
>     avoiding increases in grace-period latency.
>     
>     Link: https://lore.kernel.org/all/20240328171949.743211-1-leobras@redhat.com/
>     
>     Reported-by: Leonardo Bras <leobras@redhat.com>
>     Suggested-by: Leonardo Bras <leobras@redhat.com>
>     Suggested-by: Sean Christopherson <seanjc@google.com>
>     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 0a3b0fd1910e6..42383986e692b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4981,6 +4981,13 @@
>  			the ->nocb_bypass queue.  The definition of "too
>  			many" is supplied by this kernel boot parameter.
>  
> +	rcutree.nocb_patience_delay= [KNL]
> +			On callback-offloaded (rcu_nocbs) CPUs, avoid
> +			disturbing RCU unless the grace period has
> +			reached the specified age in milliseconds.
> +			Defaults to zero.  Large values will be capped
> +			at five seconds.
> +
>  	rcutree.qhimark= [KNL]
>  			Set threshold of queued RCU callbacks beyond which
>  			batch limiting is disabled.
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 7560e204198bb..6e4b8b43855a0 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -176,6 +176,8 @@ static int gp_init_delay;
>  module_param(gp_init_delay, int, 0444);
>  static int gp_cleanup_delay;
>  module_param(gp_cleanup_delay, int, 0444);
> +static int nocb_patience_delay;
> +module_param(nocb_patience_delay, int, 0444);
>  
>  // Add delay to rcu_read_unlock() for strict grace periods.
>  static int rcu_unlock_delay;
> @@ -4334,6 +4336,8 @@ EXPORT_SYMBOL_GPL(cond_synchronize_rcu_full);
>  static int rcu_pending(int user)
>  {
>  	bool gp_in_progress;
> +	unsigned long j = jiffies;

I think this is probably taken care by the compiler, but just in case I would move the 
j = jiffies;
closer to it's use, in order to avoid reading 'jiffies' if rcu_pending 
exits before the nohz_full testing.


> +	unsigned int patience = msecs_to_jiffies(nocb_patience_delay);

What do you think on processsing the new parameter in boot, and saving it 
in terms of jiffies already? 

It would make it unnecessary to convert ms -> jiffies every time we run 
rcu_pending.

(OOO will probably remove the extra division, but may cause less impact in 
some arch)

>  	struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
>  	struct rcu_node *rnp = rdp->mynode;
>  
> @@ -4347,11 +4351,13 @@ static int rcu_pending(int user)
>  		return 1;
>  
>  	/* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if so.) */
> -	if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu())
> +	gp_in_progress = rcu_gp_in_progress();
> +	if ((user || rcu_is_cpu_rrupt_from_idle() ||
> +	     (gp_in_progress && time_before(j + patience, rcu_state.gp_start))) &&

I think you meant:
	time_before(j, rcu_state.gp_start + patience)

or else this always fails, as we can never have now to happen before a 
previously started gp, right?

Also, as per rcu_nohz_full_cpu() we probably need it to be read with 
READ_ONCE():

	time_before(j, READ_ONCE(rcu_state.gp_start) + patience)

> +	    rcu_nohz_full_cpu())
>  		return 0;
>  
>  	/* Is the RCU core waiting for a quiescent state from this CPU? */
> -	gp_in_progress = rcu_gp_in_progress();
>  	if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progress)
>  		return 1;
>  
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 340bbefe5f652..174333d0e9507 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -93,6 +93,15 @@ static void __init rcu_bootup_announce_oddness(void)
>  		pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
>  	if (gp_cleanup_delay)
>  		pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
> +	if (nocb_patience_delay < 0) {
> +		pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n", nocb_patience_delay);
> +		nocb_patience_delay = 0;
> +	} else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> +		pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n", nocb_patience_delay, 5 * MSEC_PER_SEC);
> +		nocb_patience_delay = 5 * MSEC_PER_SEC;
> +	} else if (nocb_patience_delay) {

Here you suggest that we don't print if 'nocb_patience_delay == 0', 
as it's the default behavior, right?

I think printing on 0 could be useful to check if the feature exists, even 
though we are zeroing it, but this will probably add unnecessary verbosity.

> +		pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n", nocb_patience_delay);
> +	}

Here I suppose something like this can take care of not needing to convert 
ms -> jiffies every rcu_pending():

+	nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);

>  	if (!use_softirq)
>  		pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
>  	if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
> 


Thanks!
Leo


