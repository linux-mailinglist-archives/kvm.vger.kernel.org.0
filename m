Return-Path: <kvm+bounces-19601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C02A5907A71
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:58:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43B861F21E6A
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 17:58:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F2312CDB1;
	Thu, 13 Jun 2024 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxdQi8MT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CD314A4F1;
	Thu, 13 Jun 2024 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718301509; cv=none; b=pF3BCtVXHigOXZOD7SV4FoymkUnWm/E0EqmxgB8dAfa1EzbrBxrZ+aEDVed3Iuezqph0HtWCKAHRwhA3bF0U4TycREXjW/Sy30zz8OCBLbn8cyPS60EzaFXOKUv0cDA799JM9sSMDhKwXxMpnpp7g4QRcHdm/zNVWPoyHx9JtwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718301509; c=relaxed/simple;
	bh=4uaYQwMmXudEVQoqF/PT02d+uOaxbMCHRjXCjlN4PKo=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8sTLnMfAb43ea8ht7mcZTcIufQYuJpJ2Dy8SVlK9cHtzhJBxUKYAf3PosXtLvi/QcZkDFK37OzCcr6XMe7Ra8uodxb2fRc1S5aZEXyuJbmKqI+ZxFjVWA77sC7rxPLk2RmOvMKJfR9jDq1xwYVYo0l2EQ/7f9y9nbhQlVUhjWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxdQi8MT; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2ebeefb9a6eso12823551fa.1;
        Thu, 13 Jun 2024 10:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718301502; x=1718906302; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LJdaR0AKwDxb6UxD8VgG/YvgQDgT5IhbR4y3pM8S3I4=;
        b=gxdQi8MT2mBK+cIvN1bzHVSFXdCDRIzqWXPKRlDoKYG1+9VHQw8ZMFIbD5sWwtN+C8
         6oGgS/eZILskXm6ekmgTJxrU+K2LA65A0QLhYO3+EpUaiUC9MNV+9mAp3wO4xZ28M2u2
         kffoGnj99GK1YIwlP+qf3+iR8V3A8MDXLvcJgMnsAwBtr3/rN5OSro2WihzHE+ayht8w
         fSeHYqtf2BzipRgXXO6sz5F2e7Hi044/IMLrVF0z4408IAazATOtuijJCiTe4xruRYvE
         Zexk0/OIKS7CfC16w81KChBvGIqP4rfl50bAODeBPbyVIyz7dBl5N/GjkJvpVoGzu/Gx
         qTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718301502; x=1718906302;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LJdaR0AKwDxb6UxD8VgG/YvgQDgT5IhbR4y3pM8S3I4=;
        b=oIXS8PsFlx6670eod1y/rzVluSH0xsVmjWMs5X7uMyhhj334DuAViuQT4WGpndghqg
         2dlCcY0lz0zLglHNyCm0e+Wrr5ghd0V5mAVgOQ4pi1Q3I5UIU60zYi1UZdvZ69O4/RnN
         iJSm53oTmSNZYqdzxKOKN6TMLRfVxL9f210M88bnt4V7Y6VhqjXJfaDQO9K+25jxD+oS
         TlIhbYDEhNmkLoSc77WKJhlbHex/X9qGruc5vMVTka6bza5pDsBHB05uhTRVRN4SvO1U
         1G6YHf4gaUX+O6UvH0l11HZ+ma6QTcQ5G+aDuQShQpCKbkC5a2mP2VsU/zeLNuwT3K51
         m6oQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnlJfSlU1ejMY5agGgfzoqVqExKDkL01j+SgOEWUrvHxlqqI0UpOQgp9k0Hb0s9x7qIYSlDcbOSLomy5K7c7aKeDQAJEFUgI/CEGEmCtE6xwvIkIz0hXTuZBpK7o4LxQaUVd0l5AakKqxxqbyLwXxlaKFMe+tvIUTEqfww712I3gdScCBkluI1E5scC5SRZRUFDBBMHAYPsPFy0jRi7N+eWJy33jP4OYQrCT7p60kvNzJfcFcTcpgMLlKcGJTpr8gtW9Li4qKnGF7sHSgqraxsddX3vdkiNHCuPrpbidzihnjoIagC/DEvfCuFW+sbEvjhf3zy8LzdaJ7nvRQNyt1jHa95GZHxbT+zQ7hWlUVJXYIFGA1JCuIoakCTMOyCyVTBKKvGjmYOfyU9oi03Z7rHpNtbcusT5LIHl5qoygM+nSRZveeS3ZTKfxhMJg==
X-Gm-Message-State: AOJu0Ywmmidv8wu28dUHWE8YtCXwxZaQP/eH+APwOwJvaGa2jzkWZfxu
	p+ySaSKYOkpHJhq3OsPPU/9L3d7LbSibNpBD+FQfROlb1MXwDVoH
X-Google-Smtp-Source: AGHT+IEhErzyVFwc5vrtNZW2dG954f3qNIGROFYFFTe33sAR7d1zhfiUTqk8uRw2thbyuYd+W2q+QA==
X-Received: by 2002:a2e:9dd4:0:b0:2ec:453:e46e with SMTP id 38308e7fff4ca-2ec0e5a0442mr3954341fa.42.1718301501351;
        Thu, 13 Jun 2024 10:58:21 -0700 (PDT)
