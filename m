Return-Path: <kvm+bounces-19698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9CB908DD7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 16:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1791C22C04
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 14:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9F11CF96;
	Fri, 14 Jun 2024 14:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jMVQ2Ruu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA50319D8B1;
	Fri, 14 Jun 2024 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718376654; cv=none; b=MYfX6UMge1Q6ZyM30g+M7j1eKVHYu5VyCv2uT9o7Bp0hpvVwCUdp8/BCPUkGIZ5DhTwO6XP+shG/hw1iRX3yOrxmWcmjqbiSX3ATx9r5Qnq/dnaicdKnhyBeYbfPxHD2xFmUa0GxYRnwAfGeS2wxrLSE9JlK26PcuWf4HyUKEsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718376654; c=relaxed/simple;
	bh=t/Ae8J4res3vabscLveCrCGA2cPYSsgQf7VdwS4EsCs=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGLZTej5vqw0iMm0QBcrxy8ayr00mAeXJxXvfSWbFm2KYWo6q1z3qxX0okVtdJNjg+wejjhuHg0oNm+iW3mQUXo9I7+chgZruD9bblXf/FpP7ZK5xyZ6U2bFrSdB9r9ePhkraPgB8KkAiXgcgprMIGPLQOOSXpF4c/GG5/IuKZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jMVQ2Ruu; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52961b77655so2257217e87.2;
        Fri, 14 Jun 2024 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718376649; x=1718981449; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A1vDM+/434Vy7O2My5RlGhyPzc53w2jNpv2mu0lM6fk=;
        b=jMVQ2Ruun/H9bRvtoU7NnJUT104SlUvhHYh4KDudnKK8PE5a1VLEfbgYfxi+6oDfov
         S7qDIK2jCCHJ7rtmBlwuL/NrZyoDG2DipUNy3CUVBLo23zAmYn1+aoeT6Y1ZsxK5wGNp
         KyaQElgttTz8D8P9waRAyQ8DyL4QC31pnENxGRA7btGuFIXzSfDtO0lzwfxs6ip4ir8k
         y5f0egD6k3dg6/c/YzcGSxuiLdvZFTJ+D7FVru8IwVx3wfdhIZy7Uu/tFJ9AKyyY0pDD
         u57/P45+bYRz8wOA+kXt2N6bLU4Qqy/NaS5/7y4HYmkCB2CC4BkinV6utYcb96pdwcBm
         JdpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718376649; x=1718981449;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A1vDM+/434Vy7O2My5RlGhyPzc53w2jNpv2mu0lM6fk=;
        b=EPcefOhzLzij4pxHOtrUaWxafGYk4+fZ8kItg5qVNn9JYMeWd6Own4Nt7js6AvUAWE
         AzdzQL1sohmvVxSxj6cNr2eC3TKo6SQsz6P7sJvzCh1h7T8DrAzZcgVSiWkkwyhti60P
         rYwiiXxi+Hp/r9PH0zjID8aZ9DvHYpFIbIiLOxXYbmX4vjCzvmEfsTMggDl9a5wGivE3
         JiGBrEyaE01UnPA4DKZ+hXqaY2he8Zy7Nk8MItYlxU/qPTgWlScxLaARijeSfLYOMBCh
         V4OSM22pkQRn42QU8qK8nnevRmEntryqoaQQD1PO/xWUnBC7XaRJB3TMJVFlaREk6zP7
         BH/g==
X-Forwarded-Encrypted: i=1; AJvYcCU0SHgwTpZBEoalGDNvSAFZnLH3SHSbcTdU/XhAamXGjO36UZD69gmu5meNfuFSHrZ/fetRCWXkEaiapCA8RDFOQ98BgwzuOMwivMYsWLx1mW0qNtN7+eeJjm8VE5BjpKiB+VzopzvSeXO/ohIqQwTxAbQvAH41teSqVVfxyaKYTkAzASxQk7DhyXOZlqhJJWtirXWdVBorK0WX9Z73HSpERUmu/2pXSQGSuBykXkMcaJbdvSKk4nFcXlsU40VhBgVNmCwWOS+kNhlg/qjbnfC1cUJsWGTgOCC50yzsb9K8zjWnQJEX8BGX1sFFsb+0zyzxw5/s6uJR63GqsK74J3Rk57EItHQFsIC+Whhym0VbmS9vEJTNggJ1PQYq2vJwbRcr8vmAV/rNcryKlGNFaVM87auOBPN+P+MgEPKqiFaFterkeBv9zqA/kSyokg==
X-Gm-Message-State: AOJu0YwDFzLX0phXvOCThiIDKeMlqDId15sWnk5gIDtqdriXDMEwohxB
	tbF/ySOm3TaW5IufsxUwsT8XzkoqvF34OpeTJk5/LyNTdVXVjDqb
