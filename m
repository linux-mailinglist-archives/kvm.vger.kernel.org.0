Return-Path: <kvm+bounces-19578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E684907323
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 15:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB9DC1F227B7
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 13:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB0BE1448DD;
	Thu, 13 Jun 2024 13:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lHpKLv4x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BC613D524;
	Thu, 13 Jun 2024 13:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284023; cv=none; b=Bl7QObNjP8niiKvmzHmdJBehCOVq0AOydaZ4zVgL4TClo3wtv7irghSlhya2ptebmR+J0LuJPmRYrh0t0tRGU+yvG2T938FW2IT74pMJPYhvBSQT65iuC6lxBI2tpTtvrhbyWTVSBvYZgp197niPngLBc0y6u1uoPmrVgPaA3JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284023; c=relaxed/simple;
	bh=xu1792XvTnU3jDP3FYbYyhez1VlS5TvvwKQ4Hm46MoY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMl6W2nbddR8smhTMtvq+NX2WBQ6+9UlYFkbq0cjlqi4H0E1TDiEb29Z9kMH5ySAW6siXGdzD1Rc7gynLibbVYQNLIo/8Lqf54J+tQwR8gGClC7LOpOyFbVosThruIh9DYPFByW0m8nE/B4UTPudc9w7egnYPldBNTvkH1K86+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lHpKLv4x; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ebd95f136bso10801621fa.0;
        Thu, 13 Jun 2024 06:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718284018; x=1718888818; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H4qMOlVAmB1+8562nApjJnNhlZQHZLqU1OXBwVXRF78=;
        b=lHpKLv4xuroqczJt/Ywx8NPgMxPogcx8+78+YIa89Ws8ZSLTpvqmGLUKFxVOQlfbZ2
         p3z4te5c2HO9g8+O3suERoCg3RYPQchSX4iaJKU9fTNvKa/phzJDhr/z+7O4He/OFnYe
         z+vy7B7UjBYhkRKHHAgrEPhH4074IEBeknApcjudzORfl08aww/jACSaVNTHc49iqOiP
         drFuPeWeAkgd4GIMCvMuXfuaJaLYPxgxDLEfl+zbBD5dr6xQh9GDMZGsOOW0TDX7hqdq
         Wmyds3YQtfZYaUZYYr9qcQMkWfHkD3bTytLzUklplf9Y3kOro87R3TAWy2r1NWhBbd5E
         2oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718284018; x=1718888818;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4qMOlVAmB1+8562nApjJnNhlZQHZLqU1OXBwVXRF78=;
        b=GSH+vuq+atblt2ONCh+TkgHMtZj6fOeBynKrQoCsTlIJASZ6Wj8CgpRYRpv9wPBe3y
         Rc00TTMV9AlDxmeiSr8HjG2BQTE2dw8zqVNaIgjCmLP5u0teTCPGsGClfXOjWWOF6RM+
         +/Q4HBoS6kytkJWCK+z3vxAp0OJWKQ5O/qp46b9takYihnLKO6HficNw0CJaABaf7bQl
         Pdw0940qcxRcHwCXr7KlVjmi6anSBwnoh8dwEYl0Ggi+3mMaShds13A4iEzt+AGbBT+P
         E9qtJLwB3XcJKJCNjWEoLFmXhebCh4tNbeqkO83AJ9VD3kd86x9w5Ei4KKasIHEUKt8b
         FklA==
