Return-Path: <kvm+bounces-9221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 458A085C230
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 18:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC54CB219DF
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2263876C6C;
	Tue, 20 Feb 2024 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PhLbGwRx"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3C5626C6
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708449363; cv=none; b=u0lhMo4Qc4SbIfnLyEfYShd4KOXMIF4FU3MfuO66W80P/OcaBG32A77RGJ9204l4mB7TABGt+ARFRqx9Vop18WlBmMFggWChYM9u1kf0NXV9XObG8fdaCGyyZlhSDobewNsltEpTvzKBINu6kSkUsC9Gb5D6WFaK3vdQ6ynKczY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708449363; c=relaxed/simple;
	bh=FhliDVkysklF15PfPRnCqEJZYnFpC1xmT61LBc+B6yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxtfQeJK5DE3M4AZRvnRyn2Kk99wzUudmjoGRR/5PDxZAHr0h9BOuOt9pxUuNrHo1fsNS7CTsvpRLh5C0uoALkC/D5zZGaUUB+XmdRPvJou742rstOun1aGanv/RO1MbgSYCthJQWTWtaiIVzrk+8etLSLF8Umxh6dKAOtzjhL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PhLbGwRx; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 20 Feb 2024 17:15:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708449359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FuuwmqpCQpWAXNTzSXOVhd7IRRo2+InjCoLO7UA0d9k=;
	b=PhLbGwRxlT+KuFz6tNw+qZd6Cv2esxSF9tj4+tBVdOBC/t2uIBnFQ32R5S3fpIj9zwDMM4
	5EFbyhwJoTMDNouP+8qkoudMbS4tZh82lt0y+8FdzXwuNk4n1Ivu0bT7rH0CElsoD8A/3U
	SQrrw1LoLkxSGmCEGsLKUs91+vdn6jI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/10] KVM: arm64: vgic: Store LPIs in an xarray
Message-ID: <ZdTeScN3XCgtRDJ9@linux.dev>
References: <20240216184153.2714504-1-oliver.upton@linux.dev>
 <20240216184153.2714504-2-oliver.upton@linux.dev>
 <f6a4587c-1db1-d477-5e6c-93dd603a11ec@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6a4587c-1db1-d477-5e6c-93dd603a11ec@linux.dev>
X-Migadu-Flow: FLOW_OUT

Hi Zenghui,

On Wed, Feb 21, 2024 at 12:30:24AM +0800, Zenghui Yu wrote:
> On 2024/2/17 02:41, Oliver Upton wrote:
> > Using a linked-list for LPIs is less than ideal as it of course requires
> > iterative searches to find a particular entry. An xarray is a better
> > data structure for this use case, as it provides faster searches and can
> > still handle a potentially sparse range of INTID allocations.
> > 
> > Start by storing LPIs in an xarray, punting usage of the xarray to a
> > subsequent change.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> 
> [..]
> 
> > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > index db2a95762b1b..c126014f8395 100644
> > --- a/arch/arm64/kvm/vgic/vgic.c
> > +++ b/arch/arm64/kvm/vgic/vgic.c
> > @@ -131,6 +131,7 @@ void __vgic_put_lpi_locked(struct kvm *kvm, struct vgic_irq *irq)
> >  		return;
> >  	list_del(&irq->lpi_list);
> > +	xa_erase(&dist->lpi_xa, irq->intid);
> 
> We can get here *after* grabbing the vgic_cpu->ap_list_lock (e.g.,
> vgic_flush_pending_lpis()/vgic_put_irq()).  And as according to vGIC's
> "Locking order", we should disable interrupts before taking the xa_lock
> in xa_erase() and we would otherwise see bad things like deadlock..

Nice catch!

Yeah, the general intention was to disable interrupts outside of the
xa_lock, however:

> It's not a problem before patch #10, where we drop the lpi_list_lock and
> start taking the xa_lock with interrupts enabled.  Consider switching to
> use xa_erase_irq() instead?

I don't think this change is safe until #10, as the implied xa_unlock_irq()
would re-enable interrupts before the lpi_list_lock is dropped. Or do I
have wires crossed?

-- 
Thanks,
Oliver

