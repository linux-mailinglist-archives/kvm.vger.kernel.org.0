Return-Path: <kvm+bounces-6995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66CC683BD2E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 10:24:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A7DF1C236D9
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4E41BC5B;
	Thu, 25 Jan 2024 09:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hcC5ia3B"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2ED1B967
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 09:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706174680; cv=none; b=HwT6ISNc1RNA5kbEDD12Qt9t9Pz7UH6qjACm9vma0nhuH1bKf+H+eKUOqYRSctpousEgIvCftShu5CHjU9RlASiMfO61Jb0l6v1qVCCwwZw+m/A6aLqMNusoF2LRyl4Ahw9WUjwKBGd9YYQmn1RPCD0vCk9qk0P5nkrsSbr3aEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706174680; c=relaxed/simple;
	bh=vY5sRMOliK001sMMbtVh0bAfbEx8ErGOSVfyFlW2R5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VFZWxFhLuXY0/VVqfK5qenWLUFQcXQFiyyfLFlA0ExzzHqimg7mitlHOWKKl2F6UF8sfDb4DytCsq6/s4OWqY0KAe08oYy+yomdvkgHq5cgy5iRRkPsVrTg6XPfWgleZvxSlT/yYb2YHXHhbcxi6pMROw5qL1A3UqjwIhxl51pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hcC5ia3B; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 25 Jan 2024 09:24:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706174677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qiWAaEsyJHDQvgEjeYe4OWR5PcIvCedo9366UkORU0k=;
	b=hcC5ia3BMhp3v6Njy2s/RmGm+85fJAGudm0CgnWlG6iPUSQ3/p8eEgo1asJtGLS7W2L78C
	T/L+02/brYB1HpfRtoRMRXuPbMNeRRbA5ZhxSRKax3CVi+kB9iCbeYbJdOXSdl+rxTCfuk
	zf/jVWCg+J/aultGxG5jt6EdZftodjs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH 04/15] KVM: arm64: vgic-its: Walk the LPI xarray in
 vgic_copy_lpi_list()
Message-ID: <ZbIoz5x1gaGtIAq7@linux.dev>
References: <20240124204909.105952-1-oliver.upton@linux.dev>
 <20240124204909.105952-5-oliver.upton@linux.dev>
 <867cjx93kd.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867cjx93kd.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 25, 2024 at 09:15:30AM +0000, Marc Zyngier wrote:
> On Wed, 24 Jan 2024 20:48:58 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Start iterating the LPI xarray in anticipation of removing the LPI
> > linked-list.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index f152d670113f..a2d95a279798 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -332,6 +332,7 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> >  int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
> >  {
> >  	struct vgic_dist *dist = &kvm->arch.vgic;
> > +	XA_STATE(xas, &dist->lpi_xa, 0);
> 
> Why 0? LPIs start at 8192 (aka GIC_LPI_OFFSET), so it'd probably make
> sense to use that.

Just being lazy!

> >  	struct vgic_irq *irq;
> >  	unsigned long flags;
> >  	u32 *intids;
> > @@ -350,7 +351,9 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
> >  		return -ENOMEM;
> >  
> >  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> > -	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> > +	rcu_read_lock();
> > +
> > +	xas_for_each(&xas, irq, U32_MAX) {
> 
> Similar thing: we advertise 16 bits of ID space (described as
> INTERRUPT_ID_BITS_ITS), so capping at that level would make it more
> understandable.

See above. But completely agree, this is much more readable when it
matches the the actual ID space.

-- 
Thanks,
Oliver

