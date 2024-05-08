Return-Path: <kvm+bounces-16975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E66B8BF68E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 08:51:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E22D01F23B9B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 06:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD92123778;
	Wed,  8 May 2024 06:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oCRkpmyZ"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D598B676
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 06:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715151068; cv=none; b=KFJWn65CNJB1hZxJcnQsVeTRND+jsUfj4FkObGOzzh2pq6gZ0S/ipmnnKlVlfQuyL4ELJLchO1Nd+Xxm6RbEbSstia/N63lG+gjRO0S00TbJyqtzDZhEk4tgG+Pfsbnj9eKPPrMB4vSnW+qERG6QGna7+Cdbwl2LQhWUAxtwnz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715151068; c=relaxed/simple;
	bh=8bQmpzzT2Shv5Hv9pfUqEnpSW0jt7HQwQMGOf0peGOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ocy9sPnTvwyo9rZ75x3ArxlbwY5Uu/ukqQJnSjQrAzqYV8R0DWAhQl3oZuiWWVPenfZaoRKrcU9MxB52V5K2UOLM+ICmZHirAwZi2HK/igHhOYHF4yTGAzvP7ZN0UtZHNeyuBztnlA9tbyNRbnFjszUgXD3QKMt1TmHL6KcAdP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oCRkpmyZ; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 8 May 2024 06:50:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715151062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YxLA1b2PsIvrj36vSYNi6Goor2y+iu8PxLKQalt/QBY=;
	b=oCRkpmyZTSal9OW2TWhENoGR17vt1zyalTCRa5SV3Y3ItUidYVmcUvzVaZ9q/8wooMx6hw
	UIWJZSh6lVmmoXEtjtKWLZVYR6UZ3JkAQrKIFdhpUv2NMTUQPIu0ejh6UpEsW5/P83yg7w
	ySax7N03+xXJ84IKCOZeLtJQLZCdGEU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Destroy mpidr_data for 'late' vCPU creation
Message-ID: <Zjsg0d8Li1vIgyk2@linux.dev>
References: <20240507192912.1096658-1-oliver.upton@linux.dev>
 <87h6f8zu1z.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6f8zu1z.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 08, 2024 at 07:39:20AM +0100, Marc Zyngier wrote:
> On Tue, 07 May 2024 20:29:12 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > A particularly annoying userspace could create a vCPU after KVM has
> > computed mpidr_data for the VM, either by racing against VGIC
> > initialization or having a userspace irqchip.
> > 
> > In any case, this means mpidr_data no longer fully describes the VM, and
> > attempts to find the new vCPU with kvm_mpidr_to_vcpu() will fail. The
> > fix is to discard mpidr_data altogether, as it is only a performance
> > optimization and not required for correctness. In all likelihood KVM
> > will recompute the mappings when KVM_RUN is called on the new vCPU.
> > 
> > Note that reads of mpidr_data are not guarded by a lock; promote to RCU
> > to cope with the possibility of mpidr_data being invalidated at runtime.
> > 
> > Fixes: 54a8006d0b49 ("KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available")
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/arm.c | 49 ++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 40 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c4a0a35e02c7..0d845131a0e0 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -195,6 +195,22 @@ void kvm_arch_create_vm_debugfs(struct kvm *kvm)
> >  	kvm_sys_regs_create_debugfs(kvm);
> >  }
> >  
> > +static void kvm_destroy_mpidr_data(struct kvm *kvm)
> > +{
> > +	struct kvm_mpidr_data *data;
> > +
> > +	mutex_lock(&kvm->arch.config_lock);
> > +
> > +	data = rcu_dereference_raw(kvm->arch.mpidr_data);
> 
> I'm slightly worried by this. Why can't we use the "cooked" version?
> If anything I'd like to see a comment about this, as it is usually
> frowned upon.

No reason other than my own laziness... This really should be:

	rcu_dereference_protected(kvm->arch.mpidr_data,
				  lockdep_is_held(&kvm->arch.config_lock));

since we're behind the update-side lock.

-- 
Thanks,
Oliver

