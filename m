Return-Path: <kvm+bounces-28705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70BFC99BCF6
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 02:31:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A35071C20D8A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 00:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB736101EE;
	Mon, 14 Oct 2024 00:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r9YqRKuw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0F82595;
	Mon, 14 Oct 2024 00:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728865891; cv=none; b=H17UGxqntZfMfCN1r+iBN8d17SkxMcQ2/GQObdppsiCKW5bXnE8Ho3ttxzg85UipCUdyJnCjr93Wai6+WUrjT7gwwm8vQnSpwjogLyX6fsnd+X5pnzysK5nMnoI9fHNY3R0EBt0goIHFG8KEcVokWcYO9Y8Bn+o0gZaNntsoxb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728865891; c=relaxed/simple;
	bh=XvIpO0hMtyh3Po24emY82DbVHrbP5ytugA80vx/L/C4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7dM2Mcd2Qlwain2vHbjwieEd40N0TVRIyRb2gUvDRMsr2Y9H0lmvnzak5s6cIx2l7wbPnd++vqqU45+Aa9q9Cq+rMMrdcBCk3z5cVf9TZTL0lPbyNAyG2EEJVg/D/pKFTgrH0qkU3xKQIJDMK95QQq3XlW5PV6+W2HPJBKdsKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r9YqRKuw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E461C4CEC5;
	Mon, 14 Oct 2024 00:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728865890;
	bh=XvIpO0hMtyh3Po24emY82DbVHrbP5ytugA80vx/L/C4=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=r9YqRKuw96RsL0f2maCvk78OVekNkjc1FC0l5peRj1xFsFUp+Wk6XpDbm8K/I8Dat
	 NtYj6Bt7tAjktwuIEYkK2pE6Nlz6suRz3IANFU3iMXWxI7B7SBdTbd2IFcE2RMqhNe
	 Gzl7d51zCrp3PEv9lrIW1gc/wLVjkJdAhHf/b8suVLDK9/64J6axNZwU42guB6nhKd
	 Bi+uaQAfSmkkbJhfVBfu3ahXZQy9cxY9cRnT2opvnrVBsZZFVpqu2kKlHbRWIQ75Yc
	 VF5aZimutRyJow22wfPFMyDIphrxGhIuf1iV5oDIrKq8jmbchhfe2c3wMu4V4yxCL9
	 zZuh3mAA+h63Q==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 043ABCE0D17; Sun, 13 Oct 2024 17:31:30 -0700 (PDT)
Date: Sun, 13 Oct 2024 17:31:30 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: linux-nfs@vger.kernel.org, kernel-janitors@vger.kernel.org,
	vbabka@suse.cz, Tom Talpey <tom@talpey.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Olga Kornievskaia <okorniev@redhat.com>, Neil Brown <neilb@suse.de>,
	linux-can@vger.kernel.org, bridge@lists.linux.dev,
	b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
	wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
	ecryptfs@vger.kernel.org, linux-block@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/17] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <47a98e77-8bbf-48d7-bb52-50e85a5336a0@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>

On Sun, Oct 13, 2024 at 10:16:47PM +0200, Julia Lawall wrote:
> Since SLOB was removed and since
> commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
> it is not necessary to use call_rcu when the callback only performs
> kmem_cache_free. Use kfree_rcu() directly.
> 
> The changes were done using the following Coccinelle semantic patch.
> This semantic patch is designed to ignore cases where the callback
> function is used in another way.

For the series:

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> // <smpl>
> #spatch --all-includes --include-headers
> 
> @r@
> expression e;
> local idexpression e2;
> identifier cb,f,g;
> position p;
> @@
> 
> (
> call_rcu(...,e2)
> |
> call_rcu(&e->f,cb@p)
> |
> call_rcu(&e->f.g,cb@p)
> )
> 
> @r1@
> type T,T1;
> identifier x,r.cb;
> @@
> 
>  cb(...) {
> (
>    kmem_cache_free(...);
> |
>    T x = ...;
>    kmem_cache_free(...,(T1)x);
> |
>    T x;
>    x = ...;
>    kmem_cache_free(...,(T1)x);
> )
>  }
> 
> @s depends on r1@
> position p != r.p;
> identifier r.cb;
> @@
> 
>  cb@p
> 
> @script:ocaml@
> cb << r.cb;
> p << s.p;
> @@
> 
> Printf.eprintf "Other use of %s at %s:%d\n" cb (List.hd p).file (List.hd p).line
> 
> @depends on r1 && !s@
> expression e;
> identifier r.cb,f,g;
> position r.p;
> @@
> 
> (
> - call_rcu(&e->f,cb@p)
> + kfree_rcu(e,f)
> |
> - call_rcu(&e->f.g,cb@p)
> + kfree_rcu(e,f.g)
> )
> 
> @r1a depends on !s@
> type T,T1;
> identifier x,r.cb;
> @@
> 
> - cb(...) {
> (
> -  kmem_cache_free(...);
> |
> -  T x = ...;
> -  kmem_cache_free(...,(T1)x);
> |
> -  T x;
> -  x = ...;
> -  kmem_cache_free(...,(T1)x);
> )
> - }
> 
> @r2 depends on !r1@
> identifier r.cb;
> @@
> 
> cb(...) {
>  ...
> }
> 
> @script:ocaml depends on !r1 && !r2@
> cb << r.cb;
> @@
> 
> Printf.eprintf "need definition for %s\n" cb
> // </smpl>
> 
> ---
> 
>  arch/powerpc/kvm/book3s_mmu_hpte.c  |    8 ------
>  block/blk-ioc.c                     |    9 ------
>  drivers/net/wireguard/allowedips.c  |    9 +-----
>  fs/ecryptfs/dentry.c                |    8 ------
>  fs/nfsd/nfs4state.c                 |    9 ------
>  kernel/time/posix-timers.c          |    9 ------
>  net/batman-adv/translation-table.c  |   47 ++----------------------------------
>  net/bridge/br_fdb.c                 |    9 ------
>  net/can/gw.c                        |   13 ++-------
>  net/ipv4/fib_trie.c                 |    8 ------
>  net/ipv4/inetpeer.c                 |    9 +-----
>  net/ipv6/ip6_fib.c                  |    9 ------
>  net/ipv6/xfrm6_tunnel.c             |    8 ------
>  net/kcm/kcmsock.c                   |   10 -------
>  net/netfilter/nf_conncount.c        |   10 -------
>  net/netfilter/nf_conntrack_expect.c |   10 -------
>  net/netfilter/xt_hashlimit.c        |    9 ------
>  17 files changed, 23 insertions(+), 171 deletions(-)

