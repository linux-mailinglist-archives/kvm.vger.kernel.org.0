Return-Path: <kvm+bounces-17140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E228C19C5
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 01:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23FD31C20E16
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 23:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424CC12D76B;
	Thu,  9 May 2024 23:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iHDn6mqx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB86E12838D
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 23:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715296061; cv=none; b=FUP0Vsz7kVZ7BplPBUUgR8sk7QgdjWaKQx0H79/YSpVeIT08I6rRLkw5DlqRy4hqXMmtTtQ8LKWeRjLIeFfBl9b4t8AlhsQiX3KbB+FgYKE0vAVNV1oWRhUNXBlrDUbxMfuEC4I7Sp3/BV2GmwOcQaKn446xuZVHkYukzRonSFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715296061; c=relaxed/simple;
	bh=gp8pOF3IuXWxQKBZ6DWNOxyiPHT5bmd27HVxhF2Y3GY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gKLWbtcgZ8B5siy7qEEZK/Njb+UsGxrd4OahyYeuV/Awg2rmJJotITgtMGEq2Yo0VzloN+/+u6ya0HGCCQEIzVFljgbKpVK1Z0/qqPG9+8aIwGvIHFze52xbGd/w1GFBdI+8Jx6RTSdXxJCB4lGzOUVDo3zzGBCxZGNgz5cHIpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iHDn6mqx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715296057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CFaELFWpjddYkl/64kvLJs1WRRF9HXHu9i0yKLDkOEs=;
	b=iHDn6mqx1hIbGMiVBoSBdx8RqMPbtgrnXc7j6ibt+2iHh4tGY9cN6nAVcwhizqdy8L8zMM
	7mDDmwY0KYMKI57Nfv4dOEgAXccMoylihdpqUvK7z1NQ24T+842DQLnOcsFIr3tG1rz/DS
	MoQqQe4i+TJEH04gxjRqMk5sGBhnwEc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-oJvhPxbKO0OWeK19VsH0Pg-1; Thu, 09 May 2024 19:07:36 -0400
X-MC-Unique: oJvhPxbKO0OWeK19VsH0Pg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2b3756e6333so1361092a91.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2024 16:07:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715296055; x=1715900855;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFaELFWpjddYkl/64kvLJs1WRRF9HXHu9i0yKLDkOEs=;
        b=kuvenmPGXEE5X1GUQRmW+REJj9Xsf6Dm1tUr6UO+oTon6oHaxgVKFYIK6INCBXeYEu
         u2SkB4UwNjvbmd0MIAwiwJnnDSZgWYHHgiWYpamio33/WLh6l+Vhy02sb21/leftM02C
         p0oFUXA9GYOB2OgjHwrj/T6nqtvBT/snHLZ9/GgnT76rRsAAZ4f+7rdiwaR8KpsWtwmm
         ECZBq2Cd4OhqqJ0uGCT1zgRrv+DW8gq4jL6+JSE+Mjbm8JEQsZerp9FSFYDDhmlOl1ZL
         q8b3anq4oiy/1wdn9E3X6a7ws/0FVrOokqroOYm2BB5Y+iqVdFi5c2DzARhR7G2sy0JY
         g8JA==
X-Forwarded-Encrypted: i=1; AJvYcCXfHnDx020weAJPuIqLm8lBpmfgGxvp3Z0zNcJLak6s3VKuIkZpq1Ick1j5Ppmo9tHOJMqOs/FYVO5mw4pufz8kNTAa
X-Gm-Message-State: AOJu0YxLKMnbHbntJbZnHH8eqS5k7GjzvjMFEOwf8OpXXuuyX38AhN/j
	nqS4W5Lm1sBBNVwqoMA+MrWkN/GiRLPKabglHIkoSjSRFPX5gZaeOk0HK6ZMj7JkylERI9oShgO
	mSNhWb+rRYMSahcX3gE2Wqk5sf304sTIqhGop46ugbmns+KwWhmOInRiZn2i5PVRUif04N5A2CI
	psrWIe8MsVvmyKlm/wXmHPm7Pt
X-Received: by 2002:a17:90a:7e11:b0:2b6:c4d7:fd9d with SMTP id 98e67ed59e1d1-2b6ccc72f75mr943290a91.35.1715296055198;
        Thu, 09 May 2024 16:07:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/tETTTwQT03sxCmkOb4viliHZXHbh2TuSgm6BrIdm/xGbTuTZd5G6B8tBSHad3DKv/GtsmDGttKuAYWvYpho=
