Return-Path: <kvm+bounces-19711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 336BA9092FC
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 21:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 466B51C22AC5
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 19:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB581AB527;
	Fri, 14 Jun 2024 19:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Piy7/8cY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC8D26AD7;
	Fri, 14 Jun 2024 19:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718393638; cv=none; b=dl+pCGeNQ2hQSLtgfDQar0YVr9tBn9Xoz2YTqbNxPUcjA5EyTrRwu28myy0oAxeTQPeEPS22PYLNrJfmvyLvdkP9gO7iYohkokIA9Pc4bp+o5prIwXozRfeY3lEfzN2eIHPNb4JzWvQH3afgsMAzTOG61BJ7TsQuZkdpAhpevJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718393638; c=relaxed/simple;
	bh=un2DKs68DVerlXBeKlpV6w20TzStZ/MgihGnCdsi2EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5O4zg/6E5qHVKs3c8INeozn/yCj0lrM3OGaEMV7P0Y+0O6D3bR5gNgd0fArTmglhgLXkhnUt9aaXO5/h15zYzD7wXiR0UN589jbazD6q4dym9gA+Vto8AlS7sSREOCzwnnHCyWpZbIV1PVG7l0ghBlmbsBxDjKYnTtbJPzKCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=Piy7/8cY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8CBC2BD10;
	Fri, 14 Jun 2024 19:33:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Piy7/8cY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718393634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DXA9wvv5IhNhdgqqoog09hrS0W28PIbc3nCXFgq2mxA=;
	b=Piy7/8cYE5kX8QxCb1ovvf7Oew+mzdXJL4F6If9Frkz4X0RUzqFF12WjwrhUhRlUy+iIKO
	DoV+j//Avs/4vzAsOjkSD1yxY/bbFo9eXQkn/oEw9txGMiy9XDfptZ5hiqtMHXpzOrUrXv
	cPfOpW6hB2UusbVHO75CZUsDVUtb8kw=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6d22401f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 14 Jun 2024 19:33:52 +0000 (UTC)
Date: Fri, 14 Jun 2024 21:33:45 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jakub Kicinski <kuba@kernel.org>,
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
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <ZmybGZDbXkw7JTjc@zx2c4.com>
References: <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zmw5FTX752g0vtlD@pc638.lan>

On Fri, Jun 14, 2024 at 02:35:33PM +0200, Uladzislau Rezki wrote:
> +	/* Should a destroy process be deferred? */
> +	if (s->flags & SLAB_DEFER_DESTROY) {
> +		list_move_tail(&s->list, &slab_caches_defer_destroy);
> +		schedule_delayed_work(&slab_caches_defer_destroy_work, HZ);
> +		goto out_unlock;
> +	}

Wouldn't it be smoother to have the actual kmem_cache_free() function
check to see if it's been marked for destruction and the refcount is
zero, rather than polling every one second? I mentioned this approach
in: https://lore.kernel.org/all/Zmo9-YGraiCj5-MI@zx2c4.com/ -

    I wonder if the right fix to this would be adding a `should_destroy`
    boolean to kmem_cache, which kmem_cache_destroy() sets to true. And
    then right after it checks `if (number_of_allocations == 0)
    actually_destroy()`, and likewise on each kmem_cache_free(), it
    could check `if (should_destroy && number_of_allocations == 0)
    actually_destroy()`. 

Jason

