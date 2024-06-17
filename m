Return-Path: <kvm+bounces-19804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD99D90B73B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:58:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BC19284258
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4453C16A923;
	Mon, 17 Jun 2024 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="flFAYgY/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C330161B6A;
	Mon, 17 Jun 2024 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718643485; cv=none; b=hkHWr3MwHi93pOVnrF1QmzK6Jko0mQYZrqCjIvz0U7sRZUHBOij0bftdrsMssHSdPdUh3iZ1wxs0SMm2KDMt/DVDYYnD3OWkQT+aqZQOFV3CLqvhO3LnBPaaGvwfVD619aubpRSE450sfj7vCbh1CbUruimop/cNJ6es0aK4HAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718643485; c=relaxed/simple;
	bh=fUjYaRe8sqwn+3/vFWBWn9gD6kaYbkbJlyulqCM3tGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXn9PnxUjhkzN/Wr8Ylg+WIQl6qfVhFJvfZWb2aRZb+ihxsm0dgakyuaXKayRDo0D/7scBWcZDh/eCRlj3XAPw+LapWtEsSmWstE3Z+TXC8EmRKp8zucjZmFArUdeCXjpktauE4fAxmsPrR2g4e+3HEP3QLvtFLK4hzxUIGXguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=flFAYgY/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB0CC2BD10;
	Mon, 17 Jun 2024 16:58:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="flFAYgY/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718643480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Er+nOtS55CJu3Syh5+61jyHDlq8/Vrsh+iYYZbfn+o=;
	b=flFAYgY/nnqqK8ubdy9niyG0NubdT4klfUfroBy/DNbbO5DVT8vPRu3BffTtJ7pQodZOaN
	Y3wGFg0sxRrxjV2DzwGTt5JcGvNy16RrLu7AO/l+9eaew+eczEo86Y/W+NUwvsFaEBJxH+
	IIdE/u1uTCF4+OVrHDCFLUq2WCu7sHI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4270396f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 17 Jun 2024 16:57:57 +0000 (UTC)
Date: Mon, 17 Jun 2024 18:57:45 +0200
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
Message-ID: <ZnBrCQy13jZV_hyZ@zx2c4.com>
References: <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636>
 <ZnBOkZClsvAUa_5X@zx2c4.com>
 <ZnBkvYdbAWILs7qx@pc636>
 <CAHmME9r4q8erE3E-Xn61ZkSOdDDrgx6jhTAywx3ca4=G0z=wAA@mail.gmail.com>
 <ZnBnb1WkJFXs5L6z@pc636>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZnBnb1WkJFXs5L6z@pc636>

On Mon, Jun 17, 2024 at 06:42:23PM +0200, Uladzislau Rezki wrote:
> On Mon, Jun 17, 2024 at 06:33:23PM +0200, Jason A. Donenfeld wrote:
> > On Mon, Jun 17, 2024 at 6:30 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> > > Here if an "err" is less then "0" means there are still objects
> > > whereas "is_destroyed" is set to "true" which is not correlated
> > > with a comment:
> > >
> > > "Destruction happens when no objects"
> > 
> > The comment is just poorly written. But the logic of the code is right.
> > 
> OK.
> 
> > >
> > > >  out_unlock:
> > > >       mutex_unlock(&slab_mutex);
> > > >       cpus_read_unlock();
> > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > index 1373ac365a46..7db8fe90a323 100644
> > > > --- a/mm/slub.c
> > > > +++ b/mm/slub.c
> > > > @@ -4510,6 +4510,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
> > > >               return;
> > > >       trace_kmem_cache_free(_RET_IP_, x, s);
> > > >       slab_free(s, virt_to_slab(x), x, _RET_IP_);
> > > > +     if (s->is_destroyed)
> > > > +             kmem_cache_destroy(s);
> >
> Here i am not follow you. How do you see that a cache has been fully
> freed? Or is it just super draft code?

kmem_cache_destroy() does this in shutdown_cache().

