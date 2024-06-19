Return-Path: <kvm+bounces-19957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1799690E93D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 13:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44E2AB2359A
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E41A113D2A2;
	Wed, 19 Jun 2024 11:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OE0RMUMW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6B9135A6D;
	Wed, 19 Jun 2024 11:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718796140; cv=none; b=AVD1eRwH6w9/Mftajmm2bWZnRBskPsBT/kVX73naDP6k1+C+F7JILlXg7qa0abPH6suGIwZuBEoIcoinkbs2D7kSzAyLSyiMO0x66UmzwQVHKW8rQJKWrwSnGfLGay8qdCNz120UgoprXpBJ87064LpaAufav5APVqA61fY8rMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718796140; c=relaxed/simple;
	bh=75uxE1jIS7U/gZgImO3O5k1fhrGtDx8xK2bnlmud6ek=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e9hG8Mu+hUCukq50a22nZ4clt1cYa/BHXO9I51GTvI3Ga5K1cl/1dV22XOcIueUPCenTro/qOFo5Rmm4+9kYiVjPUZ/Y1K4BmP0o1ZpOE6bl1Ue6jFqF5kUdGGwM2DniBsGuIZ0DsQtOj2GkG58YiAbaKIMspM47IJ1zedLY7vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OE0RMUMW; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2ebdfe26217so60994721fa.2;
        Wed, 19 Jun 2024 04:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718796136; x=1719400936; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1We8+J1M8/iGwbEuKq9QLdgleuBIYYNVC3Jie6+7WKQ=;
        b=OE0RMUMWjmwTtHxwSC4/QTw7VP4UWIGmzyY3G60c8oHmQcSXvGGu4pU0Tj+aAk3yPj
         /TTAdEwqMfUAFnC8a+YXBOoaNNU2iL3V+G05cF1LQiduL9icX43CyQlHITKJb2cABUJm
         XArxR7y3DBv2aGz96LS77mX3BV3kyUvH3ykaQ5DsFurdylle+q3Mf4Q7Y9jXRnEfp0H5
         oUoK5sxPkUDQashXt1x3+NJavosmhcA4V0IqUiYX2g4+lqFUhQqFC1o6uf6rvYyQRA5u
         Y5X291yrUXOlSP2aish46TVfkHTTWuJsxujUSDNJ2fmAV+2Tqh1wFJDhltWJ3FxDWNU1
         OScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718796136; x=1719400936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1We8+J1M8/iGwbEuKq9QLdgleuBIYYNVC3Jie6+7WKQ=;
        b=iT+cNrdnGcRfgzPtRn2eV6CNRohnYCP/dS28lW59LfiyTS6oEZ8nj74ajSp+0fN7Pw
         EMLF7KcVmwDcpEMbWKeFWBOQAglIlDnAI7cW8XkEziOi5bF9yePwk2h5UaRcjsRJVup1
         nH6HUSnbJ0+HWBzDA6dbKdFCmxiYab4ufS6welvZmEKPtiG96JA7y4SnXGSUTfdmwm2m
         OcC5V3TMoXdhd9i8F/T8AM58whzxWEpvt41+KzPuCqRuN6H2c4aQUVWE4Cuu/JONj3gb
         KhYE/B/5HCMUzbaj3UJ+Tq4ZwMGNAbdKmrD3/8g1uRn6vFrKjtq3bOOmOxeY9eYXJlG4
         gvCw==
X-Forwarded-Encrypted: i=1; AJvYcCUYzhSmLisSheX6vi4V6i7ZLOIh3wGQK+SM3YPSf4aA/fTa/6daYzDhhCc+TiesUBeLqcnymwAeDhKm6GmkA6yfU0whN3kjzDPhKmxCXwz9BzTSJgDVQU1H6QN4CXFVV5uxFkiE9Uip+LEkACdj9G3iBYs8K7IF0OLaezYgP6DRvyM3UdFP2s+LdhK9KawS0R/TAQV9de0uWp7uvPn+fsAxzuCJsGdMjadhm6UBOMJUPAxWWFOkoQibEhnCi6lnLouAg4m2cpZTSU4TILCsctSYqjYh68PK7PsyYepU+HoxiB7DDhYKPmIz2voRyAdbTkktwAYzfITCz5GLiANk+dksq9MmTN9imEIzQ8aoVn7zv3nZkTGvgiYSxeEzswzUY9SyMSfVCRsXPJc4XAt9zMV72HZW7cVa1FPToxn3RPlCqXEVrSqwzVCtlgKwjg==
X-Gm-Message-State: AOJu0YxeHZ0KQJp3btvZ3dg98HpiQKlSe6dway4K/BCxRoQELEkVl9gy
	x2QLEgvuw4dEAIX3Z2csXlkXaxYOHSckCCb6kYTP+DWyqnPcPc50
