Return-Path: <kvm+bounces-19805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B085290B763
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 19:05:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B04C1F2212C
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B0A16A92A;
	Mon, 17 Jun 2024 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EB2EkGMp"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335ED157A41;
	Mon, 17 Jun 2024 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718643886; cv=none; b=qkcsgBQyW0rexLKdZ78TNvWDCma4os597paEArZokglqfi33DymwRx6wfBOI9+7hvgisLvysTBdedq0DzoQFBldOg72vuP/kDK2qUgPXN7A4psdTAQ3+sPrP/fO+LlECCDMcKd9cw0an5bE60LcjeuRegk6Il52uFLHOMIzYM5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718643886; c=relaxed/simple;
	bh=aTo9WYNfxMDXZ7XIaowP99DTt7UkkCN5iUpRoKtIZ2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dsl3/YOPNyS6QHfnbNS/r18sXYQod2vZ2/kpzY4mOIvF7ZL4rdhZIT7/xPmHTz7oyckn9poapuPIsDChPy6C3A6WgDxGy6nLvgMV8anFIgBlBMJwawmm6kZFdO+J1xhAPTk23bBVWsv16bMCf5NqDPb+XZrqN3Rb5xz9G7JvvR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=EB2EkGMp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552BDC2BD10;
	Mon, 17 Jun 2024 17:04:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EB2EkGMp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718643881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ARICZd145/mpU/6/C4ChaIGt7llEKLdE0hg6cGdHWdo=;
	b=EB2EkGMp1iSSR/ZoBjTvLsRipbJ/3GyF1pF67bPbTJpZpZViXHWNSdGe3Wp0tZUf6UwcS3
	PPQY3tLkcp6pOnHOdpKJJIurtRSa2uJJxmso4eaZw7W4rybzLkYu5iwhPsWnqpDdk5ApWJ
	+Lmz+dK5Qx+05M2/zNiFzoH33PNzOFM=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 81f95149 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 17 Jun 2024 17:04:41 +0000 (UTC)
Date: Mon, 17 Jun 2024 19:04:34 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
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
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <ZnBsomxy_cCnnIBy@zx2c4.com>
References: <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636>
 <ZnBOkZClsvAUa_5X@zx2c4.com>
 <ZnBkvYdbAWILs7qx@pc636>
 <CAHmME9r4q8erE3E-Xn61ZkSOdDDrgx6jhTAywx3ca4=G0z=wAA@mail.gmail.com>
 <b415b8e3-24cc-4747-a30d-706e1dcfdff7@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b415b8e3-24cc-4747-a30d-706e1dcfdff7@suse.cz>

On Mon, Jun 17, 2024 at 06:38:52PM +0200, Vlastimil Babka wrote:
> On 6/17/24 6:33 PM, Jason A. Donenfeld wrote:
> > On Mon, Jun 17, 2024 at 6:30 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> >> Here if an "err" is less then "0" means there are still objects
> >> whereas "is_destroyed" is set to "true" which is not correlated
> >> with a comment:
> >>
> >> "Destruction happens when no objects"
> > 
> > The comment is just poorly written. But the logic of the code is right.
> > 
> >>
> >> >  out_unlock:
> >> >       mutex_unlock(&slab_mutex);
> >> >       cpus_read_unlock();
> >> > diff --git a/mm/slub.c b/mm/slub.c
> >> > index 1373ac365a46..7db8fe90a323 100644
> >> > --- a/mm/slub.c
> >> > +++ b/mm/slub.c
> >> > @@ -4510,6 +4510,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
> >> >               return;
> >> >       trace_kmem_cache_free(_RET_IP_, x, s);
> >> >       slab_free(s, virt_to_slab(x), x, _RET_IP_);
> >> > +     if (s->is_destroyed)
> >> > +             kmem_cache_destroy(s);
> >> >  }
> >> >  EXPORT_SYMBOL(kmem_cache_free);
> >> >
> >> > @@ -5342,9 +5344,6 @@ static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
> >> >               if (!slab->inuse) {
> >> >                       remove_partial(n, slab);
> >> >                       list_add(&slab->slab_list, &discard);
> >> > -             } else {
> >> > -                     list_slab_objects(s, slab,
> >> > -                       "Objects remaining in %s on __kmem_cache_shutdown()");
> >> >               }
> >> >       }
> >> >       spin_unlock_irq(&n->list_lock);
> >> >
> >> Anyway it looks like it was not welcome to do it in the kmem_cache_free()
> >> function due to performance reason.
> > 
> > "was not welcome" - Vlastimil mentioned *potential* performance
> > concerns before I posted this. I suspect he might have a different
> > view now, maybe?
> > 
> > Vlastimil, this is just checking a boolean (which could be
> > unlikely()'d), which should have pretty minimal overhead. Is that
> > alright with you?
> 
> Well I doubt we can just set and check it without any barriers? The
> completion of the last pending kfree_rcu() might race with
> kmem_cache_destroy() in a way that will leave the cache there forever, no?
> And once we add barriers it becomes a perf issue?

Hm, yea you might be right about barriers being required. But actually,
might this point toward a larger problem with no matter what approach,
polling or event, is chosen? If the current rule is that
kmem_cache_free() must never race with kmem_cache_destroy(), because
users have always made diligent use of call_rcu()/rcu_barrier() and
such, but now we're going to let those race with each other - either by
my thing above or by polling - so we're potentially going to get in trouble
and need some barriers anyway. 

I think?

Jason

