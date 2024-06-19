Return-Path: <kvm+bounces-19953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF47290E75D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:52:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40F671F22B7F
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B8E54784;
	Wed, 19 Jun 2024 09:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PJCVKjSI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108CB81AA3;
	Wed, 19 Jun 2024 09:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718790726; cv=none; b=smPO346rzSsV2Hu6Htlqkak6ReWBlTUBYjy5Ag8X5TPsF0VwGZaEBEfPwIrOUOkC/dmqBIpQuQDuNiby9ax+ipchIid+PNlcgcwyfgnke+a9/zxa3xfgTUA8OQORbt+/PmqRPHWVzGtFJ8HTNuARlRzZQ6CbesACTQSi2hHh/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718790726; c=relaxed/simple;
	bh=QNo5k1Xit7gstpENqR9hmPgsoLViG3k55hI7buVxfMU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRg4k6lt/RQcKt353SXPxLf/pusfkOSgKsBGb/WaauQYNws0u98KygXoDy/mXHIkcT9Afl0Y4pjkka+iJkit/CATLHdzylPjCswcILdrNuNeWRuQkjflnLMhbW02d4rdtv96OW4BD1MVYBqJzICjftLxN5HZTXb2GD7it9xyyh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PJCVKjSI; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ec0f3b9bb8so46987921fa.1;
        Wed, 19 Jun 2024 02:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718790723; x=1719395523; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TY+TzI4NVOZe+bVmXFpZLf0ZfiG9DoMpTrEztVoxeCc=;
        b=PJCVKjSI0llDw6J0/7YYIhUHlgxCIeHhZeBPWHvb2Iap9+UWdiM9oL7hqliWSWB+ZI
         ZNbiARqhAtrLKbcG9CUfQF0Glc0u7AuA7cotYN6sPUvxMNXKH/nGprdQ++Pab+g4Rp11
         o9Ln5K20t2FQp5VVp+/70TJT/ocmFdIyfBY4p7Og7d/4RTDBKhoBY3kCYTnO/Z90G1xK
         dXlRUTFBnsZcXfS0XaJZw2HLksTm1Er8OH3kGHMUv0O+RVchjNjTk+4RLizRZDLMOeST
         ZWAjY3BUEYCOXBL38K0ebCJSuUkXek3zeZModbf5CbnORpLA1C9EhVRmeNAvEl0fChjZ
         x8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718790723; x=1719395523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TY+TzI4NVOZe+bVmXFpZLf0ZfiG9DoMpTrEztVoxeCc=;
        b=u2frX3ctfX5QB0/GUXP8u4kztIE6Mu/NzT5io8cvJQCACyvfxdkOnOnAh1C7qs+una
         LzEEXJBgxZW/ZmzusAjA1CZ+thIEOckX7MUVNQ1N9EZ8xTgKJFUG4hD0Ct196pqSsYNn
         sdhPamlVBeta6Ph7txxOTs/IvUk1h514izN21CK+XLe1+uMaeIffTtx/7djXUZhIgD1S
         DALoOX4SWqIfq54MIR2sCN303hDN3DSD6V8s5joSmpTTVJFEVkxUmjBEONX6nvWvlJ7E
         REe7c4fDBG8Ndd2BoPslSm3YlWkyqvyC4l66JRBWTnlY3px6J9e5vZOfz66soXO9eXyD
         78gg==
X-Forwarded-Encrypted: i=1; AJvYcCXt087gQy52lvVoKJ5FFTKKzdiB9rz6PrGRf3GvbHmxYWXM5Inz1+MiUYqia0fSFduM5Aj0IDBnRl6v7Hotbu5O0hLTLXOeu8mNKTjWwCrxd8bbV8uOG+7exzWWQpG6APVp4dyzde9F2LQpTc7L+ylq2UW/nWbB5aEJcbzggmUbHoPOZz38ZXA9Tk7OpdyErmbGVNbo54sV72mPXqboMohDyKpkpJo2ElTHJM5xZiWDyj5H2rtSsGEV/LL/+rn9f46ueAsyZC1Lfr1owLMv6pG2TB718s4WwesMPEvlFkVe1zRP6WmVshWl2Wl8KfYEq0DO0bRu8zKlrNzjswdJDlKfPDAltodJnxjoB00du/WKHHtd1yDUndv2gJ1/vmJ2tkUH82hRk+z3/oOk0r2/tzy/Li0Wh4Agj0LZrc9b/0gDe4pAVTOeiM0E7ZUjTA==
X-Gm-Message-State: AOJu0YyshtbobD9fp0f4Ark7RGWWXxC+xC0jk1WKeadUIrenmREXVYy1
	vAuzJSqU+gTkzUMzYqItUmRR8e1QnU2YggsmvrusIq3njlwgMdju
