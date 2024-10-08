Return-Path: <kvm+bounces-28155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F80995810
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 22:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07F421C20FC5
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2024 20:02:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5531D215026;
	Tue,  8 Oct 2024 20:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rN+E6v8u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F64238DD6;
	Tue,  8 Oct 2024 20:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728417746; cv=none; b=XnZ8GUmHQfB9wZhIN03KB7n7quy50H1Zd6twTmkUVMEu0ZT61Si5ZosCKqSW6//FJaU0brsRGvp+Ie1eG3XTHvftGI8WmiQGjwcQ6qS089FeSzIs9LT9Z0vz+FtPgsnOmlbnEW1yaKICXBJ64i8+J3oGcHtK9LAHaiOr7rYHwBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728417746; c=relaxed/simple;
	bh=mwnu9JDu0/QJ39vaeqgzPRoqn/uQOdBvX8cshH9rI2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q1cIcYBCVNp+r5958RzSWAtJhnMaiL5euuPCKQL5pMVioAfzAKJmSrJQfUO+/nVOgA0zSrCyJn09aeVYiT0aPRQcVCNb+KSJhjVGS4i/ECavHN/HZ+tMCE8xMs/wjbKDP0+2kwoHE0THApl+GH01VNEjRNUD+yG2eIQHyk3R5hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rN+E6v8u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF43C4CEC7;
	Tue,  8 Oct 2024 20:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728417745;
	bh=mwnu9JDu0/QJ39vaeqgzPRoqn/uQOdBvX8cshH9rI2M=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=rN+E6v8uF4ioUNKLIm91KJY7WajT816xax0xLKmMg82r/VdNKxRi2SuPyaYp5mvMp
	 3iEUmIoUxBqAzw3S+3xHFwxDjNUXJ1ms4vvTgy40qSQdbS1e5YsXgihqx/FlfH41CR
	 B5yXHM1xV2RQDH8pdQ+oYSffGAkWue72wxmp8FzHSdYe8F0+gQDgEtxtt3iMaFayap
	 QQgLNNDuCW4krxkjKxBJa5Jy1wKnBCXJ8lwHOvYQ4u/HYgc6yow8XGPEF6rU7+hsiS
	 Kkfhf7h/1UX7Uoiu1m8M2TLxAcmXcKHBMcjwCNjgHqioPraMS1As8rwzYnC/B4K15R
	 l1T7CHnBap8VA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 56F9BCE0DD1; Tue,  8 Oct 2024 13:02:25 -0700 (PDT)
Date: Tue, 8 Oct 2024 13:02:25 -0700
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
Message-ID: <acf7a96b-facb-469b-8079-edbec7770780@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>
 <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
 <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>
 <ZnVInAV8BXhgAjP_@pc636>
 <df0716ac-c995-498c-83ee-b8c25302f9ed@suse.cz>
 <b3d9710a-805e-4e37-8295-b5ec1133d15c@paulmck-laptop>
 <37807ec7-d521-4f01-bcfc-a32650d5de25@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37807ec7-d521-4f01-bcfc-a32650d5de25@suse.cz>

On Tue, Oct 08, 2024 at 06:41:12PM +0200, Vlastimil Babka wrote:
> On 7/24/24 15:53, Paul E. McKenney wrote:
> > On Mon, Jul 15, 2024 at 10:39:38PM +0200, Vlastimil Babka wrote:
> >> On 6/21/24 11:32 AM, Uladzislau Rezki wrote:
> >> > On Wed, Jun 19, 2024 at 11:28:13AM +0200, Vlastimil Babka wrote:
> >> > One question. Maybe it is already late but it is better to ask rather than not.
> >> > 
> >> > What do you think if we have a small discussion about it on the LPC 2024 as a
> >> > topic? It might be it is already late or a schedule is set by now. Or we fix
> >> > it by a conference time.
> >> > 
> >> > Just a thought.
> >> 
> >> Sorry for the late reply. The MM MC turned out to be so packed I didn't even
> >> propose a slab topic. We could discuss in hallway track or a BOF, but
> >> hopefully if the current direction taken by my RFC brings no unexpected
> >> surprise, and the necessary RCU barrier side is also feasible, this will be
> >> settled by time of plumbers.
> > 
> > That would be even better!
> > 
> > 							Thanx, Paul
> 
> Hah, so it was close but my hope was fulfilled in the end!

Nice, and thank you!!!

							Thanx, Paul

> commit bdf56c7580d267a123cc71ca0f2459c797b76fde
> Merge: efdfcd40ad5e ecc4d6af979b
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Sep 18 08:53:53 2024 +0200
> 
>     Merge tag 'slab-for-6.12' of
> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab
> 
> So that was at 8:53 Vienna time, and Plumbers started at 10:00...

