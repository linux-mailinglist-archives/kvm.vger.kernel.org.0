Return-Path: <kvm+bounces-19801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0A1A90B6BD
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:42:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2839E283C1F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:42:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D601662FB;
	Mon, 17 Jun 2024 16:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPpauZqE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5EB1E529;
	Mon, 17 Jun 2024 16:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718642550; cv=none; b=MxJRe2/SHcxpqwm6PpxAW/MPef0u4tN6lWzi1h+KiNVTAsp6fBiy/e1ktklXEYluJshWFQm59/o2inx6d33KMOxo7vok8TUtGoyuNB8Nf0dZt08FJtyuoLPpa4ICT/E3ppgm5FW2wwJINvwDnOruGgaEgFte7uvOgDSbxVbguNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718642550; c=relaxed/simple;
	bh=4I3/haUM18/IbRSzFoVM3RfFFm03ff7YkrKpxiaQc8I=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fiT80zR7LAmeGmKODVGNJ6e27K0vbzv2sKfFyBFKtm4XXMT77TLrE4rzCBliH+ajx2HKZTBb6TfV14ynYk4eMeGQxLZ3G2H+S5zZYXtsPsJWbReoAwmPXB3b+4Vzc9y9gRU8sjEHnk1VeKAJfO0g8nsxa6Q4mt3R9kFM8K15PE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPpauZqE; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52bbf73f334so4308689e87.2;
        Mon, 17 Jun 2024 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718642547; x=1719247347; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nVbXAXBamX9byggpH5pf9RLnfjUsWFyotRoWWJmUCyg=;
        b=WPpauZqEv/iSEFaBLUgIOvw+Yi/gG42YuAd6wXLlDC9cDdeVz3iSQsaJnISFtgitoo
         D16GxmvpUfVLlDJplhrCA/9UgguUDa5xorbCYIovZCIPnZB9UcJa7D+M+AKHe2PnTcxT
         Q5nqrqK1QqfOBIpo6C9HOq3WK65Jiy8Wcfjp6a1xO8WvjHm/zxCf7pNAjaDe1RZFkhnn
         8KhzlzYQSkttiXexmYsqe1aNRRPKkyc70tmlRzEEe0ouMNNd8z81x2qsb9mYwj7YhGKj
         zLxBvw4+Kl2QjxLQgpAk9wcwSN6J3hq1uyIEj0weT8hddBTVgYGHChkyATo3+JJzVIFT
         CSRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718642547; x=1719247347;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVbXAXBamX9byggpH5pf9RLnfjUsWFyotRoWWJmUCyg=;
        b=S54xsxBPETDPBpCD9BtesQpSTW0szr1rU5LHtTVfWqYbY0J1NQvqV0djriqjBjTPnu
         T2lfnn3Wcoufc+jPxEevrGkE6yDvVdQIgCyVRqaITC0me0p0oKeXY39YwOHNCmuioQpj
         IbESciEPcWH7dM9e1txDS3GQg9aIMCc/tduj9PsAguKa0ZGH8T/pcDdG3DSfXWE2Ec8M
         awGHBWVPiRWi6pnM+s2tUbBj7UshLM4QauUnJrMotLQpQgk8qf6nlOeRjfohpsuS//Et
         PGTeicoYw+StGyd/6ukPguRCVBZsT9tN5MkK50uMPb/QCSpk6cmGB+jgNfJFNKSkkXjn
         XxSA==
X-Forwarded-Encrypted: i=1; AJvYcCXVzgYu87NX1Q7K2Un9bX7n2hakzkqMunrGJVGqnxzqIcZNohBo4ZyFtlhIijTrlCHEnNhFX+bdT63sxz/CxNiXxmh0V5X7YIMEhPdgB/WW6P2f7ftBTcZjqb9xVm0DZJVJfWAOMHfHy1esm5otC+rRw2M4ANOu0D1u+T8D+LEC4DO9s0GnAiF6ni2RSBMKiWlbBvnj4w7DYtgsf3XduOsli/VHAPFsqosxH4YHBV1Fc/WCab4o+79rqvE3+NXSuhHp/XqapAO3gIzxwT+RJ8HcQh3Yz/4zXphL7xb8jbOfqyK2iB3kutNy11hIaheltX5foIghxOPY4uHrQV4qEtHIKc6vTQ6p0UY2XwJrZqBjFn6hTX+kN4VMDaCm6zSkZOPKlO92caMbzX6X9nK57Jwi7CN4fjgGVUw6hNPdAN8XdRrhJg7vWrLJL/QClw==
X-Gm-Message-State: AOJu0YxE5B1bRna7xtDs6L4R08fElHC6WxRVSY+SgAAf+bplQOOiwvFi
	sYQwFGY1m5UnS3X298+DqCk7qeAraLUjO+ujYsyyzicEjAuPCpsG
X-Google-Smtp-Source: AGHT+IEbAoHoo+cqq7GZF8p0qgsFLjS7D8dpwx0oAM5cf5weHrkVdSXGtAH7Cuol28FV9Mqr6MxQYg==
X-Received: by 2002:a19:2d48:0:b0:52c:8fba:e2a1 with SMTP id 2adb3069b0e04-52ca6e657c4mr6499193e87.18.1718642546982;
        Mon, 17 Jun 2024 09:42:26 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca28722e2sm1265845e87.136.2024.06.17.09.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 09:42:26 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 17 Jun 2024 18:42:23 +0200
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
Message-ID: <ZnBnb1WkJFXs5L6z@pc636>
References: <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636>
 <ZnBOkZClsvAUa_5X@zx2c4.com>
 <ZnBkvYdbAWILs7qx@pc636>
 <CAHmME9r4q8erE3E-Xn61ZkSOdDDrgx6jhTAywx3ca4=G0z=wAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHmME9r4q8erE3E-Xn61ZkSOdDDrgx6jhTAywx3ca4=G0z=wAA@mail.gmail.com>

On Mon, Jun 17, 2024 at 06:33:23PM +0200, Jason A. Donenfeld wrote:
> On Mon, Jun 17, 2024 at 6:30 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> > Here if an "err" is less then "0" means there are still objects
> > whereas "is_destroyed" is set to "true" which is not correlated
> > with a comment:
> >
> > "Destruction happens when no objects"
> 
> The comment is just poorly written. But the logic of the code is right.
> 
OK.

> >
> > >  out_unlock:
> > >       mutex_unlock(&slab_mutex);
> > >       cpus_read_unlock();
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 1373ac365a46..7db8fe90a323 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -4510,6 +4510,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
> > >               return;
> > >       trace_kmem_cache_free(_RET_IP_, x, s);
> > >       slab_free(s, virt_to_slab(x), x, _RET_IP_);
> > > +     if (s->is_destroyed)
> > > +             kmem_cache_destroy(s);
>
Here i am not follow you. How do you see that a cache has been fully
freed? Or is it just super draft code?

Thanks!

--
Uladzislau Rezki

