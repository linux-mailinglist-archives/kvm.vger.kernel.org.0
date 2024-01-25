Return-Path: <kvm+bounces-7020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C1383C6C9
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:34:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E946F1F22023
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 15:34:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56E477316D;
	Thu, 25 Jan 2024 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rkkBeBFq"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C4A6EB71
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 15:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706196880; cv=none; b=hHp/fyK/KPHS3qOBWr2vFl52qyaTixnsyg2o9H4isEIeKKoW24wZ2SX1AlyDKJSTu0bMDdLpLPd5LvkUyv03M4MpEx0ZASuVBXnWU06PFt/yrHLTBtxbFAN06UCNqEbejg5hoEdXZvuaJ3DLxfQqRpKyKdm5ON378CYdSe8pkYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706196880; c=relaxed/simple;
	bh=N9SIOM9LI+59wt2sYvd/8utU150nlmQFsnLLCY3O7MM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYzCucaPhXyJqJGDUU6W5ASjDH+RPpusEalUu2OpupqFxFbRes91S7aZ1YUvtQ+4tA1bbQxmRg0HnnjRS4byFSwE8FYr1Am5BEtV+lAtGb5xCXdDRbJGSj+leO3gerFlkkPWSh73MdbmuKmfexhinUEtmjPQqIApuKyAtgqT4Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rkkBeBFq; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 25 Jan 2024 15:34:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706196875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VtDAmOrZY4Bx+Tsgzo/1O7l/sBnHyINDVYGufCEohmQ=;
	b=rkkBeBFqLH2kWFQIs78U50g1WVIkEkR/Op14SsDRTRQ/ZkJkjrrHAGmctrIjOYw7oFfQmx
	S9Em/TsZWXHCtMX5/ZijBy0nVvjF6uca9d/KvFRXJHJUSiH/30STDIHysvqj/gGLjJZcSD
	BqNOPln/4bK3PByNMIh9ikf1+4zUrTM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 12/15] KVM: arm64: vgic-its: Pick cache victim based on
 usage count
Message-ID: <ZbJ_h7s9W1J7wy-B@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
 <20240124204909.105952-13-oliver.upton@linux.dev>
 <861qa58yy0.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861qa58yy0.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 25, 2024 at 10:55:19AM +0000, Marc Zyngier wrote:
> On Wed, 24 Jan 2024 20:49:06 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:

[...]

> > +static struct vgic_translation_cache_entry *vgic_its_cache_victim(struct vgic_dist *dist)
> > +{
> > +	struct vgic_translation_cache_entry *cte, *victim = NULL;
> > +	u64 min, tmp;
> > +
> > +	/*
> > +	 * Find the least used cache entry since the last cache miss, preferring
> > +	 * older entries in the case of a tie. Note that usage accounting is
> > +	 * deliberately non-atomic, so this is all best-effort.
> > +	 */
> > +	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
> > +		if (!cte->irq)
> > +			return cte;
> > +
> > +		tmp = atomic64_xchg_relaxed(&cte->usage_count, 0);
> > +		if (!victim || tmp <= min) {
> 
> min is not initialised until after the first round. Not great. How
> comes the compiler doesn't spot this?

min never gets read on the first iteration, since victim is known to be
NULL. Happy to initialize it though to keep this more ovbviously sane.

> > +			victim = cte;
> > +			min = tmp;
> > +		}
> > +	}
> 
> So this resets all the counters on each search for a new insertion?
> Seems expensive, specially on large VMs (512 * 16 = up to 8K SWP
> instructions in a tight loop, and I'm not even mentioning the fun
> without LSE). I can at least think of a box that will throw its
> interconnect out of the pram it tickled that way.

Well, each cache eviction after we hit the cache limit. I wrote this up
to have _something_ that allowed the rculist conversion to later come
back to rework futher, but that obviously didn't happen.

> I'd rather the new cache entry inherits the max of the current set,
> making it a lot cheaper. We can always detect the overflow and do a
> full invalidation in that case (worse case -- better options exist).

Yeah, I like your suggested approach. I'll probably build a bit on top
of that.

> > +
> > +	return victim;
> > +}
> > +
> >  static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> >  				       u32 devid, u32 eventid,
> >  				       struct vgic_irq *irq)
> > @@ -645,9 +664,12 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> >  		goto out;
> >  
> >  	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
> > -		/* Always reuse the last entry (LRU policy) */
> > -		victim = list_last_entry(&dist->lpi_translation_cache,
> > -				      typeof(*cte), entry);
> > +		victim = vgic_its_cache_victim(dist);
> > +		if (WARN_ON_ONCE(!victim)) {
> > +			victim = new;
> > +			goto out;
> > +		}
>
> I don't understand how this could happen. It sort of explains the
> oddity I was mentioning earlier, but I don't think we need this
> complexity.

The only way it could actually happen is if a bug were introduced where
lpi_cache_count is somehow nonzero but the list is empty. But yeah, we
can dump this and assume we find a victim, which ought to always be
true.

-- 
Thanks,
Oliver

