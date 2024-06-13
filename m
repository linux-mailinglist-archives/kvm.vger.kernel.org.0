Return-Path: <kvm+bounces-19576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8030D907278
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 938171C225C7
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 12:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC87144D2D;
	Thu, 13 Jun 2024 12:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuhuVSpb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5B3384;
	Thu, 13 Jun 2024 12:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282829; cv=none; b=IihzUwtXiOSg1hP7QYftH9EPDx/Olaa9+UAk9t5ycJcDh4CsGhZcDlrrvLN77F6B9KLlK6QmkOtAMLM8iwv9Yae0xw4wzYfRFAymdDn8d3q1+WgOqPQWr0ZpfGfXtZkehbRQKTywJZabIt2ZbegO/DvFbsKUBFRn8QxoRyQ/AWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282829; c=relaxed/simple;
	bh=Vzv0i5AjIrgsjm2KrIFQ5g0zkd8OKZuFz8J9hczkvVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJEy1X1N+tG/siJlZYDY8kbyPZi3I12R+s4wWzwDGXxEglP8eKHcEfksnj/ewPw2BdfCjXsaAlbPufZSpJyIBDT93dhWRuL5eGwFYXzhfI2eJbCeMDTQo0aXXV5vsKQODmR2WEVtqjuvZHwzplX2w0krkjYknU+WbpKZQtjqdXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuhuVSpb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E35C4AF1D;
	Thu, 13 Jun 2024 12:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718282829;
	bh=Vzv0i5AjIrgsjm2KrIFQ5g0zkd8OKZuFz8J9hczkvVU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=BuhuVSpbcTx/eXjea/TKS5UUyJyZDKgBNGNojdYjNvJlbKf8f0REK48qN1G00QK7t
	 ZvvD3sCDrXWlChEjzvItORVcr37gzulSj0d0CfSPbA83U6r5VftQqojy80MOvG23a1
	 hY4PfyCfuqcnSaALxQyZ/vHNn0szv9zgi06Lvy5Ymsf4b+QclQogfP1kyeQbjXsHNE
	 KeoVUHKhGcgsG1cxPpec1vzYgQIEkfZMDItRc5n3MrVKB0vQ1/D9qXOZfEF84mWmDk
	 L9JoHz+GitlIQlt2tEf+5mTalIBsiIhFOB/1V6xe9T/Fc0cNhX3rsh7C2TcMNBTHJf
	 6oTzHy6k9vjnw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id B3435CE3F3B; Thu, 13 Jun 2024 05:47:08 -0700 (PDT)
Date: Thu, 13 Jun 2024 05:47:08 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
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
Message-ID: <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmrfA1p2zSVIaYam@zx2c4.com>

On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > when the callback only performs kmem_cache_free. Use
> > > > kfree_rcu() directly.
> > > > 
> > > > The changes were done using the following Coccinelle semantic patch.
> > > > This semantic patch is designed to ignore cases where the callback
> > > > function is used in another way.
> > > 
> > > How does the discussion on:
> > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > reflect on this series? IIUC we should hold off..
> > 
> > We do need to hold off for the ones in kernel modules (such as 07/14)
> > where the kmem_cache is destroyed during module unload.
> > 
> > OK, I might as well go through them...
> > 
> > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > 	Needs to wait, see wg_allowedips_slab_uninit().
> 
> Also, notably, this patch needs additionally:
> 
> diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> index e4e1638fce1b..c95f6937c3f1 100644
> --- a/drivers/net/wireguard/allowedips.c
> +++ b/drivers/net/wireguard/allowedips.c
> @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> 
>  void wg_allowedips_slab_uninit(void)
>  {
> -	rcu_barrier();
>  	kmem_cache_destroy(node_cache);
>  }
> 
> Once kmem_cache_destroy has been fixed to be deferrable.
> 
> I assume the other patches are similar -- an rcu_barrier() can be
> removed. So some manual meddling of these might be in order.

Assuming that the deferrable kmem_cache_destroy() is the option chosen,
agreed.

							Thanx, Paul

