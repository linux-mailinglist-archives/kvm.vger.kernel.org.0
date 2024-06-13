Return-Path: <kvm+bounces-19599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3F7907A2D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:46:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15E311C24B43
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 17:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2085D14A632;
	Thu, 13 Jun 2024 17:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEbQkQ+U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2B012E1C2;
	Thu, 13 Jun 2024 17:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718300760; cv=none; b=UB08yYcIZVentnpOaBWyh2bfZ7fsLqPRNNAkblzooQmiEOBEBuptW9xm7XjwTbjoS4zq0BYjCyBXhaZb8EQdiks2CzJPz8d1zwtd8PrqF2xE1ycfsW0zMkPBtDivwJg9qG7yO96FcAI7L9ha1Xz+y/hfFPtN84wFJMuWb6h81TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718300760; c=relaxed/simple;
	bh=8wZftwNb/k7uIh9XSIxuBqvpXG6ZPovdvQIUEmPnupc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqpxmmFxF5elukSMKgC07Z7W8QEQ4IrUV61i3jR3ixiy4ekA2mnNSQUPLwTjqDKldGJJOU25CAPpGhroCKob95nt4CWORTREI7zzpl2F4kdHGhyfAuveoA9qo5p9iYDU3gUfJB5HGRPDet8fs1tmuzLM37yeoHpBqMcBGscFZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEbQkQ+U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80014C2BBFC;
	Thu, 13 Jun 2024 17:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718300759;
	bh=8wZftwNb/k7uIh9XSIxuBqvpXG6ZPovdvQIUEmPnupc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=qEbQkQ+UG3cqDCkPWEZuFpKomUQZ2djBRGbA7EzDh2d7JKykflV9684BKaUVP0poZ
	 hIEOKqV4RjAZCZqUFtq/Fzd33aTZIQbfH/JE50LEMZ8hGgtLdw/EB23V+3xw2VOuIZ
	 qrAuLp7I8tYjJ+AZnEs09c6345tne5dWCGQ0B1jge1o9wIjFoU4Bu/a0z60D/IBXXt
	 FW0yk+gUMaKr4/T8D989Jx8E9iDtm5SJrjQvu3TKBPP59LiSiEIwvrD8NCIgFF8WDp
	 OV4LtOCrBe6gjqoKjnWhQG17bVbuiIJF363t8yR29EgEH+KPBsHqEqQ/VAvl20tLVU
	 6zqe3onttfsfg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 290BCCE0760; Thu, 13 Jun 2024 10:45:59 -0700 (PDT)
Date: Thu, 13 Jun 2024 10:45:59 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,
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
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zmsuswo8OPIhY5KJ@pc636>

On Thu, Jun 13, 2024 at 07:38:59PM +0200, Uladzislau Rezki wrote:
> On Thu, Jun 13, 2024 at 08:06:30AM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 13, 2024 at 03:06:54PM +0200, Uladzislau Rezki wrote:
> > > On Thu, Jun 13, 2024 at 05:47:08AM -0700, Paul E. McKenney wrote:
> > > > On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> > > > > On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > > > > > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > > > > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > > > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > > > > > when the callback only performs kmem_cache_free. Use
> > > > > > > > kfree_rcu() directly.
> > > > > > > > 
> > > > > > > > The changes were done using the following Coccinelle semantic patch.
> > > > > > > > This semantic patch is designed to ignore cases where the callback
> > > > > > > > function is used in another way.
> > > > > > > 
> > > > > > > How does the discussion on:
> > > > > > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > > > > > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > > > > > reflect on this series? IIUC we should hold off..
> > > > > > 
> > > > > > We do need to hold off for the ones in kernel modules (such as 07/14)
> > > > > > where the kmem_cache is destroyed during module unload.
> > > > > > 
> > > > > > OK, I might as well go through them...
> > > > > > 
> > > > > > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > > > > > 	Needs to wait, see wg_allowedips_slab_uninit().
> > > > > 
> > > > > Also, notably, this patch needs additionally:
> > > > > 
> > > > > diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> > > > > index e4e1638fce1b..c95f6937c3f1 100644
> > > > > --- a/drivers/net/wireguard/allowedips.c
> > > > > +++ b/drivers/net/wireguard/allowedips.c
> > > > > @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> > > > > 
> > > > >  void wg_allowedips_slab_uninit(void)
> > > > >  {
> > > > > -	rcu_barrier();
> > > > >  	kmem_cache_destroy(node_cache);
> > > > >  }
> > > > > 
> > > > > Once kmem_cache_destroy has been fixed to be deferrable.
> > > > > 
> > > > > I assume the other patches are similar -- an rcu_barrier() can be
> > > > > removed. So some manual meddling of these might be in order.
> > > > 
> > > > Assuming that the deferrable kmem_cache_destroy() is the option chosen,
> > > > agreed.
> > > >
> > > <snip>
> > > void kmem_cache_destroy(struct kmem_cache *s)
> > > {
> > > 	int err = -EBUSY;
> > > 	bool rcu_set;
> > > 
> > > 	if (unlikely(!s) || !kasan_check_byte(s))
> > > 		return;
> > > 
> > > 	cpus_read_lock();
> > > 	mutex_lock(&slab_mutex);
> > > 
> > > 	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
> > > 
> > > 	s->refcount--;
> > > 	if (s->refcount)
> > > 		goto out_unlock;
> > > 
> > > 	err = shutdown_cache(s);
> > > 	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
> > > 	     __func__, s->name, (void *)_RET_IP_);
> > > ...
> > > 	cpus_read_unlock();
> > > 	if (!err && !rcu_set)
> > > 		kmem_cache_release(s);
> > > }
> > > <snip>
> > > 
> > > so we have SLAB_TYPESAFE_BY_RCU flag that defers freeing slab-pages
> > > and a cache by a grace period. Similar flag can be added, like
> > > SLAB_DESTROY_ONCE_FULLY_FREED, in this case a worker rearm itself
> > > if there are still objects which should be freed.
> > > 
> > > Any thoughts here?
> > 
> > Wouldn't we also need some additional code to later check for all objects
> > being freed to the slab, whether or not that code is  initiated from
> > kmem_cache_destroy()?
> >
> Same away as SLAB_TYPESAFE_BY_RCU is handled from the kmem_cache_destroy() function.
> It checks that flag and if it is true and extra worker is scheduled to perform a
> deferred(instead of right away) destroy after rcu_barrier() finishes.

Like this?

	SLAB_DESTROY_ONCE_FULLY_FREED

	Instead of adding a new kmem_cache_destroy_rcu()
	or kmem_cache_destroy_wait() API member, instead add a
	SLAB_DESTROY_ONCE_FULLY_FREED flag that can be passed to the
	existing kmem_cache_destroy() function.  Use of this flag would
	suppress any warnings that would otherwise be issued if there
	was still slab memory yet to be freed, and it would also spawn
	workqueues (or timers or whatever) to do any needed cleanup work.

							Thanx, Paul

