Return-Path: <kvm+bounces-19999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B3B90F472
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 18:47:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 654ADB22C32
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 16:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99666155C8E;
	Wed, 19 Jun 2024 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6v5z/sd"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929CB2262B;
	Wed, 19 Jun 2024 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718815596; cv=none; b=a1/Cb2UNdUvQC4Pmw0B4YWM9yyv2/OFUUJJKpOoTBjFWJ57gMu9K9OGJiVbkOmSPaaJUFlpMJ9i64A9D4YYjDgBewIiDdJHCJMCkrn9vvmb+/lpG3oC6c5wPM2JHUUE45PAZ6C0gl9L4p/p2xYrl/bHJzD8dVes0STdQxzr5RFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718815596; c=relaxed/simple;
	bh=EYkeKSbtNt6ckvuCFzfSCizaZJeveGlRlQZbS2iiRBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3XEZcnslU7UfPPApSN7e6PKOnz60D7GtxSNPqeHcmMw9e4M9XycHHGL+FbgKx1kwoe0FEYuAsHE+VIjEwK7wgK7ayQe0GikRDTCeErD7H82n1lD254DRgsj0pIaKTvb886yrYxuQdoHM9nme1R1VDmySejtYurB7T3gqoK37wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6v5z/sd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E5A8C2BBFC;
	Wed, 19 Jun 2024 16:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718815596;
	bh=EYkeKSbtNt6ckvuCFzfSCizaZJeveGlRlQZbS2iiRBM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=U6v5z/sdVrRwT3ywPATsj7XmP7jMC/9Ue7euI2CV/THH1rdybzupp61Q3EwrfCb0Z
	 oRYlNRBfdTqybOoKx/k80D0IFIG9kqzvnBfEhD0JRlH5VjuYxCM23EMd3xBXpXT4V1
	 1uKiOxgwzsrXXxoSU+L5hezYeMeNJITqk3/QT2yQTixMKTvXNKFLINUqCcR1a6Eofa
	 +OA6Ypzrq6AdcZ9WeH29C2vx0ekyMr+caeurBrnmo/hQuNhH7uVp+yJZMA3eeltGHh
	 vqikZFgBg0Khso/7VAufzpVxv9ZrPvAsnpHAA9QtIEbrLcOlZKN9roRJ/XJu5hty2l
	 uLXG9ZdVaWb9A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id EC3CDCE09D8; Wed, 19 Jun 2024 09:46:35 -0700 (PDT)
Date: Wed, 19 Jun 2024 09:46:35 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
	kernel-janitors@vger.kernel.org, bridge@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nicholas Piggin <npiggin@gmail.com>, netdev@vger.kernel.org,
	wireguard@lists.zx2c4.com, linux-kernel@vger.kernel.org,
	ecryptfs@vger.kernel.org, Neil Brown <neilb@suse.de>,
	Olga Kornievskaia <kolga@netapp.com>, Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>, linux-nfs@vger.kernel.org,
	linux-can@vger.kernel.org, Lai Jiangshan <jiangshanlai@gmail.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <04567347-c138-48fb-a5ab-44cc6a318549@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>
 <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
 <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>

