Return-Path: <kvm+bounces-19883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6C6A90DB22
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 19:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B38B1F2559E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 17:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A386B15099C;
	Tue, 18 Jun 2024 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkOp7f3+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB551CAB3;
	Tue, 18 Jun 2024 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718733192; cv=none; b=kSnnQIlXIyDZyMZIYrelGg5GpzzE6UVIcyin8UH+Cn7AikQJZPF1edfIg/CtsI+3QhrLSzWz/BdGb4Lhqgcik4J3r6Bbu1xp4dfhvaAk5tE3UbgB3lG0SGUE+s+KKQ2jmG0EiCcr8SJfHHDDLh31KRjqUovHz7Jsg2z5iI6Hb6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718733192; c=relaxed/simple;
	bh=1oG2z1L2HMCk/Y21GlrePdx7AXyrdRLAZGfQqNCTU9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hU2aa3P504iXMC1l6vLhXLIbQNepjd4AH8WLt94DPsNA7mEIN/5HYCHTkxQ6HT3Gci4rhNr5y0GLapeSQoG4woMhDbp8Lt9x2xb2Jgw5EUmVHAe2ppeVYx99Ci+xFayR5+C3nShY+YC/V11QrtUop5/rAzv6agxBm4meoPyyaMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkOp7f3+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078A0C3277B;
	Tue, 18 Jun 2024 17:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718733192;
	bh=1oG2z1L2HMCk/Y21GlrePdx7AXyrdRLAZGfQqNCTU9I=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=QkOp7f3+vMry8cAs4SIc1hm/gEn1nrjiwL7M2c0KKPR9yiamR54iaHuuCRGK7piGG
	 +n42AXTyIq0ngAFYyq7228+ThonPylf7E7oMdT2aYR9Pj835uWmAGVPiU6S9gfNyhB
	 yfkIq9lqKnRI9OARD5J0WUk6ozDPQ5dA8rkdgqCxf/WalWf2keAEK6iXZgRM6fR4Ch
	 vHY9axBAPsFEWk9+VWTA6AYH4XWKV//PM6aKm/qaUrDDo0afnO6WO7QxPGZLE4pl9Y
	 oz/l1kLMvMAbKJ2LAF3HRzkHJxiudjKsFXTmeXVFEuWrvtx/MztlGXtyweNvs6fNs6
	 OSLwxNqjqPupw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id A0B31CE05B6; Tue, 18 Jun 2024 10:53:11 -0700 (PDT)
Date: Tue, 18 Jun 2024 10:53:11 -0700
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
Message-ID: <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>

On Tue, Jun 18, 2024 at 07:21:42PM +0200, Vlastimil Babka wrote:
> On 6/18/24 6:48 PM, Paul E. McKenney wrote:
> > On Tue, Jun 18, 2024 at 11:31:00AM +0200, Uladzislau Rezki wrote:
> >> > On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
> >> > >> +
> >> > >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> >> > >> +
> >> > >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
> >> > > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
> >> > > wanted to avoid initially.
> >> > 
> >> > I wanted to avoid new API or flags for kfree_rcu() users and this would
> >> > be achieved. The barrier is used internally so I don't consider that an
> >> > API to avoid. How difficult is the implementation is another question,
> >> > depending on how the current batching works. Once (if) we have sheaves
> >> > proven to work and move kfree_rcu() fully into SLUB, the barrier might
> >> > also look different and hopefully easier. So maybe it's not worth to
> >> > invest too much into that barrier and just go for the potentially
> >> > longer, but easier to implement?
> >> > 
> >> Right. I agree here. If the cache is not empty, OK, we just defer the
> >> work, even we can use a big 21 seconds delay, after that we just "warn"
> >> if it is still not empty and leave it as it is, i.e. emit a warning and
> >> we are done.
> >> 
> >> Destroying the cache is not something that must happen right away. 
> > 
> > OK, I have to ask...
> > 
> > Suppose that the cache is created and destroyed by a module and
> > init/cleanup time, respectively.  Suppose that this module is rmmod'ed
> > then very quickly insmod'ed.
> > 
> > Do we need to fail the insmod if the kmem_cache has not yet been fully
> > cleaned up?
> 
> We don't have any such link between kmem_cache and module to detect that, so
> we would have to start tracking that. Probably not worth the trouble.

Fair enough!

> >  If not, do we have two versions of the same kmem_cache in
> > /proc during the overlap time?
> 
> Hm could happen in /proc/slabinfo but without being harmful other than
> perhaps confusing someone. We could filter out the caches being destroyed
> trivially.

Or mark them in /proc/slabinfo?  Yet another column, yay!!!  Or script
breakage from flagging the name somehow, for example, trailing "/"
character.

> Sysfs and debugfs might be more problematic as I suppose directory names
> would clash. I'll have to check... might be even happening now when we do
> detect leaked objects and just leave the cache around... thanks for the
> question.

"It is a service that I provide."  ;-)

But yes, we might be living with it already and there might already
be ways people deal with it.

							Thanx, Paul

> >> > > Since you do it asynchronous can we just repeat
> >> > > and wait until it a cache is furry freed?
> >> > 
> >> > The problem is we want to detect the cases when it's not fully freed
> >> > because there was an actual read. So at some point we'd need to stop the
> >> > repeats because we know there can no longer be any kfree_rcu()'s in
> >> > flight since the kmem_cache_destroy() was called.
> >> > 
> >> Agree. As noted above, we can go with 21 seconds(as an example) interval
> >> and just perform destroy(without repeating).
> >> 
> >> --
> >> Uladzislau Rezki
> 

