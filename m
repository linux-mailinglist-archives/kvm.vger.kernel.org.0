Return-Path: <kvm+bounces-7017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AB383C639
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:14:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D80A295ACF
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 15:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BEF36E2DC;
	Thu, 25 Jan 2024 15:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aE3n7dXC"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B077B63417
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706195598; cv=none; b=fF9jCfizw84i1AScqCuoHs0/GctLIONioYvE9OqsVc8fBoyuWX7ISMgz/B5R/5q6wTFo7qrNDN+4ZtWc0GjhgsBCqd4mJK7czRUlEVwoX+w2OPGBMCvKV2uXc8UPia7U+pZ2i6Pgw5I+9Pg0A3lixMcOIpdf3fk+egcImffEoWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706195598; c=relaxed/simple;
	bh=ro3FmJ2O8VVpiYZrhdmuvRyQqm7SV+s8gnBJ1Eq/p/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HuvVUnFr4dn+ejpdpGAJfFIJd8KH7zm0f48kPy+3bI+mYzkpimepvNdKGwG33AwQcTNlmLLmiODozmWIWLt5ct4fOy4diXL0rVeX0bQxnWAYbTzltZZXH3nTiT0aXSEYghones6LnbKAvnpyaKSPjHCx5uI+4lolQGnurqufQjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aE3n7dXC; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 25 Jan 2024 15:13:10 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706195594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G1bfoKcZ9bG6agzbcx0Gui5Hfgvy3MAQcV45CEUfOiU=;
	b=aE3n7dXC2DSIJu8gT7rlJi+diIT2OJGMzaD80D7EH74A5RW6g98w42uE+2q8scET7ivuV+
	dEcMAjqzKBxtF+WUCqdEjU7SwlvmxPc2Lk6HyTpOHy+fuswItZRqDxCuYm1oaUFMAROxK+
	cuhSlNXkKXbQE/KleWncZN6zfWj0Cgc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 11/15] KVM: arm64: vgic-its: Lazily allocate LPI
 translation cache
Message-ID: <ZbJ6hvr8rKFllW1e@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
 <20240124204909.105952-12-oliver.upton@linux.dev>
 <8634ul90l9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634ul90l9.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 25, 2024 at 10:19:46AM +0000, Marc Zyngier wrote:
> On Wed, 24 Jan 2024 20:49:05 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > +
> > +	/*
> > +	 * Caching the translation implies having an extra reference
> > +	 * to the interrupt, so drop the potential reference on what
> > +	 * was in the cache, and increment it on the new interrupt.
> > +	 */
> > +	if (victim && victim->irq)
> > +		vgic_put_irq(kvm, victim->irq);
> 
> The games you play with 'victim' are a bit odd. I'd rather have it
> initialised to NULL, and be trusted to have a valid irq if non-NULL.
> 
> Is there something special I'm missing?

I pulled some shenanigans use the same cleanup path to free the new
cache entry in the case of a race. At that point the new cache entry
is initialized to 0 and doesn't have a valid pointer to an irq.

I thought this was a fun trick, but in retrospect it just makes it hard
to follow. I'll just explicitly free the new entry in the case of a
detected race and do away with the weirdness.

-- 
Thanks,
Oliver

