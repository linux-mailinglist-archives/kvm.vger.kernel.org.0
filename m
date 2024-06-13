Return-Path: <kvm+bounces-19590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DB69075C8
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:53:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D74C528286F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:53:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38D74146A99;
	Thu, 13 Jun 2024 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrpLVmcH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 303B32AEFE;
	Thu, 13 Jun 2024 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718290405; cv=none; b=Uy9msA1WPMgOApn0F5Z5S3B9soDMzSksHIkxo9uVLtvbrL2eIeS1b5HJY7pqUnq9nCHkPql8CcIw85VLSkgsdk+G5iSUTnbNfyUbNuVLy4DoydxMHq7IOth868Ww6YiCpXhzo5Nwg7wZafuKysyIaz3GQDlE+1jPiPTtslAfz6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718290405; c=relaxed/simple;
	bh=mv116xzS15vzP9cCgyxl+fMi+NNgkWtSKInvv0qYaOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWKbHay+d+itWUMNjwzGQvQy0TvFUdMP0qZFieFj+haKJh8vi+UviTLW67fZxUM4J9nP521YJdtiS8zzY7W81xBiSB72qGLEaZDDjAv5GA0iJXzKWTqG+lAn2n7s7d1nmX0MaFY/dqE8o1JVMPnnN8McBi3YKOmsQ1/H2Lox8rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrpLVmcH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC65C2BBFC;
	Thu, 13 Jun 2024 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718290404;
	bh=mv116xzS15vzP9cCgyxl+fMi+NNgkWtSKInvv0qYaOs=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=JrpLVmcHw+1vVdhz0hr4zlMOLXiUKHV49VrNryd9CK9X7dHErNGXoNPragvwwBCL6
	 SI+TwOrU0FMj0xU+2UtPCWQYN40GnerBvRUWBRAdFC6tFr6qz/km2rV7Chl1lUoJ9m
	 GkMihacipvdMQvdeIh6blgyiwV88h8rLs6V0Mnkla0nj4SuiDXJa+6y8vT55UDyDCg
	 17cVFuyxwkGgEp3TDCWzn0VlfqZ9umP1GCUkgnyIY+4CdHl8IwPus+2YunewlR6OZN
	 LcIgWzpaZOEsxjLA0loXbAyOPGV2Su96HAd1dBvN9u04caeK6yBd20pCVyC1ZFFfIw
	 qT4yEmqTp71dA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 556E8CE09E0; Thu, 13 Jun 2024 07:53:24 -0700 (PDT)
Date: Thu, 13 Jun 2024 07:53:24 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <62757652-8874-45d7-afec-734edeb03831@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com>
 <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <20240613071738.0655ff4f@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613071738.0655ff4f@kernel.org>

On Thu, Jun 13, 2024 at 07:17:38AM -0700, Jakub Kicinski wrote:
> On Wed, 12 Jun 2024 20:38:02 -0700 Paul E. McKenney wrote:
> > o	Make rcu_barrier() wait for kfree_rcu() objects.  (This is
> > 	surprisingly complex and will wait unnecessarily in some cases.
> > 	However, it does preserve current code.)
> 
> Not sure how much mental capacity for API variations we expect from
> people using caches, but I feel like this would score the highest
> on Rusty's API scale. I'd even venture an opinion that it's less
> confusing to require cache users to have their own (trivial) callbacks
> than add API variants we can't error check even at runtime...

Fair point, though please see Jason's emails.

And the underlying within-RCU mechanism is the same either way, so that
API decision can be deferred for some time.

But the within-slab mechanism does have the advantage of also possibly
simplifying reference-counting and the potential upcoming hazard pointers.
On the other hand, I currently have no idea what level of violence this
change would make to the slab subsystem.

							Thanx, Paul