On Wed, Jun 19, 2024 at 11:28:13AM +0200, Vlastimil Babka wrote:
> On 6/18/24 7:53 PM, Paul E. McKenney wrote:
> > On Tue, Jun 18, 2024 at 07:21:42PM +0200, Vlastimil Babka wrote:
> >> On 6/18/24 6:48 PM, Paul E. McKenney wrote:
> >> > On Tue, Jun 18, 2024 at 11:31:00AM +0200, Uladzislau Rezki wrote:
> >> >> > On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
> >> >> > >> +
> >> >> > >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> >> >> > >> +
> >> >> > >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
> >> >> > > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
> >> >> > > wanted to avoid initially.
> >> >> > 
> >> >> > I wanted to avoid new API or flags for kfree_rcu() users and this would
> >> >> > be achieved. The barrier is used internally so I don't consider that an
> >> >> > API to avoid. How difficult is the implementation is another question,
> >> >> > depending on how the current batching works. Once (if) we have sheaves
> >> >> > proven to work and move kfree_rcu() fully into SLUB, the barrier might
> >> >> > also look different and hopefully easier. So maybe it's not worth to
> >> >> > invest too much into that barrier and just go for the potentially
> >> >> > longer, but easier to implement?
> >> >> > 
> >> >> Right. I agree here. If the cache is not empty, OK, we just defer the
> >> >> work, even we can use a big 21 seconds delay, after that we just "warn"
> >> >> if it is still not empty and leave it as it is, i.e. emit a warning and
> >> >> we are done.
> >> >> 
> >> >> Destroying the cache is not something that must happen right away. 
> >> > 
> >> > OK, I have to ask...
> >> > 
> >> > Suppose that the cache is created and destroyed by a module and
> >> > init/cleanup time, respectively.  Suppose that this module is rmmod'ed
> >> > then very quickly insmod'ed.
> >> > 
> >> > Do we need to fail the insmod if the kmem_cache has not yet been fully
> >> > cleaned up?
> >> 
> >> We don't have any such link between kmem_cache and module to detect that, so
> >> we would have to start tracking that. Probably not worth the trouble.
> > 
> > Fair enough!
> > 
> >> >  If not, do we have two versions of the same kmem_cache in
> >> > /proc during the overlap time?
> >> 
> >> Hm could happen in /proc/slabinfo but without being harmful other than
> >> perhaps confusing someone. We could filter out the caches being destroyed
> >> trivially.
> > 
> > Or mark them in /proc/slabinfo?  Yet another column, yay!!!  Or script
> > breakage from flagging the name somehow, for example, trailing "/"
> > character.
> 
> Yeah I've been resisting such changes to the layout and this wouldn't be
> worth it, apart from changing the name itself but not in a dangerous way
> like with "/" :)

;-) ;-) ;-)

> >> Sysfs and debugfs might be more problematic as I suppose directory names
> >> would clash. I'll have to check... might be even happening now when we do
> >> detect leaked objects and just leave the cache around... thanks for the
> >> question.
> > 
> > "It is a service that I provide."  ;-)
> > 
> > But yes, we might be living with it already and there might already
> > be ways people deal with it.
> 
> So it seems if the sysfs/debugfs directories already exist, they will
> silently not be created. Wonder if we have such cases today already because
> caches with same name exist. I think we do with the zsmalloc using 32 caches
> with same name that we discussed elsewhere just recently.
> 
> Also indeed if the cache has leaked objects and won't be thus destroyed,
> these directories indeed stay around, as well as the slabinfo entry, and can
> prevent new ones from being created (slabinfo lines with same name are not
> prevented).

New one on me!

> But it wouldn't be great to introduce this possibility to happen for the
> temporarily delayed removal due to kfree_rcu() and a module re-insert, since
> that's a legitimate case and not buggy state due to leaks.

Agreed.

> The debugfs directory we could remove immediately before handing over to the
> scheduled workfn, but if it turns out there was a leak and the workfn leaves
> the cache around, debugfs dir will be gone and we can't check the
> alloc_traces/free_traces files there (but we have the per-object info
> including the traces in the dmesg splat).
> 
> The sysfs directory is currently removed only with the whole cache being
> destryed due to sysfs/kobject lifetime model. I'd love to untangle it for
> other reasons too, but haven't investigated it yet. But again it might be
> useful for sysfs dir to stay around for inspection, as for the debugfs.
> 
> We could rename the sysfs/debugfs directories before queuing the work? Add
> some prefix like GOING_AWAY-$name. If leak is detected and cache stays
> forever, another rename to LEAKED-$name. (and same for the slabinfo). But
> multiple ones with same name might pile up, so try adding a counter then?
> Probably messy to implement, but perhaps the most robust in the end? The
> automatic counter could also solve the general case of people using same
> name for multiple caches.
> 
> Other ideas?

Move the going-away files/directories to some new directoriesy?  But you
would still need a counter or whatever.  I honestly cannot say what
would be best from the viewpoint of existing software scanning those
files and directories.

							Thanx, Paul

> Thanks,
> Vlastimil
> 
> > 
> > 							Thanx, Paul
> > 
> >> >> > > Since you do it asynchronous can we just repeat
> >> >> > > and wait until it a cache is furry freed?
> >> >> > 
> >> >> > The problem is we want to detect the cases when it's not fully freed
> >> >> > because there was an actual read. So at some point we'd need to stop the
> >> >> > repeats because we know there can no longer be any kfree_rcu()'s in
> >> >> > flight since the kmem_cache_destroy() was called.
> >> >> > 
> >> >> Agree. As noted above, we can go with 21 seconds(as an example) interval
> >> >> and just perform destroy(without repeating).
> >> >> 
> >> >> --
> >> >> Uladzislau Rezki
> >> 
> 