X-Google-Smtp-Source: AGHT+IH2q3ZanpQKJz2uH0N6Dyx/XhlIdcK364i+Te6PyIoIECi/nqcQmDGItl1tQkSP50785isBNw==
X-Received: by 2002:a2e:9cc6:0:b0:2eb:e365:f191 with SMTP id 38308e7fff4ca-2ec3ce93f99mr14054151fa.15.1718790722749;
        Wed, 19 Jun 2024 02:52:02 -0700 (PDT)
Received: from pc636 (host-90-233-216-238.mobileonline.telia.com. [90.233.216.238])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec05c06068sm19506721fa.35.2024.06.19.02.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 02:52:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 19 Jun 2024 11:51:58 +0200
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
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH 00/14] replace call_rcu by kfree_rcu for simple
 kmem_cache_free callback
Message-ID: <ZnKqPqlPD3Rl04DZ@pc636>
References: <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
 <ZnCDgdg1EH6V7w5d@pc636>
 <36c60acd-543e-48c5-8bd2-6ed509972d28@suse.cz>
 <ZnFT1Czb8oRb0SE7@pc636>
 <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c8b2883-962f-431f-b2d3-3632755de3b0@paulmck-laptop>

On Tue, Jun 18, 2024 at 09:48:49AM -0700, Paul E. McKenney wrote:
> On Tue, Jun 18, 2024 at 11:31:00AM +0200, Uladzislau Rezki wrote:
> > > On 6/17/24 8:42 PM, Uladzislau Rezki wrote:
> > > >> +
> > > >> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> > > >> +
> > > >> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
> > > > It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
> > > > wanted to avoid initially.
> > > 
> > > I wanted to avoid new API or flags for kfree_rcu() users and this would
> > > be achieved. The barrier is used internally so I don't consider that an
> > > API to avoid. How difficult is the implementation is another question,
> > > depending on how the current batching works. Once (if) we have sheaves
> > > proven to work and move kfree_rcu() fully into SLUB, the barrier might
> > > also look different and hopefully easier. So maybe it's not worth to
> > > invest too much into that barrier and just go for the potentially
> > > longer, but easier to implement?
> > > 
> > Right. I agree here. If the cache is not empty, OK, we just defer the
> > work, even we can use a big 21 seconds delay, after that we just "warn"
> > if it is still not empty and leave it as it is, i.e. emit a warning and
> > we are done.
> > 
> > Destroying the cache is not something that must happen right away. 
> 
> OK, I have to ask...
> 
> Suppose that the cache is created and destroyed by a module and
> init/cleanup time, respectively.  Suppose that this module is rmmod'ed
> then very quickly insmod'ed.
> 
> Do we need to fail the insmod if the kmem_cache has not yet been fully
> cleaned up?  If not, do we have two versions of the same kmem_cache in
> /proc during the overlap time?
> 
No fail :) If same cache is created several times, its s->refcount gets
increased, so, it does not create two entries in the "slabinfo". But i
agree that your point is good! We need to be carefully with removing and
simultaneous creating.

From the first glance, there is a refcounter and a global "slab_mutex"
which is used to protect a critical section. Destroying is almost fully
protected(as noted above, by a global mutex) with one exception, it is:

static void kmem_cache_release(struct kmem_cache *s)
{
	if (slab_state >= FULL) {
		sysfs_slab_unlink(s);
		sysfs_slab_release(s);
	} else {
		slab_kmem_cache_release(s);
	}
}

this one can race, IMO.

--
Uladzislau Rezki

