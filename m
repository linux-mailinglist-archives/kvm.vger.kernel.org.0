Return-Path: <kvm+bounces-62864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DB631C5129C
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 09:46:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D75874ECB1E
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:45:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238832FCC12;
	Wed, 12 Nov 2025 08:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyMxGT/H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592E2FC873;
	Wed, 12 Nov 2025 08:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937150; cv=none; b=fYgkNN2/4POiSR5QSyWY1UBcqQGEZSmM7tvbdKNP5oiDGO1yBcLAfc/SSNtACahd1tlt6xBYFctYyOkctgFj43xstvuCAhGYat5/rg7wEKpXLu0dTTdjimeewy93gnD0pS3kCm2QF8AVLFpXEOpNL4/8PorY75jwKovv5Nsji2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937150; c=relaxed/simple;
	bh=3PpC23lXWHMZc/xqZ8AI6v/rV2TDMJJUIRhSuy6tr+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nj8+9ZpdUaypFtyT41jw9Fco2VwdOgHbZNRY7BOMA66TcLewQ03+lyfR5rsOx2aThks+fmJFSm2Gj+r5lWBUeEGOQJfW0N0Lfv14ce9aHWARYVLvuf6RNK3+glkTgwvqun8bMMET9WR8QtuKycm0xxNgWfWC1gEi+CVZWsAasfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyMxGT/H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8BEC4CEF7;
	Wed, 12 Nov 2025 08:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762937146;
	bh=3PpC23lXWHMZc/xqZ8AI6v/rV2TDMJJUIRhSuy6tr+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyMxGT/HHav6pdcoZJe2w68jZ+BllzlUulSSnAFhC6j02cdmGIa6ljPeDogIuN6XR
	 xhLX/yJwi6pJBkqwM83lBtGiHUOPiA30EJ0qwUtS7Nyqr93Fcai3jYJ0ka23jKxlb+
	 MQJfYJlUGv+r9aild/gH4M3IRHMzB5OSH+31GPo7UPMwXoEkNZc1Gdlsyh00FmBWHl
	 I5dNhWL6hsS1AhaZ9ZJn2Xi10rtsUVD3qvUIjO30+IJgK81FQ2FCtDDPd5LKdOGPed
	 CkqIr6cMqr9rr30BORWUr9CFJA3YIl4HsbxqOT31AOgWiysacpegcIy+Bgrq9fcF6v
	 2TS3igp6FMojg==
Date: Wed, 12 Nov 2025 00:45:45 -0800
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: Re: [PATCH v2 20/45] KVM: arm64: Revamp vgic maintenance interrupt
 configuration
Message-ID: <aRRJOSNnvD1B0ZfJ@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
 <20251109171619.1507205-21-maz@kernel.org>
 <aRPQBQVPLVXGOxU-@kernel.org>
 <86y0obtzt9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86y0obtzt9.wl-maz@kernel.org>

On Wed, Nov 12, 2025 at 08:33:54AM +0000, Marc Zyngier wrote:
> On Wed, 12 Nov 2025 00:08:37 +0000,
> Oliver Upton <oupton@kernel.org> wrote:
> > 
> > On Sun, Nov 09, 2025 at 05:15:54PM +0000, Marc Zyngier wrote:
> > > +static void summarize_ap_list(struct kvm_vcpu *vcpu,
> > > +			      struct ap_list_summary *als)
> > >  {
> > >  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> > >  	struct vgic_irq *irq;
> > > -	int count = 0;
> > > -
> > > -	*multi_sgi = false;
> > >  
> > >  	lockdep_assert_held(&vgic_cpu->ap_list_lock);
> > >  
> > > -	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> > > -		int w;
> > > +	*als = (typeof(*als)){};
> > >  
> > > -		raw_spin_lock(&irq->irq_lock);
> > > -		/* GICv2 SGIs can count for more than one... */
> > > -		w = vgic_irq_get_lr_count(irq);
> > > -		raw_spin_unlock(&irq->irq_lock);
> > > +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> > > +		scoped_guard(raw_spinlock, &irq->irq_lock) {
> > > +			if (vgic_target_oracle(irq) != vcpu)
> > > +				continue;
> > 
> > From our conversation about this sort of thing a few weeks ago, wont
> > this 'continue' interact pooly with the for loop that scoped_guard()
> > expands to?
> 
> Gahhh... I was sure I had killed that everywhere, but obviously failed
> to. I wish there was a coccinelle script to detect this sort of broken
> constructs (where are the script kiddies when you really need them?).
> 
> Thanks for spotting it!
> 
> > Consistent with the other checks against the destination oracle you'll
> > probably want a branch hint too.
> 
> Yup, I'll add that.

I can take care of it when applying. These patches need to bake :)

Thanks,
Oliver

