Return-Path: <kvm+bounces-19582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DC4F9074CE
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 16:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2624B286F6B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 14:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE841474B8;
	Thu, 13 Jun 2024 14:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="L2OdeEdD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13BD1448D7;
	Thu, 13 Jun 2024 14:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718287925; cv=none; b=I86ts514cHJIs+9lfKtf0TiX1JFvuCbNzdhoMBmZpePOi72wKEesCNrYrcItQD0zAQUTDBC1oxFj8usSmCQKL9FJiL/4axH8zUfdaNhesFmQHxg2y8FAIV12pzirFCKwSLT3jMHbESn7cxIiW4rXyX00xROF58WTRgI7B7hTGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718287925; c=relaxed/simple;
	bh=BP0dHPKrPu1s5lsp6b2VSCZAPBtD2LfDAGF3nZJ/aYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKPeoTew5K7KAhRH1tBMnRVXgyjWyWh8QRVrrsIeQtRZ5JzmVeU8MNxFkM/EKHGRThz5ddhQJxJ46GWPMv5MapSB6JlctJ1QuHs6FQDDbXY9qGuqfNT7ayWoXVK4CjJc/tHJI5cF2HLNlkJvHMJ3crwShyiQ0r9TgzScHbuP/5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=L2OdeEdD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414C2C2BBFC;
	Thu, 13 Jun 2024 14:12:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="L2OdeEdD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718287920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fjz4ZCmXLkYKy1WwR1BKUB9SOdktn0OQ80YKkl5C07A=;
	b=L2OdeEdDbAYwCCQIo0q3Y5svBHl6HUoVii7Ipx/YqW9msnW5nLiQCcmVhvT3d2aYbXekmX
	6vGp/7RezmQfWwaVJxWqE0MwVUi9dk5ylrevWbLPzxAvc9yHIJFCNMr0XP5ij6Ppv2K3la
	u18h46ekO5C4iutUHhucdp/z23ziWUY=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9cf22b43 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 13 Jun 2024 14:11:58 +0000 (UTC)
Date: Thu, 13 Jun 2024 16:11:52 +0200
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
Message-ID: <Zmr-KPG9F6w-uzys@zx2c4.com>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com>
 <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e06440e2-9121-4c92-8bf2-945977987052@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e06440e2-9121-4c92-8bf2-945977987052@paulmck-laptop>

On Thu, Jun 13, 2024 at 05:46:11AM -0700, Paul E. McKenney wrote:
> How about a kmem_cache_destroy_rcu() that marks that specified cache
> for destruction, and then a kmem_cache_destroy_barrier() that waits?
> 
> I took the liberty of adding your name to the Google document [1] and
> adding this section:

Cool, though no need to make me yellow!

> > But then, if that mechanism generally works, we don't really need a new
> > function and we can just go with the first option of making
> > kmem_cache_destroy() asynchronously wait. It'll wait, as you described,
> > but then we adjust the tail of every kfree_rcu batch freeing cycle to
> > check if there are _still_ any old outstanding kmem_cache_destroy()
> > requests. If so, then we can splat and keep the old debugging info we
> > currently have for finding memleaks.
> 
> The mechanism can always be sabotaged by memory-leak bugs on the part
> of the user of the kmem_cache structure in play, right?
> 
> OK, but I see your point.  I added this to the existing
> "kmem_cache_destroy() Lingers for kfree_rcu()" section:
> 
> 	One way of preserving this debugging information is to splat if
> 	all of the slab’s memory has not been freed within a reasonable
> 	timeframe, perhaps the same 21 seconds that causes an RCU CPU
> 	stall warning.
> 
> Does that capture it?

Not quite what I was thinking. Your 21 seconds as a time-based thing I
guess could be fine. But I was mostly thinking:

1) kmem_cache_destroy() is called, but there are outstanding objects, so
   it defers.

2) Sometime later, a kfree_rcu_work batch freeing operation runs.

3) At the end of this batch freeing, the kernel notices that the
   kmem_cache whose destruction was previously deferred still has
   outstanding objects and has not been destroyed. It can conclude that
   there's thus been a memory leak.

In other words, instead of having to do this based on timers, you can
just have the batch freeing code ask, "did those pending kmem_cache
destructions get completed as a result of this last operation?"

