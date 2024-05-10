Return-Path: <kvm+bounces-17218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 902CE8C2BAF
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:19:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B35401C20D65
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9252213B590;
	Fri, 10 May 2024 21:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eM3WU0hW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBA913B591
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715375944; cv=none; b=XkY0e44VBsvTAduOVr4A0UrMhMDiHhfaXJ7qTAJkppkTozP2/b+0+LygnscUgCNh0fH7pB8+EwL8G+TDdOzw2K4lU2a9IqurzsIbIcrSaVsA7vOjf4/nDtV/aiQ+R1KC+2cpCWw6zGfHeRCw7Rdnna0Zv7W1mwxIJbmrDFQBmyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715375944; c=relaxed/simple;
	bh=Qj1QNhzNCSyxG+yBmaCaGRNrCXMg2pUwMRVhPqpsyGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=E6hvTs/rJMLdNlR4PesL9RxfIbaKHiYJ6XyBhKz2nHGFH0qw5iZeKcjUqHpVMaX64xjwdaUIOK0S0aABQBBXmnvq11VYMOA7d5UrHhRqsGVtR42AtPB/qc9OofTd0YIbrCy8pTbDtgkOt6tripyIi/35gwbdQmoFYskpGJdCe6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eM3WU0hW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715375941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dXb/uGzf6QDtqkkTKaqYM6XALHf41ZfOokP/ZOcck6U=;
	b=eM3WU0hW8U8LskZGerxAziaNINEsKTQFrRQhtYZkVBsPhJM2owAd/S8rBKwILEPunWrcC9
	c+4HMdVvr+wW7dyh/NTMzZaikl7/ePTMPksIgaMuiQsxh5rAlTQtLcnT35IX8BIlyt+vfl
	pl/GJXZAna/YfilKkAfCIwlDVe5sCKk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-rjP82aEJOYa9HGTMGTDlgA-1; Fri, 10 May 2024 17:15:23 -0400
X-MC-Unique: rjP82aEJOYa9HGTMGTDlgA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ee0caec57fso22900425ad.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 14:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715375723; x=1715980523;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dXb/uGzf6QDtqkkTKaqYM6XALHf41ZfOokP/ZOcck6U=;
        b=qEF2jwbr9XR2f7oCazXdyXBC9dn0PmzziJP9s5fHPAHEfpsgZ0zaJ6Og5Bbskshxg8
         CK+EddI16eemtB09CmEw4b97uyVTluxLGhYIIHovvLvg6ETAt211pQUbL2V5EEe/OHu1
         MZBHzDohxLoqKIN/egMzFgjAHsWlGu6e4zjPsiosJ8jGQY+yN6WuYO5Lk34VOX6JoX7v
         aFEast+FBlZmuDOHLYPGYoZn7/W374Rv8+Vs+7uB6WKbjDeVf7Z9+zuJvru7qpPixEtO
         g+2G6w6uQafVFEBBLi9QULTnLcjZyK98pA7pATvulh96nJV4+0l28Rm4Ucdwah706n3M
         c2vw==
X-Forwarded-Encrypted: i=1; AJvYcCWqLiG9Wg/fHjn2QqJoxiXOiI0/jXEpwcc9mOv0HTU7KTnvNSU+xhXwRZCqf2mfRsk0Dkc5svttLbAUQUUU4jrkcNav
X-Gm-Message-State: AOJu0Yy2vbE9/VVda13cUTVfqUxVf3wRZj6c0KAcwVFksfsym2gxD2A1
	c0fLDZ6Pd4uBcTjVI4MjOnv+1EJZTwXs3qdhFBgNkQqYsF7+Tpq9wOyoJafaLM4l4RIN0ZqYqj2
	2DZDUanw4EvSinGvedcEP7PPuofg3QUw7zDmSMgsfvRraPfkmOw==
X-Received: by 2002:a17:903:184:b0:1e4:24bc:426e with SMTP id d9443c01a7336-1ef43d2eac1mr48828365ad.28.1715375722584;
        Fri, 10 May 2024 14:15:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiqnKQu87FnOIqSQCrlqW5ilQ1Y76PmrvIX4ZXfyQ1snIwqq8+i3Is9avMiZ366RbkxisbtA==
X-Received: by 2002:a17:903:184:b0:1e4:24bc:426e with SMTP id d9443c01a7336-1ef43d2eac1mr48828025ad.28.1715375722013;
        Fri, 10 May 2024 14:15:22 -0700 (PDT)
