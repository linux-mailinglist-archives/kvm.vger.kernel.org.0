Return-Path: <kvm+bounces-24788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9797E95A334
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 18:52:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C6001F25625
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 16:52:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95441AF4E0;
	Wed, 21 Aug 2024 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hkdJH2X9"
X-Original-To: kvm@vger.kernel.org
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8EE15886A
	for <kvm@vger.kernel.org>; Wed, 21 Aug 2024 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724259163; cv=none; b=H5FRMjsmjHkCFLtWrzWS7al6I3le3KkIGEG/mDw/5T5ZQJaAJcwpqGHeTrPDiaHnuxg4/ZhNHNVmTxj5wVyNIdLUBKIUnOkxkql4ObKa7nFQ79hnG9MewkhUOJh0wcf3PFwgX3ebTNNUSAo+KkIp6vpX93tOwgIsi1CziFBEqkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724259163; c=relaxed/simple;
	bh=cjvjXhlB9flVKxb/cblakppl907aLEdm2vk5HrKBcvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3jg72iRjZXWsBG4KfgcyPsTxsWt75+Bkb+Ox4fP88icEG7CK4D2Yydrl+d8t5XeTD8rSsAAG9eYNAbNvX265FEBy3WbLxt+/JlM005sSViGB++SKy//uxYxFqt3fQjfM4NYD5rTCwHG/PPUkDLQwnV89MucgPNmt0KGu8zlgEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hkdJH2X9; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 21 Aug 2024 09:52:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724259157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RhkCn0ao6zdR20+7bDAZFdJNVPYbj05+LvI61+DYOno=;
	b=hkdJH2X91AdgM5+zOVDGLwr1HTzeTZ+2p/Sarj0/EpdGETIuqicK3PLbiV88vGem+y99BK
	/IlJ0jOrxwXdyJeL3xzUUwPnYJJrjahouXN9btym0vOpJyxeOcc576JwwwQHFbXRI5cN9C
	03rU7h1VL0q8tHMhgeR+4ODXUDAvF7I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH 04/12] KVM: arm64: Force GICv3 traps activa when no
 irqchip is configured on VHE
Message-ID: <ZsYbTAfH3lK7M1aU@linux.dev>
References: <20240820100349.3544850-1-maz@kernel.org>
 <20240820100349.3544850-5-maz@kernel.org>
 <ZsUn1E6Gytu40iOW@linux.dev>
 <86ikvuxh56.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikvuxh56.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Aug 21, 2024 at 12:13:57PM +0100, Marc Zyngier wrote:
> On Wed, 21 Aug 2024 00:33:40 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > s/activa/active/
> > 
> > On Tue, Aug 20, 2024 at 11:03:41AM +0100, Marc Zyngier wrote:
> > > On a VHE system, no GICv3 traps get configured when no irqchip is
> > > present. This is not quite matching the "no GICv3" semantics that
> > > we want to present.
> > > 
> > > Force such traps to be configured in this case.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/vgic/vgic.c | 14 ++++++++++----
> > >  1 file changed, 10 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
> > > index 974849ea7101..2caa64415ff3 100644
> > > --- a/arch/arm64/kvm/vgic/vgic.c
> > > +++ b/arch/arm64/kvm/vgic/vgic.c
> > > @@ -917,10 +917,13 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
> > >  
> > >  void kvm_vgic_load(struct kvm_vcpu *vcpu)
> > >  {
> > > -	if (unlikely(!vgic_initialized(vcpu->kvm)))
> > > +	if (unlikely(!irqchip_in_kernel(vcpu->kvm) || !vgic_initialized(vcpu->kvm))) {
> > 
> > Doesn't !vgic_initialized(vcpu->kvm) also cover the case of no irqchip
> > in kernel?
> 
> It does, but that's purely accidental. I can drop that, but it is
> really fragile.

Oh, definitely not, I was just wondering if this was meant as a
functional change or a readability change to make the relation explicit.

-- 
Thanks,
Oliver