X-Google-Smtp-Source: AGHT+IHY6I+1wjnfCL5bVO3aTBj0asX2DB6+TLCQy1IxnGK2EyJpAdTHcDYhDhl1lF4pI5isZiqATw==
X-Received: by 2002:a2e:7818:0:b0:2ec:3bc4:3e36 with SMTP id 38308e7fff4ca-2ec3ceb6a56mr15076241fa.14.1718796136224;
        Wed, 19 Jun 2024 04:22:16 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec05c78126sm19577951fa.81.2024.06.19.04.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 04:22:15 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Jun 2024 13:22:12 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
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
Message-ID: <ZnK_ZLlFM6MrdEah@pc636>
References: <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <ZnKqPqlPD3Rl04DZ@pc636>
 <c208e95d-9aa9-476f-9dee-0242a2d6a24f@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c208e95d-9aa9-476f-9dee-0242a2d6a24f@suse.cz>

On Wed, Jun 19, 2024 at 11:56:44AM +0200, Vlastimil Babka wrote:
> On 6/19/24 11:51 AM, Uladzislau Rezki wrote:
> > On Tue, Jun 18, 2024 at 09:48:49AM -0700, Paul E. McKenney wrote:
> >> On Tue, Jun 18, 2024 at 11:31:00AM +0200, Uladzislau Rezki wrote:
> >> > > On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
> >> > > >> +
> >> > > >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> >> > > >> +
> >> > > >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
> >> > > > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
> >> > > > wanted to avoid initially.
> >> > > 
> >> > > I wanted to avoid new API or flags for kfree_rcu() users and this would
> >> > > be achieved. The barrier is used internally so I don't consider that an
> >> > > API to avoid. How difficult is the implementation is another question,
> >> > > depending on how the current batching works. Once (if) we have sheaves
> >> > > proven to work and move kfree_rcu() fully into SLUB, the barrier might
> >> > > also look different and hopefully easier. So maybe it's not worth to
> >> > > invest too much into that barrier and just go for the potentially
> >> > > longer, but easier to implement?
> >> > > 
> >> > Right. I agree here. If the cache is not empty, OK, we just defer the
> >> > work, even we can use a big 21 seconds delay, after that we just "warn"
> >> > if it is still not empty and leave it as it is, i.e. emit a warning and
> >> > we are done.
> >> > 
> >> > Destroying the cache is not something that must happen right away. 
> >> 
> >> OK, I have to ask...
> >> 
> >> Suppose that the cache is created and destroyed by a module and
> >> init/cleanup time, respectively.  Suppose that this module is rmmod'ed
> >> then very quickly insmod'ed.
> >> 
> >> Do we need to fail the insmod if the kmem_cache has not yet been fully
> >> cleaned up?  If not, do we have two versions of the same kmem_cache in
> >> /proc during the overlap time?
> >> 
> > No fail :) If same cache is created several times, its s->refcount gets
> > increased, so, it does not create two entries in the "slabinfo". But i
> > agree that your point is good! We need to be carefully with removing and
> > simultaneous creating.
> 
> Note that this merging may be disabled or not happen due to various flags on
> the cache being incompatible with it. And I want to actually make sure it
> never happens for caches being already destroyed as that would lead to
> use-after-free (the workfn doesn't recheck the refcount in case a merge
> would happen during the grace period)
> 
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -150,9 +150,10 @@ int slab_unmergeable(struct kmem_cache *s)
>  #endif
> 
>         /*
> -        * We may have set a slab to be unmergeable during bootstrap.
> +        * We may have set a cache to be unmergeable during bootstrap.
> +        * 0 is for cache being destroyed asynchronously
>          */
> -       if (s->refcount < 0)
> +       if (s->refcount <= 0)
>                 return 1;
> 
>         return 0;
> 
OK, i see such flags, SLAB_NO_MERGE. Then i was wrong, it can create two
different slabs.

Thanks!

--
Uladzislau Rezki

