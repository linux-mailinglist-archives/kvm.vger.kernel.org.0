Return-Path: <kvm+bounces-19806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 648FE90B7C2
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 19:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF8C3284BBD
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE85E16DC33;
	Mon, 17 Jun 2024 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgKo3Jxd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008916CD31;
	Mon, 17 Jun 2024 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718644801; cv=none; b=jQF+43rI1b/FSJgPuVs7YUXwJ1CpE7zjAjZJiWjQ+9UZFOeyf0fju9NtptC8R10/UAWo6ZxnXATrDjCnAnji/ZsV7HbSEIXz/981Y5Q2MzZJot2jkwss9iQdZl07Ed7R3kNpfNOIlYJJpr37a7upM48C7K55LZNg9dHIwjYwDLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718644801; c=relaxed/simple;
	bh=viLDpuJKEVzbprFQO23qfBQGXZv55FGbFpR7JPV8Aik=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t2ERHr8FQPwMczO/gM2XLiFlFfYps2iT+b/WA5H0okILTJy+2uQYiCnUI2govMbs4p6X1Rep+IQAXEQ8RcWGkA3/a+ycDser2a7CN3gEkiZg0ecVWaDuSxm16uucougeCbgqyLb3PECYVxNNSfDqkUXfjaAr3ERvbMK+e6z2PTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgKo3Jxd; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52c8c0d73d3so4957342e87.1;
        Mon, 17 Jun 2024 10:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718644797; x=1719249597; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vZ8O3vkKnV5WMsPPzukATAgUwpYfoN3xcCe/8i65jUE=;
        b=SgKo3JxdtCG+m66kMjKFe+P4rEEJaI1oi+ykzaC6O/8y40LsmHTsoH4h72fRWNFz/J
         vu3GOxMFcnuNGDnWwV3Rrpol5AmmXibVbvKdutsL8SO+o/l9UKRN1Z/ftKAdMC6/p0vL
         QqFtE/tKKO4l3B8U+1PJD+IYtqoioOs5S0po1dhRkQuGdhbjTa0FlW7tn3piw3ftPu44
         bsC3W7xyNvwJQgPOheWFGBIJ1Z2H6dbBRQC5wFgW3sjOorB/3qYOAWG8IukOaI2Qxbkb
         eTwvy2+xXShPiGsRa1r7Ye/nFeTy/BtuezripavaE7XpeNC1oJHQmf9p6TnHiD5HzDPZ
         KUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718644797; x=1719249597;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ8O3vkKnV5WMsPPzukATAgUwpYfoN3xcCe/8i65jUE=;
        b=AHEmTQkVsGEnHSXmfmE8m3j+9VJerkjODFwG45kiO8BkVYim+ux16HMSGdL3LiXInJ
         1wgpMDUk+aBQioPfJGe3wbCLFAmUgjRjS0ntmXPEc2KKBUSkSrtGTWMnEkzWBNndxNIP
         Lwe2zcE9zvsWuJSwhCHFJo5jxuGLhPptrYKQjgRMXynPr7Gej7akhsU1hT/kGP+zjv2r
         s3mLMeEkfhRdN+ioAmVMtEfHFn9e3hAXiFiRgYnGc5TALAfCZI9hi3ilw7kOcaCASi2c
         L3iUKvaNDKfy1oyPZtYLU/H/JSh3kJoydzldaOgyLsdAHIkDKrCBv8SuIAXloc8sOXNw
         5Wow==