X-Received: by 2002:a17:90a:7e11:b0:2b6:c4d7:fd9d with SMTP id
 98e67ed59e1d1-2b6ccc72f75mr943264a91.35.1715296054648; Thu, 09 May 2024
 16:07:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZjqWXPFuoYWWcxP3@google.com> <0e239143-65ed-445a-9782-e905527ea572@paulmck-laptop>
 <Zjq9okodmvkywz82@google.com> <ZjrClk4Lqw_cLO5A@google.com>
 <Zjroo8OsYcVJLsYO@LeoBras> <b44962dd-7b8a-4201-90b7-4c39ba20e28d@paulmck-laptop>
 <ZjsZVUdmDXZOn10l@LeoBras> <ZjuFuZHKUy7n6-sG@google.com> <5fd66909-1250-4a91-aa71-93cb36ed4ad5@paulmck-laptop>
 <ZjyGefTZ8ThZukNG@LeoBras> <4e368040-05b0-46ab-bafa-59710d5de549@paulmck-laptop>
In-Reply-To: <4e368040-05b0-46ab-bafa-59710d5de549@paulmck-laptop>
From: Leonardo Bras Soares Passos <leobras@redhat.com>
Date: Thu, 9 May 2024 20:07:22 -0300
Message-ID: <CAJ6HWG4LyyLuQ9ZZ2ayLRt79_m_6-=ZePhHyQV8VTMPjFG+kYg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/2] Avoid rcu_core() if CPU just left guest vcpu
To: paulmck@kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <quic_neeraju@quicinc.com>, 
	Joel Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Zqiang <qiang.zhang1211@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 9, 2024 at 7:44=E2=80=AFPM Paul E. McKenney <paulmck@kernel.org=
> wrote:
>
> On Thu, May 09, 2024 at 05:16:57AM -0300, Leonardo Bras wrote:
> > On Wed, May 08, 2024 at 08:32:40PM -0700, Paul E. McKenney wrote:
> > > On Wed, May 08, 2024 at 07:01:29AM -0700, Sean Christopherson wrote:
> > > > On Wed, May 08, 2024, Leonardo Bras wrote:
> > > > > Something just hit me, and maybe I need to propose something more=
 generic.
> > > >
> > > > Yes.  This is what I was trying to get across with my complaints ab=
out keying off
> > > > of the last VM-Exit time.  It's effectively a broad stroke "this ta=
sk will likely
> > > > be quiescent soon" and so the core concept/functionality belongs in=
 common code,
> > > > not KVM.
> > >
> > > OK, we could do something like the following wholly within RCU, namel=
y
> > > to make rcu_pending() refrain from invoking rcu_core() until the grac=
e
> > > period is at least the specified age, defaulting to zero (and to the
> > > current behavior).
> > >
> > > Perhaps something like the patch shown below.
> >
> > That's exactly what I was thinking :)
> >
> > >
> > > Thoughts?
> >
> > Some suggestions below:
> >
> > >
> > >                                                     Thanx, Paul
> > >
> > > ---------------------------------------------------------------------=
---
> > >
> > > commit abc7cd2facdebf85aa075c567321589862f88542
> > > Author: Paul E. McKenney <paulmck@kernel.org>
> > > Date:   Wed May 8 20:11:58 2024 -0700
> > >
> > >     rcu: Add rcutree.nocb_patience_delay to reduce nohz_full OS jitte=
r
> > >
> > >     If a CPU is running either a userspace application or a guest OS =
in
> > >     nohz_full mode, it is possible for a system call to occur just as=
 an
> > >     RCU grace period is starting.  If that CPU also has the schedulin=
g-clock
> > >     tick enabled for any reason (such as a second runnable task), and=
 if the
