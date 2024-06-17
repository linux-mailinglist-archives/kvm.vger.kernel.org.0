Return-Path: <kvm+bounces-19798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0670290B663
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DEB71C22FE7
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:31:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4199E15A861;
	Mon, 17 Jun 2024 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzsoFndl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0165158DD4;
	Mon, 17 Jun 2024 16:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718641861; cv=none; b=OETSlEzlt6Ld1ESHkJ6ob/keXD6zd0rwUg5CizZw+w8gk7nARDX1I2hYzBBx5vW4rT3GGcEq+R6gJU+5KPTrrCzrd47VDfNhuMYZAmQ4M9pJH1fdOEzfzWudYGeeR70eoD5y6RmpZtjXJMC8zyggPtMwob+LUcpoQH1zJ6IhUUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718641861; c=relaxed/simple;
	bh=N+Qryf05FJj1hGepJO+grejqagGTDFVxmTmLFR24LxA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJv0QkfMjbcK6LvuLikCBtyxRNLBz++eE3esTISmsjxaBhzJqCUERXfBBS60Qreg8xq+WvMAbSu5kei1SxCoWXS+lWeOTKuho9tSdexO9gsMHAbOkSnh7gzHVygKu3E3q6g7XlFuR4K4Gh081Frn1OX6GfeL6vSZHLc9wqevgFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzsoFndl; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2ebe6495aedso42867981fa.0;
        Mon, 17 Jun 2024 09:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718641858; x=1719246658; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P18NXjBrMly2kaNOMkzQiyWW0KiEt9TV5gbmtLRhdnE=;
        b=IzsoFndljoYmFfZmzKjWO0y7B8sVwieQnmonFcQGhlZk1LiRZ/S6QKGZTV1AKY6MH+
         6Vo+dLGcTL2Vv2E/pbRdL38QYElOjdFR8jOBiNPW24IS5BW+kzEXNRdMfSb9jp6Ewean
         pDtMwixWFQYsCKbih32MNuZt+7FYYR3Canr74iZmOl7oNsNfXhLak7c8W7V9cG5pdB9Q
         HrlN4xolvduCdgGprtGxzeywjmEPKiNZP2HSjGCiomeulNM76EJnFG4d0qJI36fgjWP0
         xgkppzYOtcJyXQZzuZ5NPzja5a2AEHarQdyPfuJTuJFTRRYVUU68+4e02NCGBiWFAUFv
         +kyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718641858; x=1719246658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P18NXjBrMly2kaNOMkzQiyWW0KiEt9TV5gbmtLRhdnE=;
        b=NQfNJUHQ+lyHYNcxnNI1Md1WHmQmRcDvErix9HmkKdp5drJjJZ1i6LoKRqt6Wf7sDO
         OkXJM3GLjZ1lpnGN+mP/ISU94l5tv6iJUrFQW8Uz3y6zYCMVxLsDrZQuUS6lHgSb0eEN
         DmxMcPxDUslRakWqA6+yjPptK3tBdzNIrFF98f0ks3Oa95nI9fs4hrw8cmK7YmXeKWj+
         /amXkr7/TWvmcOU1r0a3wJIIURE8a7piZbYpKvc6Lao98SBypMMEUyX4v1rqSvlkb8s5
         ulY9myrT/n8crUZ1goFbRsbMregU8lbpfQ2+K7Rol4Qs/XEIYnJnsKL6aXDeP+3YT3n5
         pOyg==
X-Forwarded-Encrypted: i=1; AJvYcCVleeA6xn5BOtkxGX4FWGbpeD4/T15dmo5/xbFDclKPkKGFuhMDZeG75nHijC0OdUuR8lYbJoIxBtUqOcHDWDzJREwr0L2lJMwsOoe5oIJw4VuE7Cd0hffwAYqI5j6N+THUNWZxPMO8U4Y8HC9nQQ5FalzoJmhbSbF3oQKCMIJZgZhTkrN7M4bzMNLQAYf9VR13wKEc7PWMAc5+//Y45ZhpLdTrxzld10oJWGO6OJd9eIhIJADE+jLVgkuhx5HoyVaDmLw7KSuUA2WH+3B6G4z8mnHHg9oovCwzpeZROGElqtV5kJG1OhvZ+526deYv4eOOHAjNG2G0tVCyp6TadECmVrD2iU0O1ZfjTTleo1T6AB0DkpIglliEIsCdrjHExcwxQ2f/txa9/oKp4MExRbBhh/RM1t0JbYhttty0f1NK5Ryexlnixss7jN9yUw==
X-Gm-Message-State: AOJu0YxbktrJ7Srt36nbvYrAZRHcU9Zr0H5CPczrYiaj5mUd5Z4QICvM
	QcSq/gkJ0Lrt6uq+F3oGNC8fSnyqBwiZ40HuWOS2UGo0mKxMaS2V
