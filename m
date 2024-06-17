Return-Path: <kvm+bounces-19814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE27790B9ED
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 20:42:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C66101C23BCE
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 18:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52274198E6D;
	Mon, 17 Jun 2024 18:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SwLOWmne"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17D415ECDB;
	Mon, 17 Jun 2024 18:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718649736; cv=none; b=ipdEG2MxfBH6ah1tHJPzW4+x174hnF6XZy+akdDZxFjy3duwQCT/lmV5KBdPVza/nFUfMggVhqCZqN5DN4KxofVnJlWzzBDmopsCLCRtAEm1cfyVtSNZ0yuTv+FMtaGnB9HjqXbczpFQt/S91Mvv40Q45O9C7w06C4REgs0Ugfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718649736; c=relaxed/simple;
	bh=Flz2Pil2geTTJPxA2CBnOZsQd4N0qDIllekhZBSDWlc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C3HPX2fyS78d7CFkJbjv3pvVSbLkc9v0zy07nUrrIG5ZJdFVohZKmQg3ppmlSj2G2TtXzL97/T5ZvwKwKUb7DCYIEcvI1YSi/z70u5ihmqkLp4YQ1Z4UCgoXLkRTQiBjA3dHX4y2jq1kNPwpV7saWPUFmw5KGA1uagE4nOb51EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SwLOWmne; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52bc29c79fdso6411089e87.1;
        Mon, 17 Jun 2024 11:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718649733; x=1719254533; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+jO2FlPNmcOLf+hC3upZKg3SDI4/5kwrnW8GkxW5YVg=;
        b=SwLOWmnegBDu0JkvO8Nk44GF2tkUWJquyl78o3MaKsdamsvDPkuile/bqycsEgFeF7
         8s33oHaK6l/o743r8T5vismpctgIlDtjjllhCfzevHkT+v+hfpf4ZwQNnlWOHYdOCaIk
         xK+w8r94y3an1iV5Stw7kumo8GZ7uLcBfrLQTHxbRTtZ8hP8KcKCSc9bXUuwZykj86ME
         x69lW4t7agK2tRS0aZhqHAlf0AcG5fWl7W6/xJDv0Yc3P7fILbomIs13vHnECCpCfWnM
         jRa/hXtYC5cYMbixNz2uaJyEiiS49XVkqe9pC9L0qoZQcc4CnAZg2PzexSiYEsFER4Pz
         Zbjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718649733; x=1719254533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jO2FlPNmcOLf+hC3upZKg3SDI4/5kwrnW8GkxW5YVg=;
        b=r3s+YBbYVCO1EXoT35oXlqzer01navZiyQ8ZKgXuh5Dvu2NaMzoGPcIbVkyhuMxY81
         te72gjyDM0a3Y6SD21PH+tC5PBVK2z1scxiueUAPYnXKnK4xIW1nnHmqJM+Whgzeg/Qq
         e1q1gMvzV8MYF3latzb+6758KqPKJ0Mcr2AodbqJUEYe1ZpjXlRuiGjASO1xb5wV8bsI
         jWcKrDXIPaMYObErrIMb6t6A7isZ2hGBCOE7PqED7uj2sBZKmf3SI2WcJuT8SFArN5qU
         4B1MSVtzK6SvXZV7WOrePmGOEu8OPACy1oZoReF6q9KCwjkNeATEzvGBrdywZW3qz1bN
         5rNg==
X-Forwarded-Encrypted: i=1; AJvYcCVBIoYHB9zvqJj4LsEW2GeviCD5HM88aqJbhuk47uLFXWV9FivIwO6Y5hRIr2Pimuh/QSQ55rvni9Np4X6kzm4wjbq+9SEl92AeLUb9bVIXW67DdTudWrJRre01EQ5Yx3IVwVtndrMEpc3uir/incEz9Qv0vhsVf73sxDC0IeRKnItKYpN76lzxTy8ZpxKGo6Ngkulb2IrgN5LBWEizXOgrp3xovPWWtF77qezmnjDxPFaws/stttvTlJQxoJXPmYvCitoTsL9SCH7LQbi7cImAeHuGTsiP9vJoxh++axXZWGZ9zygTOgTfG6uvnc3vG1CPGuzY1LhhVtQCMon4h2Fs+wtadwid4j3O//wbZhLTWURZ99MWaUPqAaRmOhZwRlByMN1dO/HArmpSudpMX/511257pJID0mUKXB7r/pdfGBBNhOQ/+rYHjOwisQ==
X-Gm-Message-State: AOJu0YwVFGEmtLJjAKw5bzc7E2Lo58Cs6RtBmVGcfv1YkiQzcDnHEZkj
	llZs4TMim1bpGZhR6H/p9hq/cumeC3MuulPqnANwthc9DKr4A425
