Return-Path: <kvm+bounces-19788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CCC90B438
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:27:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0D8C282707
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1822017BB7;
	Mon, 17 Jun 2024 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="clhRAdt9"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF4D51D;
	Mon, 17 Jun 2024 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718636189; cv=none; b=J3aDlsDSoS4wX/8rFtzuU+WKjM0oxrpGFaKQBJnYgEsGA+oXABAOr3d8g3z97arFysc7F3TU2K1i7Y3qsUcfxakqb9t+H7U0+MHgI77X3Ho3aXsNGvTOT6xKs3QDEthtH64d/1kGzLXXzZqQM2rSDFRQxm29Q2UULqvTIcYi7RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718636189; c=relaxed/simple;
	bh=1g98WIt6DK45Ckxrtdcr5vChfA+pfghexrdjwxiI8YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qr55YnDrBCJpQf2T8uN56HAEMFITZsJGSYO0W3Gh+7SJ6C6cbhJ6iU9ralQoa7qpmUEThezsS1AiUojlnCIAiI6fZby3OqW+7bzgP+j8NMrzXclCkp2uwIbm0EqtLAoj/gf5KBGogL0WlRajrDSiykuJgrqYGO3AnFXbXC0geuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=clhRAdt9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F573C2BD10;
	Mon, 17 Jun 2024 14:56:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="clhRAdt9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1718636183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6bcwrvbIl7+eEjyyGJoXxh1mehCsgFRYWHRM/zwpUAQ=;
	b=clhRAdt9QmHzMaEEzVai+8NS5mBwqdWC/f0sKn8iKNRjAYqBW9N3E2L8sbjmiy2SQkZGk0
	hK8NYQAMg8k+eCY6yhiOMg3Eok18XjHMRfrN68QDTwANHVK37YKOUoOk4GYwZc7KCjnUD+
	5Jm/fDnndt2OgFIS0O5m9q1UI47PGCA=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 071c720a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Mon, 17 Jun 2024 14:56:22 +0000 (UTC)
Date: Mon, 17 Jun 2024 16:56:17 +0200
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
Message-ID: <ZnBOkZClsvAUa_5X@zx2c4.com>
References: <80e03b02-7e24-4342-af0b-ba5117b19828@paulmck-laptop>
 <Zmru7hhz8kPDPsyz@pc636>
 <7efde25f-6af5-4a67-abea-b26732a8aca1@paulmck-laptop>
 <Zmsuswo8OPIhY5KJ@pc636>
 <cb51bc57-47b8-456a-9ac0-f8aa0931b144@paulmck-laptop>
 <ZmszOd5idhf2Cb-v@pc636>
 <b03b007f-3afa-4ad4-b76b-dea7b3aa2bc3@paulmck-laptop>
 <Zmw5FTX752g0vtlD@pc638.lan>
 <ZmybGZDbXkw7JTjc@zx2c4.com>
 <ZnA_QFvuyABnD3ZA@pc636>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZnA_QFvuyABnD3ZA@pc636>

On Mon, Jun 17, 2024 at 03:50:56PM +0200, Uladzislau Rezki wrote:
> On Fri, Jun 14, 2024 at 09:33:45PM +0200, Jason A. Donenfeld wrote:
> > On Fri, Jun 14, 2024 at 02:35:33PM +0200, Uladzislau Rezki wrote:
> > > +	/* Should a destroy process be deferred? */
> > > +	if (s->flags & SLAB_DEFER_DESTROY) {
> > > +		list_move_tail(&s->list, &slab_caches_defer_destroy);
> > > +		schedule_delayed_work(&slab_caches_defer_destroy_work, HZ);
> > > +		goto out_unlock;
> > > +	}
> > 
> > Wouldn't it be smoother to have the actual kmem_cache_free() function
> > check to see if it's been marked for destruction and the refcount is
> > zero, rather than polling every one second? I mentioned this approach
> > in: https://lore.kernel.org/all/Zmo9-YGraiCj5-MI@zx2c4.com/ -
> > 
> >     I wonder if the right fix to this would be adding a `should_destroy`
> >     boolean to kmem_cache, which kmem_cache_destroy() sets to true. And
> >     then right after it checks `if (number_of_allocations == 0)
> >     actually_destroy()`, and likewise on each kmem_cache_free(), it
> >     could check `if (should_destroy && number_of_allocations == 0)
> >     actually_destroy()`. 
> > 
> I do not find pooling as bad way we can go with. But your proposal
> sounds reasonable to me also. We can combine both "prototypes" to
> one and offer.
> 
> Can you post a prototype here?

This is untested, but the simplest, shortest possible version would be:

diff --git a/mm/slab.h b/mm/slab.h
index 5f8f47c5bee0..907c0ea56c01 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -275,6 +275,7 @@ struct kmem_cache {
 	unsigned int inuse;		/* Offset to metadata */
 	unsigned int align;		/* Alignment */
 	unsigned int red_left_pad;	/* Left redzone padding size */
+	bool is_destroyed;		/* Destruction happens when no objects */
 	const char *name;		/* Name (only for display!) */
 	struct list_head list;		/* List of slab caches */
 #ifdef CONFIG_SYSFS
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 1560a1546bb1..f700bed066d9 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -494,8 +494,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
 		goto out_unlock;

 	err = shutdown_cache(s);
-	WARN(err, "%s %s: Slab cache still has objects when called from %pS",
-	     __func__, s->name, (void *)_RET_IP_);
+	if (err)
+		s->is_destroyed = true;
 out_unlock:
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
diff --git a/mm/slub.c b/mm/slub.c
index 1373ac365a46..7db8fe90a323 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4510,6 +4510,8 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
 		return;
 	trace_kmem_cache_free(_RET_IP_, x, s);
 	slab_free(s, virt_to_slab(x), x, _RET_IP_);
+	if (s->is_destroyed)
+		kmem_cache_destroy(s);
 }
 EXPORT_SYMBOL(kmem_cache_free);

@@ -5342,9 +5344,6 @@ static void free_partial(struct kmem_cache *s, struct kmem_cache_node *n)
 		if (!slab->inuse) {
 			remove_partial(n, slab);
 			list_add(&slab->slab_list, &discard);
-		} else {
-			list_slab_objects(s, slab,
-			  "Objects remaining in %s on __kmem_cache_shutdown()");
 		}
 	}
 	spin_unlock_irq(&n->list_lock);


