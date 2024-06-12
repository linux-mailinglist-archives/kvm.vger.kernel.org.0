Return-Path: <kvm+bounces-19528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA447905F41
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA45B1C213DD
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:32:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5732812DDA7;
	Wed, 12 Jun 2024 23:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KuRtSsoX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3344022092;
	Wed, 12 Jun 2024 23:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718235128; cv=none; b=qNMAxb0SjeLRMjfxtNNj1iZIZjrMPrpLEcM4NkT5CNG8kBNZbIuOqWLZMpUNUuFDO10GkFu+j2a2C6ORg3Bp+kY8qE72n4WkUKM3aRLb5QzSRrTpUVUdgvxEPn427RRStRRzO3g/ZSmFuEb2Mchz3O39cFh1T4kX85sIhmHrKhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718235128; c=relaxed/simple;
	bh=vXTin2RE5LVdNvEj9vXYTNfzeL/DBSh7hlukwrm3jM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZWP7+Ef1VbQgeAFP9ulJCdFEyHoYp6q4EIpy4GZcbTEzkWkW4TbgPdIiF64VadtQFT8WnEsSJIQ+vdUKSoua9Xyc038ups93MZreOhMgQWD5ktikCEQDK+ox2Fr9LVMJMcy0p9iFX1nzwWK65SwhTWtnyZ4VmDkY5U7tcLQhzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=KuRtSsoX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79393C116B1;
	Wed, 12 Jun 2024 23:32:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="KuRtSsoX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718235123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qSAYPgRWQjgO94CvH8azZnzUEXB1002L22u56bSmdYM=;
	b=KuRtSsoXnhoWtj8ILW+HbvJl66iT9qTq9bSBLEsqlgbz+NueejOfai90fuwt9YC44f1xei
	hmuw3gt1QJJwUC0wpdH+Cc3bGwXliu0JUoPBoQ3fEIPyMnLEjglwvNilIrEYYHTX8Rku8B
	FH2QYFekE0pqYf5XHoYxT03jyvV2YLs=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7c292bc0 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Wed, 12 Jun 2024 23:32:03 +0000 (UTC)
Date: Thu, 13 Jun 2024 01:31:57 +0200
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
Message-ID: <Zmov7ZaL-54T9GiM@zx2c4.com>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>

On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > Since SLOB was removed, it is not necessary to use call_rcu
> > > when the callback only performs kmem_cache_free. Use
> > > kfree_rcu() directly.
> > > 
> > > The changes were done using the following Coccinelle semantic patch.
> > > This semantic patch is designed to ignore cases where the callback
> > > function is used in another way.
> > 
> > How does the discussion on:
> >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > reflect on this series? IIUC we should hold off..
> 
> We do need to hold off for the ones in kernel modules (such as 07/14)
> where the kmem_cache is destroyed during module unload.
> 
> OK, I might as well go through them...
> 
> [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> 	Needs to wait, see wg_allowedips_slab_uninit().

Right, this has exactly the same pattern as the batman-adv issue:

    void wg_allowedips_slab_uninit(void)
    {
            rcu_barrier();
            kmem_cache_destroy(node_cache);
    }

I'll hold off on sending that up until this matter is resolved.

Jason

