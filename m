Return-Path: <kvm+bounces-19598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5270B907A0E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B663FB242B5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 17:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68320145B2F;
	Thu, 13 Jun 2024 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxkFx2sc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626114A093;
	Thu, 13 Jun 2024 17:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718300347; cv=none; b=FvcBqipXnT4jVkCaQbuMt82mAVEta6SHLrHf2D25fq1tFY+kht90u8XLQFT+HOjE/jNRUa9ifdGf5dEqZjLgE4WZpXivzCWM1qEQXwwkyxqJtcHlgy1p6SS08yrEGsDPudHqXJsy0rKua91JAjyXuytR9RjzxBp+LjNakEDPxmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718300347; c=relaxed/simple;
	bh=fHH7Y/GCV9RKHWRoNr6bxBkzHP+WxpUKHOajIKJQc0A=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lf4iKElbc9keRklBn9lGQ6hAlZqgy4ISQbyGU9RmOGzUcLz45CEiXPbxF0DhcKbF6hfq8OgdHd+aARmCwgXrcu6IYnM+lkbWWFqlXqFjCjwlUw2rnsJVGbkH+DAcK5zQ9x++sdlEBFIhfrMEohE+eeN/I1ZujTuw6ycNC6ar7qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxkFx2sc; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52bbdb15dd5so1658349e87.3;
        Thu, 13 Jun 2024 10:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718300344; x=1718905144; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=956BT+Uq9SD+emo8+jCK8z5I39sZ4FeCbRyFqSAHxWc=;
        b=gxkFx2scR94MsRlvbmw5uI806EfMTrEnQpNzuFTxR9wGTPSOc+7D52WekaOxVJyu2P
         wgKjqGD2SC3evJk+4k5zPryD57uZDRfw/HP4S8qUN+91swZKgCy60ho3uBSe0XlDg///
         is7Tt4KaQcr9Z3fA8iaip8pYI8q32JWcFIKkXX6qut+iSB5q6dEVEGv78Yen3ATEOvrb
         A+NxrI0xrwPvO1fgYJlbxpUPW1fUHJ8BagXdFv5oN74f83KWTKee5Q+NmWmYuKo1ciZV
         rAPAmX6yQvSMDWS4J2SkiqXowLtcdDTvHrRnj3KgaD6YVbh4aWWdljhnv3GBXcDQ/cig
         Wtqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718300344; x=1718905144;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=956BT+Uq9SD+emo8+jCK8z5I39sZ4FeCbRyFqSAHxWc=;
        b=qyMzCidkHpEcC47LckCplOQOTZ3IlM87jg53yUgh6HM6EoV5aI25PrE7h4tZL4D5Zj
         2NXfgvqlC0q6s07e3NKEFtKNH7XcrWDLhuCKXt1lckQOSJhaofr3yRE0XI9BM8gdZmku
         lRcvvSxFpHzHQ0+sno4jHM2s3OMqzj9VV58UuD3683x3hj4KgriGtFkAPrOyplOjKBHX
         bliQ4xvo7UcE0F5mISvuLTLv2R8h4i5wvUlgtolo8Jj0wMKQWnq6C5PCLfH2XQzkkUqr
         r+JwuXYFV6ESFn808yhRjDpTFtCtMdQX5JH5J11RpA5zbWr39BGlG/kU6GTfXboG1iAH
         v8iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsay3bizCj3Do0cRqomwNingFhHf4dfl/G1I2mBShys24omAVVodi2I7UDLTQixI5vi2ONjA28IctmRD1Z/9t5qvC8peqTlua7nst0zcD0JQi8nuCRdSbROheUzaTJsEDbGTmn4DgPkKZbLh20b6c9n7FemaoUS350KWqLFc95Au4byqghV1c4Gzf+FRELc4D1+ymIwdEYIaO1vjLR4Yv25QtszYbRcTnE+Zicfcs6BiRuwx791dFhoCpeki65HZwBzenqWl4FWzJU5UsntK2zY4BfJI+DyKVM4DRfFl0Zo+7NcoJPsldjd4WF3A+VzFLfGBFkFGBFIpBdiD2w8B6JUBJDzvJEmK3mnwnseKK0tfLs/E1YYCOOww9LMyeRxnuUpDi/1i31CkC7s6cFuM08onDuRCwADKlvhr9M5yMQZUCTwvE777CPzdIGIw==