> > >     system was booted with rcutree.use_softirq=3D0, then RCU can add =
insult to
> > >     injury by awakening that CPU's rcuc kthread, resulting in yet ano=
ther
> > >     task and yet more OS jitter due to switching to that task, runnin=
g it,
> > >     and switching back.
> > >
> > >     In addition, in the common case where that system call is not of
> > >     excessively long duration, awakening the rcuc task is pointless.
> > >     This pointlessness is due to the fact that the CPU will enter an =
extended
> > >     quiescent state upon returning to the userspace application or gu=
est OS.
> > >     In this case, the rcuc kthread cannot do anything that the main R=
CU
> > >     grace-period kthread cannot do on its behalf, at least if it is g=
iven
> > >     a few additional milliseconds (for example, given the time durati=
on
> > >     specified by rcutree.jiffies_till_first_fqs, give or take schedul=
ing
> > >     delays).
> > >
> > >     This commit therefore adds a rcutree.nocb_patience_delay kernel b=
oot
> > >     parameter that specifies the grace period age (in milliseconds)
> > >     before which RCU will refrain from awakening the rcuc kthread.
> > >     Preliminary experiementation suggests a value of 1000, that is,
> > >     one second.  Increasing rcutree.nocb_patience_delay will increase
> > >     grace-period latency and in turn increase memory footprint, so sy=
stems
> > >     with constrained memory might choose a smaller value.  Systems wi=
th
> > >     less-aggressive OS-jitter requirements might choose the default v=
alue
> > >     of zero, which keeps the traditional immediate-wakeup behavior, t=
hus
> > >     avoiding increases in grace-period latency.
> > >
> > >     Link: https://lore.kernel.org/all/20240328171949.743211-1-leobras=
@redhat.com/
> > >
> > >     Reported-by: Leonardo Bras <leobras@redhat.com>
> > >     Suggested-by: Leonardo Bras <leobras@redhat.com>
> > >     Suggested-by: Sean Christopherson <seanjc@google.com>
> > >     Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> > >
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Docume=
ntation/admin-guide/kernel-parameters.txt
> > > index 0a3b0fd1910e6..42383986e692b 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -4981,6 +4981,13 @@
> > >                     the ->nocb_bypass queue.  The definition of "too
> > >                     many" is supplied by this kernel boot parameter.
> > >
> > > +   rcutree.nocb_patience_delay=3D [KNL]
> > > +                   On callback-offloaded (rcu_nocbs) CPUs, avoid
> > > +                   disturbing RCU unless the grace period has
> > > +                   reached the specified age in milliseconds.
> > > +                   Defaults to zero.  Large values will be capped
> > > +                   at five seconds.
> > > +
> > >     rcutree.qhimark=3D [KNL]
> > >                     Set threshold of queued RCU callbacks beyond whic=
h
> > >                     batch limiting is disabled.
> > > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > > index 7560e204198bb..6e4b8b43855a0 100644
> > > --- a/kernel/rcu/tree.c
> > > +++ b/kernel/rcu/tree.c
> > > @@ -176,6 +176,8 @@ static int gp_init_delay;
> > >  module_param(gp_init_delay, int, 0444);
> > >  static int gp_cleanup_delay;
> > >  module_param(gp_cleanup_delay, int, 0444);
> > > +static int nocb_patience_delay;
> > > +module_param(nocb_patience_delay, int, 0444);
> > >
> > >  // Add delay to rcu_read_unlock() for strict grace periods.
> > >  static int rcu_unlock_delay;
> > > @@ -4334,6 +4336,8 @@ EXPORT_SYMBOL_GPL(cond_synchronize_rcu_full);
> > >  static int rcu_pending(int user)
> > >  {
> > >     bool gp_in_progress;
> > > +   unsigned long j =3D jiffies;
> >
> > I think this is probably taken care by the compiler, but just in case I=
 would move the
> > j =3D jiffies;
> > closer to it's use, in order to avoid reading 'jiffies' if rcu_pending
> > exits before the nohz_full testing.
>
> Good point!  I just removed j and used jiffies directly.
>
> > > +   unsigned int patience =3D msecs_to_jiffies(nocb_patience_delay);
> >
> > What do you think on processsing the new parameter in boot, and saving =
it
> > in terms of jiffies already?
> >
> > It would make it unnecessary to convert ms -> jiffies every time we run
> > rcu_pending.
> >
> > (OOO will probably remove the extra division, but may cause less impact=
 in
> > some arch)
>
> This isn't exactly a fastpath, but it is easy enough to do the conversion
> in rcu_bootup_announce_oddness() and place it into another variable
> (for the benefit of those using drgn or going through crash dumps).
>
> > >     struct rcu_data *rdp =3D this_cpu_ptr(&rcu_data);
> > >     struct rcu_node *rnp =3D rdp->mynode;
> > >
> > > @@ -4347,11 +4351,13 @@ static int rcu_pending(int user)
> > >             return 1;
> > >
> > >     /* Is this a nohz_full CPU in userspace or idle?  (Ignore RCU if =
so.) */
> > > -   if ((user || rcu_is_cpu_rrupt_from_idle()) && rcu_nohz_full_cpu()=
)
> > > +   gp_in_progress =3D rcu_gp_in_progress();
> > > +   if ((user || rcu_is_cpu_rrupt_from_idle() ||
> > > +        (gp_in_progress && time_before(j + patience, rcu_state.gp_st=
art))) &&
> >
> > I think you meant:
> >       time_before(j, rcu_state.gp_start + patience)
> >
> > or else this always fails, as we can never have now to happen before a
> > previously started gp, right?
> >
> > Also, as per rcu_nohz_full_cpu() we probably need it to be read with
> > READ_ONCE():
> >
> >       time_before(j, READ_ONCE(rcu_state.gp_start) + patience)
>
> Good catch on both counts, fixed!
>
> > > +       rcu_nohz_full_cpu())
> > >             return 0;
> > >
> > >     /* Is the RCU core waiting for a quiescent state from this CPU? *=
/
> > > -   gp_in_progress =3D rcu_gp_in_progress();
> > >     if (rdp->core_needs_qs && !rdp->cpu_no_qs.b.norm && gp_in_progres=
s)
> > >             return 1;
> > >
> > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > index 340bbefe5f652..174333d0e9507 100644
> > > --- a/kernel/rcu/tree_plugin.h
> > > +++ b/kernel/rcu/tree_plugin.h
> > > @@ -93,6 +93,15 @@ static void __init rcu_bootup_announce_oddness(voi=
d)
> > >             pr_info("\tRCU debug GP init slowdown %d jiffies.\n", gp_=
init_delay);
> > >     if (gp_cleanup_delay)
> > >             pr_info("\tRCU debug GP cleanup slowdown %d jiffies.\n", =
gp_cleanup_delay);
> > > +   if (nocb_patience_delay < 0) {
> > > +           pr_info("\tRCU NOCB CPU patience negative (%d), resetting=
 to zero.\n", nocb_patience_delay);
> > > +           nocb_patience_delay =3D 0;
> > > +   } else if (nocb_patience_delay > 5 * MSEC_PER_SEC) {
> > > +           pr_info("\tRCU NOCB CPU patience too large (%d), resettin=
g to %ld.\n", nocb_patience_delay, 5 * MSEC_PER_SEC);
> > > +           nocb_patience_delay =3D 5 * MSEC_PER_SEC;
> > > +   } else if (nocb_patience_delay) {
> >
> > Here you suggest that we don't print if 'nocb_patience_delay =3D=3D 0',
> > as it's the default behavior, right?
>
> Exactly, in keeping with the function name rcu_bootup_announce_oddness().
>
> This approach allows easy spotting of deviations from default settings,
> which can be very helpful when debugging.
>
> > I think printing on 0 could be useful to check if the feature exists, e=
ven
> > though we are zeroing it, but this will probably add unnecessary verbos=
ity.
>
> It could be quite useful to people learning the RCU implementation,
> and I encourage those people to remove all those "if" statements from
> rcu_bootup_announce_oddness() in order to get the full story.
>
> > > +           pr_info("\tRCU NOCB CPU patience set to %d milliseconds.\=
n", nocb_patience_delay);
> > > +   }
> >
> > Here I suppose something like this can take care of not needing to conv=
ert
> > ms -> jiffies every rcu_pending():
> >
> > +     nocb_patience_delay =3D msecs_to_jiffies(nocb_patience_delay);
>
> Agreed, but I used a separate variable to help people looking at crash
> dumps or using drgn.
>
> And thank you for your review and comments!  Applying these changes
> with attribution.
>

Thank you!
Leo

>                                                         Thanx, Paul
>
> > >     if (!use_softirq)
> > >             pr_info("\tRCU_SOFTIRQ processing moved to rcuc kthreads.=
\n");
> > >     if (IS_ENABLED(CONFIG_RCU_EQS_DEBUG))
> > >
> >
> >
> > Thanks!
> > Leo
> >
>


