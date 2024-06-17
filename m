Return-Path: <kvm+bounces-19796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0273C90B5F5
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A85A1C22D13
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAEC11B966;
	Mon, 17 Jun 2024 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGMxqYUW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C514AAD;
	Mon, 17 Jun 2024 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718640750; cv=none; b=p2O8ZIn2XWHOgro7v7mTcv/QRte6RWyKnvtOm8UVXKYQbhwotFN0FSm696tR+X7Z3+DFS2uXaNbIHdzPml1+qeU0hAMtcIlC9MJltBhNE/GHXIlQIXwgK7u14+BiIUMHBX6RIHVsbRS3ArUb6czl1u0g3XbTnDpzt/xyaAYdngo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718640750; c=relaxed/simple;
	bh=+gtWCVLAIwVN9QYLGAITeupOhR87qFGefwq+Ci8vsv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lfnytt5vgpt/qTYkazNmCj5dc9kqUO22kjx11ElBlvjb7D/Bi/9Yid22KdLowk5y6/TuJyA0svj4P+aUy0x5+9ju2xuTmft0IhNKryGrZJweZzv9s4O+243AVw9B5jr72lOGffK966IFgK95AcmUbu+bEOzx8ooSMACSPLetZ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGMxqYUW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45957C3277B;
	Mon, 17 Jun 2024 16:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718640749;
	bh=+gtWCVLAIwVN9QYLGAITeupOhR87qFGefwq+Ci8vsv0=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=tGMxqYUWUZidJOkTYRC4FVvYBSBOWSgclx4qkkf2YhB76G0qNpmpl3h3ZG/PV3BOy
	 xlZXdbbOvZ6jW6KZZoE8jW1tSsMXb9BTJYiUY+4BFP1x4DLKJ88c59xgouIGwbGnfH
	 pzOLAUlBJvqVtt/nGes5ftIvMNsA0KW74j39YxI7CsKwDMIstY8QCTis+Vm1d09ssf
	 Brg/opMBq5bCqKivChkp0axZbqIBv6L47ipGD98z9wwNolXOn9myeZNXKM1TRS3DUb
	 bJJ9eMBF03SfToJMq6gfQl4IveoZO6GqEFk38XBSPXCG+yBO8oun6MjojXjI6saj96
	 ETfYabYghHfAQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C3424CE09F5; Mon, 17 Jun 2024 09:12:28 -0700 (PDT)
Date: Mon, 17 Jun 2024 09:12:28 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
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
Message-ID: <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com>
 <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>

On Mon, Jun 17, 2024 at 05:10:50PM +0200, Vlastimil Babka wrote:
> On 6/13/24 2:22 PM, Jason A. Donenfeld wrote:
> > On Wed, Jun 12, 2024 at 08:38:02PM -0700, Paul E. McKenney wrote:
> >> o	Make the current kmem_cache_destroy() asynchronously wait for
> >> 	all memory to be returned, then complete the destruction.
> >> 	(This gets rid of a valuable debugging technique because
> >> 	in normal use, it is a bug to attempt to destroy a kmem_cache
> >> 	that has objects still allocated.)
> 
> This seems like the best option to me. As Jason already said, the debugging
> technique is not affected significantly, if the warning just occurs
> asynchronously later. The module can be already unloaded at that point, as
> the leak is never checked programatically anyway to control further
> execution, it's just a splat in dmesg.

Works for me!

> > Specifically what I mean is that we can still claim a memory leak has
> > occurred if one batched kfree_rcu freeing grace period has elapsed since
> > the last call to kmem_cache_destroy_rcu_wait/barrier() or
> > kmem_cache_destroy_rcu(). In that case, you quit blocking, or you quit
> > asynchronously waiting, and then you splat about a memleak like we have
> > now.
> 
> Yes so we'd need the kmem_cache_free_barrier() for a slab kunit test (or the
> pessimistic variant waiting for the 21 seconds), and a polling variant of
> the same thing for the asynchronous destruction. Or we don't need a polling
> variant if it's ok to invoke such a barrier in a schedule_work() workfn.
> 
> We should not need any new kmem_cache flag nor kmem_cache_destroy() flag to
> burden the users of kfree_rcu() with. We have __kmem_cache_shutdown() that
> will try to flush everything immediately and if it doesn't succeed, we can
> assume kfree_rcu() might be in flight and try to wait for it asynchronously,
> without any flags.

That does sound like a very attractive approach.

> SLAB_TYPESAFE_BY_RCU is still handled specially because it has special
> semantics as well.
> 
> As for users of call_rcu() with arbitrary callbacks that might be functions
> from the module that is about to unload, these should not return from
> kmem_cache_destroy() with objects in flight. But those should be using
> rcu_barrier() before calling kmem_cache_destroy() already, and probably we
> should not try to handle this automagically? Maybe one potential change with
> the described approach is that today they would get the "cache not empty"
> warning immediately. But that wouldn't stop the module unload so later the
> callbacks would try to execute unmapped code anyway. With the new approach
> the asynchronous handling might delay the "cache not empty" warnings (or
> not, if kmem_cache_free_barrier() would finish before a rcu_barrier() would)
> so the unmapped code execution would come first. I don't think that would be
> a regression.

Agreed.

There are some use cases where a call_rcu() from a module without an
rcu_barrier() would be OK, for example, if the callback function was
defined in the core kernel and either: (1) The memory was from kmalloc()
or (2) The memory was from kmem_cache_alloc() and your suggested
changes above have been applied.  My current belief is that these are
too special of cases to be worth optimizing for, so that the rule should
remain "If you use call_rcu() in a module, you must call rcu_barrier()
within the module-unload code."

There have been discussions of having module-unload automatically invoke
rcu_barrier() if needed, but thus far we have not come up with a good
way to do this.  Challenges include things like static inline functions
from the core kernel invoking call_rcu(), in which case how to figure
out that the rcu_barrier() is not needed?

							Thanx, Paul

