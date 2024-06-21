Return-Path: <kvm+bounces-20227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74EB99120A6
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 11:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C38A2839A4
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 09:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6342A16EBE9;
	Fri, 21 Jun 2024 09:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DHWS9DXt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D351E482C8;
	Fri, 21 Jun 2024 09:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718962338; cv=none; b=Uo8u30sQpnpgMhBssBYcui9caZahVcbWV8Qa3QoG7FiNo/xA8bJMvhrUn7yMHcr8w8HsiEgh+0qhocj+1E89TblcumCB+LZPoVeOfXdRpsO8hiivd1FP6YCxotsGhkAWeyynY1wfqh2MTDr+k4Q/eYAby2eBIIfUVe1jtSSNiok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718962338; c=relaxed/simple;
	bh=tX3lbP0oIbLXstNsFkYy7tmCmp7K2WDT7BZj38Vc58w=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V4HRfTm5EPxZyncVOyHzG2RwedWRBCeaNjk6VmLIkv2oE7EhMpw4YdqW6832zFwUAojLsEQmc/4saS8Ff8TqP57ecEjrauBP2PI/F8E1rknC9yWrOFPMsgX2FYfkI4KBd3wO+LTQMt5qjn2GpCaCaRMyjo0j9kSlpxiV4pplnI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DHWS9DXt; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-57cc30eaf0aso951999a12.2;
        Fri, 21 Jun 2024 02:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718962335; x=1719567135; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LXjbiUeKX1jEQnL+FwWLcen6cX7ksdYWye9qn3fwv6g=;
        b=DHWS9DXt13LiribTgN2bFTRDmxtyLV6IugelHM34OjdJd2ZlVkJZrZVzo188uPm+6F
         nJOebWgnUBywhTTS8Ax6m2BWlthz09YQm9I0ybOkWVpdiVl3ikslR7uqk/AeA7Dp0OHu
         GxTcDEN2qtTwAZVEfitZKxqWR7Tzxvx9tY3FD3C1QoiS6kdr95Zf9Rp7NAY2dm0ebP8H
         YamJigxkBQ+XWKofXRFmw2rEVpME2dPoRkqRz+RBxAPum+ADALYaM1UpF6KsyF2gV6gu
         MMeMLSJ5M2eJThJU+tEyQHXT2unV7hp283rA7EcUVO1cKyfxJAx8eDaoXl2H9VZD7CS6
         TGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718962335; x=1719567135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXjbiUeKX1jEQnL+FwWLcen6cX7ksdYWye9qn3fwv6g=;
        b=SEmlM5N11fHyWBqnA+j0sKITFQCOUyI1d740MV2oCGmlquzQ9K2F2/kkeNiouWsMhy
         Hy4Dkke0nRk1mbNcj3FP5GG3r8n1wViYmjOlFT3+HQdhx8kjn8f144N8Wv3Gl5fWsYLr
         pj4TbJST39aj3gpJ6L7ISKE+NPk7RKRu4VGB1RFtUhI7i7ZcEmj9crMwAPW6R/lGwo93
         K67POJZPwSGheQe4pQSmtoeDNZCUNPBDH1DJ/R9aLywW+ezqJAqbpHZ82ZdddTEjlyd4
         HUQe3sgh7A01I8ilUKUytwBxEChrbeCijlrmMfYBoSz81svheAucI2nfgbmQod6LEpW0
         szKA==
X-Forwarded-Encrypted: i=1; AJvYcCWsHXq3IZ+DU1wQFIte1T+StCLSQKiubG5fdrMQbufCImFUw/+WmzKXpS+G94YxTHYZMYPLxa3UiWLNflmF6mQDzPzx7Fci7TkqIRCdv98/6daniRcZreiYVkVqgvm2ImhIftkgAMDDrGbKgDynA/cDcXn0PpM7vHeolSW3CzJ3yMRm98KGJLDPicOBeDsukR2VclJoyAgnKW1f2lJsT1QWJpn4wIXQZGLS+nrtVzo9RTMujH4bdXtUbMQeeWFaGXiSD5A/oS5PoJLaMfGl9O9R3rkeuEtEkmU0U7J9K/YVrrJQLOOI3ePWefYkMzPo5I8gqPpzxjZIkhPYPWf2HE2FtP3+4sxgAbdBtStPDJU9AdL6i8lQNv4QwOEqj8ntCPbeCJOsorwyRrzo1SGdoAYPRGjljsARK+Kvp4JkKOQVub+hbZdQOpa+xgPQFw==
X-Gm-Message-State: AOJu0YwnrLyS2yw9Wh8270dYG9hHynYiiWubYziAsEyVia3LuPplYFp4
	jTiLXRI/L+6xR22gTZE7xa6KqUdqkMrxgW3gVjoK5hXcqvLWuyElAILmhpnIGJ0=
X-Google-Smtp-Source: AGHT+IEG3QIZH1aO0GWd9T0Xk/3yUg93srj60sGG+BwmRF3tpMGbSRtFwCmQB/INPoCeCqb37IZhUg==
X-Received: by 2002:a50:d60b:0:b0:57a:79c2:e9d6 with SMTP id 4fb4d7f45d1cf-57d07ea9ccbmr5867695a12.33.1718962334727;
        Fri, 21 Jun 2024 02:32:14 -0700 (PDT)
