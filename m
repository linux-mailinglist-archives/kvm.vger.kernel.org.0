Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8196066CF38
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjAPS4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjAPS4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:56:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329F318B35;
        Mon, 16 Jan 2023 10:56:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C34B161117;
        Mon, 16 Jan 2023 18:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0F2C433EF;
        Mon, 16 Jan 2023 18:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673895392;
        bh=DuMYZOnr0bMZvp7GSH2TEtxIL4JXiMj6qVLcpIaZmVw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=nNscdUa5yyar00y4JkXqh/nP1LwzCLEY3fydqzu6fthUBWQOwSIevYrYNrDeChQR3
         D8F6MGD1axAjkWcOE9CUsxvsxv+drEgsIAI3kRi9eBVUNaybBz/SaSx+WO2PiUSYeu
         ZAmA+HZE8m3lkKINt/rCVtquL3O/WI0gvQiI3NvuCbePGAdKsIsI3lyE0QSx5Fm2Mu
         k6slx5iTdh2aeBbVdphF/sXLKgCDo1sBOiEjbXDVZQw18FqNKLJY7QpNCY90I21QBT
         Y7FkrZ+SSN9B2j7NTeILgbOMm2VrGEaNX/MLj5EKYpM9tN/HfVUz6eIO76gITp2f6k
         fdIdMW5fVn/uA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id CB7385C0687; Mon, 16 Jan 2023 10:56:31 -0800 (PST)
Date:   Mon, 16 Jan 2023 10:56:31 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 2/3] rcu: Equip sleepable RCU with lockdep dependency
 graph checks
Message-ID: <20230116185631.GY2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113065955.815667-3-boqun.feng@gmail.com>
 <20230113112949.GX4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y8GdYgSBtyKwf/qj@boqun-archlinux>
 <20230113191120.GB4028633@paulmck-ThinkPad-P17-Gen-1>
 <456f6c15-3043-6da2-349d-c0c3880c1a55@redhat.com>
 <Y8WPWJ6TKg5ikZYr@Boquns-Mac-mini.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8WPWJ6TKg5ikZYr@Boquns-Mac-mini.local>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 09:54:32AM -0800, Boqun Feng wrote:
> On Mon, Jan 16, 2023 at 06:36:43PM +0100, Paolo Bonzini wrote:
> > On 1/13/23 20:11, Paul E. McKenney wrote:
> > > On Fri, Jan 13, 2023 at 10:05:22AM -0800, Boqun Feng wrote:
> > > > On Fri, Jan 13, 2023 at 03:29:49AM -0800, Paul E. McKenney wrote:
> > > > I prefer that the first two patches go through your tree, because it
> > > > reduces the synchronization among locking, rcu and KVM trees to the
> > > > synchronization betwen rcu and KVM trees.
> > > 
> > > Very well, I have queued and pushed these with the usual wordsmithing,
> > > thank you!
> > 
> > I'm worried about this case:
> > 
> > 	CPU 0				CPU 1
> > 	--------------------		------------------
> > 	lock A				srcu lock B
> > 	srcu lock B			lock A
> > 	srcu unlock B			unlock A
> > 	unlock A			srcu unlock B
> > 
> > While a bit unclean, there is nothing that downright forbids this; as long
> > as synchronize_srcu does not happen inside lock A, no deadlock can occur.
> > 
> 
> First, even with my change, lockdep won't report this as a deadlock
> because srcu_read_lock() is annotated as a recursive (unfair) read lock
> (the "read" parameter for lock_acquire() is 2) and in this case lockdep
> knows that it won't cause deadlock.
> 
> For SRCU, the annotation mapping that is 1) srcu_read_lock() is marked
> as recursive read lock and 2) synchronize_srcu() is marked as write lock
> sync, recursive read locks themselves cannot cause deadlocks and lockdep
> is aware of it.
> 
> Will add a selftest for this later.
> 
> > However, if srcu is replaced with an rwlock then lockdep should and does
> > report a deadlock.  Boqun, do you get a false positive or do your patches
> 
> To be more precise, to have a deadlock, the read lock on CPU 0 has to be
> a *fair* read lock (i.e. non-recursive reader, the "read" parameter for
> lock_acquire is 1)
> 
> > correctly suppress this?
> 
> I'm pretty sure that lockdep handles this ;-)

And lockdep agrees, refusing to complain about the following:

	idx = srcu_read_lock(&srcu1);
	mutex_lock(&mut1);
	mutex_unlock(&mut1);
	srcu_read_unlock(&srcu1, idx);

	mutex_lock(&mut1);
	idx = srcu_read_lock(&srcu1);
	srcu_read_unlock(&srcu1, idx);
	mutex_unlock(&mut1);

							Thanx, Paul