Received: from LeoBras.redhat.com ([2804:1b3:a800:8d87:eac1:dae4:8dd4:fe50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0bad61c7sm36934655ad.68.2024.05.10.14.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 May 2024 14:15:20 -0700 (PDT)
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
Date: Fri, 10 May 2024 18:15:14 -0300
Message-ID: <Zj6OYvivXF7tUIqV@LeoBras>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <Zj56kVxuTJm4EsAn@LeoBras>
References: <ZjuFuZHKUy7n6-sG@google.com> <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop> <ZjyGefTZ8ThZukNG@LeoBras> <Zjyh-qRt3YewHsdP@LeoBras> <09a8f4f6-a692-4586-bb68-b0a524b7a5d8@paulmck-laptop> <Zj5GEK8bt3061TiD@LeoBras> <a5784417-d65d-45c2-a66f-310a494b9827@paulmck-laptop> <Zj5VgM_RzaDWQs1t@LeoBras> <d5021b48-09d6-4a54-9874-740051aab574@paulmck-laptop> <Zj56kVxuTJm4EsAn@LeoBras>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, May 10, 2024 at 04:50:41PM -0300, Leonardo Bras wrote:
> On Fri, May 10, 2024 at 10:41:53AM -0700, Paul E. McKenney wrote:
> > On Fri, May 10, 2024 at 02:12:32PM -0300, Leonardo Bras wrote:
> > > On Fri, May 10, 2024 at 09:21:59AM -0700, Paul E. McKenney wrote:
> > > > On Fri, May 10, 2024 at 01:06:40PM -0300, Leonardo Bras wrote:
> > > > > On Thu, May 09, 2024 at 04:45:53PM -0700, Paul E. McKenney wrote:
> > > > > > On Thu, May 09, 2024 at 07:14:18AM -0300, Leonardo Bras wrote:
> > > > > > > On Thu, May 09, 2024 at 05:16:57AM -0300, Leonardo Bras wrote:
> > > > > > 
> > > > > > [ . . . ]
> > > > > > 
> > > > > > > > Here I suppose something like this can take care of not needing to convert 
> > > > > > > > ms -> jiffies every rcu_pending():
> > > > > > > > 
> > > > > > > > +	nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> > > > > > > > 
> > > > > > > 
> > > > > > > Uh, there is more to it, actually. We need to make sure the user 
> > > > > > > understands that we are rounding-down the value to multiple of a jiffy 
> > > > > > > period, so it's not a surprise if the delay value is not exactly the same 
> > > > > > > as the passed on kernel cmdline.
> > > > > > > 
> > > > > > > So something like bellow diff should be ok, as this behavior is explained 
> > > > > > > in the docs, and pr_info() will print the effective value.
> > > > > > > 
> > > > > > > What do you think?
> > > > > > 
> > > > > > Good point, and I have taken your advice on making the documentation
> > > > > > say what it does.
> > > > > 
> > > > > Thanks :)
> > > > > 
> > > > > > 
> > > > > > > Thanks!
> > > > > > > Leo
> > > > > > > 
> > > > > > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > > > > > index 0a3b0fd1910e..9a50be9fd9eb 100644
> > > > > > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > > > > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > > > > > @@ -4974,20 +4974,28 @@
> > > > > > >                         otherwise be caused by callback floods through
> > > > > > >                         use of the ->nocb_bypass list.  However, in the
> > > > > > >                         common non-flooded case, RCU queues directly to
> > > > > > >                         the main ->cblist in order to avoid the extra
> > > > > > >                         overhead of the ->nocb_bypass list and its lock.
> > > > > > >                         But if there are too many callbacks queued during
> > > > > > >                         a single jiffy, RCU pre-queues the callbacks into
> > > > > > >                         the ->nocb_bypass queue.  The definition of "too
> > > > > > >                         many" is supplied by this kernel boot parameter.
> > > > > > >  
> > > > > > > +       rcutree.nocb_patience_delay= [KNL]
> > > > > > > +                       On callback-offloaded (rcu_nocbs) CPUs, avoid
> > > > > > > +                       disturbing RCU unless the grace period has
> > > > > > > +                       reached the specified age in milliseconds.
> > > > > > > +                       Defaults to zero.  Large values will be capped
> > > > > > > +                       at five seconds. Values rounded-down to a multiple
> > > > > > > +                       of a jiffy period.
> > > > > > > +
> > > > > > >         rcutree.qhimark= [KNL]
> > > > > > >                         Set threshold of queued RCU callbacks beyond which
> > > > > > >                         batch limiting is disabled.
> > > > > > >  
> > > > > > >         rcutree.qlowmark= [KNL]
> > > > > > >                         Set threshold of queued RCU callbacks below which
> > > > > > >                         batch limiting is re-enabled.
> > > > > > >  
> > > > > > >         rcutree.qovld= [KNL]
> > > > > > >                         Set threshold of queued RCU callbacks beyond which
> > > > > > > diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
> > > > > > > index fcf2b4aa3441..62ede401420f 100644
> > > > > > > --- a/kernel/rcu/tree.h
> > > > > > > +++ b/kernel/rcu/tree.h
> > > > > > > @@ -512,20 +512,21 @@ do {                                                              \
> > > > > > >         local_irq_save(flags);                                  \
> > > > > > >         if (rcu_segcblist_is_offloaded(&(rdp)->cblist)) \
> > > > > > >                 raw_spin_lock(&(rdp)->nocb_lock);               \
> > > > > > >  } while (0)
> > > > > > >  #else /* #ifdef CONFIG_RCU_NOCB_CPU */
> > > > > > >  #define rcu_nocb_lock_irqsave(rdp, flags) local_irq_save(flags)
> > > > > > >  #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
> > > > > > >  
> > > > > > >  static void rcu_bind_gp_kthread(void);
> > > > > > >  static bool rcu_nohz_full_cpu(void);
> > > > > > > +static bool rcu_on_patience_delay(void);
> > > > > > 
> > > > > > I don't think we need an access function, but will check below.
> > > > > > 
> > > > > > >  /* Forward declarations for tree_stall.h */
> > > > > > >  static void record_gp_stall_check_time(void);
> > > > > > >  static void rcu_iw_handler(struct irq_work *iwp);
> > > > > > >  static void check_cpu_stall(struct rcu_data *rdp);
> > > > > > >  static void rcu_check_gp_start_stall(struct rcu_node *rnp, struct rcu_data *rdp,
> > > > > > >                                      const unsigned long gpssdelay);
> > > > > > >  
> > > > > > >  /* Forward declarations for tree_exp.h. */
> > > > > > >  static void sync_rcu_do_polled_gp(struct work_struct *wp);
> > > > > > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > > > > > index 340bbefe5f65..639243b0410f 100644
> > > > > > > --- a/kernel/rcu/tree_plugin.h
> > > > > > > +++ b/kernel/rcu/tree_plugin.h
> > > > > > > @@ -5,20 +5,21 @@
> > > > > > >   * or preemptible semantics.
> > > > > > >   *
> > > > > > >   * Copyright Red Hat, 2009
> > > > > > >   * Copyright IBM Corporation, 2009
> > > > > > >   *
> > > > > > >   * Author: Ingo Molnar <mingo@elte.hu>
> > > > > > >   *        Paul E. McKenney <paulmck@linux.ibm.com>
> > > > > > >   */
> > > > > > >  
> > > > > > >  #include "../locking/rtmutex_common.h"
> > > > > > > +#include <linux/jiffies.h>
> > > > > > 
> > > > > > This is already pulled in by the enclosing tree.c file, so it should not
> > > > > > be necessary to include it again. 
> > > > > 
> > > > > Even better :)
> > > > > 
> > > > > > (Or did you get a build failure when
> > > > > > leaving this out?)
> > > > > 
> > > > > I didn't, it's just that my editor complained the symbols were not getting 
> > > > > properly resolved, so I included it and it was fixed. But since clangd is 
> > > > > know to make some mistakes, I should have compile-test'd before adding it.
> > > > 
> > > > Ah, got it!  ;-)
> > > > 
> > > > > > >  static bool rcu_rdp_is_offloaded(struct rcu_data *rdp)
> > > > > > >  {
> > > > > > >         /*
> > > > > > >          * In order to read the offloaded state of an rdp in a safe
> > > > > > >          * and stable way and prevent from its value to be changed
> > > > > > >          * under us, we must either hold the barrier mutex, the cpu
> > > > > > >          * hotplug lock (read or write) or the nocb lock. Local
> > > > > > >          * non-preemptible reads are also safe. NOCB kthreads and
> > > > > > >          * timers have their own means of synchronization against the
> > > > > > > @@ -86,20 +87,33 @@ static void __init rcu_bootup_announce_oddness(void)
> > > > > > >         if (rcu_kick_kthreads)
> > > > > > >                 pr_info("\tKick kthreads if too-long grace period.\n");
> > > > > > >         if (IS_ENABLED(CONFIG_DEBUG_OBJECTS_RCU_HEAD))
> > > > > > >                 pr_info("\tRCU callback double-/use-after-free debug is enabled.\n");
> > > > > > >         if (gp_preinit_delay)
> > > > > > >                 pr_info("\tRCU debug GP pre-init slowdown %d jiffies.\n", gp_preinit_delay);
> > > > > > >         if (gp_init_delay)
> > > > > > >                 pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_init_delay);
> > > > > > >         if (gp_cleanup_delay)
> > > > > > >                 pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", gp_cleanup_delay);
> > > > > > > +       if (nocb_patience_delay < 0) {
> > > > > > > +               pr_info("\tRCU NOCB CPU patience negative (%d), resetting to zero.\n",
> > > > > > > +                       nocb_patience_delay);
> > > > > > > +               nocb_patience_delay = 0;
> > > > > > > +       } else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> > > > > > > +               pr_info("\tRCU NOCB CPU patience too large (%d), resetting to %ld.\n",
> > > > > > > +                       nocb_patience_delay, 5 * MSEC_PER_SEC);
> > > > > > > +               nocb_patience_delay = msecs_to_jiffies(5 * MSEC_PER_SEC);
> > > > > > > +       } else if (nocb_patience_delay) {
> > > > > > > +               nocb_patience_delay = msecs_to_jiffies(nocb_patience_delay);
> > > > > > > +               pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\n",
> > > > > > > +                       jiffies_to_msecs(nocb_patience_delay);
> > > > > > > +       }
> > > > > > 
> > > > > > I just did this here at the end:
> > > > > > 
> > > > > > 	nocb_patience_delay_jiffies = msecs_to_jiffies(nocb_patience_delay);
> > > > > > 
> > > > > > Ah, you are wanting to print out the milliseconds after the rounding
> > > > > > to jiffies.
> > > > > 
> > > > > That's right, just to make sure the user gets the effective patience time, 
> > > > > instead of the before-rounding one, which was on input.
> > > > > 
> > > > > > I am going to hold off on that for the moment, but I hear your request
> > > > > > and I have not yet said "no".  ;-)
> > > > > 
> > > > > Sure :)
> > > > > It's just something I think it's nice to have (as a user).
> > > > 
> > > > If you would like to do a separate patch adding this, here are the
> > > > requirements:
> > > > 
> > > > o	If the current code prints nothing, nothing additional should
> > > > 	be printed.
> > > > 
> > > > o	If the rounding ended up with the same value (as it should in
> > > > 	systems with HZ=1000), nothing additional should be printed.
> > > > 
> > > > o	Your choice as to whether or not you want to print out the
> > > > 	jiffies value.
> > > > 
> > > > o	If the additional message is on a new line, it needs to be
> > > > 	indented so that it is clear that it is subordinate to the
> > > > 	previous message.
> > > > 
> > > > 	Otherwise, you can use pr_cont() to continue the previous
> > > > 	line, of course being careful about "\n".
> > > > 
> > > > Probably also something that I am forgetting, but that is most of it.
> > > 
> > > Thanks!
> > > I will work on a patch doing that :)
> > 
> > Very good, looking forward to seeing what you come up with!
> > 
> > My current state is on the "dev" branch of the -rcu tree, so please base
> > on that.
> 
> Thanks! I used it earlier to send the previous diff :)
> 
> > 
> > > > > > >         if (!use_softirq)
> > > > > > >                 pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.\n");
> > > > > > >         if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
> > > > > > >                 pr_info("\tRCU debug extended QS entry/exit.\n");
> > > > > > >         rcupdate_announce_bootup_oddness();
> > > > > > >  }
> > > > > > >  
> > > > > > >  #ifdef CONFIG_PREEMPT_RCU
> > > > > > >  
> > > > > > >  static void rcu_report_exp_rnp(struct rcu_node *rnp, bool wake);
> > > > > > > @@ -1260,10 +1274,29 @@ static bool rcu_nohz_full_cpu(void)
> > > > > > >  
> > > > > > >  /*
> > > > > > >   * Bind the RCU grace-period kthreads to the housekeeping CPU.
> > > > > > >   */
> > > > > > >  static void rcu_bind_gp_kthread(void)
> > > > > > >  {
> > > > > > >         if (!tick_nohz_full_enabled())
> > > > > > >                 return;
> > > > > > >         housekeeping_affine(current, HK_TYPE_RCU);
> > > > > > >  }
> > > > > > > +
> > > > > > > +/*
> > > > > > > + * Is this CPU a NO_HZ_FULL CPU that should ignore RCU if the time since the
> > > > > > > + * start of current grace period is smaller than nocb_patience_delay ?
> > > > > > > + *
> > > > > > > + * This code relies on the fact that all NO_HZ_FULL CPUs are also
> > > > > > > + * RCU_NOCB_CPU CPUs.
> > > > > > > + */
> > > > > > > +static bool rcu_on_patience_delay(void)
> > > > > > > +{
> > > > > > > +#ifdef CONFIG_NO_HZ_FULL
> > > > > > 
> > > > > > You lost me on this one.  Why do we need the #ifdef instead of
> > > > > > IS_ENABLED()?  Also, please note that rcu_nohz_full_cpu() is already a
> > > > > > compile-time @false in CONFIG_NO_HZ_FULL=n kernels.
> > > > > 
> > > > > You are right. rcu_nohz_full_cpu() has a high chance of being inlined on
> > > > > 	if ((...) && rcu_nohz_full_cpu())
> > > > > And since it returns false, this whole statement will be compiled out, and 
> > > > > the new function will not exist in CONFIG_NO_HZ_FULL=n, so there  is no 
> > > > > need to test it.
> > > > 
> > > > Very good!  You had me going there for a bit.  ;-)
> > > > 
> > > > > > > +       if (!nocb_patience_delay)
> > > > > > > +               return false;
> > > > > > 
> > > > > > We get this automatically with the comparison below, right?
> > > > > 
> > > > > Right
> > > > > 
> > > > > >   If so, we
> > > > > > are not gaining much by creating the helper function.  Or am I missing
> > > > > > some trick here?
> > > > > 
> > > > > Well, it's a fastpath. Up to here, we just need to read 
> > > > > nocb_patience_delay{,_jiffies} from memory.
> > > > 
> > > > Just nocb_patience_delay_jiffies, correct?  Unless I am missing something,
> > > > nocb_patience_delay is unused after boot.
> > > 
> > > Right, I used both because I was referring to the older version and the 
> > > current version with _jiffies.
> > 
> > Fair enough!
> > 
> > > > > If we don't include the fastpath we have to read jiffies and 
> > > > > rcu_state.gp_start, which can take extra time: up to 2 cache misses.
> > > > > 
> > > > > I thought it could be relevant, as we reduce the overhead of the new 
> > > > > parameter when it's disabled (patience=0). 
> > > > > 
> > > > > Do you think that could be relevant?
> > > > 
> > > > Well, the hardware's opinion is what matters.  ;-)
> > > > 
> > > > But the caller's code path reads jiffies a few times, so it should
> > > > be hot in the cache, correct?
> > > 
> > > Right, but I wonder how are the chances of it getting updated between  
> > > caller's use and this function's. Same for gp_start.
> > 
> > Well, jiffies is updated at most once per millisecond, and gp_start is
> > updated at most once per few milliseconds.  So the chances of it being
> > updated within that code sequence are quite small.
> 
> Fair enough, and we probably don't need to worry about it getting 
> cached-out in this sequence, as well. 
> 
> Also time_before() is a macro and we don't need to worry on the function 
> call, so we just spend 2 extra L1-cache reads and a couple arithmetic 
> instructions which are not supposed to take long, so it's fair to assume 
> the fast-path would not be that much faster than the slow path, which means 
> we don't need a fast path after all.
> 
> Thanks for helping me notice that :)
> 
> > 
> > > > But that does lead to another topic, namely the possibility of tagging
> > > > nocb_patience_delay_jiffies with __read_mostly. 
> > > 
> > > Oh, right. This was supposed to be in the diff I sent earlier, but I 
> > > completelly forgot to change before sending. So, yeah, I agree on 
> > > nocb_patience_delay being __read_mostly; 
> > > 
> > > > And there might be
> > > > a number of other of RCU's variables that could be similarly tagged
> > > > in order to avoid false sharing.  (But is there any false sharing?
> > > > This might be worth testing.)
> > > 
> > > Maybe there isn't, but I wonder if it would hurt performance if they were 
> > > tagged as __read_only anyway. 
> > 
> > Let's be at least a little careful here.  It is just as easy to hurt
> > performance by marking things __read_mostly or __read_only as it is
> > to help performance.  ;-)
> 
> Fair enough :)
> 
> > 
> > 							Thanx, Paul
> > 
> 

Oh, btw, for what it's worth:
Reviewed-by: Leonardo Bras <leobras@redhat.com>

Thanks!
Leo