Received: from pc636 (host-90-233-218-141.mobileonline.telia.com. [90.233.218.141])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec05c8a85esm3330101fa.117.2024.06.13.10.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 10:58:20 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 13 Jun 2024 19:58:17 +0200
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
Message-ID: <ZmszOd5idhf2Cb-v@pc636>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>

On Thu, Jun 13, 2024 at 10:45:59AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 13, 2024 at 07:38:59PM +0200, Uladzislau Rezki wrote:
> > On Thu, Jun 13, 2024 at 08:06:30AM -0700, Paul E. McKenney wrote:
> > > On Thu, Jun 13, 2024 at 03:06:54PM +0200, Uladzislau Rezki wrote:
> > > > On Thu, Jun 13, 2024 at 05:47:08AM -0700, Paul E. McKenney wrote:
> > > > > On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> > > > > > On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > > > > > > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > > > > > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > > > > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > > > > > > when the callback only performs kmem_cache_free. Use
> > > > > > > > > kfree_rcu() directly.
> > > > > > > > > 
> > > > > > > > > The changes were done using the following Coccinelle semantic patch.
> > > > > > > > > This semantic patch is designed to ignore cases where the callback
> > > > > > > > > function is used in another way.
> > > > > > > > 
> > > > > > > > How does the discussion on:
> > > > > > > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > > > > > > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > > > > > > reflect on this series? IIUC we should hold off..
> > > > > > > 
> > > > > > > We do need to hold off for the ones in kernel modules (such as 07/14)
> > > > > > > where the kmem_cache is destroyed during module unload.
> > > > > > > 
> > > > > > > OK, I might as well go through them...
> > > > > > > 
> > > > > > > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > > > > > > 	Needs to wait, see wg_allowedips_slab_uninit().
> > > > > > 
> > > > > > Also, notably, this patch needs additionally:
> > > > > > 
> > > > > > diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> > > > > > index e4e1638fce1b..c95f6937c3f1 100644
> > > > > > --- a/drivers/net/wireguard/allowedips.c
> > > > > > +++ b/drivers/net/wireguard/allowedips.c
> > > > > > @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> > > > > > 
> > > > > >  void wg_allowedips_slab_uninit(void)
> > > > > >  {
> > > > > > -	rcu_barrier();
> > > > > >  	kmem_cache_destroy(node_cache);
> > > > > >  }
> > > > > > 
> > > > > > Once kmem_cache_destroy has been fixed to be deferrable.
> > > > > > 
> > > > > > I assume the other patches are similar -- an rcu_barrier() can be
> > > > > > removed. So some manual meddling of these might be in order.
> > > > > 
> > > > > Assuming that the deferrable kmem_cache_destroy() is the option chosen,
> > > > > agreed.
> > > > >
> > > > <snip>
> > > > void kmem_cache_destroy(struct kmem_cache *s)
> > > > {
> > > > 	int err = -EBUSY;
> > > > 	bool rcu_set;
> > > > 
> > > > 	if (unlikely(!s) || !kasan_check_byte(s))
> > > > 		return;
> > > > 
> > > > 	cpus_read_lock();
> > > > 	mutex_lock(&slab_mutex);
> > > > 
> > > > 	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
> > > > 
> > > > 	s->refcount--;
> > > > 	if (s->refcount)
> > > > 		goto out_unlock;
> > > > 
> > > > 	err = shutdown_cache(s);
> > > > 	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
> > > > 	     __func__, s->name, (void *)_RET_IP_);
> > > > ...
> > > > 	cpus_read_unlock();
> > > > 	if (!err && !rcu_set)
> > > > 		kmem_cache_release(s);
> > > > }
> > > > <snip>
> > > > 
> > > > so we have SLAB_TYPESAFE_BY_RCU flag that defers freeing slab-pages
> > > > and a cache by a grace period. Similar flag can be added, like
> > > > SLAB_DESTROY_ONCE_FULLY_FREED, in this case a worker rearm itself
> > > > if there are still objects which should be freed.
> > > > 
> > > > Any thoughts here?
> > > 
> > > Wouldn't we also need some additional code to later check for all objects
> > > being freed to the slab, whether or not that code is  initiated from
> > > kmem_cache_destroy()?
> > >
> > Same away as SLAB_TYPESAFE_BY_RCU is handled from the kmem_cache_destroy() function.
> > It checks that flag and if it is true and extra worker is scheduled to perform a
> > deferred(instead of right away) destroy after rcu_barrier() finishes.
> 
> Like this?
> 
> 	SLAB_DESTROY_ONCE_FULLY_FREED
> 
> 	Instead of adding a new kmem_cache_destroy_rcu()
> 	or kmem_cache_destroy_wait() API member, instead add a
> 	SLAB_DESTROY_ONCE_FULLY_FREED flag that can be passed to the
> 	existing kmem_cache_destroy() function.  Use of this flag would
> 	suppress any warnings that would otherwise be issued if there
> 	was still slab memory yet to be freed, and it would also spawn
> 	workqueues (or timers or whatever) to do any needed cleanup work.
> 
>
The flag is passed as all others during creating a cache:

  slab = kmem_cache_create(name, size, ..., SLAB_DESTROY_ONCE_FULLY_FREED | OTHER_FLAGS, NULL);

the rest description is correct to me.

--
Uladzislau Rezki