X-Google-Smtp-Source: AGHT+IEPhqe0DMj4rMlaXsMOCbhrl4lbGG1gPjCGb7ivFIirSumn2PP7mfmxsW/9BAzDd49k/bprGA==
X-Received: by 2002:a2e:9cd6:0:b0:2eb:fdd3:8fa2 with SMTP id 38308e7fff4ca-2ec0e5c5816mr68620871fa.13.1718641857513;
        Mon, 17 Jun 2024 09:30:57 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec05c78400sm14106751fa.84.2024.06.17.09.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 09:30:57 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 17 Jun 2024 18:30:53 +0200
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
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
Message-ID: <ZnBkvYdbAWILs7qx@pc636>
References: <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636>
 <ZnBOkZClsvAUa_5X@zx2c4.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnBOkZClsvAUa_5X@zx2c4.com>

On Mon, Jun 17, 2024 at 04:56:17PM +0200, Jason A. Donenfeld wrote:
> On Mon, Jun 17, 2024 at 03:50:56PM +0200, Uladzislau Rezki wrote:
> > On Fri, Jun 14, 2024 at 09:33:45PM +0200, Jason A. Donenfeld wrote:
> > > On Fri, Jun 14, 2024 at 02:35:33PM +0200, Uladzislau Rezki wrote:
> > > > +	/* Should a destroy process be deferred? */
> > > > +	if (s->flags & SLAB_DEFER_DESTROY) {
> > > > +		list_move_tail(&s->list, &slab_caches_defer_destroy);
> > > > +		schedule_delayed_work(&slab_caches_defer_destroy_work, HZ);
> > > > +		goto out_unlock;
> > > > +	}
> > > 
> > > Wouldn't it be smoother to have the actual kmem_cache_free() function
> > > check to see if it's been marked for destruction and the refcount is
> > > zero, rather than polling every one second? I mentioned this approach
> > > in: https://lore.kernel.org/all/Zmo9-YGraiCj5-MI@zx2c4.com/ -
> > > 
> > >     I wonder if the right fix to this would be adding a `should_destroy`
> > >     boolean to kmem_cache, which kmem_cache_destroy() sets to true. And
> > >     then right after it checks `if (number_of_allocations == 0)
> > >     actually_destroy()`, and likewise on each kmem_cache_free(), it
> > >     could check `if (should_destroy && number_of_allocations == 0)
> > >     actually_destroy()`. 
> > > 
> > I do not find pooling as bad way we can go with. But your proposal
> > sounds reasonable to me also. We can combine both "prototypes" to
> > one and offer.
> > 
> > Can you post a prototype here?
> 
> This is untested, but the simplest, shortest possible version would be:
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 5f8f47c5bee0..907c0ea56c01 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -275,6 +275,7 @@ struct kmem_cache {
>  	unsigned int inuse;		/* Offset to metadata */
>  	unsigned int align;		/* Alignment */
>  	unsigned int red_left_pad;	/* Left redzone padding size */
> +	bool is_destroyed;		/* Destruction happens when no objects */
>  	const char *name;		/* Name (only for display!) */
>  	struct list_head list;		/* List of slab caches */
>  #ifdef CONFIG_SYSFS
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1560a1546bb1..f700bed066d9 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -494,8 +494,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
>  		goto out_unlock;
> 
>  	err = shutdown_cache(s);
> -	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
> -	     __func__, s->name, (void *)_RET_IP_);
> +	if (err)
> +		s->is_destroyed = true;
>
Here if an "err" is less then "0" means there are still objects
whereas "is_destroyed" is set to "true" which is not correlated
with a comment:

"Destruction happens when no objects"

>  out_unlock:
>  	mutex_unlock(&slab_mutex);
>  	cpus_read_unlock();
> diff --git a/mm/slub.c b/mm/slub.c
> index 1373ac365a46..7db8fe90a323 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -4510,6 +4510,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
>  		return;
>  	trace_kmem_cache_free(_RET_IP_, x, s);
>  	slab_free(s, virt_to_slab(x), x, _RET_IP_);
> +	if (s->is_destroyed)
> +		kmem_cache_destroy(s);
>  }
>  EXPORT_SYMBOL(kmem_cache_free);
> 
> @@ -5342,9 +5344,6 @@ static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
>  		if (!slab->inuse) {
>  			remove_partial(n, slab);
>  			list_add(&slab->slab_list, &discard);
> -		} else {
> -			list_slab_objects(s, slab,
> -			  "Objects remaining in %s on __kmem_cache_shutdown()");
>  		}
>  	}
>  	spin_unlock_irq(&n->list_lock);
> 
Anyway it looks like it was not welcome to do it in the kmem_cache_free()
function due to performance reason.

--
Uladzislau Rezki

