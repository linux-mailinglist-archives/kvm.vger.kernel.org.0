Return-Path: <kvm+bounces-22162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AFF093B20A
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 15:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C322283ACD
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 13:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1EB4159598;
	Wed, 24 Jul 2024 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WAP2//Vl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D456E13E020;
	Wed, 24 Jul 2024 13:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721829216; cv=none; b=Rv0Kp+InsbzBKLBu2jjtRL8k1OcREHL4Ps0hGnqAqa8NN5Z2xdK1vWK/GbM09zJATconytTYWTr9uYL73vczPY5hh2XIGuLurfbXl9mTK1Yjhd4Nwf5YF+bSP2ndZNCn5sp1ZRe5Wc3xteO1r+V/dMDI7gxPhJAvHXN/WOiQyZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721829216; c=relaxed/simple;
	bh=07Vzl6re9ZHoHnUQaqXa2n0Sm3JNDNE/aQbliYyNUPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tSSzTIBDxdv0JLtBfh0RrFv+uy+NmG1dIcNFaej0eDwcxijtjKZINehLVWPm7sCdlSNsoSfv3hCj2pbUK1/QG83S9OeroYJ032d2MMwcqucsTlIq+EnuvPJ9v+IMC71o5ZXIxlDNbvlVTWO8y48uEycbC9LvRviM0O2ZagUqHrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WAP2//Vl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0F7C32781;
	Wed, 24 Jul 2024 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721829215;
	bh=07Vzl6re9ZHoHnUQaqXa2n0Sm3JNDNE/aQbliYyNUPE=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=WAP2//VlWUSM9jrjWrTnlUR5U9gfJcKWxfEehwSsgCifqJ1HhI5rmor2MgAYiE7Hj
	 k3H3D8gUK01HrebDYiJ8EV56b+RO+InO4F1HL2zNXYqpPk0VVAstDY9HBgwUy8+jTo
	 8Kp+cbZnfcsDTxUnkpS1wiQgO6T2KXSlCCZwyOB4EAFefvi0zRPKDPVqPNBGFqV5Kn
	 m54HgAjJfy8we9Y9tl7LY7L4gaHz6KkuEz0NmtF8JUJfXUWPMHmL6c8XZgfCklah1Y
	 U/SwoGTJa9N4jZ4SGcPsHczOthJTxHkGyBSbyg3+L/BrGVV8TCmbKAOKTgYYxrZSSF
	 Ywifo4pkBnatw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id A535FCE0A6E; Wed, 24 Jul 2024 06:53:34 -0700 (PDT)
Date: Wed, 24 Jul 2024 06:53:34 -0700
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
Message-ID: <b3d9710a-805e-4e37-8295-b5ec1133d15c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>
 <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
 <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>
 <ZnVInAV8BXhgAjP_@pc636>
 <df0716ac-c995-498c-83ee-b8c25302f9ed@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df0716ac-c995-498c-83ee-b8c25302f9ed@suse.cz>

On Mon, Jul 15, 2024 at 10:39:38PM +0200, Vlastimil Babka wrote:
> On 6/21/24 11:32 AM, Uladzislau Rezki wrote:
> > On Wed, Jun 19, 2024 at 11:28:13AM +0200, Vlastimil Babka wrote:
> > One question. Maybe it is already late but it is better to ask rather than not.
> > 
> > What do you think if we have a small discussion about it on the LPC 2024 as a
> > topic? It might be it is already late or a schedule is set by now. Or we fix
> > it by a conference time.
> > 
> > Just a thought.
> 
> Sorry for the late reply. The MM MC turned out to be so packed I didn't even
> propose a slab topic. We could discuss in hallway track or a BOF, but
> hopefully if the current direction taken by my RFC brings no unexpected
> surprise, and the necessary RCU barrier side is also feasible, this will be
> settled by time of plumbers.

That would be even better!

							Thanx, Paul