X-Forwarded-Encrypted: i=1; AJvYcCXf7iKGVOjG8PrBwyOcJnZFZokqtrpWR7GZcgo0o4UFlMKvpG64oF8OYFAGWgYwLQ20gkxAftsmN6MbBByweHy6oADDF1iRb3ggza19GGL/wNlHxLQLSAFT8kemMZ4nrauPlM29Eb5MD2AwbJVayvZOscmxfkMI/e2zbBWnHxbFUhY4ZnXkph1V4nsSLL0spBmNNuS/mNiV7KAOW4DIgy99kDnXz8eVKfyDEPl++IlFro+zOcTcFsAf6pq/ivNCKJ8vtJGN+k2x6eTqL+MCuBy9eVQCiX7kaLg7IKVGXygF/wizvVbtcSbsA6CZz2sIO6k2devEoWY5cwWPXKxuqdFp73BqR9KfXAUVb30WiPkdqIPsWDlSqZzme37SxRFy97OKRiEeOebShjpiXbrCtd9/1lhgJQcarTMle/R6j1k5uIrnV9Tc44Re5ewLeQ==
X-Gm-Message-State: AOJu0YyVsYyhi0oT7KO4uJUAtgs/gzViqsVKdw/zeSk+ahiR4ZB9ljHd
	4sCQjw7mZJnVGK0QGHFdxxkRz7KknTB81vvkjmSZzUz2FZgqPies
X-Google-Smtp-Source: AGHT+IF+kn6orlxXNu+KbBfK5TuJ9FRTaW/E7mKFLwWnfY9/g3N+9lA943ajPi6EK1Z9MmgGKAp4XQ==
X-Received: by 2002:a19:8c5a:0:b0:52c:88d6:891d with SMTP id 2adb3069b0e04-52ca6e5637emr6427245e87.9.1718644797253;
        Mon, 17 Jun 2024 10:19:57 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52ca28722b0sm1286680e87.126.2024.06.17.10.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 10:19:56 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 17 Jun 2024 19:19:53 +0200
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
Message-ID: <ZnBwOf3faUJMbrfW@pc636>
References: <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636>
 <ZnBOkZClsvAUa_5X@zx2c4.com>
 <ZnBkvYdbAWILs7qx@pc636>
 <CAHmME9r4q8erE3E-Xn61ZkSOdDDrgx6jhTAywx3ca4=G0z=wAA@mail.gmail.com>
 <ZnBnb1WkJFXs5L6z@pc636>
 <ZnBrCQy13jZV_hyZ@zx2c4.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZnBrCQy13jZV_hyZ@zx2c4.com>

On Mon, Jun 17, 2024 at 06:57:45PM +0200, Jason A. Donenfeld wrote:
> On Mon, Jun 17, 2024 at 06:42:23PM +0200, Uladzislau Rezki wrote:
> > On Mon, Jun 17, 2024 at 06:33:23PM +0200, Jason A. Donenfeld wrote:
> > > On Mon, Jun 17, 2024 at 6:30 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> > > > Here if an "err" is less then "0" means there are still objects
> > > > whereas "is_destroyed" is set to "true" which is not correlated
> > > > with a comment:
> > > >
> > > > "Destruction happens when no objects"
> > > 
> > > The comment is just poorly written. But the logic of the code is right.
> > > 
> > OK.
> > 
> > > >
> > > > >  out_unlock:
> > > > >       mutex_unlock(&slab_mutex);
> > > > >       cpus_read_unlock();
> > > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > > index 1373ac365a46..7db8fe90a323 100644
> > > > > --- a/mm/slub.c
> > > > > +++ b/mm/slub.c
> > > > > @@ -4510,6 +4510,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
> > > > >               return;
> > > > >       trace_kmem_cache_free(_RET_IP_, x, s);
> > > > >       slab_free(s, virt_to_slab(x), x, _RET_IP_);
> > > > > +     if (s->is_destroyed)
> > > > > +             kmem_cache_destroy(s);
> > >
> > Here i am not follow you. How do you see that a cache has been fully
> > freed? Or is it just super draft code?
> 
> kmem_cache_destroy() does this in shutdown_cache().
>
Right. In this scenario you invoke kmem_cache_destroy() over and over
until the last object gets freed. This potentially slowing the kmem_cache_free()
which is not OK, at least to me.

--
Uladzislau Rezki