X-Google-Smtp-Source: AGHT+IG+He9esutTE4DcK6Uo+MkQ9CT1wI+N+kkdrm92KSfS1cK189MGjfkb18QFb85ZwtxeC6GLJw==
X-Received: by 2002:a05:6512:549:b0:521:cc8a:46dd with SMTP id 2adb3069b0e04-52ca6e56e2dmr7855127e87.11.1718649732281;
        Mon, 17 Jun 2024 11:42:12 -0700 (PDT)
Received: from pc636 (host-185-121-47-193.sydskane.nu. [185.121.47.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56db6182sm540019666b.51.2024.06.17.11.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 11:42:11 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 17 Jun 2024 20:42:09 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: paulmck@kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
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
Message-ID: <ZnCDgdg1EH6V7w5d@pc636>
References: <20240609082726.32742-1-Julia.Lawall@inria.fr>
 <20240612143305.451abf58@kernel.org>
 <baee4d58-17b4-4918-8e45-4d8068a23e8c@paulmck-laptop>
 <Zmov7ZaL-54T9GiM@zx2c4.com>
 <Zmo9-YGraiCj5-MI@zx2c4.com>
 <08ee7eb2-8d08-4f1f-9c46-495a544b8c0e@paulmck-laptop>
 <Zmrkkel0Fo4_g75a@zx2c4.com>
 <e926e3c6-05ce-4ba6-9e2e-e5f3b37bcc23@suse.cz>
 <3b6fe525-626c-41fb-8625-3925ca820d8e@paulmck-laptop>
 <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6711935d-20b5-41c1-8864-db3fc7d7823d@suse.cz>

On Mon, Jun 17, 2024 at 07:23:36PM +0200, Vlastimil Babka wrote:
> On 6/17/24 6:12 PM, Paul E. McKenney wrote:
> > On Mon, Jun 17, 2024 at 05:10:50PM +0200, Vlastimil Babka wrote:
> >> On 6/13/24 2:22 PM, Jason A. Donenfeld wrote:
> >> > On Wed, Jun 12, 2024 at 08:38:02PM -0700, Paul E. McKenney wrote:
> >> >> o	Make the current kmem_cache_destroy() asynchronously wait for
> >> >> 	all memory to be returned, then complete the destruction.
> >> >> 	(This gets rid of a valuable debugging technique because
> >> >> 	in normal use, it is a bug to attempt to destroy a kmem_cache
> >> >> 	that has objects still allocated.)
> >> 
> >> This seems like the best option to me. As Jason already said, the debugging
> >> technique is not affected significantly, if the warning just occurs
> >> asynchronously later. The module can be already unloaded at that point, as
> >> the leak is never checked programatically anyway to control further
> >> execution, it's just a splat in dmesg.
> > 
> > Works for me!
> 
> Great. So this is how a prototype could look like, hopefully? The kunit test
> does generate the splat for me, which should be because the rcu_barrier() in
> the implementation (marked to be replaced with the real thing) is really
> insufficient. Note the test itself passes as this kind of error isn't wired
> up properly.
> 
> Another thing to resolve is the marked comment about kasan_shutdown() with
> potential kfree_rcu()'s in flight.
> 
> Also you need CONFIG_SLUB_DEBUG enabled otherwise node_nr_slabs() is a no-op
> and it might fail to notice the pending slabs. This will need to change.
> 
> ----8<----
> diff --git a/lib/slub_kunit.c b/lib/slub_kunit.c
> index e6667a28c014..e3e4d0ca40b7 100644
> --- a/lib/slub_kunit.c
> +++ b/lib/slub_kunit.c
> @@ -5,6 +5,7 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/rcupdate.h>
>  #include "../mm/slab.h"
>  
>  static struct kunit_resource resource;
> @@ -157,6 +158,26 @@ static void test_kmalloc_redzone_access(struct kunit *test)
>  	kmem_cache_destroy(s);
>  }
>  
> +struct test_kfree_rcu_struct {
> +	struct rcu_head rcu;
> +};
> +
> +static void test_kfree_rcu(struct kunit *test)
> +{
> +	struct kmem_cache *s = test_kmem_cache_create("TestSlub_kfree_rcu",
> +				sizeof(struct test_kfree_rcu_struct),
> +				SLAB_NO_MERGE);
> +	struct test_kfree_rcu_struct *p = kmem_cache_alloc(s, GFP_KERNEL);
> +
> +	kasan_disable_current();
> +
> +	KUNIT_EXPECT_EQ(test, 0, slab_errors);
> +
> +	kasan_enable_current();
> +	kfree_rcu(p, rcu);
> +	kmem_cache_destroy(s);
> +}
> +
>  static int test_init(struct kunit *test)
>  {
>  	slab_errors = 0;
> @@ -177,6 +198,7 @@ static struct kunit_case test_cases[] = {
>  
>  	KUNIT_CASE(test_clobber_redzone_free),
>  	KUNIT_CASE(test_kmalloc_redzone_access),
> +	KUNIT_CASE(test_kfree_rcu),
>  	{}
>  };
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index b16e63191578..a0295600af92 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -277,6 +277,8 @@ struct kmem_cache {
>  	unsigned int red_left_pad;	/* Left redzone padding size */
>  	const char *name;		/* Name (only for display!) */
>  	struct list_head list;		/* List of slab caches */
> +	struct work_struct async_destroy_work;
> +
>  #ifdef CONFIG_SYSFS
>  	struct kobject kobj;		/* For sysfs */
>  #endif
> @@ -474,7 +476,7 @@ static inline bool is_kmalloc_cache(struct kmem_cache *s)
>  			      SLAB_NO_USER_FLAGS)
>  
>  bool __kmem_cache_empty(struct kmem_cache *);
> -int __kmem_cache_shutdown(struct kmem_cache *);
> +int __kmem_cache_shutdown(struct kmem_cache *, bool);
>  void __kmem_cache_release(struct kmem_cache *);
>  int __kmem_cache_shrink(struct kmem_cache *);
>  void slab_kmem_cache_release(struct kmem_cache *);
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 5b1f996bed06..c5c356d0235d 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -44,6 +44,8 @@ static LIST_HEAD(slab_caches_to_rcu_destroy);
>  static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work);
>  static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
>  		    slab_caches_to_rcu_destroy_workfn);
> +static void kmem_cache_kfree_rcu_destroy_workfn(struct work_struct *work);
> +
>  
>  /*
>   * Set of flags that will prevent slab merging
> @@ -234,6 +236,7 @@ static struct kmem_cache *create_cache(const char *name,
>  
>  	s->refcount = 1;
>  	list_add(&s->list, &slab_caches);
> +	INIT_WORK(&s->async_destroy_work, kmem_cache_kfree_rcu_destroy_workfn);
>  	return s;
>  
>  out_free_cache:
> @@ -449,12 +452,16 @@ static void slab_caches_to_rcu_destroy_workfn(struct work_struct *work)
>  	}
>  }
>  
> -static int shutdown_cache(struct kmem_cache *s)
> +static int shutdown_cache(struct kmem_cache *s, bool warn_inuse)
>  {
>  	/* free asan quarantined objects */
> +	/*
> +	 * XXX: is it ok to call this multiple times? and what happens with a
> +	 * kfree_rcu() in flight that finishes after or in parallel with this?
> +	 */
>  	kasan_cache_shutdown(s);
>  
> -	if (__kmem_cache_shutdown(s) != 0)
> +	if (__kmem_cache_shutdown(s, warn_inuse) != 0)
>  		return -EBUSY;
>  
>  	list_del(&s->list);
> @@ -477,6 +484,32 @@ void slab_kmem_cache_release(struct kmem_cache *s)
>  	kmem_cache_free(kmem_cache, s);
>  }
>  
> +static void kmem_cache_kfree_rcu_destroy_workfn(struct work_struct *work)
> +{
> +	struct kmem_cache *s;
> +	int err = -EBUSY;
> +	bool rcu_set;
> +
> +	s = container_of(work, struct kmem_cache, async_destroy_work);
> +
> +	// XXX use the real kmem_cache_free_barrier() or similar thing here
It implies that we need to introduce kfree_rcu_barrier(), a new API, which i
wanted to avoid initially. Since you do it asynchronous can we just repeat
and wait until it a cache is furry freed?

I am asking because inventing a new kfree_rcu_barrier() might not be so
straight forward.

--
Uladzislau Rezki

