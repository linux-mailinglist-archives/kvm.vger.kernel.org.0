Return-Path: <kvm+bounces-19572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F82C906DC5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0050AB21EF8
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 12:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EE2149DE3;
	Thu, 13 Jun 2024 11:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MeI8MH8G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B7A1465A5;
	Thu, 13 Jun 2024 11:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279953; cv=none; b=eEym6XUlUHeUQRetdQhs0+47Dkdfu2OTsn15opGPDEGokTYX2GBZeCdngY2X+SvKdyopFI47HtfHEPBnGyGFt3z2xNMu1/qTfvERLK4nNiELDL55B5LO89rU95IDYtpRRsB1+QQxNWUD7YUaAW1BzXwoRKjoc5rueP5urWanqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279953; c=relaxed/simple;
	bh=0ciGaQw5y4u0nJS5KStWIT6J+uYIGGdbCRp7w2Mw+jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YchvrFWeIFsKcYdk0GjcYRko0HN+7Eacstq6pQecX1GLwEXVAvWZVQFnwrgu4p+yfUgU91pP0/8IWfllQKeW8B5E5pfOqa0CRICQOB+/YQ28Xvz2DkqNXc6jF110/wxOJyvEEskBploeA+/sL1HwsfZ+7y1fulsRpE/nZrTKmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=MeI8MH8G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEAAC4AF4D;
	Thu, 13 Jun 2024 11:59:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MeI8MH8G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718279946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2oQoeraeqQaQpCY62eMS55dJmmDU2cLnySqsO1DV0bg=;
	b=MeI8MH8G9GaVwTubn3zbemt8iMGjhWu2xlRT5g6xh1L4MS9g8vj3/b4L5Io4CIm+PbC/28
	K4kTBBhke2rM7bNZ2dv8VC/fK7/9r4oKXzXHf3Yt4ENzPLvg7XFBUp90WP45io3c2/cs6Q
	JMbCSdFZKlgC96+RmMCLxV7PaJ3gRO0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ebdb63be (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 13 Jun 2024 11:59:05 +0000 (UTC)
Date: Thu, 13 Jun 2024 13:58:59 +0200
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
Message-ID: <ZmrfA1p2zSVIaYam@zx2c4.com>
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

Also, notably, this patch needs additionally:

diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
index e4e1638fce1b..c95f6937c3f1 100644
--- a/drivers/net/wireguard/allowedips.c
+++ b/drivers/net/wireguard/allowedips.c
@@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)

 void wg_allowedips_slab_uninit(void)
 {
-	rcu_barrier();
 	kmem_cache_destroy(node_cache);
 }

Once kmem_cache_destroy has been fixed to be deferrable.

I assume the other patches are similar -- an rcu_barrier() can be
removed. So some manual meddling of these might be in order.

Jason