X-Forwarded-Encrypted: i=1; AJvYcCXP46oBl9LWEeWZOi/nFO9LpfvD0XoXbjOze/y6JDCJBg8tWdMdYajFUlftwyFss9puNTTuHwlKWEIIvIB2jFDl6S48mcaLkYGvh3GMmxC3Nt7i+fd7S0YTjq14gSIWCGOIz0tm6QmrFpxoSLz8uRKbO8OTaPBJykm7iugHg1JzlEzIfwKDGF/EhovOdHI061peiiqbOINYoAEeU8K1Oe31BYZvY0y1xg+p1lCaTCormFL9CGyW9JeCT1+otoXW5Kd6RyhZTAoY612Xsx5F/mExtE0TYRhCV+ArQ8PWpgtBVcGCf0U6qpHyLh1EPdyPWuDnOHi1kTMjytStGOpgxFoZwZnvmOqDI51dN1oLq7M9bcwwBLl1hzW9WwMflZBwbFPR+WwOkcenlUHpYB+la126LQmDHWl6VPD6WGL7woF4mnRQphN7tnjdYSRfwg==
X-Gm-Message-State: AOJu0YweF5XV8H+UF6myYCXms8mjJEFBK244riqhJzn46zyVY064vIwI
	b8ZopXLnuMlBjdjlq08IeFphupqb91cIJ/K5Rd/IpLx94tfX950p
X-Google-Smtp-Source: AGHT+IFNjIqLDbiiJvyVQ+CTYUUPuuKLx47d3/3uk6kw1RXtVGPymnVcCEA7pTqKhgYonTHLU10trQ==
X-Received: by 2002:a2e:878f:0:b0:2eb:ecba:444a with SMTP id 38308e7fff4ca-2ebfc9fac80mr27236611fa.23.1718284018170;
        Thu, 13 Jun 2024 06:06:58 -0700 (PDT)
Received: from pc636 (host-90-233-218-141.mobileonline.telia.com. [90.233.218.141])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec05c05f56sm2099851fa.42.2024.06.13.06.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 06:06:57 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 13 Jun 2024 15:06:54 +0200
To: "Paul E. McKenney" <paulmck@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <Zmru7hhz8kPDPsyz@pc636>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>

On Thu, Jun 13, 2024 at 05:47:08AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> > On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > > when the callback only performs kmem_cache_free. Use
> > > > > kfree_rcu() directly.
> > > > > 
> > > > > The changes were done using the following Coccinelle semantic patch.
> > > > > This semantic patch is designed to ignore cases where the callback
> > > > > function is used in another way.
> > > > 
> > > > How does the discussion on:
> > > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > > reflect on this series? IIUC we should hold off..
> > > 
> > > We do need to hold off for the ones in kernel modules (such as 07/14)
> > > where the kmem_cache is destroyed during module unload.
> > > 
> > > OK, I might as well go through them...
> > > 
> > > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > > 	Needs to wait, see wg_allowedips_slab_uninit().
> > 
> > Also, notably, this patch needs additionally:
> > 
> > diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> > index e4e1638fce1b..c95f6937c3f1 100644
> > --- a/drivers/net/wireguard/allowedips.c
> > +++ b/drivers/net/wireguard/allowedips.c
> > @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> > 
> >  void wg_allowedips_slab_uninit(void)
> >  {
> > -	rcu_barrier();
> >  	kmem_cache_destroy(node_cache);
> >  }
> > 
> > Once kmem_cache_destroy has been fixed to be deferrable.
> > 
> > I assume the other patches are similar -- an rcu_barrier() can be
> > removed. So some manual meddling of these might be in order.
> 
> Assuming that the deferrable kmem_cache_destroy() is the option chosen,
> agreed.
>
<snip>
void kmem_cache_destroy(struct kmem_cache *s)
{
	int err = -EBUSY;
	bool rcu_set;

	if (unlikely(!s) || !kasan_check_byte(s))
		return;

	cpus_read_lock();
	mutex_lock(&slab_mutex);

	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;

	s->refcount--;
	if (s->refcount)
		goto out_unlock;

	err = shutdown_cache(s);
	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
	     __func__, s->name, (void *)_RET_IP_);
...
	cpus_read_unlock();
	if (!err && !rcu_set)
		kmem_cache_release(s);
}
<snip>

so we have SLAB_TYPESAFE_BY_RCU flag that defers freeing slab-pages
and a cache by a grace period. Similar flag can be added, like
SLAB_DESTROY_ONCE_FULLY_FREED, in this case a worker rearm itself
if there are still objects which should be freed.

Any thoughts here?

--
Uladzislau Rezki

