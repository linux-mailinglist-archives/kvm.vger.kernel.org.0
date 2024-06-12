Return-Path: <kvm+bounces-19525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7C84905EEB
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 01:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 689401F22A52
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 23:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B1512D741;
	Wed, 12 Jun 2024 23:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajo5INMF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4617FA93B;
	Wed, 12 Jun 2024 23:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718233460; cv=none; b=O0Lp+3MhnHfS4pZvAgtd2RW+nnErWNDxRsLGjn0+UTJyHlOfMD65FT2fwnlQRhxfuIDx7prdW/Mv+/DodgX1QmWuDkAFwf1E4RIySenQIt+jqNJ4FPNpK0hKTYxXaj29JYYkf35QoP8MV7y/zaC0U9WoSRJWgA6NV44mf6kCJ0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718233460; c=relaxed/simple;
	bh=r4XcvG9Zjydzkd1AmkZAP2xPiok2w/W0tDdIGWsKLlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIeR1GSy8Hdu2O2r9D2Qkh/7U02FoBliN9vHB8NdfTCpXVcWbPD3xDXIcj59XWqHJ3YOZF4wG5M6au2U7Sz7tZsIwjre9rENy8ytC+PzmNln1iQoCO7UgfkQnseVFajLZIMluhZDy7b/hf622ykfjKlK0dngkWPeCA4AmuDS6As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajo5INMF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77F8C116B1;
	Wed, 12 Jun 2024 23:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718233459;
	bh=r4XcvG9Zjydzkd1AmkZAP2xPiok2w/W0tDdIGWsKLlE=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=ajo5INMFOIdUK8bTKJSOMTORqSBUVoTQMoTueScDlw6P7fEKN6L6KudGm8A/f9DV2
	 vac6aDF6zFHvqVhLnecDeXpTWqKjsgyaGlyYA4jn+sYSI8iPlTZA780P5FZZ2QLokd
	 TW2/efoa0ILfQDom5zYPZYttH0Zay//A6W3sEm47ScK9OEZvoBo/K4BvF3RIs/Le4w
	 ckCQrAXr3PM4+Pd067rXKPEm+1PxdYqAXhlaQm4dv5OxvWFhB3hvQnXvNmk7dvAr7L
	 /vanj8BKtPfnTrKefLFEyaIqF22+2EqJuMoTh97FTwq7ijzvQEu32ydoZbQcPLyXRl
	 tC6o2QGNB+peQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6C26FCE0DEA; Wed, 12 Jun 2024 16:04:19 -0700 (PDT)
Date: Wed, 12 Jun 2024 16:04:19 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
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
Message-ID: <fc3fb837-6f3c-4955-899d-1be002d17d70@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <7e58e73d-4173-49fe-8f05-38a3699bc2c1@kernel.dk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e58e73d-4173-49fe-8f05-38a3699bc2c1@kernel.dk>

On Wed, Jun 12, 2024 at 04:52:57PM -0600, Jens Axboe wrote:
> On 6/12/24 4:37 PM, Paul E. McKenney wrote:
> > [PATCH 09/14] block: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > 	I don't see a kmem_cache_destroy(), but then again, I also don't
> > 	see the kmem_cache_create().  Unless someone can see what I am
> > 	not seeing, let's wait.
> 
> It's in that same file:
> 
> blk_ioc_init()
> 
> the cache itself never goes away, as the ioc code is not unloadable. So
> I think the change there should be fine.

Thank you, Jens!  (And to Jakub for motivating me to go look.)

So to update the scorecared, 05/14, 09/14, 11/14 and 12/14 are OK and
can go ahead.

							Thanx, Paul