X-Gm-Message-State: AOJu0Yw4mvVvDUWiyeYHXkAdI5AZPvyQWVmfpJI8RthwN0PGekzTw8a9
	jYd4+USev2JiNN9x1Y9Zzgu6jDzUmYX6hWnA45Swk+Fx7oZkN2Va
X-Google-Smtp-Source: AGHT+IEqfg03O6T4CVRhNhuT1kToVJHsIj8GcfpqCCRbVlEQmwf5k9Sqz/b5zlxpaNyn2BuI8Okyaw==
X-Received: by 2002:a05:6512:517:b0:52b:796e:66a5 with SMTP id 2adb3069b0e04-52ca6e9954cmr243776e87.66.1718300343767;
        Thu, 13 Jun 2024 10:39:03 -0700 (PDT)
Received: from pc636 (host-90-233-218-141.mobileonline.telia.com. [90.233.218.141])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca288cd87sm299099e87.304.2024.06.13.10.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 10:39:03 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 13 Jun 2024 19:38:59 +0200
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>,
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
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <Zmsuswo8OPIhY5KJ@pc636>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>

On Thu, Jun 13, 2024 at 08:06:30AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 13, 2024 at 03:06:54PM +0200, Uladzislau Rezki wrote:
> > On Thu, Jun 13, 2024 at 05:47:08AM -0700, Paul E. McKenney wrote:
> > > On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> > > > On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > > > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > > > > when the callback only performs kmem_cache_free. Use
> > > > > > > kfree_rcu() directly.
> > > > > > > 
> > > > > > > The changes were done using the following Coccinelle semantic patch.
> > > > > > > This semantic patch is designed to ignore cases where the callback
> > > > > > > function is used in another way.
> > > > > > 
> > > > > > How does the discussion on:
> > > > > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > > > > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > > > > reflect on this series? IIUC we should hold off..
> > > > > 
> > > > > We do need to hold off for the ones in kernel modules (such as 07/14)
> > > > > where the kmem_cache is destroyed during module unload.
> > > > > 
> > > > > OK, I might as well go through them...
> > > > > 
> > > > > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > > > > 	Needs to wait, see wg_allowedips_slab_uninit().
> > > > 
> > > > Also, notably, this patch needs additionally:
> > > > 
> > > > diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> > > > index e4e1638fce1b..c95f6937c3f1 100644
> > > > --- a/drivers/net/wireguard/allowedips.c
> > > > +++ b/drivers/net/wireguard/allowedips.c
> > > > @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> > > > 
> > > >  void wg_allowedips_slab_uninit(void)
> > > >  {
> > > > -	rcu_barrier();
> > > >  	kmem_cache_destroy(node_cache);
> > > >  }
> > > > 
> > > > Once kmem_cache_destroy has been fixed to be deferrable.
> > > > 
> > > > I assume the other patches are similar -- an rcu_barrier() can be
> > > > removed. So some manual meddling of these might be in order.
> > > 
> > > Assuming that the deferrable kmem_cache_destroy() is the option chosen,
> > > agreed.
> > >
> > <snip>
> > void kmem_cache_destroy(struct kmem_cache *s)
> > {
> > 	int err = -EBUSY;
> > 	bool rcu_set;
> > 
> > 	if (unlikely(!s) || !kasan_check_byte(s))
> > 		return;
> > 
> > 	cpus_read_lock();
> > 	mutex_lock(&slab_mutex);
> > 
> > 	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
> > 
> > 	s->refcount--;
> > 	if (s->refcount)
> > 		goto out_unlock;
> > 
> > 	err = shutdown_cache(s);
> > 	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
> > 	     __func__, s->name, (void *)_RET_IP_);
> > ...
> > 	cpus_read_unlock();
> > 	if (!err && !rcu_set)
> > 		kmem_cache_release(s);
> > }
> > <snip>
> > 
> > so we have SLAB_TYPESAFE_BY_RCU flag that defers freeing slab-pages
> > and a cache by a grace period. Similar flag can be added, like
> > SLAB_DESTROY_ONCE_FULLY_FREED, in this case a worker rearm itself
> > if there are still objects which should be freed.
> > 
> > Any thoughts here?
> 
> Wouldn't we also need some additional code to later check for all objects
> being freed to the slab, whether or not that code is  initiated from
> kmem_cache_destroy()?
>
Same away as SLAB_TYPESAFE_BY_RCU is handled from the kmem_cache_destroy() function.
It checks that flag and if it is true and extra worker is scheduled to perform a
deferred(instead of right away) destroy after rcu_barrier() finishes.

--
Uladzislau Rezki

