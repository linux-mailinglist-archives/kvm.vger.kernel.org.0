Return-Path: <kvm+bounces-19573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E44907004
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DAF328956D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 12:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6A3E145338;
	Thu, 13 Jun 2024 12:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hfCrzpDL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF725143C46;
	Thu, 13 Jun 2024 12:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281371; cv=none; b=PsM8I/KnMWmEPIOIERLRTKFoIf1LpGEc6gb7bb/n+7fH7QFbAffVl33vm+HJ85OSYFyMbMPmsPZjZYMtqlTvJljS8vbsaZG0QNMfsarY3CLyZrXSegE4rQXMfu/pOnNWzI0efTcjap0F3ASMvoauX9OLHRk4b8HyM8sTRUUuAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281371; c=relaxed/simple;
	bh=D26C2QGAWbo4I1JNfd9NGM4IGwcESsf+jS9RBEkH0RY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CY2Yf/1cbSaCVVOeeAxNbsOnX+tYIvAsLI9WFjekWGPkWUMJRoL3ndlyyjSUGu0y9Axo7h/waDAzS4qvbVyCwxOs5bS804ZvBbLlepwsBScxrw0nH89G4ue1zovf+WzyWCsaqo+q9l63mSEgfv2GUwoCJHCsDMgBI5hJvC9rTEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=hfCrzpDL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46929C32786;
	Thu, 13 Jun 2024 12:22:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hfCrzpDL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718281367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zijv6FPIt5hCtiuqrLBHgYuKfY1FOvo07a77dKOwqRA=;
	b=hfCrzpDLzmbNtF/sSyUwD/q4E2PbjKj9Fna9CH4V+V4vPbeuYBlZyE1WHIwBmUUgtmwa4e
	hkAMHeSicVC3lwYY/+b0ttk/c79NH8Y9GniehbCUO4Tz+G6YoeBDfmgGgVjY7xbdbEJGet
	Tjg4BjizrxilahviyNABzJbhoTcy7oY=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 199f6b88 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 13 Jun 2024 12:22:46 +0000 (UTC)
Date: Thu, 13 Jun 2024 14:22:41 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Julia Lawall <Julia.Lawall@inria.fr>,
	linux-block@vger.kernel.org, kernel-janitors@vger.kernel.org,
	bridge@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <Zmrkkel0Fo4_g75a@zx2c4.com>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com>
 <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>

On Wed, Jun 12, 2024 at 08:38:02PM -0700, Paul E. McKenney wrote:
> o	Make the current kmem_cache_destroy() asynchronously wait for
> 	all memory to be returned, then complete the destruction.
> 	(This gets rid of a valuable debugging technique because
> 	in normal use, it is a bug to attempt to destroy a kmem_cache
> 	that has objects still allocated.)
> 
> o	Make a kmem_cache_destroy_rcu() that asynchronously waits for
> 	all memory to be returned, then completes the destruction.
> 	(This raises the question of what to is it takes a "long time"
> 	for the objects to be freed.)

These seem like the best two options.

> o	Make a kmem_cache_free_barrier() that blocks until all
> 	objects in the specified kmem_cache have been freed.
> 
> o	Make a kmem_cache_destroy_wait() that waits for all memory to
> 	be returned, then does the destruction.  This is equivalent to:
> 
> 		kmem_cache_free_barrier(&mycache);
> 		kmem_cache_destroy(&mycache);

These also seem fine, but I'm less keen about blocking behavior.

Though, along the ideas of kmem_cache_destroy_rcu(), you might also
consider renaming this last one to kmem_cache_destroy_rcu_wait/barrier().
This way, it's RCU focused, and you can deal directly with the question
of, "how long is too long to block/to memleak?"

Specifically what I mean is that we can still claim a memory leak has
occurred if one batched kfree_rcu freeing grace period has elapsed since
the last call to kmem_cache_destroy_rcu_wait/barrier() or
kmem_cache_destroy_rcu(). In that case, you quit blocking, or you quit
asynchronously waiting, and then you splat about a memleak like we have
now.

But then, if that mechanism generally works, we don't really need a new
function and we can just go with the first option of making
kmem_cache_destroy() asynchronously wait. It'll wait, as you described,
but then we adjust the tail of every kfree_rcu batch freeing cycle to
check if there are _still_ any old outstanding kmem_cache_destroy()
requests. If so, then we can splat and keep the old debugging info we
currently have for finding memleaks.

Jason