Received: from pc636 (176-227-201-31.ftth.glasoperator.nl. [31.201.227.176])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6fcf56e9f3sm62345066b.215.2024.06.21.02.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 02:32:14 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Fri, 21 Jun 2024 11:32:12 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: paulmck@kernel.org, Uladzislau Rezki <urezki@gmail.com>,
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
Message-ID: <ZnVInAV8BXhgAjP_@pc636>
References: <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
 <9967fdfa-e649-456d-a0cb-b4c4bf7f9d68@suse.cz>
 <6dad6e9f-e0ca-4446-be9c-1be25b2536dd@paulmck-laptop>
 <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cba4a48-902b-4fb6-895c-c8e6b64e0d5f@suse.cz>

On Wed, Jun 19, 2024 at 11:28:13AM +0200, Vlastimil Babka wrote:
> On 6/18/24 7:53 PM, Paul E. McKenney wrote:
> > On Tue, Jun 18, 2024 at 07:21:42PM +0200, Vlastimil Babka wrote:
> >> On 6/18/24 6:48 PM, Paul E. McKenney wrote:
> >> > On Tue, Jun 18, 2024 at 11:31:00AM +0200, Uladzislau Rezki wrote:
> >> >> > On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
> >> >> > >> +
> >> >> > >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> >> >> > >> +
> >> >> > >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
> >> >> > > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
> >> >> > > wanted to avoid initially.
> >> >> > 
> >> >> > I wanted to avoid new API or flags for kfree_rcu() users and this would
> >> >> > be achieved. The barrier is used internally so I don't consider that an
> >> >> > API to avoid. How difficult is the implementation is another question,
> >> >> > depending on how the current batching works. Once (if) we have sheaves
> >> >> > proven to work and move kfree_rcu() fully into SLUB, the barrier might
> >> >> > also look different and hopefully easier. So maybe it's not worth to
> >> >> > invest too much into that barrier and just go for the potentially
> >> >> > longer, but easier to implement?
> >> >> > 
> >> >> Right. I agree here. If the cache is not empty, OK, we just defer the
> >> >> work, even we can use a big 21 seconds delay, after that we just "warn"
> >> >> if it is still not empty and leave it as it is, i.e. emit a warning and
> >> >> we are done.
> >> >> 
> >> >> Destroying the cache is not something that must happen right away. 
> >> > 
> >> > OK, I have to ask...
> >> > 
> >> > Suppose that the cache is created and destroyed by a module and
> >> > init/cleanup time, respectively.  Suppose that this module is rmmod'ed
> >> > then very quickly insmod'ed.
> >> > 
> >> > Do we need to fail the insmod if the kmem_cache has not yet been fully
> >> > cleaned up?
> >> 
> >> We don't have any such link between kmem_cache and module to detect that, so
> >> we would have to start tracking that. Probably not worth the trouble.
> > 
> > Fair enough!
> > 
> >> >  If not, do we have two versions of the same kmem_cache in
> >> > /proc during the overlap time?
> >> 
> >> Hm could happen in /proc/slabinfo but without being harmful other than
> >> perhaps confusing someone. We could filter out the caches being destroyed
> >> trivially.
> > 
> > Or mark them in /proc/slabinfo?  Yet another column, yay!!!  Or script
> > breakage from flagging the name somehow, for example, trailing "/"
> > character.
> 
> Yeah I've been resisting such changes to the layout and this wouldn't be
> worth it, apart from changing the name itself but not in a dangerous way
> like with "/" :)
> 
> >> Sysfs and debugfs might be more problematic as I suppose directory names
> >> would clash. I'll have to check... might be even happening now when we do
> >> detect leaked objects and just leave the cache around... thanks for the
> >> question.
> > 
> > "It is a service that I provide."  ;-)
> > 
> > But yes, we might be living with it already and there might already
> > be ways people deal with it.
> 
> So it seems if the sysfs/debugfs directories already exist, they will
> silently not be created. Wonder if we have such cases today already because
> caches with same name exist. I think we do with the zsmalloc using 32 caches
> with same name that we discussed elsewhere just recently.
> 
> Also indeed if the cache has leaked objects and won't be thus destroyed,
> these directories indeed stay around, as well as the slabinfo entry, and can
> prevent new ones from being created (slabinfo lines with same name are not
> prevented).
> 
> But it wouldn't be great to introduce this possibility to happen for the
> temporarily delayed removal due to kfree_rcu() and a module re-insert, since
> that's a legitimate case and not buggy state due to leaks.
> 
> The debugfs directory we could remove immediately before handing over to the
> scheduled workfn, but if it turns out there was a leak and the workfn leaves
> the cache around, debugfs dir will be gone and we can't check the
> alloc_traces/free_traces files there (but we have the per-object info
> including the traces in the dmesg splat).
> 
> The sysfs directory is currently removed only with the whole cache being
> destryed due to sysfs/kobject lifetime model. I'd love to untangle it for
> other reasons too, but haven't investigated it yet. But again it might be
> useful for sysfs dir to stay around for inspection, as for the debugfs.
> 
> We could rename the sysfs/debugfs directories before queuing the work? Add
> some prefix like GOING_AWAY-$name. If leak is detected and cache stays
> forever, another rename to LEAKED-$name. (and same for the slabinfo). But
> multiple ones with same name might pile up, so try adding a counter then?
> Probably messy to implement, but perhaps the most robust in the end? The
> automatic counter could also solve the general case of people using same
> name for multiple caches.
> 
> Other ideas?
> 
One question. Maybe it is already late but it is better to ask rather than not.

What do you think if we have a small discussion about it on the LPC 2024 as a
topic? It might be it is already late or a schedule is set by now. Or we fix
it by a conference time.

Just a thought.

--
Uladzislau Rezki

