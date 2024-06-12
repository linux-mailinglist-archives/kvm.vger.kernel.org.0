Return-Path: <kvm+bounces-19521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37518905E9D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 00:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5C0F282A8D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 22:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF65612C819;
	Wed, 12 Jun 2024 22:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gP+b8oI2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B433C28385;
	Wed, 12 Jun 2024 22:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718231876; cv=none; b=tLCf+n2Rg62o9iaq+cKVkksQlZgQionrgULmfVF+NYoiRx7rRK9yDBhSkmYPj9acnre97xZ3AsdqXF/CYJp+iJdoOWBa6V9hDUgcGQgcEKmGOP3P+vfGPiTfYHgDt3iGh5ETHrswC9nVTdwttuggy4UNWx6mVyev1w1rl9KzNQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718231876; c=relaxed/simple;
	bh=oIsohZ+9uDXt1/szfbZNu9uZ6WH4ExPZbv0MeSABAuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VP11zNL1BHneE8u7HEMfsUdH+TTt58BXmUt97y5tCQSOCfZ+c7VbB8FRiO14JUZEt4dtU1L31WsStNJEZK8JyiIlGBhxjNfO/k28/iXk3q17jZ/hThZ4W31jnG/kIeDhC0V7w9PaloX3DW5SH85++t8gAu7XIcQivgAjyLov8LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gP+b8oI2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29078C116B1;
	Wed, 12 Jun 2024 22:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718231876;
	bh=oIsohZ+9uDXt1/szfbZNu9uZ6WH4ExPZbv0MeSABAuw=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=gP+b8oI23RaN2auavn9kdJs6IaFxGfpTRers71TYsRO81EBkAJS1TEEGF9PeM+7wx
	 JfjAorGHi0StC2tbEFL0bYR8ahwDNRtKXd/jEciawD5flFj7OxObqgTN+5TakbhJo9
	 MYUohzqZDX+JJBX7UwG3NUQCOUrxFlzf999/p9+XDhMFm6el3kPv2V63iZvZ5wUcv5
	 lQ5MrBltINH+5KZS/28WiZf4A+9rRX+iNrE09oOnoadekn/S8rZO8cAVOXqThDgSq8
	 GX1/wlDqJccdnaongSnTXVexdmEnFHpo7BzVqTOxZtg9rbL/bdSMDg4px5jWTRJf+V
	 LGtEBztw5cOtQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id BC95ACE0DEA; Wed, 12 Jun 2024 15:37:55 -0700 (PDT)
Date: Wed, 12 Jun 2024 15:37:55 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Julia Lawall <Julia.Lawall@inria.fr>, linux-block@vger.kernel.org,
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
Message-ID: <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612143305.451abf58@kernel.org>

On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > Since SLOB was removed, it is not necessary to use call_rcu
> > when the callback only performs kmem_cache_free. Use
> > kfree_rcu() directly.
> > 
> > The changes were done using the following Coccinelle semantic patch.
> > This semantic patch is designed to ignore cases where the callback
> > function is used in another way.
> 
> How does the discussion on:
>   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
>   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> reflect on this series? IIUC we should hold off..

We do need to hold off for the ones in kernel modules (such as 07/14)
where the kmem_cache is destroyed during module unload.

OK, I might as well go through them...

[PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	Needs to wait, see wg_allowedips_slab_uninit().

[PATCH 02/14] net: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	I don't immediately see the rcu_barrier(), but if there isn't
	one in there somewhere there probably should be.  Caution
	suggests a need to wait.

[PATCH 03/14] KVM: PPC: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	I don't immediately see the rcu_barrier(), but if there isn't
	one in there somewhere there probably should be.  Caution
	suggests a need to wait.

[PATCH 04/14] xfrm6_tunnel: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	Needs to wait, see xfrm6_tunnel_fini().

[PATCH 05/14] tracefs: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	This one is fine because the tracefs_inode_cachep kmem_cache
	is created at boot and never destroyed.

[PATCH 06/14] eCryptfs: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	I don't see a kmem_cache_destroy(), but then again, I also don't
	see the kmem_cache_create().  Unless someone can see what I am
	not seeing, let's wait.

[PATCH 07/14] net: bridge: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	Needs to wait, see br_fdb_fini() and br_deinit().

[PATCH 08/14] nfsd: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	I don't immediately see the rcu_barrier(), but if there isn't
	one in there somewhere there probably should be.  Caution
	suggests a need to wait.

[PATCH 09/14] block: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	I don't see a kmem_cache_destroy(), but then again, I also don't
	see the kmem_cache_create().  Unless someone can see what I am
	not seeing, let's wait.

[PATCH 10/14] can: gw: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	Needs to wait, see cgw_module_exit().

[PATCH 11/14] posix-timers: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	This one is fine because the posix_timers_cache kmem_cache is
	created at boot and never destroyed.

[PATCH 12/14] workqueue: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	This one is fine because the pwq_cache kmem_cache is created at
	boot and never destroyed.

[PATCH 13/14] kcm: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	I don't immediately see the rcu_barrier(), but if there isn't
	one in there somewhere there probably should be.  Caution
	suggests a need to wait.

[PATCH 14/14] netfilter: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
	Needs to wait, see hashlimit_mt_exit().

So 05/14, 11/14 and 12/14 are OK and can go ahead.  The rest need some
help.

Apologies for my having gotten overly enthusiastic about this change!

							Thanx, Paul