X-Google-Smtp-Source: AGHT+IFwcocbKCVljpVcKX91E2mKCvIpm5pfUWDi+eXb482Grpw2w/2u1FYYW0LUN48bweJbaljbrg==
X-Received: by 2002:ac2:4181:0:b0:52c:a5e6:989e with SMTP id 2adb3069b0e04-52ca6e656d3mr1989889e87.16.1718376648691;
        Fri, 14 Jun 2024 07:50:48 -0700 (PDT)
Received: from pc636 (host-90-233-218-141.mobileonline.telia.com. [90.233.218.141])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca2888119sm534327e87.266.2024.06.14.07.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jun 2024 07:50:48 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 14 Jun 2024 16:50:45 +0200
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
Message-ID: <ZmxYxYSLulV_2vhN@pc636>
References: <ZmrfA1p2zSVIaYam@zx2c4.com>
 <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <addbec8f-a67c-4191-8a3c-1181488947cb@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <addbec8f-a67c-4191-8a3c-1181488947cb@paulmck-laptop>

On Fri, Jun 14, 2024 at 07:17:29AM -0700, Paul E. McKenney wrote:
> On Fri, Jun 14, 2024 at 02:35:33PM +0200, Uladzislau Rezki wrote:
> > On Thu, Jun 13, 2024 at 11:13:52AM -0700, Paul E. McKenney wrote:
> > > On Thu, Jun 13, 2024 at 07:58:17PM +0200, Uladzislau Rezki wrote:
> > > > On Thu, Jun 13, 2024 at 10:45:59AM -0700, Paul E. McKenney wrote:
> > > > > On Thu, Jun 13, 2024 at 07:38:59PM +0200, Uladzislau Rezki wrote:
> > > > > > On Thu, Jun 13, 2024 at 08:06:30AM -0700, Paul E. McKenney wrote:
> > > > > > > On Thu, Jun 13, 2024 at 03:06:54PM +0200, Uladzislau Rezki wrote:
> > > > > > > > On Thu, Jun 13, 2024 at 05:47:08AM -0700, Paul E. McKenney wrote:
> > > > > > > > > On Thu, Jun 13, 2024 at 01:58:59PM +0200, Jason A. Donenfeld wrote:
> > > > > > > > > > On Wed, Jun 12, 2024 at 03:37:55PM -0700, Paul E. McKenney wrote:
> > > > > > > > > > > On Wed, Jun 12, 2024 at 02:33:05PM -0700, Jakub Kicinski wrote:
> > > > > > > > > > > > On Sun,  9 Jun 2024 10:27:12 +0200 Julia Lawall wrote:
> > > > > > > > > > > > > Since SLOB was removed, it is not necessary to use call_rcu
> > > > > > > > > > > > > when the callback only performs kmem_cache_free. Use
> > > > > > > > > > > > > kfree_rcu() directly.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > The changes were done using the following Coccinelle semantic patch.
> > > > > > > > > > > > > This semantic patch is designed to ignore cases where the callback
> > > > > > > > > > > > > function is used in another way.
> > > > > > > > > > > > 
> > > > > > > > > > > > How does the discussion on:
> > > > > > > > > > > >   [PATCH] Revert "batman-adv: prefer kfree_rcu() over call_rcu() with free-only callbacks"
> > > > > > > > > > > >   https://lore.kernel.org/all/20240612133357.2596-1-linus.luessing@c0d3.blue/
> > > > > > > > > > > > reflect on this series? IIUC we should hold off..
> > > > > > > > > > > 
> > > > > > > > > > > We do need to hold off for the ones in kernel modules (such as 07/14)
> > > > > > > > > > > where the kmem_cache is destroyed during module unload.
> > > > > > > > > > > 
> > > > > > > > > > > OK, I might as well go through them...
> > > > > > > > > > > 
> > > > > > > > > > > [PATCH 01/14] wireguard: allowedips: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
> > > > > > > > > > > 	Needs to wait, see wg_allowedips_slab_uninit().
> > > > > > > > > > 
> > > > > > > > > > Also, notably, this patch needs additionally:
> > > > > > > > > > 
> > > > > > > > > > diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
> > > > > > > > > > index e4e1638fce1b..c95f6937c3f1 100644
> > > > > > > > > > --- a/drivers/net/wireguard/allowedips.c
> > > > > > > > > > +++ b/drivers/net/wireguard/allowedips.c
> > > > > > > > > > @@ -377,7 +377,6 @@ int __init wg_allowedips_slab_init(void)
> > > > > > > > > > 
> > > > > > > > > >  void wg_allowedips_slab_uninit(void)
> > > > > > > > > >  {
> > > > > > > > > > -	rcu_barrier();
> > > > > > > > > >  	kmem_cache_destroy(node_cache);
> > > > > > > > > >  }
> > > > > > > > > > 
> > > > > > > > > > Once kmem_cache_destroy has been fixed to be deferrable.
> > > > > > > > > > 
> > > > > > > > > > I assume the other patches are similar -- an rcu_barrier() can be
> > > > > > > > > > removed. So some manual meddling of these might be in order.
> > > > > > > > > 
> > > > > > > > > Assuming that the deferrable kmem_cache_destroy() is the option chosen,
> > > > > > > > > agreed.
> > > > > > > > >
> > > > > > > > <snip>
> > > > > > > > void kmem_cache_destroy(struct kmem_cache *s)
> > > > > > > > {
> > > > > > > > 	int err = -EBUSY;
> > > > > > > > 	bool rcu_set;
> > > > > > > > 
> > > > > > > > 	if (unlikely(!s) || !kasan_check_byte(s))
> > > > > > > > 		return;
> > > > > > > > 
> > > > > > > > 	cpus_read_lock();
> > > > > > > > 	mutex_lock(&slab_mutex);
> > > > > > > > 
> > > > > > > > 	rcu_set = s->flags & SLAB_TYPESAFE_BY_RCU;
> > > > > > > > 
> > > > > > > > 	s->refcount--;
> > > > > > > > 	if (s->refcount)
> > > > > > > > 		goto out_unlock;
> > > > > > > > 
> > > > > > > > 	err = shutdown_cache(s);
> > > > > > > > 	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
> > > > > > > > 	     __func__, s->name, (void *)_RET_IP_);
> > > > > > > > ...
> > > > > > > > 	cpus_read_unlock();
> > > > > > > > 	if (!err && !rcu_set)
> > > > > > > > 		kmem_cache_release(s);
> > > > > > > > }
> > > > > > > > <snip>
> > > > > > > > 
> > > > > > > > so we have SLAB_TYPESAFE_BY_RCU flag that defers freeing slab-pages
> > > > > > > > and a cache by a grace period. Similar flag can be added, like
> > > > > > > > SLAB_DESTROY_ONCE_FULLY_FREED, in this case a worker rearm itself
> > > > > > > > if there are still objects which should be freed.
> > > > > > > > 
> > > > > > > > Any thoughts here?
> > > > > > > 
> > > > > > > Wouldn't we also need some additional code to later check for all objects
> > > > > > > being freed to the slab, whether or not that code is  initiated from
> > > > > > > kmem_cache_destroy()?
> > > > > > >
> > > > > > Same away as SLAB_TYPESAFE_BY_RCU is handled from the kmem_cache_destroy() function.
> > > > > > It checks that flag and if it is true and extra worker is scheduled to perform a
> > > > > > deferred(instead of right away) destroy after rcu_barrier() finishes.
> > > > > 
> > > > > Like this?
> > > > > 
> > > > > 	SLAB_DESTROY_ONCE_FULLY_FREED
> > > > > 
> > > > > 	Instead of adding a new kmem_cache_destroy_rcu()
> > > > > 	or kmem_cache_destroy_wait() API member, instead add a
> > > > > 	SLAB_DESTROY_ONCE_FULLY_FREED flag that can be passed to the
> > > > > 	existing kmem_cache_destroy() function.  Use of this flag would
> > > > > 	suppress any warnings that would otherwise be issued if there
> > > > > 	was still slab memory yet to be freed, and it would also spawn
> > > > > 	workqueues (or timers or whatever) to do any needed cleanup work.
> > > > > 
> > > > >
> > > > The flag is passed as all others during creating a cache:
> > > > 
> > > >   slab = kmem_cache_create(name, size, ..., SLAB_DESTROY_ONCE_FULLY_FREED | OTHER_FLAGS, NULL);
> > > > 
> > > > the rest description is correct to me.
> > > 
> > > Good catch, fixed, thank you!
> > > 
> > And here we go with prototype(untested):
> 
> Thank you for putting this together!  It looks way simpler than I would
> have guessed, and quite a bit simpler than I would expect it would be
> to extend rcu_barrier() to cover kfree_rcu().
> 
Yep, it should be pretty pretty straightforward. The slab mechanism does
not have a functionality when it comes to defer of destroying, i.e. it
is not allowed to destroy non-fully-freed-slab:

<snip>
void kmem_cache_destroy(struct kmem_cache *s)
{
...
	err = shutdown_cache(s);
	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
	     __func__, s->name, (void *)_RET_IP_);
...
<snip>

So, this patch extends it.

> >  
> > +static void
> > +slab_caches_defer_destroy_workfn(struct work_struct *work)
> > +{
> > +	struct kmem_cache *s, *s2;
> > +
> > +	mutex_lock(&slab_mutex);
> > +	list_for_each_entry_safe(s, s2, &slab_caches_defer_destroy, list) {
> > +		if (__kmem_cache_empty(s)) {
> > +			/* free asan quarantined objects */
> > +			kasan_cache_shutdown(s);
> > +			(void) __kmem_cache_shutdown(s);
> > +
> > +			list_del(&s->list);
> > +
> > +			debugfs_slab_release(s);
> > +			kfence_shutdown_cache(s);
> > +			kmem_cache_release(s);
> > +		}
> 
> My guess is that there would want to be a splat if the slab stuck around
> for too long, but maybe that should instead be handled elsewhere or in
> some other way?  I must defer to you guys on that one.
> 
Probably yes.

--
Uladzislau Rezki

