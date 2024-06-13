Return-Path: <kvm+bounces-19591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2153C90760A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 17:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D0F12825ED
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 15:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75804149C46;
	Thu, 13 Jun 2024 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsvcVPrx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6E953E31;
	Thu, 13 Jun 2024 15:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718291191; cv=none; b=hOQWu7RcR5tjDOI1BYxWSH0QeljgFZnr9VmLyIRQyyrkp2MA8JETZ8B8kfviur1iNq2zLZ70kumX8liDknPuJx72o4Sw7e9pP3eVVkT/2lSCMtEPdQJzlf7xxSm1bmgH/YVpWZlG7Sd2A1rn9XvhyEUmSJW8FpHA6oDMm7ZELzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718291191; c=relaxed/simple;
	bh=wgsmED+LXJqE3La/bOLyHDsAdYsz1Isrd2OZaovkeiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SefNXXEgiokPOZj1MwSoT5Um0V3uOYIxDEnp5na3pd1hlPU1l2UCe4z6TKY5d+Am6tK88ev9eGR5Qz7YxCivUDnPT/6nxKQjqN80qP2dVMXzmLb/8EkoR3+V9sS1VmDzjyTmH2cnOw3t/GAoSJrpD8CmR4cCMZw2xP8IxA6gO8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BsvcVPrx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE25BC2BBFC;
	Thu, 13 Jun 2024 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718291190;
	bh=wgsmED+LXJqE3La/bOLyHDsAdYsz1Isrd2OZaovkeiA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=BsvcVPrxieuyVR6+qllHztbJhLvGWba7+HmN+SIlEElKHi1Zd9/dzBPedwRMCli8S
	 FKpRyagelBFngmKn9sPg3P02A8uzaYcHLSm4ZCiJ23ukBHqE6QmQhU0xzrnx/01bBh
	 4tqDsCvxFzIiuHlyJwzZGNFrhx54EIpgDvaMQ8HYCqaDWvzmMTunrp+TKCyPqaNDLa
	 /GbEdfXKY54P/m5SCsGf4TMotsXHaXBrs3REfjdxZBx/wm+QlwVSdjc5u2RbCBB4ta
	 WRq65TWMuPnHdq4aaao+h9OYo4/mhtegaJrK22Z05AWdgoiz0bQKHsta3wVVF+fskZ
	 CT+12OJKFo+6g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 7A44DCE09E0; Thu, 13 Jun 2024 08:06:30 -0700 (PDT)
Date: Thu, 13 Jun 2024 08:06:30 -0700
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
Message-ID: <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zmru7hhz8kPDPsyz@pc636>

On Thu, Jun 13, 2024 at 03:06:54PM +0200, Uladzislau Rezki wrote:
> On Thu, Jun 13, 2024 at 05:47:08AM -0700, Paul E. McKenney wrote:
> > On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> > > On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > > > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > > > when the callback only performs kmem_cache_free. Use
> > > > > > kfree_rcu() directly.
> > > > > > 
> > > > > > The changes were done using the following Coccinelle semantic patch.
> > > > > > This semantic patch is designed to ignore cases where the callback
> > > > > > function is used in another way.
> > > > > 
> > > > > How does the discussion on:
> > > > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > > > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > > > reflect on this series? IIUC we should hold off..
> > > > 
> > > > We do need to hold off for the ones in kernel modules (such as 07/14)
> > > > where the kmem_cache is destroyed during module unload.
> > > > 
> > > > OK, I might as well go through them...
> > > > 
> > > > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > > > 	Needs to wait, see wg_allowedips_slab_uninit().
> > > 
> > > Also, notably, this patch needs additionally:
> > > 
> > > diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> > > index e4e1638fce1b..c95f6937c3f1 100644
> > > --- a/drivers/net/wireguard/allowedips.c
> > > +++ b/drivers/net/wireguard/allowedips.c
> > > @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> > > 
> > >  void wg_allowedips_slab_uninit(void)
> > >  {
> > > -	rcu_barrier();
> > >  	kmem_cache_destroy(node_cache);
> > >  }
> > > 
> > > Once kmem_cache_destroy has been fixed to be deferrable.
> > > 
> > > I assume the other patches are similar -- an rcu_barrier() can be
> > > removed. So some manual meddling of these might be in order.
> > 
> > Assuming that the deferrable kmem_cache_destroy() is the option chosen,
> > agreed.
> >
> <snip>
> void kmem_cache_destroy(struct kmem_cache *s)
> {
> 	int err = -EBUSY;
> 	bool rcu_set;
> 
> 	if (unlikely(!s) || !kasan_check_byte(s))
> 		return;
> 
> 	cpus_read_lock();
> 	mutex_lock(&slab_mutex);
> 
> 	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
> 
> 	s->refcount--;
> 	if (s->refcount)
> 		goto out_unlock;
> 
> 	err = shutdown_cache(s);
> 	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
> 	     __func__, s->name, (void *)_RET_IP_);
> ...
> 	cpus_read_unlock();
> 	if (!err && !rcu_set)
> 		kmem_cache_release(s);
> }
> <snip>
> 
> so we have SLAB_TYPESAFE_BY_RCU flag that defers freeing slab-pages
> and a cache by a grace period. Similar flag can be added, like
> SLAB_DESTROY_ONCE_FULLY_FREED, in this case a worker rearm itself
> if there are still objects which should be freed.
> 
> Any thoughts here?

Wouldn't we also need some additional code to later check for all objects
being freed to the slab, whether or not that code is  initiated from
kmem_cache_destroy()?

Either way, I am adding the SLAB_DESTROY_ONCE_FULLY_FREED possibility,
thank you! [1]

							Thanx, Paul

[1] https://docs.google.com/document/d/1v0rcZLvvjVGejT3523W0rDy_sLFu2LWc_NR3fQItZaA/edit?usp=sharing

